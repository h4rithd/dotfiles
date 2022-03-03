#!/bin/bash

git clone https://github.com/itchyny/lightline.vim ~/.vim/pack/plugins/start/lightline
git clone --depth 1 https://github.com/sheerun/vim-polyglot ~/.vim/pack/plugins/start/vim-polyglot
git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree
vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q
git clone https://github.com/andymass/vim-matchup.git ~/.vim/pack/vendor/start/vim-matchup
git clone https://github.com/mhinz/vim-startify.git ~/.vim/pack/vendor/start/vim-startify
git clone --depth 1 https://github.com/lifepillar/vim-mucomplete.git ~/.vim/pack/bundle/start/vim-mucomplete
