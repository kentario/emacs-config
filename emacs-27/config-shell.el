;;;  config-shell.el	
;;;  
;;;  David Wuertele	Fri Oct 26 14:18:47 2001

;;;  Steal This Program!!!

(require 'shell)
(add-hook 'shell-mode-hook 'turn-on-font-lock)
(defun shell-with-cd-to-default-directory (directory-name)
  (interactive "DDirectory: ")
  (cond ((not (comint-check-proc "*shell*"))
	 (let* ((prog (or explicit-shell-file-name
			  (getenv "ESHELL")
			  (getenv "SHELL")
			  "/bin/sh"))		     
		(name (file-name-nondirectory prog))
		(startfile (concat "~/.emacs_" name))
		(xargs-name (intern-soft (concat "explicit-" name "-args"))))
	   (set-buffer (apply 'make-comint "shell" prog
			      (if (file-exists-p startfile) startfile)
			      (if (and xargs-name (boundp xargs-name))
				  (symbol-value xargs-name)
				'("-i"))))
	   (shell-mode))))
  (switch-to-buffer "*shell*")
  (set-buffer-process-coding-system 'utf-8 'utf-8)
  (setq proc (get-buffer-process (current-buffer)))
  (process-send-string proc (concat "cd " directory-name))
  (shell-process-cd directory-name)
  (process-send-string proc "\n"))

(defun shell-on-tramp-host (tramp-host-name)
  (interactive)
  (let* ((this-tramp-host (car (assoc tramp-host-name tramp-hosts)))
	 (this-tramp-directory (cdr (assoc tramp-host-name tramp-hosts)))
	 (this-tramp-shell-buffer-name (concat "*" this-tramp-host "*")))
    (cond ((not (comint-check-proc this-tramp-shell-buffer-name))
	   (find-file this-tramp-directory)
	   (let* ((prog "/bin/sh")
		  (name (file-name-nondirectory prog))
		  (startfile (concat "~/.emacs_" name))
		  (xargs-name (intern-soft (concat "explicit-" name "-args"))))
	     (set-buffer (apply 'make-comint this-tramp-host prog
				(if (file-exists-p startfile) startfile)
				(if (and xargs-name (boundp xargs-name))
				    (symbol-value xargs-name)
				  '("-i"))))
	     (shell-mode))))
    (switch-to-buffer this-tramp-shell-buffer-name)
    (set-buffer-process-coding-system 'utf-8 'utf-8)
    (setq proc (get-buffer-process (current-buffer)))
    (process-send-string proc (concat "cd " directory-name))))

(setq comint-scroll-show-maximum-output nil)


;;; Local Variables:
;;; mode:lisp-interaction
;;; mode:font-lock
;;; End:
