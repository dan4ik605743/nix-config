''
  " Settings
  syntax on
  set number
  set mouse=a
  set clipboard=unnamed
  set background=dark
  colorscheme gruvbox

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

  " LightLine
  let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ }

  " Clap
  nnoremap <C-f> :Clap filer<CR>
''
