"" ----------------------------------------
"" Help Vim Document JP : https://vim-jp.org/vimdoc-ja/index.html
"" Vim Script           : https://knowledge.sakura.ad.jp/23436/
"" ----------------------------------------

"" ----------------------------------------
""	Configure Default Vim
"" ----------------------------------------
syntax on                      " make syntax visible
filetype plugin indent on
let mapleader="\<Space>" " shortcut trigger
let $LANG='en_US.UTF-8'

set autoread                   " if file changed outside vim. it alerms to reload or not
set backspace=indent,eol,start " you can delete by backspace
set belloff=all                " cut down bell
set cursorcolumn               " hilighten cursor column

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932,sjis,euc-jp,iso-2022-jp " detect all kind of file format

set fileformats=unix,dos,mac   " detect break line automatically
set hidden nobackup noswapfile " do not create swap file
set hlsearch incsearch         " search in smart way
set laststatus=2
set lazyredraw                 " set not drawing each time of macro. it speeds up macro.

set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set matchtime=1

set mouse=a       " enable to use mouse
set nobomb        " remove bom. bom is utf8 csv for excel because it needs to detect utf or not. It sometimes added by written by windows notepad.
set number        " show line number
set ruler showcmd " show status
set rulerformat=%40(%1*%=%l,%-(%c%V%)\ %=%t%)%* " right bottom status format

set shiftwidth=2
set showmatch                           " show corresponding brackets
set smartcase ignorecase wildignorecase " search in smart way
set statusline=%F
set tabstop=2
set title titlestring=%F                " set as absolute path
set whichwrap=b,s,h,l,<,>,[,]           " enable to go to next line with these symbol
set wildmenu                            " menu completion

autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " start at a line where you exit vim last time


"" ----------------------------------------
"" Plugins
"" ----------------------------------------
"" Install vim-plug if not installed.  Make Directory for vim-plug
let s:vimdir   = has('nvim') ? '~/.config/nvim/' : '~/.vim/'
let s:plugdir  = s:vimdir . 'plugged'
let s:plugfile = s:vimdir . 'autoload/plug.vim'
let s:plugurl  = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if empty(glob(s:plugfile))
  silent execute '!mkdir -p ' . s:vimdir . 'autoload'
  if executable('curl')
    silent execute '!curl -sLo ' . s:plugfile ' ' . s:plugurl
  elseif executable('wget')
		silent execute '!wget -q -O ' . s:plugfile ' ' . s:plugurl
  else
		silent !echo 'vim-plug install failed: you need either wget or curl'
  endif
	autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

"" -------------------------------------
"" Install plugins
"" -------------------------------------
call plug#begin(s:plugdir)
	" LSP
	" winget install rustlang.rustup
	" winget install OpenJS.NodeJS.LTS
	"" 補完用Plugin
	Plug 'prabirshrestha/vim-lsp'
	Plug 'mattn/vim-lsp-settings'
	Plug 'prabirshrestha/asyncomplete.vim'
	Plug 'prabirshrestha/asyncomplete-lsp.vim'
	Plug 'prabirshrestha/asyncomplete-emmet.vim'

	"" 見た目周り
	"" 見た目の色合いを調整
	Plug 'jacoborus/tender.vim'
	"" カラーコードをコード上でプレビューする
	Plug 'ap/vim-css-color'
	"" 差分行をハイライト
	Plug 'airblade/vim-gitgutter'
	"" コンフリクトマーカーで色分け
	Plug 'rhysd/conflict-marker.vim'

	"" 入力補助補
	"" 末尾のwhitespaaceを表示。:FixWhiteSpaceで一括削除（:5,10Fixなどで行指定も可能）
	Plug 'bronson/vim-trailing-whitespace'
	"" 閉じカッコを自動で保管してくれる
	Plug 'cohama/lexima.vim'
	"" カッコなどの編集に便利
	Plug 'machakann/vim-sandwich'
	"" 爆速HTMLコーディング(divのあとに<Ctrl+Y>+, で変換)
	Plug 'mattn/emmet-vim'
	"" 選択範囲をgccで一括コメント
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-repeat'
	"" 行揃に便利
	Plug 'junegunn/vim-easy-align'

	Plug 'ConradIrwin/vim-bracketed-paste'
call plug#end()


"" ----------------------------------------
"" Mapping
"" normal  mode : nnoremap map
"" visual  mode : vnoremap vmap
"" command mode : cnoremap cmap
"" insert  mode : inoremap imap
"" rule         : [n/v/c/i][noremap] <opt> useraction vimaction
"" other        : <C-c> means Ctrl+c, <Leader> 'backslash'
"" reference    : http://vimblog/hatenablog.com/entry/vimrc_key_mapping
""              : http://yu8mada.com/2018/08/02/the-difference^between-nmap-and-nnoremap-in-vim/
"" ----------------------------------------

nnoremap <Right> <C-w>l
nnoremap <Left> <C-w>h
nnoremap <Up> <C-w>k
nnoremap <Down> <C-w>j
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>
nnoremap <silent> <C-m> :tabN<CR>
nnoremap <silent> <C-n> :tabn<CR>

"" -----------------------------------------
"" Vim-Plug
"" -----------------------------------------
nnoremap <Leader>clean   :PlugClean<CR>
nnoremap <Leader>update  :PlugUpdate<CR>
nnoremap <Leader>install :PlugInstall<CR>

"" -----------------------------------------
"" tender,vim
 "" -----------------------------------------
colorscheme tender
set termguicolors

"" -----------------------------------------
" VimTrailingWhiteSpace
"" -----------------------------------------
nnoremap <Leader>trim :FixWhitespace<CR>

"" -----------------------------------------
"" EasyAlign
"" -----------------------------------------
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"" -----------------------------------------
"" ConflictMarker
"" -----------------------------------------
let g:conflict_marker_begin = '<<<<<<< .*$'
let g:conflict_marker_end   = '>>>>>>> .*$'
highlight ConflictMarkerBegin  guibg=#2f7366
highlight ConflictMarkerOurs   guibg=#2e5049
highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
highlight ConflictMarkerTheirs guibg=#344f69
highlight ConflictMarkerEND    guibg=#2f628e

"" -----------------------------------------
" asyncomplete
"" -----------------------------------------
set completeopt=menuone
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
let g:asymcomplete#config = {
	\ 'backspace_delete_completion': 0,
	\ 'enable_auto_completion': 1
	\ }

" ============================================================
"  FileTypeごとの設定
" ============================================================
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#emmet#get_source_options({
	\ 'name': 'emmet',
	\ 'whitelist': ['html'],
	\ 'completor': function('asyncomplete#sources#emmet#completor'),
	\ }))
