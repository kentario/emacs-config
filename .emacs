;;; .emacs --- Initialization file for Emacs
;;; Commentary: Emacs Startup File --- initialization for Emacs

;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(custom-safe-themes
   '("8966037be0ad554bbc8ceda50bb752493a711266e1e3562b23b462dd97cb6236"
     default))
 '(package-selected-packages
   '(counsel diminish flycheck flycheck-inline helpful hydra ivy-rich
	     quick-peek)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Make some annoying stuff go away.
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(global-display-line-numbers-mode -1) ;; For some reason I just don't like this.

;; Make some nice stuff appear
(set-scroll-bar-mode 'right)
(column-number-mode 1)
(indent-according-to-mode)
(display-time)

;; Enable certain disabled commands
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Theme
(load-theme 'kentaro-deeper-blue)
(setq fancy-splash-image "~/lib/emacs-butterfly.svg")

;; Don't make shell jump around.
(setq comint-scroll-show-maximum-output nil)

;; Set up straight.el
;; straight.el bootstrap
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Use straight by default, don't need :straight t.
(setq straight-use-package-by-default t)
;; Install use-package with straight.el
(straight-use-package 'use-package)

;; Make it possible to hide minor modes, so as to avoid clutter in the mode line.
(use-package diminish)

;; Autocompletion with ivy, counsel, and swiper.
(use-package ivy
  :diminish
  :bind (([remap isearch-forward] . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done))
  :config
  (ivy-mode))

(use-package counsel
  :diminish
  :bind (("C-x b" . counsel-switch-buffer))
  :config
  (counsel-mode))

(use-package swiper
  :diminish)

(use-package ivy-rich
  :diminish
  :config
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)
  (ivy-rich-mode))

;; Displays the key bindings following the currently entered incomplete command.
(use-package which-key
  :diminish
  :custom
  (which-key-idle-delay 0.6)
  :config
  (which-key-setup-side-window-right)
  (which-key-mode))

;; An alternative to the built-in Emacs help that provides much more contextual information.
(use-package helpful
  :diminish
  :bind (([remap describe-key] . helpful-key)
	 ([remap describe-command] . helpful-command)
	 ("C-c C-d" . helpful-at-point)
	 ("C-c F" . helpful-function))
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable))

(defalias 'calc-eval-region
   (kmacro "M-w C-x * q C-y <return> SPC = SPC C-y"))
(global-set-key (kbd "C-c r") 'calc-eval-region)

;; Tie related commands into a family of short bindings with a prefix.
(use-package hydra)

(defhydra hydra-move (:foreign-keys warn :hint nil
				    :pre (set-cursor-color "#e52b50")
				    :post (set-cursor-color "green"))
  "
      ^^^^^^Move^^^^^^             ^Mark^                ^Actions^
------------------------------------------------------------
 ^ ^ ^ ^ ^   _t_   ^ ^ ^ ^ ^       _SPC_: set mark       _w_: copy
 _a_ _r_ _s_  +  _e_ _i_ _o_       _m_  : unset mark     _d_: cut
 ^ ^ ^ ^ ^   _n_   ^ ^ ^ ^ ^       ^ ^                   _y_: yank
 ^ ^ ^ ^ ^   ^ ^   ^ ^ ^ ^ ^       ^ ^                   _/_: undo
"
  ("n" next-line)
  ("t" previous-line)
  ("e" forward-char)
  ("s" backward-char)
  ("i" forward-word)
  ("r" backward-word)
  ("a" move-beginning-of-line)
  ("o" move-end-of-line)
  ("SPC" set-mark-command)
  ("m" (deactivate-mark t))
  ("w" kill-ring-save)
  ("d" kill-region)
  ("y" yank)
  ("/" undo)
  ("g" nil "quit"))
(global-set-key (kbd "C-<return>") 'hydra-move/body)

(defhydra hydra-minibuffer-move ()
  ("n" ivy-next-line "next")
  ("t" ivy-previous-line "prev")
  ("g" nil "cancel"))
(define-key ivy-minibuffer-map (kbd "C-<return>") 'hydra-minibuffer-move/body)

(defhydra hydra-buffer-menu (:foreign-keys run :hint nil)
  "
^Mark^             ^Unmark^           ^Actions^          ^Search
^^^^^^^^-----------------------------------------------------------------
_m_: mark          _u_: unmark        _x_: execute       _R_: re-isearch
_s_: save          _U_: unmark up     _b_: bury          _I_: isearch
_d_: delete        ^ ^                _g_: refresh       _O_: multi-occur
_D_: delete up     ^ ^                _T_: files only: % -28`Buffer-menu-files-only
_~_: modified
"
  ("m" Buffer-menu-mark)
  ("u" Buffer-menu-unmark)
  ("U" Buffer-menu-backup-unmark)
  ("d" Buffer-menu-delete)
  ("D" Buffer-menu-delete-backwards)
  ("s" Buffer-menu-save)
  ("~" Buffer-menu-not-modified)
  ("x" Buffer-menu-execute)
  ("b" Buffer-menu-bury)
  ("g" revert-buffer)
  ("T" Buffer-menu-toggle-files-only)
  ("O" Buffer-menu-multi-occur :color blue)
  ("I" Buffer-menu-isearch-buffers :color blue)
  ("R" Buffer-menu-isearch-buffers-regexp :color blue)
  ("c" nil "cancel")
  ("v" Buffer-menu-select "select" :color blue)
  ("o" Buffer-menu-other-window "other-window" :color blue)
  ("q" quit-window "quit" :color blue))
(define-key Buffer-menu-mode-map "." 'hydra-buffer-menu/body)

;; hydra-window --------------------------------------------
;;
;; hydra for managing windows

(defhydra hydra-window (:foreign-keys warn :hint nil)
  "
    ^^Move^^            ^Actions^
^^^^^^----------------------------------
      ^_t_^             [_v_]ertical split
      ^^↑^^             [_h_]orizontal split
  _s_ ←   → _e_         [_d_]elete window
      ^^↓^^
      ^_n_^
"
  ("s" windmove-left)
  ("n" windmove-down)
  ("t" windmove-up)
  ("e" windmove-right)
  ("h" split-window-below)
  ("v" split-window-right)
  ("d" delete-window)
  ("SPC" nil "quit"))
(global-set-key (kbd "M-o") 'hydra-window/body)

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (add-to-list 'treesit-language-source-alist
               '(typst "https://github.com/uben0/tree-sitter-typst"))
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(add-to-list 'auto-mode-alist '("\\.tpp\\'" . c++-ts-mode))

(use-package nix-ts-mode
  :mode "\\.nix\\'")
(use-package typst-ts-mode
  :mode "\\.typst\\'")

;; Temp flycheck stuff
(use-package flycheck
  :straight t
  :init (global-flycheck-mode))
(use-package quick-peek
  :straight t)
(use-package flycheck-inline
  :straight t)
(with-eval-after-load 'flycheck
  (add-hook 'flycheck-mode-hook #'flycheck-inline-mode))
(add-hook 'c++-mode-hook
          (lambda ()
            (setq flycheck-clang-language-standard "c++23")
            (setq flycheck-gcc-language-standard "c++23")))

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

(use-package atomic-chrome
  :demand t
  :straight (atomic-chrome
             :repo "KarimAziev/atomic-chrome"
             :type git
             :host github)
  :commands (atomic-chrome-start-server)
  :config
  (setq-default atomic-chrome-extension-type-list '(atomic-chrome))
  (setq atomic-chrome-buffer-open-style 'frame)
  (atomic-chrome-start-server))

;; Setting custom keybinds:
(defun previous-line-recenter ()
  "Move to the previous line, then recenter the cursor to the center of the screen."
  (interactive)
  (forward-line -1)
  (recenter))

(defun next-line-recenter ()
  "Move to the previous next, then recenter the cursor to the center of the screen."
  (interactive)
  (forward-line)
  (recenter))

(global-set-key (kbd "M-p") #'previous-line-recenter)
(global-set-key (kbd "M-n") #'next-line-recenter)
