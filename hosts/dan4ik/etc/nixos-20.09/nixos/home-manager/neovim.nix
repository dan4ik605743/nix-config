{ pkgs, }:

{
  enable = true;
  withNodeJs = true;
  withPython = true;
  withPython3 = true;
  withRuby = true;
  vimAlias = false;
  viAlias = false;
  configure = {
  customRC = ''
    let color0  = "#0A0D0E"
    let color1  = "#854041"
    let color2  = "#9F5261"
    let color3  = "#DA6271"
    let color4  = "#FA837E"
    let color5  = "#BA6482"
    let color6  = "#E1728D"
    let color7  = "#f4c1c7"
    let color8  = "#aa878b"
    let color9  = "#854041"
    let color10 = "#9F5261"
    let color11 = "#DA6271"
    let color12 = "#FA837E"
    let color13 = "#BA6482"
    let color14 = "#E1728D"
    let color15 = "#f4c1c7"
    let g:NERDTreeDirArrowExpandable = '▸'
    let g:NERDTreeDirArrowCollapsible = '▾'
    let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ }
    syntax on
    set number
    set mouse=a
    nnoremap <C-n> :NERDTree<CR>
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \ exe "normal! g`\"" |
    \ endif
    '';
    plug.plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-closetag
      vim-go
      lightline-vim
      wombat256-vim
      coc-nvim
      nerdtree
    ];
  };
}
