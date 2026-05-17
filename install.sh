#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/h4rithd/dotfiles.git"
REPO_DIR="${HOME}/.dotfiles"
BACKUP_DIR="${HOME}/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

PACK_ROOT="${HOME}/.vim/pack"
PACK_START="${PACK_ROOT}/plugins/start"
PACK_OPT="${PACK_ROOT}/plugins/opt"

log() {
    printf '[+] %s\n' "$*"
}

warn() {
    printf '[!] %s\n' "$*" >&2
}

die() {
    printf '[-] %s\n' "$*" >&2
    exit 1
}

detect_os() {
    case "$(uname -s)" in
        Darwin)
            echo "mac"
            ;;
        Linux)
            echo "linux"
            ;;
        *)
            echo "unknown"
            ;;
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

install_or_update_plugin_start() {
    local name="$1"
    local repo="$2"
    local branch="${3:-}"
    local target="${PACK_START}/${name}"

    if [ -d "$target/.git" ]; then
        log "Updating Vim plugin: $name"
        git -C "$target" pull --ff-only || true
        return
    fi

    if [ -e "$target" ]; then
        log "Existing non-git plugin path found, backing up: $target"
        backup_path "$target"
    fi

    log "Installing Vim plugin: $name"

    if [ -n "$branch" ]; then
        git clone --depth 1 --branch "$branch" "$repo" "$target"
    else
        git clone --depth 1 "$repo" "$target"
    fi
}

install_or_update_plugin_opt() {
    local name="$1"
    local repo="$2"
    local branch="${3:-}"
    local target="${PACK_OPT}/${name}"

    if [ -d "$target/.git" ]; then
        log "Updating optional Vim plugin: $name"
        git -C "$target" pull --ff-only || true
        return
    fi

    if [ -e "$target" ]; then
        log "Existing non-git optional plugin path found, backing up: $target"
        backup_path "$target"
    fi

    log "Installing optional Vim plugin: $name"

    if [ -n "$branch" ]; then
        git clone --depth 1 --branch "$branch" "$repo" "$target"
    else
        git clone --depth 1 "$repo" "$target"
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

    if ! vim --version | grep -q '+terminal'; then
        warn "Your Vim does not have +terminal. vim-floaterm may not work."
    fi

    if command -v node >/dev/null 2>&1; then
        log "Node.js version: $(node -v)"
    else
        warn "Node.js is missing. coc.nvim autocomplete needs Node.js."
    fi
}

warn_if_repo_files_look_broken() {
    local file
    for file in "$REPO_DIR/.vimrc" "$REPO_DIR/.zshrc" "$REPO_DIR/.vim/plug-install.sh"; do
        if [ -f "$file" ]; then
            local lines
            lines="$(wc -l < "$file" | tr -d ' ')"

            if [ "$lines" -lt 10 ]; then
                warn "$file has only $lines lines. Check that it was committed with real newlines."
            fi
        fi
    done
}

install_dotfiles() {
    local os_type="$1"

    log "Installing dotfiles for OS: $os_type"

    mkdir -p "$HOME/.local"
    mkdir -p "$HOME/.vim"
    mkdir -p "$HOME/.vim/undodir"

    # Files/directories that will be managed by this script.
    backup_path "$HOME/.vimrc"
    backup_path "$HOME/.zshrc"
    backup_path "$HOME/.zshrc-mac"
    backup_path "$HOME/.tmux.conf"
    backup_path "$HOME/.cuirlrc"
    backup_path "$HOME/.hushlogin"
    backup_path "$HOME/.local/bin"
    backup_path "$HOME/iTerm2-profile.json"

    log "Copying common dotfiles"

    [ -f "$REPO_DIR/.vimrc" ] && cp "$REPO_DIR/.vimrc" "$HOME/.vimrc"
    [ -f "$REPO_DIR/.tmux.conf" ] && cp "$REPO_DIR/.tmux.conf" "$HOME/.tmux.conf"
    [ -f "$REPO_DIR/.cuirlrc" ] && cp "$REPO_DIR/.cuirlrc" "$HOME/.cuirlrc"
    [ -f "$REPO_DIR/.hushlogin" ] && cp "$REPO_DIR/.hushlogin" "$HOME/.hushlogin"

    if [ -d "$REPO_DIR/.local/bin" ]; then
        mkdir -p "$HOME/.local"
        rsync -a "$REPO_DIR/.local/bin/" "$HOME/.local/bin/"
        find "$HOME/.local/bin" -type f -exec chmod u+x {} \;
    fi

    # Copy .vim but do NOT copy old plugin directories from the repo.
    # Plugins are installed fresh below.
    if [ -d "$REPO_DIR/.vim" ]; then
        rsync -a \
            --exclude 'pack/' \
            "$REPO_DIR/.vim/" "$HOME/.vim/"
    fi

    # OS-specific zshrc behavior.
    if [ "$os_type" = "mac" ]; then
        if [ -f "$REPO_DIR/.zshrc-mac" ]; then
            log "macOS detected: installing .zshrc-mac as ~/.zshrc"
            cp "$REPO_DIR/.zshrc-mac" "$HOME/.zshrc"
        else
            warn ".zshrc-mac not found. Falling back to repo .zshrc"
            [ -f "$REPO_DIR/.zshrc" ] && cp "$REPO_DIR/.zshrc" "$HOME/.zshrc"
        fi

        rm -f "$HOME/.zshrc-mac"
    elif [ "$os_type" = "linux" ]; then
        log "Linux detected: installing repo .zshrc as ~/.zshrc"
        [ -f "$REPO_DIR/.zshrc" ] && cp "$REPO_DIR/.zshrc" "$HOME/.zshrc"

        rm -f "$HOME/.zshrc-mac"
    else
        warn "Unknown OS. Installing repo .zshrc as fallback."
        [ -f "$REPO_DIR/.zshrc" ] && cp "$REPO_DIR/.zshrc" "$HOME/.zshrc"

        rm -f "$HOME/.zshrc-mac"
    fi

    # Always ignore/remove iTerm2 profile.
    rm -f "$HOME/iTerm2-profile.json"
}

