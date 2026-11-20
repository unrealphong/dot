# Changelog

Những thay đổi đáng kể của repo, mới nhất ở trên. Repo không đánh số phiên bản nên nhóm theo ngày merge; trong mỗi ngày chia **Thêm / Đổi / Sửa / Bỏ** theo tinh thần [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). `#số` là PR của repo này; `tvb#số` là PR ở repo cũ [phonglh-tvb/dot](https://github.com/phonglh-tvb/dot), nơi repo nằm tới 2026-11-20 (cùng nội dung lịch sử; khi chuyển, commit được viết lại với tác giả unrealphong nên SHA khác repo cũ); mã 7 ký tự là commit từ trước khi repo dùng PR. Thiết kế của các việc lớn ở [docs/specs/](docs/specs/README.md).

Cách ghi một dòng mới: mục Commit và PR trong [AGENTS.md](AGENTS.md).

## 2026-11-21

### Thêm

- Mỗi máy tự tắt được C#, Go, Rust mà không bỏ khỏi repo: liệt kê chúng trong `disable_tools` của `~/.config/mise/config.local.toml` (file riêng của máy, không vào repo). Khi đó `./install.sh` không cài .NET SDK, Go, rustup, `lld`/`lldb`, Rider; nvim không cài gói Mason của Go và Rust; `scripts/drift.sh` không báo thiếu chúng. Cách tắt và thứ tự gỡ ở [docs/shell.md](docs/shell.md). [#5]

## 2026-11-20

### Đổi

- Repo chuyển sang [unrealphong/dot](https://github.com/unrealphong/dot). Toàn bộ lịch sử được viết lại với tác giả unrealphong (nội dung, thông điệp và ngày giữ nguyên, SHA đổi); commit từ nay cũng bằng tài khoản này (danh tính đặt trong `.git/config` của checkout, danh tính chung của máy không đổi). Nhánh chính là `main`: lịch sử chuyển sang nằm ở nhánh `master` và đã merge vào `main` [#3]; PR merge bằng fast-forward từ máy nên commit nào cũng do unrealphong commit và ký. PR cũ ghi là `tvb#số` và vẫn trỏ về [phonglh-tvb/dot](https://github.com/phonglh-tvb/dot). [#4]

### Sửa

- Project Odoo lại có gợi ý Python chung khi gõ: builtin (`isinstance`), từ khoá (`return`), tên sau `from odoo import`. odoo_ls không gợi ý những thứ đó, nên pyright chạy thêm nhưng chỉ để gợi ý (không diagnostics, không hover hay go to definition, không gợi ý sau dấu chấm để khỏi trùng với odoo_ls). Chi tiết ở [docs/neovim.md](docs/neovim.md). [#2]

## 2026-11-16

### Thêm

- `git mergetool` (và mục "Open external merge tool" của lazygit, phím `M`) mở nvim thay vì `opendiff`: LOCAL | BASE | REMOTE ở trên, file đang sửa ở dưới; không hỏi trước mỗi file, không để lại file `.orig`. Cách dùng và các chỗ dễ vấp ở [docs/git.md](docs/git.md). [tvb#34]

### Sửa

- `Alt-h` / `Alt-j` / `Alt-k` / `Alt-l` trong tmux đổi kích thước pane như `tmux.conf` vốn định, thay vì chọn pane (tmux-tilish gán đè; chọn pane vẫn là `Ctrl-h/j/k/l`). Trong nvim phím được gửi cho nvim, nên `Alt-h` bật terminal ngang của NvChad lại dùng được trong tmux. [tvb#33]

## 2026-11-15

### Thêm

- Phím git trong Neovim: `]c` / `[c` nhảy giữa các đoạn thay đổi, `Space gp` xem, `Space gh` stage hoặc bỏ stage (visual mode: chỉ các dòng chọn), `Space gb` / `Space gB` blame dòng / cả file. Phím chép: `Space yf` / `Space yp` chép đường dẫn kèm dòng (`src/app.ts#L42`), visual `Space cc` chép vùng chọn thành khối code Markdown kèm tên file. Vùng vừa yank nháy sáng. Bảng phím ở [config/nvim/README.md](config/nvim/README.md). [tvb#31]
- Ba plugin Neovim cho việc đọc code: nhãn `TODO` / `FIXME` được tô màu và tìm bằng `Space ft`, nhảy giữa các nhãn bằng `]n` / `[n`; ô màu hiện cạnh giá trị màu và class Tailwind; `Space gl` / `Space gL` chép hoặc mở link GitHub của dòng đang đứng. Phím đầy đủ ở [config/nvim/README.md](config/nvim/README.md). [tvb#28]
- Hai hàm fish: `wt` chọn worktree của repo hiện tại bằng fzf rồi `cd` vào, `cpwd` chép đường dẫn thư mục hiện tại vào clipboard. [tvb#27]
- [docs/shell.md](docs/shell.md) có bảng các hàm fish và mục về mise: fish và zsh bật mise theo hai cơ chế khác nhau. [tvb#27]
- Cấu hình `lazygit` ([config/lazygit/config.yml](config/lazygit/config.yml)): màu Rose Pine như tmux và Neovim, icon Nerd Font, diff đi qua `delta`, không tự fetch, và `<c-n>` ở bảng Files soạn commit bằng `cz`. Đường dẫn cấu hình do `LG_CONFIG_FILE` đặt trong fish và `.zshenv`, vì lazygit trên macOS không đọc `~/.config`. [tvb#26]
- Phím tmux: `prefix G` mở lazygit trong popup, `prefix O` mở thư mục của pane bằng Finder, `prefix e` đóng mọi pane khác (hỏi lại trước). [tvb#26]
- [docs/shell.md](docs/shell.md) có mục tmux: bảng phím của repo, phím của plugin, và các phím `Alt` do `tmux-tilish` chiếm. [tvb#26]
- [docs/git.md](docs/git.md): bố cục cấu hình git trong repo, bảng alias, lệnh `cz`, phần diff và merge. [tvb#25]
- Alias git mới: `git ba` / `bm` / `bn` (liệt kê nhánh), `git hist` (graph mọi nhánh), `git open` (mở repo trên GitHub), và `git unmerged` / `edit-unmerged` / `add-unmerged` cho lúc merge đang xung đột. [tvb#25]
- `cz` (commitizen) trong `Brewfile` và `.cz.toml` ở gốc repo: `cz c` hỏi loại, khu vực, mô tả rồi ghép thành commit message; chọn loại bằng một phím, commit bị hook chặn thì lần sau hỏi dùng lại message vừa gõ. `cz check -m "<message>"` kiểm message gõ tay. [tvb#24]

### Đổi

- LSP trong Neovim bớt làm phiền: `lua_ls` không còn hiện hộp thoại hỏi "configure your work environment" khi gặp chữ như `love.` hay `ngx.`; `cssls` không còn cảnh báo khối CSS / SCSS / Less rỗng (các lỗi khác vẫn báo). [tvb#32]
- Float của Neovim trước đây không viền (hover `K`, popup gitsigns, Mason) nay có viền `single`, cùng kiểu với các float NvChad vẽ sẵn. [tvb#31]
- Cấu hình LSP của Neovim tách theo server: `lua/configs/lspconfig.lua` chỉ còn phần dùng chung, mỗi server một file `after/lsp/<tên>.lua`. Hành vi không đổi. [tvb#29]
- mise đọc `.nvmrc` và `.node-version` của từng project, nên node theo bản project ghi thay vì bản `latest` toàn cục. Project ghi bản chưa cài thì lần đầu vào đó mise tự tải. [tvb#27]
- Commit message của repo theo [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/): `feat(nvim): add C# support` thay cho `nvim: add C# support`; gói và runtime dùng loại `build`. Quy ước đầy đủ ở [AGENTS.md](AGENTS.md); lịch sử cũ giữ nguyên, không sửa lại. [tvb#24]

### Sửa

- Neovim trong tmux in comment nghiêng và gạch chân cong có màu dưới lỗi LSP: `TERM` trong pane đổi từ `screen-256color` (không hỗ trợ hai thứ đó) sang `tmux-256color`. Chỉ pane mở sau khi nạp lại cấu hình mới nhận; gạch chân cong cần terminal ngoài là Ghostty, xem [docs/shell.md](docs/shell.md). [tvb#30]
- `git ci` trước đây luôn lỗi (`'checkin' is not a git command`), nay là `git commit`. [tvb#25]

## 2026-11-13

### Thêm

- SQL Server 2022 trong `docker/docker-compose.yml`: profile `mssql`, cổng 1433, container `mssql-dev`, volume `mssql-data`; mật khẩu `sa` lấy từ biến `MSSQL_SA_PASSWORD`, không có mặc định. [tvb#23]
- `CHANGELOG.md` (file này) và `docs/specs/` để viết spec trước khi làm việc lớn; spec đầu tiên là [SQL Server trên VM Lima](docs/specs/0001-lima-mssql.md). [tvb#22]

### Đổi

- README gọn lại: phần Neovim, Docker và Lima, Linux, Shell và SSH chuyển sang `docs/`. [tvb#22]
- Ghostty mở cửa sổ phóng to sẵn, font JetBrains Mono NL 14, padding theo màu viền, Option trái làm Alt, copy khi chọn, khôi phục cửa sổ, quick terminal bằng Option+`` ` ``. [tvb#21]

### Bỏ

- Ghostty: `TERM=xterm-256color` và keybind backspace; `xterm-ghostty` đã khớp phím và có truecolor. [tvb#21]

## 2026-11-08

### Thêm

- `config/nvim/README.md`: cách dùng Neovim hằng ngày (phím tắt cho file, LSP, terminal, debug; quy trình C#), thay bản mẫu của NvChad. [tvb#20]

## 2026-11-05

### Thêm

- C# trong Neovim: LSP `roslyn.nvim` (có Razor), debug bằng `netcoredbg`, lệnh `:Scaffold` sinh controller, view, Razor Pages, Blazor, Minimal API từ model đang đứng. Công cụ cài bằng mise. [tvb#19]

## 2026-10-31

### Thêm

- fish nạp khoá SSH từ Keychain một lần cho mỗi agent (macOS), để ký commit không hỏi lại passphrase sau khi khởi động máy. [tvb#18]
- `navi` cho phím `prefix C-g` của tmux. [tvb#14]
- Bước `./install.sh odoo`: OdooLS và typeshed ghim bản kèm sha256, bản cũ giữ lại bên cạnh. [tvb#9]
- `lima/dev.yaml` và bước `./install.sh lima`; `scripts/docker-clean.sh`; hadolint trong CI; `dive`, `lazydocker`, `oha`; mặc định SSH dùng chung `config/ssh/defaults.conf` (tự bật bằng tay). [tvb#7]
- Theo dõi cấu hình `gh`, `zed`, `karabiner`, `.gitalias`; file `.link-each` để chỉ link từng file trong thư mục; `fastfetch`. [tvb#8]
- Hỗ trợ Debian, Ubuntu, Pop!_OS: bước `apt` và `fonts`, `Aptfile`, `scripts/fonts.sh`, job CI `install-linux`. [tvb#6]
- CI: shellcheck, shfmt, stylua, actionlint, gitleaks; dựng cấu hình trong HOME giả trên Ubuntu và macOS. [tvb#5]
- `scripts/drift.sh` so máy với khai báo; bước `rust`; pnpm trong mise. [tvb#3]
- Cấu hình zsh tối thiểu (`.zshenv`, `.zprofile`, `.zshrc`). [tvb#2]
- `AGENTS.md` (CLAUDE.md trỏ tới) và mẫu mô tả PR. [efa2edd]
- Secret: hook gitleaks, `scripts/secrets.sh` (1Password, sops + age), `docs/secrets.md`. [a2ab9dd]
- `install.sh` chạy theo bước; `scripts/link.sh` symlink an toàn, đồ đang chiếm chỗ được chuyển vào `~/.dotfiles-backup/` thay vì xoá. [14d0ab7]

### Đổi

- tmux: thanh trạng thái và viền pane theo Rose Pine, cùng bảng màu với Ghostty và Neovim. [tvb#17]
- Agent được tự merge PR của mình khi đủ bốn điều kiện. [tvb#4]
- Brewfile tách thành lõi, `devops`, `apps`; chọn nhóm bằng `DOT_PROFILES`. [tvb#3]
- Cập nhật plugin Neovim. [tvb#10] [2c75f62]
- Neovim thuần 0.12: `vim.pack` thay lazy.nvim, completion và snippet có sẵn thay nvim-cmp và LuaSnip; bỏ bản phân phối NvChad nhưng giữ giao diện và bộ phím. [c81c002]
- mise chọn Java theo major (`temurin-21`, `temurin-25`) để `mise upgrade` tự lên bản vá. [0c6c308]
- Ansible role `dot` gọi `scripts/link.sh` thay vì xoá file đang chiếm chỗ. [14d0ab7]

### Sửa

- `secrets.sh encrypt` / `edit` tìm `.sops.yaml` cạnh file và không để lại file `.enc` rỗng khi lỗi. [tvb#16]
- `pkg-scan-docker` tìm thư mục `pkg-scanner` theo vị trí repo. [tvb#15]
- `secrets.sh check` nhận đúng 1Password CLI đã đăng nhập qua app. [tvb#13]
- clangd cài bằng Mason, máy mới có LSP C/C++. [tvb#11]
- fish chỉ nạp tích hợp Kiro khi đang ở trong Kiro; `secrets.sh` đọc quyền file đúng trên Linux. [tvb#6]
- Đường dẫn khả chuyển trong fish, git, tmux; zsh hết báo `fnm: command not found`. [tvb#2]

### Bỏ

- tmux-powerline (ghi đè thanh trạng thái). [tvb#17]
- Plugin tmux `atppuccin/tmux` (gõ sai tên, chưa bao giờ cài được). [tvb#14]
- `ghostty` và `openkey` khỏi `Brewfile.apps`. [tvb#12]
- Cấu hình WezTerm và Alacritty. [tvb#8]
- `dump.sh` (thay bằng `drift.sh`). [tvb#3]
- oh-my-zsh và fnm. [tvb#2]

## 2026-10-30

### Thêm

- Neovim cho web, Odoo, Rust, Go, Python, Java và viết tài liệu: LSP, formatter (conform), debug (nvim-dap). [3d32c9d]
- `typst`, `mactex`, `skim` để viết Typst / LaTeX. [f34c85a]
- git: difftool `nvimdiff`, danh tính riêng cho `~/workspace/personal/`, thêm mẫu ignore toàn cục. [a6c7850]
- fish: alias `eza`, tích hợp shell của Kiro. [99cc0c0]
- mise: dotnet. [8375e75]

## 2026-08-19

### Đổi

- Thêm và cập nhật plugin Neovim. [290157e]

## 2026-08-18

### Thêm

- Cấu hình đầu tiên: Neovim (lazy.nvim), tmux, WezTerm, Docker Compose (Postgres, MongoDB, MySQL, Kafka, pkg-scanner), Brewfile. [e147a85]

### Đổi

- Tên người dùng git. [c1b9557]

[#5]: https://github.com/unrealphong/dot/pull/5
[#4]: https://github.com/unrealphong/dot/pull/4
[#3]: https://github.com/unrealphong/dot/pull/3
[#2]: https://github.com/unrealphong/dot/pull/2
[tvb#34]: https://github.com/phonglh-tvb/dot/pull/34
[tvb#33]: https://github.com/phonglh-tvb/dot/pull/33
[tvb#32]: https://github.com/phonglh-tvb/dot/pull/32
[tvb#31]: https://github.com/phonglh-tvb/dot/pull/31
[tvb#30]: https://github.com/phonglh-tvb/dot/pull/30
[tvb#29]: https://github.com/phonglh-tvb/dot/pull/29
[tvb#28]: https://github.com/phonglh-tvb/dot/pull/28
[tvb#27]: https://github.com/phonglh-tvb/dot/pull/27
[tvb#26]: https://github.com/phonglh-tvb/dot/pull/26
[tvb#25]: https://github.com/phonglh-tvb/dot/pull/25
[tvb#24]: https://github.com/phonglh-tvb/dot/pull/24
[tvb#23]: https://github.com/phonglh-tvb/dot/pull/23
[tvb#22]: https://github.com/phonglh-tvb/dot/pull/22
[tvb#21]: https://github.com/phonglh-tvb/dot/pull/21
[tvb#20]: https://github.com/phonglh-tvb/dot/pull/20
[tvb#19]: https://github.com/phonglh-tvb/dot/pull/19
[tvb#18]: https://github.com/phonglh-tvb/dot/pull/18
[tvb#17]: https://github.com/phonglh-tvb/dot/pull/17
[tvb#16]: https://github.com/phonglh-tvb/dot/pull/16
[tvb#15]: https://github.com/phonglh-tvb/dot/pull/15
[tvb#14]: https://github.com/phonglh-tvb/dot/pull/14
[tvb#13]: https://github.com/phonglh-tvb/dot/pull/13
[tvb#12]: https://github.com/phonglh-tvb/dot/pull/12
[tvb#11]: https://github.com/phonglh-tvb/dot/pull/11
[tvb#10]: https://github.com/phonglh-tvb/dot/pull/10
[tvb#9]: https://github.com/phonglh-tvb/dot/pull/9
[tvb#8]: https://github.com/phonglh-tvb/dot/pull/8
[tvb#7]: https://github.com/phonglh-tvb/dot/pull/7
[tvb#6]: https://github.com/phonglh-tvb/dot/pull/6
[tvb#5]: https://github.com/phonglh-tvb/dot/pull/5
[tvb#4]: https://github.com/phonglh-tvb/dot/pull/4
[tvb#3]: https://github.com/phonglh-tvb/dot/pull/3
[tvb#2]: https://github.com/phonglh-tvb/dot/pull/2
[efa2edd]: https://github.com/unrealphong/dot/commit/efa2edd
[a2ab9dd]: https://github.com/unrealphong/dot/commit/a2ab9dd
[14d0ab7]: https://github.com/unrealphong/dot/commit/14d0ab7
[2c75f62]: https://github.com/unrealphong/dot/commit/2c75f62
[c81c002]: https://github.com/unrealphong/dot/commit/c81c002
[0c6c308]: https://github.com/unrealphong/dot/commit/0c6c308
[3d32c9d]: https://github.com/unrealphong/dot/commit/3d32c9d
[f34c85a]: https://github.com/unrealphong/dot/commit/f34c85a
[a6c7850]: https://github.com/unrealphong/dot/commit/a6c7850
[99cc0c0]: https://github.com/unrealphong/dot/commit/99cc0c0
[8375e75]: https://github.com/unrealphong/dot/commit/8375e75
[290157e]: https://github.com/unrealphong/dot/commit/290157e
[e147a85]: https://github.com/unrealphong/dot/commit/e147a85
[c1b9557]: https://github.com/unrealphong/dot/commit/c1b9557
