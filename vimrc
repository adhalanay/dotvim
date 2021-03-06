" Vim configuration
"
" Author: Karl Yngve Lervåg

call vimrc#init()

" {{{1 Load plugins

call plug#begin(g:vimrc#path_bundles)

Plug 'junegunn/vim-plug', { 'on' : [] }

" My own plugins
call plug#(g:vimrc#path_lervag . 'vimtex')
call plug#(g:vimrc#path_lervag . 'file-line')
call plug#(g:vimrc#path_lervag . 'vim-foam')
call plug#(g:vimrc#path_lervag . 'vim-rmarkdown')
if g:vimrc#is_devhost
  call plug#(g:vimrc#path_lervag . 'wiki.vim')
  call plug#(g:vimrc#path_lervag . 'wiki-ft.vim')
  call plug#(g:vimrc#path_lervag . 'vim-sintef')
endif

" Plugin: UI
Plug 'Konfekt/FastFold'
Plug 'luochen1990/rainbow'
Plug 'andymass/vim-matchup'
Plug 'junegunn/vim-slash'
Plug 'RRethy/vim-illuminate'
Plug 'yegappan/mru' 
Plug 'JuliaEditorSupport/julia-vim'
" Plugin: Completion and snippets
if has('nvim') || v:version >= 800
  Plug 'Shougo/deoplete.nvim',
        \ has('nvim') ? { 'do': ':UpdateRemotePlugins' } : {}
endif

Plug 'roxma/vim-hug-neovim-rpc', has('nvim') ? { 'on' : [] } : {}
Plug 'roxma/nvim-yarp'
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/neco-vim'
Plug 'Shougo/neco-syntax'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'SirVer/ultisnips'

" Plugin: Text objects and similar
Plug 'wellle/targets.vim'
Plug 'machakann/vim-sandwich'

" Plugin: Finder, motions, and tags
Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
" Plug 'raghur/fruzzy'
if has('nvim') || v:version >= 800
  Plug 'ludovicchabant/vim-gutentags'
endif
Plug 'dyng/ctrlsf.vim'
Plug 'machakann/vim-columnmove'

" Plugin: Linting, debugging, and code runners
if has('nvim') || v:version >= 800
  Plug 'w0rp/ale'
endif
Plug 'idanarye/vim-omnipytent', { 'branch' : 'develop' }
Plug 'idanarye/vim-vebugger', { 'branch' : 'develop' }
Plug 'sakhnik/nvim-gdb'

" Plugin: Editing
Plug 'junegunn/vim-easy-align'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'zirrostig/vim-schlepp'

" Plugin: VCS
Plug 'rbong/vim-flog'
Plug 'tpope/vim-fugitive'
Plug 'ludovicchabant/vim-lawrencium'

" Plugin: Tmux (incl. filetype)
Plug 'whatyouhide/vim-tmux-syntax'
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'

" Plugin: Various
Plug 'itchyny/calendar.vim'
Plug 'tweekmonster/helpful.vim'
Plug 'junegunn/vader.vim', {
      \ 'on' : ['Vader'],
      \ 'for' : ['vader'],
      \}
Plug 'Shougo/vimproc', { 'do' : 'make -f make_unix.mak' }
Plug 'mbbill/undotree', { 'on' : 'UndotreeToggle' }
Plug 'tyru/capture.vim', { 'on' : 'Capture' }
Plug 'tpope/vim-unimpaired'

" Filetype: python
Plug 'davidhalter/jedi-vim'
Plug 'zchee/deoplete-jedi'
Plug 'vim-python/python-syntax'
Plug 'kalekundert/vim-coiled-snake'  " Folding
Plug 'tweekmonster/braceless.vim'    " Indents
Plug 'jeetsukumaran/vim-pythonsense' " Text objects and motions

" Filetype: vim
Plug 'tpope/vim-scriptease'

" Filetype: markdown
Plug 'plasticboy/vim-markdown'

" Filetype: various
Plug 'darvelo/vim-systemd'
Plug 'gregsexton/MatchTag'
Plug 'vim-ruby/vim-ruby'
Plug 'elzr/vim-json'
Plug 'gisraptor/vim-lilypond-integrator'
Plug 'nhooyr/neoman.vim', has('nvim') ? { 'on' : [] } : {}
Plug 'https://gitlab.com/HiPhish/info.vim'
Plug 'tpope/vim-apathy'

call plug#end()

" }}}1

if g:vimrc#bootstrap | finish | endif

" {{{1 Autocommands

augroup vimrc_autocommands
  autocmd!

  " Only use cursorline for current window
  autocmd WinEnter,FocusGained * setlocal cursorline
  autocmd WinLeave,FocusLost   * setlocal nocursorline

  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost * call personal#init#go_to_last_known_position()

  " Set keymapping for command window
  autocmd CmdwinEnter * nnoremap <buffer> q <c-c><c-c>

  " Close preview after complete
  " autocmd CompleteDone * pclose
augroup END

" {{{1 Options

" Vim specific options
if !has('nvim')
  set history=10000
  set nrformats-=octal
  if has('patch-7.4.399')
    set cryptmethod=blowfish2
  else
    set cryptmethod=blowfish
  endif
  set autoread
  set backspace=indent,eol,start
  set wildmenu
  set laststatus=2
  set autoindent
  set incsearch
endif

" Neovim specific options
if has('nvim')
  set inccommand=nosplit
endif

" Basic
set cpoptions+=J
set tags=tags;~,.tags;~
set path=.,,
if &modifiable
  set fileformat=unix
endif
set wildignore=*.o
set wildignore+=*~
set wildignore+=*.pyc
set wildignore+=.git/*
set wildignore+=.hg/*
set wildignore+=.svn/*
set wildignore+=*.DS_Store
set wildignore+=CVS/*
set wildignore+=*.mod
set diffopt=filler,vertical,foldcolumn:0,context:4
if has('patch-8.1.360')
  set diffopt+=indent-heuristic,algorithm:patience
  set diffopt+=hiddenoff
endif

" Backup, swap and undofile
set noswapfile
set undofile
set undodir=$HOME/.cache/vim/undo
set backup
set backupdir=$HOME/.cache/vim/backup
if !isdirectory(&undodir)
  call mkdir(&undodir, 'p')
endif
if !isdirectory(&backupdir)
  call mkdir(&backupdir, 'p')
endif

" Behaviour
set autochdir
set lazyredraw
set confirm
set hidden
set shortmess=aoOtT
silent! set shortmess+=cI
set textwidth=100
set nowrap
set linebreak
set comments=n:>
set nojoinspaces
set formatoptions+=ronl1j
set formatlistpat=^\\s*[-*]\\s\\+
set formatlistpat+=\\\|^\\s*(\\(\\d\\+\\\|[a-z]\\))\\s\\+
set formatlistpat+=\\\|^\\s*\\(\\d\\+\\\|[a-z]\\)[:).]\\s\\+
set winaltkeys=no
set mouse=a
set gdefault
set updatetime=1000

" Completion
set wildmode=longest:full,full
set wildcharm=<c-z>
set complete+=U,s,k,kspell,d,]
set completeopt=menuone
silent! set completeopt+=noinsert,noselect

" Presentation
set list
set listchars=tab:▸\ ,nbsp:%,trail:\ ,extends:…,precedes:…
set fillchars=vert:│,fold:\ ,diff:⣿
set matchtime=2
set matchpairs+=<:>
set cursorline
set scrolloff=5
set splitbelow
set splitright
set previewheight=20
set noshowmode

if !has('gui_running')
  set visualbell
  set t_vb=
let mapleader=","
let maplocalleader=","
function! GuiTabLabel()
    let label = ''
    let bufnrlist = tabpagebuflist(v:lnum)
 
    " Add '+' if one of the buffers in the tab page is modified
    for bufnr in bufnrlist
    if getbufvar(bufnr, "&modified")
        let label = '+'
        break
    endif
    endfor
 
    " Append the tab number
    let label .= tabpagenr().': '
 
    " Append the buffer name
    let name = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
    if name == ''
        " give a name to no-name documents
        if &buftype=='quickfix'
            let name = '[Quickfix List]'
        else
            let name = '[Not yet saved]'
        endif
    else
        " get only the file name
        let name = fnamemodify(name,":t")
    endif
    let label .= name
 
    " Append the number of windows in the tab page
    let wincount = tabpagewinnr(v:lnum, '$')
    return label . '  [' . wincount . ']'
endfunction
 
" set up tab tooltips with every buffer name
function! GuiTabToolTip()
    let tip = ''
    let bufnrlist = tabpagebuflist(v:lnum)
 
    for bufnr in bufnrlist
        " separate buffer entries
        if tip!=''
            let tip .= ' | '
        endif
 
        " Add name of buffer
        let name=bufname(bufnr)
        if name == ''
            " give a name to no name documents
            if getbufvar(bufnr,'&buftype')=='quickfix'
                let name = '[Quickfix List]'
            else
                let name = '[Not yet saved]'
            endif
        endif
        let tip.=name
 
        " add modified/modifiable flags
        if getbufvar(bufnr, "&modified")
            let tip .= ' [+]'
        endif
        if getbufvar(bufnr, "&modifiable")==0
            let tip .= ' [-]'
        endif
    endfor
 
    return tip
endfunction
 
set guitablabel=%!GuiTabLabel()
set guitabtooltip=%!GuiTabToolTip()

endif

" Folding
if &foldmethod ==# ''
  set foldmethod=syntax
endif
set foldlevelstart=0
set foldcolumn=0
set foldtext=personal#fold#foldtext()

" Indentation
set softtabstop=-1
set shiftwidth=2
set expandtab
set copyindent
set preserveindent
silent! set breakindent

" Searching and movement
set nostartofline
set ignorecase
set smartcase
set infercase
set showmatch

set display=lastline
set virtualedit=block

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
elseif executable('ack-grep')
  set grepprg=ack-grep\ --nocolor
endif

" Printing
set printexpr=PrintFile(v:fname_in)

function! PrintFile(fname)
  let l:pdf = a:fname . '.pdf'
  call system(printf('ps2pdf %s %s', a:fname, l:pdf))

  echohl ModeMsg
  let l:reply = input('View file before printing [y/N]? ')
  echohl None
  echon "\n"
  if l:reply =~# '^y'
    call system('mupdf ' . l:pdf)
  endif

  echohl ModeMsg
  let l:reply = input('Save file to $HOME [Y/n]? ')
  echohl None
  echon "\n"
  if empty(l:reply) || l:reply =~# '^n'
    call system(printf('cp %s ~/vim-hardcopy.pdf', l:pdf))
  endif

  echohl ModeMsg
  let l:reply = input('Send file to printer [y/N]? ')
  echohl None
  echon "\n"
  if l:reply =~# '^y'
    call system('lp ' . l:pdf)
    let l:error = v:shell_error
  else
    let l:error = 1
  endif

  call delete(a:fname)
  call delete(l:pdf)
  return l:error
endfunction

" {{{1 Appearance and UI

set background=light
"set winwidth=70
let mapleader=","
let maplocalleader=","
if has('gui_running')
  set lines=50
  set guifont=Inconsolata-g\ for\ Powerline\ Medium\ 9
  set guioptions=acimTrLe
  set showtabline=1
"  set guioptions += m
"  set guioptions += t
"  set guioptions += r
 " set guiheadroom=0
else
  " This is necessary for Vim
  if &t_Co == 8 && $TERM !~# '^linux'
    set t_Co=256
  endif

  " Set terminal cursor
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[6 q\<Esc>\e]12;3\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\e]12;14\x7\<Esc>\\"
  else
    let &t_SI = "\e[6 q\e]12;3\x7"
    let &t_EI = "\e[2 q\e]12;14\x7"
    silent !echo -ne "\e[2 q\e]12;14\x7"
    autocmd vimrc_autocommands VimLeave *
          \ silent !echo -ne "\e[2 q\e]112\x7"
  endif
endif

" Set colorscheme and custom colors
colorscheme oceandeep
colors oceandeep
"set guifont=DejaVu\ Sans\ Mono\ 10
set guifont=Inconsolata\ 12 " very nice, but leaves terrible artefacts with national (mostly russian) characters

"autocmd vimrc_autocommands ColorScheme * call personal#init#custom_colors()
"silent! colorscheme my_solarized

" Set gui cursor
set guicursor=a:block
set guicursor+=n:Cursor
set guicursor+=o-c:iCursor
set guicursor+=v:vCursor
set guicursor+=i-ci-sm:ver30-Cursor
set guicursor+=r-cr:hor20-rCursor
set guicursor+=a:blinkon0

" Initialize statusline and tabline
"call statusline#init()
"call statusline#init_tabline()
set cursorline   	"highlight current line
set cursorcolumn 	"highlight current column
set wildmenu
set listchars=tab:>.,trail:.,extends:#,nbsp:.
set laststatus=2	"status bar
set statusline=%n:\ %f%m%r%h%w\ [%Y,%{&fileencoding},%{&fileformat}]\ [%l-%L,%v][%p%%]\ [%{strftime(\"%l:%M:%S\ \%p,\ %a\ %b\ %d,\ %Y\")}]\ %{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
set ruler
set rulerformat=%25(%n%m%r:\ %Y\ [%l,%v]\ %p%%%)
" toujours afficher le mode courant
set showcmd		 "show the command being typed
set number 
" {{{1 Mappings

"
" Available for mapping
"
"   Q
"   U
"   ctrl-h
"   ctrl-j
"   ctrl-s
"   ctrl-space
"

" Disable some mappings
noremap  <f1>   <nop>
inoremap <f1>   <nop>
nnoremap Q      <nop>

" Some general/standard remappings
inoremap jk     <esc>
nnoremap Y      y$
nnoremap J      mzJ`z
nnoremap dp     dp]c
nnoremap do     do]c
nnoremap '      `
nnoremap <c-e>  <c-^>
nnoremap <c-p>  <c-i>
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
xnoremap <expr> j v:count ? 'j' : 'gj'
xnoremap <expr> k v:count ? 'k' : 'gk'
nnoremap gV     `[V`]

" Buffer navigation
nnoremap <silent> gb    :bnext<cr>
nnoremap <silent> gB    :bprevious<cr>

" Utility maps for repeatable quickly change/delete current word
nnoremap c*   *``cgn
nnoremap c#   *``cgN
nnoremap cg* g*``cgn
nnoremap cg# g*``cgN
nnoremap d*   *``dgn
nnoremap d#   *``dgN
nnoremap dg* g*``dgn
nnoremap dg# g*``dgN

" Navigate folds
nnoremap          zf zMzvzz
nnoremap <silent> zj :silent! normal! zc<cr>zjzvzz
nnoremap <silent> zk :silent! normal! zc<cr>zkzvzz[z

" Backspace and return for improved navigation
"nnoremap        <bs> <c-o>zvzz
"nnoremap <expr> <cr> empty(&buftype) ? '<c-]>zvzz' : '<cr>'

" Shortcuts for some files
nnoremap <silent> <leader>ev :execute 'edit' resolve($MYVIMRC)<cr>
nnoremap <silent> <leader>xv :source $MYVIMRC<cr>
nnoremap <leader>ez :edit ~/.zshrc<cr>

xnoremap <silent><expr> ++ personal#visual_math#yank_and_analyse()
nmap     <silent>       ++ vip++<esc>

nnoremap <leader>pp :hardcopy<cr>
xnoremap <leader>pp :hardcopy<cr>

" Terminal mappings
if has('nvim')
  nnoremap <c-c><c-c> :split term://zsh<cr>i
  tnoremap <esc>      <c-\><c-n>
endif

" {{{1 Configure plugins

" {{{2 internal

" Disable a lot of unnecessary internal plugins
let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logipat = 1
let g:loaded_rrhelper = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1

" }}}2

" {{{2 feature: git

let g:flog_default_format = "[%h] %ad%d\n          %s"
let g:flog_default_date_format = 'format:%Y-%m-%d %H:%M:%S'

nnoremap <silent><leader>gl :silent Flog -all<cr>
nnoremap <silent><leader>gL :silent Flog -all -path=%<cr>

augroup vimrc_flog
  autocmd!
  autocmd FileType floggraph setlocal nolist
  autocmd FileType floggraph nmap <buffer><silent> q <plug>FlogQuit
augroup END

nnoremap <silent><leader>gs :call personal#git#fugitive_toggle()<cr>
nnoremap <silent><leader>ge :Gedit<cr>
nnoremap <silent><leader>gd :Gdiff<cr>

augroup vimrc_fugitive
  autocmd!
  autocmd BufReadPost fugitive:// setlocal bufhidden=delete
  autocmd FileType git setlocal foldlevel=1
  autocmd FileType git nnoremap <buffer><silent> q :bwipeout!<cr>
augroup END

" }}}2
" {{{2 feature: completion

let g:deoplete#enable_at_startup = 1

try
  call deoplete#custom#option('smart_case', v:true)
  call deoplete#custom#option('ignore_sources', {
        \ '_': ['around'],
        \ 'dagbok': ['syntax'],
        \})

  call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])
  call deoplete#custom#source('ultisnips', 'rank', 1000)

  call deoplete#custom#var('omni', 'input_patterns', {
        \ 'foam' : g:foam#complete#re_refresh_deoplete,
        \ 'tex' : g:vimtex#re#deoplete,
        \ 'wiki' : '\[\[[^]|]{3,}$',
        \})
catch
endtry

if v:version >= 800
  inoremap <expr><c-h>   deoplete#smart_close_popup() . "\<c-h>"
  inoremap <expr><bs>    deoplete#smart_close_popup() . "\<c-h>"
endif
inoremap <expr><cr>    pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
inoremap <expr><tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" }}}2

" {{{2 plugin: ale

let g:ale_set_signs = 0

if exists('*nvim_buf_set_virtual_text')
  let g:ale_virtualtext_cursor = 1
  let g:ale_echo_cursor = 0
endif

let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_delay = 0

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'

let g:ale_statusline_format = ['Errors: %d', 'Warnings: %d', '']

let g:ale_linters = {
      \ 'tex': [],
      \ 'python': ['pylint'],
      \}

nmap <silent> <leader>aa <Plug>(ale_lint)
nmap <silent> <leader>aj <Plug>(ale_next_wrap)
nmap <silent> <leader>ak <Plug>(ale_previous_wrap)

" }}}2
" {{{2 plugin: calendar.vim

let g:calendar_first_day = 'monday'
let g:calendar_date_endian = 'big'
let g:calendar_frame = 'space'
let g:calendar_week_number = 1

nnoremap <silent> <leader>c :Calendar -position=here<cr>

" Connect to diary
augroup vimrc_calendar
  autocmd!
  autocmd FileType calendar
        \ nnoremap <silent><buffer> <cr>
        \ :<c-u>call personal#wiki#open_diary()<cr>
augroup END

" }}}2
" {{{2 plugin: CtrlFS

let g:ctrlsf_indent = 2
let g:ctrlsf_regex_pattern = 1
let g:ctrlsf_position = 'bottom'
let g:ctrlsf_context = '-B 2'
let g:ctrlsf_default_root = 'project+fw'
let g:ctrlsf_populate_qflist = 1
if executable('rg')
  let g:ctrlsf_ackprg = 'rg'
endif

nnoremap         <leader>ff :CtrlSF 
nnoremap <silent><leader>ft :CtrlSFToggle<cr>
nnoremap <silent><leader>fu :CtrlSFUpdate<cr>
vmap     <silent><leader>f  <Plug>CtrlSFVwordExec

" }}}2
" {{{2 plugin: CtrlP

let g:ctrlp_map = ''
let g:ctrlp_switch_buffer = 'e'
let g:ctrlp_working_path_mode = 'rc'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']

if executable('fd')
  let g:ctrlp_user_command += ['fd --type f --color=never "" %s']
  let g:ctrlp_use_caching = 0
elseif executable('rg')
  let g:ctrlp_user_command += ['rg %s --files --color=never --glob ""']
  let g:ctrlp_use_caching = 0
elseif executable('ag')
  let g:ctrlp_user_command += ['ag %s -l --nocolor -g ""']
  let g:ctrlp_use_caching = 0
endif

" let g:ctrlp_match_func = {'match': 'pymatcher#PyMatch'}
" let g:ctrlp_match_func = {'match': 'fruzzy#ctrlp#matcher'}
" let g:fruzzy#usenative = 1
let g:ctrlp_tilde_homedir = 1
let g:ctrlp_match_window = 'top,order:ttb,min:30,max:30'
let g:ctrlp_status_func = {
      \ 'main' : 'statusline#ctrlp',
      \ 'prog' : 'statusline#ctrlp',
      \}
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_mruf_exclude = '\v' . join([
      \ '\/\.%(git|hg)\/',
      \ '\.wiki$',
      \ '\.snip$',
      \ '\.vim\/vimrc$',
      \ '\/vim\/.*\/doc\/.*txt$',
      \ '_%(LOCAL|REMOTE)_',
      \ '\~record$',
      \ '^\/tmp\/',
      \ '^man:\/\/',
      \], '|')

" Mappings
nnoremap <silent> <leader>oo       :CtrlP<cr>
nnoremap <silent> <leader>og       :CtrlPRoot<cr>
nnoremap <silent> <leader>ov       :CtrlP ~/.vim<cr>
nnoremap <silent> <leader>op       :call personal#ctrlp#vim_plugs()<cr>
nnoremap <silent> <leader>ob       :CtrlPBuffer<cr>
nnoremap <silent> <leader>ow       :CtrlPWiki<cr>
nnoremap <silent> <leader>ot       :CtrlPTag<cr>
nnoremap <silent> <leader><leader> :CtrlPMRU<cr>
" nnoremap <silent> <leader><leader>
"       \ :call personal#ctrlp#disable_matchfunc('CtrlPMRU')<cr>

" }}}2
" {{{2 plugin: FastFold

nmap <sid>(DisableFastFoldUpdate) <plug>(FastFoldUpdate)
let g:fastfold_fold_command_suffixes =  ['x','X']
let g:fastfold_fold_movement_commands = []

" }}}2
" {{{2 plugin: rainbow

let g:rainbow_active = 1
let g:rainbow_conf = {
      \ 'guifgs': ['#f92672', '#00afff', '#268bd2', '#93a1a1', '#dc322f',
      \   '#6c71c4', '#b58900', '#657b83', '#d33682', '#719e07', '#2aa198'],
      \ 'ctermfgs': ['9', '127', '4', '1', '3', '12', '5', '2', '6', '33',
      \   '104', '124', '7', '39'],
      \ 'separately' : {
      \   'gitconfig' : 0,
      \   'wiki' : 0,
      \   'md' : 0,
      \   'help' : 0,
      \   'lua' : 0,
      \   'fortran' : {},
      \   'systemd' : 0,
      \   'cfg' : 0,
      \   'vim' : 0,
      \ }
      \}

" }}}2
" {{{2 plugin: targets.vim

let g:targets_argOpening = '[({[]'
let g:targets_argClosing = '[]})]'
let g:targets_separators = ', . ; : + - = ~ _ * # / | \ &'
let g:targets_nl = 'nN'

" }}}2
" {{{2 plugin: UltiSnips

let g:UltiSnipsExpandTrigger = '<c-U>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:UltiSnipsSnippetDirectories = [vimrc#path('UltiSnips')]

nnoremap <leader>es :UltiSnipsEdit!<cr>

" }}}2
" {{{2 plugin: undotree

let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

nnoremap <f5> :UndotreeToggle<cr>

" }}}2
" {{{2 plugin: vimux

let g:VimuxOrientation = 'h'
let g:VimuxHeight = '50'
let g:VimuxResetSequence = ''

" Open and manage panes/runners
nnoremap <leader>io :call VimuxOpenRunner()<cr>
nnoremap <leader>iq :VimuxCloseRunner<cr>
nnoremap <leader>ip :VimuxPromptCommand<cr>
nnoremap <leader>in :VimuxInspectRunner<cr>

" Send commands
nnoremap <leader>ii  :call VimuxSendText("jkk\n")<cr>
nnoremap <leader>is  :set opfunc=personal#vimux#operator<cr>g@
nnoremap <leader>iss :call VimuxRunCommand(getline('.'))<cr>
xnoremap <leader>is  "vy :call VimuxSendText(@v)<cr>

" }}}2
" {{{2 plugin: vim-easy-align

let g:easy_align_bypass_fold = 1

nmap ga <plug>(LiveEasyAlign)
vmap ga <plug>(LiveEasyAlign)
nmap gA <plug>(EasyAlign)
vmap gA <plug>(EasyAlign)
vmap .  <plug>(EasyAlignRepeat)

" }}}2
" {{{2 plugin: vim-columnmove

let g:columnmove_no_default_key_mappings = 1

for s:x in split('ftFT;,wbeWBE', '\zs') + ['ge', 'gE']
  silent! call columnmove#utility#map('nxo', s:x, 'ø' . s:x, 'block')
endfor
unlet s:x

" }}}2
" {{{2 plugin: vim-gutentags

let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_generate_on_new = 0
let g:gutentags_file_list_command = {
      \ 'markers': {
      \   '.git': 'git ls-files',
      \   '.hg': 'hg files',
      \ },
      \}

" }}}2
" {{{2 plugin: vim-illuminate

let g:Illuminate_delay = 0
let g:Illuminate_ftblacklist = [
      \ 'dagbok',
      \ 'wiki',
      \]

" }}}2
" {{{2 plugin: vim-lawrencium

nnoremap <leader>hs :Hgstatus<cr>
nnoremap <leader>hl :Hglog<cr>
nnoremap <leader>hL :Hglogthis<cr>
nnoremap <leader>hd :call personal#hg#wrapper('Hgvdiff')<cr>
nnoremap <leader>hr :call personal#hg#wrapper('Hgvrecord')<cr>
nnoremap <leader>ha :call personal#hg#abort()<cr>

" }}}
" {{{2 plugin: vim-lsp

" Disable on old Vims
if v:version < 800
  let g:lsp_auto_enable = 0
endif

let g:lsp_log_verbose = 1
let g:lsp_log_file = '/tmp/vim-lsp.log'
let g:lsp_diagnostics_enabled = 0

nnoremap <silent> <leader>ld :LspDefinition<cr>
nnoremap <silent> <leader>lr :LspReferences<cr>
nnoremap <silent> <leader>lR :LspRename<cr>
nnoremap <silent> <leader>lh :LspHover<cr>

if executable('pyls')
  augroup vimrc_lsp
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->['pyls']},
          \ 'whitelist': ['python'],
          \})
  augroup END
endif

" }}}2
" {{{2 plugin: vim-matchup

let g:matchup_matchparen_status_offscreen = 0
let g:matchup_override_vimtex = 1

" }}}2
" {{{2 plugin: vim-omnipytent

let g:omnipytent_filePrefix = ''
let g:omnipytent_defaultPythonVersion = 3
let g:omnipytent_projectRootMarkers = ['.git', '.hg']

nnoremap         <leader>re :OPedit 
nnoremap <silent><leader>rr :OP<cr>
nnoremap <silent><leader>rt :OP test<cr>

" }}}2
" {{{2 plugin: vim-plug

" See autoload/vimrc.vim

" }}}2
" {{{2 plugin: vim-sandwich

let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1
let g:textobj_sandwich_no_default_key_mappings = 1

" Support for python like function names
let g:sandwich#magicchar#f#patterns = [
  \   {
  \     'header' : '\<\%(\h\k*\.\)*\h\k*',
  \     'bra'    : '(',
  \     'ket'    : ')',
  \     'footer' : '',
  \   },
  \ ]


try
  " Change some default options
  call operator#sandwich#set('delete', 'all', 'highlight', 0)
  call operator#sandwich#set('all', 'all', 'cursor', 'keep')

  " Surround mappings (similar to surround.vim)
  nmap gs  <plug>(operator-sandwich-add)
  nmap gss <plug>(operator-sandwich-add)iW
  nmap ds  <plug>(operator-sandwich-delete)<plug>(textobj-sandwich-query-a)
  nmap dss <plug>(operator-sandwich-delete)<plug>(textobj-sandwich-auto-a)
  nmap cs  <plug>(operator-sandwich-replace)<plug>(textobj-sandwich-query-a)
  nmap css <plug>(operator-sandwich-replace)<plug>(textobj-sandwich-auto-a)
  xmap sa  <plug>(operator-sandwich-add)
  xmap sd  <plug>(operator-sandwich-delete)
  xmap sr  <plug>(operator-sandwich-replace)

  " Text objects
  xmap is  <plug>(textobj-sandwich-query-i)
  xmap as  <plug>(textobj-sandwich-query-a)
  omap is  <plug>(textobj-sandwich-query-i)
  omap as  <plug>(textobj-sandwich-query-a)
  xmap iss <plug>(textobj-sandwich-auto-i)
  xmap ass <plug>(textobj-sandwich-auto-a)
  omap iss <plug>(textobj-sandwich-auto-i)
  omap ass <plug>(textobj-sandwich-auto-a)

  " Allow repeats while keeping cursor fixed
  silent! runtime autoload/repeat.vim
  nmap . <plug>(operator-sandwich-predot)<plug>(RepeatDot)

  " Default recipes
  let g:sandwich#recipes  = deepcopy(g:sandwich#default_recipes)
  let g:sandwich#recipes += [
        \ {
        \   'buns' : ['{\s*', '\s*}'],
        \   'input' : ['}'],
        \   'kind' : ['delete', 'replace', 'auto', 'query'],
        \   'regex' : 1,
        \   'nesting' : 1,
        \   'match_syntax' : 1,
        \   'skip_break' : 1,
        \   'indentkeys-' : '{,},0{,0}'
        \ },
        \ {
        \   'buns' : ['\[\s*', '\s*\]'],
        \   'input' : [']'],
        \   'kind' : ['delete', 'replace', 'auto', 'query'],
        \   'regex' : 1,
        \   'nesting' : 1,
        \   'match_syntax' : 1,
        \   'indentkeys-' : '[,]'
        \ },
        \ {
        \   'buns' : ['(\s*', '\s*)'],
        \   'input' : [')'],
        \   'kind' : ['delete', 'replace', 'auto', 'query'],
        \   'regex' : 1,
        \   'nesting' : 1,
        \   'match_syntax' : 1,
        \   'indentkeys-' : '(,)'
        \ },
        \]
catch
endtry

" }}}2
" {{{2 plugin: vim-schlepp

vmap <unique> <up>    <Plug>SchleppUp
vmap <unique> <down>  <Plug>SchleppDown
vmap <unique> <left>  <Plug>SchleppLeft
vmap <unique> <right> <Plug>SchleppRight

" }}}2
" {{{2 plugin: vim-slash

noremap <plug>(slash-after) zz

" }}}2
" {{{2 plugin: vim-table-mode

let g:table_mode_auto_align = 0

" }}}2
" {{{2 plugin: vim-tmux-navigator

let g:tmux_navigator_disable_when_zoomed = 1

" }}}
" {{{2 plugin: vim-vebugger

let g:vebugger_leader = '<leader>d'

" }}}

" {{{2 filetype: json

let g:vim_json_syntax_conceal = 0

" }}}2
" {{{2 filetype: markdown

let g:vim_markdown_folding_style_pythonic = 0
let g:vim_markdown_override_foldtext = 0
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_extensions_in_markdown = 1

" }}}2
" {{{2 filetype: python

" Note: I should remember to install python-jedi and python2-jedi!
" Note: See more settings at:
"       ~/.vim/personal/ftplugin/python.vim
"       ~/.vim/personal/after/ftplugin/python.vim

" I prefer to map jedi.vim features manually
let g:jedi#auto_initialization = 0

" Syntax
let g:python_highlight_all = 1

" Folding
let g:coiled_snake_foldtext_flags = []

" Use Braceless for
" - indents
" - text objects (indent blocks ii, ai)
let g:braceless_block_key = 'i'
augroup MyBraceless
  autocmd!
  autocmd User BracelessInit nunmap J
  autocmd User BracelessInit iunmap <cr>
  autocmd FileType python BracelessEnable +indent
augroup END

" }}}2
" {{{2 filetype: ruby

let g:ruby_fold=1

" }}}2
" {{{2 filetype: tex

let g:tex_stylish = 1
let g:tex_conceal = ''
let g:tex_flavor = 'latex'
let g:tex_isk='48-57,a-z,A-Z,192-255,:'

let g:vimtex_fold_enabled = 1
let g:vimtex_fold_types = {
      \ 'sections' : {'parse_levels': 1},
      \}
let g:vimtex_format_enabled = 1
"let g:vimtex_view_method = 'zathura'
let g:vimtex_view_automatic = 0
let g:vimtex_view_forward_search_on_start = 0
let g:vimtex_toc_config = {
      \ 'split_pos' : 'full',
      \ 'mode' : 2,
      \ 'fold_enable' : 1,
      \ 'hotkeys_enabled' : 1,
      \ 'hotkeys_leader' : '',
      \ 'refresh_always' : 0,
      \}
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_quickfix_autoclose_after_keystrokes = 3
let g:vimtex_imaps_leader = '\|'
let g:vimtex_complete_img_use_tail = 1
let g:vimtex_complete_bib = {
      \ 'simple' : 1,
      \ 'menu_fmt' : '@year, @author_short, @title',
      \}
let g:vimtex_echo_verbose_input = 0
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = 'file:@pdf\#src:@line@tex'
let g:vimtex_view_general_options_latexmk = '--unique'


if has('nvim')
  let g:vimtex_compiler_progname = 'nvr'
endif

"
" NOTE: See also ~/.vim/personal/ftplugin/tex.vim
"

" }}}2
" {{{2 filetype: vim

" Internal vim plugin
let g:vimsyn_embed = 'P'

" }}}2
" {{{2 filetype: wiki

let g:wiki_root = '~/documents/wiki'
let g:wiki_toc_title = 'Innhald'
let g:wiki_viewer = {'pdf': 'zathura'}
let g:wiki_export = {'from_format': 'gfm'}
let g:wiki_filetypes = ['wiki', 'md']
let g:wiki_month_names = [
      \ 'januar',
      \ 'februar',
      \ 'mars',
      \ 'april',
      \ 'mai',
      \ 'juni',
      \ 'juli',
      \ 'august',
      \ 'september',
      \ 'oktober',
      \ 'november',
      \ 'desember'
      \]
let g:wiki_template_title_week = '# Samandrag veke %(week), %(year)'
let g:wiki_template_title_month = '# Samandrag frå %(month-name) %(year)'

let g:wiki_toc_depth = 2
let g:wiki_file_open = 'personal#wiki#file_open'

" }}}2

" }}}1
