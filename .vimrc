"" ----------------------------------------
""	Configure
"" ----------------------------------------
set nobomb
set lazyredraw
set laststatus=0
set termguicolors
let $LANG='en_US.UTF-8'
let mapleader="\<Space>"
set title titlestring=%F
set splitright splitbelow
set clipboard=unnamedplus
set fileformats=unix,dos,mac
set whichwrap=b,s,h,l,<,>,[,]
set hidden nobackup noswapfile
set smartcase ignorecase wildignorecase
set rulerformat=%40(%1*%=%l,%-(%c%V%)\ %=%t%)%*
set noexpandtab tabstop=4 softtabstop=-1 shiftwidth=0
set encoding=utf-8 fileencodings=cp932,sjis,euc-jp,utf-8,iso-2022-jp
if has('nvim')
	set inccommand=split
else
	syntax on
	set ttyfast
	set autoread
	set wildmenu
	set belloff=all
	set ruler showcmd
	set hlsearch incsearch
	filetype plugin indent on
	set backspace=indent,eol,start
endif

