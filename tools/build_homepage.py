"""
build_homepage.py — generates index.html for the Aponar Adhikar site.

This turns the homepage from a hand-written HTML file into a generated one,
so the filmstrip photo list lives as plain Python data (easy to add/remove/
reorder images) instead of copy-pasted <figure> blocks.

Output: site/index.html

Run with: python3 build_homepage.py
Requires only the Python standard library.
"""
import os

SITE_DIR = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))

# ---------------------------------------------------------------
# 1. Data — every photo in the homepage filmstrip.
#    Add/remove/reorder entries here; the HTML regenerates from this list.
#    "file" must match a filename inside site/images/.
# ---------------------------------------------------------------
FILMSTRIP_PHOTOS = [
    {"file": "howrah-bridge.jpg",     "alt": "Howrah Bridge, Kolkata, at dusk",
     "bn": "কলকাতা", "en": "Kolkata"},
    {"file": "kolkata-street.jpg",    "alt": "A busy street scene in central Kolkata",
     "bn": "কলকাতার রাস্তা", "en": "Kolkata streets"},
    {"file": "bishnupur-temple.jpg",  "alt": "Terracotta temples of Bishnupur",
     "bn": "বিষ্ণুপুর", "en": "Bishnupur temples"},
    {"file": "sundarbans.jpg",        "alt": "Mangrove creek in the Sundarbans",
     "bn": "সুন্দরবন", "en": "Sundarbans"},
    {"file": "shantiniketan.jpg",     "alt": "Baul singers at Shantiniketan",
     "bn": "শান্তিনিকেতন", "en": "Shantiniketan"},
    {"file": "tea-garden.jpg",        "alt": "Tea pickers in the Darjeeling hills",
     "bn": "দার্জিলিং চা বাগান", "en": "Darjeeling tea gardens"},
    {"file": "bankura-village.jpg",   "alt": "A village in Bankura district",
     "bn": "বাঁকুড়া", "en": "Rural Bankura"},
    {"file": "wildlife.jpg",          "alt": "Red panda, kingfisher and snow leopard of North Bengal",
     "bn": "বন্যপ্রাণী", "en": "Wildlife of Bengal"},
]

# Homepage tool-card and hero images (unchanged, but kept as data too so the
# whole page comes from this one script).
HERO_IMAGE = {"file": "map-collage.jpg",
              "alt": "Collage in the shape of West Bengal showing tea gardens, Durga Puja, terracotta temples and the Sundarbans"}
FIX_CARD_IMAGE = {"file": "registration-queue.jpg",
                   "alt": "People waiting with registration paperwork at a government camp"}
BROWSE_CARD_IMAGE = {"file": "dhak-drummers.jpg",
                      "alt": "Rural West Bengal community"}
BROWSE_INTRO_IMAGE = {"file": "fields-boys.jpg", "alt": "Rural West Bengal"}


# ---------------------------------------------------------------
# 2. Render the filmstrip <figure> blocks from FILMSTRIP_PHOTOS
# ---------------------------------------------------------------
def render_filmstrip():
    figures = []
    for photo in FILMSTRIP_PHOTOS:
        figures.append(f'''      <figure>
        <img src="images/{photo['file']}" alt="{photo['alt']}">
        <figcaption><span class="bn">{photo['bn']}</span>{photo['en']}</figcaption>
      </figure>''')
    return "\n".join(figures)


