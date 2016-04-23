"== Vim syntax file (adopted for INSTEAD [instead.syscall.ru] programming) ==
" Language:      Lua 4.0, Lua 5.0, Lua 5.1 and Lua 5.2
" Maintainer:    Nikolay Konovalow <major.kolz 'at' gmail com>
" First Author:  Carlos Augusto Teixeira Mendes <cmendes 'at' inf puc-rio br>
" Second Author: Marcus Aurelius Farias <masserahguard-lua 'at' yahoo com>
" Last Change:   2015 Jul 7
" Options:
"       lua_version = 4 or 5
"       lua_subversion = 0 (4.0, 5.0) or 1 (5.1) or 2 (5.2)
"       default 5.2
"============================================================================

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

if !exists("lua_version")
  " Default is lua 5.2
  let lua_version = 5
  let lua_subversion = 2
elseif !exists("lua_subversion")
  " lua_version exists, but lua_subversion doesn't. So, set it to 0
  let lua_subversion = 0
endif

syn case match

" Syncing method: how many lines vim parse backward for avoiding mismatch in highlighting
syn sync minlines=250

"=================================== Comments ========================================
syn keyword luaTodo contained TODO FIXME XXX
syn match   luaComment  "--.*$" contains=luaTodo,@Spell,INSTEADTags
if lua_version == 5 && lua_subversion == 0
  syn region luaComment matchgroup=luaComment start="--\[\[" end="\]\]" contains=luaTodo,luaInnerComment,@Spell
  syn region luaInnerComment contained transparent start="\[\[" end="\]\]"
elseif lua_version > 5 || (lua_version == 5 && lua_subversion >= 1)
  " Comments in Lua 5.1: --[[ ... ]], [=[ ... ]=], [===[ ... ]===], etc.
  syn region luaComment matchgroup=luaComment start="--\[\z(=*\)\[" end="\]\z1\]" contains=luaTodo,INSTEADTags,@Spell
endif

" First line may start with #!
syn match luaComment "\%^#!.*"
" INSTEAD's header-tags in comments
syn region INSTEADTags contained matchgroup=luaComment start="\$\%(Name\|Author\|Version\):" end="\$" contains=@Spell

"=================================== Brackets ========================================
syn region luaParen transparent start='(' end=')' contains=ALLBUT,luaParenError,luaTodo,luaSpecial,luaIfThen,luaElseifThen,luaElse,luaThenEnd,luaBlock,luaLoopBlock,luaIn,luaStatement,INSTEADStringControl,INSTEADSpecial,luaSpecial
syn region luaTableBlock transparent matchgroup=luaTable start="{" end="}" contains=ALLBUT,luaBraceError,luaTodo,luaSpecial,luaIfThen,luaElseifThen,luaElse,luaThenEnd,luaBlock,luaLoopBlock,luaIn,luaStatement,INSTEADStringControl

syn match  luaParenError ")"
syn match  luaBraceError "}"

"================================ INSTEAD foldings ===================================
syn region INSTEADObjBlock transparent matchgroup=luaTable start="\sway = {" end="}[,;]" fold
syn region INSTEADObjBlock transparent matchgroup=luaTable start="\sobj = {" end="}[,;]" fold
syn region INSTEADObjBlock transparent matchgroup=luaFuncCall start="\<var\ *{" end="}[,;]" fold 
syn region INSTEADObjBlock transparent matchgroup=luaFuncCall start="\<global\ *{" end="}" fold 

"=================================== Strings =========================================
  " INSTEAD text's control words. 
syn match INSTEADStringControl contained "\[cut\]"
syn match INSTEADStringControl contained "\[upd\]"
syn match INSTEADStringControl contained "{"
  " Links: '{xact|text}', '{xact(arg)|text}', '{xact(' .. arg .. ')|text}'
syn match INSTEADStringControl contained "{[a-zA-Z0-9_)(]\+[(|]"
  " Link's )| part
syn match INSTEADStringControl contained ")|"
  " Link's text
syn match INSTEADStringControl contained "{[а-яА-я"]*}"
syn match INSTEADStringControl contained "}"
syn match INSTEADSpecial contained "\^" 
syn match INSTEADSpecial contained '\\"'
syn match INSTEADSpecial contained '\\\\'
	" For my _say function
syn match INSTEADSpecial contained '@[a-zA-Z_]*'
syn region INSTEADCutsceneCode contained matchgroup=luaFuncCall start="\[code" end="\]" contains=luaFuncCall

if lua_version < 5
  syn match  luaSpecial contained "\\[\\abfnrtv\'\"]\|\\[[:digit:]]\{,3}"
