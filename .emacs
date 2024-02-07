(menu-bar-mode -1)
(set-scroll-bar-mode 'right)
(tool-bar-mode -1)
(blink-cursor-mode -1)

(column-number-mode 1)
(indent-according-to-mode)
(display-time)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(modus-vivendi)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.

 ;; Additions made by Kentaro Wuertele
 '(show-paren-match ((t (:background "MediumBlue" :box (:line-width (-1 . -1) :color "white" :style nil)))))
 ; '(region ((t (:background "#103050" :box (:line-width (-1 . -1) :color "grey15")))))
 '(region ((t (:background "grey15"))))
 '(mode-line ((t (:box (:line-width 1 :color "red")))))
 )

(global-set-key (kbd "C-x C-e") 'compile)
(global-set-key (kbd "C-x '") 'next-error)
(global-set-key (kbd "C-x O") (lambda () (interactive) (other-window -1)))

(setq explicit-shell-file-name "/bin/bash")
(setenv "Pager" "/bin/cat")
(setenv "LFS" "/mnt/lfs")
(server-start)
(setenv "EDITOR" "emacsclient")
