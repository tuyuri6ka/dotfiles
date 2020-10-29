"" ----------------------------------------
"" Plugins
"" ----------------------------------------
"" Install vim-plug if not installed
"" Make Directory for vim-plug
if empty(glob('~/.vim\autoload/plug.vim'))
	silent !echo '[Downloading vim-plug]...'
	silent !mkdir -p ~/.vim/autoload
	"" Install vim-plug by curl or wget command
	let s:plugfile = '~/.vim/autoload/plug.vim'
	let s:plugurl  = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
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
let plugdir=has('nvim') ? '~/.config/nvim/plugged/' : '~/.vim/plugged'
call plug#begin(plugdir)
	Plug 'mattn/emmet-vim'
	Plug 'ap/vim-css-color'
	Plug 'cohama/lexima.vim'
	Plug 'ayu-theme/ayu-vim'
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
	Plug 'junegunn/fzf.vim' | Plug 'junegunn/fzf', {'dir', '~/.fzf', 'do', './install --all'}
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
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " start at a line where you exit vim last time

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

nnormap Y y$
nnormap + <C-a>
nnormap - <C-x>
nnormap <Up> gk
nnormap <Down> gj
nnormap <ESC> <C-\><C-n>
nnormap <Leader>t :tabnew<CR>
nnormap <Leader>1 :diffget LOCAL<CR>
nnormap <Leader>2 :diffget BASE<CR>
nnormap <Leader>3 :diffget REMOTE<CR>
nnormap <Leader>code :!code %:p<CR>
nnormap <Leader>dir :!code -r %:p:h<CR>
nnormap <Leader>term :split \| terminal<CR>
map <Leader>\ :vsp <CR>:exec("tag ".expand("<cword>"))<CR>


let ayucolor='dark'
colorscheme ayu


"" EmmetVim
let g:user_emmet_settings = {
	\ 'typescript'     : { 'extends' : 'jsx' },
	\ 'javascript.jsx' : { 'extends' : 'jsx' }
\ }

"" EasyAlign
xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(LiveEasyAlign)

"" EasyMotion
let g:EasyMotion_do_mapping=0
let g:EasyMotion_enter_jump_first=1
map <Leader>s <Plug>(easymotion-sn)

"" VimFugitive
nnoremap <Leader>gd  :Gdiff<CR>
nnoremap <Leader>ga  :Gwrite<CR>
nnoremap <Leader>gb  :Gblame<CR>
nnoremap <Leader>gs  :Gstatus<CR>
nnoremap <Leader>dp  :diffput<CR>
nnoremap <Leader>du  :diffupdate<CR>
nnoremap <Leader>dgl  :diffget //2 \| diffupdate<CR>
nnoremap <Leader>dgr  :diffget //3 \| diffupdate<CR>
set diffopt+=vertical

"" ConflictMarker
let g:conflict_marker_begin = '<<<<<<< .*$'
let g:conflict_marker_end   = '>>>>>>> .*$'
highlight ConflictMarkerBegin  guibg=#2f7366
highlight ConflictMarkerOurs   guibg=#2e5049
highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
highlight ConflictMarkerTheirs guibg=#344f69
highlight ConflictMarkerEND    guibg=#2f628e

" VimTrailingWhiteSpace
nnoremap <Leader>trim :FixWhiteSpace<CR>

"" Coc.nvim
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
imap <expr> <S-Tab> TabShiftComp() | smap <expr> <S-Tab> TabShiftComp()
let g:coc_global_extensions = [
	\ 'coc-snippets'
\]
imap <C-j> <Plug>(coc-snippets-expand-jump)


