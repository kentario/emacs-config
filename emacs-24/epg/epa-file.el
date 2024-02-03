;;; epa-file.el --- the EasyPG Assistant, transparent file encryption
;; Copyright (C) 2006 Daiki Ueno

;; Author: Daiki Ueno <ueno@unixuser.org>
;; Keywords: PGP, GnuPG

;; This file is part of EasyPG.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'epa)

(defgroup epa-file nil
  "The EasyPG Assistant hooks for transparent file encryption"
  :group 'epa)

(defcustom epa-file-name-regexp "\\.gpg\\'"
  "Regexp which matches filenames to be encrypted with GnuPG."
  :type 'regexp
  :group 'epa-file)

(defvar epa-file-handler
  (cons epa-file-name-regexp 'epa-file-handler))
  
(defvar epa-file-passphrase-alist nil)

(defun epa-file-passphrase-callback-function (context key-id file)
  (if (eq key-id 'SYM)
      (let ((entry (assoc file epa-file-passphrase-alist))
	    passphrase)
	(or (copy-sequence (cdr entry))
	    (progn
	      (unless entry
		(setq entry (list file)
		      epa-file-passphrase-alist (cons entry
						 epa-file-passphrase-alist)))
	      (setq passphrase (epg-passphrase-callback-function context
								 key-id nil))
	      (setcdr entry (copy-sequence passphrase))
	      passphrase)))
    (epg-passphrase-callback-function context key-id nil)))

(defun epa-file-handler (operation &rest args)
  (save-match-data
    (let ((op (get operation 'epa-file)))
      (if op
	  (apply op args)
	(epa-file-run-real-handler operation args)))))

(defun epa-file-run-real-handler (operation args)
  (let ((inhibit-file-name-handlers
	 (cons 'epa-file-handler
	       (and (eq inhibit-file-name-operation operation)
		    inhibit-file-name-handlers)))
	(inhibit-file-name-operation operation))
    (apply operation args)))

(defvar last-coding-system-used)
(defun epa-file-insert-file-contents (file &optional visit beg end replace)
  (barf-if-buffer-read-only)
  (if (and visit (or beg end))
      (error "Attempt to visit less than an entire file"))
  (setq file (expand-file-name file))
  (let ((local-copy (epa-file-run-real-handler #'file-local-copy (list file)))
	(context (epg-make-context))
	string length entry)
    (if visit
	(setq buffer-file-name file))
    (epg-context-set-passphrase-callback
     context
     (cons #'epa-file-passphrase-callback-function
	   file))
    (unwind-protect
	(progn
	  (if replace
	      (goto-char (point-min)))
	  (condition-case error
	      (setq string (epg-decrypt-file context file nil))
	    (error
	     (if (setq entry (assoc file epa-file-passphrase-alist))
		 (setcdr entry nil))
	     (signal 'file-error
		     (cons "Opening input file" (cdr error)))))
	  (if (or beg end)
	      (setq string (substring string (or beg 0) end)))
	  (setq string
		(decode-coding-string string
				      (or coding-system-for-read 'undecided)))
	  (if (boundp 'last-coding-system-used)
	      (set-buffer-file-coding-system last-coding-system-used)
	    (set-buffer-file-coding-system default-buffer-file-coding-system))
	  (save-excursion
	    (insert string)
	    (setq length (length string))
	    (if replace
		(delete-region (point) (point-max)))))
      (if (and local-copy
	       (file-exists-p local-copy))
	  (delete-file local-copy)))
    (list file length)))
(put 'insert-file-contents 'epa-file 'epa-file-insert-file-contents)

(defun epa-file-write-region (start end file &optional append visit lockname
				    mustbenew)
  (if append
      (error "Can't append to the file."))
  (setq file (expand-file-name file))
  (let* ((coding-system (or coding-system-for-write
			    (if (boundp 'last-coding-system-used)
				(condition-case nil
				    (write-region (point-min) (point-max) "/")
				  (error last-coding-system-used))
			      buffer-file-coding-system)))
	 (context (epg-make-context))
	 (coding-system-for-write 'binary)
	 string entry)
    (epg-context-set-passphrase-callback
     context
     (cons #'epa-file-passphrase-callback-function
	   file))
    (condition-case error
	(setq string
	      (epg-encrypt-string
	       context
	       (if (stringp start)
		   (encode-coding-string start coding-system)
		 (encode-coding-string (buffer-substring start end)
				       coding-system))
	       (unless (assoc file epa-file-passphrase-alist)
		 (epa-select-keys
		  context
		  "Select recipents for encryption.
If no one is selected, symmetric encryption will be performed.  "))))
      (error
       (if (setq entry (assoc file epa-file-passphrase-alist))
	   (setcdr entry nil))
       (signal 'file-error (cons "Opening output file" (cdr error)))))
    (epa-file-run-real-handler
     #'write-region
     (list string nil file append visit lockname mustbenew))
    (if (boundp 'last-coding-system-used)
	(setq last-coding-system-used coding-system))
    (if (eq visit t)
	(progn
	  (setq buffer-file-name file)
	  (set-visited-file-modtime))
      (if (stringp visit)
	  (progn
	    (set-visited-file-modtime)
	    (setq buffer-file-name visit))))
    (if (or (eq visit t)
	    (eq visit nil)
	    (stringp visit))
	(message "Wrote %s" buffer-file-name))))
(put 'write-region 'epa-file 'epa-file-write-region)

;;;###autoload
(defun epa-file-enable ()
  (interactive)
  (if (memq epa-file-handler file-name-handler-alist)
      (message "`epa-file' already enabled")
    (setq file-name-handler-alist
	  (cons epa-file-handler file-name-handler-alist))
    (message "`epa-file' enabled")))

;;;###autoload
(defun epa-file-disable ()
  (interactive)
  (if (memq epa-file-handler file-name-handler-alist)
      (progn
	(setq file-name-handler-alist
	      (delq epa-file-handler file-name-handler-alist))
	(message "`epa-file' disabled"))
    (message "`epa-file' already disabled")))

(provide 'epa-file)

;;; epa-file.el ends here
