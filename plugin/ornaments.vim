if exists('g:loaded_ornaments')
  finish
endif
let g:loaded_ornaments = 1


let ornaments_instrument = get(g:, 'ornaments_instrument', has('textprop') ? 'popup' : 'setline')


if ornaments_instrument ==# 'popup'
  if !has('textprop')
    throw 'ornaments: require +textprop feature'
  endif

  augroup ornaments-autocmd
    autocmd!
    autocmd InsertCharPre * call ornaments#popup#on_InsertCharPre()
  augroup END
elseif ornaments_instrument ==# 'setline'
  augroup ornaments-autocmd
    autocmd!
    autocmd BufEnter * call ornaments#setline#on_BufEnter()
    autocmd CmdwinEnter : call ornaments#setline#on_CmdwinEnter()
    autocmd BufDelete * call ornaments#setline#on_BufDelete()
    autocmd BufLeave * call ornaments#setline#on_BufLeave()
    autocmd CmdwinLeave : call ornaments#setline#on_CmdwinLeave()
    autocmd InsertCharPre * call ornaments#setline#on_InsertCharPre()
  augroup END
else
  throw printf('ornaments: unknown instrument: %s', ornaments_instrument)
endif
