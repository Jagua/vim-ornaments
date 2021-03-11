if exists('g:loaded_ornaments')
  finish
endif
let g:loaded_ornaments = 1


let s:save_cpo = &cpo
set cpo&vim


let s:ornaments_instrument = get(g:, 'ornaments_instrument', exists('*popup_create') ? 'popup' : has('conceal') ? 'conceal' : 'setline')


if s:ornaments_instrument ==# 'conceal'
  if !has('conceal')
    throw 'ornaments: conceal: require Vim compiled with +conceal feature'
  endif

  augroup ornaments-autocmd
    autocmd!
    autocmd InsertCharPre * call ornaments#conceal#on_InsertCharPre()
  augroup END
elseif s:ornaments_instrument ==# 'popup'
  if !exists('*popup_create')
    throw 'ornaments: popup: require popup_create() function'
  endif

  augroup ornaments-autocmd
    autocmd!
    autocmd InsertCharPre * call ornaments#popup#on_InsertCharPre()
  augroup END
elseif s:ornaments_instrument ==# 'setline'
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
  throw printf('ornaments: unknown instrument: %s', s:ornaments_instrument)
endif


let &cpo = s:save_cpo
unlet s:save_cpo