elseif lua_version == 5
  if lua_subversion == 0
    syn match  luaSpecial contained #\\[\\abfnrtv'"[\]]\|\\[[:digit:]]\{,3}#
    syn region luaMultiLineString matchgroup=Normal start=+\[\[+ end=+\]\]+ contains=luaMultiLineString,INSTEADSpecial,INSTEADStringControl,@Spell
  else
    if lua_subversion == 1
      syn match  luaSpecial contained #\\[\\abfnrtv'"]\|\\[[:digit:]]\{,3}#
    else " Lua 5.2
      syn match  luaSpecial contained #\\[\\abfnrtvz'"]\|\\x[[:xdigit:]]\{2}\|\\[[:digit:]]\{,3}#
    endif
    syn region luaMultiLineString matchgroup=Normal start="\[\z(=*\)\[" end="\]\z1\]" contains=INSTEADSpecial,INSTEADStringControl,INSTEADCutsceneCode,@Spell
  endif
endif
syn region luaString matchgroup=Normal start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=INSTEADSpecial,INSTEADStringControl,@Spell
syn region luaSingleQuoteString start=+'+ end=+'+ skip=+\\\\\|\\'+ contains=luaSpecial

"=================================== Numbers =========================================
  " Integer
syn match luaNumber "\<\d\+\>"
  " Floating point number, with dot, optional exponent
syn match luaNumber  "\<\d\+\.\d*\%([eE][-+]\=\d\+\)\=\>"
  " Floating point number, starting with a dot, optional exponent
syn match luaNumber  "\.\d\+\%([eE][-+]\=\d\+\)\=\>"
  " Floating point number, without dot, with exponent
syn match luaNumber  "\<\d\+[eE][-+]\=\d\+\>"
  " hex numbers
if lua_version >= 5
  if lua_subversion == 1
    syn match luaNumber "\<0[xX]\x\+\>"
  elseif lua_subversion >= 2
    syn match luaNumber "\<0[xX][[:xdigit:].]\+\%([pP][-+]\=\d\+\)\=\>"
  endif
endif

"=================================== Constructions ===================================
  " Incomplete constructions 
syn match  luaError "\<\%(end\|else\|elseif\|then\|until\|in\)\>"
  " function ... end
syn region luaFunctionBlock transparent matchgroup=luaFunction start="\<function\>" end="\<end\>" fold contains=ALLBUT,luaTodo,luaSpecial,luaElseifThen,luaElse,luaThenEnd,luaIn,INSTEADStringControl,
   " else
syn keyword luaElse contained else 
  " then ... end
syn region luaThenEnd contained transparent matchgroup=luaCond start="\<then\>" end="\<end\>" contains=ALLBUT,luaTodo,luaSpecial,luaThenEnd,luaIn,INSTEADStringControl
  " elseif ... then
syn region luaElseifThen contained transparent matchgroup=luaCond start="\<elseif\>" end="\<then\>" contains=ALLBUT,luaTodo,luaSpecial,luaElseifThen,luaElse,luaThenEnd,luaIn,INSTEADStringControl
	" if ... then
syn region luaIfThen transparent matchgroup=luaCond start="\<if\>" end="\<then\>"me=e-4 contains=ALLBUT,luaTodo,luaSpecial,luaElseifThen,luaElse,luaIn,INSTEADStringControl nextgroup=luaThenEnd skipwhite skipempty
  " do ... end
syn region luaBlock transparent matchgroup=luaStatement start="\<do\>" end="\<end\>" contains=ALLBUT,luaTodo,luaSpecial,luaElseifThen,luaElse,luaThenEnd,luaIn,INSTEADStringControl
  " repeat ... until
syn region luaLoopBlock transparent matchgroup=luaRepeat start="\<repeat\>" end="\<until\>" contains=ALLBUT,luaTodo,luaSpecial,luaElseifThen,luaElse,luaThenEnd,luaIn,INSTEADStringControl
  " while ... do
syn region luaLoopBlock transparent matchgroup=luaRepeat start="\<while\>" end="\<do\>"me=e-2 contains=ALLBUT,luaTodo,luaSpecial,luaIfThen,luaElseifThen,luaElse,luaThenEnd,luaIn,INSTEADStringControl nextgroup=luaBlock skipwhite skipempty
  " for ... do and for ... in ... do
syn region luaLoopBlock transparent matchgroup=luaRepeat start="\<for\>" end="\<do\>"me=e-2 contains=ALLBUT,luaTodo,luaSpecial,luaIfThen,luaElseifThen,luaElse,luaThenEnd,INSTEADStringControl nextgroup=luaBlock skipwhite skipempty

syn keyword luaIn contained in
syn match luaPunctuation "\%(\.\.\|\.\)"

"=================================== Keywords ========================================
  " INSTEAD's keywords
syn keyword luaFunc instead_version
syn match   luaFunc "stead\.\<\%(scene_delim\|unpack\|add_var\|restart\)\>"
syn keyword luaFuncCall take takef remove have put putf place placef placeto drop dropf seen taken
syn keyword luaFuncCall p pn pr
syn keyword luaFuncCall time walk rnd back visited visits walkin
syn keyword luaFuncCall enable disable move disable_all enable_all disabled
syn keyword luaFuncCall lifeon lifeoff live sprite img 
syn keyword luaFuncCall seen exist ref deref change_pl
syn keyword luaFuncCall vroom xact vway vobj
syn keyword luaFuncCall pon poff prem pseen punseen psub pjump pstart
syn keyword luaFuncCall set_music restore_music is_music stop_music
syn keyword luaFuncCall set_sound  stop_sound add_sound
syn keyword luaFuncCall txtc txtr txtl txttop txtbottom txtmiddle txtb txtem txtu txtst txtnb txttab
syn keyword luaFuncCall path objs ways here where add del
syn match luaFuncCall "\<\(me\|from\|inv\)\ *\((\)\@="
syn region _noMatterName_ transparent matchgroup=luaFuncCall start="\<code\ *\[\[" end="\]\]" contains=ALLBUT,luaBraceError,luaTodo,luaSpecial,INSTEADStringControl

  " Reserved 
syn keyword luaStatement return local break
if lua_version > 5 || (lua_version == 5 && lua_subversion >= 2)
  syn keyword luaStatement goto
  syn match luaLabel "::\I\i*::"
endif
syn keyword luaOperator and or not
syn keyword luaConstant nil
if lua_version > 4
  syn keyword luaConstant true false
endif

syn keyword luaFunc assert collectgarbage dofile error next
syn keyword luaFunc print rawget rawset tonumber tostring type _VERSION

if lua_version == 4
  syn keyword luaFunc _ALERT _ERRORMESSAGE gcinfo
  syn keyword luaFunc call copytagmethods dostring
  syn keyword luaFunc foreach foreachi getglobal getn
  syn keyword luaFunc gettagmethod globals newtag
  syn keyword luaFunc setglobal settag settagmethod sort
  syn keyword luaFunc tag tinsert tremove
  syn keyword luaFunc _INPUT _OUTPUT _STDIN _STDOUT _STDERR
  syn keyword luaFunc openfile closefile flush seek
  syn keyword luaFunc setlocale execute remove rename tmpname
  syn keyword luaFunc getenv date clock exit
  syn keyword luaFunc readfrom writeto appendto read write
  syn keyword luaFunc PI abs sin cos tan asin
  syn keyword luaFunc acos atan atan2 ceil floor
  syn keyword luaFunc mod frexp ldexp sqrt min max log
  syn keyword luaFunc log10 exp deg rad random
  syn keyword luaFunc randomseed strlen strsub strlower strupper
  syn keyword luaFunc strchar strrep ascii strbyte
  syn keyword luaFunc format strfind gsub
  syn keyword luaFunc getinfo getlocal setlocal setcallhook setlinehook
