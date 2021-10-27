if exists('g:loaded_ornaments')
  finish
endif
let g:loaded_ornaments = 1


let s:save_cpo = &cpo
set cpo&vim


let s:ornaments_instrument = get(g:, 'ornaments_instrument', has('popupwin') ? 'popup' : has('conceal') ? 'conceal' : 'setline')


if s:ornaments_instrument ==# 'textprop_gaming'
  if !has('timers') || !has('textprop')
    throw 'ornaments: textprop_gaming: require Vim compiled with +timers and +textprop feature'
  endif

  augroup ornaments-autocmd
    autocmd!
    autocmd InsertCharPre * call ornaments#textprop_gaming#on_InsertCharPre()
    autocmd BufWinEnter * call ornaments#textprop_gaming#on_BufWinEnter()
    autocmd ColorScheme * call ornaments#textprop_gaming#on_ColorScheme()
  augroup END
elseif s:ornaments_instrument ==# 'conceal'
  if !has('timers') || !has('conceal')
    throw 'ornaments: conceal: require Vim compiled with +timers and +conceal feature'
  endif

  augroup ornaments-autocmd
    autocmd!
    autocmd InsertCharPre * call ornaments#conceal#on_InsertCharPre()
  augroup END
elseif s:ornaments_instrument ==# 'popup'
  if !has('timers') || !has('popupwin')
    throw 'ornaments: popup: require Vim compiled with +timers and +popupwin feature'
  endif

  augroup ornaments-autocmd
    autocmd!
    autocmd InsertCharPre * call ornaments#popup#on_InsertCharPre()
  augroup END
elseif s:ornaments_instrument ==# 'popup_raindrops'
  if !has('timers') || !has('popupwin')
    throw 'ornaments: popup_raindrops: require Vim compiled with +timers and +popupwin feature'
  endif

  augroup ornaments-autocmd
    autocmd!
    autocmd InsertCharPre * call ornaments#popup_raindrops#on_InsertCharPre()
  augroup END
elseif s:ornaments_instrument ==# 'setline'
  if !has('timers')
    throw 'ornaments: setline: require Vim compiled with +timers feature'
  endif

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
