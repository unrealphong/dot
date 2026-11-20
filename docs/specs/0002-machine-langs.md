# 0002: Tắt ngôn ngữ theo từng máy

- **Trạng thái:** đã làm
- **Ngày:** 2026-11-20
- **PR:** [#5](https://github.com/unrealphong/dot/pull/5)
- **Liên quan:** [config/mise/config.toml](../../config/mise/config.toml), [install.sh](../../install.sh), [Brewfile](../../Brewfile), [Brewfile.apps](../../Brewfile.apps), [scripts/drift.sh](../../scripts/drift.sh), [config/nvim/lua/configs/tools.lua](../../config/nvim/lua/configs/tools.lua), [docs/shell.md](../shell.md)

## Bối cảnh

Repo cài cùng một bộ ngôn ngữ cho mọi máy: .NET SDK và ba công cụ C# cho nvim (mise), Go (mise), Rust (bước `rust` của `install.sh`, `lld` và `lldb` trong Brewfile), Rider (IDE C#, `Brewfile.apps`), cùng gói Mason của Go và Rust. Máy chính hiện không code C#, Go, Rust nữa; trên máy đó chúng chiếm khoảng 16 GB: Rider 6,3 GB, phần còn lại là SDK, cache NuGet, module Go và `llvm` mà `lld`/`lldb` kéo theo.

Gỡ tay thì không bền: `./install.sh` cài lại, mason-tool-installer cài lại gói Mason mỗi lần mở nvim, mà gopls, goimports, delve phải build bằng `go` nên khi thiếu go là lần mở nào cũng báo lỗi.

## Mục tiêu

- Một máy tắt được C#, Go, Rust mà không sửa file chung; máy khác và máy mới vẫn cài đủ như trước.
- Tắt rồi thì `./install.sh`, mở nvim và `scripts/drift.sh` không cài lại, không báo lỗi, không báo lệch.
- Ngoài phạm vi: bỏ hẳn một ngôn ngữ khỏi repo. Plugin nvim của C# và Rust (roslyn.nvim, rustaceanvim, crates.nvim) và parser treesitter vẫn cài: chúng nhỏ, lockfile dùng chung, và chỉ chạy khi mở file của ngôn ngữ đó.

## Thiết kế

Một danh sách riêng của máy: `disable_tools` của mise trong `~/.config/mise/config.local.toml`. Theo tài liệu mise (configuration), `config.local.toml` giữ "machine-specific values" và file local đè lên file chung cùng thư mục; `disable_tools` là "Tools mise ignores even when a config file lists them". `~/.config/mise` là link vào `config/mise`, nên file nằm trong checkout và được `.gitignore` chặn, giống `config/fish/fish_variables`.

| Thành phần | Đọc danh sách thế nào |
|---|---|
| mise (`dotnet`, `go`, công cụ C#) | mise tự bỏ qua. Tên phải khớp từng tool: `dotnet` không kéo theo `dotnet:*` |
| Bước `rust` của `install.sh` | `mise settings get disable_tools` có `"rust"` thì bỏ qua. `rust` cũng là tên tool của mise, nên mục đó vẫn đúng nghĩa với mise |
| Brewfile, Brewfile.apps | gói chỉ một ngôn ngữ cần thì đánh dấu `unless off.("<tool>")`: `lld`, `lldb` theo `rust`, Rider theo `dotnet`. brew chạy Brewfile với PATH rút gọn (`shims/shared:/usr/bin:/bin:...`) và lọc biến `MISE_*`, nên `off` gọi `#{HOMEBREW_PREFIX}/bin/mise`; máy chưa có mise thì không tắt gì và cài đủ |
| `scripts/drift.sh` | đọc Brewfile bằng `sed` chứ không chạy Ruby, nên tự bỏ các dòng `unless off.("<tool>")` có tool đã tắt (như đã làm với `if OS.mac?`) |
| nvim (`tools.lua`) | `condition` có sẵn của mason-tool-installer: gói Go khi có lệnh `go`, gói Rust khi có `cargo` |

nvim nhìn lệnh có trên máy chứ không đọc danh sách của mise: như vậy đơn giản hơn, và cũng đúng cho máy thiếu go vì lý do khác (Linux mới, PATH của phiên chưa có mise).

## Phương án đã cân nhắc

- **Bỏ hẳn khỏi repo**: đơn giản nhất nhưng máy khác mất theo; người dùng chọn giữ trong repo.
- **Mở rộng `DOT_PROFILES` cho ngôn ngữ**: biến này chỉ sống trong một lần chạy `install.sh`. Muốn bền thì phải thêm một file riêng của máy, trong khi mise vẫn cần danh sách của nó, thành hai chỗ khai báo.
- **`MISE_DISABLE_TOOLS` đặt trong shell** (biến universal của fish, `.zshenv`): phải đặt ở mọi shell, brew lọc mất biến, ứng dụng mở từ GUI không thấy.
- **Tách go, dotnet ra `conf.d/*.toml` hay `config.<env>.toml`**: thư mục được link nguyên vào repo nên máy nào cũng thấy các file đó; còn `MISE_ENV` lại là một biến môi trường.

## Đánh đổi và đường lui

- Rust dùng chung danh sách của mise dù rustup cài ngoài mise.
- Brewfile gọi mise mỗi lần brew đọc nó (vài chục ms). mise cài ngoài Homebrew thì Brewfile không thấy mise, và cài `lld`/`lldb` như mặc định.
- Máy mới muốn tắt ngay từ đầu thì tạo `config/mise/config.local.toml` trong checkout trước khi chạy `./install.sh`. Riêng các gói `unless off.(...)` (`lld`, `lldb`, Rider) vẫn được cài ở lần đầu vì Brewfile được đọc trước khi có mise; gỡ sau theo [docs/shell.md](../shell.md).
- Đường lui: bỏ tên khỏi danh sách (hoặc xoá file) rồi `./install.sh brew mise rust nvim`. Revert PR thì mọi máy cài đủ như cũ.

## Kiểm chứng

- mise với HOME giả có `config.local.toml`: `mise config ls` thấy file, `mise install --dry-run` không còn tool đã tắt. Thử `MISE_DISABLE_TOOLS=go,dotnet` thì `dotnet:roslyn-language-server` vẫn được cài, nên phải ghi đủ tên.
- Brewfile nháp chạy qua `brew bundle list`: PATH bên trong không có `/opt/homebrew/bin`, và không thấy `MISE_DISABLE_TOOLS`. Gọi mise bằng `HOMEBREW_PREFIX` thì HOME thật cho ra `lld`, `lldb`, `rider`; HOME giả tắt `rust` và `dotnet` thì không; không tắt gì thì `brew bundle list --all` giống hệt bản trên `main`.
- `./install.sh rust` với HOME giả: có `"rust"` thì in "bỏ qua", không có thì gọi stub `curl`.
- `scripts/drift.sh` với HOME thật và HOME giả đã tắt: bản giả báo `lld`, `lldb`, `rider` là "đã cài mà chưa khai báo" (đúng, máy đó cần gỡ), không báo thiếu.
- nvim: `require "configs.tools"` với PATH có và không có `go`/`cargo`.
