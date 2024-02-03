;;;  config-crypt.el	
;;;  
;;;  David Wuertele	Mon Oct 22 11:30:20 2001

;;;  Steal This Program!!!

(require 'crypt++)
(require 'tar-mode)

(setq crypt-encryption-type 'pgp
      crypt-encryption-file-extension "\\(\\.pgp\\)$")

(load-library "mailcrypt")
(mc-setversion "gpg")

;(autoload 'mc-install-write-mode "mailcrypt" nil t)
;(autoload 'mc-install-read-mode "mailcrypt" nil t)
;(add-hook 'mail-mode-hook 'mc-install-write-mode)
;(add-hook 'gnus-summary-mode-hook 'mc-install-read-mode)
;(add-hook 'news-reply-mode-hook 'mc-install-write-mode)
;(setq mc-levien-file-name "~/lib/PGP/.remailers")
;(add-hook 'message-mode-hook 'mc-install-write-mode)
;(setq mc-pgp-user-id "David M. Wuertele <dave@bfnet.com>")
;(setenv "PGPPATH" "/home/dave/lib/PGP")

(setq ssh-program "/usr/bin/ssh")
(load "ssh")

(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)
(setq comint-password-prompt-regexp
      "\\(\\([Oo]ld \\|[Nn]ew \\|Kerberos \\|'s \\|login \\|CVS \\|^\\)[Pp]assword\\( (again)\\)?\\|pass phrase\\|Enter passphrase\\).*:\\s *\\'"
      )



;;; Local Variables:
;;; mode:lisp-interaction
;;; mode:font-lock
;;; End:
