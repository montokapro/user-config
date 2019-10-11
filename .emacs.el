;; package repos
(require 'package) 
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; helm
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-r") 'helm-mini)
(setq helm-split-window-in-side-p t) ; open helm buffer inside current window, not occupy whole other window
(setq projectile-completion-system 'helm)
(helm-projectile-on)

;; switch between windows with shift and arrows
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings 'meta))

;; intuitive undo
(global-undo-tree-mode)

;; auto-complete-mode
(ac-config-default)

;; highlight matching parenthesises
(show-paren-mode 1)

;; dim unfocused buffers
(dimmer-mode)
(setq dimmer-fraction 0.25)

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
(require 'browse-at-remote)

;; cedille
(require 'cedille-mode)

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
    (expand-region avy multiple-cursors magit dimmer helm-projectile projectile browse-at-remote undo-tree cider helm-idris ensime auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
