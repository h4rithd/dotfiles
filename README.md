# h4rithd Dotfiles

Personal dotfiles for setting up a new macOS or Linux machine. Covers shell,
Vim, tmux, terminal-app profiles, fonts, and local utility scripts.

## Layout

```
shared/   Used on every OS: .vimrc, .hushlogin, .cuirlrc, .local/bin/*,
          Vim plugin installer, and fonts/.
mac/      macOS-only: .zshrc, .tmux.conf, tmux status-bar script,
          iTerm2 profile, Terminal.app profile.
linux/    Linux-only: .zshrc, .tmux.conf, mate-terminal defaults.
install.sh   Detects the OS and installs the right combination of the above.
```

`.tmux.conf` and `.zshrc` are **not** shared files — the Mac and Linux
versions differ (different pane-navigation keys, different clipboard
commands, etc.), so each lives under its own OS folder.

## Install on a new machine

```bash
git clone https://github.com/h4rithd/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh            # dotfiles only: zsh, vim, tmux, ~/.local/bin
./install.sh --full      # + fonts + terminal-app profile (iTerm2/Terminal.app, mate-terminal)
```

Flags:

| Flag | Effect |
|---|---|
| *(none)* | Dotfiles + Vim plugins only. No fonts, no terminal-app changes. |
| `--full` | Everything, including fonts and the terminal-app profile. |
| `--with-fonts` | Add font install to a default run. |
| `--with-terminal` | Add the terminal-app profile to a default run. |
| `--no-fonts` / `--no-terminal` | Subtract one of those from `--full`. |

The script detects macOS vs Linux with `uname` and installs the matching
`mac/` or `linux/` files. It is safe to re-run: anything it would overwrite
is backed up first to `~/.dotfiles-backup-<timestamp>/`.

## What each OS gets

### macOS
- `~/.zshrc` from `mac/.zshrc`
- `~/.tmux.conf` from `mac/.tmux.conf` — Linux-style pane navigation
  (Arrow keys move panes, Ctrl+Arrow resizes, matching the Linux tmux setup)
- `~/.tmux/status.sh`, a two-row tmux status bar (CPU / memory / IP / VPN /
  date / time, using Nerd Font icons)
- **Fonts** (`--full`/`--with-fonts`): JetBrainsMono Nerd Font Mono
  (Regular/Bold/Italic/BoldItalic) → `~/Library/Fonts`
- **Terminal profiles** (`--full`/`--with-terminal`):
  - iTerm2: installed via iTerm2's own [Dynamic
    Profiles](https://iterm2.com/documentation-dynamic-profiles.html)
    mechanism (drops a JSON file in
    `~/Library/Application Support/iTerm2/DynamicProfiles/`) — no existing
    iTerm2 settings are touched. Pick the profile **h4rithd** in
    iTerm2 → Settings → Profiles. It remaps Cmd+Arrow / Cmd+letter to send
    the same Ctrl sequences Linux uses, so pane navigation and word-jump
    match Linux without swapping your Cmd/Ctrl keys system-wide.
  - Terminal.app: installs a profile named **h4rithd** and sets it as the
    default/startup profile. Terminal.app has no Command-key remapping, so
    this profile uses the real Control key instead (`Ctrl+Arrow` to
    move/resize panes, `Ctrl+Left/Right` to jump words).

### Linux
- `~/.zshrc`, `~/.tmux.conf` from `linux/`
- **Fonts** (`--full`/`--with-fonts`): same Nerd Font family →
  `~/.local/share/fonts`, then `fc-cache -f`
- **mate-terminal** (`--full`/`--with-terminal`): `linux/mate-terminal-defaults.sh`
  applies a generated dark profile (same font, unlimited scrollback) via
  `gsettings`. This is **not** an export of a real mate-terminal profile —
  it's a reasonable default. To replace it with an exact copy of a real
  profile, run `dconf dump /org/mate/terminal/profiles/Default/` on that
  machine and update the file with the output.

## Manual install (without the script)

### Linux
```bash
cp linux/.zshrc ~/.zshrc
cp linux/.tmux.conf ~/.tmux.conf
cp shared/.vimrc ~/.vimrc
cp shared/.hushlogin ~/.hushlogin
mkdir -p ~/.local/bin
cp -r shared/.local/bin/* ~/.local/bin/
chmod +x ~/.local/bin/*
```

### macOS
```bash
cp mac/.zshrc ~/.zshrc
cp mac/.tmux.conf ~/.tmux.conf
cp shared/.vimrc ~/.vimrc
cp shared/.hushlogin ~/.hushlogin
mkdir -p ~/.local/bin
cp -r shared/.local/bin/* ~/.local/bin/
chmod +x ~/.local/bin/*
```

## Vim plugins

`install.sh` installs Vim plugins using Vim's native package system:

```text
~/.vim/pack/plugins/start/
~/.vim/pack/plugins/opt/
```

Installed plugins:

```text
lightline.vim, vim-polyglot, nerdtree, vim-devicons, vim-matchup,
vim-startify, vim-visual-multi, vim-fugitive, vim-floaterm, indentLine,
coc.nvim (start); onedark.vim (opt)
```

## Vim shortcuts

Leader key: `Space`

```text
Space f      open/close NERDTree sidebar
Space F      find current file in NERDTree
Space t      open/close floating terminal
Space tn     new floating terminal
Space tk     kill floating terminal
Space tp     previous terminal
Space tj     next terminal
Space gs     Git status
Space gb     Git blame
Space gd     Git diff
Space gc     Git commit
Space gl     Git log
Space gp     Git push
gd           go to definition
gr           references
gi           implementation
gy           type definition
K            hover documentation
Space rn     rename symbol
Space a      code action
Space ff     format current file
```

## CoC autocomplete

After installing, open Vim and run:

```vim
:CocInstall coc-json coc-html coc-css coc-yaml coc-pyright coc-tsserver coc-sh
```

Optional C/C++ support:

```vim
:CocInstall coc-clangd
```

## Requirements

```text
git, vim, zsh, tmux, node, rsync
```

Ubuntu/Debian:
```bash
sudo apt update
sudo apt install -y git vim zsh tmux nodejs npm rsync
```

macOS with Homebrew:
```bash
brew install git vim zsh tmux node rsync
```

## tmux shortcuts (both OSes, prefix is `Ctrl+a`)

| Keys | Action |
|---|---|
| `Ctrl+w` / `Ctrl+q` | split pane horizontal / vertical (no prefix needed) |
| prefix, then Arrow | move between panes |
| prefix, then `Ctrl+Arrow` (mac) | resize pane by 1 |
| prefix, then `H`/`J`/`K`/`L` | resize pane by 2 |
| prefix, then `Alt`/`Option`+Arrow | resize pane by 5 |
| `Alt`/`Option`+1..9 | switch window |
| prefix, then `q` | kill pane |
| prefix, then `y` | copy tmux buffer to system clipboard |

On macOS, Terminal.app can't see the Command key as a modifier, so the above
uses **Control**. iTerm2's installed profile remaps Cmd to send the same
sequences, so Cmd works there instead if you prefer it.

## Backup behavior

The install script backs up anything it would overwrite before replacing it,
to `~/.dotfiles-backup-<timestamp>/`.
