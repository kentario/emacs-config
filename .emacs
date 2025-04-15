;;; .emacs --- Initialization file for Emacs
;;; Commentary: Emacs Startup File --- initialization for Emacs

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("8966037be0ad554bbc8ceda50bb752493a711266e1e3562b23b462dd97cb6236" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Make some annoying stuff go away.
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(global-display-line-numbers-mode -1) ;; For some reason I just don't like this.

;; Make some nice stuff appear
(set-scroll-bar-mode 'right)
(column-number-mode 1)
(indent-according-to-mode)
(display-time)

;; Theme
(load-theme 'kentaro-deeper-blue)
(setq fancy-splash-image "~/lib/emacs-butterfly.svg")

;; Don't make shell jump around.
(setq comint-scroll-show-maximum-output nil)
