" vim: fdm=marker foldenable sw=4 ts=4 sts=4
" This is my .vimrc File, most of it came from Max Canto's .vimrc File " https://github.com/changemewtf/dotfiles/blob/master/vim/.vimrc 
" {{{ Clear all autocommands

" TODO: It might be more honest to put this in my ,v auto-source-vimrc binding
au!

" }}}

" {{{ Plugins and Settings

" Vundle is used to handle plugins.
" https://github.com/gmarik/Vundle.vim

" {{{ VUNDLE SETUP

set nocompatible
filetype off
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" Plugin 'joshdick/onedark.vim'
" let g:dracula_colorterm = 0
" Plugin 'dracula/vim', { 'name': 'dracula' }

" }}}

" {{{ Rust
"     ====

Plugin 'rust-lang/rust.vim'

"}}}

" {{{ context
"     =======

Plugin 'wellle/context.vim'

"}}}

" {{{ committia
"     =========

Plugin 'rhysd/committia.vim'

" }}}

" {{{ gv
"     ==

Plugin 'junegunn/gv.vim'

" }}}


" {{{ jedi-vim
"     ==

Plugin 'davidhalter/jedi-vim'

let g:jedi#auto_initialization = 1
let g:jedi#popup_on_dot = 0

let g:jedi#completions_enabled = 1
" let g:jedi#auto_vim_configuration = 1
let g:jedi#show_call_signatures = 2
let g:jedi#goto_command = "<leader>jg"
let g:jedi#goto_definitions_command = "<leader>jd"
let g:jedi#rename_command = "<leader>jr"
let g:jedi#usages_command = "<leader>jn"

" }}}

" {{{ ale

Plugin 'dense-analysis/ale'

let b:ale_fixers = {
\    '*': ['remove_trailing_lines', 'trim_whitespace'],
\    'python': ['black'],
\}

" let b:ale_linters = {'python': ['pyright']}

" }}}

" {{{ vim-test
"     ========

Plugin 'vim-test/vim-test'

let test#python#runner = 'pytest'
let test#strategy = "dispatch"

" }}}

" {{{ vim-visual-multi
"     ===========

Plugin 'mg979/vim-visual-multi'

let g:VM_maps = {}
let g:VM_maps["Add Cursor Down"]    = '<C-j>'   " new cursor down
let g:VM_maps["Add Cursor Up"]      = '<C-k>'   " new cursor up

" }}}

" {{{ vim-gitgutter
"     ===========

Plugin 'airblade/vim-gitgutter'

" }}}

" {{{ vim-airline
"     ===========

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

let g:airline#extensions#obsession#indicator_text = 'Obsession'
let g:airline_extensions = ['obsession', 'branch']

let g:airline_theme='base16_dracula'

if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set termguicolors

" }}}

" {{{ vim-maximizer
"     =============

Plugin 'szw/vim-maximizer'

" }}}

" {{{ vim-fetch
"     =========

Plugin 'wsdjeg/vim-fetch'

" }}}

" {{{ vim-instant-markdown
"     ====================

" Plugin 'suan/vim-instant-markdown'

" }}}

" {{{ vim-csv
" 
"     ====================

" Plugin 'chrisbra/csv.vim'

" }}}
"

" {{{ vim-merginal
"
"     ============

Plugin 'idanarye/vim-merginal'

" }}}
"

" {{{ His Home-Row-ness the Pope of Tim
"     =================================

" vim-surround: s is a text-object for delimiters; ss linewise
" ys to add surround
Plugin 'tpope/vim-surround'

" vim-dispatch
Plugin 'tpope/vim-dispatch'

" vim-unimpaired
Plugin 'tpope/vim-unimpaired'

" vim-obsession
Plugin 'tpope/vim-obsession'

" vim-commentary: gc is an operator to toggle comments; gcc linewise
Plugin 'tpope/vim-commentary'

" vim-repeat: make vim-commentary and vim-surround work with .
" Plugin 'tpope/vim-repeat'

