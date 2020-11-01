"" ----------------------------------------
"" Help Vim Document JP : https://vim-jp.org/vimdoc-ja/index.html
"" Vim Script           : https://knowledge.sakura.ad.jp/23436/
"" ----------------------------------------

"" ----------------------------------------
"" Plugins
"" ----------------------------------------
"" Install vim-plug if not installed
"" Make Directory for vim-plug
let s:vimdir   = has('nvim') ? '~/.config/nvim/' : '~/.vim'
let s:plugdir  = s:vimdir . 'plugged'
let s:plugfile = s:vimdir . 'autoload/plug.vim'
let s:plugurl  = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if empty(glob(s:plugfile))
	silent !echo '[Downloading vim-plug]...'
	silent execute '!mkdir -p ' . s:vimdir . 'autoload' 
	"" Install vim-plug by curl or wget command
	if executable('curl')
		silent execute '!curl -sLo ' . s:plugfile ' ' . s:plugurl
	elseif executable('wget')
		silent execute '!wget -q -O ' . s:plugfile ' ' . s:plugurl
	else
		silent !echo 'vim-plug install failed: you need either wget or curl'
		cquit
	endif
	autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

"" Install plugins
call plug#begin(s:plugdir)
	Plug 'mattn/emmet-vim'
	Plug 'ap/vim-css-color'
	Plug 'cohama/lexima.vim'
	"Plug 'ayu-theme/ayu-vim'
	Plug 'jacoborus/tender.vim'
	Plug 'tpope/vim-commentary'
	Plug 'machakann/vim-sandwich'
	Plug 'junegunn/vim-easy-align'
	Plug 'Lokaltog/vim-easymotion'
	Plug 'yuttie/comfotable-motion.vim'
	Plug 'bronson/vim-trailing-whitespace'
	Plug 'ConradIrwin/vim-bracketed-paste'
	Plug 'tpope/vim-surround' | Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-fugitive' | Plug 'rhysd/conflict-marker.vim'
	let g:polyglot_disabled = ['csv'] | Plug 'sheerun/vim-polyglot'
	Plug 'neoclide/coc.vim', {'do': 'yarn install --frozen-lockfile'}
	Plug 'junegunn/fzf.vim' | Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
call plug#end()


"" ----------------------------------------
""	Configure Default Vim
"" ----------------------------------------
set nobomb " remove bom. bom is utf8 csv for excel because it needs to detect utf or not. It sometimes added by written by windows notepad.
set number " show line number
set cursorcolumn " hilighten cursor column
set showmatch " show corresponding brackets
set mouse=a " enable to use mouse
set matchtime=1
set statusline=%F
set laststatus=2
set lazyredraw " set not drawing each time of macro. it speeds up macro.
let $LANG='en_US.UTF-8'
let mapleader="\<Space>" " shortcut trigger
set title titlestring=%F " set as absolute path
set splitright splitbelow " split in natural way
set clipboard=unnamedplus " copy and make it usable with any other platform
set fileformats=unix,dos,mac " detect break line automatically
set whichwrap=b,s,h,l,<,>,[,] " enable to go to next line with these symbol
set hidden nobackup noswapfile " do not create swap file
set smartcase ignorecase wildignorecase " search in smart way
set rulerformat=%40(%1*%=%l,%-(%c%V%)\ %=%t%)%* " right bottom status format
set encoding=utf-8 fileencodings=cp932,sjis,euc-jp,utf-8,iso-2022-jp " detect all kind of file format

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

autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " start at a line where you exit vim last time

