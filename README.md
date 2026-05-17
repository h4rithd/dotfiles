# h4rithd Dotfiles
Personal dotfiles for setting up a new macOS or Linux machine. This repo includes shell, Vim, tmux, and local utility script configuration.

## What this repo configures
- Zsh shell configuration
- Vim configuration
- Vim plugins
- tmux configuration
- Local scripts under `~/.local/bin`
- macOS/Linux-specific `.zshrc` handling

## Install on a new machine
Clone the repo:
```bash
git clone https://github.com/h4rithd/dotfiles.git ~/.dotfiles
chmod +x install.sh
./install.sh
```


## Manual install
If you do not want to use the install script, copy files manually.
### Linux
```bash
cp .zshrc ~/.zshrc
cp .vimrc ~/.vimrc
cp .tmux.conf ~/.tmux.conf
cp .hushlogin ~/.hushlogin
mkdir -p ~/.local/bin
cp -r .local/bin/* ~/.local/bin/
chmod +x ~/.local/bin/*
```

### macOS
```bash
cp .zshrc-mac ~/.zshrc
cp .vimrc ~/.vimrc
cp .tmux.conf ~/.tmux.conf
cp .hushlogin ~/.hushlogin
mkdir -p ~/.local/bin
cp -r .local/bin/* ~/.local/bin/
chmod +x ~/.local/bin/*
```

## Vim plugins
The install script installs Vim plugins using Vim's native package system:
```text
~/.vim/pack/plugins/start/
~/.vim/pack/plugins/opt/
```

Installed plugins include:
```text
lightline.vim
vim-polyglot
nerdtree
vim-devicons
vim-matchup
vim-startify
vim-visual-multi
vim-fugitive
vim-floaterm
indentLine
coc.nvim
onedark.vim
```

## Vim shortcuts
Leader key:
```text
Space
```

Common mappings:
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
Basic requirements:
```text
git
vim
zsh
tmux
node
rsync
```

For Ubuntu/Debian:
```bash
sudo apt update
sudo apt install -y git vim zsh tmux nodejs npm rsync
```

For macOS with Homebrew:
```bash
brew install git vim zsh tmux node rsync
```

## Backup behavior
The install script backs up existing files before replacing them.

Backups are stored in:
```text
~/.dotfiles-backup-YYYYMMDD-HHMMSS
```
