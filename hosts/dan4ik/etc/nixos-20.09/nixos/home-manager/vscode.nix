{ pkgs, unstable, }:

{
  enable = true;
  package = unstable.vscode;
  extensions = with unstable.vscode-extensions;
  [
    ms-vscode.cpptools
    bbenoist.Nix
    pkief.material-icon-theme
  ]++ pkgs.vscode-utils.extensionsFromVscodeMarketplace 
  [
    {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "0.1.2";
      sha256 = "1n5ilw1k29km9b0yzfd32m8gvwa2xhh6156d4dys6l8sbfpp2cv9";
    }
    {
      name = "theme-monokai-pro-vscode";
      publisher = "monokai";
      version = "1.1.19";
      sha256 = "0skzydg68bkwwwfnn2cwybpmv82wmfkbv66f54vl51a0hifv3845";
    }
];
  userSettings = {
    "update.channel" = "none";
    "telemetry.enableTelemetry" = "false";
    "telemetry.enableCrashReporter" =  "false";
    "terminal.integrated.shell.linux" = "${pkgs.zsh}/bin/zsh";
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.colorTheme" = "Monokai Pro (Filter Ristretto)";
    "editor.fontFamily" = "Iosevka";
    "editor.fontLigatures" = "true";
    "editor.fontSize" = 16;
  };
}
