(menu-bar-mode -1)
(set-scroll-bar-mode 'right)
(tool-bar-mode -1)
(blink-cursor-mode -1)

(column-number-mode 1)
(indent-according-to-mode)
(display-time)

(ido-mode 1)
;; Don't jump to a different directory when creating a new file, or mistyping a filename.
(setq ido-auto-merge-work-directories-length -1)

;; Initialize package.el
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Load use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t) ; Ensure all packages are installed by default

(use-package smex
  :ensure t)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package quick-peek
  :ensure t)

(use-package flycheck-inline
  :ensure t)

(use-package lsp-mode
  :ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(spacemacs-dark))
 '(custom-safe-themes
   '("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(fancy-splash-image "~/emacs-butterfly.svg")
 '(package-selected-packages
   '(quick-peek spacemacs-theme flycheck-inline lsp-mode use-package flycheck smex)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(flycheck-inline-error ((t (:foreground "Red1" :weight extrabold))))
;; '(flycheck-inline-info ((t (:foreground "SeaGreen2"))))
;; '(flycheck-inline-warning ((t (:foreground "Yellow"))))
;; '(font-lock-comment-delimiter-face ((t (:foreground "peru"))))
;; '(font-lock-comment-face ((t (:foreground "peru"))))
;; '(font-lock-keyword-face ((t (:foreground "light sea green"))))
;; '(font-lock-preprocessor-face ((t (:foreground "CornFlowerBlue"))))
;; '(font-lock-type-face ((t (:foreground "SteelBlue1"))))
;; '(isearch ((t (:foreground "white" :background "#2f822f" :weight bold))))
;; '(lazy-highlight ((t (:foreground "#8ae4f2" :background "#004065"))))
;; '(mode-line ((t (:box (:line-width 1 :color "red")))))
 ;; '(show-paren-mismatch ((t (:background "DarkRed"))))
 )

(with-eval-after-load 'flycheck
  (add-hook 'flycheck-mode-hook #'flycheck-inline-mode)
  (with-eval-after-load 'quick-peek
    (setq flycheck-inline-display-function
	  (lambda (msg pos err)
            (let* ((ov (quick-peek-overlay-ensure-at pos))
		   (contents (quick-peek-overlay-contents ov)))
              (setf (quick-peek-overlay-contents ov)
                    (concat contents (when contents "\n") msg))
              (quick-peek-update ov)))
	  flycheck-inline-clear-function #'quick-peek-hide)))

(global-set-key (kbd "C-x p") 'flycheck-previous-error)
(global-set-key (kbd "C-x n") 'flycheck-next-error)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-x C-e") 'compile)
(global-set-key (kbd "C-x '") 'next-error)
(global-set-key (kbd "C-x \"") 'previous-error)
(global-set-key (kbd "C-x O") (lambda () (interactive) (other-window -1)))

(setq explicit-shell-file-name "/bin/bash")
(setenv "Pager" "/bin/cat")
(setenv "LFS" "/mnt/lfs")
(server-start)
(setenv "EDITOR" "emacsclient")

;; Deeper-blue nice color is goldenrod
