;;;  config-speedbar.el	
;;;  
;;;  David Wuertele	Tue Oct 30 18:21:01 2001

;;;  Steal This Program!!!

(autoload 'speedbar-frame-mode "speedbar" "Popup a speedbar frame" t)
(autoload 'speedbar-get-focus "speedbar" "Jump to speedbar frame" t)
(global-set-key [(f4)] 'speedbar-get-focus)

;; Texinfo fancy chapter tags
(add-hook 'texinfo-mode-hook (lambda () (require 'sb-texinfo)))

;; HTML fancy chapter tags
(add-hook 'html-mode-hook (lambda () (require 'sb-html)))

;For any verison of emacs on a linux RPM based system:
(autoload 'rpm "sb-rpm" "Rpm package listing in speedbar.")

;; w3 link listings
;(autoload 'w3-speedbar-buttons "sb-w3" "s3 specific speedbar button generator.")

;(add-to-list 'load-path "/path/to/semantic")
(setq semantic-load-turn-everything-on t)
(require 'semantic-load)

(require 'jde)

;; Set the debug option to enable a backtrace when a
;; problem occurs.
(setq debug-on-error t)

;; Update the Emacs load-path to include the path to
;; the JDE and its require packages. This code assumes
;; that you have installed the packages in the emacs/site
;; subdirectory of your home directory.
(add-to-list 'load-path (expand-file-name "~/emacs/site/jde/lisp"))
(add-to-list 'load-path (expand-file-name "~/emacs/site/semantic"))
(add-to-list 'load-path (expand-file-name "~/emacs/site/speedbar"))
(add-to-list 'load-path (expand-file-name "~/emacs/site/eieio"))
(add-to-list 'load-path (expand-file-name "~/emacs/site/elib"))


;; If you want Emacs to defer loading the JDE until you open a 
;; Java file, edit the following line
(setq defer-loading-jde nil)
;; to read:
;;
;;  (setq defer-loading-jde t)
;;

(if defer-loading-jde
    (progn
      (autoload 'jde-mode "jde" "JDE mode." t)
      (setq auto-mode-alist
	    (append
	     '(("\\.java\\'" . jde-mode))
	     auto-mode-alist)))
  (require 'jde))


;; Sets the basic indentation for Java source files
;; to two spaces.
(defun my-jde-mode-hook ()
  (setq c-basic-offset 2))

(add-hook 'jde-mode-hook 'my-jde-mode-hook)

;; Include the following only if you want to run
;; bash as your shell.

;; Setup Emacs to run bash as its primary shell.
(setq explicit-shell-file-name shell-file-name)
(setenv "SHELL" shell-file-name)
(setq explicit-sh-args '("-login" "-i"))

(setq jde-global-classpath '("."))

;;; Local Variables:
;;; mode:lisp-interaction
;;; mode:font-lock
;;; End:
