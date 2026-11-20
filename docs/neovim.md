# Neovim

Cấu hình thuần Neovim 0.12, không dùng NvChad (bản distribution) hay lazy.nvim. Những gì Neovim đã có sẵn thì dùng bản gốc: `vim.pack` (quản lý plugin), `vim.lsp.config` / `vim.lsp.enable`, completion và snippet LSP (`vim.lsp.completion`, `vim.snippet`), `gc` để comment, treesitter highlight. Giao diện (statusline, tabufline, nvdash, đổi theme) vẫn là plugin `nvchad/ui` + `nvchad/base46`, chạy độc lập.

File này nói cấu hình được dựng thế nào. Cách dùng hằng ngày (phím tắt, debug, quy trình C#) ở [config/nvim/README.md](../config/nvim/README.md).

## Bố cục

Trong `config/nvim/`:

```
init.lua                 vào cấu hình
lua/plugins.lua          danh sách plugin (vim.pack) + hook build
lua/options.lua          tuỳ chọn (gồm mặc định NvChad đã chép lại)
lua/mappings.lua         phím tắt (giữ nguyên bộ phím NvChad)
lua/autocmds.lua         indent theo ngôn ngữ, viết tài liệu, Java
lua/configs/             lspconfig, conform, dap, jdtls, reading, rust, scaffold (:Scaffold), tools (danh sách Mason), ui, writing
after/lsp/<tên>.lua      cấu hình riêng của từng LSP server (xem mục LSP bên dưới)
nvim-pack-lock.json      commit của từng plugin (đưa vào git)
README.md                cách dùng: phím tắt và quy trình làm việc
```

## Plugin và công cụ

- Plugin ghim bằng `nvim-pack-lock.json`: máy mới mở nvim (hoặc `./install.sh nvim`) là cài đúng commit.
- Cập nhật plugin: `:lua vim.pack.update()`, xem thay đổi, `:write` để chấp nhận, rồi commit lockfile. Hoàn lại: `git checkout HEAD -- nvim-pack-lock.json` rồi `:restart`.
- Công cụ (LSP, formatter, debug adapter) khai báo một chỗ trong `lua/configs/tools.lua`; `mason-tool-installer` tự cài những gói còn thiếu. Cài lại bằng tay: `:MasonToolsInstall`. Gói của Go chỉ cài khi có lệnh `go`, của Rust khi có `cargo`, để máy đã tắt hai ngôn ngữ đó ([shell.md](shell.md), mục Tắt một ngôn ngữ trên một máy) không cài thừa.
- Cài plugin bị ngắt giữa chừng: khởi động sau sẽ tự xoá thư mục hỏng và cài lại.
- Ba plugin cho việc đọc code, cấu hình ở `lua/configs/reading.lua`: `todo-comments.nvim` (nhãn trong comment, tìm bằng `:TodoTelescope`), `nvim-highlight-colors` (ô màu cạnh giá trị màu, kể cả class Tailwind), `gitlinker.nvim` (link GitHub của dòng đang đứng, cần Neovim 0.12). Phím ở [config/nvim/README.md](../config/nvim/README.md).

## LSP

- `lua/configs/lspconfig.lua` giữ phần dùng chung: danh sách server đưa cho `vim.lsp.enable`, cấu hình `"*"` (tắt semantic tokens), và `LspAttach` (completion gốc của Neovim, phím tắt, tắt `document_color` vì colorify của nvchad/ui đã lo, cắt bớt pyright ở project Odoo).
- Cấu hình riêng của từng server ở `after/lsp/<tên>.lua`, mỗi file `return` một bảng. Neovim nạp mọi `lsp/<tên>.lua` trên runtimepath và `after/` nạp sau cùng, nên bảng này merge **lên** dữ liệu `lsp/<tên>.lua` của nvim-lspconfig. Thêm server mới: thêm tên vào danh sách trong `lspconfig.lua`, cần sửa gì thì tạo thêm file trong `after/lsp/`.
- Hai file là định nghĩa trọn vẹn vì nvim-lspconfig không có: `after/lsp/roslyn.lua` (nvim-lspconfig chỉ có `roslyn_ls`, không hỗ trợ Razor; server do roslyn.nvim tự bật, không qua `vim.lsp.enable`) và `after/lsp/odoo_ls.lua`.
- Sửa `after/lsp/` xong, cách chắc nhất để biết không đổi hành vi: dump `vim.lsp.config[<tên>]` của mọi server ra file trước và sau rồi `diff` (xem bảng Kiểm chứng trong [AGENTS.md](../AGENTS.md)).

## C# / .NET

- LSP là `roslyn.nvim` (có Razor, tức `.cshtml` và `.razor`; `roslyn_ls` của nvim-lspconfig thì không). Ba công cụ cài bằng `mise install` chứ không qua Mason, vì Mason đang giữ `roslyn-language-server` cũ hơn mức roslyn.nvim yêu cầu và `netcoredbg` chỉ có bản x86_64 (macOS arm64 phải chạy qua Rosetta). Debug: `netcoredbg` qua nvim-dap, cấu hình "C#: build and launch" tự `dotnet build` rồi chạy dll của project.
- `:Scaffold` (`<leader>cs`) làm việc như "Add > New Scaffolded Item" của Visual Studio: đứng trong file model, chọn controller + view (MVC), một view riêng, Razor Pages, Blazor hoặc Minimal API. Model lấy từ class đang đứng, DbContext tự tìm trong project (không thấy thì hỏi tên), file sinh ra mở ngay và nằm trong quickfix (`<leader>ql`). `:Scaffold!` ghi đè file đã có. Engine là `dotnet-aspnet-codegenerator`, nên project cần các package `Microsoft.VisualStudio.Web.CodeGeneration.Design` và `Microsoft.EntityFrameworkCore.SqlServer` / `.Tools` (Blazor thêm `Microsoft.AspNetCore.Components.QuickGrid`, Minimal API thêm `Microsoft.AspNetCore.OpenApi` nếu bật OpenAPI); thiếu gói nào tool tự báo.

## Odoo

`odoo_ls` chỉ gắn vào `python` và `xml` khi project có `odools.toml`. Binary và typeshed do `./install.sh odoo` cài, bản và sha256 ghim trong `scripts/odoo-ls.sh`. Nâng bản: sửa `VERSION` và sha256 theo trang release, đọc ghi chú phát hành và `config_schema.json` của release đó trước (khoá của `odools.toml` có thể đổi). Bản cũ được giữ thành `odoo_ls_server.<bản cũ>` và `typeshed.<bản cũ>`; quay lại bằng `mv` ngược.

OdooLS chỉ gợi ý phần Odoo: model và field (`self.env["res.pa`, `fields.Ch`), thành viên của record và module (`self.`, `os.`), tên module sau `import`. Nó **không** gợi ý builtin (`isinstance`), từ khoá (`return`) hay tên sau `from x import`. Vì vậy ở project Odoo pyright vẫn chạy, nhưng chỉ để bù phần đó (`after/lsp/pyright.lua`):

- Dùng python và `odoo_path` mà `odools.toml` chỉ tới, nên `from odoo import ` cũng có gợi ý.
- Không báo diagnostics (`analysis.ignore = ["**"]`): đọc mã Odoo bằng kiểu tĩnh thì báo sai rất nhiều, còn odoo_ls và ruff đã báo.
- Chỉ giữ completion và signature help. Hover, go to definition, references, symbol để odoo_ls, nên `K` / `gd` không ra kết quả đôi.
- Không gợi ý sau dấu chấm. pyright không biết field / model của Odoo nên chỉ trả về thành viên của `BaseModel`, trùng gần hết với odoo_ls (`params.` từng ra 523 mục, 226 mục bị đôi).

Còn trùng nhẹ ở đầu từ: tên cục bộ hay tên đã import (`fields`, `api`) có thể hiện hai lần, một của mỗi server. Plugin chính thức [odoo/odoo-neovim](https://github.com/odoo/odoo-neovim) cảnh báo khi pyright chạy cùng (tính năng chồng nhau); cách cắt bớt ở trên là để tránh đúng chỗ chồng đó.

Lần đầu mở project, OdooLS mất khoảng 10 giây để nạp module (máy này: 1249 module). Trong lúc đó chỉ có gợi ý của pyright.
