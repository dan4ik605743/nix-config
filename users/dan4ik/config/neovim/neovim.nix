{ pkgs }:

''
  " Plugins
  call plug#begin('/home/dan4ik/.vim/plugged')
    Plug 'preservim/nerdtree'
    Plug 'ervandew/supertab'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'LnL7/vim-nix'
    Plug 'OmniSharp/omnisharp-vim'
    Plug 'itchyny/lightline.vim'
    Plug 'puremourning/vimspector'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'jiangmiao/auto-pairs'
    Plug 'dense-analysis/ale'
    Plug 'maximbaz/lightline-ale'
    Plug 'preservim/tagbar'
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'arcticicestudio/nord-vim'
    Plug 'ap/vim-css-color'
    Plug 'plasticboy/vim-markdown'
    Plug 'mhinz/vim-startify'
  call plug#end()

  " Theme
  colorscheme nord
  set background=dark
  let g:nord_uniform_diff_background = 1
  let g:nord_cursor_line_number_background = 1
  let g:nord_uniform_status_lines = 1
  let g:nord_italic = 1
  let g:nord_italic_comments = 1
  let g:nord_underline = 1

  " Settings
  set relativenumber
  set mouse=a
  set clipboard+=unnamedplus
  set encoding=utf-8
  set nobackup       
  set nowritebackup  
  set noswapfile
  set autochdir
  set showtabline=2
  scriptencoding utf-8
  syntax on
  :set tabstop=4
  :set shiftwidth=4
  :set expandtab

  " Back to the place
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal! g`\"" |
  \ endif
  
  " Clear last search highlighting
  nnoremap <Leader><Esc> :noh<Return><Esc>

  " NerdTree
  let g:NERDTreeDirArrowExpandable = '▸'
  let g:NERDTreeDirArrowCollapsible = '▾'
  let g:NERDTreeCustomOpenArgs={'file':{'where': 't'}}
  let NERDTreeChDirMode=2
  nnoremap <C-x> :NERDTreeToggle .<CR>

  " LightLine
  let g:lightline = {
  \ 'colorscheme': 'nord',
  \ 'active': {
  \   'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
  \              [ 'lineinfo' ],
  \              [ 'fileformat', 'fileencoding', 'filetype'] ]
  \ },
  \ 'tabline': {
  \   'left': [ ['tabs'] ],
  \   'right': [ ['close'] ]
  \ },
  \ 'separator': {
  \   'left': '', 'right': ''
  \ },
  \ 'subseparator': {
  \   'left': '', 'right': '' 
  \ },
  \ 'component_expand':{
  \  'linter_checking': 'lightline#ale#checking',
  \  'linter_infos': 'lightline#ale#infos',
  \  'linter_warnings': 'lightline#ale#warnings',
  \  'linter_errors': 'lightline#ale#errors',
  \  'linter_ok': 'lightline#ale#ok',
  \ },
  \ 'component_type':{
  \  'linter_checking': 'right',
  \  'linter_infos': 'right',
  \  'linter_warnings': 'warning',
  \  'linter_errors': 'error',
  \  'linter_ok': 'right',
  \ },
  \ } 

  " OmniSharp
  let g:OmniSharp_server_path = '${pkgs.omnisharp-roslyn}/bin/omnisharp'
  autocmd FileType cs nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>

  " Fzf
  nnoremap <C-f> :Files<CR>
  let g:fzf_preview_window = 'right:60%'

  " SuperTab
  let g:SuperTabMappingForward = '<S-Tab>'
  let g:SuperTabMappingBackward = '<Tab>'

  " Ale
  let g:ale_linters = {
  \ 'cs': ['OmniSharp']
  \}

  let g:ale_linters = {
  \ 'nix': ['rnix-lsp']
  \}

  " VimSpector
  let g:vimspector_enable_mappings = 'HUMAN'
  nnoremap <Leader>vr :VimspectorReset<CR>

  " Tagbar 
  let g:tagbar_ctags_bin = '${pkgs.ctags}/bin/ctags'
  nnoremap <Leader>tt :TagbarToggle<CR> 

  " Startify
  let g:startify_files_number = 5
  let g:startify_update_oldfiles = 1
  let g:startify_change_to_vcs_root = 0
  let g:startify_padding_left = 4
  let g:startify_session_autoload = 0

  let g:startify_lists = [
  \ { 'type': 'bookmarks', 'header': ['   Bookmars:']      },
  \ { 'type': 'files',     'header': ['   Recents:']            },
  \ { 'type': 'dir',       'header': ['   Current: '. getcwd()] },
  \ ]

  let g:startify_bookmarks = [
  \ { 'f': '/etc/nixos/flake.nix' },
  \ { 'c': '/etc/nixos/hosts/ggwp/configuration.nix' },
  \ { 'h': '/etc/nixos/users/dan4ik/default.nix' },
  \ { 'v': '/etc/nixos/users/dan4ik/config/neovim/neovim.nix' },
  \ { 'n': '/etc/nixos/config/nix.nix' },
  \ ]

  let g:startify_custom_header = [ "", 
  \ "",
  \ "     ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
  \ "     ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
  \ "     ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
  \ "     ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
  \ "     ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
  \ "     ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
  \ "",
  \ ]
''
