# reference: https://shapeshed.com/vim-netrw/
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_browse_split = 4
augroup OpenWithExplore
  autocmd!
  autocmd VimEnter * :Vexplore
augroup END
