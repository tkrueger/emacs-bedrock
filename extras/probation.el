;;; probation.el --- A collection of snippets trying to prove their value.

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

;; (use-package combobulate
;;   :custom
;;   ;; You can customize Combobulate's key prefix here.
;;   ;; Note that you may have to restart Emacs for this to take effect!
;;   (combobulate-key-prefix "C-c o")
;;   :hook ((prog-mode . combobulate-mode))
;;   ;; Amend this to the directory where you keep Combobulate's source
;;   ;; code.
;;   :load-path ("~/dev/combobulate"))

;;; probation.el ends here

;;;
;;; Polymode setup (for helmfiles)
;;;

(use-package mustache-mode
  :ensure t)

(use-package yaml-pro
  :ensure t)

(define-derived-mode my-yaml-wrapper-mode yaml-ts-mode "MyYAML"
  "My wrapper around \"yaml-ts-mode\", enabling customizations."

  ;; Call the parent mode (yaml-ts-mode) initialization already done by derive.
  ;; Now override/extend here.

  ;; Example: Override a keybinding
  (define-key my-yaml-wrapper-mode-map (kbd "C-c C-c") #'my-yaml-custom-command)

  ;; Example: Add a hook
  (add-hook 'after-save-hook #'my-yaml-after-save-hook nil t)
  )

(defun my-yaml-custom-command ()
  (interactive)
  (message "Custom command in my-yaml-wrapper-mode"))

(defun my-yaml-after-save-hook ()
  (when (eq major-mode 'my-yaml-wrapper-mode)
    (message "File saved in my-yaml-wrapper-mode!")))

(defun my-yaml-ts-yaml-pro--fast-parse-bounds (orig-fun &rest args)
  (message "Starting yaml-pro--fast-parse-bounds")
  (let ((result (apply orig-fun args)))
    (message "Finished yaml-pro--fast-parse-bounds")
    result))

(advice-add 'yaml-pro--fast-parse-bounds :around #'my-yaml-ts-yaml-pro--fast-parse-bounds)

(defun my-yaml-ts-parse-buffer-advice (orig-fun &rest args)
  (message "Starting yaml-ts-parse-buffer")
  (let ((result (apply orig-fun args)))
    (message "Finished yaml-ts-parse-buffer")
    result))

(advice-add 'yaml-ts-parse-buffer :around #'my-yaml-ts-parse-buffer-advice)

(defun my-yaml-pro-ts-down-level (orig-fun &rest args)
  (message "Starting yaml-pro-ts-down-level")
  (message "tree is:")
  (let ((result (apply orig-fun args)))
    (message "Finished yaml-pro-ts-down-level")
    (message "result is %S" result)
    (pp result)
    (message "result above")
    result))

(advice-add 'yaml-pro-ts-down-level :around #'my-yaml-pro-ts-down-level)

(use-package polymode
  :ensure t
  ;;:mode ("\.py$" . poly-python-sql-mode)
  :config
  (setq polymode-prefix-key (kbd "C-c n"))
  (define-hostmode poly-yaml-hostmode
    ;;:mode 'yaml-ts-mode
    :mode 'my-yaml-wrapper-mode
    )

  (define-innermode poly-mustache-expr-innermode
    :mode 'mustache-mode
    :head-matcher "{{"
    :tail-matcher "}}"
    :head-mode 'body
    :tail-mode 'body
    :protect-syntax t
    :protect-font-lock t
    :adjust-face nil)

  (define-polymode poly-helm-yaml-mode
    :hostmode 'poly-yaml-hostmode
    :innermodes '(poly-mustache-expr-innermode))

  

  (defun fixed-mustace-block-end   (ahead)
    (message "fixed start called")
    (cons 100 100))
  (defun fixed-mustace-block-start (ahead) (cons 10 10))
  
  (defun last-mustache-block-end (ahead)
    (if (re-search-backward "}}" nil t)
	(progn
	  (message "last-mustache-block-end found %s %s" 10 10)
	  (cons (match-beginning 0) (match-end 0))
	  )
      (progn
	(message "last-mustache-block-end returns 0 0")
	(cons 0 0))))
  
  (defun next-mustache-block-start (ahead)
    (if (re-search-forward "{{" nil t)
	(progn
	  (message "next-mustache-block-start found next mustache block %s %s" 0 0)
	  (cons (match-beginning 0) (match-end 0)))
      (progn
	(message "next-mustache-block-start resturns default %s %s" (point-max) (point-max))
	(cons (point-max) (point-max)))))

  (defun my-non-mustache-head-matcher (ahead)
    (if (> ahead 0)
	(let ((p
	       ;; TODO if we have no end before us, but a beginning in front of us,
	       ;; we're in the first block. But this seems to hang up the code, dunno why
	       (when (re-search-forward "}}" nil t)
		 (cons (match-beginning 0) (match-end 0)))))
	  (message "head called at %s with  %s : %s" (point) ahead p)
	  p)
      (let ((p
	     (when(re-search-backward "}}" nil t)
	       (cons (match-beginning 0) (match-end 0)))))
	(message "head called at %s with %s : %s" (point) ahead p)
	p)
      ))

  (defun my-non-mustache-tail-matcher (ahead)
    (if (> ahead 0)
	(when (re-search-forward "{{" nil t)
	  (cons (- (match-beginning 0) 1) (- (match-beginning 0) 1))
	  (when (re-search-backward "{{" nil t)
	    (cons (- (match-beginning 0) 1) (- (match-beginning 0) 1))))
      ))

  (define-hostmode poly-yaml-2-hostmode
    ;;:mode 'yaml-ts-mode
    :mode 'fundamental-mode
    )
  
  (define-innermode poly-yaml-2-yaml-innermode
    :mode 'yaml-ts-mode
    :head-matcher #'my-non-mustache-head-matcher
    :tail-matcher #'my-non-mustache-tail-matcher
    :head-mode 'host
    :tail-mode 'host)

  (define-polymode poly-yaml-2-mode
    :hostmode 'poly-yaml-2-hostmode
    :innermodes '(poly-mustache-expr-innermode poly-yaml-2-yaml-innermode))
  )