elseif lua_version == 5
  syn keyword luaFunc getmetatable setmetatable
  syn keyword luaFunc ipairs pairs
  syn keyword luaFunc pcall xpcall
  syn keyword luaFunc _G loadfile rawequal require
  if lua_subversion == 0
    syn keyword luaFunc getfenv setfenv
    syn keyword luaFunc loadstring unpack
    syn keyword luaFunc gcinfo loadlib LUA_PATH _LOADED _REQUIREDNAME
  else
    syn keyword luaFunc load select
    syn match   luaFunc /\<package\.cpath\>/
    syn match   luaFunc /\<package\.loaded\>/
    syn match   luaFunc /\<package\.loadlib\>/
    syn match   luaFunc /\<package\.path\>/
    if lua_subversion == 1
      syn keyword luaFunc getfenv setfenv
      syn keyword luaFunc loadstring module unpack
      syn match   luaFunc /\<package\.loaders\>/
      syn match   luaFunc /\<package\.preload\>/
      syn match   luaFunc /\<package\.seeall\>/
    elseif lua_subversion == 2
      syn keyword luaFunc _ENV rawlen
      syn match   luaFunc /\<package\.config\>/
      syn match   luaFunc /\<package\.preload\>/
      syn match   luaFunc /\<package\.searchers\>/
      syn match   luaFunc /\<package\.searchpath\>/
      syn match   luaFunc /\<bit32\.arshift\>/
      syn match   luaFunc /\<bit32\.band\>/
      syn match   luaFunc /\<bit32\.bnot\>/
      syn match   luaFunc /\<bit32\.bor\>/
      syn match   luaFunc /\<bit32\.btest\>/
      syn match   luaFunc /\<bit32\.bxor\>/
      syn match   luaFunc /\<bit32\.extract\>/
      syn match   luaFunc /\<bit32\.lrotate\>/
      syn match   luaFunc /\<bit32\.lshift\>/
      syn match   luaFunc /\<bit32\.replace\>/
      syn match   luaFunc /\<bit32\.rrotate\>/
      syn match   luaFunc /\<bit32\.rshift\>/
    endif
    syn match luaFunc /\<coroutine\.running\>/
  endif
  syn match   luaFunc /\<coroutine\.create\>/
  syn match   luaFunc /\<coroutine\.resume\>/
  syn match   luaFunc /\<coroutine\.status\>/
  syn match   luaFunc /\<coroutine\.wrap\>/
  syn match   luaFunc /\<coroutine\.yield\>/
  syn match   luaFunc /\<string\.byte\>/
  syn match   luaFunc /\<string\.char\>/
  syn match   luaFunc /\<string\.dump\>/
  syn match   luaFunc /\<string\.find\>/
  syn match   luaFunc /\<string\.format\>/
  syn match   luaFunc /\<string\.gsub\>/
  syn match   luaFunc /\<string\.len\>/
  syn match   luaFunc /\<string\.lower\>/
  syn match   luaFunc /\<string\.rep\>/
  syn match   luaFunc /\<string\.sub\>/
  syn match   luaFunc /\<string\.upper\>/
  if lua_subversion == 0
    syn match luaFunc /\<string\.gfind\>/
  else
    syn match luaFunc /\<string\.gmatch\>/
    syn match luaFunc /\<string\.match\>/
    syn match luaFunc /\<string\.reverse\>/
  endif
  if lua_subversion == 0
    syn match luaFunc /\<table\.getn\>/
    syn match luaFunc /\<table\.setn\>/
    syn match luaFunc /\<table\.foreach\>/
    syn match luaFunc /\<table\.foreachi\>/
  elseif lua_subversion == 1
    syn match luaFunc /\<table\.maxn\>/
  elseif lua_subversion == 2
    syn match luaFunc /\<table\.pack\>/
    syn match luaFunc /\<table\.unpack\>/
  endif
  syn match   luaFunc /\<table\.concat\>/
  syn match   luaFunc /\<table\.sort\>/
  syn match   luaFunc /\<table\.insert\>/
  syn match   luaFunc /\<table\.remove\>/
  syn match   luaFunc /\<math\.abs\>/
  syn match   luaFunc /\<math\.acos\>/
  syn match   luaFunc /\<math\.asin\>/
  syn match   luaFunc /\<math\.atan\>/
  syn match   luaFunc /\<math\.atan2\>/
  syn match   luaFunc /\<math\.ceil\>/
  syn match   luaFunc /\<math\.sin\>/
  syn match   luaFunc /\<math\.cos\>/
  syn match   luaFunc /\<math\.tan\>/
  syn match   luaFunc /\<math\.deg\>/
  syn match   luaFunc /\<math\.exp\>/
  syn match   luaFunc /\<math\.floor\>/
  syn match   luaFunc /\<math\.log\>/
  syn match   luaFunc /\<math\.max\>/
  syn match   luaFunc /\<math\.min\>/
  if lua_subversion == 0
    syn match luaFunc /\<math\.mod\>/
    syn match luaFunc /\<math\.log10\>/
  else
    if lua_subversion == 1
      syn match luaFunc /\<math\.log10\>/
    endif
    syn match luaFunc /\<math\.huge\>/
    syn match luaFunc /\<math\.fmod\>/
    syn match luaFunc /\<math\.modf\>/
    syn match luaFunc /\<math\.cosh\>/
    syn match luaFunc /\<math\.sinh\>/
    syn match luaFunc /\<math\.tanh\>/
  endif
  syn match   luaFunc /\<math\.pow\>/
  syn match   luaFunc /\<math\.rad\>/
  syn match   luaFunc /\<math\.sqrt\>/
  syn match   luaFunc /\<math\.frexp\>/
  syn match   luaFunc /\<math\.ldexp\>/
  syn match   luaFunc /\<math\.random\>/
  syn match   luaFunc /\<math\.randomseed\>/
  syn match   luaFunc /\<math\.pi\>/
  syn match   luaFunc /\<io\.close\>/
  syn match   luaFunc /\<io\.flush\>/
  syn match   luaFunc /\<io\.input\>/
  syn match   luaFunc /\<io\.lines\>/
  syn match   luaFunc /\<io\.open\>/
  syn match   luaFunc /\<io\.output\>/
  syn match   luaFunc /\<io\.popen\>/
  syn match   luaFunc /\<io\.read\>/
  syn match   luaFunc /\<io\.stderr\>/
  syn match   luaFunc /\<io\.stdin\>/
  syn match   luaFunc /\<io\.stdout\>/
  syn match   luaFunc /\<io\.tmpfile\>/
  syn match   luaFunc /\<io\.type\>/
  syn match   luaFunc /\<io\.write\>/
  syn match   luaFunc /\<os\.clock\>/
  syn match   luaFunc /\<os\.date\>/
  syn match   luaFunc /\<os\.difftime\>/
  syn match   luaFunc /\<os\.execute\>/
  syn match   luaFunc /\<os\.exit\>/
  syn match   luaFunc /\<os\.getenv\>/
  syn match   luaFunc /\<os\.remove\>/
  syn match   luaFunc /\<os\.rename\>/
  syn match   luaFunc /\<os\.setlocale\>/
  syn match   luaFunc /\<os\.time\>/
  syn match   luaFunc /\<os\.tmpname\>/
  syn match   luaFunc /\<debug\.debug\>/
  syn match   luaFunc /\<debug\.gethook\>/
  syn match   luaFunc /\<debug\.getinfo\>/
  syn match   luaFunc /\<debug\.getlocal\>/
  syn match   luaFunc /\<debug\.getupvalue\>/
  syn match   luaFunc /\<debug\.setlocal\>/
  syn match   luaFunc /\<debug\.setupvalue\>/
  syn match   luaFunc /\<debug\.sethook\>/
  syn match   luaFunc /\<debug\.traceback\>/
  if lua_subversion == 1
    syn match luaFunc /\<debug\.getfenv\>/
    syn match luaFunc /\<debug\.setfenv\>/
    syn match luaFunc /\<debug\.getmetatable\>/
    syn match luaFunc /\<debug\.setmetatable\>/
    syn match luaFunc /\<debug\.getregistry\>/
  elseif lua_subversion == 2
    syn match luaFunc /\<debug\.getmetatable\>/
    syn match luaFunc /\<debug\.setmetatable\>/
    syn match luaFunc /\<debug\.getregistry\>/
    syn match luaFunc /\<debug\.getuservalue\>/
    syn match luaFunc /\<debug\.setuservalue\>/
    syn match luaFunc /\<debug\.upvalueid\>/
    syn match luaFunc /\<debug\.upvaluejoin\>/
  endif
