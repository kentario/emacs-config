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

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(deeper-blue))
 '(package-selected-packages '(smex))
 ;; Some more nice splash images: https://github.com/tecosaur/emacs-config/tree/master/misc/splash-images
 '(fancy-splash-image "home/ken/emacs-butterfly.pbm")
 )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:foreground "peru")))) ; comments
 '(font-lock-comment-delimiter-face ((t (:foreground "peru")))) ;, //, /**/, #
 '(font-lock-preprocessor-face ((t (:foreground "CornFlowerBlue")))) ;#include, #define
 '(font-lock-type-face ((t (:foreground "SteelBlue1")))) ; variable type int, char
 '(font-lock-keyword-face ((t (:foreground "light sea green")))) ; If, template, auto, const, for, break
 '(mode-line ((t (:box (:line-width 1 :color "red"))))) ; The that separates windows.
 '(show-paren-mismatch ((t (:background "DarkRed")))) ; Highlighting for whne parenthesis don't match ())
 '(lazy-highlight ((t (:foreground "#8ae4f2" :background "#004065")))) ; One is is for highlighting matches that aren't currently selected when using isearch.
 '(isearch ((t (:foreground "white" :background "#2f822f" :weight bold)))) ; Highlighting for the currently selected match of C-s
 )

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
