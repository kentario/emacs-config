(menu-bar-mode -1)
(set-scroll-bar-mode 'right)
(tool-bar-mode -1)
(blink-cursor-mode -1)

(column-number-mode 1)
(indent-according-to-mode)
(display-time)

(ido-mode 1)
;; Don't jump to a different directory when creating a new file, or mistyping a filename.
(setq ido-auto-merge-work-directories-length -1)

;; Initialize package.el
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
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

;; Eventually this will not be needed as vc-use-package has been merged into emacs.
(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))

(require 'vc-use-package)

;; Makes opening new buffers happen in the current window.
(use-package current-window-only
  :vc (current-window-only
       :fetcher github
       :repo "FrostyX/current-window-only")
  :config (current-window-only-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(kentaro-deeper-blue))
 '(custom-safe-themes
   '("8966037be0ad554bbc8ceda50bb752493a711266e1e3562b23b462dd97cb6236" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(fancy-splash-image "~/lib/emacs-butterfly.svg")
 '(package-selected-packages
   '(quick-peek spacemacs-theme flycheck-inline use-package flycheck smex))
 '(package-vc-selected-packages
   '((vc-use-package :vc-backend Git :url "https://github.com/slotThe/vc-use-package"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

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

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-x C-e") 'compile)
(global-set-key (kbd "C-x '") 'next-error)
(global-set-key (kbd "C-x \"") 'previous-error)
(global-set-key (kbd "C-x O") (lambda () (interactive) (other-window -1)))
(global-set-key (kbd "C-x C-/") 'comment-region)
(global-set-key (kbd "C-x C-\\") 'uncomment-region)
(global-set-key (kbd "C-x %") (lambda () (interactive) (enlarge-window -1)))

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