install_vim_plugins() {
    if ! command -v vim >/dev/null 2>&1; then
        warn "Skipping Vim plugins because vim is missing."
        return
    fi

    log "Installing Vim plugins"

    mkdir -p "$PACK_START"
    mkdir -p "$PACK_OPT"

    # Remove old duplicate package roots from your earlier setup.
    rm -rf "$PACK_ROOT/vendor/start/nerdtree"
    rm -rf "$PACK_ROOT/vendor/start/vim-matchup"
    rm -rf "$PACK_ROOT/vendor/start/vim-startify"
    rm -rf "$PACK_ROOT/bundle/start/vim-mucomplete"
    rm -rf "$PACK_START/vim-mucomplete"

    install_or_update_plugin_start "lightline.vim"      "https://github.com/itchyny/lightline.vim.git"
    install_or_update_plugin_start "vim-polyglot"       "https://github.com/sheerun/vim-polyglot.git"
    install_or_update_plugin_start "nerdtree"           "https://github.com/preservim/nerdtree.git"
    install_or_update_plugin_start "vim-devicons"       "https://github.com/ryanoasis/vim-devicons.git"
    install_or_update_plugin_start "vim-matchup"        "https://github.com/andymass/vim-matchup.git"
    install_or_update_plugin_start "vim-startify"       "https://github.com/mhinz/vim-startify.git"
    install_or_update_plugin_start "vim-visual-multi"   "https://github.com/mg979/vim-visual-multi.git"
    install_or_update_plugin_start "vim-fugitive"       "https://github.com/tpope/vim-fugitive.git"
    install_or_update_plugin_start "vim-floaterm"       "https://github.com/voldikss/vim-floaterm.git"
    install_or_update_plugin_start "indentLine"         "https://github.com/Yggdroot/indentLine.git"
    install_or_update_plugin_start "coc.nvim"           "https://github.com/neoclide/coc.nvim.git" "release"

    install_or_update_plugin_opt "onedark.vim" "https://github.com/joshdick/onedark.vim.git"

    log "Generating Vim helptags"

    find "$PACK_ROOT" -type d -name doc | while read -r docdir; do
        vim -Nu NONE -n -es -c "helptags $docdir" -c "qa" || true
    done
}

install_coc_extensions() {
    if ! command -v vim >/dev/null 2>&1; then
        return
    fi

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
    if ! command -v zsh >/dev/null 2>&1; then
        warn "zsh is not installed. Skipping shell change."
        return
    fi

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
    local os_type
    os_type="$(detect_os)"

    check_requirements
    install_or_update_repo
    warn_if_repo_files_look_broken
    install_dotfiles "$os_type"
    install_vim_plugins
    install_coc_extensions
    set_default_shell_to_zsh

    log "Done."

    if [ -d "$BACKUP_DIR" ]; then
        log "Backup saved at: $BACKUP_DIR"
    fi

    echo
    echo "Next steps:"
    echo "  1. Restart your terminal or run: exec zsh"
    echo "  2. Open Vim and test: Space f"
    echo "  3. If CoC extensions did not install, run this inside Vim:"
    echo "     :CocInstall coc-json coc-html coc-css coc-yaml coc-pyright coc-tsserver coc-sh"
    echo
}

main "$@"
