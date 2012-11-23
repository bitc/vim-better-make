" better-make.vim - Provides the :Make command which is better than :make
" Maintainer:   Bit Connor <mutantlemon@gmail.com>
" Version:      0.1

function! s:Make(bang, arg)
  " Save the original position of the cursor
  let l:orig_cursor = getpos(".")

  " Execute the builtin make command
  exe "make".a:bang a:arg

  " Open the quickfix window when there are recognized errors
  cwindow

  " Check the current position of the cursor
  let l:after_cursor = getpos(".")

  " If the cursor moved to a different location, then it means that it jumped
  " to an error location, and we'll leave it there.
  "
  " If however, it only moved to the beginning of the current line that it was
  " originally on, it means that most likely there
  if l:orig_cursor[0] == l:after_cursor[0] && l:orig_cursor[1] == l:after_cursor[1]
    call setpos('.', l:orig_cursor)
  endif
endfunction

command! -bang -nargs=* Make call <SID>Make('<bang>', '<args>')
