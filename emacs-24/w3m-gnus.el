;; w3m-gnus.el
;;
;; as posted to gnu.emacs.help by John Wiegley <johnw@gnu.org> and
;; fixed by greg@visiontech-dml.com 
;;
;; Message-ID: <2fasnftcpt4.fsf@broadcom.com>
;;
(require 'w3m)

(defvar gnus-w3m-minor-mode nil)

(make-variable-buffer-local 'gnus-w3m-minor-mode)
(add-to-list 'minor-mode-alist '(gnus-w3m-minor-mode " w3m"))
(add-to-list 'minor-mode-map-alist (cons 'gnus-w3m-minor-mode w3m-mode-map))

(defadvice mm-inline-text (around use-w3m-instead (handle) activate)
  (let ((type (mm-handle-media-subtype handle)))
    (if (not (equal type "html"))
        ad-do-it
      (let ((text (mm-get-part handle))
            (b (point)))
        (save-excursion
          (insert text)
          (save-restriction
            (narrow-to-region b (point))
            (goto-char (point-min))
            (w3m-region (point-min) (point-max))
           (setq gnus-w3m-minor-mode t))
          (mm-handle-set-undisplayer
           handle
           `(lambda ()
              (let (buffer-read-only)
               (setq gnus-w3m-minor-mode nil)
                (if (functionp 'remove-specifier)
                    (mapcar (lambda (prop)
                              (remove-specifier
                               (face-property 'default prop)
                               (current-buffer)))
                            '(background background-pixmap foreground)))
                (delete-region ,(point-min-marker)
                               ,(point-max-marker))))))))))
