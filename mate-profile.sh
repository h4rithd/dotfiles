#!/bin/bash

dconf write /org/mate/terminal/global/profile-list "['default', 'h4rithd']"
cat <<EOF | dconf load /org/mate/terminal/profiles/
[h4rithd]
allow-bold=false
background-color='#262626262626'
background-darkness=0.94999999999999996
background-type='solid'
bold-color='#000000000000'
bold-color-same-as-fg=true
cursor-blink-mode='on'
cursor-shape='block'
default-show-menubar=false
font='Liberation Mono 15'
foreground-color='#FFFFFFFFFFFF'
palette='#000000000000:#CCCC00000000:#4E4D9A9A0605:#C4C3A0A00000:#34346564A4A3:#E6E661610000:#060598979A9A:#D3D3D7D6CFCF:#555457565352:#EFEF29282928:#8A89E2E23434:#FCFBE9E84F4F:#72729F9ECFCF:#ADAC7F7EA8A8:#3434E2E2E2E2:#EEEDEEEDECEB'
scrollback-unlimited=true
silent-bell=true
title-mode='ignore'
use-custom-default-size=true
use-system-font=false
use-theme-colors=false
visible-name='h4rithd'
EOF
dconf write /org/mate/terminal/global/default-profile "'h4rithd'"