" vim-markdown: some stuff for fenced language highlighting
Plugin 'tpope/vim-markdown'

let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'yaml', 'haml', 'bash=sh']

" vim-fugitive: git is heaven
Plugin 'tpope/vim-fugitive'

" Command to add a co-author to a commit
command! -nargs=+ Gca :r!git log -n100 --pretty=format:"\%an <\%ae>" | grep -i '<args>' | head -1 | xargs echo "Coauthored-by:"

" vim-vinegar
Plugin 'tpope/vim-vinegar'

" vim-eunuch
Plugin 'tpope/vim-eunuch'

" }}}

" {{{ NERDTree
"     ========

Plugin 'scrooloose/nerdtree'

" OPTIONS:

" Get rid of objects in C projects
let NERDTreeIgnore=['\~$', '.o$', 'bower_components', 'node_modules', '__pycache__']
let NERDTreeHijackNetrw=1
" let NERDTreeWinSize=20
" 
nmap <Leader>pv :NERDTreeToggle<CR>

" }}}

" {{{ netrw: Configuration
"     ====================
"
let g:netrw_chgwin = -1
let g:netrw_banner=0        " disable banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=1     " tree view
let g:netrw_winsize=-28      " width of tree explorer
" hide gitignore'd files
let g:netrw_list_hide=netrw_gitignore#Hide()
" hide dotfiles by default (this is the string toggled by netrw-gh)
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
" nnoremap <Leader>pv :Lexplore<CR>

" let g:NetrwIsOpen=0
" function! ToggleNetrw()
"     if g:NetrwIsOpen
"         let i = bufnr("$")
"         while (i >= 1)
"             if (getbufvar(i, "&filetype") == "netrw")
"                 silent exe "bwipeout " . i
"             endif
"             let i-=1
"         endwhile
"         let g:NetrwIsOpen=0
"     else
"         let g:NetrwIsOpen=1
"         silent Lexplore
"     endif
" endfunction

" " noremap <silent> <C-E> :call ToggleNetrw()<CR>
" nnoremap <silent> <leader>pv :call ToggleNetrw()<CR>

" Opens netrw with vim
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

" }}}

" {{{ skeleton-config
"     ===============
" autocmd BufNewFile README.md 0r ~/skeletons/README.md
" autocmd BufNewFile readme.md 0r ~/skeletons/readme.md

autocmd BufNewFile *.sh 0r ~/.config/skeletons/bash.sh

" {{{ undotree
"     ======

Plugin 'mbbill/undotree'

" OPTIONS:

set undodir=~/.vim/undodir
set undofile

" }}}

" {{{ vim-syntastic
"     ==========

" Plugin 'vim-syntastic/syntastic'

" OPTIONS:

" let g:syntastic_python_checkers = ['python3', 'flake8']
" let g:syntastic_python_pylint_exec = 'flake8'

" }}}

" {{{ vim-wakatime
"     ============

Plugin 'wakatime/vim-wakatime'

" }}}

" {{{ vim-startify
"     ============

" Plugin 'mhinz/vim-startify'

" }}}

" </PLUGINS>

" {{{ VUNDLE TEARDOWN

call vundle#end()
filetype plugin indent on

" }}}

" }}}

" {{{ Basic Settings

" clipboard
set clipboard=unnamedplus

" Modelines
set modelines=2
set modeline

" Leading zeros
set nrformats-=octal

" Colorscheme
syntax on
" colorscheme onedark

" For clever completion with the :find command
set path+=**

" Always use bash syntax for sh filetype
let g:is_bash=1

" Search
set ignorecase smartcase
set grepprg=grep\ -IrsnH
set incsearch

" Window display
set showcmd ruler laststatus=2

" Mac OS X clipboard
set clipboard=unnamed

" Numbers
set number
set relativenumber

" Splits
set splitright
set splitbelow      " default split is below

" Ident
set smartindent   " Do smart autoindenting when starting a new line
set shiftwidth=4  " Set number of spaces per auto indentation
set tabstop=4       " number of visual spaces per TAB

" Buffers
set history=500
set hidden
if exists("&undofile")
    set undofile
endif

" Text display
set listchars=trail:.,tab:>-,extends:>,precedes:<,nbsp:¬
set list

" Typing behavior
set backspace=indent,eol,start
set showmatch
set wildmode=full
set wildmenu
set complete-=i

" Formatting
set nowrap
set tabstop=2 shiftwidth=2 softtabstop=2
set foldlevelstart=2

" Status line
" set statusline=%!MyStatusLine()

" Session saving
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,localoptions

" Word splitting
"set iskeyword+=-

" }}}

" {{{ Autocommands

augroup Markdown
  autocmd!
  autocmd FileType markdown set wrap
augroup END

augroup Mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END

" Change the QuickFixLine background color
" augroup vimrc_colors
"     au!
"     au ColorScheme * hi QuickFixLine ctermfg=NONE cterm=bold guifg=NONE gui=bold
" augroup END

" Make the modification indicator [+] white on red background
" au ColorScheme * hi User1 gui=bold term=bold cterm=bold guifg=white guibg=red ctermfg=white ctermbg=red

" Tweak the color of the fold display column
" au ColorScheme * hi FoldColumn cterm=bold ctermbg=233 ctermfg=146
" highlight Pmenu ctermbg=blue guibg=blue guifg=white ctermbg=white
" highlight PMenuSel ctermbg=white guibg=white guifg=black ctermfg=black
" highlight PmenuSbar ctermbg=gray guibg=gray
" highlight PmenuThumb ctermbg=red guibg=red

" Spaces Only
au FileType swift,mustache,markdown,cpp,hpp,vim,sh,html,htmldjango,css,sass,scss,javascript,coffee,python,ruby,eruby setl expandtab list

" Tabs Only
au FileType c,h,make setl foldmethod=syntax noexpandtab nolist
au FileType gitconfig,apache,sql setl noexpandtab nolist

" Folding
au FileType html,htmldjango,css,sass,javascript,coffee,python,ruby,eruby setl foldmethod=indent foldenable
au FileType json setl foldmethod=indent foldenable shiftwidth=4 softtabstop=4 tabstop=4 expandtab

" Tabstop/Shiftwidth
au FileType mustache,ruby,eruby,javascript,coffee,sass,scss setl softtabstop=2 shiftwidth=2 tabstop=2
au FileType rst setl softtabstop=3 shiftwidth=3 tabstop=3

" Other
au FileType python let b:python_highlight_all=1
au FileType markdown setl linebreak

" }}}

" {{{ Syntax Hilighting

" This has to happen AFTER autocommands are defined, because I run au! when,
" defining them, and syntax hilighting is done with autocommands.

" Syntax hilighting
syntax enable
" set hlsearch

" }}}

" Key Mappings {{{

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

"split navigations
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" vim-maximizer
noremap <C-w>m :MaximizerToggle<CR>

" Newlines
" nnoremap <C-J> o<ESC>k
" nnoremap <C-K> O<ESC>j

" Select the stuff I just pasted
nnoremap gV `[V`]

" De-fuckify whitespace
nnoremap <F4> :retab<CR>:%s/\s\+$//e<CR><C-o>

" Change indent continuously
vmap < <gv
vmap > >gv

" camelCase => camel_case
vnoremap ,case :s/\v\C(([a-z]+)([A-Z]))/\2_\l\3/g<CR>

" Session mappings
let g:sessions_dir = '~/vim-sessions'
nnoremap <Leader>ss :Obsession ' . g:session_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
nnoremap <Leader>sr :so ' . g:session_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'
nnoremap <Leader>sp :Obsession<CR>

" Merginal
map <leader>gB :MerginalToggle<CR>

