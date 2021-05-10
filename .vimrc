" vim: fdm=marker foldenable sw=4 ts=4 sts=4
" This is my .vimrc File, most of it came from Max Canto's .vimrc File
" https://github.com/changemewtf/dotfiles/blob/master/vim/.vimrc

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

" }}}

" {{{ vim-fetch
"     =========

Plugin 'wsdjeg/vim-fetch'

" }}}

" {{{ vim-tmux
"     ========

Plugin 'tmux-plugins/vim-tmux'

" }}}

" {{{ vim-obsession
"     ========

Plugin 'tpope/vim-obsession'

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

" {{{ His Home-Row-ness the Pope of Tim
"     =================================

" vim-surround: s is a text-object for delimiters; ss linewise
" ys to add surround
Plugin 'tpope/vim-surround'

" vim-commentary: gc is an operator to toggle comments; gcc linewise
Plugin 'tpope/vim-commentary'

" vim-repeat: make vim-commentary and vim-surround work with .
Plugin 'tpope/vim-repeat'

" vim-liquid: syntax stuff
Plugin 'tpope/vim-liquid'

" vim-markdown: some stuff for fenced language highlighting
Plugin 'tpope/vim-markdown'
let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'yaml', 'haml', 'bash=sh']

Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-eunuch'

" }}}

" {{{ NERDTree
"     ========

" Plugin 'scrooloose/nerdtree'

" OPTIONS:

" Get rid of objects in C projects
" let NERDTreeIgnore=['\~$', '.o$', 'bower_components', 'node_modules', '__pycache__']
" let NERDTreeWinSize=20
" 
" nmap <C-f> :NERDTreeToggle<CR>

" }}}

" {{{ netrw: Configuration
"     ====================

let g:netrw_banner=0        " disable banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_winsize=25      " width of tree explorer
" hide gitignore'd files
let g:netrw_list_hide=netrw_gitignore#Hide()
" hide dotfiles by default (this is the string toggled by netrw-gh)
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" Opens netrw with vim
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

" }}}

" {{{ skeleton-config
"     ===============
autocmd BufNewFile README.md 0r ~/skeletons/README.md
autocmd BufNewFile readme.md 0r ~/skeletons/readme.md

autocmd BufNewFile *.sh 0r ~/skeletons/bash.sh

" {{{ undotree
"     ======

Plugin 'mbbill/undotree'

" OPTIONS:

set undodir=~/.vim/undodir
set undofile

" }}}

" {{{ vim-syntastic
"     ==========

Plugin 'vim-syntastic/syntastic'

" OPTIONS:

let g:syntastic_python_python_exec = 'python3'

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

" Modelines
set modelines=2
set modeline

" Colorscheme
colorscheme badwolf
set background=dark

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
set statusline=%!MyStatusLine()

" Session saving
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,localoptions

" Word splitting
set iskeyword+=-

" git grep
set grepprg=git\ grep\ -n\ $*         " Use git grep for searching

" }}}

" {{{ Autocommands

" Make the modification indicator [+] white on red background
au ColorScheme * hi User1 gui=bold term=bold cterm=bold guifg=white guibg=red ctermfg=white ctermbg=red

" Tweak the color of the fold display column
au ColorScheme * hi FoldColumn cterm=bold ctermbg=233 ctermfg=146

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

" }}}

" Key Mappings {{{

"split navigations
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Newlines
nnoremap <C-j> o<ESC>k
nnoremap <C-k> O<ESC>j

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

" Diff Mode
nnoremap <silent> ,j :if &diff \| exec 'normal ]czz' \| endif<CR>
nnoremap <silent> ,k :if &diff \| exec 'normal [czz' \| endif<CR>
nnoremap <silent> ,p :if &diff \| exec 'normal dp' \| endif<CR>
nnoremap <silent> ,o :if &diff \| exec 'normal do' \| endif<CR>
nnoremap <silent> ZD :if &diff \| exec ':qall' \| endif<CR>

" netrw
nnoremap <silent> <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

" }}}

" Custom Functions {{{

" MyStatusLine() {{{

function! MyStatusLine()
    let statusline = ""
    " Filename (F -> full, f -> relative)
    let statusline .= "%f"
    " Buffer flags
    let statusline .= "%( %h%1*%m%*%r%w%) "
    " File format and type
    let statusline .= "(%{&ff}%(\/%Y%))"
    " Left/right separator
    let statusline .= "%="
    " Line & column
    let statusline .= "(%l,%c%V) "
    " Character under cursor (decimal)
    let statusline .= "%03.3b "
    " Character under cursor (hexadecimal)
    let statusline .= "0x%02.2B "
    " File progress
    let statusline .= "| %P/%L"
    " Obsession vim-session
    for i in range(tabpagenr('$'))
        " select the highlighting
        if i + 1 == tabpagenr()
            let statusline .= '%#TabLineSel#'
        else
            let statusline .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let statusline .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let statusline .= ' %{MyTabLabel(' . (i + 1) . ')} '
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let statusline .= '%#TabLineFill#%T'

    let statusline .= '%=' " Right-align after this

    if exists('g:this_obsession')
        let statusline .= '%#diffadd#' " Use the "DiffAdd" color if in a session
    endif

    " add vim-obsession status if available
    if exists(':Obsession')
        let statusline .= "%{ObsessionStatus()}"
        if exists('v:this_session') && v:this_session != ''
            let s:obsession_string = v:this_session
            let s:obsession_parts = split(s:obsession_string, '/')
            let s:obsession_filename = s:obsession_parts[-1]
            let statusline .= ' ' . s:obsession_filename . ' '
            let statusline .= '%*' " Restore default color
        endif
    endif

    return statusline
endfunction

" }}}

" {{{ MyTabLine()

function MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return bufname(buflist[winnr - 1])
endfunction

" }}}
