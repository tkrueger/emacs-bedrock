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
  (add-hook 'before-save-hook 'eglot-format-buffer))

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
