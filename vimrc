" dein ------------------------------------------------------------------------ {{{
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('~/.vim/dein')
  call dein#begin('~/.vim/dein')
  call dein#add('~/.vim/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('scrooloose/nerdtree.git')
  call dein#add('vim-ruby/vim-ruby.git')
  call dein#add('chriskempson/base16-vim.git')
  call dein#add('tpope/vim-git.git')
  call dein#add('Keithbsmiley/swift.vim.git')
  call dein#add('lambdatoast/elm.vim.git')

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif
" -------------------------------------------------------------------------- }}}
" Basic configuration ------------------------------------------------------ {{{

set nocompatible
syntax on
filetype plugin indent on

let mapleader=','

noremap <leader>ev :edit $MYVIMRC<CR>
noremap <leader>sv :source $MYVIMRC<CR>

set termguicolors

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

set hidden
set switchbuf=useopen

set expandtab
set smarttab
set tabstop=4
set shiftwidth=2
set softtabstop=2
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
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:·
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

set number
set relativenumber

set wrap
set textwidth=80
set formatoptions=qrn1
" execute "set colorcolumn=" . join(range(81,335), ',')
set synmaxcol=256

set winwidth=79
set t_ti= t_te=

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
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.bmp,*.ico
set wildignore+=*.sw?
set wildignore+=.netrwhist
set wildignore+=.DS_Store
set wildignore+=*.cs,*.sln,*.config,*.asax,*.resx
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
" Preserve ----------------------------------------------------------------- {{{

" Remove trailing whitespace
noremap <leader>w :call <SID>Preserve("%s/\\s\\+$//e")<CR>
" Format file
noremap <leader>r :call <SID>Preserve("normal gg=G")<CR>

" augroup TrailingWhitespace
"     autocmd BufWritePre * call <SID>Preserve("%s/\\s\\+$//e")
" augroup END

function! s:Preserve(command)
    " Save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")

    " Do the business:
    execute a:command

    " Restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" -------------------------------------------------------------------------- }}}
" Multipurpose tab --------------------------------------------------------- {{{
inoremap <Tab> <C-R>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-N>

function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-P>"
    endif
endfunction
" -------------------------------------------------------------------------- }}}
" Ruby Test Runner --------------------------------------------------------- {{{
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
" Selecta ------------------------------------------------------------------ {{{
" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
nnoremap <leader>f :call SelectaCommand("find * -type f", "", ":e")<cr>

function! SelectaBuffer()
  let bufnrs = filter(range(1, bufnr("$")), 'buflisted(v:val)')
  let buffers = map(bufnrs, 'bufname(v:val)')
  call SelectaCommand('echo "' . join(buffers, "\n") . '"', "", ":b")
endfunction

" Fuzzy select a buffer. Open the selected buffer with :b.
nnoremap <leader>b :call SelectaBuffer()<cr>
" -------------------------------------------------------------------------- }}}
" Rename ------------------------------------------------------------------ {{{
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction

map <leader>N :call RenameFile()<CR>
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
    au BufNewFile,BufRead Fastfile set filetype=ruby
augroup END
" ruby END }}}
" html {{{
augroup ft_html
    au!
    au FileType html setlocal nowrap
augroup END
" html END }}}
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
" Gist {{{
noremap <leader>g :Gist<CR>

let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
" }}}
" Javascript {{{
let b:javascript_fold = 1
let javascript_enable_domhtmlcss = 1
let g:javascript_conceal = 1
" }}}
" -------------------------------------------------------------------------- }}}
