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
;;; probation.el ends here
