let s:save_cpo = &cpo
set cpo&vim


function! ornaments#conceal#on_InsertCharPre() abort
  if !ornaments#conceal#ornamentable() || v:char !~# '[[:alnum:]]'
    return
  endif

  setlocal conceallevel=1 concealcursor=ic
  highlight Conceal guifg=fg guibg=bg

  let step = get(g:, 'ornaments_step', 3)
  let grace_notes = s:grace_notes(v:char, step)
  let interval = get(g:, 'ornaments_interval', 70)
  let opts = {
        \ 'id' : -1,
        \ 'pos' : [[line('.'), col('.')]],
        \ 'time' : interval,
        \}
  call s:update(opts, grace_notes)
endfunction


function! ornaments#conceal#ornamentable() abort
  return get(g:, 'ornaments_enable', 1) && get(b:, 'ornaments_enable', 1)
endfunction


const s:code_0 = char2nr('0')
const s:code_9 = char2nr('9')
const s:code_A = char2nr('A')
const s:code_Z = char2nr('Z')
const s:code_a = char2nr('a')
const s:code_z = char2nr('z')
const s:size_nu = s:code_9 - s:code_0 + 1
const s:size_al = s:code_z - s:code_a + 1


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


function! s:update(opts, grace_notes) abort
  if a:opts.id != -1
    call matchdelete(a:opts.id)
  endif

  if empty(a:grace_notes)
    return
  endif

  let a:opts.id = matchaddpos('Conceal', a:opts.pos, 10, -1, {'conceal' : a:grace_notes[-1]})

  call timer_start(a:opts.time, {-> s:update(a:opts, a:grace_notes[:-2])})
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
