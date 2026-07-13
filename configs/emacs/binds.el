;; Dired binds
(progn
  (require 'dired)
  (define-key dired-mode-map (kbd "T") #'dired-create-empty-file))
