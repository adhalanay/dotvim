"
" Personal settings for vimscript files
"
" Last Update: 2013-04-14
" Author:      Karl Yngve Lervåg
"

"
" Only load the file once
"
if exists('b:did_ft_vim') | finish | endif
let b:did_ft_vim = 1

"
" Define some settings
"
if exists('ruby_fold') | unlet ruby_fold | endif
set foldmethod=marker
