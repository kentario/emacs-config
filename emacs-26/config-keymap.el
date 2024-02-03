;;;  config-keymap.el	
;;;  
;;;  David Wuertele	Wed Jun 19 16:11:24 1996

;;;  Steal This Program!!!


;; KEYMAP
(global-set-key "" 'compile)
(global-set-key "'" 'next-error)
(global-set-key "\C-xs" 'shell-with-cd-to-default-directory)
(global-set-key "" 'toggle-truncate-lines)
(define-key emacs-lisp-mode-map "\C-m" 'reindent-then-newline-and-indent)
(define-key lisp-interaction-mode-map "\C-m" 'reindent-then-newline-and-indent)
(global-set-key [C-M-next]  (lambda () (interactive) (scroll-left 20)))
(global-set-key [C-M-prior] (lambda () (interactive) (scroll-right 20)))
(global-set-key "" 'font-lock-fontify-buffer)

(global-set-key [mouse-5] (lambda () (interactive) (scroll-up 1)))
(global-set-key [mouse-4] (lambda () (interactive) (scroll-down 1)))

;;; Local Variables:
;;; mode:lisp-interaction
;;; End:
