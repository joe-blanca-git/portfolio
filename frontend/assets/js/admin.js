/* Painel admin: login, navegação e CRUD genérico sobre a API /api/admin */
(function () {
  "use strict";

  const { escapeHtml: esc, assetUrl, iconClass, request } = window.Portfolio;
  const TOKEN_KEY = "portfolio_admin_token";

  /* =====================================================================
     Configuração das telas
     ===================================================================== */
  const ORDER_FIELD = { name: "sort_order", label: "Ordem", type: "number", col: 3, min: 0, help: "Menor aparece primeiro." };

  const PROJECT_CATEGORIES = [
    ["filter-api", "Integração / API"],
    ["filter-plataform", "Plataforma / Sistema Web"],
    ["filter-site", "Site Institucional / Landing Page"],
  ];

  const CONTACT_TYPES = [
    ["phone", "Telefone", "bi-telephone"],
    ["whatsapp", "WhatsApp", "bi-whatsapp"],
    ["email", "E-mail", "bi-envelope"],
    ["linkedin", "LinkedIn", "bi-linkedin"],
    ["instagram", "Instagram", "bi-instagram"],
    ["github", "GitHub", "bi-github"],
    ["teams", "Microsoft Teams", "bi-microsoft-teams"],
    ["facebook", "Facebook", "bi-facebook"],
    ["youtube", "YouTube", "bi-youtube"],
    ["website", "Site", "bi-globe"],
    ["other", "Outro", "bi-link-45deg"],
  ];

  const RESOURCES = {
    contacts: {
      title: "Contatos e redes",
      singular: "contato",
      icon: "at-sign",
      description: "Telefones, e-mails e redes sociais exibidos no site.",
      columns: [
        { key: "icon", label: "", type: "icon" },
        { key: "label", label: "Rótulo", main: true },
        { key: "value", label: "Texto" },
        { key: "show_in_contact", label: "Card de contato", type: "bool", mobile: false },
        { key: "show_in_social", label: "Ícones sociais", type: "bool", mobile: false },
        { key: "sort_order", label: "Ordem", mobile: false },
      ],
      fields: [
        { name: "type", label: "Tipo", type: "select", required: true, col: 6, options: CONTACT_TYPES.map(([v, l]) => [v, l]) },
        { name: "label", label: "Rótulo", required: true, col: 6, help: "Itens com o mesmo rótulo são agrupados no card de contato (ex.: E-mail)." },
        { name: "value", label: "Texto exibido", required: true, col: 6, placeholder: "(16) 9 9999-9999" },
        { name: "url", label: "Link", col: 6, placeholder: "https://...", help: "Vazio: telefone e e-mail geram tel:/mailto: automaticamente." },
        { name: "icon", label: "Ícone", type: "icon", col: 6 },
        { ...ORDER_FIELD },
        { name: "show_in_contact", label: "Mostrar no card da seção Contato", type: "checkbox", col: 6, default: true },
        { name: "show_in_social", label: "Mostrar nos ícones sociais (hero e rodapé)", type: "checkbox", col: 6 },
      ],
    },
    highlights: {
      title: "Destaques do Sobre mim",
      singular: "destaque",
      icon: "sparkles",
      description: "Cards com ícone exibidos abaixo do texto de apresentação.",
      columns: [
        { key: "icon", label: "", type: "icon" },
        { key: "title", label: "Título", main: true },
        { key: "description", label: "Descrição", mobile: false },
        { key: "sort_order", label: "Ordem", mobile: false },
      ],
      fields: [
        { name: "title", label: "Título", required: true, col: 6 },
        { name: "description", label: "Descrição", col: 6 },
        { name: "icon", label: "Ícone", type: "icon", col: 4 },
        { name: "color", label: "Cor do ícone", type: "color", col: 5 },
        { ...ORDER_FIELD },
      ],
    },
    timeline: {
      title: "Linha do tempo",
      singular: "marco",
      icon: "milestone",
      description: "Marcos da sua trajetória na seção Sobre mim.",
      columns: [
        { key: "year", label: "Ano" },
        { key: "description", label: "Descrição", main: true },
        { key: "sort_order", label: "Ordem", mobile: false },
      ],
      fields: [
        { name: "year", label: "Ano", required: true, col: 3, placeholder: "2025" },
        { name: "description", label: "Descrição", required: true, col: 6 },
        { ...ORDER_FIELD },
      ],
    },
    skill_categories: {
      title: "Categorias de habilidades",
      singular: "categoria",
      feminine: true,
      icon: "layers",
      description: "Cada categoria vira um card na seção Habilidades.",
      columns: [
        { key: "icon", label: "", type: "icon" },
        { key: "title", label: "Categoria", main: true },
        { key: "sort_order", label: "Ordem" },
      ],
      fields: [
        { name: "title", label: "Nome da categoria", required: true, col: 6 },
        { name: "icon", label: "Ícone", type: "icon", col: 3 },
        { ...ORDER_FIELD },
      ],
    },
    skills: {
      title: "Habilidades",
      singular: "habilidade",
      feminine: true,
      icon: "gauge",
      description: "Itens com barra de nível dentro de cada categoria.",
      lookups: { category_id: "skill_categories" },
      columns: [
        { key: "name", label: "Habilidade", main: true },
        { key: "category_id", label: "Categoria", type: "lookup", lookup: "skill_categories", lookupLabel: "title" },
        { key: "level", label: "Nível", type: "level", mobile: false },
        { key: "sort_order", label: "Ordem", mobile: false },
      ],
      fields: [
        { name: "category_id", label: "Categoria", type: "select", required: true, col: 6, optionsFrom: "skill_categories", optionLabel: "title" },
        { name: "name", label: "Habilidade", required: true, col: 6 },
        { name: "level", label: "Nível (%)", type: "number", required: true, col: 3, min: 0, max: 100 },
        { ...ORDER_FIELD },
      ],
    },
    awards: {
      title: "Conquistas",
      singular: "conquista",
      feminine: true,
      icon: "trophy",
      description: "Bloco \"Destaques\" ao lado das habilidades.",
      columns: [
        { key: "icon", label: "", type: "icon" },
        { key: "title", label: "Título", main: true },
        { key: "subtitle", label: "Subtítulo", mobile: false },
        { key: "sort_order", label: "Ordem", mobile: false },
      ],
      fields: [
        { name: "value", label: "Número em destaque", col: 3, placeholder: "+1" },
        { name: "title", label: "Título", required: true, col: 5 },
        { name: "subtitle", label: "Subtítulo", col: 4 },
        { name: "icon", label: "Ícone", type: "icon", col: 4 },
        { ...ORDER_FIELD },
      ],
    },
    certificates: {
      title: "Certificados",
      singular: "certificado",
      icon: "badge-check",
      description: "Lista de certificados exibida na seção Habilidades.",
      columns: [
        { key: "name", label: "Certificado", main: true },
        { key: "sort_order", label: "Ordem" },
      ],
      fields: [
        { name: "name", label: "Certificado", required: true, col: 9, placeholder: "Metodologia DevOps - Alura" },
        { ...ORDER_FIELD },
      ],
    },
    experiences: {
      title: "Experiências",
      singular: "experiência",
      feminine: true,
      icon: "briefcase",
      description: "Jornada profissional na seção Carreira.",
      columns: [
        { key: "role", label: "Cargo", main: true },
        { key: "company", label: "Empresa" },
        { key: "period", label: "Período", mobile: false },
        { key: "sort_order", label: "Ordem", mobile: false },
      ],
      fields: [
        { name: "role", label: "Cargo", required: true, col: 6 },
        { name: "company", label: "Empresa", required: true, col: 6 },
        { name: "period", label: "Período", required: true, col: 6, placeholder: "2022 - Atualmente" },
        { ...ORDER_FIELD },
        { name: "description", label: "Descrição", type: "textarea", rows: 5, col: 12 },
        { name: "achievements", label: "Realizações", type: "textarea", rows: 5, col: 12, help: "Uma realização por linha." },
      ],
    },
    education: {
      title: "Formação acadêmica",
      singular: "formação",
      feminine: true,
      icon: "graduation-cap",
      description: "Linha do tempo de formação na seção Carreira.",
      columns: [
        { key: "degree", label: "Curso", main: true },
        { key: "institution", label: "Instituição", mobile: false },
        { key: "period", label: "Período" },
        { key: "sort_order", label: "Ordem", mobile: false },
      ],
      fields: [
        { name: "degree", label: "Curso", required: true, col: 12 },
        { name: "institution", label: "Instituição", required: true, col: 6 },
        { name: "period", label: "Período", required: true, col: 3, placeholder: "2022 - 2024" },
        { ...ORDER_FIELD },
        { name: "description", label: "Descrição", type: "textarea", rows: 5, col: 12 },
      ],
    },
    courses: {
      title: "Cursos",
      singular: "curso",
      icon: "book-open",
      description: "Cursos complementares. Use \"Cursando\" no ano para destacar em verde.",
      columns: [
        { key: "icon", label: "", type: "icon" },
        { key: "title", label: "Curso", main: true },
        { key: "institution", label: "Instituição", mobile: false },
        { key: "year", label: "Ano" },
        { key: "sort_order", label: "Ordem", mobile: false },
      ],
      fields: [
        { name: "title", label: "Curso", required: true, col: 6 },
        { name: "institution", label: "Instituição", required: true, col: 6 },
        { name: "year", label: "Ano", col: 4, placeholder: "2025 - Cursando" },
        { name: "icon", label: "Ícone", type: "icon", col: 5 },
        { ...ORDER_FIELD },
      ],
    },
    posts: {
      title: "Blog",
      singular: "publicação",
      feminine: true,
      icon: "file-text",
      description: "Publicações do blog. A mais recente aparece em destaque no site.",
      columns: [
        { key: "img_header", label: "Capa", type: "image" },
        { key: "title", label: "Título", main: true },
        { key: "tag", label: "Categoria", mobile: false },
        { key: "published", label: "Status", type: "published" },
        { key: "created_at", label: "Criado em", type: "date", mobile: false },
      ],
      fields: [
        { name: "title", label: "Título", required: true, col: 12 },
        { name: "tag", label: "Categoria (tag)", col: 6, placeholder: "Tecnologia, Evento..." },
        { name: "published", label: "Publicado no site", type: "checkbox", col: 6, default: true },
        { name: "img_header", label: "Imagem de capa", type: "image", col: 12 },
        { name: "content", label: "Conteúdo", type: "richtext", col: 12 },
        { name: "images", label: "Galeria de imagens", type: "gallery", col: 12, help: "Uma URL por linha, ou envie as imagens." },
      ],
    },
    projects: {
      title: "Projetos",
      singular: "projeto",
      icon: "folder-kanban",
      description: "Cases exibidos na seção Portfólio.",
      columns: [
        { key: "image_url", label: "Capa", type: "image" },
        { key: "title", label: "Projeto", main: true },
        { key: "category", label: "Categoria", type: "option", options: PROJECT_CATEGORIES, mobile: false },
        { key: "sort_order", label: "Ordem", mobile: false },
      ],
      fields: [
        { name: "title", label: "Nome do projeto", required: true, col: 6 },
        { name: "category", label: "Categoria (filtro do site)", type: "select", required: true, col: 6, options: PROJECT_CATEGORIES },
        { name: "image_url", label: "Imagem ou GIF de capa", type: "image", col: 12 },
        { name: "project_link", label: "Link externo", col: 9, placeholder: "https://... (opcional)" },
        { ...ORDER_FIELD },
        { name: "description", label: "Descrição", type: "textarea", rows: 6, col: 12 },
      ],
    },
  };

  const PROFILE_SECTIONS = [
    {
      title: "Identidade",
      subtitle: "Nome e cargo usados no título da página, header e rodapé.",
      fields: [
        { name: "full_name", label: "Nome completo", required: true, col: 6 },
        { name: "role_title", label: "Cargo", col: 6 },
        { name: "location", label: "Localização", col: 6, help: "Aparece no card da seção Contato." },
        { name: "footer_tagline", label: "Frase do rodapé", col: 6 },
      ],
    },
    {
      title: "Hero (topo do site)",
      subtitle: "Primeira dobra da página inicial.",
      fields: [
        { name: "hero_greeting", label: "Saudação", col: 6, placeholder: "Olá, eu sou..." },
        { name: "hero_title", label: "Título", col: 3, placeholder: "Dev" },
        { name: "years_experience", label: "Anos de experiência", type: "number", col: 3, min: 0, max: 99 },
        { name: "hero_typed_items", label: "Palavras animadas", col: 6, help: "Separadas por vírgula. Ex.: Web, API's, Frontend" },
        { name: "hero_badges", label: "Cards flutuantes da foto", col: 6, help: "Até 3, separados por vírgula." },
        { name: "hero_lead", label: "Texto de apresentação", type: "textarea", rows: 3, col: 12 },
        { name: "hero_image", label: "Foto do hero", type: "image", col: 12 },
      ],
    },
    {
      title: "Sobre mim",
      subtitle: "Texto de apresentação, foto e assinatura.",
      fields: [
        { name: "about_subtitle", label: "Subtítulo da seção", col: 6 },
        { name: "about_title", label: "Título", col: 6 },
        { name: "about_text", label: "Texto", type: "textarea", rows: 5, col: 12 },
        { name: "about_quote", label: "Frase abaixo da assinatura", col: 12 },
        { name: "about_image", label: "Foto", type: "image", col: 6 },
        { name: "signature_image", label: "Assinatura", type: "image", col: 6 },
      ],
    },
    {
      title: "Habilidades",
      subtitle: "Bloco lateral com conquistas e certificados.",
      fields: [
        { name: "skills_summary_title", label: "Título do bloco", col: 6 },
        { name: "skills_summary_text", label: "Texto", type: "textarea", rows: 2, col: 12 },
      ],
    },
    {
      title: "Carreira",
      subtitle: "Citações exibidas acima da experiência e da formação.",
      fields: [
        { name: "experience_quote", label: "Citação da experiência", col: 8 },
        { name: "experience_quote_author", label: "Autor", col: 4 },
        { name: "education_quote", label: "Citação da formação", col: 8 },
        { name: "education_quote_author", label: "Autor", col: 4 },
      ],
    },
    {
      title: "Contato",
      subtitle: "Os telefones, e-mails e redes ficam em Contatos e redes.",
      fields: [
        { name: "contact_title", label: "Título do card", col: 6 },
        { name: "contact_text", label: "Texto do card", type: "textarea", rows: 2, col: 12 },
        { name: "contact_image", label: "Foto da seção", type: "image", col: 12 },
      ],
    },
  ];

  const NAV = [
    { items: [{ route: "dashboard", label: "Visão geral", icon: "layout-dashboard" }] },
    { group: "Site", items: [
      { route: "profile", label: "Perfil e textos", icon: "user-round" },
      { route: "contacts" }, { route: "highlights" }, { route: "timeline" },
    ] },
    { group: "Habilidades", items: [{ route: "skill_categories", label: "Categorias" }, { route: "skills" }, { route: "awards" }, { route: "certificates" }] },
    { group: "Carreira", items: [{ route: "experiences" }, { route: "education", label: "Formação" }, { route: "courses" }] },
    { group: "Publicações", items: [{ route: "posts" }, { route: "projects" }] },
    { group: "Conta", items: [{ route: "account", label: "Alterar senha", icon: "key-round" }] },
  ];

  /* =====================================================================
     Estado, API e utilitários
     ===================================================================== */
  const state = { token: null, user: null, editors: {}, cache: {} };
  const view = document.getElementById("view");

  function readToken() {
    try { return localStorage.getItem(TOKEN_KEY); } catch { return null; }
  }

  function writeToken(token) {
    try {
      if (token) localStorage.setItem(TOKEN_KEY, token);
      else localStorage.removeItem(TOKEN_KEY);
    } catch { /* navegação privada */ }
  }

  async function api(path, options = {}) {
    try {
      return await request(path, { ...options, token: state.token });
    } catch (error) {
      if (error.status === 401 && state.token) {
        logout("Sua sessão expirou. Entre novamente.");
      }
      throw error;
    }
  }

  function icons(root) {
    if (window.lucide) lucide.createIcons({ root: root || document });
  }

  function toast(message, type = "success") {
    const container = document.getElementById("toast-container");
    const el = document.createElement("div");
    el.className = "saas-toast";
    const icon = type === "success" ? "check-circle-2" : "alert-circle";
    const color = type === "success" ? "#10b981" : "#ef4444";
    el.innerHTML = `<i data-lucide="${icon}" style="color:${color}"></i><span>${esc(message)}</span>`;
    container.appendChild(el);
    icons(el);
    setTimeout(() => el.classList.add("show"), 10);
    setTimeout(() => {
      el.classList.remove("show");
      setTimeout(() => el.remove(), 300);
    }, 3500);
  }

  function formatDate(value) {
    if (!value) return "";
    const date = new Date(value);
    return isNaN(date) ? esc(value) : date.toLocaleDateString("pt-BR");
  }

  function resourceLabel(route) {
    const item = NAV.flatMap((g) => g.items).find((i) => i.route === route);
    return (item && item.label) || (RESOURCES[route] && RESOURCES[route].title) || route;
  }

  async function loadLookup(name, force = false) {
    if (!state.cache[name] || force) state.cache[name] = await api(`/api/admin/${name}`);
    return state.cache[name];
  }

  /* =====================================================================
     Login e layout
     ===================================================================== */
  const loginPanel = document.getElementById("login-panel");
  const appPanel = document.getElementById("app-panel");

  function showLogin(message) {
    appPanel.classList.add("hidden");
    loginPanel.classList.remove("hidden");
    const errorEl = document.getElementById("login-error");
    errorEl.textContent = message || "";
    errorEl.classList.toggle("hidden", !message);
    icons(loginPanel);
  }

  function showApp() {
    loginPanel.classList.add("hidden");
    appPanel.classList.remove("hidden");
    renderNav();
    route();
  }

  function logout(message) {
    state.token = null;
    state.user = null;
    state.cache = {};
    writeToken(null);
    showLogin(message);
  }

  document.getElementById("login-form").addEventListener("submit", async (e) => {
    e.preventDefault();
    const btn = document.getElementById("login-btn");
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value;
    const errorEl = document.getElementById("login-error");
    errorEl.classList.add("hidden");

    if (!email || !password) {
      errorEl.textContent = "Preencha e-mail e senha.";
      errorEl.classList.remove("hidden");
      return;
    }

    btn.disabled = true;
    btn.textContent = "Autenticando...";
    try {
      const data = await request("/api/auth/login", { method: "POST", body: { email, password } });
      state.token = data.token;
      state.user = data.user;
      writeToken(data.token);
      document.getElementById("password").value = "";
      toast("Sessão iniciada com sucesso!");
      showApp();
    } catch (error) {
      errorEl.textContent = error.message;
      errorEl.classList.remove("hidden");
    } finally {
      btn.disabled = false;
      btn.textContent = "Entrar no sistema";
    }
  });

  document.getElementById("toggle-password").addEventListener("click", () => {
    const input = document.getElementById("password");
    const icon = document.getElementById("toggle-password-icon");
    const show = input.type === "password";
    input.type = show ? "text" : "password";
    icon.className = show ? "bi bi-eye-slash" : "bi bi-eye";
  });

  document.getElementById("btn-logout").addEventListener("click", (e) => {
    e.preventDefault();
    logout();
    toast("Sessão encerrada.");
  });

  document.getElementById("sidebar-toggle").addEventListener("click", () => document.body.classList.toggle("sidebar-open"));
  document.getElementById("sidebar-backdrop").addEventListener("click", () => document.body.classList.remove("sidebar-open"));

  function renderNav() {
    document.getElementById("sidebar-nav").innerHTML = NAV.map((group) => `
      ${group.group ? `<div class="nav-group-title">${esc(group.group)}</div>` : ""}
      <ul class="sidebar-nav">
        ${group.items.map((item) => {
          const res = RESOURCES[item.route];
          const icon = item.icon || (res && res.icon) || "circle";
          return `<li><a class="nav-item" href="#/${item.route}" data-route="${item.route}"><i data-lucide="${icon}"></i> ${esc(resourceLabel(item.route))}</a></li>`;
        }).join("")}
      </ul>`).join("");
    icons(document.querySelector(".sidebar"));
  }

  function setActiveNav(routeName) {
    document.querySelectorAll("#sidebar-nav .nav-item").forEach((a) => {
      a.classList.toggle("active", a.dataset.route === routeName);
    });
  }

  /* =====================================================================
     Rotas (#/recurso, #/recurso/novo, #/recurso/ID)
     ===================================================================== */
  async function route() {
    if (!state.token) return;
    document.body.classList.remove("sidebar-open");
    state.editors = {};

    const [name = "dashboard", id] = location.hash.replace(/^#\/?/, "").split("/");
    setActiveNav(name);
    window.scrollTo({ top: 0 });

    view.innerHTML = '<div class="loading-block"><div class="spinner-border spinner-border-sm me-2"></div> Carregando...</div>';

    try {
      if (name === "dashboard") await renderDashboard();
      else if (name === "profile") await renderProfile();
      else if (name === "account") renderAccount();
      else if (RESOURCES[name] && id) await renderForm(name, id === "novo" ? null : id);
      else if (RESOURCES[name]) await renderList(name);
      else location.hash = "#/dashboard";
    } catch (error) {
      if (error.status === 401) return;
      view.innerHTML = `
        <div class="saas-card text-center py-5">
          <i data-lucide="alert-triangle" style="width:36px;height:36px;color:var(--danger)"></i>
          <p class="mt-3 mb-0">${esc(error.message)}</p>
        </div>`;
      icons(view);
    }
  }

  window.addEventListener("hashchange", route);

  /* =====================================================================
     Dashboard
     ===================================================================== */
  async function renderDashboard() {
    const { counts } = await api("/api/admin/summary");
    const name = state.user && (state.user.name || state.user.email);

    view.innerHTML = `
      <div class="page-header">
        <div>
          <h1 class="page-title">Olá${name ? `, ${esc(name.split(" ")[0])}` : ""}!</h1>
          <p class="page-subtitle">Escolha o que deseja atualizar no site.</p>
        </div>
        <a class="btn-saas btn-saas-outline" href="index.html" target="_blank" rel="noopener"><i data-lucide="external-link"></i> Ver site</a>
      </div>
      <div class="dashboard-grid">
        <a class="dash-card" href="#/profile">
          <div class="dash-icon"><i data-lucide="user-round"></i></div>
          <div><div class="dash-count" style="font-size:17px">Perfil</div><div class="dash-label">Textos e fotos do site</div></div>
        </a>
        ${Object.entries(RESOURCES).map(([key, res]) => `
          <a class="dash-card" href="#/${key}">
            <div class="dash-icon"><i data-lucide="${res.icon}"></i></div>
            <div><div class="dash-count">${Number(counts[key] || 0)}</div><div class="dash-label">${esc(resourceLabel(key))}</div></div>
          </a>`).join("")}
      </div>`;
    icons(view);
  }

  /* =====================================================================
     Listagem genérica
     ===================================================================== */
  function cellHtml(col, row, lookups) {
    const value = row[col.key];
    switch (col.type) {
      case "image": {
        const src = assetUrl(value);
        return src ? `<img class="thumb" src="${esc(src)}" alt="" loading="lazy" onerror="this.style.visibility='hidden'">` : '<div class="thumb"></div>';
      }
      case "icon":
        return value ? `<span class="icon-preview" style="width:36px;height:36px;font-size:17px"><i class="${iconClass(value)}"></i></span>` : "";
      case "bool":
        return value ? '<span class="soft-badge success">Sim</span>' : '<span class="soft-badge muted">Não</span>';
      case "published":
        return value ? '<span class="soft-badge success">Publicado</span>' : '<span class="soft-badge muted">Rascunho</span>';
      case "level":
        return `<span class="level-bar"><span style="width:${Number(value) || 0}%"></span></span>${Number(value) || 0}%`;
      case "date":
        return formatDate(value);
      case "option": {
        const opt = col.options.find(([v]) => v === value);
        return `<span class="soft-badge">${esc(opt ? opt[1] : value)}</span>`;
      }
      case "lookup": {
        const item = (lookups[col.lookup] || []).find((i) => i.id === value);
        return `<span class="soft-badge">${esc(item ? item[col.lookupLabel] : "—")}</span>`;
      }
      default:
        return esc(value);
    }
  }

  async function renderList(name) {
    const res = RESOURCES[name];
    const rows = await api(`/api/admin/${name}`);
    state.cache[name] = rows;

    const lookups = {};
    for (const col of res.columns.filter((c) => c.type === "lookup")) {
      lookups[col.lookup] = await loadLookup(col.lookup, true);
    }

    view.innerHTML = `
      <div class="page-header">
        <div>
          <h1 class="page-title">${esc(res.title)}</h1>
          <p class="page-subtitle">${esc(res.description)}</p>
        </div>
        <a class="btn-saas" href="#/${name}/novo"><i data-lucide="plus"></i> Adicionar ${esc(res.singular)}</a>
      </div>
      <div class="saas-card">
        ${rows.length > 6 ? `
        <div class="table-toolbar">
          <input type="search" class="form-control search-input" placeholder="Buscar..." aria-label="Buscar">
          <span class="text-secondary small" data-count>${rows.length} registro(s)</span>
        </div>` : ""}
        <div class="table-responsive">
          <table class="table-modern">
            <thead>
              <tr>
                ${res.columns.map((c) => `<th class="${c.mobile === false ? "hide-mobile" : ""}">${esc(c.label)}</th>`).join("")}
                <th class="text-end">Ações</th>
              </tr>
            </thead>
            <tbody>
              ${rows.length ? rows.map((row) => `
                <tr data-search="${esc(res.columns.map((c) => row[c.key] ?? "").join(" ").toLowerCase())}">
                  ${res.columns.map((c) => `<td class="${c.main ? "cell-main" : ""} ${c.mobile === false ? "hide-mobile" : ""}">${cellHtml(c, row, lookups)}</td>`).join("")}
                  <td class="text-end">
                    <div class="row-actions">
                      <a class="btn-saas btn-saas-outline btn-sm" href="#/${name}/${row.id}"><i data-lucide="pencil"></i> Editar</a>
                      <button type="button" class="btn-saas danger btn-sm" data-delete="${row.id}"><i data-lucide="trash-2"></i><span class="hide-mobile">Excluir</span></button>
                    </div>
                  </td>
                </tr>`).join("") : `
                <tr><td class="empty-row" colspan="${res.columns.length + 1}">Nenhum registro ainda. Clique em "Adicionar ${esc(res.singular)}".</td></tr>`}
            </tbody>
          </table>
        </div>
      </div>`;
    icons(view);

    const search = view.querySelector(".search-input");
    if (search) {
      search.addEventListener("input", () => {
        const term = search.value.trim().toLowerCase();
        let visible = 0;
        view.querySelectorAll("tbody tr[data-search]").forEach((tr) => {
          const match = !term || tr.dataset.search.includes(term);
          tr.classList.toggle("d-none", !match);
          if (match) visible++;
        });
        view.querySelector("[data-count]").textContent = `${visible} registro(s)`;
      });
    }

    view.querySelectorAll("[data-delete]").forEach((btn) => {
      btn.addEventListener("click", async () => {
        const row = rows.find((r) => String(r.id) === btn.dataset.delete);
        const title = row && (row.title || row.name || row.label || row.role || row.degree || row.year);
        const extra = name === "skill_categories" ? "\nAs habilidades desta categoria também serão excluídas." : "";
        if (!confirm(`Excluir ${res.singular}${title ? ` "${title}"` : ""}? Esta ação não pode ser desfeita.${extra}`)) return;
        btn.disabled = true;
        try {
          await api(`/api/admin/${name}/${btn.dataset.delete}`, { method: "DELETE" });
          toast("Registro excluído.");
          renderList(name);
        } catch (error) {
          btn.disabled = false;
          toast(error.message, "danger");
        }
      });
    });
  }

  /* =====================================================================
     Formulários
     ===================================================================== */
  function fieldHtml(field, value, options = {}) {
    const id = `f-${field.name}`;
    const req = field.required ? '<span class="req">*</span>' : "";
    const help = field.help ? `<div class="form-text">${esc(field.help)}</div>` : "";
    const feedback = `<div class="invalid-feedback" data-error-for="${field.name}"></div>`;
    const attrs = `id="${id}" name="${field.name}" ${field.required ? "required" : ""} ${field.placeholder ? `placeholder="${esc(field.placeholder)}"` : ""}`;
    const v = value ?? "";
    let control;

    switch (field.type) {
      case "textarea":
        control = `<textarea class="form-control" rows="${field.rows || 4}" ${attrs}>${esc(v)}</textarea>`;
        break;
      case "number":
        control = `<input type="number" class="form-control" ${attrs} value="${esc(v)}" ${field.min !== undefined ? `min="${field.min}"` : ""} ${field.max !== undefined ? `max="${field.max}"` : ""}>`;
        break;
      case "select": {
        const opts = field.optionsFrom
          ? (options.lookups[field.optionsFrom] || []).map((o) => [o.id, o[field.optionLabel]])
          : field.options;
        control = `
          <select class="form-select" ${attrs}>
            <option value="">Selecione...</option>
            ${opts.map(([val, label]) => `<option value="${esc(val)}" ${String(val) === String(v) ? "selected" : ""}>${esc(label)}</option>`).join("")}
          </select>`;
        break;
      }
      case "checkbox": {
        const checked = value === undefined || value === null ? !!field.default : !!value;
        return `
          <div class="col-md-${field.col || 12} d-flex align-items-end">
            <div class="form-check form-switch mb-2">
              <input class="form-check-input" type="checkbox" role="switch" id="${id}" name="${field.name}" ${checked ? "checked" : ""}>
              <label class="form-check-label" for="${id}">${esc(field.label)}</label>
            </div>
          </div>`;
      }
      case "icon":
        control = `
          <div class="icon-field">
            <span class="icon-preview"><i class="${iconClass(v, "bi-question")}"></i></span>
            <input type="text" class="form-control" ${attrs} value="${esc(v)}" placeholder="bi-code-slash" data-icon-input>
          </div>`;
        return `
          <div class="col-md-${field.col || 12}">
            <label class="form-label" for="${id}">${esc(field.label)}${req}</label>
            ${control}
            <div class="form-text">Nome do <a href="https://icons.getbootstrap.com/" target="_blank" rel="noopener">Bootstrap Icon</a>.</div>
            ${feedback}
          </div>`;
      case "color":
        control = `
          <div class="color-field">
            <input type="color" value="${/^#[0-9a-f]{6}$/i.test(v) ? v : "#065cc2"}" data-color-picker aria-label="Escolher cor">
            <input type="text" class="form-control" ${attrs} value="${esc(v)}" placeholder="Vazio = cor padrão">
          </div>`;
        break;
      case "image":
        control = `
          <div class="image-field" data-image-field>
            <div class="image-preview">${v ? `<img src="${esc(assetUrl(v))}" alt="">` : '<i data-lucide="image"></i>'}</div>
            <div class="flex-grow-1 w-100">
              <input type="text" class="form-control" ${attrs} value="${esc(v)}" placeholder="https://... ou envie uma imagem">
              <div class="d-flex flex-wrap gap-2 mt-2">
                <label class="btn-saas btn-saas-outline btn-sm upload-label"><i data-lucide="upload"></i> Enviar imagem
                  <input type="file" accept="image/png,image/jpeg,image/gif,image/webp" data-upload>
                </label>
                <button type="button" class="btn-saas btn-saas-outline btn-sm" data-clear-image>Remover</button>
              </div>
            </div>
          </div>`;
        break;
      case "gallery": {
        const lines = Array.isArray(value) ? value.join("\n") : v;
        control = `
          <div data-gallery-field>
            <textarea class="form-control" rows="4" ${attrs} placeholder="https://...">${esc(lines)}</textarea>
            <div class="d-flex flex-wrap gap-2 mt-2">
              <label class="btn-saas btn-saas-outline btn-sm upload-label"><i data-lucide="upload"></i> Enviar imagens
                <input type="file" accept="image/png,image/jpeg,image/gif,image/webp" multiple data-upload-multiple>
              </label>
            </div>
            <div class="gallery-preview"></div>
          </div>`;
        break;
      }
      case "richtext":
        control = `<div class="rich-editor" id="${id}" data-richtext="${field.name}"></div>`;
        break;
      default:
        control = `<input type="text" class="form-control" ${attrs} value="${esc(v)}">`;
    }

    return `
      <div class="col-md-${field.col || 12}">
        <label class="form-label" for="${id}">${esc(field.label)}${req}</label>
        ${control}
        ${help}
        ${feedback}
      </div>`;
  }

  async function uploadFile(file) {
    const form = new FormData();
    form.append("file", file);
    const data = await api("/api/admin/uploads", { method: "POST", body: form, isForm: true });
    return data.url;
  }

  // Liga previews, uploads e editores depois que o HTML do formulário é inserido
  function bindFormWidgets(form, fields, values) {
    icons(form);

    form.querySelectorAll("[data-icon-input]").forEach((input) => {
      input.addEventListener("input", () => {
        input.parentElement.querySelector(".icon-preview i").className = iconClass(input.value, "bi-question");
      });
    });

    form.querySelectorAll("[data-color-picker]").forEach((picker) => {
      const text = picker.parentElement.querySelector("input[type=text]");
      picker.addEventListener("input", () => (text.value = picker.value));
    });

    form.querySelectorAll("[data-image-field]").forEach((wrap) => {
      const input = wrap.querySelector("input[type=text]");
      const preview = wrap.querySelector(".image-preview");
      const refresh = () => {
        const src = assetUrl(input.value.trim());
        preview.innerHTML = src ? `<img src="${esc(src)}" alt="" onerror="this.remove()">` : '<i data-lucide="image"></i>';
        icons(preview);
      };
      input.addEventListener("change", refresh);
      wrap.querySelector("[data-clear-image]").addEventListener("click", () => {
        input.value = "";
        refresh();
      });
      wrap.querySelector("[data-upload]").addEventListener("change", async (e) => {
        const file = e.target.files[0];
        e.target.value = "";
        if (!file) return;
        try {
          toast("Enviando imagem...");
          input.value = await uploadFile(file);
          refresh();
          toast("Imagem enviada.");
        } catch (error) {
          toast(error.message, "danger");
        }
      });
    });

    form.querySelectorAll("[data-gallery-field]").forEach((wrap) => {
      const textarea = wrap.querySelector("textarea");
      const preview = wrap.querySelector(".gallery-preview");
      const refresh = () => {
        preview.innerHTML = textarea.value
          .split("\n")
          .map((l) => l.trim())
          .filter(Boolean)
          .map((url) => `<img src="${esc(assetUrl(url))}" alt="" onerror="this.style.opacity=.3">`)
          .join("");
      };
      refresh();
      textarea.addEventListener("input", refresh);
      wrap.querySelector("[data-upload-multiple]").addEventListener("change", async (e) => {
        const files = [...e.target.files];
        e.target.value = "";
        for (const file of files) {
          try {
            const url = await uploadFile(file);
            textarea.value = (textarea.value.trim() ? textarea.value.trim() + "\n" : "") + url;
            refresh();
          } catch (error) {
            toast(`${file.name}: ${error.message}`, "danger");
          }
        }
        if (files.length) toast("Upload concluído.");
      });
    });

    form.querySelectorAll("[data-richtext]").forEach((el) => {
      const name = el.dataset.richtext;
      const quill = new Quill(el, {
        theme: "snow",
        placeholder: "Comece a digitar o conteúdo...",
        modules: {
          toolbar: [
            [{ header: [2, 3, false] }],
            ["bold", "italic", "underline", "strike"],
            [{ list: "ordered" }, { list: "bullet" }],
            ["link", "blockquote", "code-block", "image"],
            ["clean"],
          ],
        },
      });
      quill.root.innerHTML = values[name] || "";
      state.editors[name] = quill;
    });

    // Contatos: sugere o ícone ao trocar o tipo, se ainda estiver vazio
    const typeSelect = form.querySelector("select[name=type]");
    const iconInput = form.querySelector("input[name=icon]");
    if (typeSelect && iconInput && fields.some((f) => f.name === "type")) {
      typeSelect.addEventListener("change", () => {
        const match = CONTACT_TYPES.find(([v]) => v === typeSelect.value);
        if (match && !iconInput.value.trim()) {
          iconInput.value = match[2];
          iconInput.dispatchEvent(new Event("input"));
        }
      });
    }
  }

  function readForm(form, fields) {
    const data = {};
    fields.forEach((field) => {
      if (field.type === "richtext") {
        const quill = state.editors[field.name];
        const html = quill ? quill.root.innerHTML : "";
        data[field.name] = html === "<p><br></p>" ? "" : html;
        return;
      }
      const el = form.elements[field.name];
      if (!el) return;
      if (field.type === "checkbox") data[field.name] = el.checked;
      else if (field.type === "number") data[field.name] = el.value === "" ? null : Number(el.value);
      else if (field.type === "select" && field.optionsFrom) data[field.name] = el.value === "" ? null : Number(el.value);
      else if (field.type === "gallery") data[field.name] = el.value.split("\n").map((l) => l.trim()).filter(Boolean);
      else data[field.name] = el.value;
    });
    return data;
  }

  function showErrors(form, errors = {}) {
    form.querySelectorAll(".is-invalid").forEach((el) => el.classList.remove("is-invalid"));
    form.querySelectorAll(".is-invalid-editor").forEach((el) => el.classList.remove("is-invalid-editor"));
    form.querySelectorAll("[data-error-for]").forEach((el) => {
      el.textContent = "";
      el.style.display = "";
    });

    let first = null;
    Object.entries(errors).forEach(([name, message]) => {
      const feedback = form.querySelector(`[data-error-for="${name}"]`);
      const input = form.elements[name];
      if (input && input.classList) input.classList.add("is-invalid");
      const editor = form.querySelector(`[data-richtext="${name}"]`);
      if (editor) editor.parentElement.classList.add("is-invalid-editor");
      if (feedback) {
        feedback.textContent = message;
        feedback.style.display = "block";
        first = first || feedback;
      }
    });
    if (first) first.scrollIntoView({ behavior: "smooth", block: "center" });
  }

  async function submitForm(form, fields, save) {
    const btn = form.querySelector("[type=submit]");
    btn.disabled = true;
    const original = btn.innerHTML;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Salvando...';
    showErrors(form);
    try {
      await save(readForm(form, fields));
      return true;
    } catch (error) {
      if (error.fields && Object.keys(error.fields).length) showErrors(form, error.fields);
      toast(error.message, "danger");
      return false;
    } finally {
      btn.disabled = false;
      btn.innerHTML = original;
      icons(btn);
    }
  }

  async function renderForm(name, id) {
    const res = RESOURCES[name];
    const lookups = {};
    for (const lookup of Object.values(res.lookups || {})) lookups[lookup] = await loadLookup(lookup, true);

    const values = id ? await api(`/api/admin/${name}/${id}`) : {};
    if (!id && name === "skills" && lookups.skill_categories && lookups.skill_categories.length === 0) {
      view.innerHTML = `
        <div class="saas-card text-center py-5">
          <p>Cadastre uma categoria antes de adicionar habilidades.</p>
          <a class="btn-saas" href="#/skill_categories/novo">Criar categoria</a>
        </div>`;
      return;
    }

    view.innerHTML = `
      <a class="breadcrumb-link" href="#/${name}"><i data-lucide="arrow-left"></i> ${esc(res.title)}</a>
      <div class="page-header">
        <h1 class="page-title">${id ? `Editar ${esc(res.singular)}` : `${res.feminine ? "Nova" : "Novo"} ${esc(res.singular)}`}</h1>
      </div>
      <form class="saas-card" novalidate>
        <div class="row g-4">
          ${res.fields.map((f) => fieldHtml(f, values[f.name], { lookups })).join("")}
        </div>
        <div class="invalid-feedback" data-error-for="_"></div>
        <div class="form-actions">
          <a class="btn-saas btn-saas-outline" href="#/${name}">Cancelar</a>
          <button type="submit" class="btn-saas"><i data-lucide="save"></i> Salvar</button>
        </div>
      </form>`;

    const form = view.querySelector("form");
    bindFormWidgets(form, res.fields, values);

    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      const ok = await submitForm(form, res.fields, (data) =>
        api(id ? `/api/admin/${name}/${id}` : `/api/admin/${name}`, { method: id ? "PUT" : "POST", body: data })
      );
      if (ok) {
        toast(id ? "Alterações salvas." : "Registro criado.");
        location.hash = `#/${name}`;
      }
    });
  }

  /* =====================================================================
     Perfil
     ===================================================================== */
  async function renderProfile() {
    const values = await api("/api/admin/profile");
    const fields = PROFILE_SECTIONS.flatMap((s) => s.fields);

    view.innerHTML = `
      <div class="page-header">
        <div>
          <h1 class="page-title">Perfil e textos</h1>
          <p class="page-subtitle">Conteúdo fixo das seções do site.</p>
        </div>
      </div>
      <form novalidate>
        ${PROFILE_SECTIONS.map((section) => `
          <div class="saas-card">
            <h2 class="card-section-title">${esc(section.title)}</h2>
            <p class="card-section-subtitle">${esc(section.subtitle)}</p>
            <div class="row g-4">${section.fields.map((f) => fieldHtml(f, values[f.name], { lookups: {} })).join("")}</div>
          </div>`).join("")}
        <div class="form-actions" style="border-top:none">
          <a class="btn-saas btn-saas-outline" href="index.html" target="_blank" rel="noopener"><i data-lucide="external-link"></i> Ver no site</a>
          <button type="submit" class="btn-saas"><i data-lucide="save"></i> Salvar perfil</button>
        </div>
      </form>`;

    const form = view.querySelector("form");
    bindFormWidgets(form, fields, values);
    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      const ok = await submitForm(form, fields, (data) => api("/api/admin/profile", { method: "PUT", body: data }));
      if (ok) toast("Perfil atualizado.");
    });
  }

  /* =====================================================================
     Conta
     ===================================================================== */
  function renderAccount() {
    const fields = [
      { name: "current_password", label: "Senha atual", required: true },
      { name: "new_password", label: "Nova senha", required: true, help: "Mínimo de 8 caracteres." },
      { name: "confirm_password", label: "Confirme a nova senha", required: true },
    ];
    view.innerHTML = `
      <div class="page-header">
        <div>
          <h1 class="page-title">Alterar senha</h1>
          <p class="page-subtitle">Conectado como ${esc(state.user && state.user.email)}</p>
        </div>
      </div>
      <form class="saas-card" style="max-width:560px" novalidate>
        <div class="row g-4">
          ${fields.map((f) => `
            <div class="col-12">
              <label class="form-label" for="f-${f.name}">${esc(f.label)}<span class="req">*</span></label>
              <input type="password" class="form-control" id="f-${f.name}" name="${f.name}" required autocomplete="${f.name === "current_password" ? "current-password" : "new-password"}">
              ${f.help ? `<div class="form-text">${esc(f.help)}</div>` : ""}
              <div class="invalid-feedback" data-error-for="${f.name}"></div>
            </div>`).join("")}
        </div>
        <div class="form-actions">
          <button type="submit" class="btn-saas"><i data-lucide="key-round"></i> Atualizar senha</button>
        </div>
      </form>`;
    icons(view);

    const form = view.querySelector("form");
    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      const ok = await submitForm(form, fields, (data) => {
        if (data.new_password !== data.confirm_password) {
          const error = new Error("As senhas não conferem.");
          error.fields = { confirm_password: "As senhas não conferem." };
          throw error;
        }
        return api("/api/admin/account/password", {
          method: "PUT",
          body: { current_password: data.current_password, new_password: data.new_password },
        });
      });
      if (ok) {
        form.reset();
        toast("Senha atualizada.");
      }
    });
  }

  /* =====================================================================
     Inicialização
     ===================================================================== */
  async function init() {
    state.token = readToken();
    if (!state.token) return showLogin();
    try {
      const { user } = await api("/api/auth/me");
      state.user = user;
      showApp();
    } catch (error) {
      if (error.status !== 401) showLogin(error.message);
    }
  }

  init();
})();
