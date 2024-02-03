;;; epa.el --- the EasyPG Assistant
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

(require 'epg)
(require 'font-lock)
(require 'widget)
(eval-when-compile (require 'wid-edit))

(defgroup epa nil
  "The EasyPG Assistant"
  :group 'epg)

(defcustom epa-armor nil
  "If non-nil, epa commands create ASCII armored output."
  :type 'boolean
  :group 'epa)

(defcustom epa-textmode nil
  "If non-nil, epa commands treat input files as text."
  :type 'boolean
  :group 'epa)

(defcustom epa-popup-info-window nil
  "If non-nil, status information from epa commands is displayed on
the separate window."
  :type 'boolean
  :group 'epa)

(defcustom epa-info-window-height 5
  "Number of lines used to display status information."
  :type 'integer
  :group 'epa)

(defgroup epa-faces nil
  "Faces for epa-mode."
  :group 'epa)

(defface epa-validity-high-face
  '((((class color) (background dark))
     (:foreground "PaleTurquoise" :bold t))
    (t
     (:bold t)))
  "Face used for displaying the high validity."
  :group 'epa-faces)
(defvar epa-validity-high-face 'epa-validity-high-face)

(defface epa-validity-medium-face
  '((((class color) (background dark))
     (:foreground "PaleTurquoise" :italic t))
    (t
     ()))
  "Face used for displaying the medium validity."
  :group 'epa-faces)
(defvar epa-validity-medium-face 'epa-validity-medium-face)

(defface epa-validity-low-face
  '((t
     (:italic t)))
  "Face used for displaying the low validity."
  :group 'epa-faces)
(defvar epa-validity-low-face 'epa-validity-low-face)

(defface epa-validity-disabled-face
  '((t
     (:italic t :inverse-video t)))
  "Face used for displaying the disabled validity."
  :group 'epa-faces)
(defvar epa-validity-disabled-face 'epa-validity-disabled-face)

(defface epa-string-face
  '((((class color)
      (background dark))
     (:foreground "lightyellow"))
    (((class color)
      (background light))
     (:foreground "blue4"))
    (t
     ()))
  "Face used for displaying the string."
  :group 'epa-faces)
(defvar epa-string-face 'epa-string-face)

(defface epa-mark-face
  '((((class color) (background dark))
     (:foreground "orange" :bold t))
    (t
     (:foreground "red" :bold t)))
  "Face used for displaying the high validity."
  :group 'epa-faces)
(defvar epa-mark-face 'epa-mark-face)

(defface epa-field-name-face
  '((((class color) (background dark))
     (:foreground "PaleTurquoise" :bold t))
    (t (:bold t)))
  "Face for the name of the attribute field."
  :group 'epa)
(defvar epa-field-name-face 'epa-field-name-face)

(defface epa-field-body-face
  '((((class color) (background dark))
     (:foreground "turquoise" :italic t))
    (t (:italic t)))
  "Face for the body of the attribute field."
  :group 'epa)
(defvar epa-field-body-face 'epa-field-body-face)

(defcustom epa-validity-face-alist
  '((unknown . epa-validity-disabled-face)
    (invalid . epa-validity-disabled-face)
    (disabled . epa-validity-disabled-face)
    (revoked . epa-validity-disabled-face)
    (expired . epa-validity-disabled-face)
    (none . epa-validity-low-face)
    (undefined . epa-validity-low-face)
    (never . epa-validity-low-face)
    (marginal . epa-validity-medium-face)
    (full . epa-validity-high-face)
    (ultimate . epa-validity-high-face))
  "An alist mapping validity values to faces."
  :type 'list
  :group 'epa)

(defcustom epa-font-lock-keywords
  '(("^\\*"
     (0 epa-mark-face))
    ("^\t\\([^\t:]+:\\)[ \t]*\\(.*\\)$"
     (1 epa-field-name-face)
     (2 epa-field-body-face)))
  "Default expressions to addon in epa-mode."
  :type '(repeat (list string))
  :group 'epa)

(defconst epa-pubkey-algorithm-letter-alist
  '((1 . ?R)
    (2 . ?r)
    (3 . ?s)
    (16 . ?g)
    (17 . ?D)
    (20 . ?G)))

(defvar epa-keys-buffer nil)
(defvar epa-key-buffer-alist nil)
(defvar epa-key nil)
(defvar epa-list-keys-arguments nil)
(defvar epa-info-buffer nil)

(defvar epa-keys-mode-map
  (let ((keymap (make-sparse-keymap)))
    (define-key keymap "m" 'epa-mark)
    (define-key keymap "u" 'epa-unmark)
    (define-key keymap "d" 'epa-decrypt-file)
    (define-key keymap "v" 'epa-verify-file)
    (define-key keymap "s" 'epa-sign-file)
    (define-key keymap "S" 'epa-sign-keys)
    (define-key keymap "e" 'epa-encrypt-file)
    (define-key keymap "r" 'epa-delete-keys)
    (define-key keymap "i" 'epa-import-keys)
    (define-key keymap "o" 'epa-export-keys)
    (define-key keymap "g" 'epa-list-keys)
    (define-key keymap "n" 'next-line)
    (define-key keymap "p" 'previous-line)
    (define-key keymap " " 'scroll-up)
    (define-key keymap [delete] 'scroll-down)
    (define-key keymap "q" 'epa-exit-buffer)
    keymap))

(defvar epa-key-mode-map
  (let ((keymap (make-sparse-keymap)))
    (define-key keymap "q" 'bury-buffer)
    keymap))

(defvar epa-info-mode-map
  (let ((keymap (make-sparse-keymap)))
    (define-key keymap "q" 'delete-window)
    keymap))

(defvar epa-exit-buffer-function #'bury-buffer)

(define-widget 'epa-key 'push-button
  "Button for representing a epg-key object."
  :format "%[%v%]"
  :button-face-get 'epa-key-widget-button-face-get
  :value-create 'epa-key-widget-value-create
  :action 'epa-key-widget-action
  :help-echo 'epa-key-widget-help-echo)

(defun epa-key-widget-action (widget &optional event)
  (epa-show-key (widget-get widget :value)))

(defun epa-key-widget-value-create (widget)
  (let* ((key (widget-get widget :value))
	 (primary-sub-key (car (epg-key-sub-key-list key)))
	 (primary-user-id (car (epg-key-user-id-list key))))
    (insert (format "%c "
		    (if (epg-sub-key-validity primary-sub-key)
			(car (rassq (epg-sub-key-validity primary-sub-key)
				    epg-key-validity-alist))
		      ? ))
	    (epg-sub-key-id primary-sub-key)
	    " "
	    (if (stringp (epg-user-id-string primary-user-id))
		(epg-user-id-string primary-user-id)
	      (epg-decode-dn (epg-user-id-string primary-user-id))))))

(defun epa-key-widget-button-face-get (widget)
  (let ((validity (epg-sub-key-validity (car (epg-key-sub-key-list
					      (widget-get widget :value))))))
    (if validity
	(cdr (assq validity epa-validity-face-alist))
      'default)))

(defun epa-key-widget-help-echo (widget)
  (format "Show %s"
	  (epg-sub-key-id (car (epg-key-sub-key-list
				(widget-get widget :value))))))

(defun epa-keys-mode ()
  "Major mode for `epa-list-keys'."
  (kill-all-local-variables)
  (buffer-disable-undo)
  (setq major-mode 'epa-keys-mode
	mode-name "Keys"
	truncate-lines t
	buffer-read-only t)
  (use-local-map epa-keys-mode-map)
  (set-keymap-parent (current-local-map) widget-keymap)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(epa-font-lock-keywords t))
  ;; In XEmacs, auto-initialization of font-lock is not effective
  ;; if buffer-file-name is not set.
  (font-lock-set-defaults)
  (widget-setup)
  (make-local-variable 'epa-exit-buffer-function)
  (run-hooks 'epa-keys-mode-hook))

(defun epa-key-mode ()
  "Major mode for `epa-show-key'."
  (kill-all-local-variables)
  (buffer-disable-undo)
  (setq major-mode 'epa-key-mode
	mode-name "Key"
	truncate-lines t
	buffer-read-only t)
  (use-local-map epa-key-mode-map)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(epa-font-lock-keywords t))
  ;; In XEmacs, auto-initialization of font-lock is not effective
  ;; if buffer-file-name is not set.
  (font-lock-set-defaults)
  (make-local-variable 'epa-exit-buffer-function)
  (run-hooks 'epa-key-mode-hook))

;;;###autoload
(defun epa-list-keys (&optional name mode protocol)
  (interactive
   (if current-prefix-arg
       (let ((name (read-string "Pattern: "
				(if epa-list-keys-arguments
				    (car epa-list-keys-arguments)))))
	 (list (if (equal name "") nil name)
	       (y-or-n-p "Secret keys? ")
	       (intern (completing-read "Protocol? "
					'(("OpenPGP") ("CMS"))
					nil t))))
     (or epa-list-keys-arguments (list nil nil nil))))
  (unless (and epa-keys-buffer
	       (buffer-live-p epa-keys-buffer))
    (setq epa-keys-buffer (generate-new-buffer "*Keys*")))
  (set-buffer epa-keys-buffer)
  (let ((inhibit-read-only t)
	buffer-read-only
	(point (point-min))
	(context (epg-make-context protocol)))
    (unless (get-text-property point 'epa-list-keys)
      (setq point (next-single-property-change point 'epa-list-keys)))
    (when point
      (delete-region point
		     (or (next-single-property-change point 'epa-list-keys)
			 (point-max)))
      (goto-char point))
    (epa-insert-keys context name mode)
    (epa-keys-mode))
  (make-local-variable 'epa-list-keys-arguments)
  (setq epa-list-keys-arguments (list name mode protocol))
  (goto-char (point-min))
  (pop-to-buffer (current-buffer)))

(defun epa-insert-keys (context name mode)
  (save-excursion
    (save-restriction
      (narrow-to-region (point) (point))
      (let ((keys (epg-list-keys context name mode))
	    point)
	(while keys
	  (setq point (point))
	  (insert "  ")
	  (add-text-properties point (point)
			       (list 'epa-key (car keys)
				     'front-sticky nil
				     'rear-nonsticky t
				     'start-open t
				     'end-open t))
	  (widget-create 'epa-key :value (car keys))
	  (insert "\n")
	  (setq keys (cdr keys))))      
      (add-text-properties (point-min) (point-max)
			   (list 'epa-list-keys t
				 'front-sticky nil
				 'rear-nonsticky t
				 'start-open t
				 'end-open t)))))

(defun epa-marked-keys ()
  (or (save-excursion
	(set-buffer epa-keys-buffer)
	(goto-char (point-min))
	(let (keys key)
	  (while (re-search-forward "^\\*" nil t)
	    (if (setq key (get-text-property (match-beginning 0)
					     'epa-key))
		(setq keys (cons key keys))))
	  (nreverse keys)))
      (save-excursion
	(beginning-of-line)
	(let ((key (get-text-property (point) 'epa-key)))
	  (if key
	      (list key))))))

;;;###autoload
(defun epa-select-keys (context prompt &optional names secret)
  "Display a user's keyring and ask him to select keys.
CONTEXT is an epg-context.
PROMPT is a string to prompt with.
NAMES is a list of strings to be matched with keys.  If it is nil, all
the keys are listed.
If SECRET is non-nil, list secret keys instead of public keys."
  (save-excursion
    (unless (and epa-keys-buffer
		 (buffer-live-p epa-keys-buffer))
      (setq epa-keys-buffer (generate-new-buffer "*Keys*")))
    (let ((inhibit-read-only t)
	  buffer-read-only)
      (set-buffer epa-keys-buffer)
      (erase-buffer)
      (insert prompt "\n")
      (widget-create 'link
		     :notify (lambda (&rest ignore) (abort-recursive-edit))
		     :help-echo
		     (substitute-command-keys
		      "Click here or \\[abort-recursive-edit] to cancel")
		     "Cancel")
      (widget-create 'link
		     :notify (lambda (&rest ignore) (exit-recursive-edit))
		     :help-echo
		     (substitute-command-keys
		      "Click here or \\[exit-recursive-edit] to finish")
		     "OK")
      (insert "\n\n")
      (if names
	  (while names
	    (epa-insert-keys context (car names) secret)
	    (if (get-text-property (point) 'epa-list-keys)
		(epa-mark))
	    (goto-char (point-max))
	    (setq names (cdr names)))
	(if secret
	    (progn
	      (epa-insert-keys context nil secret)
	      (if (get-text-property (point) 'epa-list-keys)
		  (epa-mark)))
	  (epa-insert-keys context nil nil)))
      (epa-keys-mode)
      (setq epa-exit-buffer-function #'abort-recursive-edit)
      (goto-char (point-min))
      (pop-to-buffer (current-buffer)))
    (unwind-protect
	(progn
	  (recursive-edit)
	  (epa-marked-keys))
      (if (get-buffer-window epa-keys-buffer)
	  (delete-window (get-buffer-window epa-keys-buffer)))
      (kill-buffer epa-keys-buffer))))

(defun epa-show-key (key)
  (let* ((primary-sub-key (car (epg-key-sub-key-list key)))
	 (entry (assoc (epg-sub-key-id primary-sub-key)
		       epa-key-buffer-alist))
	 (inhibit-read-only t)
	 buffer-read-only
	 pointer)
    (unless entry
      (setq entry (cons (epg-sub-key-id primary-sub-key) nil)
	    epa-key-buffer-alist (cons entry epa-key-buffer-alist)))
    (unless (and (cdr entry)
		 (buffer-live-p (cdr entry)))
      (setcdr entry (generate-new-buffer
		     (format "*Key*%s" (epg-sub-key-id primary-sub-key)))))
    (set-buffer (cdr entry))
    (make-local-variable 'epa-key)
    (setq epa-key key)
    (erase-buffer)
    (setq pointer (epg-key-user-id-list key))
    (while pointer
      (insert " "
	      (if (epg-user-id-validity (car pointer))
		  (char-to-string
		   (car (rassq (epg-user-id-validity (car pointer))
			       epg-key-validity-alist)))
		" ")
	      " "
	      (if (stringp (epg-user-id-string (car pointer)))
		  (epg-user-id-string (car pointer))
		(epg-decode-dn (epg-user-id-string (car pointer))))
	      "\n")
      (setq pointer (cdr pointer)))
    (setq pointer (epg-key-sub-key-list key))
    (while pointer
      (insert " "
	      (if (epg-sub-key-validity (car pointer))
		  (char-to-string
		   (car (rassq (epg-sub-key-validity (car pointer))
			       epg-key-validity-alist)))
		" ")
	      " "
	      (epg-sub-key-id (car pointer))
	      " "
	      (format "%dbits"
		      (epg-sub-key-length (car pointer)))
	      " "
	      (cdr (assq (epg-sub-key-algorithm (car pointer))
			 epg-pubkey-algorithm-alist))
	      "\n\tCreated: "
	      (format-time-string "%Y-%m-%d"
				  (epg-sub-key-creation-time (car pointer)))
	      (if (epg-sub-key-expiration-time (car pointer))
		  (format "\n\tExpires: %s"
			  (format-time-string "%Y-%m-%d"
					      (epg-sub-key-expiration-time
					       (car pointer))))
		"")
	      "\n\tCapabilities: "
	      (mapconcat #'symbol-name
			 (epg-sub-key-capability (car pointer))
			 " ")
	      "\n\tFingerprint: "
	      (epg-sub-key-fingerprint (car pointer))
	      "\n")
      (setq pointer (cdr pointer)))
    (goto-char (point-min))
    (pop-to-buffer (current-buffer))
    (epa-key-mode)))

(defun epa-show-key-notify (widget &rest ignore)
  (epa-show-key (widget-get widget :value)))

(defun epa-mark (&optional arg)
  "Mark the current line.
If ARG is non-nil, unmark the current line."
  (interactive "P")
  (let ((inhibit-read-only t)
	buffer-read-only
	properties)
    (beginning-of-line)
    (setq properties (text-properties-at (point)))
    (delete-char 1)
    (insert (if arg " " "*"))
    (set-text-properties (1- (point)) (point) properties)
    (forward-line)))

(defun epa-unmark (&optional arg)
  "Unmark the current line.
If ARG is non-nil, mark the current line."
  (interactive "P")
  (epa-mark (not arg)))

(defun epa-toggle-mark ()
  "Toggle the mark the current line."
  (interactive)
  (epa-mark (eq (char-after (save-excursion (beginning-of-line) (point))) ?*)))

(defun epa-exit-buffer ()
  "Exit the current buffer.
`epa-exit-buffer-function' is called if it is set."
  (interactive)
  (funcall epa-exit-buffer-function))

(defun epa-display-verify-result (verify-result)
  (if epa-popup-info-window
      (progn
	(unless epa-info-buffer
	  (setq epa-info-buffer (generate-new-buffer "*Info*")))
	(save-excursion
	  (set-buffer epa-info-buffer)
	  (let ((inhibit-read-only t)
		buffer-read-only)
	    (erase-buffer)
	    (insert (epg-verify-result-to-string verify-result)))
	  (epa-info-mode))
	(pop-to-buffer epa-info-buffer)
	(if (> (window-height) epa-info-window-height)
	    (shrink-window (- (window-height) epa-info-window-height)))
	(goto-char (point-min)))
    (message "%s" (epg-verify-result-to-string verify-result))))

(defun epa-info-mode ()
  "Major mode for `epa-info-buffer'."
  (kill-all-local-variables)
  (buffer-disable-undo)
  (setq major-mode 'epa-info-mode
	mode-name "Info"
	truncate-lines t
	buffer-read-only t)
  (use-local-map epa-info-mode-map)
  (run-hooks 'epa-info-mode-hook))

;;;###autoload
(defun epa-decrypt-file (file)
  "Decrypt FILE."
  (interactive "fFile: ")
  (let* ((default-name (file-name-sans-extension file))
	 (plain (expand-file-name
		 (read-file-name
		  (concat "To file (default "
			  (file-name-nondirectory default-name)
			  ") ")
		  (file-name-directory default-name)
		  default-name)))
	 (context (epg-make-context)))
    (message "Decrypting %s..." (file-name-nondirectory file))
    (epg-decrypt-file context file plain)
    (message "Decrypting %s...done" (file-name-nondirectory file))
    (if (epg-context-result-for context 'verify)
	(epa-display-verify-result (epg-context-result-for context 'verify)))))

;;;###autoload
(defun epa-verify-file (file)
  "Verify FILE."
  (interactive "fFile: ")
  (let* ((context (epg-make-context))
	 (plain (if (equal (file-name-extension file) "sig")
		    (file-name-sans-extension file))))
    (message "Verifying %s..." (file-name-nondirectory file))
    (epg-verify-file context file plain)
    (message "Verifying %s...done" (file-name-nondirectory file))
    (if (epg-context-result-for context 'verify)
	(epa-display-verify-result (epg-context-result-for context 'verify)))))

;;;###autoload
(defun epa-sign-file (file signers mode)
  "Sign FILE by SIGNERS keys selected."
  (interactive
   (list (expand-file-name (read-file-name "File: "))
	 (epa-select-keys (epg-make-context) "Select keys for signing.
If no one is selected, default secret key is used.  "
			  nil t)
	 (if (y-or-n-p "Make a detached signature? ")
	     'detached
	   (if (y-or-n-p "Make a cleartext signature? ")
	       'clear))))
  (let ((signature (concat file
			   (if (or epa-armor
				   (not (memq mode '(nil t normal detached))))
			       ".asc"
			     (if (memq mode '(t detached))
				 ".sig"
			       ".gpg"))))
	(context (epg-make-context)))
    (epg-context-set-armor context epa-armor)
    (epg-context-set-textmode context epa-textmode)
    (epg-context-set-signers context signers)
    (message "Signing %s..." (file-name-nondirectory file))
    (epg-sign-file context file signature mode)
    (message "Signing %s...done" (file-name-nondirectory file))))

;;;###autoload
(defun epa-encrypt-file (file recipients)
  "Encrypt FILE for RECIPIENTS."
  (interactive
   (list (expand-file-name (read-file-name "File: "))
	 (epa-select-keys (epg-make-context) "Select recipients for encryption.
If no one is selected, symmetric encryption will be performed.  ")))
  (let ((cipher (concat file (if epa-armor ".asc" ".gpg")))
	(context (epg-make-context)))
    (epg-context-set-armor context epa-armor)
    (epg-context-set-textmode context epa-textmode)
    (message "Encrypting %s..." (file-name-nondirectory file))
    (epg-encrypt-file context file recipients cipher)
    (message "Encrypting %s...done" (file-name-nondirectory file))))

;;;###autoload
(defun epa-decrypt-region (start end)
  "Decrypt the current region between START and END.

Don't use this command in Lisp programs!"
  (interactive "r")
  (save-excursion
    (let ((context (epg-make-context))
	  plain)
      (message "Decrypting...")
      (setq plain (epg-decrypt-string context (buffer-substring start end)))
      (message "Decrypting...done")
      (delete-region start end)
      (goto-char start)
      (insert (decode-coding-string plain coding-system-for-read))
      (if (epg-context-result-for context 'verify)
	  (epa-display-verify-result (epg-context-result-for context 'verify))))))

;;;###autoload
(defun epa-decrypt-armor-in-region (start end)
  "Decrypt OpenPGP armors in the current region between START and END.

Don't use this command in Lisp programs!"
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (goto-char start)
      (let (armor-start armor-end charset coding-system)
	(while (re-search-forward "-----BEGIN PGP MESSAGE-----$" nil t)
	  (setq armor-start (match-beginning 0)
		armor-end (re-search-forward "^-----END PGP MESSAGE-----$"
					     nil t))
	  (unless armor-end
	    (error "No armor tail"))
	  (goto-char armor-start)
	  (if (re-search-forward "^Charset: \\(.*\\)" armor-end t)
	      (setq charset (match-string 1)))
	  (if coding-system-for-read
	      (setq coding-system coding-system-for-read)
	    (if charset
		(setq coding-system (intern (downcase charset)))
	      (setq coding-system 'utf-8)))
	  (let ((coding-system-for-read coding-system))
	    (epa-decrypt-region start end)))))))

;;;###autoload
(defun epa-verify-region (start end)
  "Verify the current region between START and END.

Don't use this command in Lisp programs!"
  (interactive "r")
  (let ((context (epg-make-context)))
    (epg-verify-string context
		       (encode-coding-string
			(buffer-substring start end)
			coding-system-for-write))
    (if (epg-context-result-for context 'verify)
	(epa-display-verify-result (epg-context-result-for context 'verify)))))

;;;###autoload
(defun epa-verify-armor-in-region (start end)
  "Verify OpenPGP armors in the current region between START and END.

Don't use this command in Lisp programs!"
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (goto-char start)
      (let (armor-start armor-end)
	(while (re-search-forward "-----BEGIN PGP\\( SIGNED\\)? MESSAGE-----$"
				  nil t)
	  (setq armor-start (match-beginning 0))
	  (if (match-beginning 1)	;cleartext signed message
	      (progn
		(unless (re-search-forward "^-----BEGIN PGP SIGNATURE-----$"
					   nil t)
		  (error "Invalid cleartext signed message"))
		(setq armor-end (re-search-forward
				 "^-----END PGP SIGNATURE-----$"
				 nil t)))
	    (setq armor-end (re-search-forward
			     "^-----END PGP MESSAGE-----$"
			     nil t)))
	  (unless armor-end
	    (error "No armor tail"))
	  (epa-verify-region armor-start armor-end))))))

;;;###autoload
(defun epa-sign-region (start end signers mode)
  "Sign the current region between START and END by SIGNERS keys selected.

Don't use this command in Lisp programs!"
  (interactive
   (list (region-beginning) (region-end)
	 (epa-select-keys (epg-make-context) "Select keys for signing.
If no one is selected, default secret key is used.  "
			  nil t)
	 (if (y-or-n-p "Make a detached signature? ")
	     'detached
	   (if (y-or-n-p "Make a cleartext signature? ")
	       'clear))))
  (save-excursion
    (let ((context (epg-make-context))
	  signature)
      (epg-context-set-armor context epa-armor)
      (epg-context-set-textmode context epa-textmode)
      (epg-context-set-signers context signers)
      (message "Signing...")
      (setq signature (epg-sign-string context
				       (encode-coding-string
					(buffer-substring start end)
					coding-system-for-write)
				       mode))
      (message "Signing...done")
      (delete-region start end)
      (insert (decode-coding-string signature coding-system-for-read)))))

;;;###autoload
(defun epa-encrypt-region (start end recipients)
  "Encrypt the current region between START and END for RECIPIENTS.

Don't use this command in Lisp programs!"
  (interactive
   (list (region-beginning) (region-end)
	 (epa-select-keys (epg-make-context) "Select recipients for encryption.
If no one is selected, symmetric encryption will be performed.  ")))
  (save-excursion
    (let ((context (epg-make-context))
	  cipher)
      (epg-context-set-armor context epa-armor)
      (epg-context-set-textmode context epa-textmode)
      (message "Encrypting...")
      (setq cipher (epg-encrypt-string context
				       (encode-coding-string
					(buffer-substring start end)
					coding-system-for-write)
				       recipients))
      (message "Encrypting...done")
      (delete-region start end)
      (insert cipher))))

;;;###autoload
(defun epa-delete-keys (keys &optional allow-secret)
  "Delete selected KEYS."
  (interactive
   (let ((keys (epa-marked-keys)))
     (unless keys
       (error "No keys selected"))
     (list keys
	   (eq (nth 1 epa-list-keys-arguments) t))))
  (let ((context (epg-make-context)))
    (message "Deleting...")
    (epg-delete-keys context keys allow-secret)
    (message "Deleting...done")
    (apply #'epa-list-keys epa-list-keys-arguments)))

;;;###autoload
(defun epa-import-keys (file)
  "Import keys from FILE."
  (interactive "fFile: ")
  (let ((context (epg-make-context)))
    (message "Importing %s..." (file-name-nondirectory file))
    (epg-import-keys-from-file context (expand-file-name file))
    (message "Importing %s...done" (file-name-nondirectory file))
    (apply #'epa-list-keys epa-list-keys-arguments)))

;;;###autoload
(defun epa-export-keys (keys file)
  "Export selected KEYS to FILE."
  (interactive
   (let ((keys (epa-marked-keys))
	 default-name)
     (unless keys
       (error "No keys selected"))
     (setq default-name
	   (expand-file-name
	    (concat (epg-sub-key-id (car (epg-key-sub-key-list (car keys))))
		    (if epa-armor ".asc" ".gpg"))
	    default-directory))
     (list keys
	   (expand-file-name
	    (read-file-name
	     (concat "To file (default "
		     (file-name-nondirectory default-name)
		     ") ")
	     (file-name-directory default-name)
	     default-name)))))
  (let ((context (epg-make-context)))
    (epg-context-set-armor context epa-armor)
    (message "Exporting to %s..." (file-name-nondirectory file))
    (epg-export-keys-to-file context keys file)
    (message "Exporting to %s...done" (file-name-nondirectory file))))

;;;###autoload
(defun epa-sign-keys (keys &optional local)
  "Sign selected KEYS.
If LOCAL is non-nil, the signature is marked as non exportable."
  (interactive
   (let ((keys (epa-marked-keys)))
     (unless keys
       (error "No keys selected"))
     (list keys current-prefix-arg)))
  (let ((context (epg-make-context)))
    (message "Signing keys...")
    (epg-sign-keys context keys local)
    (message "Signing keys...done")))

(provide 'epa)

;;; epa.el ends here
