-- Project Python thường: pyright lo đủ (gợi ý, hover, go to definition, kiểm kiểu).
--
-- Project Odoo (có odools.toml): odoo_ls lo phần Odoo (model, field, thành viên của record) nhưng không gợi ý
-- builtin, từ khoá hay tên sau `from x import`, nên pyright vẫn chạy để bù đúng phần đó. Nó dùng python và mã
-- Odoo mà odools.toml chỉ tới, và không báo diagnostics: đọc mã Odoo bằng kiểu tĩnh thì báo sai nhiều, còn
-- odoo_ls với ruff đã báo. Phần bỏ hover / go to definition và gợi ý sau dấu chấm ở LspAttach trong
-- lua/configs/lspconfig.lua.

-- Chuỗi `<key> = "..."` đầu tiên trong odools.toml, ${workspaceFolder} thay bằng gốc project
local function odools(root, key)
  local file = io.open(root .. "/odools.toml")
  if not file then
    return nil
  end
  local value = ("\n" .. file:read "*a"):match("\n%s*" .. key .. '%s*=%s*"([^"]*)"')
  file:close()
  return value and (value:gsub("%${workspaceFolder}", function()
    return root
  end))
end

return {
  root_dir = function(bufnr, on_dir)
    local file = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(file, "odools.toml")
      or vim.fs.root(file, {
        "pyrightconfig.json",
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        ".git",
      })
    on_dir(root or vim.fs.dirname(file))
  end,
  before_init = function(_, config)
    local root = config.root_dir
    if not (root and vim.uv.fs_stat(root .. "/odools.toml")) then
      return
    end
    -- Sửa tại chỗ: client.settings chính là bảng config.settings
    local python = config.settings.python
    python.pythonPath = odools(root, "python_path")
    python.analysis = vim.tbl_extend("force", python.analysis or {}, {
      extraPaths = { odools(root, "odoo_path") }, -- để `from odoo import ...` có gợi ý
      ignore = { "**" }, -- tắt mọi diagnostics của pyright
      autoImportCompletions = false, -- gợi ý import tự động từ cả cây mã Odoo thì quá nhiều
    })
  end,
  settings = { pyright = { disableOrganizeImports = true } }, -- để ruff lo import
}
