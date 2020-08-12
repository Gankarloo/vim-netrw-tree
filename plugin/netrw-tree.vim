" Make netrw behave as I like.
" Stolen from http://ivanbrennan.nyc/2014-01-16/rigging-vims-netrw

function! VexToggle(dir)
  if exists("t:vex_buf_nr")
    call VexClose()
  else
    call VexOpen(a:dir)
  endif
endfunction

function! VexOpen(dir)
  let g:netrw_browse_split=4    " open files in previous window
  let vex_width = 25

  execute "Vexplore " . a:dir
  let t:vex_buf_nr = bufnr("%")
  wincmd H

  call VexSize(vex_width)
endfunction

"noremap <Leader><Tab> :call VexToggle(getcwd())<CR>
"noremap <Leader>` :call VexToggle("")<CR>

function! VexClose()
  let cur_win_nr = winnr()
  let target_nr = ( cur_win_nr == 1 ? winnr("#") : cur_win_nr )

  1wincmd w
  close
  unlet t:vex_buf_nr

  execute (target_nr - 1) . "wincmd w"
  call NormalizeWidths()
endfunction

function! VexSize(vex_width)
  execute "vertical resize" . a:vex_width
  set winfixwidth
  call NormalizeWidths()
endfunction

function! NormalizeWidths()
  let eadir_pref = &eadirection
  set eadirection=hor
  set equalalways! equalalways!
  let &eadirection = eadir_pref
endfunction

augroup NetrwGroup
  autocmd! BufEnter * call NormalizeWidths()
augroup END

augroup NetrwESC
  autocmd!
  autocmd FileType netrw :nmap <silent><expr> <ESC> 
  \ popup_findpreview() ? popup_close(popup_findpreview()) : 
  \ "\<ESC>"
augroup END


