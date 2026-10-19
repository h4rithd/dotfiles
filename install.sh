#!/usr/bin/env bash
# h4rithd dotfiles installer.
#
# Usage:
#   ./install.sh               Dotfiles only: zsh, vim, tmux, ~/.local/bin, vim plugins.
#                               No fonts, no terminal-app profile changes.
#   ./install.sh --full        Everything above, plus fonts and the terminal-app
#                               profile for your OS (iTerm2 + Terminal.app on macOS,
#                               mate-terminal on Linux).
#   ./install.sh --with-fonts       Add just the font install to the default run.
#   ./install.sh --with-terminal    Add just the terminal-app profile to the default run.
#
# --full is the same as --with-fonts --with-terminal.
set -euo pipefail

REPO_URL="https://github.com/h4rithd/dotfiles.git"
REPO_DIR="${HOME}/.dotfiles"
BACKUP_DIR="${HOME}/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

PACK_ROOT="${HOME}/.vim/pack"
PACK_START="${PACK_ROOT}/plugins/start"
PACK_OPT="${PACK_ROOT}/plugins/opt"

WITH_FONTS=0
WITH_TERMINAL=0

log()  { printf '[+] %s\n' "$*"; }
warn() { printf '[!] %s\n' "$*" >&2; }
die()  { printf '[-] %s\n' "$*" >&2; exit 1; }

usage() {
    sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'
}

parse_args() {
    for arg in "$@"; do
        case "$arg" in
            --full)          WITH_FONTS=1; WITH_TERMINAL=1 ;;
            --with-fonts)    WITH_FONTS=1 ;;
            --with-terminal) WITH_TERMINAL=1 ;;
            --no-fonts)      WITH_FONTS=0 ;;
            --no-terminal)   WITH_TERMINAL=0 ;;
            -h|--help)       usage; exit 0 ;;
            *) die "Unknown option: $arg (see --help)" ;;
        esac
    done
}

detect_os() {
    case "$(uname -s)" in
        Darwin) echo "mac" ;;
        Linux)  echo "linux" ;;
        *)      echo "unknown" ;;
    esac
}

