;;;  startup-full.el	
;;;  
;;;  David Wuertele	Mon Oct 22 10:30:16 2001

;;;  Steal This Program!!!

; local library loads
(load "config-display.el")
(load "config-language.el")
(load "config-dired.el")
(load "config-crypt.el")
(load "config-shell.el")
(load "config-keymap.el")
(load "config-init.el")
(load "config-calc.el")
(load "config-html.el")
(load "config-igrep.el")
(load "config-misc.el")
(load "scad-mode.el")
(load "graphviz-dot-mode.el")

;(load "config-android.el")
;(load "config-magit.el")

;(load "config-tex.el")
;(load "config-jde.el")

; local library autoloads
(autoload 'init-dlog "dlog" nil t)
(autoload 'view-processes "view-process-mode" nil t)

; misc init files
(setq gnus-init-file "~/mail/.gnus")


;;; Local Variables:
;;; mode:lisp-interaction
;;; mode:font-lock
;;; End:
