;;;  init_stuf.el	Initialize various files.
;;;  
;;;  David Wuertele	Thu Apr  2 00:44:30 1992

;;;  Steal This Program!!!


(defun init-elisp ()
  (interactive)
  (goto-char (point-min))
  (insert
   (format ";;;  %s	\n;;;  \n;;;  Kentaro Wuertele	%s\n\n;;;  3.141592653589793238462643383279502\n\n"
	   (substring buffer-file-name (string-match "[^/]*$" buffer-file-name))
	   (current-time-string)))
  (insert
   (format "\n\n\n;;; Local Variables:\n;;; mode:lisp-interaction\n;;; mode:font-lock\n;;; End:\n"))
  (goto-char (point-min))
  (end-of-line)
  (lisp-interaction-mode))

(defun init-perl ()
  (interactive)
  (goto-char (point-min))
  (let ((program-name (substring buffer-file-name (string-match "[^/]*$" buffer-file-name))))
    (insert
     (concat 
      (format "#!/usr/bin/perl -w\n#\t-*- Perl -*-\t\t%s:\t\n#\n" program-name)
      (format "#\t\(usage\)%% %s\n#\n" program-name)
      (format "#\tInputs:\t\t\n#\t\t\t\n#\tOutputs:\t\t\n#\n")
      (format "#\tKentaro Wuertele\t%s\t3.141592653589793238462643383279502\n\n" (current-time-string)))))
  (goto-char (point-min))
  (end-of-line)
  (save-buffer)
  (start-process "chmod" nil "chmod" "+x" buffer-file-name)
  (perl-mode))

(defun init-color ()
  (interactive)
  (if (eq window-system 'x)
      (if (fboundp 'x-set-background-color)
	  (progn
	    (x-set-background-color "black")
	    (x-set-foreground-color "yellow")
	    (x-set-cursor-color "red")
	    (x-set-mouse-color "aquamarine"))
	(if (fboundp 'set-background-color)
	    (progn
	      (set-background-color "black")
	      (set-foreground-color "yellow")
	      (set-cursor-color "red")
	      (set-mouse-color "aquamarine"))))))

(provide 'init_stuff)

;;; Local Variables:
;;; mode:lisp-interaction
;;; End:
