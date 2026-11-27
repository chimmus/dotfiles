let mapleader = " "

nnoremap <leader>cd :Ex<CR>
set mouse=a

if has('macunix')
      set clipboard=unnamed
endif

if filereadable('/etc/os-release') && match(readfile('/etc/os-release'), 'ID=ubuntu') != -1
  " --- Yank to macOS clipboard via OSC 52 ---
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

  " --- Paste from macOS clipboard via OSC 52 ---
  function! Osc52Paste()
    let tty = '/dev/tty'
    " Save terminal settings, switch to raw mode without echo to read response
    let saved_stty = system('stty -g < ' . tty)
    call system('stty raw -echo min 0 time 5 < ' . tty)
    call writefile(["\e]52;c;?\x07"], tty, 'b')

    let resp = ''
    while 1
      let ch = system('dd bs=1 count=1 2>/dev/null < ' . tty)
      if empty(ch) || ch ==# "\x07"
        break
      endif
      let resp .= ch
    endwhile

    call system('stty ' . trim(saved_stty) . ' < ' . tty)
    redraw!

    let b64 = matchstr(resp, '52;c;\zs.*')
    if !empty(b64)
      let @" = system('base64 -d', b64)
      normal! ""p
    endif
  endfunction

  nnoremap <leader>p :call Osc52Paste()<CR>
endif
