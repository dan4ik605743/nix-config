{ pkgs, }:

{
  enable = true;
  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };
  theme = {
    name = "Adwaita-dark";
    package = pkgs.gnome3.gnome_themes_standard;
  };
  gtk3 = {
    extraCss = ''
      VteTerminal, vte-terminal {
      padding: 15px;
    }
    '';
    extraConfig = {
      gtk-cursor-theme-name = "Adwatia";
      gtk-cursor-theme-size = 0;
    };
  };
  gtk2.extraConfig = ''
    gtk-cursor-theme-name="Adwatia"
    gtk-cursor-theme-size=0
    '';
}
