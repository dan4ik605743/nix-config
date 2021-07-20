''
  ;; Settings
  (setq 
    doom-theme 'doom-gruvbox
    doom-themes-enable-bold t
    doom-themes-enable-italic t
    doom-themes-treemacs-theme "doom-colors"
    doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 12)
    doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 12)
    doom-modeline-buffer-encoding t
    doom-modeline-major-mode-icon t
    doom-modeline-enable-word-count nil
    doom-modeline-height 20
  )

  ;; Bindings
  (map! :i "C-c C-c" #'company-dabbrev)
  (map! "C-c C-z" #'treemacs-display-current-project-exclusively)

  ;; Other Settings
  (xterm-mouse-mode 1)
  (add-hook! 'doom-load-theme-hook
             :append
             (defun my/init-extra-fonts-h(&optional frame)
               (with-selected-frame (or frame (selected-frame))
                 (set-fontset-font t 'symbol "JetBrainsMono Nerd Font Mono" nil)
                 (set-fontset-font t 'symbol "Noto Color Emoji" nil 'append))))
  (custom-set-faces!
    '(mode-line :family "Iosevka FT Extended" :height 90)
    '(mode-line-inactive :family "Iosevka FT Extended" :height 90)
    '(doom-dashboard-menu-title :foreground "#458588")
    '(org-document-title :height 100)
  )

  ;; Projectile
  (projectile-add-known-project "~/pkgs/")
  (projectile-add-known-project "~/test/")
  (projectile-add-known-project "~/nur/")
  (projectile-add-known-project "~/nix-config/")
  (projectile-add-known-project "~/nixpkgs/")
  (projectile-add-known-project "~/Documents/code/")
  (projectile-add-known-project "/etc/nixos")

  ;; Rainbow mode
  (add-hook 'text-mode-hook 'rainbow-mode)
  (add-hook 'prog-mode-hook 'rainbow-mode)

  ;; Centaur-tabs
  (use-package! centaur-tabs
  :hook (doom-first-file . centaur-tabs-mode)
  :init
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-gray-out-icons 'buffer)
  (setq centaur-tabs-style "chamfer")
  (setq centaur-tabs-set-bar 'under)
  (setq x-underline-at-descent-line t)
  (setq centaur-tabs-set-modified-marker t)
  (setq centaur-tabs-modified-marker "•")
  (setq centaur-tabs-close-button "")
  (setq centaur-tabs-cycle-scope 'tabs)
  :config
  (add-hook '+doom-dashboard-mode-hook #'centaur-tabs-local-mode)
  (add-hook '+popup-buffer-mode-hook #'centaur-tabs-local-mode)
  (centaur-tabs-change-fonts "Iosevka FT Extended" 90)
  (centaur-tabs-group-by-projectile-project)
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-set-modified-marker t)
  (setq centaur-tabs-set-bar 'under)
  (setq x-underline-at-descent-line t)
  (setq centaur-tabs-height 20)
  (centaur-tabs-mode t)
  (centaur-tabs-headline-match)
  :bind
  (:map evil-normal-state-map
   ("g t" . centaur-tabs-forward)
   ("g T" . centaur-tabs-backward)
   ("C-c C-d" . centaur-tabs--kill-this-buffer-dont-ask))
  )

  ;; Treemacs
  (custom-set-faces!
  '(treemacs-root-face :family "Iosevka FT Extended" :height 90)
  '(treemacs-git-unmodified-face :family "Iosevka FT Extended" :height 90)
  '(treemacs-git-modified-face :family "Iosevka FT Extended" :height 90)
  '(treemacs-git-renamed-face :family "Iosevka FT Extended" :height 90)
  '(treemacs-git-ignored-face :family "Iosevka FT Extended" :height 90)
  '(treemacs-git-untracked-face :family "Iosevka FT Extended" :height 90)
  '(treemacs-git-added-face :family "Iosevka FT Extended" :height 90)
  '(treemacs-git-conflict-face :family "Iosevka FT Extended" :height 90)
  '(treemacs-directory-face :family "Iosevka FT Extended" :height 90)
  '(treemacs-directory-collapsed-face :family "Iosevka FT Extended" :height 90)
  '(treemacs-file-face :family "Iosevka FT Extended" :height 90)
  '(treemacs-tags-face :family "Iosevka FT Extended" :height 90)
  )
''
