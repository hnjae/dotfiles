" https://github.com/denisidoro/navi/blob/master/docs/cheatsheet/syntax/README.md

" Based on vim's syntax/sh.vim
"
" The Vim license follows:
"
" VIM LICENSE
"
" I)  There are no restrictions on distributing unmodified copies of Vim except
"     that they must include this license text.  You can also distribute
"     unmodified parts of Vim, likewise unrestricted except that they must
"     include this license text.  You are also allowed to include executables
"     that you made from the unmodified Vim sources, plus your own usage
"     examples and Vim scripts.
"
" II) It is allowed to distribute a modified (or extended) version of Vim,
"     including executables and/or source code, when the following four
"     conditions are met:
"     1) This license text must be included unmodified.
"     2) The modified Vim must be distributed in one of the following five ways:
"        a) If you make changes to Vim yourself, you must clearly describe in
"           the distribution how to contact you.  When the maintainer asks you
"           (in any way) for a copy of the modified Vim you distributed, you
"           must make your changes, including source code, available to the
"           maintainer without fee.  The maintainer reserves the right to
"           include your changes in the official version of Vim.  What the
"           maintainer will do with your changes and under what license they
"           will be distributed is negotiable.  If there has been no negotiation
"           then this license, or a later version, also applies to your changes.
"           The current maintainers are listed here: https://github.com/orgs/vim/people.
"           If this changes it will be announced in appropriate places (most likely
"           vim.sf.net, www.vim.org and/or comp.editors).  When it is completely
"           impossible to contact the maintainer, the obligation to send him
"           your changes ceases.  Once the maintainer has confirmed that he has
"           received your changes they will not have to be sent again.
"        b) If you have received a modified Vim that was distributed as
"           mentioned under a) you are allowed to further distribute it
"           unmodified, as mentioned at I).  If you make additional changes the
"           text under a) applies to those changes.
"        c) Provide all the changes, including source code, with every copy of
"           the modified Vim you distribute.  This may be done in the form of a
"           context diff.  You can choose what license to use for new code you
"           add.  The changes and their license must not restrict others from
"           making their own changes to the official version of Vim.
"        d) When you have a modified Vim which includes changes as mentioned
"           under c), you can distribute it without the source code for the
"           changes if the following three conditions are met:
"           - The license that applies to the changes permits you to distribute
"             the changes to the Vim maintainer without fee or restriction, and
"             permits the Vim maintainer to include the changes in the official
"             version of Vim without fee or restriction.
"           - You keep the changes for at least three years after last
"             distributing the corresponding modified Vim.  When the maintainer
"             or someone who you distributed the modified Vim to asks you (in
"             any way) for the changes within this period, you must make them
"             available to him.
"           - You clearly describe in the distribution how to contact you.  This
"             contact information must remain valid for at least three years
"             after last distributing the corresponding modified Vim, or as long
"             as possible.
"        e) When the GNU General Public License (GPL) applies to the changes,
"           you can distribute the modified Vim under the GNU GPL version 2 or
"           any later version.
"     3) A message must be added, at least in the output of the ":version"
"        command and in the intro screen, such that the user of the modified Vim
"        is able to see that it was modified.  When distributing as mentioned
"        under 2)e) adding the message is only required for as far as this does
"        not conflict with the license used for the changes.
"     4) The contact information as required under 2)a) and 2)d) must not be
"        removed or changed, except that the person himself can make
"        corrections.
"
" III) If you distribute a modified version of Vim, you are encouraged to use
"      the Vim license for your changes and make them available to the
"      maintainer, including the source code.  The preferred way to do this is
"      by e-mail or by uploading the files to a server and e-mailing the URL.
"      If the number of changes is small (e.g., a modified Makefile) e-mailing a
"      context diff will do.  The e-mail address to be used is
"      <maintainer@vim.org>
"
" IV)  It is not allowed to remove this license from the distribution of the Vim
"      sources, parts of it or from a modified version.  You may use this
"      license for previous Vim releases instead of the license that they came
"      with, at your option.

" Vim syntax file
" Language:		shell (sh) Korn shell (ksh) bash (sh)
" Maintainer:		Charles E. Campbell <NcampObell@SdrPchip.AorgM-NOSPAM>
" Previous Maintainer:	Lennart Schultz <Lennart.Schultz@ecmwf.int>
" Last Change:		Feb 11, 2023
" Version:		207
" URL:		http://www.drchip.org/astronaut/vim/index.html#SYNTAX_SH
" For options and settings, please use:      :help ft-sh-syntax
" This file includes many ideas from Eric Brunet (eric.brunet@ens.fr) and heredoc fixes from Felipe Contreras

" quit when a syntax file was already loaded {{{1
if exists("b:current_syntax")
  finish
endif

" from `docs/widgets/howto/VIM.md`
syntax match Comment "\v^;.*$"
syntax match Statement "\v^\%.*$"
syntax match Operator "\v^\#.*$"
syntax match String "\v\<.*\>"
syntax match String "\v^\$.*$"

let b:is_kornshell= 0
let b:is_bash= 0
let b:is_dash= 1
let b:is_posix= 1

" set up default g:sh_fold_enabled {{{1
" ================================
if !exists("g:sh_fold_enabled")
  let g:sh_fold_enabled= 0
elseif g:sh_fold_enabled != 0 && !has("folding")
  let g:sh_fold_enabled= 0
  echomsg "Ignoring g:sh_fold_enabled=".g:sh_fold_enabled."; need to re-compile vim for +fold support"
endif
let s:sh_fold_functions= and(g:sh_fold_enabled,1)
let s:sh_fold_heredoc  = and(g:sh_fold_enabled,2)
let s:sh_fold_ifdofor  = and(g:sh_fold_enabled,4)
if g:sh_fold_enabled && &fdm == "manual"
  " Given that	the	user provided g:sh_fold_enabled
  " 	AND	g:sh_fold_enabled is manual (usual default)
  " 	implies	a desire for syntax-based folding
  setl fdm=syntax
endif

