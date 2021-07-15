''
  ;; Settings
  (setq 
    doom-theme 'doom-sourcerer
    doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 12)
    doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 12)
    doom-modeline-buffer-encoding t
    display-line-numbers-type t
  )

  ;; Bindings
  (map! :i "C-c C-c" #'company-dabbrev)
  (map! "C-c C-z" #'treemacs)

  ;; Other Settings
  (xterm-mouse-mode 1)
  (projectile-add-known-project "~/pkgs/")
  (projectile-add-known-project "~/test/")
  (projectile-add-known-project "~/nur/")
  (projectile-add-known-project "~/nix-config/")
  (projectile-add-known-project "~/Documents/code/")
  (projectile-add-known-project "/etc/nixos")
  (add-hook 'text-mode-hook 'rainbow-mode)
  (add-hook 'prog-mode-hook 'rainbow-mode)
''
