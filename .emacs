(menu-bar-mode -1)
(set-scroll-bar-mode 'right)
(tool-bar-mode -1)
(blink-cursor-mode -1)

(column-number-mode 1)
(global-display-line-numbers-mode -1)

(indent-according-to-mode)
(display-time)

(ido-mode 1)
;; Don't jump to a different directory when creating a new file, or mistyping a filename.
(setq ido-auto-merge-work-directories-length -1)

;; Package management
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Load use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

(setq use-package-always-ensure t) ; Ensure all packages are installed by default

(use-package smex
  :ensure t)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package quick-peek
  :ensure t)

(use-package flycheck-inline
  :ensure t)

(use-package exec-path-from-shell
  :ensure t)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(use-package rust-mode
  :ensure t)

(use-package flycheck-rust
  :ensure t)

(use-package pdf-tools
  :ensure t)

(use-package auctex
  :ensure t)

(use-package cdlatex
  :ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(kentaro-deeper-blue))
 '(custom-safe-themes
   '("8966037be0ad554bbc8ceda50bb752493a711266e1e3562b23b462dd97cb6236" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(fancy-splash-image "~/lib/emacs-butterfly.svg")
 '(flycheck-clang-args nill)
 '(flycheck-gcc-args "-std=c++20")
 '(package-selected-packages
   '(cdlatex auctex flycheck-rust quick-peek spacemacs-theme flycheck-inline use-package flycheck smex))
 '(package-vc-selected-packages
   '((vc-use-package :vc-backend Git :url "https://github.com/slotThe/vc-use-package"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Rust stuff
(add-hook 'rust-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (flycheck-mode)
	    (flycheck-rust-setup)
	    ))

(setq rust-format-on-save t)

;; Allows flycheck to display error messages with a horizontal bar around them.
(with-eval-after-load 'flycheck
  (add-hook 'flycheck-mode-hook #'flycheck-inline-mode)
  (with-eval-after-load 'quick-peek
    (setq flycheck-inline-display-function
	  (lambda (msg pos err)
	    (let* ((ov (quick-peek-overlay-ensure-at pos))
		   (contents (quick-peek-overlay-contents ov)))
	      (setf (quick-peek-overlay-contents ov)
		    (concat contents (when contents "\n") msg))
	      (quick-peek-update ov)))
	  flycheck-inline-clear-function #'quick-peek-hide)))

;; PDF Tools setup
(setq TeX-view-program-selection '((output-pdf "PDF Tools")))
(setq TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view)))

;; Auto-revert PDF buffers when the PDF file changes on disk
(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

;; Enable PDF sync support (forward/backward search)
(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-start-server t)

;; Allow previewing of TikZ figures with AUCTeX
(eval-after-load "preview"
  '(add-to-list 'preview-default-preamble "\\PreviewEnvironment{tikzpicture}" t)
  )

;; LaTeX stuff
(setq TeX-auto-save t)
(setq TeX-parse-self t)

;; Automatically insert braces when typing ^ or _
(setq TeX-electric-sub-and-superscript t)

;; Enable prettify-symbols mode in LaTeX buffers.
;; Enable TeX-fold-mode in LaTeX buffers. https://www.gnu.org/software/auctex/manual/auctex/Folding.html
;; This also makes it so that whenever typing a "}" or "$" the stuff that I just typed will be folded.

(add-hook 'LaTeX-mode-hook
	  (lambda ()
	    (prettify-symbols-mode)
	    (TeX-fold-mode 1)
	    (turn-on-cdlatex)
	    (add-hook 'find-file-hook #'TeX-fold-buffer t t)
	    ;; (add-hook 'after-change-functions
	    ;; 	      (lambda (start end oldlen)
	    ;; 		(when (= (- end start) 1)
	    ;; 		  (let ((char-point
	    ;; 			 (buffer-substring-no-properties
	    ;; 			  start end)))
	    ;; 		    (when (or (string= char-point "}")
	    ;; 			      (string= char-point "$"))
	    ;; 		      (TeX-fold-paragraph)))))
	    ;; 	      t t)))
	    ))

