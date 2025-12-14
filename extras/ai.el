;;; ai --- Ai Interfaces for Emacs
;;;

;;;
;;; gptel: A simple LLM client for Emacs
;; See https://github.com/karthink/gptel
;;;

(use-package gptel
  :ensure t)

;;;
;;; gptel ollama models
;;; These require you to install ollama and install some models:
;;; > ollama serve
;;; > ollama add mistal:latest
;;;
;;; See https://docs.ollama.com/
;;;

(gptel-make-ollama "Ollama"             ;Any name of your choosing
  :host "localhost:11434"               ;Where it's running
  :stream t                             ;Stream responses
  :models '(mistral:latest))            ;List of models

(use-package ellama
  :ensure t
  :bind ("C-c e" . ellama)
  :init (setopt ellama-auto-scroll t)
  :config
  ;; show ellama context in header line in all buffers
  (ellama-context-header-line-global-mode +1)
  ;; show ellama session id in header line in all buffers
  (ellama-session-header-line-global-mode +1))
