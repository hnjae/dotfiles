" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
after/syntax/tex/moreverb.vim	[[[1
15
" moreverb.vim: support for the moreverb package
"   Author : Charles E. Campbell
"   Date   : Aug 20, 2013
"   Version: 1a	ASTRO-ONLY
" NOTE: Place this file in your $HOME/.vim/after/syntax/tex/ directory (make it if it doesn't exist)
let b:loaded_moreverb = "v1a"
if exists("g:tex_verbspell")
  syn region texZone		start="\\begin{verbatimtab}"		end="\\end{verbatimtab}\|%stopzone\>"	contains=@Spell
  syn region texZone		start="\\begin{verbatimwrite}"		end="\\end{verbatimwrite}\|%stopzone\>"	contains=@Spell
  syn region texZone		start="\\begin{boxedverbatim}"		end="\\end{boxedverbatim}\|%stopzone\>"	contains=@Spell
else
  syn region texZone		start="\\begin{verbatimtab}"		end="\\end{verbatimtab}\|%stopzone\>"
  syn region texZone		start="\\begin{verbatimwrite}"		end="\\end{verbatimwrite}\|%stopzone\>"
  syn region texZone		start="\\begin{boxedverbatim}"		end="\\end{boxedverbatim}\|%stopzone\>"
endif
