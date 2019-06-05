let s:save_cpo = &cpo
set cpo&vim


function! ornaments#on_BufEnter() abort
  if ornaments#ornamentable()
    call ornaments#start()
  endif
endfunction


function! ornaments#on_CmdwinEnter() abort
  if ornaments#ornamentable()
    call ornaments#start()
  endif
endfunction


function! ornaments#on_BufDelete() abort
  call ornaments#stop()
endfunction


function! ornaments#on_BufLeave() abort
  call ornaments#stop()
endfunction


function! ornaments#on_CmdwinLeave() abort
  call ornaments#stop()
endfunction


function! ornaments#on_InsertCharPre() abort
  if ornaments#ornamentable() && v:char =~# '[[:graph:][:blank:]]'
    let [_, lnum, col; _] = getcurpos()
    let step = get(g:, 'ornaments_step', 5)
    call add(b:ornaments_queue, {
          \ 'char' : v:char,
          \ 'lnum' : lnum,
          \ 'col' : col,
          \ 'counter' : step - 1})
  endif
endfunction


function! ornaments#start() abort
  let interval = get(g:, 'ornaments_interval', 50)
  let b:ornaments_queue = []
  let b:ornaments_timer_id =
        \ timer_start(interval, function('s:update_ornaments'), {'repeat' : -1})
endfunction


function! ornaments#stop() abort
  if exists('b:ornaments_timer_id')
    call timer_stop(b:ornaments_timer_id)
    unlet b:ornaments_timer_id
    while !empty(b:ornaments_queue)
      call s:update_ornaments()
    endwhile
  endif
endfunction


function! ornaments#ornamentable() abort
  return get(g:, 'ornaments_enable', 1) && get(b:, 'ornaments_enable', 1) && has('timers')
endfunction


function! s:update_ornaments(...) abort
  if !empty(b:ornaments_queue)
    noautocmd call map(s:new_lines(), 'setline(v:key, v:val["line"])')
  endif
endfunction


function! s:new_lines() abort
  let lines = {}
  for i in range(len(b:ornaments_queue))
    let queue = b:ornaments_queue[i]
    let lnum = queue['lnum']
    if has_key(lines, lnum)
      let start_col = lines[lnum]['start_col']
      let end_col = lines[lnum]['end_col']
      let str = lines[lnum]['str']
    else
      let start_col = 9999
      let end_col = -1
      let lines[lnum] = {}
      let lines[lnum]['getline'] = getline(lnum)
      let str = ''
    endif
    if start_col > queue['col']
      let start_col = queue['col']
    endif
    if end_col < queue['col']
      let end_col = queue['col']
    endif
    let str .= nr2char(char2nr(queue['char']) - queue['counter'])

    let lines[lnum]['start_col'] = start_col
    let lines[lnum]['end_col'] = end_col
    let lines[lnum]['str'] = str

    let line = lines[lnum]['getline']
    let pre = start_col < 2 ? '' : line[ : start_col - 2]
    let remain = end_col != -1 && len(line) >= end_col ? line[end_col : ] : ''
    let lines[lnum]['line'] = pre . str . remain
    let queue['counter'] -= 1
    let b:ornaments_queue[i] = queue
  endfor
  call filter(b:ornaments_queue, 'v:val["counter"] >= 0')
  return lines
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
