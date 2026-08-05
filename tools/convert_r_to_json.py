import re, json, sys

def extract_balanced(text, start_idx):
    """Given text and index right after the opening '(', return the substring
    up to (not including) the matching ')' and the index just after that ')'."""
    depth = 1
    i = start_idx
    in_str = False
    str_char = None
    while i < len(text):
        ch = text[i]
        if in_str:
            if ch == '\\':
                i += 2
                continue
            if ch == str_char:
                in_str = False
            i += 1
            continue
        else:
            if ch == '"' or ch == "'":
                in_str = True
                str_char = ch
            elif ch == '(':
                depth += 1
            elif ch == ')':
                depth -= 1
                if depth == 0:
                    return text[start_idx:i], i + 1
        i += 1
    raise ValueError("unbalanced")

def get_statement(src, varname):
    m = re.search(re.escape(varname) + r'\s*<-\s*(\w+)\s*\(', src)
    if not m:
        raise ValueError("not found: " + varname)
    func = m.group(1)
    start = m.end()
    body, end = extract_balanced(src, start)
    return func, body

# ---------- Tokenizer ----------
TOKEN_RE = re.compile(r'''
    (?P<STRING>"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*')
  | (?P<NUMBER>\d+\.\d+|\d+)
  | (?P<IDENT>[A-Za-z_.][A-Za-z0-9_.]*)
  | (?P<LPAREN>\()
  | (?P<RPAREN>\))
  | (?P<COMMA>,)
  | (?P<EQUALS>=)
  | (?P<SKIP>\s+|\#[^\n]*)
''', re.VERBOSE)

def tokenize(s):
    tokens = []
    pos = 0
    while pos < len(s):
        m = TOKEN_RE.match(s, pos)
        if not m:
            raise ValueError("bad token at " + s[pos:pos+30])
        kind = m.lastgroup
        val = m.group()
        if kind != 'SKIP':
            tokens.append((kind, val))
        pos = m.end()
    return tokens

def decode_r_string(tok):
    quote = tok[0]
    inner = tok[1:-1]
    out = []
    i = 0
    while i < len(inner):
        c = inner[i]
        if c == '\\':
            nxt = inner[i+1]
            if nxt == 'u':
                hexpart = inner[i+2:i+6]
                out.append(chr(int(hexpart, 16)))
                i += 6
                continue
            elif nxt == 'n':
                out.append('\n'); i += 2; continue
            elif nxt == 't':
                out.append('\t'); i += 2; continue
            elif nxt in ('"', "'", '\\'):
                out.append(nxt); i += 2; continue
            else:
                out.append(nxt); i += 2; continue
        else:
            out.append(c); i += 1
    return ''.join(out)