" set up the syntax-highlighting for iskeyword
if (v:version == 704 && has("patch-7.4.1142")) || v:version > 704
  if !exists("g:sh_syntax_isk") || (exists("g:sh_syntax_isk") && g:sh_syntax_isk)
    if exists("b:is_bash")
      exe "syn iskeyword ".&iskeyword.",-,:"
    else
      exe "syn iskeyword ".&iskeyword.",-"
    endif
  endif
endif

" Set up folding commands for shell {{{1
" =================================
sil! delc ShFoldFunctions
sil! delc ShFoldHereDoc
sil! delc ShFoldIfDoFor
if s:sh_fold_functions
  com! -nargs=* ShFoldFunctions <args> fold
else
  com! -nargs=* ShFoldFunctions <args>
endif
if s:sh_fold_heredoc
  com! -nargs=* ShFoldHereDoc <args> fold
else
  com! -nargs=* ShFoldHereDoc <args>
endif
if s:sh_fold_ifdofor
  com! -nargs=* ShFoldIfDoFor <args> fold
else
  com! -nargs=* ShFoldIfDoFor <args>
endif

" sh syntax is case sensitive {{{1
syn case match

" Clusters: contains=@... clusters {{{1
"==================================
syn cluster shErrorList	contains=shDoError,shIfError,shInError,shCaseError,shEsacError,shCurlyError,shParenError,shTestError,shOK
if exists("b:is_kornshell") || exists("b:is_bash")
  syn cluster ErrorList add=shDTestError
endif
syn cluster shArithParenList	contains=shArithmetic,shArithParen,shCaseEsac,shDeref,shDo,shDerefSimple,shEcho,shEscape,shNumber,shOperator,shPosnParm,shExSingleQuote,shExDoubleQuote,shHereString,shRedir,shSingleQuote,shDoubleQuote,shStatement,shVariable,shAlias,shTest,shCtrlSeq,shSpecial,shParen,bashSpecialVariables,bashStatement,shIf,shFor,shFunctionKey,shFunctionOne,shFunctionTwo
syn cluster shArithList	contains=@shArithParenList,shParenError
syn cluster shCaseEsacList	contains=shCaseStart,shCaseLabel,shCase,shCaseBar,shCaseIn,shDeref,shDerefSimple,shCaseCommandSub,shCaseExSingleQuote,shCaseSingleQuote,shCaseDoubleQuote,shCtrlSeq,@shErrorList,shStringSpecial,shCaseRange
syn cluster shCaseList	contains=@shCommandSubList,shCaseEsac,shColon,shCommandSub,shCommandSubBQ,shDblBrace,shDo,shEcho,shExpr,shFor,shHereDoc,shIf,shHereString,shRedir,shSetList,shSource,shStatement,shVariable,shCtrlSeq
if exists("b:is_kornshell") || exists("b:is_bash")
  syn cluster shCaseList	add=shForPP
endif
syn cluster shCommandSubList	contains=shAlias,shArithmetic,shCmdParenRegion,shCommandSub,shCtrlSeq,shDeref,shDerefSimple,shDoubleQuote,shEcho,shEscape,shExDoubleQuote,shExpr,shExSingleQuote,shHereDoc,shNumber,shOperator,shOption,shPosnParm,shHereString,shRedir,shSingleQuote,shSpecial,shStatement,shSubSh,shTest,shVariable
syn cluster shCurlyList	contains=shNumber,shComma,shDeref,shDerefSimple,shDerefSpecial
" COMBAK: removing shEscape from shDblQuoteList fails ksh04:43 -- Jun 09, 2022: I don't see the problem with ksh04, so am reinstating shEscape
syn cluster shDblQuoteList	contains=shArithmetic,shCommandSub,shCommandSubBQ,shDeref,shDerefSimple,shEscape,shPosnParm,shCtrlSeq,shSpecial,shSpecialDQ
syn cluster shDerefList	contains=shDeref,shDerefSimple,shDerefVar,shDerefSpecial,shDerefWordError,shDerefPSR,shDerefPPS
syn cluster shDerefVarList	contains=shDerefOffset,shDerefOp,shDerefVarArray,shDerefOpError
syn cluster shEchoList	contains=shArithmetic,shCommandSub,shCommandSubBQ,shDeref,shDerefSimple,shEscape,shExSingleQuote,shExDoubleQuote,shSingleQuote,shDoubleQuote,shCtrlSeq,shEchoQuote
syn cluster shExprList1	contains=shCharClass,shNumber,shOperator,shExSingleQuote,shExDoubleQuote,shSingleQuote,shDoubleQuote,shExpr,shDblBrace,shDeref,shDerefSimple,shCtrlSeq
syn cluster shExprList2	contains=@shExprList1,@shCaseList,shTest
syn cluster shFunctionList	contains=@shCommandSubList,shCaseEsac,shColon,shDo,shEcho,shExpr,shFor,shHereDoc,shIf,shOption,shHereString,shRedir,shSetList,shSource,shStatement,shVariable,shOperator,shCtrlSeq
if exists("b:is_kornshell") || exists("b:is_bash")
  syn cluster shFunctionList	add=shRepeat,shDblBrace,shDblParen,shForPP
  syn cluster shDerefList	add=shCommandSubList,shEchoDeref
endif
syn cluster shHereBeginList	contains=@shCommandSubList
syn cluster shHereList	contains=shBeginHere,shHerePayload
syn cluster shHereListDQ	contains=shBeginHere,@shDblQuoteList,shHerePayload
syn cluster shIdList	contains=shArithmetic,shCommandSub,shCommandSubBQ,shWrapLineOperator,shSetOption,shDeref,shDerefSimple,shHereString,shNumber,shOperator,shRedir,shExSingleQuote,shExDoubleQuote,shSingleQuote,shDoubleQuote,shExpr,shCtrlSeq,shStringSpecial,shAtExpr
syn cluster shIfList	contains=@shLoopList,shDblBrace,shDblParen,shFunctionKey,shFunctionOne,shFunctionTwo
syn cluster shLoopList	contains=@shCaseList,@shErrorList,shCaseEsac,shConditional,shDblBrace,shExpr,shFor,shIf,shOption,shSet,shTest,shTestOpr,shTouch
if exists("b:is_kornshell") || exists("b:is_bash")
  syn cluster shLoopoList	add=shForPP
endif
syn cluster shPPSLeftList	contains=shAlias,shArithmetic,shCmdParenRegion,shCommandSub,shCtrlSeq,shDeref,shDerefSimple,shDoubleQuote,shEcho,shEscape,shExDoubleQuote,shExpr,shExSingleQuote,shHereDoc,shNumber,shOperator,shOption,shPosnParm,shHereString,shRedir,shSingleQuote,shSpecial,shStatement,shSubSh,shTest,shVariable
syn cluster shPPSRightList	contains=shDeref,shDerefSimple,shEscape,shPosnParm
syn cluster shSubShList	contains=@shCommandSubList,shCommandSubBQ,shCaseEsac,shColon,shCommandSub,shDo,shEcho,shExpr,shFor,shIf,shHereString,shRedir,shSetList,shSource,shStatement,shVariable,shCtrlSeq,shOperator
syn cluster shTestList	contains=shArithmetic,shCharClass,shCommandSub,shCommandSubBQ,shCtrlSeq,shDeref,shDerefSimple,shDoubleQuote,shSpecialDQ,shExDoubleQuote,shExpr,shExSingleQuote,shNumber,shOperator,shSingleQuote,shTest,shTestOpr
syn cluster shNoZSList	contains=shSpecialNoZS
syn cluster shForList	contains=shTestOpr,shNumber,shDerefSimple,shDeref,shCommandSub,shCommandSubBQ,shArithmetic

" Echo: {{{1
" ====
" This one is needed INSIDE a CommandSub, so that `echo bla` be correct
syn region shEcho matchgroup=shStatement start="\<echo\>"  skip="\\$" matchgroup=shEchoDelim end="$" matchgroup=NONE end="[<>;&|()`]"me=e-1 end="\d[<>]"me=e-2 end="#"me=e-1 contains=@shEchoList skipwhite nextgroup=shQuickComment
syn region shEcho matchgroup=shStatement start="\<print\>" skip="\\$" matchgroup=shEchoDelim end="$" matchgroup=NONE end="[<>;&|()`]"me=e-1 end="\d[<>]"me=e-2 end="#"me=e-1 contains=@shEchoList skipwhite nextgroup=shQuickComment
if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_posix")
  syn region shEchoDeref contained matchgroup=shStatement start="\<echo\>"  skip="\\$" matchgroup=shEchoDelim end="$" end="[<>;&|()`}]"me=e-1 end="\d[<>]"me=e-2 end="#"me=e-1 contains=@shEchoList skipwhite nextgroup=shQuickComment
  syn region shEchoDeref contained matchgroup=shStatement start="\<print\>" skip="\\$" matchgroup=shEchoDelim end="$" end="[<>;&|()`}]"me=e-1 end="\d[<>]"me=e-2 end="#"me=e-1 contains=@shEchoList skipwhite nextgroup=shQuickComment
endif
syn match  shEchoQuote contained	'\%(\\\\\)*\\["`'()]'

" This must be after the strings, so that ... \" will be correct
syn region shEmbeddedEcho contained matchgroup=shStatement start="\<print\>" skip="\\$" matchgroup=shEchoDelim end="$" matchgroup=NONE end="[<>;&|`)]"me=e-1 end="\d[<>]"me=e-2 end="\s#"me=e-2 contains=shNumber,shExSingleQuote,shSingleQuote,shDeref,shDerefSimple,shSpecialVar,shOperator,shExDoubleQuote,shDoubleQuote,shCharClass,shCtrlSeq

" Alias: {{{1
" =====
if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_posix")
  syn match shStatement "\<alias\>"
  syn region shAlias matchgroup=shStatement start="\<alias\>\s\+\(\h[-._[:alnum:]]*\)\@="  skip="\\$" end="\>\|`"
  syn region shAlias matchgroup=shStatement start="\<alias\>\s\+\(\h[-._[:alnum:]]*=\)\@=" skip="\\$" end="="
  " syn region shAlias matchgroup=shStatement start="\<alias\>\s\+\(\h[-._[:alnum:]]\+\)\@="  skip="\\$" end="\>\|`"
  " syn region shAlias matchgroup=shStatement start="\<alias\>\s\+\(\h[-._[:alnum:]]\+=\)\@=" skip="\\$" end="="

  " Touch: {{{1
  " =====
  syn match shTouch	'\<touch\>[^;#]*'	skipwhite nextgroup=shComment contains=shTouchCmd,shDoubleQuote,shSingleQuote,shDeref,shDerefSimple
  syn match shTouchCmd	'\<touch\>'		contained
endif

" Error Codes: {{{1
" ============
if !exists("g:sh_no_error")
  syn match   shDoError "\<done\>"
  syn match   shIfError "\<fi\>"
  syn match   shInError "\<in\>"
  syn match   shCaseError ";;"
  syn match   shEsacError "\<esac\>"
  syn match   shCurlyError "}"
  syn match   shParenError ")"
  syn match   shOK	'\.\(done\|fi\|in\|esac\)'
  if exists("b:is_kornshell") || exists("b:is_bash")
    syn match     shDTestError "]]"
  endif
  syn match     shTestError "]"
endif

" Options: {{{1
" ====================
syn match   shOption	"\s\zs[-+][-_a-zA-Z#@]\+"
syn match   shOption	"\s\zs--[^ \t$=`'"|);]\+"

" File Redirection Highlighted As Operators: {{{1
"===========================================
syn match      shRedir	"\d\=>\(&[-0-9]\)\="
syn match      shRedir	"\d\=>>-\="
syn match      shRedir	"\d\=<\(&[-0-9]\)\="
syn match      shRedir	"\d<<-\="

" Operators: {{{1
" ==========
syn match   shOperator	"<<\|>>"		contained
syn match   shOperator	"[!&;|]"		contained
syn match   shOperator	"\[[[^:]\|\]]"		contained
syn match   shOperator	"[-=/*+%]\=="		skipwhite nextgroup=shPattern
syn match   shPattern	"\<\S\+\())\)\@="	contained contains=shExSingleQuote,shSingleQuote,shExDoubleQuote,shDoubleQuote,shDeref

" Subshells: {{{1
" ==========
syn region shExpr  transparent matchgroup=shExprRegion  start="{" end="}"		contains=@shExprList2 nextgroup=shSpecialNxt
syn region shSubSh transparent matchgroup=shSubShRegion start="[^(]\zs(" end=")"	contains=@shSubShList nextgroup=shSpecialNxt

" Tests: {{{1
"=======
syn region shExpr	matchgroup=shRange start="\[" skip=+\\\\\|\\$\|\[+ end="\]" contains=@shTestList,shSpecial
syn region shTest	transparent matchgroup=shStatement start="\<test\s" skip=+\\\\\|\\$+ matchgroup=NONE end="[;&|]"me=e-1 end="$" contains=@shExprList1
syn region shNoQuote	start='\S'	skip='\%(\\\\\)*\\.'	end='\ze\s' end="\ze['"]"	contained contains=shDerefSimple,shDeref
syn match  shAstQuote	contained	'\*\ze"'	nextgroup=shString
syn match  shTestOpr	contained	'[^-+/%]\zs=' skipwhite nextgroup=shTestDoubleQuote,shTestSingleQuote,shTestPattern
syn match  shTestOpr	contained	"<=\|>=\|!=\|==\|=\~\|-.\>\|-\(nt\|ot\|ef\|eq\|ne\|lt\|le\|gt\|ge\)\>\|[!<>]"
syn match  shTestPattern	contained	'\w\+'
syn region shTestDoubleQuote	contained	start='\%(\%(\\\\\)*\\\)\@<!"' skip=+\\\\\|\\"+ end='"'	contains=shDeref,shDerefSimple,shDerefSpecial
syn match  shTestSingleQuote	contained	'\\.'	nextgroup=shTestSingleQuote
syn match  shTestSingleQuote	contained	"'[^']*'"

" Character Class In Range: {{{1
" =========================
syn match   shCharClass	contained	"\[:\(backspace\|escape\|return\|xdigit\|alnum\|alpha\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|tab\):\]"

" Loops: do, if, while, until {{{1
" ======
ShFoldIfDoFor syn region shDo	transparent	matchgroup=shConditional start="\<do\>" matchgroup=shConditional end="\<done\>"			contains=@shLoopList
ShFoldIfDoFor syn region shIf	transparent	matchgroup=shConditional start="\<if\_s" matchgroup=shConditional skip=+-fi\>+ end="\<;\_s*then\>" end="\<fi\>"	contains=@shIfList
ShFoldIfDoFor syn region shFor		matchgroup=shLoop start="\<for\ze\_s\s*\%(((\)\@!" end="\<in\>" end="\<do\>"me=e-2			contains=@shLoopList,shDblParen skipwhite nextgroup=shCurlyIn
if exists("b:is_kornshell") || exists("b:is_bash")
  ShFoldIfDoFor syn region shForPP	matchgroup=shLoop start='\<for\>\_s*((' end='))' contains=@shForList
endif

if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_posix")
  syn cluster shCaseList	add=shRepeat
  syn cluster shFunctionList	add=shRepeat
  syn region shRepeat   matchgroup=shLoop   start="\<while\_s" end="\<do\>"me=e-2	contains=@shLoopList,shDblParen,shDblBrace
  syn region shRepeat   matchgroup=shLoop   start="\<until\_s" end="\<do\>"me=e-2	contains=@shLoopList,shDblParen,shDblBrace
  if !exists("b:is_posix")
    syn region shCaseEsac matchgroup=shConditional start="\<select\s" matchgroup=shConditional end="\<in\>" end="\<do\>" contains=@shLoopList
  endif
else
  syn region shRepeat   matchgroup=shLoop   start="\<while\_s" end="\<do\>"me=e-2		contains=@shLoopList
  syn region shRepeat   matchgroup=shLoop   start="\<until\_s" end="\<do\>"me=e-2		contains=@shLoopList
endif
syn region shCurlyIn   contained	matchgroup=Delimiter start="{" end="}" contains=@shCurlyList
syn match  shComma     contained	","

" Case: case...esac {{{1
" ====
syn match shCaseBar	contained skipwhite "\(^\|[^\\]\)\(\\\\\)*\zs|"		nextgroup=shCase,shCaseStart,shCaseBar,shCaseExSingleQuote,shCaseSingleQuote,shCaseDoubleQuote
syn match shCaseStart	contained skipwhite skipnl "("			nextgroup=shCase,shCaseBar
syn match shCaseLabel	contained skipwhite	"\%(\\.\|[-a-zA-Z0-9_*.]\)\+"	contains=shCharClass
ShFoldIfDoFor syn region	shCase	contained skipwhite skipnl matchgroup=shSnglCase start="\%(\\.\|[^#$()'" \t]\)\{-}\zs)"  end=";;" end="esac"me=s-1		contains=@shCaseList	nextgroup=shCaseStart,shCase
ShFoldIfDoFor syn region	shCaseEsac	matchgroup=shConditional start="\<case\>" end="\<esac\>"	contains=@shCaseEsacList

syn keyword shCaseIn	contained skipwhite skipnl in			nextgroup=shCase,shCaseStart,shCaseBar,shCaseExSingleQuote,shCaseSingleQuote,shCaseDoubleQuote
if !exists("g:sh_no_error")
  syn region  shCaseExSingleQuote	matchgroup=Error start=+\$'+ skip=+\\\\\|\\.+ end=+'+	contains=shStringSpecial	skipwhite skipnl nextgroup=shCaseBar	contained
endif
syn region  shCaseSingleQuote	matchgroup=shQuote start=+'+ end=+'+		contains=shStringSpecial		skipwhite skipnl nextgroup=shCaseBar	contained
syn region  shCaseDoubleQuote	matchgroup=shQuote start=+"+ skip=+\\\\\|\\.+ end=+"+	contains=@shDblQuoteList,shStringSpecial	skipwhite skipnl nextgroup=shCaseBar	contained
syn region  shCaseCommandSub	start=+`+ skip=+\\\\\|\\.+ end=+`+		contains=@shCommandSubList		skipwhite skipnl nextgroup=shCaseBar	contained
" Misc: {{{1
"======
syn match   shWrapLineOperator "\\$"
syn region  shCommandSubBQ   	start="`" skip="\\\\\|\\." end="`"	contains=shBQComment,@shCommandSubList
"COMBAK: see ksh13:50
"syn match   shEscape	contained	'\%(^\)\@!\%(\\\\\)*\\.'	nextgroup=shSingleQuote,shDoubleQuote
"COMBAK: see sh11:27
syn match   shEscape	contained	'\%(^\)\@!\%(\\\\\)*\\.'	nextgroup=shComment
"COMBAK: see ksh13:53
"syn match   shEscape	contained	'\%(^\)\@!\%(\\\\\)*\\.'

" $() and $(()): {{{1
" $(..) is not supported by sh (Bourne shell).  However, apparently
" some systems (HP?) have as their /bin/sh a (link to) Korn shell
" (ie. Posix compliant shell).  /bin/ksh should work for those
" systems too, however, so the following syntax will flag $(..) as
" an Error under /bin/sh.  By consensus of vimdev'ers!
if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_posix")
  syn region shCommandSub matchgroup=shCmdSubRegion start="\$(\ze[^(]"  skip='\\\\\|\\.' end=")"  contains=@shCommandSubList
  syn region shArithmetic matchgroup=shArithRegion  start="\$((" skip='\\\\\|\\.' end="))" contains=@shArithList
  syn region shArithmetic matchgroup=shArithRegion  start="\$\[" skip='\\\\\|\\.' end="\]" contains=@shArithList
  syn match  shSkipInitWS contained	"^\s\+"
  syn region shArithParen matchgroup=shArithRegion  contained start="(" end=")" contains=@shArithParenList
elseif !exists("g:sh_no_error")
  syn region shCommandSub matchgroup=Error start="\$(" end=")" contains=@shCommandSubList
endif
syn region shCmdParenRegion matchgroup=shCmdSubRegion start="(\ze[^(]" skip='\\\\\|\\.' end=")" contains=@shCommandSubList

if exists("b:is_kornshell") || exists("b:is_posix")
  syn cluster shCommandSubList add=kshSpecialVariables,kshStatement
  syn cluster shCaseList add=kshStatement
  syn keyword kshSpecialVariables contained CDPATH COLUMNS EDITOR ENV ERRNO FCEDIT FPATH HISTFILE HISTSIZE HOME IFS LINENO LINES MAIL MAILCHECK MAILPATH OLDPWD OPTARG OPTIND PATH PPID PS1 PS2 PS3 PS4 PWD RANDOM REPLY SECONDS SHELL TMOUT VISUAL
  syn keyword kshStatement cat chmod clear cp du egrep expr fgrep find grep head killall less ls mkdir mv nice printenv rm rmdir sed sort strip stty tail tput
  syn keyword kshStatement command setgroups setsenv
endif

syn match   shSource	"^\.\s"
syn match   shSource	"\s\.\s"
"syn region  shColon	start="^\s*:" end="$" end="\s#"me=e-2 contains=@shColonList
"syn region  shColon	start="^\s*\zs:" end="$" end="\s#"me=e-2
if exists("b:is_kornshell") || exists("b:is_posix")
  syn match   shColon	'^\s*\zs:'
endif

" String And Character Constants: {{{1
"================================
syn match   shNumber	"\<\d\+\>#\="
syn match   shNumber	"\<-\=\.\=\d\+\>#\="
syn match   shCtrlSeq	"\\\d\d\d\|\\[abcfnrtv0]"			contained
syn region  shSingleQuote	matchgroup=shQuote start=+'+ end=+'+		contains=@Spell	nextgroup=shSpecialStart,shSpecialSQ
syn region  shDoubleQuote	matchgroup=shQuote start=+\%(\%(\\\\\)*\\\)\@<!"+ skip=+\\.+ end=+"+			contains=@shDblQuoteList,shStringSpecial,@Spell	nextgroup=shSpecialStart
syn match   shStringSpecial	"[^[:print:] \t]"			contained
syn match   shStringSpecial	"[^\\]\zs\%(\\\\\)*\(\\[\\"'`$()#]\)\+"			nextgroup=shComment
syn match   shSpecialSQ	"[^\\]\zs\%(\\\\\)*\(\\[\\"'`$()#]\)\+"		contained	nextgroup=shBkslshSnglQuote,@shNoZSList
syn match   shSpecialDQ	"[^\\]\zs\%(\\\\\)*\(\\[\\"'`$()#]\)\+"		contained	nextgroup=shBkslshDblQuote,@shNoZSList
syn match   shSpecialStart	"\%(\\\\\)*\\[\\"'`$()#]"			contained	nextgroup=shBkslshSnglQuote,shBkslshDblQuote,@shNoZSList
syn match   shSpecial	"^\%(\\\\\)*\\[\\"'`$()#]"
syn match   shSpecialNoZS	contained	"\%(\\\\\)*\\[\\"'`$()#]"
syn match   shSpecialNxt	contained	"\\[\\"'`$()#]"
"syn region  shBkslshSnglQuote	contained	matchgroup=shQuote start=+'+ end=+'+	contains=@Spell	nextgroup=shSpecialStart
"syn region  shBkslshDblQuote	contained	matchgroup=shQuote start=+"+ skip=+\\"+ end=+"+	contains=@shDblQuoteList,shStringSpecial,@Spell	nextgroup=shSpecialStart

" Comments: {{{1
"==========
syn cluster	shCommentGroup	contains=shTodo,@Spell
syn keyword	shTodo	contained		COMBAK FIXME TODO XXX

