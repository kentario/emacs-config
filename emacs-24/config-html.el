;;;  config-html.el	
;;;  
;;;  David Wuertele	Wed Jun 19 16:12:43 1996

;;;  Steal This Program!!!


;; HTML
(autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)
(setq auto-mode-alist (cons '("\\.html$" . html-helper-mode) auto-mode-alist))
(setq html-helper-do-write-file-hooks t)
(setq html-helper-build-new-buffer t)
(setq html-helper-address-string "<A HREF=\"http://cave/~dave\">David Wuertele</A>")


;;; Local Variables:
;;; mode:lisp-interaction
;;; End:
