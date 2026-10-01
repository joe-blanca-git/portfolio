/* Renderiza a página inicial com os dados de GET /api/site */
(function () {
  "use strict";

  const { escapeHtml: esc, assetUrl, iconClass, safeColor, imgFallback, PLACEHOLDER_IMG, request } = window.Portfolio;

  const CATEGORY_LABELS = {
    "filter-api": "Integração",
    "filter-plataform": "Plataforma",
    "filter-site": "Site Institucional",
  };
  const BADGE_ICONS = ["bi-at", "bi-code-slash", "bi-lightning"];

  const $ = (selector) => document.querySelector(selector);

  function setHtml(selector, html) {
    const el = $(selector);
    if (el) el.innerHTML = html;
  }

  function setImage(selector, url, alt) {
    const el = $(selector);
    if (!el) return;
    const src = assetUrl(url);
    (el.closest(".profile-image") || el).classList.toggle("d-none", !src);
    if (src) {
      el.src = src;
      el.alt = alt || "";
    }
  }

  // Preenche todos os elementos [data-field="coluna"] com o texto do perfil
  function fillFields(profile) {
    document.querySelectorAll("[data-field]").forEach((el) => {
      const value = profile[el.dataset.field];
      el.textContent = value ?? "";
    });
  }

  function linesToList(text) {
    return String(text || "")
      .split(",")
      .map((s) => s.trim())
      .filter(Boolean);
  }

  function contactHref(contact) {
    if (contact.url) return assetUrl(contact.url);
    if (contact.type === "email") return `mailto:${contact.value}`;
    if (contact.type === "phone") return `tel:${contact.value.replace(/[^\d+]/g, "")}`;
    return "";
  }

  function externalAttrs(href) {
    return /^https?:/i.test(href) ? ' target="_blank" rel="noopener"' : "";
  }

  /* ---------- Hero ---------- */
  function renderHero(profile, socials) {
    const typed = $("#hero-typed");
    typed.setAttribute("data-typed-items", profile.hero_typed_items || "");

    setHtml("#hero-stats", profile.years_experience
      ? `<div class="stat-item">
           <span class="purecounter" data-purecounter-start="0" data-purecounter-end="${Number(profile.years_experience)}" data-purecounter-duration="2">0</span>
           <span class="stat-label">Anos de Experiência</span>
         </div>`
      : "");

    setHtml("#hero-badges", linesToList(profile.hero_badges)
      .slice(0, 3)
      .map((text, i) => `
        <div class="floating-card card-${i + 1}" data-aos="zoom-in" data-aos-delay="${300 + i * 100}">
          <i class="bi ${BADGE_ICONS[i]}"></i>
          <span>${esc(text)}</span>
        </div>`)
      .join(""));

    setImage("#hero-image", profile.hero_image, profile.full_name);
    setHtml("#hero-social", socialLinks(socials));
  }

  function socialLinks(socials) {
    return socials
      .map((c) => {
        const href = contactHref(c);
        return href
          ? `<a href="${esc(href)}"${externalAttrs(href)} aria-label="${esc(c.label)}"><i class="${iconClass(c.icon, "bi-link-45deg")}"></i></a>`
          : "";
      })
      .join("");
  }

  /* ---------- Sobre mim ---------- */
  function renderAbout(profile, highlights, timeline) {
    setImage("#about-image", profile.about_image, profile.full_name);
    setImage("#signature-image", profile.signature_image, "Assinatura");

    setHtml("#about-highlights", highlights
      .map((h, i) => {
        const color = safeColor(h.color);
        return `
          <div class="skill-item" data-aos="zoom-in" data-aos-delay="${400 + i * 50}">
            <div class="skill-icon"${color ? ` style="background:${color}"` : ""}>
              <i class="${iconClass(h.icon)}"></i>
            </div>
            <h4>${esc(h.title)}</h4>
            <p>${esc(h.description)}</p>
          </div>`;
      })
      .join(""));

    setHtml("#about-timeline", timeline
      .map((t) => `
        <div class="timeline-item">
          <div class="year">${esc(t.year)}</div>
          <div class="description">${esc(t.description)}</div>
        </div>`)
      .join(""));
  }

  /* ---------- Habilidades ---------- */
  function renderSkills(categories, awards, certificates) {
    setHtml("#skill-categories", categories
      .map((cat, i) => `
        <div class="col-md-6" data-aos="flip-left" data-aos-delay="${200 + i * 100}">
          <div class="skill-card">
            <div class="skill-header">
              <i class="${iconClass(cat.icon, "bi-code-slash")}"></i>
              <h3>${esc(cat.title)}</h3>
            </div>
            <div class="skills-animation">
              ${cat.skills
                .map((s) => `
                <div class="skill-item">
                  <div class="skill-info">
                    <span class="skill-name">${esc(s.name)}</span>
                    <span class="skill-percentage">${Number(s.level)}%</span>
                  </div>
                  <div class="skill-bar progress">
                    <div class="progress-bar" role="progressbar" aria-label="${esc(s.name)}"
                      aria-valuenow="${Number(s.level)}" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>`)
                .join("")}
            </div>
          </div>
        </div>`)
      .join(""));

    setHtml("#awards", awards
      .map((a, i) => `
        <div class="stat-item" data-aos="zoom-in" data-aos-delay="${300 + i * 100}">
          <div class="stat-circle"><i class="${iconClass(a.icon, "bi-award")}"></i></div>
          <div class="stat-info">
            ${a.value ? `<span class="stat-number">${esc(a.value)}</span>` : ""}
            <span class="stat-label">${esc(a.title)}</span><br />
            ${a.subtitle ? `<span class="stat-label">${esc(a.subtitle)}</span>` : ""}
          </div>
        </div>`)
      .join(""));

    $("#certificates-block").classList.toggle("d-none", certificates.length === 0);
    setHtml("#certificates", certificates.map((c) => `<div class="skill-badge">${esc(c.name)}</div>`).join(""));
  }

  /* ---------- Carreira ---------- */
  function quoteHtml(text, author) {
    if (!text) return "";
    return `${esc(text)}${author ? `<br /><small>${esc(author)}</small>` : ""}`;
  }

  function renderResume(profile, experiences, education) {
    setHtml("#experience-quote", quoteHtml(profile.experience_quote, profile.experience_quote_author));
    setHtml("#education-quote", quoteHtml(profile.education_quote, profile.education_quote_author));

    setHtml("#experiences", experiences
      .map((exp, i) => `
        <div class="experience-card" data-aos="zoom-in" data-aos-delay="${Math.min(300 + i * 100, 500)}">
          <div class="card-header">
            <div class="role-info">
              <h3>${esc(exp.role)}</h3>
              <h4>${esc(exp.company)}</h4>
            </div>
            <span class="duration">${esc(exp.period)}</span>
          </div>
          <div class="card-body">
            ${exp.description ? `<p>${esc(exp.description)}</p>` : ""}
            ${exp.achievements.length
              ? `<ul class="achievements">${exp.achievements.map((a) => `<li>${esc(a)}</li>`).join("")}</ul>`
              : ""}
          </div>
        </div>`)
      .join(""));

    setHtml("#education", education
      .map((ed, i) => `
        <div class="education-item" data-aos="slide-up" data-aos-delay="${Math.min(300 + i * 100, 500)}">
          <div class="timeline-marker"></div>
          <div class="education-content">
            <div class="degree-header">
              <h3>${esc(ed.degree)}</h3>
              <span class="year">${esc(ed.period)}</span>
            </div>
            <h4 class="institution">${esc(ed.institution)}</h4>
            ${ed.description ? `<p>${esc(ed.description)}</p>` : ""}
          </div>
        </div>`)
      .join(""));
  }

  /* ---------- Cursos ---------- */
  function renderCourses(courses) {
    $("#services").classList.toggle("d-none", courses.length === 0);
    setHtml("#courses-container", courses
      .map((course, i) => {
        const isCurrent = /cursando/i.test(course.year || "");
        return `
          <div class="col-xl-4 col-md-6" data-aos="fade-up" data-aos-delay="${Math.min(100 + i * 50, 400)}">
            <div class="service-item">
              <div class="icon"><i class="${iconClass(course.icon, "bi-mortarboard")}"></i></div>
              <div class="course-body">
                <h3>${esc(course.title)}</h3>
                <div class="course-meta">
                  <span>${esc(course.institution)}</span>
                  ${course.year ? `<span class="year${isCurrent ? " is-current" : ""}">${esc(course.year)}</span>` : ""}
                </div>
              </div>
            </div>
          </div>`;
      })
      .join(""));
  }

  /* ---------- Blog ---------- */
  function postUrl(post) {
    return `service-details.html?post=${encodeURIComponent(post.id)}`;
  }

  function renderBlog(posts) {
    if (!posts.length) {
      setHtml("#featured-post-container",
        '<div class="featured-post"><div class="empty-state"><i class="bi bi-journal-text"></i>Nenhuma publicação por enquanto.</div></div>');
      setHtml("#sidebar-posts-container", "");
      return;
    }

    const [featured, ...others] = posts;
    const cover = assetUrl(featured.img_header) || PLACEHOLDER_IMG;

    setHtml("#featured-post-container", `
      <article class="featured-post">
        <a class="post-cover" href="${postUrl(featured)}" tabindex="-1" aria-hidden="true">
          <img src="${esc(cover)}" alt="" loading="lazy" ${imgFallback}>
          <span class="post-flag"><i class="bi bi-star-fill"></i> Destaque</span>
        </a>
        <div class="post-body">
          ${featured.tag ? `<span class="badge-soft align-self-start">${esc(featured.tag)}</span>` : ""}
          <h3><a href="${postUrl(featured)}">${esc(featured.title)}</a></h3>
          <p class="post-excerpt">${esc(featured.excerpt)}</p>
          <a class="read-more" href="${postUrl(featured)}">Continuar lendo <i class="bi bi-arrow-right"></i></a>
        </div>
      </article>`);

    setHtml("#sidebar-posts-container", others.length
      ? others
          .map((post) => `
            <a class="post-mini" href="${postUrl(post)}">
              <img src="${esc(assetUrl(post.img_header) || PLACEHOLDER_IMG)}" alt="" loading="lazy" ${imgFallback}>
              <div class="post-mini-body">
                ${post.tag ? `<div class="post-mini-tag">${esc(post.tag)}</div>` : ""}
                <div class="post-mini-title">${esc(post.title)}</div>
              </div>
              <i class="bi bi-chevron-right"></i>
            </a>`)
          .join("")
      : '<p class="text-secondary small mb-0">Novas publicações aparecerão aqui.</p>');
  }

  /* ---------- Portfólio ---------- */
  function renderProjects(projects) {
    const container = $("#projects-container");

    if (!projects.length) {
      container.innerHTML = '<div class="empty-state"><i class="bi bi-briefcase"></i>Nenhum projeto encontrado no portfólio.</div>';
      return;
    }

    container.innerHTML = projects
      .map((proj, idx) => {
        const label = CATEGORY_LABELS[proj.category] || "Projeto";
        const categoryClass = /^[\w-]+$/.test(proj.category || "") ? proj.category : "";
        return `
          <div class="col-xl-3 col-lg-4 col-md-6 portfolio-item ${categoryClass}">
            <article class="project-card" data-project-index="${idx}" tabindex="0" role="button"
              aria-label="Ver detalhes de ${esc(proj.title)}">
              <div class="project-img">
                <img src="${esc(assetUrl(proj.image_url) || PLACEHOLDER_IMG)}" alt="" loading="lazy" ${imgFallback}>
                <span class="project-category">${esc(label)}</span>
              </div>
              <div class="project-content">
                <h3 class="project-title">${esc(proj.title)}</h3>
                <p class="project-desc">${esc(proj.description)}</p>
                <span class="project-more">Ver detalhes <i class="bi bi-arrow-right"></i></span>
              </div>
            </article>
          </div>`;
      })
      .join("");

    function openModal(proj) {
      if (!proj) return;
      const img = $("#portfolioModalImg");
      img.src = assetUrl(proj.image_url) || PLACEHOLDER_IMG;
      img.alt = proj.title || "";
      $("#portfolioModalLabel").textContent = proj.title || "";
      $("#portfolioModalCategory").textContent = CATEGORY_LABELS[proj.category] || "Projeto";
      $("#portfolioModalDesc").textContent = proj.description || "";

      const link = assetUrl(proj.project_link);
      const linkBtn = $("#portfolioModalLink");
      linkBtn.href = link || "#";
      linkBtn.classList.toggle("d-none", !link);

      bootstrap.Modal.getOrCreateInstance($("#portfolioModal")).show();
    }

    container.addEventListener("click", (e) => {
      const card = e.target.closest(".project-card[data-project-index]");
      if (card) openModal(projects[card.dataset.projectIndex]);
    });
    container.addEventListener("keydown", (e) => {
      const card = e.target.closest(".project-card[data-project-index]");
      if (card && (e.key === "Enter" || e.key === " ")) {
        e.preventDefault();
        openModal(projects[card.dataset.projectIndex]);
      }
    });

    initProjectFilters(container);
  }

  function initProjectFilters(container) {
    const filters = document.querySelectorAll("#portfolio-filters li");
    const iso = typeof Isotope !== "undefined"
      ? new Isotope(container, { itemSelector: ".portfolio-item", layoutMode: "fitRows" })
      : null;

    // Isotope posiciona os itens em absoluto, então a altura igual é aplicada via JS
    function equalizeCardHeights() {
      const cards = [...container.querySelectorAll(".project-card")];
      cards.forEach((card) => (card.style.minHeight = ""));
      const maxHeight = Math.max(...cards.map((card) => card.offsetHeight));
      cards.forEach((card) => (card.style.minHeight = `${maxHeight}px`));
      if (iso) iso.layout();
    }

    equalizeCardHeights();
    if (typeof imagesLoaded !== "undefined") imagesLoaded(container).on("always", equalizeCardHeights);
    if (document.fonts) document.fonts.ready.then(equalizeCardHeights);

    let resizeTimer;
    window.addEventListener("resize", () => {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(equalizeCardHeights, 150);
    });

    function applyFilter(filterEl) {
      filters.forEach((f) => f.classList.remove("filter-active"));
      filterEl.classList.add("filter-active");
      const selector = filterEl.getAttribute("data-filter");
      if (iso) {
        iso.arrange({ filter: selector });
      } else {
        container.querySelectorAll(".portfolio-item").forEach((item) => {
          item.classList.toggle("d-none", selector !== "*" && !item.matches(selector));
        });
      }
    }

    filters.forEach((filter) => {
      filter.addEventListener("click", () => applyFilter(filter));
      filter.addEventListener("keydown", (e) => {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          applyFilter(filter);
        }
      });
    });
  }

  /* ---------- Contato e rodapé ---------- */
  function renderContact(profile, contacts, socials) {
    setImage("#contact-image", profile.contact_image, profile.full_name);

    // Agrupa por label ("Fone", "E-mail"...) mantendo a ordem cadastrada
    const groups = [];
    if (profile.location) {
      groups.push({ label: "Localização", icon: "bi-geo-alt", items: [{ text: profile.location }] });
    }
    contacts.forEach((c) => {
      let group = groups.find((g) => g.label === c.label);
      if (!group) {
        group = { label: c.label, icon: c.icon, items: [] };
        groups.push(group);
      }
      group.items.push({ text: c.value, href: contactHref(c) });
    });

    setHtml("#contact-items", groups
      .map((g) => `
        <div class="info-item">
          <div class="icon-box"><i class="${iconClass(g.icon, "bi-chat-dots")}"></i></div>
          <div class="content">
            <h4>${esc(g.label)}</h4>
            ${g.items
              .map((item) => item.href
                ? `<a href="${esc(item.href)}"${externalAttrs(item.href)}>${esc(item.text)}</a>`
                : `<p>${esc(item.text)}</p>`)
              .join("")}
          </div>
        </div>`)
      .join(""));

    setHtml("#contact-actions", socials
      .map((c, i) => {
        const href = contactHref(c);
        return href
          ? `<a href="${esc(href)}"${externalAttrs(href)}${i > 0 ? ' class="outline"' : ""}>
               <i class="${iconClass(c.icon, "bi-link-45deg")}"></i> ${esc(c.label)}
             </a>`
          : "";
      })
      .join(""));

    setHtml("#footer-social", socialLinks(socials));
  }

  /* ---------- Inicialização ---------- */
  function render(data) {
    const profile = data.profile || {};
    const contacts = data.contacts || [];
    const socials = contacts.filter((c) => c.show_in_social);
    const contactInfo = contacts.filter((c) => c.show_in_contact);

    fillFields(profile);
    if (profile.full_name) {
      document.title = [profile.full_name, profile.role_title].filter(Boolean).join(" | ");
    }

    renderHero(profile, socials);
    renderAbout(profile, data.highlights || [], data.timeline || []);
    renderSkills(data.skill_categories || [], data.awards || [], data.certificates || []);
    renderResume(profile, data.experiences || [], data.education || []);
    renderCourses(data.courses || []);
    renderBlog(data.posts || []);
    renderProjects(data.projects || []);
    renderContact(profile, contactInfo, socials);
  }

  function finish() {
    document.querySelectorAll(".footer-year").forEach((el) => (el.textContent = new Date().getFullYear()));
    document.body.classList.remove("is-loading");
    document.dispatchEvent(new Event("site:rendered"));
    if (typeof AOS !== "undefined") AOS.refreshHard();

    if (location.hash) {
      const target = document.querySelector(location.hash);
      if (target) setTimeout(() => target.scrollIntoView({ behavior: "smooth" }), 150);
    }
  }

  document.addEventListener("DOMContentLoaded", () => {
    request("/api/site")
      .then(render)
      .catch((error) => {
        console.error("Erro ao carregar o site:", error);
        const box = $("#site-error");
        box.textContent = "Não foi possível carregar o conteúdo do site agora. Tente novamente em instantes.";
        box.classList.remove("d-none");
      })
      .finally(finish);
  });
})();
