;;;  config-misc.el	
;;;  
;;;  David Wuertele	Wed Jun 19 16:12:06 1996

;;;  Steal This Program!!!


;; MISCELLANEOUS ATTRIBUTES, DEFAULTS, HOOKS, AND VARIABLES
(setq Man-notify 'aggressive)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'eval-expression 'disabled nil)
(setq default-major-mode 'text-mode)
(setq-default truncate-lines t)
(setq-default case-fold-search t)
(setq text-mode-hook '(lambda () (auto-fill-mode 1) (setq fill-column 79)))
(setq find-file-existing-other-name t)
(setenv "MANPATH" "/usr/X11R6/man:/usr/local/man:/usr/man:/usr/local/share/man:/usr/man/preformat:/var/qmail/man:/usr/share/man")
(setq ange-ftp-generate-anonymous-password "dave@")
(random t)
(set-fill-column 70)
(setq-default fill-column 70)

;(setenv "P4PORT" "192.168.0.10:1666")
;(setenv "P4CLIENT" "dave")
;(load-library "p4")

;(require 'clearcase)
;(global-set-key "p" 'clearcase-ediff-pred-current-buffer)

(setq load-path (append load-path (list "/usr/share/emacs/site-lisp/w3m")))
;(require 'w3m-load)

;(require 'planner)
;(global-set-key [(f11)] 'planner-create-task-from-buffer)

(defun stop-using-minibuffer ()
  "kill the minibuffer"
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))

(add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

;;; Local Variables:
;;; mode:lisp-interaction
;;; End:
