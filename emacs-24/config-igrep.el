;;;  config-igrep.el	
;;;  
;;;  David Wuertele	Wed Jun 19 16:09:36 1996

;;;  Steal This Program!!!

;; IGREP
(autoload (function igrep) "igrep"			"*Run `grep` PROGRAM to match EXPRESSION in FILES..." t)
(autoload (function igrep-recursively) "igrep"		"*Run `grep` recursively..." t)
(autoload (function dired-do-igrep) "igrep"		"*Run `grep` on the marked (or next prefix ARG) files.")
(autoload (function dired-do-igrep-recursively) "igrep"	"*Run `grep` recursively on the marked (or next prefix ARG) files.")
(autoload (function grep) "igrep"			"*Run `grep` PROGRAM to match EXPRESSION in FILES..." t)
(autoload (function egrep) "igrep"			"*Run `egrep`..." t)
(autoload (function glimpse) "igrep"			"*Run `glimpse`..." t)
(autoload (function fgrep) "igrep"			"*Run `fgrep`..." t)
(autoload (function agrep) "igrep"			"*Run `agrep`..." t)
(autoload (function grep-recursively) "igrep"		"*Run `grep` recursively..." t)
(autoload (function egrep-recursively) "igrep"		"*Run `egrep` recursively..." t)
(autoload (function fgrep-recursively) "igrep"		"*Run `fgrep` recursively..." t)
(autoload (function agrep-recursively) "igrep"		"*Run `agrep` recursively..." t)
(autoload (function dired-do-grep) "igrep"		"*Run `grep` on the marked (or next prefix ARG) files.")
(autoload (function dired-do-grep-recursively) "igrep"	"*Run `grep` recursively on the marked (or next prefix ARG) files.")

(setq glimpse-library "/home/dave/lib/glimpse")

;;; Local Variables:
;;; mode:lisp-interaction
;;; End:
