" Vim syntax file
" Language:	Metamorp
" Maintainer:	Lucas Wagner <lowagner@gmail.com>
" Last Change:	2016 August 05
" Credits:	Zvezdan Petkovic, Neil Schemenauer, and Dmitry Vasiliev (python.vim) 
"		Bram Moolenaar (c.vim)
" Info:	Can copy to (note that vim74 directory may differ with version):
"		/usr/share/vim/vim74/syntax/mm.vim
"	and replace the line in /usr/share/vim/vim74/filetype.vim regarding "*.mm" with
"		"au BufNewFile,BufRead *.mm		setf mm"
if exists("b:current_syntax")
  finish
endif

" We need nocompatible mode in order to continue lines with backslashes.
" Original setting will be restored.
let s:cpo_save = &cpo
set cpo&vim

syn keyword mmStatement	false null true 
syn keyword mmStatement	return break sizeof goto location exit
syn keyword mmStatement	fn pod class enumerate conglomerate
syn keyword mmStatement	print printing error erroring warn warning
syn keyword mmConditional	elif else if consider case also default
syn keyword mmRepeat	for while
syn match mmDeReference	"\$"
syn match mmGetReference	"@"
syn keyword mmInclude	include import
syn keyword mmAsync		async await
syn keyword	mmType		const char int uint float file
syn keyword	mmType		int1 int2 int3 int4 int5 int6 int7 int8 int16 int32 int64 int128
syn keyword	mmType		uint1 uint2 uint3 uint4 uint5 uint6 uint7 uint8 uint16 uint32 uint64 uint128
syn keyword	mmType		float32 float64
syn match   mmTranspilerDirective	"mm#.*$"
syn match   mmComment	"#.*$" contains=mmTodo
syn keyword mmTodo		FIXME NOTE NOTES TODO XXX contained

syn match	mmFormat		display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlLjzt]\|ll\|hh\)\=\([aAbdiuoxXDOUfFeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
syn match   mmEscape	display contained "\\." 

syn region  mmString matchgroup=mmQuotes
      \ start=+"+ end=+"+ skip=+\\\\\|\\"+
      \ contains=mmEscape,mmFormat,@Spell extend
syn region  mmTranspilerDirective matchgroup=mmTranspilerDirective
      \ start="mm\"\"\"" end="\"\"\"" keepend
      \ contains=mmEscape
syn region  mmComment matchgroup=mmLongComment
      \ start="\"\"\"" end="\"\"\"" keepend
      \ contains=mmEscape,mmSpaceError,mmTodo

syn match	mmCharError	"'\\[^abfnrtv'\\]*'"
syn match	mmCharError	"''"
syn match	mmCharError	"'''"
syn match	mmCharError	"'[^\\].*'"
syn match	mmChar	"'[^'\\]'" 
syn match	mmEscapeChar	"'\\[abfnrtv'\\]'" 

if exists("mm_highlight_all")
  if exists("mm_no_builtin_highlight")
    unlet mm_no_builtin_highlight
  endif
  if exists("mm_no_exception_highlight")
    unlet mm_no_exception_highlight
  endif
  if exists("mm_no_number_highlight")
    unlet mm_no_number_highlight
  endif
  let mm_space_error_highlight = 1
endif

" It is very important to understand all details before changing the
" regular expressions below or their order.
" The word boundaries are *not* the floating-point number boundaries
" because of a possible leading or trailing decimal point.
" The expressions below ensure that all valid number literals are
" highlighted, and invalid number literals are not.  For example,
"
" - a decimal point in '4.' at the end of a line is highlighted,
" - a second dot in 1.0.0 is not highlighted,
" - 08 is not highlighted,
" - 08e0 or 08j are highlighted,
"
" and so on, as specified in the 'Python Language Reference'.
" https://docs.mm.org/2/reference/lexical_analysis.html#numeric-literals
" https://docs.mm.org/3/reference/lexical_analysis.html#numeric-literals
if !exists("mm_no_number_highlight")
  " numbers (including longs and complex)
  syn match   mmNumber	"\<0[oO]\=\o\+[Ll]\=\>"
  syn match   mmNumber	"\<0[xX]\x\+[Ll]\=\>"
  syn match   mmNumber	"\<0[bB][01]\+[Ll]\=\>"
  syn match   mmNumber	"\<\%([1-9]\d*\|0\)[Ll]\=\>"
  syn match   mmNumber	"\<\d\+[jJ]\>"
  syn match   mmNumber	"\<\d\+[eE][+-]\=\d\+[jJ]\=\>"
  syn match   mmNumber
	\ "\<\d\+\.\%([eE][+-]\=\d\+\)\=[jJ]\=\%(\W\|$\)\@="
  syn match   mmNumber
	\ "\%(^\|\W\)\zs\d*\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>"
endif

if !exists("mm_no_builtin_highlight")
  syn keyword mmBuiltin	len
  syn keyword mmBuiltin	allocate new free disband
  syn keyword mmBuiltin	abs floor ceil
endif

if exists("mm_space_error_highlight")
  " trailing whitespace
  syn match   mmSpaceError	display excludenl "\s\+$"
  " mixed tabs and spaces
  syn match   mmSpaceError	display " \+\t"
  syn match   mmSpaceError	display "\t\+ "
endif

" Sync at the beginning of class, function, or method definition.
syn sync match mmSync grouphere NONE "^\s*\%(fn\|pod\|class\)\s\+\h\w*\s*("

if version >= 508 || !exists("did_mm_syn_inits")
  if version <= 508
    let did_mm_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default highlight links.  Can be overridden later.
  HiLink mmEscape		Special
  HiLink mmStatement	Statement
  HiLink mmConditional	Conditional
  HiLink mmType	Type
  HiLink mmRepeat		Repeat
  HiLink mmDeReference		Type
  HiLink mmGetReference		Type
  HiLink mmInclude		Include
  HiLink mmAsync		Statement
  HiLink mmFunction		Function
  HiLink mmComment		Comment
  HiLink mmSingleQuotes		Special
  HiLink mmChar		Statement
  HiLink mmEscapeChar		Special
  HiLink mmCharError		Error
  HiLink mmLongComment		String
  HiLink mmTodo		Todo
  HiLink mmFormat		Special
  HiLink mmString		String
  HiLink mmQuotes		String
  HiLink mmEscape		Special
  HiLink mmTranspilerDirective	Special
  if !exists("mm_no_number_highlight")
    HiLink mmNumber		Number
  endif
  if !exists("mm_no_builtin_highlight")
    HiLink mmBuiltin	Function
  endif
  if exists("mm_space_error_highlight")
    HiLink mmSpaceError	Error
  endif
  delcommand HiLink
endif

let b:current_syntax = "mm"

let &cpo = s:cpo_save
unlet s:cpo_save

