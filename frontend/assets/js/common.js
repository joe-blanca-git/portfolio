/* Helpers compartilhados entre o site e o painel admin */
(function () {
  "use strict";

  const API = String(window.API_BASE_URL || "").replace(/\/+$/, "");

  const PLACEHOLDER_IMG = "https://placehold.co/800x500/eef3f9/065cc2?text=Joeder+Blanca";

  function escapeHtml(value) {
    return String(value ?? "").replace(/[&<>"']/g, (c) => ({
      "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;",
    })[c]);
  }

  function safeUrl(value) {
    const url = String(value || "").trim();
    return /^(javascript|data|vbscript):/i.test(url) ? "" : url;
  }

  // Imagens enviadas pelo painel ficam em /uploads no backend
  function assetUrl(value) {
    const url = safeUrl(value);
    if (!url) return "";
    return url.startsWith("/uploads/") ? API + url : url;
  }

  // Aceita "bi-code" ou "bi bi-code"; qualquer outra coisa vira um ícone padrão
  function iconClass(value, fallback = "bi-star") {
    const name = String(value || "").trim().replace(/^bi\s+/, "");
    return /^bi-[\w-]+$/.test(name) ? `bi ${name}` : `bi ${fallback}`;
  }

  function safeColor(value) {
    return /^#[0-9a-f]{3,8}$/i.test(value || "") ? value : "";
  }

  const imgFallback = `onerror="this.onerror=null;this.src='${PLACEHOLDER_IMG}'"`;

  async function request(path, { method = "GET", body, token, isForm = false } = {}) {
    const headers = {};
    if (token) headers.Authorization = `Bearer ${token}`;
    if (body !== undefined && !isForm) headers["Content-Type"] = "application/json";

    let response;
    try {
      response = await fetch(API + path, {
        method,
        headers,
        body: body === undefined ? undefined : isForm ? body : JSON.stringify(body),
      });
    } catch (err) {
      const error = new Error("Não foi possível conectar à API. Verifique se o backend está rodando.");
      error.status = 0;
      throw error;
    }

    let data = null;
    try {
      data = await response.json();
    } catch {
      data = null;
    }

    if (!response.ok) {
      const error = new Error((data && data.error) || `Erro HTTP ${response.status}`);
      error.status = response.status;
      error.fields = (data && data.fields) || {};
      throw error;
    }
    return data;
  }

  // DOMParser não carrega imagens nem executa handlers do HTML recebido
  function sanitizeHtml(html) {
    const doc = new DOMParser().parseFromString(String(html || ""), "text/html");
    doc.querySelectorAll("script, style, iframe, object, embed, form, link, meta").forEach((el) => el.remove());
    doc.querySelectorAll("*").forEach((el) => {
      [...el.attributes].forEach((attr) => {
        const isHandler = attr.name.startsWith("on");
        const isBadUrl = ["href", "src", "xlink:href"].includes(attr.name) && !safeUrl(attr.value);
        if (isHandler || isBadUrl) el.removeAttribute(attr.name);
      });
    });
    doc.querySelectorAll("a[href]").forEach((a) => {
      a.target = "_blank";
      a.rel = "noopener";
    });
    return doc.body.innerHTML;
  }

  window.Portfolio = {
    API,
    PLACEHOLDER_IMG,
    imgFallback,
    escapeHtml,
    safeUrl,
    assetUrl,
    iconClass,
    safeColor,
    sanitizeHtml,
    request,
  };
})();
