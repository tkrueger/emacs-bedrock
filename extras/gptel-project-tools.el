;;; gptel-project-tools.el --- Project navigation tools for gptel -*- lexical-binding: t; -*-
;;;
;;;
;;; Commentary:
;;;
;;; This was created by chatgpt to play around with when using gptel. It provides
;;; functions that the LLMs can use.
;;;
;;; Code:
;;;

(require 'gptel)
(require 'project)

;; --- Helpers ---------------------------------------------------------

(defun gptel-pt--root ()
  "Return the current project root or error."
  (or (cdr (project-current))
      (user-error "No project detected")))

(defun gptel-pt--expand (path)
  "Expand PATH relative to project root."
  (expand-file-name path (gptel-pt--root)))

;; --- Tools -----------------------------------------------------------

(defun gptel-pt-list-files ()
  "List all files in the project (relative paths)."
  (let ((root (gptel-pt--root)))
    (mapcar (lambda (f) (file-relative-name f root))
            (project-files (project-current)))))

(defun gptel-pt-list-files-filtered (pattern)
  "List project files matching PATTERN (regexp)."
  (let ((root (gptel-pt--root)))
    (seq-filter
     (lambda (f) (string-match-p pattern f))
     (mapcar (lambda (f) (file-relative-name f root))
             (project-files (project-current))))))

(defun gptel-pt-read-file (path)
  "Read entire file PATH inside project."
  (let ((full (gptel-pt--expand path)))
    (with-temp-buffer
      (insert-file-contents full)
      (buffer-string))))

(defun gptel-pt-read-chunk (path start end)
  "Read part of a large file at PATH from START to END."
  (let ((full (gptel-pt--expand path)))
    (with-temp-buffer
      (insert-file-contents full nil start end)
      (buffer-string))))

(defun gptel-pt-search (pattern)
  "Search all project files for PATTERN (regexp).
Returns list of matching (path . line)."
  (let ((root (gptel-pt--root))
        (files (project-files (project-current)))
        results)
    (dolist (f files)
      (with-temp-buffer
        (insert-file-contents f)
        (goto-char (point-min))
        (while (re-search-forward pattern nil t)
          (let ((line (line-number-at-pos)))
            (push (cons (file-relative-name f root) line) results)))))
    results))

(defun gptel-pt-summarize-project ()
  "Generate short summaries (first ~200 lines) per project file.
Useful as an index for the model."
  (let* ((proj (project-current))
         (root (cdr proj)))
    (mapcar
     (lambda (f)
       (let* ((rel (file-relative-name f root)))
         (cons rel
               (with-temp-buffer
                 (insert-file-contents f nil 0 5000) ;; ~5k chars
                 (buffer-string)))))
     (project-files proj))))

;; --- Register tools for gptel ---------------------------------------

(gptel-make-tool
 :name "list_files"
 :description "List all project files"
 :args ()
 :function 'gptel-pt-list-files
 :category "project")

(gptel-make-tool
 :name "list_files_filtered"
 :description "List project files matching a regexp"
 :args (list '(:name pattern :type string :description "search pattern"))
 :function 'gptel-pt-list-files-filtered)

(gptel-make-tool
 :name "read_file"
 :description "Read file contents from project root"
 :agrs '(list (:name path :type string :description "Path to file"))
 :function 'gptel-pt-read-file)

(gptel-make-tool
 :name "read_chunk"
 :description "Read part of a file"
 :args '(List (:name path :type string :description "Chunk name")
	      (:name start :type integer :description "Start location")
	      (:name end  :type integer :description "End location"))
 :function 'gptel-pt-read-chunk)

(gptel-make-tool
 :name "search"
 :description "Search for a regexp across project files"
 :args '(list (:name pattern :type string :description "Search pattern"))
 :function 'gptel-pt-search)

(gptel-make-tool
 :name "summarize_project"
 :description "Return summaries of all project files"
 :args ()
 :function 'gptel-pt-summarize-project)

(provide 'gptel-project-tools)
;;; gptel-project-tools.el ends here
