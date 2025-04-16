;; 36:44

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
   '(ivy-rich counsel conusel diminish ivy which-key use-package smex rust-mode rainbow-delimiters quick-peek pdf-tools lsp-ui flycheck-rust flycheck-inline exec-path-from-shell cdlatex auctex)))
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
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done))
  :config
  (ivy-mode))

(use-package counsel
  :diminish
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
  :diminish which-key-mode
  :custom
  (which-key-idle-delay 0.6)
  :config
  (which-key-setup-side-window-right)
  (which-key-mode))
