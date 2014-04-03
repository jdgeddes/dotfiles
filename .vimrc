" Vim configuration file

" DEFAULT OPTIONS
set nocompatible			" make Vim default to nicer options

" READING OPTIONS
"set modeline modelines=1		" use settings from file being edited

" INPUT OPTIONS
set mouse=a				" use the mouse

" DISPLAY OPTIONS
set background=light			" better colors for white terminals
set number				" show line numbers
set ruler				" show line and column information
set backspace=2				" backspaces can go over lines
set tabstop=4				" tabs are every 8 columns
set softtabstop=4
set shiftwidth=4

":if version >= 600
"  set listchars=eol:$,tab:>-,trail:-,extends:>,precedes:<
":elseif version >= 500
"  set listchars=eol:$,tab:>-,trail:-,extends:+
":endif
set laststatus=2			" always show status line
set showmode				" always show command or insert mode
set shortmess=lnrxI			" brief messages, don't show intro
set showcmd				" show partial commands
set more				" use a pager for long listings
set nowrap				" do not wrap long lines
syntax on				" use syntax highlighting

" SAVING OPTIONS
set expandtab				" don't change tabs into spaces
set backupext=~				" backup files end in ~

" EDITING OPTIONS
filetype plugin indent on
"autocmd BufRead *.cpp,*.c,*.C,*.CPP,*.h,*.H set cindent
"set cindent				" keep indenting at same level
set noerrorbells visualbell		" flash screen instead of ringing bell
set esckeys				" allow arrow keys in insert mode
set showmatch				" show matching brackets

" SEARCH OPTIONS
set nohlsearch				" don't highlight search patterns
set incsearch				" search while typing
set ignorecase				" make searches case-insensitive

" MISCELLANEOUS OPTIONS
set dictionary=/usr/share/dict/words	" get words from system dictionary
set magic				" regexp chars have special meaning


if !has("gui_running")
    set t_Co=8
    set t_Sf=[3%p1%dm
    set t_Sb=[4%p1%dm
endif

if has("gui_running")
    color codeschool
endif

set nocp
filetype plugin on
set ofu=syntaxcomplete#Complete

" build tags of your own project with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p1 --fields=+iaS --extra=+q .<CR>
"
 " OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

cmap w!! %!sudo tee > /dev/null %

"let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
"highlight Pmenu guibg=brown gui=bold
" source /home/john/.vim/macros/gdb_mappings.vim

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

let g:easytags_updatetime_min = 4000
let g:easytags_dynamic_files = 2

let Tlist_Ctags_Cmd='/usr/bin/ctags'

map T :TaskList<CR>
map Q :TlistToggle<CR>
map S :NERDTreeToggle<CR>
imap <Leader>sp <C-o>:setlocal spell! spelllang=en_gb<CR>
nmap <Leader>sp :setlocal spell! spelllang=en_gb<CR>
nmap <F5> :w<cr>:make<cr>

map <C-S-Tab> :bp<cr>
map <C-Tab> :bn<cr>

" Store the bookmarks file
let NERDTreeBookmarksFile=expand("$HOME/.vim/NERDTreeBookmarks")
"
" Don't display these kinds of files
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$',
            \ '\.o$', '\.so$', '\.egg$', '^\.git$' ]

let NERDTreeShowBookmarks=1       " Show the bookmarks table on startup
let NERDTreeShowFiles=1           " Show hidden files, too
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1          " Quit on opening files from the tree
let NERDTreeHighlightCursorline=1 " Highlight the selected entry in the tree
let NERDTreeMouseMode=2           " Use a single click to fold/unfold directories and a double click to open files

set tags+=~/.vim/tags/include
set tags+=~/.vim/tags/glib
set tags+=./tags
"set tags+=~/.vim/tags/gtk
"set tags+=~/.vim/tags/pcap
"set tags+=~/.vim/tags/pango
"set tags+=~/.vim/tags/libnet
"set tags+=~/.vim/tags/sys
"set tags+=./tags

nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>

"autocmd FileType python set omnifunc=pythoncomplete#Complete

