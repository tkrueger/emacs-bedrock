;;; Extra config: Clojure Development tools -*- lexical-binding: t; -*-

;;; Usage: Append or require this file from init.el for some software
;;; development-focused packages.

;;; Contents:
;;;
;;;  - Clojure mode
;;;  - cider
;;;  - kaocha-runner


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Clojure mode
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo)
  (setq clojure-toplevel-inside-comment-form t)
  (add-hook 'before-save-hook 'eglot-format-buffer)
  ;; eglot's semantic-tokens highlighting maps clojure-lsp's LSP token types
  ;; onto a handful of generic faces, which fights with clojure-mode's own
  ;; (much more syntax-aware) font-lock rules for keywords, docstrings, etc.
  ;; It only turns on once the server's `initialize' request completes
  ;; asynchronously, so a buffer looks fine at first and is then
  ;; re-fontified out from under you. `eglot-managed-mode-hook' runs right
  ;; after that happens (on every connect/reconnect), so turn it back off
  ;; there rather than trying to preempt it earlier.
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (when (derived-mode-p 'clojure-mode)
                (eglot-semantic-tokens-mode -1)))))

(use-package rainbow-delimiters
  :ensure t
  :hook (emacs-lisp-mode clojure-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Cider, providing emacs REPL integration
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Force a fixed asdf java version for Cider/nREPL, regardless of what a
;; given project's .tool-versions pins (which may reference a version that
;; isn't installed locally, breaking `cider-jack-in').
(setenv "ASDF_JAVA_VERSION" "temurin-25.0.1+8.0.LTS")

(use-package cider
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Kaocha, full-fledged test runner
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package kaocha-runner
  :ensure t
  :bind (:map clojure-mode-map
              ("C-c k t" . kaocha-runner-run-test-at-point)
              ("C-c k r" . kaocha-runner-run-tests)
              ("C-c k a" . kaocha-runner-run-all-tests)
              ("C-c k w" . kaocha-runner-show-warnings)
              ("C-c k h" . kaocha-runner-hide-windows)))
