/**
 * Endereço da API.
 * - Vazio: usa o mesmo domínio da página (backend servindo o frontend).
 * - Em produção com domínios separados, coloque a URL do backend, ex.:
 *   window.API_BASE_URL = "https://api.seudominio.com.br";
 */
window.API_BASE_URL = window.API_BASE_URL ?? (location.protocol === "file:" ? "http://localhost:5000" : "");