class Parser:
    def __init__(self, tokens, env=None):
        self.toks = tokens
        self.i = 0
        self.env = env or {}
    def peek(self):
        return self.toks[self.i] if self.i < len(self.toks) else (None, None)
    def next(self):
        t = self.toks[self.i]
        self.i += 1
        return t
    def parse_expr(self):
        kind, val = self.peek()
        if kind == 'STRING':
            self.next()
            return decode_r_string(val)
        if kind == 'NUMBER':
            self.next()
            return float(val) if '.' in val else int(val)
        if kind == 'IDENT':
            if val == 'NULL':
                self.next(); return None
            if val == 'TRUE':
                self.next(); return True
            if val == 'FALSE':
                self.next(); return True if False else False
            # function call
            name = val
            self.next()
            k2, v2 = self.peek()
            if k2 == 'LPAREN':
                self.next()
                args = self.parse_args()
                k3, v3 = self.next()
                assert k3 == 'RPAREN'
                return self.eval_call(name, args)
            else:
                if name in self.env:
                    return self.env[name]
                return name  # bare identifier, unresolved
        raise ValueError("unexpected token: %r %r" % (kind, val))
    def parse_args(self):
        args = []
        k, v = self.peek()
        if k == 'RPAREN':
            return args
        while True:
            k, v = self.peek()
            name = None
            if k == 'IDENT':
                # lookahead for '=' (but not '==')
                save = self.i
                ident = v
                self.next()
                k2, v2 = self.peek()
                if k2 == 'EQUALS':
                    self.next()
                    name = ident
                    val = self.parse_expr()
                    args.append((name, val))
                else:
                    self.i = save
                    val = self.parse_expr()
                    args.append((None, val))
            else:
                val = self.parse_expr()
                args.append((None, val))
            k, v = self.peek()
            if k == 'COMMA':
                self.next()
                continue
            else:
                break
        return args
    def eval_call(self, name, args):
        if name == 'c':
            vals = [v for (n, v) in args]
            # flatten one level if nested c() lists
            flat = []
            for v in vals:
                if isinstance(v, list):
                    flat.extend(v)
                else:
                    flat.append(v)
            return flat
        if name == 'list':
            if all(n is not None for n, v in args) and len(args) > 0:
                return {n: v for n, v in args}
            elif len(args) == 0:
                return {}
            else:
                # mixed - shouldn't happen in our data; build dict, fallback index for unnamed
                d = {}
                for idx, (n, v) in enumerate(args):
                    d[n if n else f"_{idx}"] = v
                return d
        if name == 'rep':
            val = args[0][1]
            n = args[1][1]
            return [val] * int(n)
        if name == 'data.frame':
            kv = [(n, v) for n, v in args if n != 'stringsAsFactors']
            maxlen = 1
            for n, v in kv:
                if isinstance(v, list):
                    maxlen = max(maxlen, len(v))
            rows = []
            for i in range(maxlen):
                row = {}
                for n, v in kv:
                    if isinstance(v, list):
                        row[n] = v[i % len(v)]
                    else:
                        row[n] = v
                rows.append(row)
            return rows
        if name == 'rbind':
            rows = []
            for n, v in args:
                rows.extend(v)
            return rows
        if name in ('setNames', 'sapply', 'names', 'paste0', 'sort', 'unique', 'interactive', 'cat', 'nrow', 'length'):
            # not needed for data extraction
            return None
        raise ValueError("unknown function: " + name)

def parse_r_value(func, body, env=None):
    tokens = tokenize(body)
    p = Parser(tokens, env=env)
    args = p.parse_args()
    return p.eval_call(func, args)

ASSIGN_RE = re.compile(r'(?m)^(?P<var>[A-Za-z_][A-Za-z0-9_.]*)\s*<-\s*(?P<func>[A-Za-z_.][A-Za-z0-9_.]*)\s*\(')

def eval_all_assignments(src, env=None):
    env = env or {}
    pos = 0
    while True:
        m = ASSIGN_RE.search(src, pos)
        if not m:
            break
        var, func = m.group('var'), m.group('func')
        start = m.end()
        try:
            body, end = extract_balanced(src, start)
        except ValueError:
            pos = m.end()
            continue
        try:
            val = parse_r_value(func, body, env=env)
            env[var] = val
        except Exception as e:
            pass  # skip non-data statements (functions, ui defs, etc.)
        pos = end
    return env

if __name__ == '__main__':
    import os
    # Looks for app.R / schemes_data.R next to this script (tools/source_r/)
    # first, then falls back to the current working directory, so you can
    # either keep them in tools/source_r/ or pass different paths below.
    here = os.path.dirname(os.path.abspath(__file__))
    candidates = [os.path.join(here, 'source_r'), here, os.getcwd()]

    def find(fname):
        for d in candidates:
            p = os.path.join(d, fname)
            if os.path.exists(p):
                return p
        raise FileNotFoundError(f"Couldn't find {fname} in {candidates}")

    with open(find('app.R'), encoding='utf-8') as f:
        app_src = f.read()
    with open(find('schemes_data.R'), encoding='utf-8') as f:
        data_src = f.read()

    func, body = get_statement(app_src, 'content')
    content = parse_r_value(func, body)

    func, body = get_statement(app_src, 'agent_warning')
    agent_warning = parse_r_value(func, body)

    env = eval_all_assignments(data_src)
    all_schemes = env['all_schemes']

    out = {
        'content': content,
        'agent_warning': agent_warning,
        'all_schemes': all_schemes,
    }
    out_path = os.path.join(here, '..', 'data.json')
    with open(out_path, 'w', encoding='utf-8') as f:
        json.dump(out, f, ensure_ascii=False, indent=2)

    print("schemes:", len(all_schemes))
    print("content keys:", list(content.keys()))
    print("sample scheme:", all_schemes[0])