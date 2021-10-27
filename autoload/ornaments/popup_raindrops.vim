let s:save_cpo = &cpo
set cpo&vim


function! ornaments#popup_raindrops#on_InsertCharPre() abort
  if !ornaments#popup_raindrops#ornamentable()
    return
  endif

  let l:Ornaments_raindrops_char = get(g:, 'Ornaments_raindrops_char', {char -> v:char})
  let char = l:Ornaments_raindrops_char(v:char)
  let velocity = get(g:, 'ornaments_velocity', 0.045)
  let interval = get(g:, 'ornaments_interval', 20)
  let popup_opts = {
        \ 'col' : 'cursor-1',
        \ 'highlight' : 'OrnamentsRaindrops',
        \}

  call timer_start(0, {-> s:update(char, 0, extend({'line' : 'cursor-1'}, popup_opts), interval, -velocity, winline() - 1, 0, 0.0)})
  call timer_start(0, {-> s:update(char, 0, extend({'line' : 'cursor+1'}, popup_opts), interval, velocity, winline() + 1, 0, 0.0)})
endfunction


function! ornaments#popup_raindrops#ornamentable() abort
  return get(g:, 'ornaments_enable', 1) && get(b:, 'ornaments_enable', 1)
endfunction


highlight OrnamentsRaindrops ctermbg=NONE guibg=NONE


function! s:update(text, winid, popup_opts, interval, velocity, winline, baseline, y) abort
  let winid = a:winid
  let baseline = a:baseline

  if winid == 0
    let winid = popup_create(a:text, a:popup_opts)
    if winid == 0
      throw 'ornaments: popup_raindrops: failed popup_create()'
    endif

    let y = a:winline
    let baseline = popup_getpos(winid).line - y
  else
    let y = a:y + a:interval * a:velocity
  endif

  let yi = float2nr(round(y))
  if yi <= 0 || winheight(0) < yi
    if winid > 0
      call popup_close(winid)
    endif

    return
  endif

  call popup_move(winid, {'line' : baseline + yi})

  call timer_start(a:interval, {-> s:update(a:text, winid, a:popup_opts, a:interval, a:velocity, a:winline, baseline, y)})
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
