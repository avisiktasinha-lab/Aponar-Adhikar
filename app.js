// Aponar Adhikar — static site logic (vanilla JS, no build step)
// Reads CONTENT / AGENT_WARNING / ALL_SCHEMES from data.js
// (that file is generated from the original app.R + schemes_data.R).

(function () {
  "use strict";

  // ---------------------------------------------------------------
  // Page / tab switching
  // ---------------------------------------------------------------
  const sections = {
    home: document.getElementById("page-home"),
    fix: document.getElementById("page-fix"),
    browse: document.getElementById("page-browse"),
  };
  const navButtons = document.querySelectorAll(".site-nav button");

  function showPage(name, opts) {
    opts = opts || {};
    if (!sections[name]) name = "home";
    Object.keys(sections).forEach((key) => {
      sections[key].classList.toggle("section-hidden", key !== name);
    });
    navButtons.forEach((btn) => {
      btn.classList.toggle("active", btn.dataset.page === name);
    });
    if (!opts.skipScroll) {
      window.scrollTo({ top: 0, behavior: opts.instant ? "auto" : "smooth" });
    }
    if (!opts.skipHash && location.hash !== "#" + name) {
      history.replaceState(null, "", "#" + name);
    }
  }

  navButtons.forEach((btn) => {
    btn.addEventListener("click", () => showPage(btn.dataset.page));
  });
  document.querySelectorAll("[data-goto]").forEach((el) => {
    el.addEventListener("click", () => showPage(el.dataset.goto));
  });
  window.addEventListener("hashchange", () => {
    showPage(location.hash.replace("#", ""), { skipHash: true });
  });

  // Land on whichever section the URL hash points to (e.g. a scheme
  // detail page's "Back to all schemes" link goes to index.html#browse).
  const initialPage = location.hash ? location.hash.replace("#", "") : "home";
  showPage(initialPage, { skipScroll: true, skipHash: true });

  // ---------------------------------------------------------------
  // Tab 1: troubleshooting wizard
  // ---------------------------------------------------------------
  const wizardMount = document.getElementById("wizard-mount");
  const state = { step: 0, scheme: null, issue: null, option: null };

  function schemeChoicesHTML(selectEl) {
    return Object.keys(CONTENT)
      .map((key) => {
        const sc = CONTENT[key];
        return `<option value="${key}">${sc.name_bn} · ${sc.name_en}</option>`;
      })
      .join("");
  }

  function el(html) {
    const t = document.createElement("template");
    t.innerHTML = html.trim();
    return t.content.firstElementChild;
  }

  function renderWizard() {
    wizardMount.innerHTML = "";

    if (state.step === 0) {
      wizardMount.appendChild(
        el(`
        <div>
          <div class="card intro-card">
            <h2>আপনার সমস্যার প্রকার বেছে নিন</h2>
            <p class="lede-bn">অন্নপূর্ণা ভাণ্ডার, রেশন কার্ড বা স্বাস্থ্য সাথীর টাকা বা সুবিধা আটকে গেলে, পদানুসারে বেছে কারণ খুঁজে নিন।</p>
            <p class="lede-en">For Annapurna Bhandar, Ration Card, or Swasthya Sathi/Ayushman Bharat — if your money or benefit is stuck, find out why and what to do.</p>
            <button class="btn-primary btn-lg" id="btn-start">শুরু করুন · Start</button>
          </div>
          <div class="card quick-card">
            <h3>কেউ কি টাকা চাইছে আবেদনের জন্য? · Is someone asking you for money to apply?</h3>
            <div class="field-row">
              <select id="quick-scheme">${schemeChoicesHTML()}</select>
              <button class="btn-warn" id="btn-agent-quick">এখনই সতর্কতা দেখুন · See the warning now</button>
            </div>
          </div>
        </div>
      `)
      );
      wizardMount.querySelector("#btn-start").addEventListener("click", () => {
        state.step = 1;
        renderWizard();
      });
      wizardMount.querySelector("#btn-agent-quick").addEventListener("click", () => {
        state.scheme = wizardMount.querySelector("#quick-scheme").value;
        state.issue = "agent";
        state.step = 4;
        renderWizard();
      });
      return;
    }

    if (state.step === 1) {
      const options = Object.keys(CONTENT)
        .map(
          (key) => `
        <div class="option-item">
          <input type="radio" name="scheme_choice" id="scheme_${key}" value="${key}">
          <label for="scheme_${key}">${CONTENT[key].name_bn} · ${CONTENT[key].name_en}</label>
        </div>`
        )
        .join("");
      wizardMount.appendChild(
        el(`
        <div class="card">
          <div class="step-label">ধাপ ১ · Step 1</div>
          <h3>কোন প্রকল্প সম্পর্কিত? · Which scheme is this about?</h3>
          <div class="option-list">${options}</div>
          <div class="btn-row">
            <button class="btn-primary" id="btn-next">পরবর্তী · Next</button>
          </div>
        </div>
      `)
      );
      wizardMount.querySelector("#btn-next").addEventListener("click", () => {
        const picked = wizardMount.querySelector('input[name="scheme_choice"]:checked');
        if (!picked) return;
        state.scheme = picked.value;
        state.step = 2;
        renderWizard();
      });
      return;
    }

    if (state.step === 2) {
      const sc = CONTENT[state.scheme];
      const options = Object.keys(sc.issues)
        .map((key) => {
          const iss = sc.issues[key];
          return `
        <div class="option-item">
          <input type="radio" name="issue_choice" id="issue_${key}" value="${key}">
          <label for="issue_${key}">${iss.label_bn} · ${iss.label_en}</label>
        </div>`;
        })
        .join("");
      const note = sc.note_bn
        ? `<div class="sub-note"><p>${sc.note_bn}</p><p class="sub-note-en">${sc.note_en}</p></div>`
        : "";
      wizardMount.appendChild(
        el(`
        <div class="card">
          <div class="step-label">ধাপ ২ · Step 2</div>
          <h3>${sc.name_bn} — কী সমস্যা হচ্ছে? · What's going wrong?</h3>
          ${note}
          <div class="option-list">${options}</div>
          <div class="btn-row">
            <button class="btn-secondary" id="btn-back">পেছনে · Back</button>
            <button class="btn-primary" id="btn-next">পরবর্তী · Next</button>
          </div>
        </div>
      `)
      );
      wizardMount.querySelector("#btn-back").addEventListener("click", () => {
        state.step = 0;
        renderWizard();
      });
      wizardMount.querySelector("#btn-next").addEventListener("click", () => {
        const picked = wizardMount.querySelector('input[name="issue_choice"]:checked');
        if (!picked) return;
        state.issue = picked.value;
        const issueData = CONTENT[state.scheme].issues[state.issue];
        state.step = issueData.direct_warning ? 4 : 3;
        renderWizard();
      });
      return;
    }

    if (state.step === 3) {
      const iss = CONTENT[state.scheme].issues[state.issue];
      const options = Object.keys(iss.options)
        .map((key) => {
          const opt = iss.options[key];
          return `
        <div class="option-item">
          <input type="radio" name="option_choice" id="opt_${key}" value="${key}">
          <label for="opt_${key}">${opt.label_bn} · ${opt.label_en}</label>
        </div>`;
        })
        .join("");
      wizardMount.appendChild(
        el(`
        <div class="card">
          <div class="step-label">ধাপ ৩ · Step 3</div>
          <h3>${iss.question_bn} · ${iss.question_en}</h3>
          <div class="option-list">${options}</div>
          <div class="btn-row">
            <button class="btn-secondary" id="btn-back">পেছনে · Back</button>
            <button class="btn-primary" id="btn-next">সমাধান দেখুন · Show me what to do</button>
          </div>
        </div>
      `)
      );
      wizardMount.querySelector("#btn-back").addEventListener("click", () => {
        state.step = 2;
        renderWizard();
      });
      wizardMount.querySelector("#btn-next").addEventListener("click", () => {
        const picked = wizardMount.querySelector('input[name="option_choice"]:checked');
        if (!picked) return;
        state.option = picked.value;
        state.step = 4;
        renderWizard();
      });
      return;
    }

    if (state.step === 4) {
      const iss = CONTENT[state.scheme].issues[state.issue];

      if (iss.direct_warning) {
        const bodyBn = AGENT_WARNING.body_bn.map((t) => `<li>${t}</li>`).join("");
        const bodyEn = AGENT_WARNING.body_en.map((t) => `<li>${t}</li>`).join("");
        wizardMount.appendChild(
          el(`
          <div class="card result-card warn-card-bg">
            <h3>${AGENT_WARNING.title_bn}</h3>
            <h4>${AGENT_WARNING.title_en}</h4>
            <ul>${bodyBn}</ul>
            <ul>${bodyEn}</ul>
            <div class="btn-row">
              <button class="btn-primary" id="btn-restart">আবার শুরু করুন · Start over</button>
            </div>
          </div>
        `)
        );
      } else {
        const opt = iss.options[state.option];
        const steps = opt.steps_bn
          .map(
            (bn, i) => `
          <li>
            <div class="step-bn">${bn}</div>
            <div class="step-en">${opt.steps_en[i]}</div>
          </li>`
          )
          .join("");
        wizardMount.appendChild(
          el(`
          <div class="card result-card">
            <div class="step-label">আপনার জন্য · For you</div>
            <h3>${opt.diagnosis_bn}</h3>
            <p class="diagnosis-en">${opt.diagnosis_en}</p>
            <h4>কী করবেন · What to do</h4>
            <ol>${steps}</ol>
            <div class="btn-row">
              <button class="btn-secondary" id="btn-restart">আবার শুরু করুন · Start over</button>
            </div>
          </div>
        `)
        );
      }
      wizardMount.querySelector("#btn-restart").addEventListener("click", () => {
        state.step = 0;
        state.scheme = null;
        state.issue = null;
        state.option = null;
        renderWizard();
      });
      return;
    }
  }

  renderWizard();

  // ---------------------------------------------------------------
  // Tab 2: browse all schemes
  // ---------------------------------------------------------------
  const searchInput = document.getElementById("browse-search");
  const categorySelect = document.getElementById("browse-category");
  const countNote = document.getElementById("browse-count");
  const tableMount = document.getElementById("browse-table");

  const categories = Array.from(new Set(ALL_SCHEMES.map((s) => s.category))).sort();
  categorySelect.innerHTML =
    `<option value="">All categories</option>` +
    categories.map((c) => `<option value="${c}">${c}</option>`).join("");

  function renderBrowse() {
    const term = searchInput.value.trim().toLowerCase();
    const cat = categorySelect.value;
    let rows = ALL_SCHEMES;
    if (cat) rows = rows.filter((r) => r.category === cat);
    if (term) {
      rows = rows.filter((r) =>
        (r.name_en + " " + r.benefit).toLowerCase().includes(term)
      );
    }

    countNote.textContent = `Showing ${rows.length} of ${ALL_SCHEMES.length} schemes`;

    if (rows.length === 0) {
      tableMount.innerHTML = `<div class="card"><p>No schemes match that search.</p></div>`;
      return;
    }

    tableMount.innerHTML = rows
      .map(
        (row) => `
      <div class="card scheme-row">
        <div class="scheme-row-top">
          <div>
            <h4><a class="scheme-link" href="schemes/${row.slug}.html">${row.name_en}</a></h4>
            ${row.name_bn ? `<div class="bn-name">${row.name_bn}</div>` : ""}
          </div>
          <div class="cat-badge">${row.category}</div>
        </div>
        <div class="status-line">${row.status}</div>
        <div class="benefit-line">${row.benefit}</div>
        <div class="apply-line"><strong>How to apply: </strong>${row.apply}</div>
        <div class="contact-line"><strong>Contact: </strong>${row.contact}</div>
        <div class="apply-line"><a class="detail-link" href="schemes/${row.slug}.html">Full details &amp; official links &rarr;</a></div>
      </div>
    `
      )
      .join("");
  }

  searchInput.addEventListener("input", renderBrowse);
  categorySelect.addEventListener("change", renderBrowse);
  renderBrowse();
})();
