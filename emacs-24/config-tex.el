;;;  config-tex.el	
;;;  
;;;  David Wuertele	Wed Jun 19 16:11:10 1996

;;;  Steal This Program!!!

;; AUC-TeX 
(require 'tex-site)
(require 'bibtex)

(setq TeX-view-style '(("^a5$" "xdvi %d -paper a5")
			 ("^landscape$" "xdvi %d -paper a4r -s 4")
			 ;; The latest xdvi can show embedded postscript.
			 ;; If you don't have that, uncomment next line.
			 ;; ("^epsf$" "ghostview %f")
			 ("." "xdvi %d -geometry 1339x1175+-1+-1 -s 4")))


;;; Local Variables:
;;; mode:lisp-interaction
;;; End:
