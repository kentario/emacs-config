;;;  init_stuf.el	Initialize various files.
;;;  
;;;  David Wuertele	Thu Apr  2 00:44:30 1992

;;;  Steal This Program!!!


(defun init-elisp ()
  (interactive)
  (goto-char (point-min))
  (insert-string
   (format ";;;  %s	\n;;;  \n;;;  David Wuertele	%s\n\n;;;  Steal This Program!!!\n\n"
	   (substring buffer-file-name (string-match "[^/]*$" buffer-file-name))
	   (current-time-string)))
  (insert-string
   (format "\n\n\n;;; Local Variables:\n;;; mode:lisp-interaction\n;;; mode:font-lock\n;;; End:\n"))
  (goto-char (point-min))
  (end-of-line)
  (lisp-interaction-mode))

(defun init-vhdl ()
  (interactive)
  (goto-char (point-min))
  (let* ((this-file (substring buffer-file-name (string-match "[^/]*$" buffer-file-name)))
	 (this-part (substring this-file 0 (string-match "\.vhd" this-file)))
	 (this-architecture "XXX")
	 (library-string "\n\nlibrary ieee;\nuse ieee.std_logic_1164.all;\n\n"))
    (insert-string
     (format "---  %s	\n---  \n---  David Wuertele	%s\n\n---  Steal This Program!!!\n"
	     this-file
	     (current-time-string)))
    (insert-string library-string)
    (insert-string (format "entity %s is\n  port ();\nend %s;\n" this-part this-part))
    (insert-string library-string)
    (insert-string (format "architecture %s of %s is\nbegin\nend %s;\n\n\n" this-architecture this-part this-architecture))
    (insert-string (format "configuration %s_%s_con of %s is\n  for %s\n  end for;\nend %s_%s_con;\n\n"
			   this-part this-architecture this-part this-architecture this-part this-architecture))
    (insert-string "\n-- Local Variables:\n-- mode:vhdl\n-- end-comment-column:100\n-- lazy-lock-stealth-time:3\n-- End:\n"))
  (goto-char (point-min))
  (end-of-line)
  (vhdl-mode))

(defun init-tex ()
  (interactive)
  (goto-char (point-min))
  (insert-string
   (concat
    "\\documentstyle[dendentitle,epsf,A4]{jarticle}\n\n"
    "\\topmargin 1.0cm\n"
    "\\oddsidemargin 1.0cm\n"
    "\\textheight 25cm\n"
    "\\textwidth 19cm\n\n"
    "\\author{’±©’Ä»’Áê’ß·’¸¦’µæ’¼¼ M1 26327 ’¥ï’¥Æ’¥ë ’¥Ç’¥¤’¥Ó’¥Ã’¥È}\n\n"
    "\\begin{document}\n\n"
    ))
  (save-excursion
    (goto-char (point-max))
    (insert-string "\n\n\\end{document}\n"))
  (LaTeX-mode))

(defun init-perl ()
  (interactive)
  (goto-char (point-min))
  (let ((program-name (substring buffer-file-name (string-match "[^/]*$" buffer-file-name))))
    (insert-string
     (concat 
      (format "#!/usr/local/bin/perl -w\n#\t-*- Perl -*-\t\t%s:\t\n#\n" program-name)
      (format "#\t\(usage\)%% %s\n#\n" program-name)
      (format "#\tInputs:\t\t\n#\t\t\t\n#\tOutputs:\t\t\n#\n")
      (format "#\tDavid Wuertele\t%s\tSteal This Program!!!\n\n" (current-time-string)))))
  (goto-char (point-min))
  (end-of-line)
  (save-buffer)
  (start-process "chmod" nil "chmod" "+x" buffer-file-name)
  (perl-mode))


(defun init-c ()
  (interactive)
  (goto-char (point-min))
  (insert-string
   (format "/**\n***\t%s\t\t\n***\n***\t(usage)%%\n***\n***\tInputs:\t\t\n***\n***\tOutputs:\t\n***\n***\tDavid Wuertele\t\t%s\n***\n***\tSteal This Program!!!\n**/\n\n"
	   (substring buffer-file-name (string-match "[^/]*$" buffer-file-name))
	   (current-time-string)))
  (goto-char (point-min))
  (forward-line 1)
  (end-of-line)
  (c-mode))

(defun init-make ()
  (interactive)
  (goto-char (point-min))
  (insert-string
   (format "# -*- makefile -*-\t\t%s\n# davew@motorola.com\t\t%s\n# Steal This Program!!!\n\n"
	   (substring buffer-file-name (string-match "[^/]*$" buffer-file-name))
	   (current-time-string)))
  (goto-char (point-min))
  (forward-line 1)
  (end-of-line)
  (makefile-mode))

(defun init-h ()
  (interactive)
  (goto-char (point-min))
  (let ((filename (substring buffer-file-name (string-match "[^/]*$" buffer-file-name))))
    (insert-string
     (format "/**\n***\t%s\t\t\n***\n***\tDavid Wuertele\t\t%s\n***\n***\tSteal This Program!!!\n**/\n\n"
	     filename (current-time-string)))
    (setq filename (substring (upcase filename) 0 (- (length filename) 2)))
    (if (string-match "-" filename)
	(setq filename (concat
			(substring filename 0 (string-match "-" filename))
			"_"
			(substring filename (1+ (string-match "-" filename))))))
    (insert-string
     (concat
      (format "#ifndef __%s_SEEN__\t/* Protect against re-inclusion of this file. */\n#define __%s_SEEN__\n\n"
	      filename filename)
      "\n/* Includes */\n\n#include <stdio.h>\n\n\n/* Constants */\n/* Macros */\n/* Types / Structures */"
      "\n/* Globals */\n/* Prototypes */\n\n"
      (format "#endif /* __%s_SEEN__ */\n" filename))))
  (goto-char (point-min))
  (forward-line 1)
  (end-of-line)
  (c-mode))




(defun init-fheader ()
  (interactive)
  (beginning-of-line)
  (insert-string "\n/*  \n**  \n**  Inputs:\t\n**  Outputs:\t\n**  Side Efct:\t\n*/\n")
  (forward-line -6)
  (end-of-line))


(defun init-color ()
  (interactive)
  (if (eq window-system 'x)
      (if (fboundp 'x-set-background-color)
	  (progn
	    (x-set-background-color "midnightblue")
	    (x-set-foreground-color "yellow")
	    (x-set-cursor-color "red")
	    (x-set-mouse-color "aquamarine"))
	(if (fboundp 'set-background-color)
	    (progn
	      (set-background-color "midnightblue")
	      (set-foreground-color "yellow")
	      (set-cursor-color "red")
	      (set-mouse-color "aquamarine"))))))


(provide 'init_stuff)

;;; Local Variables:
;;; mode:lisp-interaction
;;; End:
