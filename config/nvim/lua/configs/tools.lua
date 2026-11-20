-- Tên package Mason; mason-tool-installer tự cài những gói còn thiếu (xem configs/mason.lua).
-- Gói của Go và Rust chỉ cài khi máy có go / cargo: máy tắt hai ngôn ngữ đó (disable_tools của mise,
-- docs/shell.md) thì không cài thừa, cũng không báo lỗi mỗi lần mở nvim vì gopls, goimports, delve build bằng go.
local function has(cmd)
  return function()
    return vim.fn.executable(cmd) == 1
  end
end
local go, rust = has "go", has "cargo"

return {
  -- LSP: web / frontend
  "typescript-language-server",
  "eslint-lsp",
  "html-lsp",
  "css-lsp",
  "tailwindcss-language-server",
  "emmet-language-server",
  "json-lsp",
  "yaml-language-server",
  "prisma-language-server",

  -- LSP: backend
  { "gopls", condition = go },
  { "golangci-lint-langserver", condition = go },
  "pyright",
  "ruff",
  { "rust-analyzer", condition = rust },
  "jdtls",

  -- LSP: khác
  "lua-language-server",
  "taplo",
  "marksman",
  "texlab",
  "tinymist",
  "clangd",

  -- Formatter / linter
  "stylua",
  "prettier",
  "clang-format",
  { "gofumpt", condition = go },
  { "goimports", condition = go },
  { "golangci-lint", condition = go },

  -- Debug adapter
  { "codelldb", condition = rust }, -- chỉ rustaceanvim dùng, configs/dap.lua không cấu hình C/C++
  { "delve", condition = go },
  "debugpy",
  "js-debug-adapter",
  "java-debug-adapter",
  "java-test",

  "tree-sitter-cli",
}
