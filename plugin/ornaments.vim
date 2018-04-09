if exists('g:loaded_ornaments')
  finish
endif
let g:loaded_ornaments = 1


augroup ornaments-autocmd
  autocmd!
  autocmd BufEnter * call ornaments#on_BufEnter()
  autocmd CmdwinEnter : call ornaments#on_CmdwinEnter()
  autocmd BufDelete * call ornaments#on_BufDelete()
  autocmd BufLeave * call ornaments#on_BufLeave()
  autocmd CmdwinLeave : call ornaments#on_CmdwinLeave()
  autocmd InsertCharPre * call ornaments#on_InsertCharPre()
augroup END
