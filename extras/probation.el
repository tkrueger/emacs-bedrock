;;; probation.el --- A collection of snippets trying to prove their value. -*- lexical-binding: t; -*-

;;; Commentary:

;;; A collection of snippets trying to prove their value.

;;; Code:

;;;
;;; Smart move to beginning of line
;;; Will toggle between beginning of line and first non-whitespace character
;;;

(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.

Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line."
  (interactive)
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line))))

(global-set-key [home] 'smart-beginning-of-line)
(global-set-key "\C-a" 'smart-beginning-of-line)

(provide 'probation.el)

;;;
;;; Frame Title
;;;

;; stolen from prelude
;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '("" invocation-name
	" Prelude - "
	(:eval (if (buffer-file-name)
		   (abbreviate-file-name (buffer-file-name))
		 "%b"))))

;;;
;;; Combobulate
;;;

(use-package combobulate
  :custom
  ;; You can customize Combobulate's key prefix here.
  ;; Note that you may have to restart Emacs for this to take effect!
  (combobulate-key-prefix "C-c o")
  :hook ((prog-mode . combobulate-mode))
  ;; Amend this to the directory where you keep Combobulate's source
  ;; code.
  :load-path ("~/dev/combobulate"))

;;;
;;; helm-ts-mode
;;;

;;(setq treesit-extra-load-path '("/usr/local/lib"))
(treesit-language-available-p 'helm)

(define-derived-mode helm-ts-mode prog-mode "helm-ts"
  "A mode for helm yaml files."
  (when (treesit-ready-p 'helm)
    (treesit-parser-create 'helm)
    (helm-ts-mode--setup)))

(defun helm-ts-mode--setup ()
  "Setup treesit for helm-ts mode."
  (setq-local treesit-font-lock-feature-list
              '((string)
		(name)
		(selector-symbol)))
  (setq-local treesit-font-lock-settings
              (apply #'treesit-font-lock-rules
                     helm-ts-font-lock-rules))
  (treesit-major-mode-setup))

(defvar helm-ts-font-lock-rules
  '(
    :language helm
    :override t
    :feature delimiter
    (["<" ">" "/>" "</"] @font-lock-bracket-face)

    :language helm
    :override t
    :feature string
    ((pair value: (_) @font-lock-string-face)
     ((string) @font-lock-string-face))

    :language helm
    :override t
    :feature name
    ((pair key: (_) @font-lock-function-name-face))

    ;; TODO the key part of this cannot be selected. Introduce "key" child to select all those?
    :language helm
    :override t
    :feature selector-symbol
    ((io_k8s_apimachinery_pkg_apis_meta_v1_labelselectorrequirement_key (string) @font-lock-symbol-face))
    ))


;;;
;;; Trying out helm-lsp
;;;

;; ...ensure that your package manager of choice is setup before
;; installing packages, and then

;; Install yaml-mode
(use-package yaml-ts-mode
  :ensure t)

;; Create a derived major-mode based on yaml-mode
(define-derived-mode helm-mode yaml-ts-mode "helm"
  "Major mode for editing kubernetes helm templates")

(use-package eglot
					; Any other existing eglot configuration plus the following:
  :hook
					; Run eglot in helm-mode buffers
  (helm-mode . eglot-ensure)
  :config
					; Run `helm_ls serve` for helm-mode buffers
  (add-to-list 'eglot-server-programs '(helm-mode "helm_ls" "serve")))


(use-package lsp-mode
  :ensure t)


;;; probation.el ends here

