" Vim syntax file
" Language:		env files (NOT shell code)
" Source:		https://github.com/overleaf/vim-env-syntax/blob/main/syntax/env.vim

" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" Match KEY=VALUE
syn match envVariable /^\h\w*\ze=/ nextgroup=envEquals
syn match envEquals   contained /=/ nextgroup=envValue
syn match envValue    contained /.*/ contains=envCommentPart

" Allow inline comments after values (optional)
syn match envCommentPart contained /#.*$/

" Comments and unassigned variables
syn match envComment /^\s*#.*$/
syn match envVariableUnassigned /^\h\w*$/

" Highlight links
hi def link envVariable Identifier
hi def link envEquals   Operator
hi def link envValue    String
hi def link envCommentPart Comment
hi def link envComment  Comment
hi def link envVariableUnassigned Error

" USE THIS AS A TEST ENV FILE
" # Test env file
" # -------------
"
" # Regular assignment
" FOO=bar
"
" # Do not highlight shell keywords in value (compare with `:setf sh`).
" SH_KEYWORDS=[1,2,3] $(date) { "foo": true } # comment
" MANY_EQUAL_SIGNS=foo=bar='baz'
"
" # Highlight quoted values as errors.  They are not necessarily errors, but more
" # often than not, quotes are added with an understanding of shell quoting,
" # leading to unexpected quote characters in the value.
" SINGLE_QUOTED='foo'
" DOUBLE_QUOTED="foo"
"
" # Spaces after the equal sign are permitted, but also become part of the value
" # and are usually oversights.
" SPACE_AFTER_EQUAL= foo bar
" SPACE_AT_LINE_END=foo bar
"
" # Variables without assigned values were valid Kustomize syntax for a while,
" # but this is now considered a bug:
" # https://github.com/kubernetes/website/issues/35669.
" NOT_ASSIGNED