backup_path() {
    local target="$1"
    if [ -e "$target" ] || [ -L "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        log "Backing up $target -> $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/"
    fi
}

install_or_update_repo() {
    if [ -d "$REPO_DIR/.git" ]; then
        log "Updating dotfiles repo: $REPO_DIR"
        git -C "$REPO_DIR" pull --ff-only
    else
        log "Cloning dotfiles repo: $REPO_URL"
        rm -rf "$REPO_DIR"
        git clone "$REPO_URL" "$REPO_DIR"
    fi
}

check_requirements() {
    command -v git >/dev/null 2>&1 || die "git is required. Install git first."
    command -v rsync >/dev/null 2>&1 || die "rsync is required. Install rsync first."

    if ! command -v vim >/dev/null 2>&1; then
        warn "vim is not installed. Dotfiles will be copied, but Vim plugin setup will be skipped."
        return
    fi

    log "Vim version: $(vim --version | head -n 1)"
    vim --version | grep -q '+terminal' || warn "Your Vim does not have +terminal. vim-floaterm may not work."

    if command -v node >/dev/null 2>&1; then
        log "Node.js version: $(node -v)"
    else
        warn "Node.js is missing. coc.nvim autocomplete needs Node.js."
    fi
}

install_shared_dotfiles() {
    log "Installing shared dotfiles"

    mkdir -p "$HOME/.local" "$HOME/.vim" "$HOME/.vim/undodir"

    backup_path "$HOME/.vimrc"
    backup_path "$HOME/.hushlogin"
    backup_path "$HOME/.cuirlrc"
    backup_path "$HOME/.local/bin"

    [ -f "$REPO_DIR/shared/.vimrc" ]      && cp "$REPO_DIR/shared/.vimrc" "$HOME/.vimrc"
    [ -f "$REPO_DIR/shared/.hushlogin" ]  && cp "$REPO_DIR/shared/.hushlogin" "$HOME/.hushlogin"
    [ -f "$REPO_DIR/shared/.cuirlrc" ]    && cp "$REPO_DIR/shared/.cuirlrc" "$HOME/.cuirlrc"

    if [ -d "$REPO_DIR/shared/.local/bin" ]; then
        mkdir -p "$HOME/.local/bin"
        rsync -a "$REPO_DIR/shared/.local/bin/" "$HOME/.local/bin/"
        find "$HOME/.local/bin" -type f -exec chmod u+x {} \;
    fi

    if [ -d "$REPO_DIR/shared/.vim" ]; then
        rsync -a --exclude 'pack/' "$REPO_DIR/shared/.vim/" "$HOME/.vim/"
    fi
}

install_os_dotfiles() {
    local os_type="$1"
    local src="$REPO_DIR/$os_type"

    [ -d "$src" ] || die "No $os_type/ directory found in repo at $src"

    log "Installing $os_type-specific dotfiles"

    backup_path "$HOME/.zshrc"
    backup_path "$HOME/.tmux.conf"

    [ -f "$src/.zshrc" ]      && cp "$src/.zshrc" "$HOME/.zshrc"
    [ -f "$src/.tmux.conf" ]  && cp "$src/.tmux.conf" "$HOME/.tmux.conf"

    if [ "$os_type" = "mac" ] && [ -f "$src/tmux-status.sh" ]; then
        mkdir -p "$HOME/.tmux"
        cp "$src/tmux-status.sh" "$HOME/.tmux/status.sh"
        chmod +x "$HOME/.tmux/status.sh"
    fi
}

install_fonts() {
    local os_type="$1"
    local font_src="$REPO_DIR/shared/fonts"

    [ -d "$font_src" ] || { warn "No shared/fonts/ directory in repo. Skipping fonts."; return; }

    local dest
    if [ "$os_type" = "mac" ]; then
        dest="$HOME/Library/Fonts"
    else
        dest="$HOME/.local/share/fonts"
    fi

    log "Installing fonts to $dest"
    mkdir -p "$dest"
    find "$font_src" -name '*.ttf' -exec cp {} "$dest/" \;

    if [ "$os_type" = "linux" ] && command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f "$dest" >/dev/null 2>&1 || true
    fi
}

install_terminal_profile() {
    local os_type="$1"

    if [ "$os_type" = "mac" ]; then
        # iTerm2, via its own supported "Dynamic Profiles" mechanism: drop a
        # profile JSON file in this folder and iTerm2 picks it up live, no
        # restart, no touching NSUserDefaults directly.
        if [ -d "/Applications/iTerm.app" ]; then
            local dp_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
            mkdir -p "$dp_dir"
            cp "$REPO_DIR/mac/iTerm2-profile.json" "$dp_dir/h4rithd.json"
            log "iTerm2 profile installed (Dynamic Profiles). Pick 'h4rithd' in iTerm2 > Settings > Profiles."
        else
            log "iTerm2 not installed, skipping its profile."
        fi

        # Terminal.app
        if [ -f "$REPO_DIR/mac/Terminal.app-profile.terminal" ]; then
            open "$REPO_DIR/mac/Terminal.app-profile.terminal"
            sleep 1
            defaults write com.apple.Terminal "Default Window Settings" -string "h4rithd"
            defaults write com.apple.Terminal "Startup Window Settings" -string "h4rithd"
            log "Terminal.app profile 'h4rithd' installed and set as default/startup."
            warn "If Terminal.app was already open, quit and reopen it for the new profile to take effect."
        fi
    elif [ "$os_type" = "linux" ]; then
        if [ -f "$REPO_DIR/linux/mate-terminal-defaults.sh" ]; then
            bash "$REPO_DIR/linux/mate-terminal-defaults.sh" || warn "mate-terminal profile setup failed; continuing."
        fi
    fi
}

install_or_update_plugin_start() {
    local name="$1" repo="$2" branch="${3:-}" target="${PACK_START}/$1"
    if [ -d "$target/.git" ]; then
        log "Updating Vim plugin: $name"
        git -C "$target" pull --ff-only || true
        return
    fi
    [ -e "$target" ] && backup_path "$target"
    log "Installing Vim plugin: $name"
    if [ -n "$branch" ]; then git clone --depth 1 --branch "$branch" "$repo" "$target"
    else git clone --depth 1 "$repo" "$target"; fi
}

install_or_update_plugin_opt() {
    local name="$1" repo="$2" branch="${3:-}" target="${PACK_OPT}/$1"
    if [ -d "$target/.git" ]; then
        log "Updating optional Vim plugin: $name"
        git -C "$target" pull --ff-only || true
        return
    fi
    [ -e "$target" ] && backup_path "$target"
    log "Installing optional Vim plugin: $name"
    if [ -n "$branch" ]; then git clone --depth 1 --branch "$branch" "$repo" "$target"
    else git clone --depth 1 "$repo" "$target"; fi
}

install_vim_plugins() {
    if ! command -v vim >/dev/null 2>&1; then
        warn "Skipping Vim plugins because vim is missing."
        return
    fi

    log "Installing Vim plugins"
    mkdir -p "$PACK_START" "$PACK_OPT"

    install_or_update_plugin_start "lightline.vim"    "https://github.com/itchyny/lightline.vim.git"
    install_or_update_plugin_start "vim-polyglot"     "https://github.com/sheerun/vim-polyglot.git"
    install_or_update_plugin_start "nerdtree"         "https://github.com/preservim/nerdtree.git"
    install_or_update_plugin_start "vim-devicons"     "https://github.com/ryanoasis/vim-devicons.git"
    install_or_update_plugin_start "vim-matchup"      "https://github.com/andymass/vim-matchup.git"
    install_or_update_plugin_start "vim-startify"     "https://github.com/mhinz/vim-startify.git"
    install_or_update_plugin_start "vim-visual-multi" "https://github.com/mg979/vim-visual-multi.git"
    install_or_update_plugin_start "vim-fugitive"     "https://github.com/tpope/vim-fugitive.git"
    install_or_update_plugin_start "vim-floaterm"     "https://github.com/voldikss/vim-floaterm.git"
    install_or_update_plugin_start "indentLine"       "https://github.com/Yggdroot/indentLine.git"
    install_or_update_plugin_start "coc.nvim"         "https://github.com/neoclide/coc.nvim.git" "release"

    install_or_update_plugin_opt "onedark.vim" "https://github.com/joshdick/onedark.vim.git"

    log "Generating Vim helptags"
    find "$PACK_ROOT" -type d -name doc | while read -r docdir; do
        vim -Nu NONE -n -es -c "helptags $docdir" -c "qa" || true
    done
}

install_coc_extensions() {
    command -v vim >/dev/null 2>&1 || return
    if ! command -v node >/dev/null 2>&1; then
        warn "Skipping CoC extensions because node is missing."
        return
    fi
    log "Trying to install CoC extensions"
    vim -Nu "$HOME/.vimrc" -n -es \
        -c "CocInstall -sync coc-json coc-html coc-css coc-yaml coc-pyright coc-tsserver coc-sh" \
        -c "qa" || warn "CoC extension install failed. Run it manually inside Vim."
}

set_default_shell_to_zsh() {
    command -v zsh >/dev/null 2>&1 || { warn "zsh is not installed. Skipping shell change."; return; }
    if [ "${SHELL:-}" = "$(command -v zsh)" ]; then
        log "zsh is already your current shell."
        return
    fi
    if command -v chsh >/dev/null 2>&1; then
        warn "To change your default shell, run:"
        echo "    chsh -s $(command -v zsh)"
    fi
}

main() {
    parse_args "$@"

    local os_type
    os_type="$(detect_os)"
    [ "$os_type" = "unknown" ] && die "Unsupported OS: $(uname -s)"

    log "Installing dotfiles for OS: $os_type (fonts: $WITH_FONTS, terminal: $WITH_TERMINAL)"

    check_requirements
    install_or_update_repo
    install_shared_dotfiles
    install_os_dotfiles "$os_type"

    [ "$WITH_FONTS" = 1 ]    && install_fonts "$os_type"
    [ "$WITH_TERMINAL" = 1 ] && install_terminal_profile "$os_type"

    install_vim_plugins
    install_coc_extensions
    set_default_shell_to_zsh

    log "Done."
    [ -d "$BACKUP_DIR" ] && log "Backup saved at: $BACKUP_DIR"

    echo
    echo "Next steps:"
    echo "  1. Restart your terminal or run: exec zsh"
    echo "  2. Open Vim and test: Space f"
    echo "  3. If CoC extensions did not install, run this inside Vim:"
    echo "     :CocInstall coc-json coc-html coc-css coc-yaml coc-pyright coc-tsserver coc-sh"
    echo
}

main "$@"
