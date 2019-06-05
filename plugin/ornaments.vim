if exists('g:loaded_ornaments')
  finish
endif
let g:loaded_ornaments = 1


augroup ornaments-autocmd
  autocmd!
  autocmd BufEnter * call ornaments#setline#on_BufEnter()
  autocmd CmdwinEnter : call ornaments#setline#on_CmdwinEnter()
  autocmd BufDelete * call ornaments#setline#on_BufDelete()
  autocmd BufLeave * call ornaments#setline#on_BufLeave()
  autocmd CmdwinLeave : call ornaments#setline#on_CmdwinLeave()
  autocmd InsertCharPre * call ornaments#setline#on_InsertCharPre()
augroup END
