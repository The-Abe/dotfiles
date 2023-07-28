augroup todo
  autocmd BufNewFile,BufRead *.todo set ft=todo
  autocmd VimLeave *.todo write
  au FileType todo iabbrev todo - [_]
  au FileType todo iabbrev note >
  au FileType todo iabbrev event *

  au FileType todo nnoremap <tab> <c-w><c-w>
  au FileType todo nnoremap <c-l> dd<c-w>lGp<c-w>h
  au FileType todo nnoremap <c-h> dd<c-w>hGp<c-w>l

  au FileType todo nnoremap <leader>s vipoj:'<,'>sort<cr>

  au FileType todo nnoremap <space> :s/-/x/<cr>

  au FileType todo syntax match Normal /^.*/
  au FileType todo syntax match Title /^[^-x>\* ]\+.*/
  au FileType todo syntax match NonText /^\s*\[x\]\s.*/
  au FileType todo syntax match Comment /^\s*>\s.*/
  au FileType todo syntax match Statement /^\s*\*\s.*/

  au FileType todo cmap q qa
augroup END
