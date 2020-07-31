;; helm
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-split-window-in-side-p t) ; open helm buffer inside current window

;; projectile
(require 'tramp)
(setq projectile-completion-system 'helm)
(helm-projectile-on)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; switch between windows with shift and arrows
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings 'meta))

;; intuitive undo
(global-undo-tree-mode)

;; auto-complete-mode
(ac-config-default)

;; highlight matching parenthesises
(show-paren-mode 1)

;; highlight long lines
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

;; show column number in status bar
(setq column-number-mode t)

;; dim unfocused buffers
(when (require 'dimmer nil t)
  (dimmer-mode)
  (setq dimmer-fraction 0.325))

;; move backup files
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; remember recent files
(recentf-mode 1)
(setq recentf-max-menu-items 25)
;; (global-set-key (kbd "C-x C-r") 'recentf-open-files)

;; reload externally modified files
(global-auto-revert-mode t)

;; link to github
(require 'browse-at-remote nil t)

;; structural editing
(require 'smartparens-config nil t)

;; cedille
(require 'cedille-mode nil t)

;; scala
(when (require 'sbt-mode nil t)
  (use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)))

;; sbt
(when (require 'scala-mode nil t)
  (use-package scala-mode
    :mode "\\.s\\(cala\\|bt\\)$"))

;; Enable nice rendering of diagnostics like compile errors.
(when (require 'flycheck nil t)
  (use-package flycheck
    :init (global-flycheck-mode)))

(when (require 'lsp-mode nil t)
  (use-package lsp-mode
    ;; Optional - enable lsp-mode automatically in scala files
    :hook  (scala-mode . lsp)
    (lsp-mode . lsp-lens-mode)
    :config (setq lsp-prefer-flymake nil)))

;; Enable nice rendering of documentation on hover
(require 'lsp-ui nil t)

;; lsp-mode supports snippets, but in order for them to work you need to use yasnippet
;; If you don't want to use snippets set lsp-enable-snippet to nil in your lsp-mode settings
;;   to avoid odd behavior with snippets and indentation
(require 'yasnippet nil t)

;; Add company-lsp backend for metals
(require 'company-lsp nil t)

;; Use the Tree View Protocol for viewing the project structure and triggering compilation 
(when (require 'lsp-treemacs nil t)
  (use-package lsp-treemacs
    :config
    (lsp-metals-treeview-enable t)
    (setq lsp-metals-treeview-show-when-views-received t)))

;; guix
(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path "~/code/guix/guix"))
(when (require 'yasnippet nil t)
  (with-eval-after-load 'yasnippet
    (add-to-list 'yas-snippet-dirs "~/code/guix/guix/etc/snippets"))
  (setq user-full-name "Stephen Webber")
  (setq user-mail-address "montokapro@gmail.com")
  (load-file "~/code/guix/guix/etc/copyright.el"))

(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(defun copy-relative-path ()
  "Copy relative path to clipboard"
  (interactive)
  (kill-new (file-relative-name buffer-file-name (projectile-project-root))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (expand-region avy multiple-cursors magit dimmer helm-projectile projectile browse-at-remote undo-tree cider helm-idris ensime auto-complete)))
 '(safe-local-variable-values
   (quote
    ((eval modify-syntax-entry 43 "'")
     (eval modify-syntax-entry 36 "'")
     (eval modify-syntax-entry 126 "'"))))
 '(sbt:program-name "~/.sdkman/candidates/sbt/current/bin/sbt"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
