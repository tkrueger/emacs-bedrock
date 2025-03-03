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

(use-package combobulate
  :custom
  ;; You can customize Combobulate's key prefix here.
  ;; Note that you may have to restart Emacs for this to take effect!
  (combobulate-key-prefix "C-c o")
  :hook ((prog-mode . combobulate-mode))
  ;; Amend this to the directory where you keep Combobulate's source
  ;; code.
  :load-path ("~/dev/combobulate"))

;;; probation.el ends here

