
" INSTEAD functions

" instead#GrepInsteadObjects(obj) {{{1
function! instead#GrepInsteadObjects(obj) 
  
  " GrepInsteadObjects(obj)
  " Create location list with obj

  " Clear old location list
  call setloclist(0, [])
  " Grep all the lines into location list
  silent! exe 'lvimgrep /^\s*\w\{1,}\s*=\s*[ix]\{0,1}' . a:obj . '/j %'
  " If location list is not empty
  if !empty(getloclist(0))
    echo ""
    lwindow
    " Close llist on WinLeave
    au WinLeave <buffer> execute 'close!'
    " Map <Esc> to close llist
    nnoremap <buffer> <Esc> <C-w>w
    " Map configured keys inside buffer to corresponding
    " actions
    call instead#AddLocListMappings(g:InsteadRoomsKey, 
          \g:InsteadObjsKey, 
          \g:InsteadDlgsKey)
    " Map corresponding key to close llist
    if a:obj == g:InsteadRoomToken
      let l:closekey = g:InsteadRoomsKey
    elseif a:obj == g:InsteadObjToken
      let l:closekey = g:InsteadObjsKey
    elseif a:obj == g:InsteadDlgToken
      let l:closekey = g:InsteadDlgsKey
    else
      echo "Close key defining error!"
    endif
    " Map close key
    execute "nmap <buffer> " . l:closekey . " <C-w>w"
    " Checking window position
    if exists("g:InsteadWindowPosition")
      if g:InsteadWindowPosition == 'left'
        wincmd H
        vertical resize 28
      endif
    endif
    " fixwidth, nowrap
    setlocal winfixwidth
    setlocal nowrap
    " Get rid of junk in llist
    setlocal modifiable
    silent! exe 'g/.*/s/.*|\s*\(\w\{1,}\)\s*=.*/\1/g'
    setlocal nomodifiable
    " Go to top
    normal! gg
  else
    echo "No " . a:obj . "s in file."
  endif
endfunction " 1}}}

" instead#InitGlobals(options) {{{1

" instead#InitGlobals(options)
" Initializes variables in dictionary
" "options" if they are not exists

function! instead#InitGlobals(options)
  if empty(a:options)
    return
  endif
  for variable in keys(a:options)
    if !exists(variable)
      execute "let " . variable . " = '" . a:options[variable] . "'"
    endif
  endfor
endfunction " 1}}}

" instead#InitMappings(mappings) {{{1

" instead#InitMappings(mappings)
" initializes mappings in "mappings" dictionary

function! instead#InitMappings(mappings)
  if empty(a:mappings)
    return
  endif
  for key in keys(a:mappings)
    execute 'nnoremap ' . eval(key) . ' :call instead#GrepInsteadObjects("' . eval(a:mappings[key]) . '")<CR>'
  endfor
endfunction

" 1}}}

" instead#AddLocListMappings(...) {{{1

" instead#AddLocListMappings(...)
" Adds mappings to location list

function! instead#AddLocListMappings(...)
  if a:0 == 0
    return
  endif
  let index = 1
  while index <= a:0
    execute 'nmap <buffer> ' . a:{index} . ' :wincmd w<CR>' . a:{index}
    let index += 1
  endwhile
endfunction

"1}}}

" instead#Init() {{{1
function! instead#Init()

  let options = {
    \ "g:InsteadRoomToken": "room",
    \ "g:InsteadObjToken" : "obj",
    \ "g:InsteadDlgToken" : "dlg",
    \ "g:InsteadRoomsKey" : "<F5>",
    \ "g:InsteadObjsKey"  : "<F6>",
    \ "g:InsteadDlgsKey"  : "<F7>",
    \ "g:InsteadRunKey"   : "<F8>",
    \}

  let mappings = {
    \ "g:InsteadRoomsKey": "g:InsteadRoomToken",
    \ "g:InsteadObjsKey" : "g:InsteadObjToken",
    \ "g:InsteadDlgsKey"  : "g:InsteadDlgToken",
    \}

  call instead#InitGlobals(options)
  call instead#InitMappings(mappings)

  " Dirty mapping for InsteadRun
  exec "nmap " . g:InsteadRunKey . " :InsteadRun<CR>"

endfunction
" 1}}}

colorscheme writer
highlight lCursor guifg=NONE guibg=DarkYellow
set foldmethod=syntax

imap <F5> <Esc><F5>
imap <F6> <Esc><F6>
imap <F7> <Esc><F7>
imap <F8> <Esc><F8>
nmap <C-c> :call MKC(0)<CR>
imap <C-c> <Esc>:call MKC(1)<CR>

nmap <leader>c :call MKC(0)<CR>`fh 
" Form xact-link on current word
nmap <leader>x ea}<Esc>bi{\|<Esc>i

" vim:foldmethod=marker
