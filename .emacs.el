;; helm
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-split-window-in-side-p t) ; open helm buffer inside current window

;; projectile
(require 'tramp)
; (setq projectile-completion-system 'helm)
; (helm-projectile-on)
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

;; python
(setq python-shell-interpreter "python3")

;; cedille
(require 'cedille-mode nil t)

;; scala
(when (require 'scala-mode nil t)
  (use-package scala-mode
    :interpreter
      ("scala" . scala-mode)))

;; sbt
(when (require 'sbt-mode nil t)
  (use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
  ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
  (setq sbt:program-options '("-Dsbt.supershell=false"))))

;; Enable nice rendering of diagnostics like compile errors.
(when (require 'flycheck nil t)
  (use-package flycheck
    :init (global-flycheck-mode)))

(when (require 'lsp-mode nil t)
  (use-package lsp-mode
    :hook
      ;; Optional - enable lsp-mode automatically in scala files
      (scala-mode . lsp)
      (lsp-mode . lsp-lens-mode)
    :config
      ;;(setq lsp-completion-provider :capf)
      (setq lsp-prefer-flymake nil)
      ;; Keyboard shortcut
      (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
      ;; Optional- tune lsp-mode performance according to
      ;; https://emacs-lsp.github.io/lsp-mode/page/performance/
      (setq gc-cons-threshold 100000000) ;; 100mb
      (setq read-process-output-max (* 1024 1024)) ;; 1mb
      (setq lsp-idle-delay 0.500)
      (setq lsp-log-io nil)))

(require 'lsp-metals nil t)

;; Enable nice rendering of documentation on hover
;;   Warning: on some systems this package can reduce your emacs responsiveness significally.
;;   (See: https://emacs-lsp.github.io/lsp-mode/page/performance/)
;;   In that case you have to not only disable this but also remove from the packages since
;;   lsp-mode can activate it automatically.
(require 'lsp-ui nil t)

;; lsp-mode supports snippets, but in order for them to work you need to use yasnippet
;; If you don't want to use snippets set lsp-enable-snippet to nil in your lsp-mode settings
;;   to avoid odd behavior with snippets and indentation
(require 'yasnippet nil t)

;; Add company-lsp backend for metals
;;
;; TODO: Replace company-lsp with actively maintained company-capf.
(when (require 'company-lsp nil t)
  (use-package company
    :hook (scala-mode . company-mode)))

;; debug adapter protocol
(when (require 'dap-mode nil t)
  (use-package dap-mode
    :hook
      (lsp-mode . dap-mode)
      (lsp-mode . dap-ui-mode)))

(require 'posframe nil t)

;; Use the Tree View Protocol for viewing the project structure and triggering compilation 
(when (require 'lsp-treemacs nil t)
  (use-package lsp-treemacs
    :config
    (setq lsp-metals-treeview-show-when-views-received t)))

;; haskell
(when (require 'haskell-interactive-mode nil t)
  (require 'haskell-process nil t)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode))

;; guix
(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path "~/code/guix/guix")
  (add-to-list 'geiser-guile-load-path "~/code/guix/free"))
(when (require 'yasnippet nil t)
  (with-eval-after-load 'yasnippet
    (add-to-list 'yas-snippet-dirs "~/code/guix/guix/etc/snippets"))
  (setq user-full-name "Stephen Webber")
  (setq user-mail-address "montokapro@gmail.com")
  (load-file "~/code/guix/guix/etc/copyright.el")
  (setq copyright-names-regexp
    (format "%s <%s>" user-full-name user-mail-address)))

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
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(expand-region avy multiple-cursors magit dimmer helm-projectile projectile browse-at-remote undo-tree cider helm-idris ensime auto-complete))
 '(safe-local-variable-values
   '((eval let
	   ((root-dir-unexpanded
	     (locate-dominating-file default-directory ".dir-locals.el")))
	   (when root-dir-unexpanded
	     (let*
		 ((root-dir
		   (expand-file-name root-dir-unexpanded))
		  (root-dir*
		   (directory-file-name root-dir)))
	       (unless
		   (boundp 'geiser-guile-load-path)
		 (defvar geiser-guile-load-path 'nil))
	       (make-local-variable 'geiser-guile-load-path)
	       (require 'cl-lib)
	       (cl-pushnew root-dir* geiser-guile-load-path :test #'string-equal))))
     (eval setq-local guix-directory
	   (locate-dominating-file default-directory ".dir-locals.el"))
     (encoding . utf-8)
     (eval let*
	   ((root-dir
	     (expand-file-name
	      (locate-dominating-file default-directory ".dir-locals.el")))
	    (root-dir*
	     (directory-file-name root-dir)))
	   (unless
	       (boundp 'geiser-guile-load-path)
	     (defvar geiser-guile-load-path 'nil))
	   (make-local-variable 'geiser-guile-load-path)
	   (require 'cl-lib)
	   (cl-pushnew root-dir* geiser-guile-load-path :test #'string-equal))
     (eval setq guix-directory
	   (locate-dominating-file default-directory ".dir-locals.el"))
     (eval modify-syntax-entry 43 "'")
     (eval modify-syntax-entry 36 "'")
     (eval modify-syntax-entry 126 "'")))
 '(sbt:program-name "~/.sdkman/candidates/sbt/current/bin/sbt"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
