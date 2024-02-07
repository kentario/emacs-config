;;;  .emacs		This .emacs should work for ANY type of emacs.
;;;  
;;;  David Wuertele	Tue Feb 22 17:43:31 1994

;;;  Steal This Program!!!

(setq startup-dir (format "~/lib/emacs-%s" emacs-major-version))

(setq load-path (append load-path (list startup-dir)))

(load "startup-full.el")

(defun xr () (interactive) (call-process "/usr/bin/xrandr" nil nil "--output" "HDMI-A-0" "--mode" "2560x1440"))

;; ;; remote scp access
;; (require 'tramp)
;; ;(setq tramp-default-method "scp")
;; (setq tramp-default-method "ssh")

;; (setq tramp-hosts '(("modelbee" . "/ssh:dwuertele@modelbee.teslamotors.com:/home/dwuertele/")
;; 		    ("dfwi"   . "/ssh:tesla@10.32.10.10:/home/tesla/")
;; 		    ("fwi5"   . "/ssh:root@10.35.57.55:/home/tesla/")
;; 		    ("fwi6"   . "/ssh:tesla@10.35.57.56:/home/tesla/")
;; 		    ("fwi7"   . "/ssh:tesla@10.35.57.57:/home/tesla/")
;; 		    ("fwi64"  . "/ssh:tesla@10.35.57.64:/home/tesla/")
;; 		    ("fwi65"  . "/ssh:tesla@10.35.57.65:/home/tesla/")
;; 		    ("duclab" . "/ssh:tesla@10.32.10.11:/home/tesla/")
;; 		    ("paragt" . "/ssh:tesla@10.32.10.12:/home/tesla/")
;; 		    ("parago" . "/ssh:root@10.32.10.12:/home/tesla/")
;; 		    ("jx01d"  . "/ssh:dwuertele@jx01.dev.tesla:/home/dwuertele")
;; 		    ("jx01"   . "/ssh:dwuertele@jx01:/home/dwuertele")
;; 		    ("dcid"   . "/ssh:root@192.168.90.100:/")
;; 		    ("ncm1"   . "/ssh:tesla@10.34.109.199:/")
;; 		    ("fwi63"  . "/ssh:tesla@10.35.57.63:/")
;; ))

(setq explicit-shell-file-name "/bin/bash")

(setenv "PAGER" "/bin/cat")
(setenv "LFS" "/mnt/lfs")
(server-start)
(setenv "EDITOR" "emacsclient")


(find-file "~")

;;; Local Variables:
;;; mode:lisp-interaction
;;; End:
