;;; -*- lexical-binding: t; -*-

;; Dired
(progn
  (require 'dired)
  (define-key dired-mode-map (kbd "T") #'dired-create-empty-file))

;; Company
(add-hook 'prog-mode-hook 'company-mode)
(with-eval-after-load 'company
  (define-key company-mode-map (kbd "M-p") #'company-complete))
