" {{{1 latex#change#init
function! latex#change#init(initialized)
  if g:latex_default_mappings
    vnoremap <silent><buffer> <localleader>l*
          \ :call latex#change#change_environment_toggle_star()<cr>
  endif
endfunction

" {{{1 latex#change#environment
function! latex#change#environment(new_env)
  let [env, l1, c1, l2, c2] = latex#util#get_env(1)

  if a:new_env == '\[' || a:new_env == '['
    let beg = '\['
    let end = '\]'
    let n1 = 1
    let n2 = 1
  elseif a:new_env == '\(' || a:new_env == '('
    let beg = '\('
    let end = '\)'
    let n1 = 1
    let n2 = 1
  else
    let beg = '\begin{' . a:new_env . '}'
    let end = '\end{' . a:new_env . '}'
    let n1 = len(env) + 7
    let n2 = len(env) + 5
  endif

  let line = getline(l1)
  let line = strpart(line, 0, c1 - 1) . l:beg . strpart(line, c1 + n1)
  call setline(l1, line)
  let line = getline(l2)
  let line = strpart(line, 0, c2 - 1) . l:end . strpart(line, c2 + n2)
  call setline(l2, line)
endfunction

" {{{1 latex#change#environment_prompt
function! latex#change#environment_prompt()
  let new_env = input('Change ' . latex#util#get_env() . ' for: ', '',
        \ 'customlist,' . s:sidwrap('input_complete'))
  if empty(new_env)
    return
  else
    call latex#change#environment(new_env)
  endif
endfunction

" {{{1 latex#change#environment_toggle_star
function! latex#change#environment_toggle_star()
  let env = latex#util#get_env()

  if env == '\('
    return
  elseif env == '\['
    let new_env = equation
  elseif env[-1:] == '*'
    let new_env = env[:-2]
  else
    let new_env = env . '*'
  endif

  call latex#change#environment(new_env)
endfunction

" {{{1 latex#change#wrap_selection
function! latex#change#wrap_selection(wrapper)
  keepjumps normal! `>a}
  execute 'keepjumps normal! `<i\' . a:wrapper . '{'
endfunction

" {{{1 latex#change#wrap_selection_prompt
function! latex#change#wrap_selection_prompt(...)
  let env = input('Environment: ', '',
        \ 'customlist,' . s:sidwrap('input_complete'))
  if empty(env)
    return
  endif

  " Make sure custom indentation does not interfere
  let ieOld = &indentexpr
  setlocal indentexpr=""

  if visualmode() ==# 'V'
    execute 'keepjumps normal! `>o\end{' . env . '}'
    execute 'keepjumps normal! `<O\begin{' . env . '}'
    " indent and format, if requested.
    if a:0 && a:1
      normal! gv>
      normal! gvgq
    endif
  else
    execute 'keepjumps normal! `>a\end{' . env . '}'
    execute 'keepjumps normal! `<i\begin{' . env . '}'
  endif

  exe "setlocal indentexpr=" . ieOld
endfunction
" }}}1

" {{{1 s:sidwrap
let s:SID = matchstr(expand('<sfile>'), '\zs<SNR>\d\+_\ze.*$')
function! s:sidwrap(func)
  return s:SID . a:func
endfunction

" {{{1 s:input_complete
function! s:input_complete(lead, cmdline, pos)
  let suggestions = []
  for entry in g:latex_complete_environments
    let env = entry.word
    if env =~ '^' . a:lead
      call add(suggestions, env)
    endif
  endfor
  return suggestions
endfunction

" {{{1 s:search_and_skip_comments
function! s:search_and_skip_comments(pat, ...)
  " Usage: s:search_and_skip_comments(pat, [flags, stopline])
  let flags             = a:0 >= 1 ? a:1 : ''
  let stopline  = a:0 >= 2 ? a:2 : 0
  let saved_pos = getpos('.')

  " search once
  let ret = search(a:pat, flags, stopline)

  if ret
    " do not match at current position if inside comment
    let flags = substitute(flags, 'c', '', 'g')

    " keep searching while in comment
    while latex#util#in_comment()
      let ret = search(a:pat, flags, stopline)
      if !ret
        break
      endif
    endwhile
  endif

  if !ret
    " if no match found, restore position
    call setpos('.', saved_pos)
  endif

  return ret
endfunction
" }}}1 Modeline

" vim:fdm=marker:ff=unix
