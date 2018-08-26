function! s:crystal_expand(file, pos)
  let l:cmd = printf('crystal tool expand --no-color -c %s:%d:%d %s', a:file, a:pos[1], a:pos[2], a:file)
  return system(l:cmd)
endfunction

function! InstallLSP(info)
  if a:info.status == 'installed' || a:info.force
    !./install.sh
    !sudo npm install -g
      \ javascript-typescript-langserver
      \ flow-language-server
      \ vue-language-server
      \ vscode-css-languageserver-bin
      \ vscode-html-languageserver-bin
      \ vscode-json-languageserver-bin
      \ dockerfile-language-server-nodejs
  endif
  !sudo npm update -g
    \ javascript-typescript-langserver
    \ flow-language-server
    \ vue-language-server
    \ vscode-css-languageserver-bin
    \ vscode-html-languageserver-bin
    \ vscode-json-languageserver-bin
    \ dockerfile-language-server-nodejs
endfunction

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

"NERDTree
Plug 'scrooloose/nerdtree'

"Syntastic
"Plug 'vim-syntastic/syntastic'

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

"Airline status bar
Plug 'vim-airline/vim-airline'

"Polyglot syntax highlighting for multiple languages
Plug 'sheerun/vim-polyglot'

"Deoplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/context_filetype.vim'

"LanguageClient for Vim
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Multi-entry selection UI fuzzy search.
Plug 'junegunn/fzf'

" Whitespace cleaner
Plug 'bronson/vim-trailing-whitespace'

" Surround
"Plug 'tpope/vim-surround'

" Vue
Plug 'posva/vim-vue'

" Ruby endings
Plug 'tpope/vim-endwise'

" Initialize plugin system
call plug#end()

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" <TAB>: completion.
inoremap <expr> <TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

highlight Pmenu ctermbg=8 guibg=#555555
highlight PmenuSel ctermbg=1 guifg=#dddd00 guibg=#1f82cd
highlight PmenuSbar ctermbg=0 guibg=#111111

let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('auto_complete_delay', 500)

" Required for operations modifying multiple buffers like rename.
set hidden

" Automatically start language servers.
let g:LanguageClient_autoStart = 1
let g:LanguageClient_setLoggingLevel = 'DEBUG'
let g:LanguageClient_serverCommands = {
    \ 'vue': ['vls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'html': ['html-languageserver', '--stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'css': ['css-languageserver', '--stdio'],
    \ 'scss': ['css-languageserver', '--stdio'],
    \ 'less': ['css-languageserver', '--stdio'],
    \ 'json': ['json-languageserver', '--stdio'],
    \ 'Dockerfile': ['docker-langserver', '--stdio']
    \ }
let g:LanguageClient_diagnosticsEnable = 1 " enable gutter, highlight and quickfix list
set completefunc=LanguageClient#complete

" keybindings for language client
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
nnoremap <silent> gf :call LanguageClient_textDocument_codeAction()<CR>

let g:vue_disable_pre_processors=1
autocmd FileType vue syntax sync fromstart

command! -buffer -nargs=0 CrystalExpand echo s:crystal_expand(expand('%'), getpos('.'))

:au BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif

"syntax
syntax on

"Let vim manage the filetypes and call out the FileType event
filetype plugin indent on

set number
set ruler
set backspace=indent,eol,start

" Set Whitespace chars
set list
set listchars=trail:·,precedes:«,extends:»,tab:▸\ 
"eol:↲,

"use ripgrep over grep
set grepprg=rg\ --vimgrep

" Search
set hlsearch "highlighter
set incsearch
set ignorecase "caseinsensitive search
set smartcase "unless one capital

set expandtab "On pressing tab, insert 2 spaces
set tabstop=2 " show existing tab with 2 spaces width
set softtabstop=2
set shiftwidth=2 " when indenting with '>', use 2 spaces width

