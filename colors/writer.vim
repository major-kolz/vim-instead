" Vim color file
" Maintainer:	Nikolay Konovalow <major.kolz@gmail.com>
" Last Change:	2015 Mar 9

" First remove all existing highlighting.
set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "writer"

hi Normal      guifg=#47b8b8
hi Statement   guifg=#47b8b8 gui=bold
hi Repeat      guifg=#47b8b8 gui=bold
hi Operator    guifg=#000000 guibg=#ffffcc
hi SpecialChar guifg=#000000 guibg=#ffffcc
hi String      guifg=#000000
hi Character	guifg=#00ffff
hi Constant    guifg=#00ffff 
hi Number		guifg=#00ffff
hi Function    guifg=#cfe7f5 gui=bold
hi Structure   guifg=#808080
hi Comment		guifg=#aea79f
hi Todo        guifg=blue    guibg=yellow
