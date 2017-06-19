" Officially distributed filetypes

" Support functions {{{
function! s:setf(filetype) abort
  if &filetype !~# '\<'.a:filetype.'\>'
    let &filetype = a:filetype
  endif
endfunction

func! s:StarSetf(ft)
  if expand("<amatch>") !~ g:ft_ignore_pat
    exe 'setf ' . a:ft
  endif
endfunc
" }}}

" HTML with Ruby - eRuby
au BufNewFile,BufRead *.erb,*.rhtml				call s:setf('eruby')

" Interactive Ruby shell
au BufNewFile,BufRead .irbrc,irbrc				call s:setf('ruby')

" Ruby
au BufNewFile,BufRead *.rb,*.rbw,*.gemspec			call s:setf('ruby')

" Rackup
au BufNewFile,BufRead *.ru					call s:setf('ruby')

" Bundler
au BufNewFile,BufRead Gemfile					call s:setf('ruby')

" Ruby on Rails
au BufNewFile,BufRead *.builder,*.rxml,*.rjs,*.ruby		call s:setf('ruby')

" Rakefile
au BufNewFile,BufRead [rR]akefile,*.rake			call s:setf('ruby')
au BufNewFile,BufRead [rR]akefile*				call s:StarSetf('ruby')

" Rantfile
au BufNewFile,BufRead [rR]antfile,*.rant			call s:setf('ruby')

" vim: nowrap sw=2 sts=2 ts=8 noet fdm=marker:
" All other filetypes

" Support functions {{{
function! s:setf(filetype) abort
  if &filetype !=# a:filetype
    let &filetype = a:filetype
  endif
endfunction
" }}}

" Appraisal
au BufNewFile,BufRead Appraisals		call s:setf('ruby')

" Autotest
au BufNewFile,BufRead .autotest			call s:setf('ruby')

" Buildr Buildfile
au BufNewFile,BufRead [Bb]uildfile		call s:setf('ruby')

" Capistrano
au BufNewFile,BufRead Capfile,*.cap		call s:setf('ruby')

" Chef
au BufNewFile,BufRead Cheffile			call s:setf('ruby')
au BufNewFile,BufRead Berksfile			call s:setf('ruby')

" CocoaPods
au BufNewFile,BufRead Podfile,*.podspec		call s:setf('ruby')

" Guard
au BufNewFile,BufRead Guardfile,.Guardfile	call s:setf('ruby')

" Jbuilder
au BufNewFile,BufRead *.jbuilder		call s:setf('ruby')

" Kitchen Sink
au BufNewFile,BufRead KitchenSink		call s:setf('ruby')

" Opal
au BufNewFile,BufRead *.opal			call s:setf('ruby')

" Pry config
au BufNewFile,BufRead .pryrc			call s:setf('ruby')

" Puppet librarian
au BufNewFile,BufRead Puppetfile		call s:setf('ruby')

" Rabl
au BufNewFile,BufRead *.rabl			call s:setf('ruby')

" Routefile
au BufNewFile,BufRead [rR]outefile		call s:setf('ruby')

" SimpleCov
au BufNewFile,BufRead .simplecov		call s:setf('ruby')

" Thor
au BufNewFile,BufRead [tT]horfile,*.thor	call s:setf('ruby')

" Vagrant
au BufNewFile,BufRead [vV]agrantfile		call s:setf('ruby')

" vim: nowrap sw=2 sts=2 ts=8 noet fdm=marker:
" Git
autocmd BufNewFile,BufRead *.git/{,modules/**/,worktrees/*/}{COMMIT_EDIT,TAG_EDIT,MERGE_,}MSG set ft=gitcommit
autocmd BufNewFile,BufRead *.git/config,.gitconfig,gitconfig,.gitmodules set ft=gitconfig
autocmd BufNewFile,BufRead */.config/git/config                          set ft=gitconfig
autocmd BufNewFile,BufRead *.git/modules/**/config                       set ft=gitconfig
autocmd BufNewFile,BufRead git-rebase-todo                               set ft=gitrebase
autocmd BufNewFile,BufRead .gitsendemail.*                               set ft=gitsendemail
autocmd BufNewFile,BufRead *.git/**
      \ if getline(1) =~ '^\x\{40\}\>\|^ref: ' |
      \   set ft=git |
      \ endif

" This logic really belongs in scripts.vim
autocmd BufNewFile,BufRead,StdinReadPost *
      \ if getline(1) =~ '^\(commit\|tree\|object\) \x\{40\}\>\|^tag \S\+$' |
      \   set ft=git |
      \ endif
autocmd BufNewFile,BufRead *
      \ if getline(1) =~ '^From \x\{40\} Mon Sep 17 00:00:00 2001$' |
      \   set filetype=gitsendemail |
      \ endif
autocmd BufNewFile,BufRead *.swift set filetype=swift
autocmd BufRead * call s:Swift()
function! s:Swift()
  if !empty(&filetype)
    return
  endif

  let line = getline(1)
  if line =~ "^#!.*swift"
    setfiletype swift
  endif
endfunction
au BufNewFile,BufRead *.elm		set filetype=elm
