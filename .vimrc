"vimrc carai

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'kovetskiy/sxhkd-vim'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'jreybert/vimagit'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'dylanaraps/wal.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'jceb/vim-orgmode'

call plug#end()

let g:airline_powerline_fonts = 1
let g:airline_theme='dark'
let g:airline#extensions#whitespace#enabled = 1

set go=a
set mouse=a
set clipboard+=unnamedplus

set ruler
set visualbell
set showmatch
set showbreak=+
set laststatus=2
set autochdir

set hlsearch
set incsearch
set ignorecase
set smartcase
set showcmd

set tabstop=4 shiftwidth=4 expandtab
set autoindent

set langmap=Ç:,¨^,
let mapleader=" "

set number

"""" Luke
" Some basics:
    nnoremap c "_c
    set nocompatible
    filetype plugin on
    syntax on
    set encoding=utf-8

" Enable autocompletion:
    set wildmode=longest,list,full

" Disables automatic commenting on newline:
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Shortcutting split navigation, saving a keypress:
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l

    map <leader>s :!clear && shellcheck %<CR>

" Replace ex mode with gq
    map Q gq

" Replace all is aliased to S.
    nnoremap S :%s//g<Left><Left>

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
    set splitbelow splitright

"""" Shortcuts """"
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
map ç :FZF<CR>
map <leader>, :vsp<CR>
map <leader>. :sp<CR>
map <leader>fs :w<CR>
nnoremap <silent> <Leader>= :exe "vertical resize " . (winwidth(0) * 4/3)<CR>
nnoremap <silent> <Leader>- :exe "vertical resize " . (winwidth(0) * 3/4)<CR>

" Tabs
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt

nnoremap <leader>h  :tabfirst<CR>
nnoremap <leader>k  :tabnext<CR>
nnoremap <leader>j  :tabprev<CR>
nnoremap <leader>l  :tablast<CR>
nnoremap <leader>t  :tabedit<Space>
nnoremap <leader>n  :tabnew<CR>
nnoremap <leader>m  :tabm<Space>
nnoremap <leader>d  :tabclose<CR>

"powerline
" python3 from powerline.vim import setup as powerline_setup
" python3 powerline_setup()
" python3 del powerline_setup

packloadall
silent! helptags ALL

colorscheme wal

" Run xrdb whenever Xdefaults or Xresources are updated.
    autocmd BufWritePost *Xresources,*Xdefaults !xrdb %
" Update binds when sxhkdrc is updated.
    autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
" Update picom when picom.conf is updated.
    autocmd BufWritePost *picom.conf !pkill -SIGUSR1 -x picom
" Source bash aliases
    autocmd BufWritePost *bash_aliases !source %
" relaunchar xplugd a cada atualizaçao
    autocmd BufWritePost *xplugrc !xplugd

" Copiar css do solinvictus
    " autocmd BufWritePost solinvictus.css !cat % | xclip -selection clipboard

" Highlight fix no vimdiff
if &diff
"     highlight! link DiffText MatchParen
    set nornu
    syntax off
endif

hi DiffAdd      ctermfg=NONE          ctermbg=Green
hi DiffChange   ctermfg=NONE          ctermbg=NONE
hi DiffDelete   ctermfg=LightBlue     ctermbg=Red
hi DiffText     ctermfg=Yellow        ctermbg=Red

" mudar cursor por modo
let &t_SI = "\e[5 q"
let &t_EI = "\e[2 q"

" Optionally reset the cursor on start:
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END