" 文字コードの自動変換
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc='euc-jp'
	let s:enc_jis='iso-2022-jp'
	" iconvがeucJP-msに対応しているかをチェック
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc='eucjp-ms'
		let s:enc_jis='iso-2022-jp-3'
		" iconvがJISX0213に対応しているかをチェック
	elseif iconv("\x87\x64\x87\x6q", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc='euc-jisx0213'
		let s:enc_jis='iso-2022-jp-3'
	endif
	" fileencodings
	if &encoding ==# 'utf-8'
		let s:fileencodings_default=&fileencodings
		let &fileencodings=s:enc_jis . ',' . s:enc_euc . ',cp932'
		let &fileencodings=&fileencodings . ',' . s:fileencodings_default
		unlet s:fileencodings_default
	else
		let &fileencodings=&fileencodings . ',' . s:enc_jis
		set fileencodings+=utf-8,ucs-2le,uc-2
		if &encoding =~# '^(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			set fileencoding+=cp932
			set fileencoding+=euc-jp
			set fileencoding+=euc-jisx0213
			set fileencoding+=euc-jp-ms
			let &encoding=s:enc_euc
			let &fileencoding=s:enc_euc
		else
			let &fileencoding=&fileencodings . ',' . s:enc_euc
		endif
	endif
	" 定数部分を処分
	unlet s:enc_euc
	unlet s:enc_jis
endif
" 日本語を含まない場合はfileencofing に encoding を使うようにする
if has('autocmd')
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-20220-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif

autocmd BufReadPost * if line("'\'") > 0 && line("'\'") <= line("$") | exe "normal! g'\"" | endif " start at a line where you exit vim last time

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
nnoremap Y y$
nnoremap + <C-a>
nnoremap - <C-x>
nnoremap <Up> gk
nnoremap <Down> gj
nnoremap <ESC> <C-\><C-n>
nnoremap <Leader>t :tabnew<CR>
nnoremap <Leader>1 :diffget LOCAL<CR>
nnoremap <Leader>2 :diffget BASE<CR>
nnoremap <Leader>3 :diffget REMOTE<CR>
nnoremap <Leader>code :!code %:p<CR>
nnoremap <Leader>dir :!code -r %:p:h<CR>
nnoremap <Leader>term :split \| terminal<CR>
map <Leader>\ :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <silent> <C-j> :bnext<CR>
nnoremap <silent> <C-k> :bprev<CR>

"" ----------------------------------------
"" PluginSetting
"" ----------------------------------------

"" ColorTheme --------------------
"" AyuVim
"let ayucolor='dark'
"colorscheme ayu
"highlight User1       guifg=#3d424D
"highlight Noramal     guibg=#0A0E14
"highlight ModeMsg     guifg=#3D424D
"highlight FoldColumn  guibg=#0A0E14
"highlight EndOfBuffer ctermfg=0 guifg=bg
"highlight DiffEnd     gui=NONE guifg=NONE    guibg=#003366
"highlight DiffDelete  gui=bold guifg=#660000 guibg=#660000
"highlight DiffChange  gui=NONE guifg=NONE    guibg=#006666
"highlight DiffNext    gui=NONE guifg=NONE    guibg=#013220

"" Tender.vim
if(has("termguicolors"))
	set termguicolors
endif
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
syntax enable
colorscheme tender

"" -----------------------------------------
"" FzfVim
"" -----------------------------------------
nnoremap <Leader>file :Files<CR>
nnoremap <Leader>hist :History<CR>
nnoremap <Leader>rg   :call Rg()<CR>
let g:fzf_layout={ 'right': '~45%' }
command! -bang -nargs=* Histroy call fzf#vim#history(fzf#vim#with_preview('down:50%'))
command! -bang -nargs=* -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview('down:50%'), <bang>0)
function! Rg()
	let string=input("Search String: ')
	call fzf#run(fzf#wrap({
		\ 'source: 'rg -lin ' . string,
		\ 'option: '--preview-window bottom:60% --preview "rg -in --color-always ' . string . ' {}"7
	\ }))
endfunction

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
let g:EasyMotion_do_mapping=0
let g:EasyMotion_enter_jump_first=1
map <Leader>s <Plug>(easymotion-sn)

"" -----------------------------------------
"" VimFugitive
"" -----------------------------------------
nnoremap <Leader>gd  :Gdiff<CR>
nnoremap <Leader>ga  :Gwrite<CR>
nnoremap <Leader>gb  :Gblame<CR>
nnoremap <Leader>gs  :Gstatus<CR>
nnoremap <Leader>dp  :diffput<CR>
nnoremap <Leader>du  :diffupdate<CR>
nnoremap <Leader>dgl  :diffget //2 \| diffupdate<CR>
nnoremap <Leader>dgr  :diffget //3 \| diffupdate<CR>
set diffopt+=vertical

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
nnoremap <Leader>trim :FixWhiteSpace<CR>

"" -----------------------------------------
"" Coc.nvim
"" -----------------------------------------
let g:coc_config_home = "~"
let g:coc_node_path = '/home/game/.nvm/versions/node/v10.22.1/bin/node'
inoremap <expr> <UP> pumvisible() ? '<C-e><UP>' : '<UP>'
inoremap <expr> <DOWN> pumvisible() ? '<C-e><DOWN>' : '<DOWN>'
function! TabComp()
	if pumvisible()
		return "\<C-n>"
	elseif coc#jumpable()
		return "\<C-r>=coc#rpc#request('snippetNext',[])\<CR>"
	else
		return "\<Tab>"
	endif
endfunction
imap <expr> <Tab> TabComp() | smap <expr> <Tab> TabComp()
function! TabShiftComp()
	if pumvisible()
		return "\<C-p>"
	elseif coc#jumpable()
		return "\<C-r>=coc#rpc#request('snippetPrev',[])\<CR>"
	else
		return "\<S-Tab>"
	endif
endfunction
	
imap <expr> <S-Tab> TabShiftComp() | smap <expr> <S-Tab> TabShiftComp()
let g:coc_global_extensions = [
	\ 'coc-snippets'
\]
imap <C-j> <Plug>(coc-snippets-expand-jump)
