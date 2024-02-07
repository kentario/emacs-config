;;;  config-calc.el	
;;;  
;;;  David Wuertele	Wed Jun 19 16:10:05 1996

;;;  Steal This Program!!!

;; CALC
(autoload 'calc-dispatch	   "calc" "Calculator Options" t)
(autoload 'full-calc		   "calc" "Full-screen Calculator" t)
(autoload 'full-calc-keypad	   "calc" "Full-screen X Calculator" t)
(autoload 'calc-eval		   "calc" "Use Calculator from Lisp")
(autoload 'defmath		   "calc" nil t t)
(autoload 'calc			   "calc" "Calculator Mode" t)
(autoload 'quick-calc		   "calc" "Quick Calculator" t)
(autoload 'calc-keypad		   "calc" "X windows Calculator" t)
(autoload 'calc-embedded	   "calc" "Use Calc inside any buffer" t)
(autoload 'calc-embedded-activate  "calc" "Activate =>'s in buffer" t)
(autoload 'calc-grab-region	   "calc" "Grab region of Calc data" t)
(autoload 'calc-grab-rectangle	   "calc" "Grab rectangle of data" t)
;(autoload 'edit-kbd-macro	   "macedit" "Edit Keyboard Macro" t)
;(autoload 'edit-last-kbd-macro	   "macedit" "Edit Keyboard Macro" t)
;(autoload 'read-kbd-macro	   "macedit" "Read Keyboard Macro" t)
(global-set-key "\e#" 'calc-dispatch)
;;; Variable "var-TimeZone" stored by Calc on Mon Jul  4 12:16:04 1994
(setq var-TimeZone '9)


;;; Local Variables:
;;; mode:lisp-interaction
;;; End:
