;;; .emacs --- Initialization file for Emacs
;;; Commentary: Emacs Startup File --- initialization for Emacs

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("8966037be0ad554bbc8ceda50bb752493a711266e1e3562b23b462dd97cb6236" default))
 '(package-selected-packages
   '(general helpful ivy-rich counsel conusel diminish ivy which-key use-package smex rust-mode rainbow-delimiters quick-peek pdf-tools lsp-ui flycheck-rust flycheck-inline exec-path-from-shell cdlatex auctex)))
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

;; Theme
(load-theme 'kentaro-deeper-blue)
(setq fancy-splash-image "~/lib/emacs-butterfly.svg")

;; Don't make shell jump around.
(setq comint-scroll-show-maximum-output nil)

;; Initialize package sources
(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
;; Make it so that I don't have to use :ensure t for every package.
(setq use-package-always-ensure t)

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

;; Tie related commands into a family of short bindings with a prefix.
(use-package hydra)

(defhydra hydra-zoom ()
  "zoom"
  ("n" text-scale-increase "in")
  ("t" text-scale-decrease "out")
  ("RET" nil "done" :exit t))
(global-set-key (kbd "C-<return>") 'hydra-zoom/body)

(defhydra hydra-move (:foreign-keys warn :pre (set-cursor-color "#e52b50") :post (set-cursor-color "green"))
  "move"
  ("n" next-line)
  ("t" previous-line)
  ("e" forward-char)
  ("s" backward-char)
  ("i" forward-word)
  ("r" backward-word)
  ("a" move-beginning-of-line)
  ("o" move-end-of-line)
  ("SPC" set-mark-command "mark")
  ("w" kill-ring-save "copy")
  ("d" kill-region "cut")
  ("y" yank "yank")
  ("/" undo "undo")
  ("g" nil "done" :exit t))
(global-set-key  prog-mode-map (kbd "C-z") 'hydra-move/body)

(defhydra hydra-minibuffer-move ()
  ("n" ivy-next-line "next")
  ("t" ivy-previous-line "prev")
  ("g" nil "stop" :exit t))
(define-key ivy-minibuffer-map (kbd "C-z") 'hydra-minibuffer-move/body)

(defhydra hydra-buffer-menu (:foreign-keys run pink
                             :hint nil)
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
