" Pathogen stuff
execute pathogen#infect()
syntax on
filetype plugin indent on

" Solarized stuff
set background=light
colorscheme solarized

" Some stuff taken from http://mislav.uniqpath.com/2011/12/vim-revisited/
set tabstop=4 shiftwidth=4      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" Also needed for 4-space tabs
au FileType python setlocal shiftwidth=4 softtabstop=4 expandtab

" Automatically remove trailing whitespace on save
" taken from
" http://stackoverflow.com/questions/356126/how-can-you-automatically-remove-trailing-whitespace-in-vim
autocmd BufWritePre * :%s/\s\+$//e

" Clear highlighting on escape in normal mode
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[

" Show ruler (current row/column of cursor)
set ruler

" .sls files are YAML
au BufNewFile,BufRead *.sls set filetype=yaml

" no swap files; they're more trouble than they're worth
set noswapfile

" Provide a different mapping for visual block mode, because Ctrl+V is used for paste on Linux.
" Normally Ctrl+B scrolls up by one page, but this can also be achieved with <PageUp>
nnoremap <C-B> <C-V>
" Also map <C-V> to no-op to help me break the habit of using it.
nnoremap <C-V> <Nop>
