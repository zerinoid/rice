"vimrc carai

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

set termguicolors

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
    Plug 'junegunn/vim-easy-align'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'kovetskiy/sxhkd-vim'
    Plug 'yuezk/vim-js'
    Plug 'maxmellon/vim-jsx-pretty'
    Plug 'jeffkreeftmeijer/vim-numbertoggle'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ghifarit53/tokyonight-vim'                      " Tokyo Night colorscheme
    Plug 'norcalli/nvim-colorizer.lua'                    " Colorize hex codes
    " Plug 'dylanaraps/wal.vim'
    " Plug 'jreybert/vimagit'
    " Plug 'jceb/vim-orgmode'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'VincentCordobes/vim-translate'

call plug#end()


" Tokyo Night
let g:tokyonight_style = 'storm' " available: night, storm
let g:tokyonight_enable_italic = 1 " available: 0, 1
let g:tokyonight_transparent_background = 1

" Set colorscheme
colorscheme tokyonight

" Lightline colorscheme
let g:lightline = {'colorscheme': 'tokyonight'}

" Required by Colorizer
lua require'colorizer'.setup()

" Variaveis
    let g:airline_powerline_fonts = 1
    let g:airline_theme='tokyonight'
    let g:airline#extensions#whitespace#enabled = 1

    let g:netrw_banner = 0
    let g:netrw_liststyle = 3
    let g:netrw_browse_split = 3
    let g:netrw_altv = 1
    let g:netrw_winsize = 15

" Basicos
    set go=a
    set mouse=a
    set clipboard+=unnamedplus
    set backspace=start
    set complete+=kspell

    set nocompatible
    filetype plugin on
    syntax on
    set encoding=utf-8

    set ruler
    set number
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
    nnoremap c "_c
    let mapleader=" "


" Enable autocompletion:
    set wildmode=longest,list,full

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

    " netrw
    nnoremap <leader>pt :Vex<CR>
    
    " translation
    nnoremap <silent> <leader>tt :Translate<CR>
    vnoremap <silent> <leader>tt :TranslateVisual<CR>
    vnoremap <silent> <leader>tr :TranslateReplace<CR>

    nmap <leader>ts <Plug>Translate
    nmap <leader>tr <Plug>TranslateReplace

" sei la
    packloadall
    silent! helptags ALL

    " colorscheme wal

" Disables automatic commenting on newline:
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
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
" Reload vimrc
    autocmd BufWritePost *init.vim :so $MYVIMRC

" Copiar css do solinvictus
    " autocmd BufWritePost solinvictus.css !cat % | xclip -selection clipboard

    autocmd BufWritePost branch !cat % | xargs echo -n | xclip -sel c; notify-send copiou %

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
