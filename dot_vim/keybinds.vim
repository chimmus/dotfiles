let mapleader = " "

nnoremap <leader>cd :Ex<CR>
set mouse=a

if has('macunix')
      set clipboard=unnamed
endif

" Yank to the host clipboard via OSC 52 when running inside a container
if filereadable('/run/.containerenv') || filereadable('/.dockerenv')
  function! s:osc52_yank() abort
    let l:text = join(v:event.regcontents, "\n")
    if v:event.regtype ==# 'V'
      let l:text .= "\n"
    endif
    let l:b64 = system('base64 | tr -d "\n"', l:text)
    call writefile(["\e]52;c;" . l:b64 . "\x07"], '/dev/tty', 'b')
  endfunction

  augroup osc52_yank
    autocmd!
    autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | call s:osc52_yank() | endif
  augroup END
endif
