{ pkgs }:
''
  " Plugins
  call plug#begin('/home/dan4ik/.vim/plugged')
    Plug 'preservim/nerdtree'
    Plug 'ervandew/supertab'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'LnL7/vim-nix'
    Plug 'OmniSharp/omnisharp-vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'puremourning/vimspector'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'jiangmiao/auto-pairs'
    Plug 'dense-analysis/ale'
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'morhetz/gruvbox'
  call plug#end()

  " Settings
  syntax on
  set number
  set mouse=a
  set clipboard+=unnamedplus
  set background=dark
  set encoding=utf-8
  set nobackup       
  set nowritebackup  
  set noswapfile
  scriptencoding utf-8
  colorscheme gruvbox
  :set tabstop=4
  :set shiftwidth=4
  :set expandtab

  " Back to the place
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal! g`\"" |
  \ endif

  " NerdTree
  let g:NERDTreeDirArrowExpandable = '▸'
  let g:NERDTreeDirArrowCollapsible = '▾'
  let g:NERDTreeCustomOpenArgs={'file':{'where': 't'}}
  nnoremap <C-n> :NERDTree<CR>

  " AirLine
  let g:airline_powerline_fonts=1
  let g:airline_theme='minimalist'

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
  nnoremap <leader>vr :VimspectorReset<CR>
''