" Here Documents: {{{1
"  (modified by Felipe Contreras)
" =========================================
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc01 start="<<\s*\z([^ \t|>]\+\)"		matchgroup=shHereDoc01 end="^\z1$"	contains=@shDblQuoteList
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc02 start="<<-\s*\z([^ \t|>]\+\)"		matchgroup=shHereDoc02 end="^\s*\z1$"	contains=@shDblQuoteList
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc03 start="<<\s*\\\z([^ \t|>]\+\)"		matchgroup=shHereDoc03 end="^\z1$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc04 start="<<-\s*\\\z([^ \t|>]\+\)"		matchgroup=shHereDoc04 end="^\s*\z1$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc05 start="<<\s*'\z([^']\+\)'"		matchgroup=shHereDoc05 end="^\z1$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc06 start="<<-\s*'\z([^']\+\)'"		matchgroup=shHereDoc06 end="^\s*\z1$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc07 start="<<\s*\"\z([^"]\+\)\""		matchgroup=shHereDoc07 end="^\z1$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc08 start="<<-\s*\"\z([^"]\+\)\""		matchgroup=shHereDoc08 end="^\s*\z1$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc09 start="<<\s*\\\_$\_s*\z([^ \t|>]\+\)"		matchgroup=shHereDoc09 end="^\z1$"	contains=@shDblQuoteList
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc10 start="<<-\s*\\\_$\_s*\z([^ \t|>]\+\)"	matchgroup=shHereDoc10 end="^\s*\z1$"	contains=@shDblQuoteList
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc11 start="<<\s*\\\_$\_s*\\\z([^ \t|>]\+\)"	matchgroup=shHereDoc11 end="^\z1$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc12 start="<<-\s*\\\_$\_s*\\\z([^ \t|>]\+\)"	matchgroup=shHereDoc12 end="^\s*\z1$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc13 start="<<\s*\\\_$\_s*'\z([^']\+\)'"		matchgroup=shHereDoc13 end="^\z1$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc14 start="<<-\s*\\\_$\_s*'\z([^']\+\)'"		matchgroup=shHereDoc14 end="^\s*\z1$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc15 start="<<\s*\\\_$\_s*\"\z([^"]\+\)\""		matchgroup=shHereDoc15 end="^\z1$"
ShFoldHereDoc syn region shHereDoc matchgroup=shHereDoc16 start="<<-\s*\\\_$\_s*\"\z([^"]\+\)\""	matchgroup=shHereDoc16 end="^\s*\z1$"

