;;;  config-dired.el	
;;;  
;;;  David Wuertele	Mon Oct 22 11:22:03 2001

;;;  Steal This Program!!!

(setq dired-listing-switches "-AFltg")

(add-hook 'dired-load-hook
	  (function (lambda ()
		      (load "dired-x")
		      )))

(setq dired-guess-shell-alist-user
      (list (list "\\.jpg\\'" "/usr/X11R6/bin/xv");; fixed rule
            (list "\\.pdf\\'" "/usr/bin/acroread");; fixed rule
              ;; possibly more rules ...
              (list "\\.bar\'";; rule with condition test
                    '(if condition
                          "BAR-COMMAND-1"
                        "BAR-COMMAND-2"))))

(require 'dired)
(require 'epa-dired)

;;; Local Variables:
;;; mode:lisp-interaction
;;; mode:font-lock
;;; End:
