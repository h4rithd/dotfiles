#!/usr/bin/env bash
set -euo pipefail

PACK_ROOT="$HOME/.vim/pack"
PACK_START="$PACK_ROOT/plugins/start"
PACK_OPT="$PACK_ROOT/plugins/opt"

echo "[+] Creating Vim package directories..."
mkdir -p "$PACK_START"
mkdir -p "$PACK_OPT"

echo "[+] Checking dependencies..."

if ! command -v git >/dev/null 2>&1; then
    echo "[-] git is missing."
    echo "    Install it with: sudo apt install git"
    exit 1
fi

if ! command -v vim >/dev/null 2>&1; then
    echo "[-] vim is missing."
    echo "    Install it with: sudo apt install vim"
    exit 1
fi

echo "[+] Vim version:"
vim --version | head -n 1

if ! vim --version | grep -q '+terminal'; then
    echo "[!] WARNING: Your Vim does not have +terminal."
    echo "    vim-floaterm may not work."
    echo "    On Debian/Ubuntu, try:"
    echo "    sudo apt install vim-gtk3 vim-nox"
fi

echo "[+] Checking Node.js for coc.nvim..."

if command -v node >/dev/null 2>&1; then
    NODE_VERSION="$(node -v | sed 's/^v//')"
    echo "[+] Node.js found: v$NODE_VERSION"
else
    echo "[!] WARNING: node is missing."
    echo "    coc.nvim autocomplete needs Node.js >= 20.19.0."
fi

echo "[+] Removing duplicate old plugin paths if they exist..."

DUPLICATES=(
    "$PACK_ROOT/vendor/start/nerdtree"
    "$PACK_ROOT/vendor/start/vim-matchup"
    "$PACK_ROOT/vendor/start/vim-startify"
    "$PACK_ROOT/bundle/start/vim-mucomplete"
)

for dir in "${DUPLICATES[@]}"; do
    if [ -d "$dir" ]; then
        echo "[+] Removing duplicate: $dir"
        rm -rf "$dir"
    fi
done

install_or_update_start() {
    local name="$1"
    local repo="$2"
    local branch="${3:-}"

    local target="$PACK_START/$name"

    if [ -d "$target/.git" ]; then
        echo "[+] Updating $name..."
        git -C "$target" pull --ff-only || true
    else
        echo "[+] Installing $name..."
        if [ -n "$branch" ]; then
            git clone --depth 1 --branch "$branch" "$repo" "$target"
        else
            git clone --depth 1 "$repo" "$target"
        fi
    fi
}

install_or_update_opt() {
    local name="$1"
    local repo="$2"
    local branch="${3:-}"

    local target="$PACK_OPT/$name"

    if [ -d "$target/.git" ]; then
        echo "[+] Updating $name..."
        git -C "$target" pull --ff-only || true
    else
        echo "[+] Installing optional plugin $name..."
        if [ -n "$branch" ]; then
            git clone --depth 1 --branch "$branch" "$repo" "$target"
        else
            git clone --depth 1 "$repo" "$target"
        fi
    fi
}

echo "[+] Installing start plugins..."

install_or_update_start "lightline.vim" "https://github.com/itchyny/lightline.vim.git"
install_or_update_start "vim-polyglot" "https://github.com/sheerun/vim-polyglot.git"
install_or_update_start "nerdtree" "https://github.com/preservim/nerdtree.git"
install_or_update_start "vim-devicons" "https://github.com/ryanoasis/vim-devicons.git"
install_or_update_start "vim-matchup" "https://github.com/andymass/vim-matchup.git"
install_or_update_start "vim-startify" "https://github.com/mhinz/vim-startify.git"
#install_or_update_start "vim-mucomplete" "https://github.com/lifepillar/vim-mucomplete.git"
install_or_update_start "vim-visual-multi" "https://github.com/mg979/vim-visual-multi.git"
install_or_update_start "vim-fugitive" "https://github.com/tpope/vim-fugitive.git"
install_or_update_start "vim-floaterm" "https://github.com/voldikss/vim-floaterm.git"
install_or_update_start "indentLine" "https://github.com/Yggdroot/indentLine.git"
install_or_update_start "coc.nvim" "https://github.com/neoclide/coc.nvim.git" "release"

echo "[+] Installing optional plugins..."

install_or_update_opt "onedark.vim" "https://github.com/joshdick/onedark.vim.git"

echo "[+] Generating helptags..."

find "$PACK_ROOT" -type d -name doc | while read -r docdir; do
    echo "[+] Helptags: $docdir"
    vim -Nu NONE -n -es -c "helptags $docdir" -c "qa" || true
done

echo
echo "[+] Done."
echo
echo "Next steps:"
echo "1. Put the updated vimrc in ~/.vimrc"
echo "2. Open Vim"
echo "3. Run this inside Vim for CoC autocomplete:"
echo
echo "   :CocInstall coc-json coc-html coc-css coc-yaml coc-pyright coc-tsserver coc-sh"
echo
echo "Optional for C/C++:"
echo
echo "   :CocInstall coc-clangd"
echo