# ---------------------------------------------------------------
# 3. Full-page template
# ---------------------------------------------------------------
PAGE_TEMPLATE = """<!DOCTYPE html>
<html lang="bn">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>আপনার অধিকার · Aponar Adhikar — West Bengal Scheme Help</title>
<meta name="description" content="Find out why your West Bengal government scheme payment or benefit is stuck, and browse the full directory of state and central schemes.">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Tiro+Bangla:ital@0;1&family=Hind+Siliguri:wght@400;500;600;700&display=swap">
<link rel="stylesheet" href="styles.css">
</head>
<body>

<header class="site-header">
  <div class="site-header-inner">
    <div>
      <div class="brand-bn">আপনার অধিকার</div>
      <div class="brand-en">Aponar Adhikar &middot; Your Entitlement</div>
    </div>
    <nav class="site-nav">
      <button type="button" data-page="home" class="active">হোম · Home</button>
      <button type="button" data-page="fix">সমস্যার সমাধান · Fix a problem</button>
      <button type="button" data-page="browse">সব প্রকল্প · Browse schemes</button>
    </nav>
  </div>
</header>

<!-- ================= HOME ================= -->
<section id="page-home">

  <div class="hero">
    <div>
      <div class="hero-eyebrow">West Bengal &middot; Government Schemes, Explained</div>
      <h1>আপনার সমস্যা বুঝুন
        <span class="en">What's going wrong, and what to do next</span>
      </h1>
      <p class="hero-lede">অন্নপূর্ণা ভাণ্ডার, রেশন কার্ড বা স্বাস্থ্য সাথীর টাকা আটকে গেলে কারণ ও করণীয় জানুন। অথবা রাজ্যের প্রায় ৯০টি প্রকল্পের সম্পূর্ণ তালিকা দেখুন — নাম, সুবিধা, আবেদনের পদ্ধতি ও যোগাযোগ, সব এক জায়গায়।</p>
      <div class="hero-ctas">
        <button class="btn-primary btn-lg" data-goto="fix">সমস্যার সমাধান খুঁজুন · Fix a problem</button>
        <button class="btn-secondary btn-lg" data-goto="browse">সব প্রকল্প দেখুন · Browse all schemes</button>
      </div>
    </div>
    <div class="hero-figure">
      <img src="images/{hero_file}" alt="{hero_alt}">
      <div class="stamp">৯০+<br>SCHEMES<br>COVERED</div>
    </div>
  </div>

  <div class="filmstrip-wrap">
    <div class="filmstrip-label">পশ্চিমবঙ্গ, এক নজরে &middot; West Bengal, at a glance</div>
    <div class="filmstrip">
{filmstrip_html}
    </div>
  </div>

  <div class="tool-intro">
    <div class="tool-intro-head">
      <h2>দুটি হাতিয়ার, একটাই লক্ষ্য · Two tools, one goal</h2>
      <p class="lede-en" style="text-align:center;max-width:56ch;margin:0 auto;">Most directories only help people apply. This helps people who already applied and are stuck — plus a complete reference for everything else.</p>
    </div>
    <div class="tool-grid">
      <div class="tool-card">
        <figure><img src="images/{fix_card_file}" alt="{fix_card_alt}"></figure>
        <div class="tool-tag">Troubleshoot</div>
        <h3>সমস্যার সমাধান খুঁজুন</h3>
        <p>Payment stopped, application rejected, card not working at the shop or hospital? Answer a few questions and get a specific next step — for Annapurna Bhandar, Ration Card, and Swasthya Sathi/Ayushman Bharat.</p>
        <button class="btn-primary" data-goto="fix">শুরু করুন · Start</button>
      </div>
      <div class="tool-card">
        <figure><img src="images/{browse_card_file}" alt="{browse_card_alt}"></figure>
        <div class="tool-tag">Reference</div>
        <h3>সব প্রকল্পের তালিকা</h3>
        <p>A searchable directory of West Bengal state schemes, applicable central schemes, and MSME/business incentives — benefit amount, how to apply, and who to contact.</p>
        <button class="btn-primary" data-goto="browse">তালিকা দেখুন · Browse</button>
      </div>
    </div>
  </div>

</section>

<!-- ================= FIX A PROBLEM ================= -->
<section id="page-fix" class="section-hidden">
  <div class="app-wrap">
    <div id="wizard-mount"></div>
  </div>
</section>

<!-- ================= BROWSE ALL SCHEMES ================= -->
<section id="page-browse" class="section-hidden">
  <div class="app-wrap wide">
    <div class="browse-intro">
      <figure><img src="images/{browse_intro_file}" alt="{browse_intro_alt}"></figure>
      <div class="browse-intro-text">
        <h2>সব প্রকল্প · All schemes</h2>
        <p>Search by name or benefit, or filter by category. This list is facts only — for troubleshooting a stuck application, use "Fix a problem" instead.</p>
      </div>
    </div>
    <div class="card">
      <div class="field-row">
        <input type="text" id="browse-search" placeholder="খুঁজুন · Search by name or benefit...">
        <select id="browse-category"></select>
      </div>
      <span class="count-note" id="browse-count"></span>
    </div>
    <div id="browse-table"></div>
  </div>
</section>

<footer class="app-footer">
  This is an independent, unofficial tool and is not affiliated with the Government of West Bengal. Scheme rules changed significantly in 2026 &mdash; always confirm final details on the relevant official portal or at a Duare Sarkar camp before applying.<br>
  এটি একটি স্বাধীন, বেসরকারি সহায়ক টুল এবং পশ্চিমবঙ্গ সরকারের সাথে যুক্ত নয়।
</footer>

<script src="data.js"></script>
<script src="app.js"></script>
</body>
</html>
"""


def build():
    html = PAGE_TEMPLATE.format(
        hero_file=HERO_IMAGE["file"],
        hero_alt=HERO_IMAGE["alt"],
        filmstrip_html=render_filmstrip(),
        fix_card_file=FIX_CARD_IMAGE["file"],
        fix_card_alt=FIX_CARD_IMAGE["alt"],
        browse_card_file=BROWSE_CARD_IMAGE["file"],
        browse_card_alt=BROWSE_CARD_IMAGE["alt"],
        browse_intro_file=BROWSE_INTRO_IMAGE["file"],
        browse_intro_alt=BROWSE_INTRO_IMAGE["alt"],
    )
    out_path = os.path.join(SITE_DIR, "index.html")
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(html)
    print(f"Wrote {out_path}")
    print(f"Filmstrip photos: {len(FILMSTRIP_PHOTOS)}")


if __name__ == "__main__":
    build()