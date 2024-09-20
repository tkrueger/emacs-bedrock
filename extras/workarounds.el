;; Extra config: Workarounds for broken things
;;
;; Contents:
;;
;;  - Projectile

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Projectile
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; In Projectile, the globally ignored directories where changed to
;; regexes. This is suppoted in projectile, but breaks when passed on to
;; ripgrep. One of the possible workarounds is to replace them with the original
;; glob values. After all, rg doesn't support regexes.
;; Either way, one loses out on a bit of functionality. Since I don't use regexes,
;; I'm going the way of globs.
;;
;; see https://github.com/bbatsov/projectile/issues/1777
;; see https://github.com/bbatsov/projectile/issues/1811
(setq projectile-globally-ignored-directories
      '(".idea"
	".vscode"
	".ensime_cache"
	".eunit"
	".git"
	".hg"
	".fslckout"
	"_FOSSIL_"
	".bzr"
	"_darcs"
	".tox"
	".svn"
	".stack-work"
	".ccls-cache"
	".cache"
	".clangd"))
