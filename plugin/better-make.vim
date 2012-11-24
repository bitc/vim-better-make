" better-make.vim - Provides the :Make command which is better than :make
" Maintainer:   Bit Connor <mutantlemon@gmail.com>
" Version:      0.1

function! s:Make(bang, arg)
  " Save the original position of the cursor
  let l:saved_cursor = getpos(".")

  " Execute the builtin make command
  exe "make!" a:arg

  " Check if there are any recognized errors
  let l:recognized_errors = 0
  for d in getqflist()
    if d.valid
      let l:recognized_errors = 1
      break
    endif
  endfor

  if !l:recognized_errors
    cclose
    " Restore the cursor to the previously saved position
    call setpos('.', l:saved_cursor)
    return
  endif

  if a:bang == "!"
    " Save the previous window (in order to not disrupt CTRL-W_p)
    let l:prev_win = winnr("#")
    " Save the current window in order to detect openining of the quickfix
    let l:cur_win = winnr()
    " Open the quickfix window
    cwindow
    if winnr() != l:cur_win
      " The quickfix has been opened, so we jump back to the original window,
      " first passing through the previous window in order to preserve the
      " original state
      exe l:prev_win "wincmd w"
      exe l:cur_win "wincmd w"
    endif
  else
    " Open the quickfix window and jump to it
    copen
    " Jump to the first error (see :help quickfix)
    :.cc
  endif
endfunction

command! -bang -nargs=* Make call <SID>Make('<bang>', '<args>')
