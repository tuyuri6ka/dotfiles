"" ----------------------------------------
"" Help Vim Document JP : https://vim-jp.org/vimdoc-ja/index.html
"" Vim Script           : https://knowledge.sakura.ad.jp/23436/
"" ----------------------------------------

"" ----------------------------------------
"" Plugins
"" ----------------------------------------
"" Install vim-plug if not installed
"" Make Directory for vim-plug
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

"" Install plugins
call plug#begin(s:plugdir)
	"" 爆速HTMLコーディング(divのあとに<Ctrl+Y>+, で変換)
	Plug 'mattn/emmet-vim'
	"" カラーコードをコード上でプレビューする
	Plug 'ap/vim-css-color'
	"" 閉じカッコを自動で保管してくれる
	Plug 'cohama/lexima.vim'
	"" 見た目の色合いを調整
	Plug 'jacoborus/tender.vim'
	"" 選択範囲をgccで一括コメント
	Plug 'tpope/vim-commentary'
	"" カッコなどの編集に便利
	Plug 'machakann/vim-sandwich'
	Plug 'tpope/vim-surround' | Plug 'tpope/vim-repeat'
	"" 行揃えに便利
	Plug 'junegunn/vim-easy-align'
	"" <Leader>. s<char><char> or l で瞬間移動
	Plug 'Lokaltog/vim-easymotion'
	"" <Ctrl-d or u> でなめらかに移動
	Plug 'yuttie/comfortable-motion.vim'
	"" 末尾のwhitespaaceを表示。:FixWhiteSpaceで一括削除（:5,10Fixなどで行指定も可能）
	Plug 'bronson/vim-trailing-whitespace'
	Plug 'ConradIrwin/vim-bracketed-paste'
	Plug 'tpope/vim-fugitive' | Plug 'rhysd/conflict-marker.vim'

	let g:polyglot_disabled = ['csv'] | Plug 'sheerun/vim-polyglot'

	"" 補完用Plugin
	Plug 'Shougo/ddc.vim'
	Plug 'vim-denops/denops.vim'
	" Install your sources
	Plug 'Shougo/ddc-around'
	" Install your filters
	Plug 'Shougo/ddc-matcher_head'
	Plug 'Shougo/ddc-sorter_rank'

call plug#end()

"" ----------------------------------------
""	Configure Default Vim
"" ----------------------------------------
let mapleader="\<Space>" " shortcut trigger
set clipboard=unnamedplus " copy and make it usable with any other platform
set cursorcolumn " hilighten cursor column
set fileformats=unix,dos,mac " detect break line automatically
set hidden nobackup noswapfile " do not create swap file
set laststatus=2
set lazyredraw " set not drawing each time of macro. it speeds up macro.
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set matchtime=1
set mouse=a " enable to use mouse
set nobomb " remove bom. bom is utf8 csv for excel because it needs to detect utf or not. It sometimes added by written by windows notepad.
set noswapfile
set number " show line number
set rulerformat=%40(%1*%=%l,%-(%c%V%)\ %=%t%)%* " right bottom status format
set showmatch " show corresponding brackets
set smartcase ignorecase wildignorecase " search in smart way
set splitright splitbelow " split in natural way
set statusline=%F
let $LANG='en_US.UTF-8'
set title titlestring=%F " set as absolute path
set whichwrap=b,s,h,l,<,>,[,] " enable to go to next line with these symbol
set encoding=utf-8 fileencodings=cp932,sjis,euc-jp,utf-8,iso-2022-jp " detect all kind of file format

autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " start at a line where you exit vim last time

" nvimとvimで設定を変える
if has('nvim')
	set inccommand=split " very useful replace preview
else
	syntax on " make syntax visible
	set ttyfast " scroll fast
	set autoread " if file changed outside vim. it alerms to reload or not
	set wildmenu " menu completion
	set belloff=all " cut down bell
	set ruler showcmd " show status
	set hlsearch incsearch " search in smart way
	filetype plugin indent on
	set backspace=indent,eol,start " you can delete by backspace
endif

if !exists('$TMUX')
	set termguicolors
endif

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

nnoremap <Leader>c :wv
nnoremap <Leader>p :rv!
nnoremap <Up> gk
nnoremap <Down> gj

nnoremap <silent> <C-j> :bnext<CR>
nnoremap <silent> <C-k> :bprev<CR>

"" Tender.vim
if(has("termguicolors"))
	set termguicolors
endif
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
syntax enable
colorscheme tender

"" -----------------------------------------
"" Vim-Plug
"" -----------------------------------------
nnoremap <Leader>clean   :PlugClean<CR>
nnoremap <Leader>update  :PlugUpdate<CR>
nnoremap <Leader>install :PlugInstall<CR>

"" -----------------------------------------
"" EmmetVim
"" -----------------------------------------
let g:user_emmet_settings = {
	\ 'typescript'     : { 'extends' : 'jsx' },
	\ 'javascript.jsx' : { 'extends' : 'jsx' }
\ }

"" -----------------------------------------
"" EasyAlign
"" -----------------------------------------
xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(LiveEasyAlign)

"" -----------------------------------------
"" EasyMotion
"" -----------------------------------------
map <Leader> <Plug>(easymotion-prefix)
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" `s{char}{char}{label}`
map <leader>s <Plug>(easymotion-bd-f2)
nmap <leader>s <Plug>(easymotion-overwin-f2)<Paste>

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" Move to line
map <leader>l <Plug>(easymotion-bd-jk)
nmap <leader>l <Plug>(easymotion-overwin-line)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

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
" VimTrailingWhiteSpace
"" -----------------------------------------
nnoremap <Leader>trim :FixWhitespace<CR>


"" -----------------------------------------
" ddc.vim
"" -----------------------------------------
" Customize global settings
" Use around source.
" https://github.com/Shougo/ddc-around
call ddc#custom#patch_global('sources', ['around'])

" Use matcher_head and sorter_rank.
" https://github.com/Shougo/ddc-matcher_head
" https://github.com/Shougo/ddc-sorter_rank
call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']},
      \ })

" Change source options
call ddc#custom#patch_global('sourceOptions', {
      \ 'around': {'mark': 'A'},
      \ })
call ddc#custom#patch_global('sourceParams', {
      \ 'around': {'maxSize': 500},
      \ })

" Customize settings on a filetype
call ddc#custom#patch_filetype(['c', 'cpp'], 'sources', ['around', 'clangd'])
call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', {
      \ 'clangd': {'mark': 'C'},
      \ })
call ddc#custom#patch_filetype('markdown', 'sourceParams', {
      \ 'around': {'maxSize': 100},
      \ })

" Mappings

" <TAB>: completion.
inoremap <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

" Use ddc.
call ddc#enable()

