''
  (doom! :completion
         company
         ivy

         :ui
         doom
         doom-dashboard
         doom-quit
         (emoji +ascii +github +unicode)
         hl-todo
         modeline
         ophints
         (popup +defaults +all)
         treemacs
         vc-gutter
         vi-tilde-fringe
         (window-select +numbers)
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
         common-lisp
         emacs-lisp
         (haskell +lsp +dante)
         (json +lsp)
         (javascript +lsp)
         (lua +lsp)
         markdown
         nix
         org     
         (python +lsp)
         qt
         sh

         :config
         (default +bindings +smartparens))
''
