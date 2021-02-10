" This Source Code Form is subject to the terms of the Mozilla Public
" License, v. 2.0. If a copy of the MPL was not distributed with this
" file, You can obtain one at https://mozilla.org/MPL/2.0/.

if exists('g:rgv')
  finish
endif
let g:rgv = 1

let s:save_cpo = &cpo
set cpo&vim

let g:rg_command = ['rg', '--vimgrep']
let g:rg_all_opt = ['--hidden', '--no-ignore']
let g:efm = '%f:%l:%c:%m'
let s:data = []

function! rgv#toggle_locwin()
  try
    if getloclist(0, {'winid' : 1}).winid
      lclose 
    else
      lopen
    endif
  catch
    call rgv#printerr(v:exception)
  endtry
endfunction

function! s:exit_cb(jobid, status, ...)
  if a:status == 2
    call rgv#printerr('rg fails')
    return
  elseif a:status == 1
    echom 'no match found'
    return
  endif
  let count = len(s:data) - 1
  if count == 1
    echom '1 match found'
  else
    echom count.' matches found'
  endif
  call setloclist(0, [], ' ', {'title': 'rg', 'lines' : s:data, 'efm': g:efm })
  lopen
endfunction

function! s:out_cb(job, data, ...)
  if len(a:data) <= 1 && empty(a:data[0])
    return
  endif
  let s:data = a:data  
endfunction

function! rgv#rg(args) abort
  let command = copy(g:rg_command)
  if has('nvim')
    let options = {
          \ 'stdout_buffered': 1,
          \ 'on_stdout': function('s:out_cb'),
          \ 'on_exit': function('s:exit_cb')
          \ }
  else
    let options = {
          \ 'out_cb': function('s:out_cb'),
          \ 'exit_cb': function('s:exit_cb')
          \ }
  endif
  if empty(a:args)
    let word = expand("<cword>")
    if empty(word)
      call rgv#printerr('expected pattern')
      return
    endif
    let command = add(command, word)
  else
    if type(a:args) == v:t_list
      let command = extend(command, a:args)
    else
      let command = add(command, a:args)
    endif
  endif
  let command = split(&shell) + split(&shellcmdflag) + [join(command)]
  if has('nvim')
    call jobstart(command, options)
  else
    call job_start(command, options)
  endif
endfunction

function! rgv#rga(args)
  let command = copy(g:rg_all_opt)
  if empty(a:args)
    let word = expand("<cword>")
    if empty(word)
      call rgv#printerr('expected pattern')
      return
    endif
    let command = add(command, word)
  else
    let command = add(command, a:args)
  endif
  call rgv#rg(command)
endfunction

function! rgv#printerr(msg)
  echohl ErrorMsg
  echom a:msg
  echohl None
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
