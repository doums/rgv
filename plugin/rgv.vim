" This Source Code Form is subject to the terms of the Mozilla Public
" License, v. 2.0. If a copy of the MPL was not distributed with this
" file, You can obtain one at https://mozilla.org/MPL/2.0/.

if exists('g:rgv_plugin')
  finish
endif
let g:rgv_plugin = 1

let s:save_cpo = &cpo
set cpo&vim

if !executable('rg')
  call rgv#printerr('rg command not found')
  let &cpo = s:save_cpo
  unlet s:save_cpo
  finish
endif

command -nargs=* Rg call rgv#rg(<q-args>)
command -nargs=* Rga call rgv#rga(<q-args>)
noremap <silent><unique> <Plug>RgToggle :call rgv#toggle_locwin()<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
