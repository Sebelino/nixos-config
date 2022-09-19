set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath

colorscheme wombat-sebelino

" Settings that should pretty much always be enabled
set nocompatible
syntax on
filetype plugin indent on

" Line numbers
set number

" Keep cursor centered
set scrolloff=999

" Toggle search highlighting
map  <F12> :set hls!<CR>
imap <F12> <ESC>:set hls!<CR>a
vmap <F12> <ESC>:set hls!<CR>gv

" Shortcut for :qa and :w
nnoremap <silent><C-y> :qa<CR>
nnoremap <silent><C-s> :w<CR>

" Upon reopening a file, jump to the position held at the end of the previous session
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Toggle text wrapping with F11
map <F11> :set wrap!<CR>

" Upon pressing Tab, put spaces instead of the tab character
set expandtab

" Use 4 spaces for tabs
set tabstop=4 shiftwidth=4 softtabstop=4

" vim-gitgutter
set updatetime=100  " How often to update markers to the left
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

set backup
set backupdir=~/.vim/backup/

set writebackup
set backupcopy=yes
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

" Save-alias
command W w
command Q q

" vim-terraform
nnoremap <A-l> :TerraformFmt<CR>

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" vim-plug is installed at ~/.local/share/nvim/site/autoload/plug.vim
" After updating this list, run :PlugInstall
call plug#begin()
Plug 'hashivim/vim-terraform'
Plug 'LnL7/vim-nix'
Plug 'airblade/vim-gitgutter'
Plug 'preservim/vim-markdown'
call plug#end()