" Instant Python constructors
nnoremap ,c 0f(3wyt)o<ESC>pV:s/\([a-z_]\+\),\?/self.\1 = \1<C-v><CR>/g<CR>ddV?def<CR>j

" Directory of current file (not pwd)
cnoremap %% <C-R>=expand('%:h').'/'<CR>

" Swap order of Python function arguments
nnoremap <silent> ,- :%s/\(self\.\)\?<C-R><C-W>(\(self, \)\?\([a-zA-Z]\+\), \?\([a-zA-Z]\+\))/\1<C-R><C-W>(\2\4, \3)/g<CR>

" Insert timestamp
nnoremap <C-d> "=strftime("%-l:%M%p")<CR>P
inoremap <C-d> <C-r>=strftime("%-l:%M%p")<CR>

" UndoTree
nnoremap <leader>u :UndotreeShow<CR>

" Context
nnoremap <leader>c :ContextToggle<CR>

" Diff Mode
nnoremap <silent> ,j :if &diff \| exec 'normal ]czz' \| endif<CR>
nnoremap <silent> ,k :if &diff \| exec 'normal [czz' \| endif<CR>
nnoremap <silent> ,p :if &diff \| exec 'normal dp' \| endif<CR>
nnoremap <silent> ,o :if &diff \| exec 'normal do' \| endif<CR>
nnoremap <silent> ZD :if &diff \| exec ':qall' \| endif<CR>

" Code Snippet Easy Copy Pasting
function! CompleteYank()
    redir @n | silent! :'<,'>number | redir END
    let filename=expand("%")
    let decoration=repeat('-', len(filename)+1)
    let @+=decoration . "\n" . filename . ':' . "\n" . decoration . "\n" . @n
endfunction
vnoremap <leader>y :call CompleteYank()<CR>

function! FindMarkers(marker)
    :Ggrep a:marker <CR>:cw<CR>
endfunction

" Scroll Up/Down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap J <PageDown>
nnoremap K <PageUp>

" Interpreter
nnoremap <leader>p :w !clear; python3<cr>

" hi SpellBad    ctermfg=015      ctermbg=000     cterm=none      guifg=#FFFFFF   guibg=#000000   gui=none
" hi SpellBad ctermfg=015 ctermbg=009 cterm=bold guibg=#ff0000 guifg=#000000 gui=bold
hi QuickFixLine term=reverse ctermbg=52 cterm=bold gui=bold

" Resize
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

" }}}

