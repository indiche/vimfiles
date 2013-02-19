execute pathogen#infect()

" Basic configuration ------------------------------------------------------ {{{

set nocompatible
syntax on
filetype plugin indent on

let mapleader=','

let g:solarized_underline=0

set background=light
colorscheme solarized

set hidden
set switchbuf=useopen

set expandtab
set smarttab
set tabstop=8
set shiftwidth=4
set softtabstop=4
set autoindent

set backspace=indent,eol,start
set complete-=i
set showmatch

set nrformats-=octal
set shiftround

set notimeout
set ttimeout
set ttimeoutlen=50

set incsearch
set ignorecase smartcase
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

set laststatus=2
set ruler
set showmode
set showcmd

set scrolloff=3
set sidescroll=1
set sidescrolloff=10
set display+=lastline

set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set showbreak=↪

set fillchars=diff:⣿,vert:│

set autoread
set autowrite
set encoding=utf-8
set fileformats+=mac

set history=1000
set viminfo^=!
set undofile
set undoreload=10000

set lazyredraw
set visualbell
set title

set wrap
set textwidth=80
set formatoptions=qrn1
set colorcolumn=+1
set synmaxcol=160

" Make Y consistent with C and D
nnoremap Y y$

set complete=.,w,b,u,t
set completeopt=longest,menuone,preview

set wildmenu
set wildmode=longest,list

" Save on lost focus
au FocusLost * :silent! wall
" Keep splits equal
au VimResized * :wincmd =

" Hide cursor line in insert mode
augroup CursorLine
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END

" Force two space
augroup TwoSpace
    au!
    au BufRead * set cpoptions+=J
augroup END

" Reopen file on the same line
augroup LastLine
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g`\"" |
                \ endif
augroup END

" Backup {{{
set backup
set noswapfile

set undodir=$HOME/.vim/tmp/undo//
set backupdir=$HOME/.vim/tmp/backup//
set directory=$HOME/.vim/tmp/swap//

" Make those folders if they don't exist
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif
" Backup END }}}
" Ignore {{{
set wildignore+=.hg,.git,.svn
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.bmp
set wildignore+=*.sw?
set wildignore+=.netrwhist
set wildignore+=.DS_Store
" }}}

" -------------------------------------------------------------------------- }}}
" Folding ------------------------------------------------------------------ {{{

set foldlevelstart=0

nnoremap <Space> za
vnoremap <Space> za

function! FoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . '…' . foldedlinecount . ' '
endfunction

set foldtext=FoldText()
" -------------------------------------------------------------------------- }}}
" Test Runner -------------------------------------------------------------- {{{
noremap <leader>ev :edit $MYVIMRC<CR>
noremap <leader>sv :source $MYVIMRC<CR>

noremap <leader>t :call <SID>RunTest()<CR>

function! s:RunTest()
    let is_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if is_test_file
        let t:test_file = @%
    elseif !exists("t:test_file")
        echom "No test file found"
        return
    endif

    write
    silent !echo
    silent !echo
    silent !echo
    silent !echo

    if match(t:test_file, '\.feature$') != -1
        if filereadable("script/features")
            exec ":!script/features " . t:test_file
        else
            exec ":!cucumber --color " . t:test_file
        end
    else
        if filereadable("script/test")
            exec ":!script/test " . t:test_file
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . t:test_file
        else
            exec ":!rspec --color " . t:test_file
        end
    end
endfunction

" -------------------------------------------------------------------------- }}}
" Filetype ----------------------------------------------------------------- {{{
" vim {{{
augroup ft_vim
    au!
    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=78
    au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END
" vim END }}}
" ruby {{{
augroup ft_ruby
    au!
    au FileType ruby setlocal tabstop=4 shiftwidth=2 softtabstop=2
augroup END
" ruby END }}}
" -------------------------------------------------------------------------- }}}
" Plugin ------------------------------------------------------------------- {{{
" NERD Tree {{{
noremap  <F2> :NERDTreeToggle<cr>
inoremap <F2> <esc>:NERDTreeToggle<cr>

augroup ps_nerdtree
    au!
    au Filetype nerdtree setlocal nolist
augroup END

let NERDTreeHighlightCursorline = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDChristmasTree = 1
let NERDTreeChDirMode = 2
let NERDTreeMapJumpFirstChild = 'gK'
" }}}
" -------------------------------------------------------------------------- }}}
