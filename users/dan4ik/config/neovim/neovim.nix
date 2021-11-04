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
    Plug 'puremourning/vimspector'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'jiangmiao/auto-pairs'
    Plug 'dense-analysis/ale'
    Plug 'preservim/tagbar'
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'arcticicestudio/nord-vim'
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
  set number
  set mouse=a
  set clipboard+=unnamedplus
  set encoding=utf-8
  set nobackup       
  set nowritebackup  
  set noswapfile
  set autochdir
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

  " AirLine
  let g:airline_powerline_fonts=1
  let g:airline_theme='nord'

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
''
