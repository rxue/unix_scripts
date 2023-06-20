# Install and configure vim
# Reference: http://vim.wikia.com/wiki/Indenting_source_code
configure_vim () {
  config_statements=`cat <<EOF
# Reference: http://tldp.org/LDP/abs/html/here-docs.html
# Configure VIM on the system level
set number
syntax on
set hlsearch
set expandtab
set shiftwidth=2
set softtabstop=2
set list # display tab
EOF`
  echo "${config_statements}"
}
