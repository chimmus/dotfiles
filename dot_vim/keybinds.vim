let mapleader = " "

nnoremap <leader>cd :Ex<CR>
set mouse=a

if has('macunix')
      set clipboard=unnamed
endif

if filereadable('/etc/os-release') && match(readfile('/etc/os-release'), 'ID=ubuntu') != -1
  function! s:WrapOsc52(seq)
    if !empty($TMUX)
      " Escape ESC as ESC ESC and wrap in tmux DCS passthrough
      return "\ePtmux;\e" . substitute(a:seq, "\e", "\e\e", 'g') . "\e\\"
    endif
    return a:seq
  endfunction

  " --- Yank to macOS clipboard via OSC 52 ---
  function! Osc52Yank()
    let b64 = system('base64 | tr -d "\n"', @0)
    let seq = s:WrapOsc52("\e]52;c;" . b64 . "\x07")
    silent exe "!printf " . shellescape(seq) . " > /dev/tty"
    redraw!
  endfunction

  augroup Osc52
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call Osc52Yank() | endif
  augroup END

  " --- Paste from macOS clipboard via OSC 52 ---
  function! Osc52Paste()
    let tty = '/dev/tty'
    let saved_stty = system('stty -g < ' . tty)
    call system('stty raw -echo min 0 time 5 < ' . tty)
    call writefile([s:WrapOsc52("\e]52;c;?\x07")], tty, 'b')

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
