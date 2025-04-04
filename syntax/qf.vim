" Rewrite Quickfix window syntax

if exists('b:current_syntax')
    finish
endif

syn match QfFileName /^[^|]*/ nextgroup=QfSepLeft
syn match QfSepLeft /|/ contained nextgroup=QfLnum
syn match QfLnum /[^:]*/ contained nextgroup=QfCol
syn match QfCol /[^|]*/ contained nextgroup=QfSepRight
syn match QfSepRight '|' contained nextgroup=QfError,QfWarn,QfInfo,QfHint
syn match QfError / E .*$/ contained
syn match QfWarn / W .*$/ contained
syn match QfInfo / I .*$/ contained
syn match QfHint / H .*$/ contained

let b:current_syntax = 'qf'
