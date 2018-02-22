" Include the system settings
if !has('nvim')
  if filereadable( "/etc/vimrc" )
     source /etc/vimrc
  endif
endif

" Include Arista-specific settings
if filereadable( $VIM . "/vimfiles/arista.vim" )
  source $VIM/vimfiles/arista.vim
endif

map <PageUp> :bn<CR>
map <PageDown> :bp<CR>

let g:python_host_prog = '/usr/bin/python2'  " here if python --version show 3.0+ you should use let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

"    PLUGIN AREA    "
call plug#begin()

Plug 'shougo/neocomplete.vim'
Plug 'tpope/vim-fugitive'
Plug 'git://git.wincent.com/command-t.git'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'vim-scripts/dbext.vim'
Plug 'junegunn/vim-easy-align'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
let g:go_version_warning = 0 " For vim support

"+--- NerdTree ---+"
Plug 'scrooloose/nerdtree'
let g:NERDTreeDirArrowExpandable = '¬'
let g:NERDTreeDirArrowCollapsible = '¦'

"+--- Ctags ---+"
"Plugin 'xolox/vim-misc'
"Plugin 'xolox/vim-easytags'
"let g:easytags_async=1
"autocmd FileReadPre * exe ":UpdateTags"

"+--- Highligth word ---+"
Plug 'vasconcelloslf/vim-interestingwords'

"+--- Syntastic ---+"
Plug 'scrooloose/syntastic'
let g:syntastic_c_compiler='gcc' " Use clang instead of gcc
let g:syntastic_c_compiler_options = '-Wall -Wextra -pedantic -std=c99'
let g:syntastic_c_check_header=1 " Check headers in c
let g:syntastic_cpp_compiler = 'clang++' " Use clang++ instead of g++
let g:syntastic_cpp_compiler_options = '-Wall -Wextra -std=c++11'
let g:syntastic_cpp_check_header=1 " Check headers in c++
let g:syntastic_ocaml_use_ocamlc =0 "dd Use ocamlc instead of ocamlopt
let g:syntastic_c_include_dirs = [ '../includes', '../headers' , '../include' , 'includes', 'headers' , 'include' ]
let g:syntastic_c_remove_include_errors = 1
let g:syntastic_c_errorformat = '%f:%l:%c: %trror: qwedqwdqwdwqdqwdqwd %m'

""+--- Completion ---+"
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': 'python3 -m pip install --user --force-reinstall --no-cache-dir neovim' }
  " deoplete tab-complete
  inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
else
  if has('timers')
    Plug 'Shougo/deoplete.nvim',
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
endif
let g:deoplete#enable_at_startup = 1

"+--- Colorscheme ---+"
Plug 'spf13/vim-colors'
Plug 'jpo/vim-railscasts-theme'

"+--- Airline ---+"
if !has("nvim")
   Plug 'bling/vim-airline'
   set laststatus=2
   let g:Powerline_symbols = "fancy"
   let g:airline_powerline_fonts =1
   let g:airline#extensions#tabline#enabled = 1

"  unicode symbols
   if !exists('g:airline_symbols')
     let g:airline_symbols = {}
   endif
   let g:airline_left_sep = '»'
   let g:airline_right_sep = '«'
   let g:airline_right_sep = '<'
   let g:airline_left_sep = '>'
   let g:airline#extensions#tabline#left_sep = ' '
   let g:airline#extensions#tabline#left_alt_sep = '|'
   let g:airline_symbols.linenr = '␊'
   let g:airline_symbols.linenr = '␤'
   let g:airline_symbols.linenr = '¶'
   let g:airline_symbols.branch = 'Ξ'
   let g:airline_symbols.paste = 'ρ'
   let g:airline_symbols.paste = 'Þ'
   let g:airline_symbols.paste = '∥'
   let g:airline_symbols.whitespace = 'Ξ'
endif

" All of your Plugins must be added before the following line
call plug#end()

colorscheme railscasts
" colorscheme molokai
" colorscheme peaksea
" colorscheme ir_black
"syntax on

"+--------More Stuff--------+"

highlight ColorColumn ctermbg=black guibg=black

function! GotoDefinition()
    let n = search("\\<".expand("<cword>")."\\>[^(]*([^)]*)\\s*\\n*\\s*{")
endfunction
map <F4> :call GotoDefinition()<CR>
imap <F4> <c-o>:call GotoDefinition()<CR>

map <C-e> :NERDTreeToggle<CR>
map <C-k> :call InterestingWords('n')<cr>
map <C-l> :call UncolorAllWords()<cr>
map <C-x> :bd <cr>
" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

command! Open !a4 open $(pwd)/%
command! -nargs=1 Branchpackage call system('a4 project branchpackage ' . <q-args>)
