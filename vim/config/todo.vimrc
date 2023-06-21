autocmd BufNewFile,BufRead *.todo set ft=todo
augroup journal
  autocmd!
  au FileType todo iabbrev todo ·
  au FileType todo iabbrev done ×
  au FileType todo iabbrev note -
  au FileType todo iabbrev event o
  au FileType todo set formatprg=sort\ -V

  au FileType todo syntax match Normal /^.*/
  au FileType todo syntax match Title /^[^-×o ]\+.*/
  au FileType todo syntax match NonText /^\s*×.*/
  au FileType todo syntax match Comment /^\s*·.*/
  au FileType todo syntax match Statement /^\s*o.*/
augroup END
