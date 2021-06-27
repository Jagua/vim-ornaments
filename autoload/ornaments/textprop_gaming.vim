let s:save_cpo = &cpo
set cpo&vim


let s:default_colors = {
      \ 'dark' : ['LightGreen', 'LightYellow', 'LightMagenta', 'LightRed', 'LightMagenta', 'LightCyan', 'LightBlue', 'LightCyan'],
      \ 'light' : ['DarkGreen', 'DarkYellow', 'DarkMagenta', 'DarkRed', 'DarkMagenta', 'DarkCyan', 'DarkBlue', 'DarkCyan'],
      \}


function! ornaments#textprop_gaming#on_BufWinEnter() abort
  call s:init(get(g:, 'ornaments_colors', s:default_colors))
endfunction


function! ornaments#textprop_gaming#on_ColorScheme() abort
  call s:init(get(g:, 'ornaments_colors', s:default_colors))
endfunction


function! ornaments#textprop_gaming#on_InsertCharPre() abort
  if !ornaments#textprop_gaming#ornamentable() || v:char !~# '[[:alnum:]]'
    return
  endif

  let s:start_time = get(s:, 'start_time', reltime())
  let step = get(g:, 'ornaments_step', 8)
  let [a, b] = reltime(s:start_time)
  let opts = {
        \ 'id' : a * 1000000 + b,
        \ 'colors' : get(g:, 'ornaments_colors', s:default_colors),
        \ 'time' : get(g:, 'ornaments_interval', 350),
        \ 'lnum' : line('.'),
        \ 'col' : col('.'),
        \ 'winid' : win_getid(),
        \}
  call timer_start(0, {-> s:update(opts, 0, step)})
endfunction


function! ornaments#textprop_gaming#ornamentable() abort
  return get(g:, 'ornaments_enable', 1) && get(b:, 'ornaments_enable', 1)
endfunction


function! s:init(colors) abort
  for i in range(len(a:colors[&background]))
    execute printf('highlight OrnamentsChar%d guifg=%s guibg=bg', i, a:colors[&background][i])
  endfor

  for i in range(len(a:colors[&background]))
    let group = printf('OrnamentsChar%d', i)
    if !empty(prop_type_get(group, {'bufnr' : bufnr()}))
      continue
    endif
    call prop_type_add(group, {
          \ 'highlight' : printf('OrnamentsChar%d', i),
          \ 'priority' : i,
          \ 'bufnr' : bufnr(),
          \ 'start_incl' : v:true,
          \ 'end_incl' : v:false,
          \})
  endfor
endfunction


function! s:update(opts, color_index, step) abort
  if a:step == 0
    call win_execute(a:opts.winid, printf('call prop_remove({"id" : %d, "all" : v:true}, %d)', a:opts.id, a:opts.lnum), 'silent!')
    return
  endif

  call win_execute(a:opts.winid, printf('call prop_add(%d, %d, {"type" : "OrnamentsChar%d", "length" : 1, "id" : %d})', a:opts.lnum, a:opts.col, a:color_index, a:opts.id), 'silent!')

  call timer_start(a:opts.time, {-> s:update(a:opts, (a:color_index + 1) % len(a:opts.colors[&background]), a:step - 1)})
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
