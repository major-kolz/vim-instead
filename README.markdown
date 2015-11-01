[INSTEAD](http://instead.syscall.ru/index.html) plugin for Vim (v.0.1)
==============================
###It is [fork](https://github.com/excelenter/vim-instead)

Make my favorite [text editor](http://www.vim.org/) more suitable for INSTEAD's gamewritting

This plugin will help you with creating INSTEAD text adventures.
It can show you the list of rooms/objects/dialogs for fast navigation 
and run INSTEAD with the current file.


* ##### snippets/lua.snippets
My snippets for [Vim](www.vim.org/). I use [vim-snipmate](https://github.com/garbas/vim-snipmate) plugin for play it. First part of the file contain pure Lua construction, second - INSTEAD-specify snippets. At the end you can see snippets for my useful.lua. Branched from [exelenter's](http://instead.syscall.ru/talk/index.php/member/36-excelenter) snippets ([his post](http://instead.syscall.ru/forum/viewtopic.php?id=407)). **Attention!** You should make link for this file (or copy it) to *snippets* directory of SnipMate plugin (or to *.vim/snippets*).

* ##### pluggin/instead-ide.vim
Some INSTEAD-specific autocreate functions

* ##### syntax/
Advanced Lua highlighting

###Preferences###
All preferences is located at */autoload/instead.vim*

* If you don't like my colorshame - change line 'colorsheme writer'
* If you don't like *folding* - change line 'set foldmethod=syntax'
