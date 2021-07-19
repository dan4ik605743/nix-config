''
  (doom! :completion
         (company +childframe)
         (ivy +fuzzy +prescient +childframe +icons)

         :ui
         (emoji +ascii +github +unicode)
         (popup +defaults +all)
         (window-select +numbers)
         doom
         doom-dashboard
         doom-quit
         hl-todo
         modeline
         ophints
         treemacs
         vc-gutter
         vi-tilde-fringe
         workspaces
         zen

         :editor
         (evil +everywhere)
         file-templates
         fold
         snippets

         :emacs
         dired
         electric
         undo
         vc

         :term
         eshell
         shell
         term

         :checkers
         syntax

         :tools
         (eval +overlay)
         lookup
         lsp
         magit
         rgb

         :os
         tty

         :lang
         (cc +lsp)
         (json +lsp)
         (javascript +lsp)
         (lua +lsp)
         (python +lsp)
         (web +lsp)
         common-lisp
         emacs-lisp
         markdown
         nix
         org     
         qt
         sh

         :config
         (default +bindings +smartparens))
''