" Identifiers: {{{1
"=============
syn match  shSetOption	"\s\zs[-+][a-zA-Z0-9]\+\>"	contained
syn match  shVariable	"\<\h\w*\ze="			nextgroup=shVarAssign
syn match  shVarAssign	"="		contained	nextgroup=shCmdParenRegion,shPattern,shDeref,shDerefSimple,shDoubleQuote,shExDoubleQuote,shSingleQuote,shExSingleQuote,shVar
syn match  shVar	contained	"\h\w*"
syn region shAtExpr	contained	start="@(" end=")" contains=@shIdList
if exists("b:is_kornshell") || exists("b:is_posix")
  syn match  shSet "^\s*set\ze\s\+$"
  if exists("b:is_dash")
    syn region shSetList oneline matchgroup=shSet start="\<\%(local\)\>\ze[/]\@!" end="$"			matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+[#=]"	contains=@shIdList
  endif
  syn region shSetList oneline matchgroup=shSet start="\<\(export\)\>\ze[/]\@!" end="$"			matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+[#=]"	contains=@shIdList
  syn region shSetList oneline matchgroup=shSet start="\<\%(set\|unset\>\)\ze[/a-zA-Z_]\@!" end="\ze[;|#)]\|$"		matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+[#=]"	contains=@shIdList nextgroup=shComment
else
  syn region shSetList oneline matchgroup=shSet start="\<\(set\|export\|unset\)\>\ze[/a-zA-Z_]\@!" end="\ze[;|#)]\|$"	matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+[#=]"	contains=@shIdList
endif

" Parameter Dereferencing: {{{1
" ========================
" Note: sh04 failure with following line
"if !exists("g:sh_no_error") && !(exists("b:is_bash") || exists("b:is_kornshell") || exists("b:is_posix"))
if !exists("g:sh_no_error")
  syn match  shDerefWordError	"[^}$[~]"	contained
endif
syn match  shDerefSimple	"\$\%(\h\w*\|\d\)"	nextgroup=@shNoZSList
syn region shDeref	matchgroup=PreProc start="\${" end="}"	contains=@shDerefList,shDerefVarArray nextgroup=shSpecialStart
syn match  shDerefSimple	"\$[-#*@!?]"	nextgroup=@shNoZSList
syn match  shDerefSimple	"\$\$"	nextgroup=@shNoZSList
syn match  shDerefSimple	"\${\d}"	nextgroup=@shNoZSList	nextgroup=shSpecialStart
if exists("b:is_bash") || exists("b:is_kornshell") || exists("b:is_posix")
  syn region shDeref	matchgroup=PreProc start="\${##\=" end="}"	contains=@shDerefList	nextgroup=@shSpecialNoZS,shSpecialStart
  syn region shDeref	matchgroup=PreProc start="\${\$\$" end="}"	contains=@shDerefList	nextgroup=@shSpecialNoZS,shSpecialStart
endif

" bash: ${!prefix*} and ${#parameter}: {{{1
" ====================================
syn match  shDerefSpecial	contained	"{\@<=[-*@?0]"		nextgroup=shDerefOp,shDerefOffset,shDerefOpError
syn match  shDerefSpecial	contained	"\({[#!]\)\@<=[[:alnum:]*@_]\+"	nextgroup=@shDerefVarList,shDerefOp
syn match  shDerefVar	contained	"{\@<=\h\w*"		nextgroup=@shDerefVarList
syn match  shDerefVar	contained	'\d'                            nextgroup=@shDerefVarList
if exists("b:is_kornshell") || exists("b:is_posix")
  syn match  shDerefVar	contained	"{\@<=\h\w*[[:alnum:]_.]*"	nextgroup=@shDerefVarList
endif

" sh ksh bash : ${var[... ]...}  array reference: {{{1
syn region  shDerefVarArray   contained	matchgroup=shDeref start="\[" end="]"	contains=@shCommandSubList nextgroup=shDerefOp,shDerefOpError

" Special ${parameter OPERATOR word} handling: {{{1
" sh ksh bash : ${parameter:-word}    word is default value
" sh ksh bash : ${parameter:=word}    assign word as default value
" sh ksh bash : ${parameter:?word}    display word if parameter is null
" sh ksh bash : ${parameter:+word}    use word if parameter is not null, otherwise nothing
"    ksh bash : ${parameter#pattern}  remove small left  pattern
"    ksh bash : ${parameter##pattern} remove large left  pattern
"    ksh bash : ${parameter%pattern}  remove small right pattern
"    ksh bash : ${parameter%%pattern} remove large right pattern
"        bash : ${parameter^pattern}  Case modification
"        bash : ${parameter^^pattern} Case modification
"        bash : ${parameter,pattern}  Case modification
"        bash : ${parameter,,pattern} Case modification
"        bash : ${@:start:qty}        display command line arguments from start to start+qty-1 (inferred)
"        bash : ${parameter@operator} transforms parameter (operator∈[uULqEPARa])
syn cluster shDerefPatternList	contains=shDerefPattern,shDerefString
if !exists("g:sh_no_error")
  syn match shDerefOpError	contained	":[[:punct:]]"
endif
syn match  shDerefOp	contained	":\=[-=?]"	nextgroup=@shDerefPatternList
syn match  shDerefOp	contained	":\=+"	nextgroup=@shDerefPatternList
if exists("b:is_bash") || exists("b:is_kornshell") || exists("b:is_posix")
  syn match  shDerefOp	contained	"#\{1,2}"		nextgroup=@shDerefPatternList
  syn match  shDerefOp	contained	"%\{1,2}"		nextgroup=@shDerefPatternList
  syn match  shDerefPattern	contained	"[^{}]\+"		contains=shDeref,shDerefSimple,shDerefPattern,shDerefString,shCommandSub,shDerefEscape nextgroup=shDerefPattern
  syn region shDerefPattern	contained	start="{" end="}"	contains=shDeref,shDerefSimple,shDerefString,shCommandSub nextgroup=shDerefPattern
  syn match  shDerefEscape	contained	'\%(\\\\\)*\\.'
endif
syn region shDerefString	contained	matchgroup=shDerefDelim start=+\%(\\\)\@<!'+ end=+'+	contains=shStringSpecial
syn region shDerefString	contained	matchgroup=shDerefDelim start=+\%(\\\)\@<!"+ skip=+\\"+ end=+"+	contains=@shDblQuoteList,shStringSpecial
syn match  shDerefString	contained	"\\["']"	nextgroup=shDerefPattern

if exists("b:is_bash") || exists("b:is_kornshell") || exists("b:is_posix")
  " bash ksh posix : ${parameter:offset}
  " bash ksh posix : ${parameter:offset:length}
  syn region shDerefOffset	contained	start=':[^-=?+]' end='\ze:'	end='\ze}'	contains=shDeref,shDerefSimple,shDerefEscape	nextgroup=shDerefLen,shDeref,shDerefSimple
  syn region shDerefOffset	contained	start=':\s-'	end='\ze:'	end='\ze}'	contains=shDeref,shDerefSimple,shDerefEscape	nextgroup=shDerefLen,shDeref,shDerefSimple
  syn match  shDerefLen	contained	":[^}]\+"	contains=shDeref,shDerefSimple,shArithmetic
endif

" Arithmetic Parenthesized Expressions: {{{1
"syn region shParen matchgroup=shArithRegion start='[^$]\zs(\%(\ze[^(]\|$\)' end=')' contains=@shArithParenList
syn region shParen matchgroup=shArithRegion start='\$\@!(\%(\ze[^(]\|$\)' end=')' contains=@shArithParenList

" Additional sh Keywords: {{{1
" ===================
syn keyword shStatement break cd chdir continue eval exec exit kill newgrp pwd read readonly return shift test trap ulimit umask wait
syn keyword shConditional contained elif else then
if !exists("g:sh_no_error")
  syn keyword shCondError elif else then
endif

" Additional ksh Keywords and Aliases: {{{1
" ===================================
if exists("b:is_kornshell") || exists("b:is_posix")
  syn keyword shStatement bg builtin disown enum export false fg getconf getopts hist jobs let printf sleep true unalias whence
  syn keyword shStatement typeset skipwhite nextgroup=shSetOption
  syn keyword shStatement autoload compound fc float functions hash history integer nameref nohup r redirect source stop suspend times type
  if exists("b:is_posix")
    syn keyword shStatement command
  else
    syn keyword shStatement time
  endif

  " Additional bash Keywords: {{{1
  " =====================
else
  syn keyword shStatement login newgrp
endif

" Synchronization: {{{1
" ================
if !exists("g:sh_minlines")
  let s:sh_minlines = 200
else
  let s:sh_minlines= g:sh_minlines
endif
if !exists("g:sh_maxlines")
  let s:sh_maxlines = 2*s:sh_minlines
  if s:sh_maxlines < 25
    let s:sh_maxlines= 25
  endif
else
  let s:sh_maxlines= g:sh_maxlines
endif
exec "syn sync minlines=" . s:sh_minlines . " maxlines=" . s:sh_maxlines
syn sync match shCaseEsacSync	grouphere	shCaseEsac	"\<case\>"
syn sync match shCaseEsacSync	groupthere	shCaseEsac	"\<esac\>"
syn sync match shDoSync	grouphere	shDo	"\<do\>"
syn sync match shDoSync	groupthere	shDo	"\<done\>"
syn sync match shForSync	grouphere	shFor	"\<for\>"
syn sync match shForSync	groupthere	shFor	"\<in\>"
syn sync match shIfSync	grouphere	shIf	"\<if\>"
syn sync match shIfSync	groupthere	shIf	"\<fi\>"
syn sync match shUntilSync	grouphere	shRepeat	"\<until\>"
syn sync match shWhileSync	grouphere	shRepeat	"\<while\>"

" Default Highlighting: {{{1
" =====================
if !exists("skip_sh_syntax_inits")
  hi def link shArithRegion	shShellVariables
  hi def link shAstQuote	shDoubleQuote
  hi def link shAtExpr	shSetList
  hi def link shBkslshSnglQuote	shSingleQuote
  hi def link shBkslshDblQuote	shDOubleQuote
  hi def link shBeginHere	shRedir
  hi def link shCaseBar	shConditional
  hi def link shCaseCommandSub	shCommandSub
  hi def link shCaseDoubleQuote	shDoubleQuote
  hi def link shCaseIn	shConditional
  hi def link shQuote	shOperator
  hi def link shCaseSingleQuote	shSingleQuote
  hi def link shCaseStart	shConditional
  hi def link shCmdSubRegion	shShellVariables
  hi def link shColon	Comment
  hi def link shDerefOp	shOperator
  hi def link shDerefPOL	shDerefOp
  hi def link shDerefPPS	shDerefOp
  hi def link shDerefPSR	shDerefOp
  hi def link shDeref	shShellVariables
  hi def link shDerefDelim	shOperator
  hi def link shDerefSimple	shDeref
  hi def link shDerefSpecial	shDeref
  hi def link shDerefString	shDoubleQuote
  hi def link shDerefVar	shDeref
  hi def link shDoubleQuote	shString
  hi def link shEcho	shString
  hi def link shEchoDelim	shOperator
  hi def link shEchoQuote	shString
  hi def link shForPP	shLoop
  hi def link shFunction	Function
  hi def link shEmbeddedEcho	shString
  hi def link shEscape	shCommandSub
  hi def link shExDoubleQuote	shDoubleQuote
  hi def link shExSingleQuote	shSingleQuote
  hi def link shHereDoc	shString
  hi def link shHereString	shRedir
  hi def link shHerePayload	shHereDoc
  hi def link shLoop	shStatement
  hi def link shSpecialNxt	shSpecial
  hi def link shNoQuote	shDoubleQuote
  hi def link shOption	shCommandSub
  hi def link shPattern	shString
  hi def link shParen	shArithmetic
  hi def link shPosnParm	shShellVariables
  hi def link shQuickComment	Comment
  hi def link shBQComment	Comment
  hi def link shRange	shOperator
  hi def link shRedir	shOperator
  hi def link shSetListDelim	shOperator
  hi def link shSetOption	shOption
  hi def link shSingleQuote	shString
  hi def link shSource	shOperator
  hi def link shStringSpecial	shSpecial
  hi def link shSpecialStart	shSpecial
  hi def link shSubShRegion	shOperator
  hi def link shTestOpr	shConditional
  hi def link shTestPattern	shString
  hi def link shTestDoubleQuote	shString
  hi def link shTestSingleQuote	shString
  hi def link shTouchCmd	shStatement
  hi def link shVariable	shSetList
  hi def link shWrapLineOperator	shOperator

  if exists("b:is_kornshell") || exists("b:is_posix")
    hi def link kshSpecialVariables	shShellVariables
    hi def link kshStatement		shStatement
  endif

  if !exists("g:sh_no_error")
    hi def link shCaseError		Error
    hi def link shCondError		Error
    hi def link shCurlyError		Error
    hi def link shDerefOpError		Error
    hi def link shDerefWordError		Error
    hi def link shDoError		Error
    hi def link shEsacError		Error
    hi def link shIfError		Error
    hi def link shInError		Error
    hi def link shParenError		Error
    hi def link shTestError		Error
    if exists("b:is_kornshell") || exists("b:is_posix")
      hi def link shDTestError		Error
    endif
  endif

  hi def link shArithmetic		Special
  hi def link shCharClass		Identifier
  hi def link shSnglCase		Statement
  hi def link shCommandSub		Special
  hi def link shCommandSubBQ		shCommandSub
  hi def link shConditional		Conditional
  hi def link shCtrlSeq		Special
  hi def link shExprRegion		Delimiter
  hi def link shFunctionKey		Function
  hi def link shFunctionName		Function
  hi def link shNumber		Number
  hi def link shOperator		Operator
  hi def link shRepeat		Repeat
  hi def link shSet		Statement
  hi def link shSetList		Identifier
  hi def link shShellVariables		PreProc
  hi def link shSpecial		Special
  hi def link shSpecialDQ		Special
  hi def link shSpecialSQ		Special
  hi def link shSpecialNoZS		shSpecial
  hi def link shStatement		Statement
  hi def link shString		String
  hi def link shTodo		Todo
  hi def link shAlias		Identifier
  hi def link shHereDoc01		shRedir
  hi def link shHereDoc02		shRedir
  hi def link shHereDoc03		shRedir
  hi def link shHereDoc04		shRedir
  hi def link shHereDoc05		shRedir
  hi def link shHereDoc06		shRedir
  hi def link shHereDoc07		shRedir
  hi def link shHereDoc08		shRedir
  hi def link shHereDoc09		shRedir
  hi def link shHereDoc10		shRedir
  hi def link shHereDoc11		shRedir
  hi def link shHereDoc12		shRedir
  hi def link shHereDoc13		shRedir
  hi def link shHereDoc14		shRedir
  hi def link shHereDoc15		shRedir
  hi def link shHereDoc16		shRedir
endif

" Delete shell folding commands {{{1
" =============================
delc ShFoldFunctions
delc ShFoldHereDoc
delc ShFoldIfDoFor

" Set Current Syntax: {{{1
" ===================
let b:current_syntax = "navi"

" vim:tabstop=16:fdm=marker:shiftwidth=2:expandtab:nolist:
