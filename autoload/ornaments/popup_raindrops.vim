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

  call timer_start(0, {-> s:update(char, 0, extend({'line' : 'cursor-1'}, popup_opts), interval, -velocity, 0, winline() - 1)})
  call timer_start(0, {-> s:update(char, 0, extend({'line' : 'cursor+1'}, popup_opts), interval, velocity, 0, winline() + 1)})
endfunction


function! ornaments#popup_raindrops#ornamentable() abort
  return get(g:, 'ornaments_enable', 1) && get(b:, 'ornaments_enable', 1)
endfunction


highlight OrnamentsRaindrops ctermbg=NONE guibg=NONE


function! s:update(text, winid, popup_opts, interval, velocity, baseline, y) abort
  let winid = a:winid
  let baseline = a:baseline

  if winid == 0
    let winid = popup_create(a:text, a:popup_opts)
    if winid == 0
      throw 'ornaments: popup_raindrops: failed popup_create()'
    endif

    let baseline = popup_getpos(winid).line - a:y
  endif

  let yi = float2nr(round(a:y))
  if yi <= 0 || winheight(0) < yi
    call popup_close(winid)

    return
  endif

  call popup_move(winid, {'line' : baseline + yi})

  call timer_start(a:interval, {-> s:update(a:text, winid, a:popup_opts, a:interval, a:velocity, baseline, a:y + a:interval * a:velocity)})
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
