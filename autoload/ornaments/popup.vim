let s:save_cpo = &cpo
set cpo&vim


function! ornaments#popup#on_InsertCharPre() abort
  if !ornaments#popup#ornamentable() || v:char !~# '[[:alnum:]]'
    return
  endif
  let step = get(g:, 'ornaments_step', 3)
  let grace_notes = s:grace_notes(v:char, step)
  let interval = get(g:, 'ornaments_interval', 70)
  let popup_opts = {
        \ 'line' : 'cursor',
        \ 'col' : 'cursor',
        \ 'time' : interval,
        \ 'highlight' : 'OrnamentsPopupColor',
        \}
  call s:update(popup_opts, grace_notes, interval)
endfunction


function! ornaments#popup#ornamentable() abort
  return get(g:, 'ornaments_enable', 1) && get(b:, 'ornaments_enable', 1)
endfunction


unlet! s:code_0 s:code_9 s:code_A s:code_Z s:code_a s:code_z s:size_nu s:size_al
if exists(':const') == 2
  const s:code_0 = char2nr('0')
  const s:code_9 = char2nr('9')
  const s:code_A = char2nr('A')
  const s:code_Z = char2nr('Z')
  const s:code_a = char2nr('a')
  const s:code_z = char2nr('z')
  const s:size_nu = s:code_9 - s:code_0 + 1
  const s:size_al = s:code_z - s:code_a + 1
else
  let s:code_0 = char2nr('0')
  let s:code_9 = char2nr('9')
  let s:code_A = char2nr('A')
  let s:code_Z = char2nr('Z')
  let s:code_a = char2nr('a')
  let s:code_z = char2nr('z')
  let s:size_nu = s:code_9 - s:code_0 + 1
  let s:size_al = s:code_z - s:code_a + 1
  lockvar s:code_0 s:code_9 s:code_A s:code_Z s:code_a s:code_z s:size_nu s:size_al
endif


highlight OrnamentsPopupColor ctermbg=NONE guibg=bg


function! s:grace_notes(char, step) abort
  let code = char2nr(a:char)

  " Note: ASCII order: '0' < '9' < 'A' < 'Z' < 'a' < 'z'
  if s:code_a <= code
    return map(range(0, a:step), 'nr2char(s:code_a + (code + v:val - s:code_a) % s:size_al)')
  elseif code <= s:code_9
    return map(range(0, a:step), 'nr2char(s:code_0 + (code + v:val - s:code_0) % s:size_nu)')
  else
    return map(range(0, a:step), 'nr2char(s:code_A + (code + v:val - s:code_A) % s:size_al)')
  endif
endfunction


function! s:update(popup_opts, grace_notes, interval) abort
  if empty(a:grace_notes)
    return
  endif

  let winid = popup_create(a:grace_notes[-1], a:popup_opts)
  if winid == 0
    throw 'ornaments: popup: failed popup_create()'
  endif

  if type(a:popup_opts.line) != v:t_number
    let pos = popup_getpos(winid)
    let a:popup_opts.line = pos.line
    let a:popup_opts.col = pos.col
  endif
  call timer_start(a:interval, {-> s:update(a:popup_opts, a:grace_notes[:-2], a:interval)})
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