;; Keybindings
(global-set-key (kbd "C-x p") 'flycheck-previous-error)
(global-set-key (kbd "C-x n") 'flycheck-next-error)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-x '") 'next-error)
(global-set-key (kbd "C-x \"") 'previous-error)
(global-set-key (kbd "C-x O") (lambda () (interactive) (other-window -1)))
(global-set-key (kbd "C-x C-/") 'comment-region)
(global-set-key (kbd "C-x C-\\") 'uncomment-region)
(global-set-key (kbd "C-x %") (lambda () (interactive) (enlarge-window -1)))

(global-set-key (kbd "C-x C-e") 'compile)
;; Special handling for emacs-lisp mode
(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-x C-e") 'eval-last-sexp)))

(setq explicit-shell-file-name "/bin/bash")
(setenv "Pager" "/bin/cat")
(setenv "LFS" "/mnt/lfs")
(server-start)
(setenv "EDITOR" "emacsclient")

(setq dired-listing-switches "-AFltg")

(add-hook 'dired-load-hook
	  (function (lambda ()
		      (load "dired-x")
		      )))

(setq dired-guess-shell-alist-user
      (list (list "\\.jpg\\'" "/usr/X11R6/bin/xv");; fixed rule
	    (list "\\.pdf\\'" "/usr/bin/acroread");; fixed rule
	    ;; possibly more rules ...
	    (list "\\.bar\'";; rule with condition test
                  '(if condition
                       "BAR-COMMAND-1"
                     "BAR-COMMAND-2"))))

(require 'dired)
(require 'epa-dired)

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

;; (defun shell-on-phonehome-host (ssh-args)
;;   (interactive)
;;   (let* ((this-tramp-host (car (assoc tramp-host-name tramp-hosts)))
;; 	 (this-tramp-directory (cdr (assoc tramp-host-name tramp-hosts)))
;; 	 (this-tramp-shell-buffer-name (concat "*" this-tramp-host "*")))
;;     (cond ((not (comint-check-proc this-tramp-shell-buffer-name))
;;            (add-to-list 'tramp-default-proxies-alist 
;; 	   (find-file this-tramp-directory)
;; 	   (let* ((prog "/bin/sh")
;; 		  (name (file-name-nondirectory prog))
;; 		  (startfile (concat "~/.emacs_" name))
;; 		  (xargs-name (intern-soft (concat "explicit-" name "-args"))))
;; 	     (set-buffer (apply 'make-comint this-tramp-host prog
;; 				(if (file-exists-p startfile) startfile)
;; 				(if (and xargs-name (boundp xargs-name))
;; 				    (symbol-value xargs-name)
;; 				  '("-i"))))
;; 	     (shell-mode))))
;;     (switch-to-buffer this-tramp-shell-buffer-name)
;;     (set-buffer-process-coding-system 'utf-8 'utf-8)
;;     (setq proc (get-buffer-process (current-buffer)))
;;     (process-send-string proc (concat "cd " directory-name))))

(setq comint-scroll-show-maximum-output nil)

(setq explicit-shell-file-name "/bin/bash")

(defun shell (&optional buffer)
  "Run an inferior shell, with I/O through BUFFER (which defaults to `*shell*').
Interactively, a prefix arg means to prompt for BUFFER.
If `default-directory' is a remote file name, it is also prompted
to change if called with a prefix arg.

If BUFFER exists but shell process is not running, make new shell.
If BUFFER exists and shell process is running, just switch to BUFFER.
Program used comes from variable `explicit-shell-file-name',
 or (if that is nil) from the ESHELL environment variable,
 or (if that is nil) from `shell-file-name'.
If a file `~/.emacs_SHELLNAME' exists, or `~/.emacs.d/init_SHELLNAME.sh',
it is given as initial input (but this may be lost, due to a timing
error, if the shell discards input when it starts up).
The buffer is put in Shell mode, giving commands for sending input
and controlling the subjobs of the shell.  See `shell-mode'.
See also the variable `shell-prompt-pattern'.

To specify a coding system for converting non-ASCII characters
in the input and output to the shell, use \\[universal-coding-system-argument]
before \\[shell].  You can also specify this with \\[set-buffer-process-coding-system]
in the shell buffer, after you start the shell.
The default comes from `process-coding-system-alist' and
`default-process-coding-system'.

The shell file name (sans directories) is used to make a symbol name
such as `explicit-csh-args'.  If that symbol is a variable,
its value is used as a list of arguments when invoking the shell.
Otherwise, one argument `-i' is passed to the shell.

\(Type \\[describe-mode] in the shell buffer for a list of commands.)"
  (interactive
   (list
    (and current-prefix-arg
	 (prog1
	     (read-buffer "Shell buffer: "
			  ;; If the current buffer is an inactive
			  ;; shell buffer, use it as the default.
			  (if (and (eq major-mode 'shell-mode)
				   (null (get-buffer-process (current-buffer))))
			      (buffer-name)
			    (generate-new-buffer-name "*shell*")))
	   (if (file-remote-p default-directory)
	       ;; It must be possible to declare a local default-directory.
	       ;; FIXME: This can't be right: it changes the default-directory
	       ;; of the current-buffer rather than of the *shell* buffer.
	       (setq default-directory
		     (expand-file-name
		      (read-directory-name
		       "Default directory: " default-directory default-directory
		       t nil))))))))
  (setq buffer (if (or buffer (not (derived-mode-p 'shell-mode))
		       (comint-check-proc (current-buffer)))
                   (get-buffer-create (or buffer "*shell*"))
                 ;; If the current buffer is a dead shell buffer, use it.
                 (current-buffer)))

  (with-current-buffer buffer
    (when (file-remote-p default-directory)
      ;; Apply connection-local variables.
      (hack-connection-local-variables-apply
       `(:application tramp
		      :protocol ,(file-remote-p default-directory 'method)
		      :user ,(file-remote-p default-directory 'user)
		      :machine ,(file-remote-p default-directory 'host)))

      ;; On remote hosts, the local `shell-file-name' might be useless.
      (if (and (called-interactively-p 'any)
	       (null explicit-shell-file-name)
	       (null (getenv "ESHELL")))
          (set (make-local-variable 'explicit-shell-file-name)
	       (file-local-name
		(expand-file-name
                 (read-file-name
                  "Remote shell path: " default-directory shell-file-name
                  t shell-file-name)))))))

  ;; The buffer's window must be correctly set when we call comint
  ;; (so that comint sets the COLUMNS env var properly).
  (switch-to-buffer buffer)
  ;; Rain or shine, BUFFER must be current by now.
  (unless (comint-check-proc buffer)
    (let* ((prog (or explicit-shell-file-name
                     (getenv "ESHELL") shell-file-name))
           (name (file-name-nondirectory prog))
           (startfile (concat "~/.emacs_" name))
           (xargs-name (intern-soft (concat "explicit-" name "-args"))))
      (unless (file-exists-p startfile)
        (setq startfile (concat user-emacs-directory "init_" name ".sh")))
      (apply 'make-comint-in-buffer "shell" buffer prog
	     (if (file-exists-p startfile) startfile)
	     (if (and xargs-name (boundp xargs-name))
                 (symbol-value xargs-name)
	       '("-i")))
      (shell-mode)))
  buffer)

;;; Local Variables:
;;; mode:lisp-interaction
;;; mode:font-lock
;;; End:
