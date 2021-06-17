 { ... }:

 {
   enable = true;
   searchEngines = { DEFAULT = "https://google.com/search?q={}"; };
   settings = { 
     url.start_pages = [ "https://vk.com" ];
     qt.args = [ "enable-native-gpu-memory-buffers" "enable-gpu-rasterization" "use-gl=egl" "ignore-gpu-blacklist" "num-raster-threads=4" ];
   };
   extraConfig = ''
     c.auto_save.session = True
     c.fonts.default_family = "JetBrainsMono Nerd Font Mono Bold"
     c.fonts.default_size = "14px"
     c.colors.webpage.darkmode.enabled = True
     c.colors.webpage.darkmode.policy.images = "never"
     config.source('base16-pinky.config.py')
     '';
}
