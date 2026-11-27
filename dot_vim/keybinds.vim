let mapleader = " "

nnoremap <leader>cd :Ex<CR>
set mouse=a

if has('macunix')
      set clipboard=unnamed
endif

function! Osc52Yank()
      let buffer = system('base64 | tr -d "\n"', @0)
        let buffer = "\e]52;c;" . buffer . "\x07"
          silent exe "!echo -ne " . shellescape(buffer) . " > /dev/tty"
            redraw!
endfunction

augroup Osc52
      autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call Osc52Yank() | endif
augroup END