" if &term =~ '^screen'
"     " tmux will send xterm-style keys when its xterm-keys option is on
"     execute "set <xUp>=\e[1;*A"
"     execute "set <xDown>=\e[1;*B"
"     execute "set <xRight>=\e[1;*C"
"     execute "set <xLeft>=\e[1;*D"
" endif

" Custom Functions {{{

" MyStatusLine() {{{

" function! MyStatusLine()
"     let statusline = ""
"     " Filename (F -> full, f -> relative)
"     let statusline .= "%f"
"     " Buffer flags
"     let statusline .= "%( %h%1*%m%*%r%w%) "
"     " File format and type
"     let statusline .= "(%{&ff}%(\/%Y%))"
"     " Left/right separator
"     let statusline .= "%="
"     " Line & column
"     let statusline .= "(%l,%c%V) "
"     " Character under cursor (decimal)
"     let statusline .= "%03.3b "
"     " Character under cursor (hexadecimal)
"     let statusline .= "0x%02.2B "
"     " File progress
"     let statusline .= "| %P/%L"
"     " Obsession vim-session
"     for i in range(tabpagenr('$'))
"         " select the highlighting
"         if i + 1 == tabpagenr()
"             let statusline .= '%#TabLineSel#'
"         else
"             let statusline .= '%#TabLine#'
"     endif

"     " set the tab page number (for mouse clicks)
"     let statusline .= '%' . (i + 1) . 'T'

"     " the label is made by MyTabLabel()
"     let statusline .= ' %{MyTabLabel(' . (i + 1) . ')} '
"     endfor

"     " after the last tab fill with TabLineFill and reset tab page nr
"     let statusline .= '%#TabLineFill#%T'

"     let statusline .= '%=' " Right-align after this

"     if exists('g:this_obsession')
"         let statusline .= '%#diffadd#' " Use the "DiffAdd" color if in a session
"     endif

"     " add vim-obsession status if available
"     if exists(':Obsession')
"         let statusline .= "%{ObsessionStatus()}"
"         if exists('v:this_session') && v:this_session != ''
"             let s:obsession_string = v:this_session
"             let s:obsession_parts = split(s:obsession_string, '/')
"             let s:obsession_filename = s:obsession_parts[-1]
"             let statusline .= ' ' . s:obsession_filename . ' '
"             let statusline .= '%*' " Restore default color
"         endif
"     endif

"     return statusline
" endfunction

" }}}

" {{{ Abbreviations
cabbrev vsf vert sfind
" }}}

" {{{ MyTabLine()

" function MyTabLabel(n)
"   let buflist = tabpagebuflist(a:n)
"   let winnr = tabpagewinnr(a:n)
"   return bufname(buflist[winnr - 1])
" endfunction

" }}}

" }}}

" presentation mode
noremap <Left> :silent bp<CR> :redraw!<CR>
noremap <Right> :silent bn<CR> :redraw!<CR>
nmap <F5> :set relativenumber! number! showmode! showcmd! hidden! ruler!<CR>
nmap <F2> :call DisplayPresentationBoundaries()<CR>
nmap <F3> :call FindExecuteCommand()<CR>

" jump to slides
nmap <F9> :call JumpFirstBuffer()<CR> :redraw!<CR>
nmap <F10> :call JumpSecondToLastBuffer()<CR> :redraw!<CR>
nmap <F11> :call JumpLastBuffer()<CR> :redraw!<CR>

" makes Ascii art font
nmap <leader>F :.!toilet -w 200 -f standard<CR>
nmap <leader>f :.!toilet -w 200 -f small<CR>
" makes Ascii border
nmap <leader>1 :.!toilet -w 200 -f term -F border<CR>

let g:presentationBoundsDisplayed = 0
function! DisplayPresentationBoundaries()
  if g:presentationBoundsDisplayed
    match
    set colorcolumn=0
    let g:presentationBoundsDisplayed = 0
  else
    highlight lastoflines ctermbg=darkred guibg=darkred
    match lastoflines /\%23l/
    set colorcolumn=80
    let g:presentationBoundsDisplayed = 1
  endif
endfunction

function! FindExecuteCommand()
  let line = search('\S*!'.'!:.*')
  if line > 0
    let command = substitute(getline(line), "\S*!"."!:*", "", "")
    execute "silent !". command
    execute "normal gg0"
    redraw
  endif
endfunction

function! JumpFirstBuffer()
  execute "buffer 1"
endfunction

function! JumpSecondToLastBuffer()
  execute "buffer " . (len(Buffers()) - 1)
endfunction

function! JumpLastBuffer()
  execute "buffer " . len(Buffers())
endfunction

function! Buffers()
  let l:buffers = filter(range(1, bufnr('$')), 'bufexists(v:val)')
  return l:buffers
endfunction

" Automatically source an eponymous <file>.vim or <file>.<ext>.vim if it exists, as a bulked-up
" modeline and to provide file-specific customizations.
function! s:AutoSource()
    let l:testedScripts = ['syntax.vim']
    if expand('<afile>:e') !=# 'vim'
        " Don't source the edited Vimscript file itself.
        call add(l:testedScripts, 'syntax.vim')
    endif

    for l:filespec in l:testedScripts
        if filereadable(l:filespec)
            execute 'source' fnameescape(l:filespec)
        endif
    endfor

    call FindExecuteCommand()
endfunction
augroup AutoSource
    autocmd! BufNewFile,BufRead * call <SID>AutoSource()
augroup END