endif

"=================================== Highlighting ====================================
  " Define the default highlighting.
  " For version 5.7 and earlier: only when not done already
  " For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_lua_syntax_inits")
  if version < 508
    let did_lua_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink luaSingleQuoteString   Character
"------------------------------------------
  HiLink luaString              String
  HiLink luaMultiLineString     String
  HiLink INSTEADTags            String
"------------------------------------------
  HiLink luaFunction            Function
"------------------------------------------
  HiLink luaFuncCall            FunCall
"------------------------------------------
  HiLink luaNumber              Number
"------------------------------------------
  HiLink luaConstant            Constant
"------------------------------------------
  HiLink luaStatement           Statement
  HiLink luaCond                Statement
  HiLink luaElse                Statement
  HiLink luaOperator            Statement
"------------------------------------------
  HiLink luaRepeat              Repeat
  HiLink luaFor                 Repeat
"------------------------------------------
  HiLink luaTable		           Structure
  HiLink luaPunctuation         Structure
"------------------------------------------
  HiLink INSTEADSpecial         SpecialChar
  HiLink luaSpecial             SpecialChar
"------------------------------------------
  HiLink INSTEADStringControl   Operator
"------------------------------------------
  HiLink luaError		           Error
  HiLink luaParenError          Error
  HiLink luaBraceError          Error
"------------------------------------------
  HiLink luaComment             Comment
"------------------------------------------
  HiLink luaFunc                Identifier
  HiLink luaIn                  Identifier
"------------------------------------------
  HiLink luaTODO                Todo

  " Не использованные: 
  " Delimiter, Special (не вижу чем эти двое отличаются; SpecialChar похоже)
  " Type, TypeDef 
  " Exception, Boolean (как Statement выглядит)
  " PreProc, Include
  " Label
  delcommand HiLink
endif

let b:current_syntax = "lua"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: set ts=2 sw=2
