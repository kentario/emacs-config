;;;  config-display.el	
;;;  
;;;  David Wuertele	Wed Jun 19 16:20:06 1996

;;;  Steal This Program!!!

(menu-bar-mode -1)			;turn off menu bars
(set-scroll-bar-mode 'right)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(load "init_stuff.el")
(init-color)

(column-number-mode 1)
(line-number-mode 1)
(indent-according-to-mode)
(display-time)

;(add-hook 'font-lock-mode-hook 'turn-on-jit-lock)
(add-hook 'dired-mode-hook 'turn-on-font-lock)
(add-hook 'lisp-interaction-mode-hook 'turn-on-font-lock)
(add-hook 'emacs-lisp-mode-hook 'turn-on-font-lock)
(add-hook 'latex-mode-hook 'turn-on-font-lock)
(add-hook 'makefile-mode-hook 'turn-on-font-lock)
(add-hook 'c-mode-hook 'turn-on-font-lock)

;;; Local Variables:
;;; mode:lisp-interaction
;;; End:
