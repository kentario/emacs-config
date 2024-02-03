;;; epg-config.el --- configuration of the EasyPG Library
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

(defgroup epg ()
  "The EasyPG Library"
  :group 'emacs)

(defcustom epg-gpg-program "gpg"
  "The `gpg' executable."
  :group 'epg
  :type 'string)

(defcustom epg-gpgsm-program "gpgsm"
  "The `gpgsm' executable."
  :group 'epg
  :type 'string)

(defcustom epg-gpg-home-directory nil
  "The directory which contains the configuration files of `epg-gpg-program'."
  :group 'epg
  :type '(choice (const :tag "Default" nil) directory))

(defcustom epg-locale-coding-system (if (boundp 'locale-coding-system)
					locale-coding-system)
  "Coding system to use with messages from `epg-gpg-program'."
  :group 'epg
  :type 'symbol)

(defconst epg-version-number "0.0.5")

(defconst epg-gpg-minimum-version "1.4.3")

;;;###autoload
(defun epg-configuration ()
  "Return a list of internal configuration parameters of `epg-gpg-program'."
  (let (config type)
    (with-temp-buffer
      (apply #'call-process epg-gpg-program nil (list t nil) nil
	     (append (if epg-gpg-home-directory
			 (list "--homedir" epg-gpg-home-directory))
		     '("--with-colons" "--list-config")))
      (goto-char (point-min))
      (while (re-search-forward "^cfg:\\([^:]+\\):\\(.*\\)" nil t)
	(setq type (intern (match-string 1))
	      config (cons (cons type
				 (if (memq type
					   '(pubkey cipher digest compress))
				     (mapcar #'string-to-number
					     (delete "" (split-string
							 (match-string 2)
							 ";")))
				   (match-string 2)))
			   config))))
    config))

(defun epg-config--parse-version (string)
  (let ((index 0)
	version)
    (while (eq index (string-match "\\([0-9]+\\)\\.?" string index))
      (setq version (cons (string-to-number (match-string 1 string))
			  version)
	    index (match-end 0)))
    (nreverse version)))

(defun epg-config--compare-version (v1 v2)
  (while (and v1 v2 (= (car v1) (car v2)))
    (setq v1 (cdr v1) v2 (cdr v2)))
  (- (or (car v1) 0) (or (car v2) 0)))

;;;###autoload
(defun epg-check-configuration (config &optional minimum-version)
  "Verify that a sufficient version of GnuPG is installed."
  (let ((entry (assq 'version config))
	version)
    (unless (and entry
		 (stringp (cdr entry)))
      (error "Undetermined version: %S" entry))
    (setq version (epg-config--parse-version (cdr entry))
	  minimum-version (epg-config--parse-version
			   (or minimum-version
			       epg-gpg-minimum-version)))
    (unless (>= (epg-config--compare-version version minimum-version) 0)
      (error "Unsupported version: %s" (cdr entry)))))

(provide 'epg-config)

;;; epg-config.el ends here
