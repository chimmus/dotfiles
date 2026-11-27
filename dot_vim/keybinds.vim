let mapleader = " "

nnoremap <leader>cd :Ex<CR>
set mouse=a

if has('macunix')
      set clipboard=unnamed
endif


if !empty($TMUX) && filereadable('/etc/os-release') && match(readfile('/etc/os-release'), 'ID=ubuntu') != -1
      augroup TmuxClipboard
              autocmd!
                  autocmd TextYankPost * if v:event.operator ==# 'y' | call system('tmux load-buffer -w -', @0) | endif
                    augroup END
endif

