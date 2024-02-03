(autoload 'epa-list-keys "epa")

(autoload 'epa-dired-mode-hook "epa-dired")
(add-hook 'dired-mode-hook 'epa-dired-mode-hook)

(require 'epa-file)
(epa-file-enable)

(provide 'epa-setup)

;;; epa-setup.el ends here