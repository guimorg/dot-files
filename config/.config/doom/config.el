;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Guilherme de Amorim"
      user-mail-address "ggimenezjr@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 14 :weight 'semi-light)
     ;; doom-variable-pitch-font (font-spec :family "Alegreya" :size 13)
     )
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Projectile Config
(setq projectile-project-search-path '("~/projects/work" "~/projects/oss"))

;; (flycheck-define-checker python-ruff
;;   "A Python syntax and style checker using Ruff."
;;   :command ("ruff" "fix" source)
;;   :error-patterns
;;   ((error line-start (file-name) ":" line ":" (message) line-end))
;;   :modes python-mode)
;; (add-to-list 'flycheck-checkers 'python-ruff)

;; (after! flycheck
;;   (setq flycheck-python-ruff-executable "ruff")  ; Ensure the path is correct
;;   (require 'flycheck-ruff)  ; Assuming you have a flycheck-ruff package or similar
;;   (flycheck-add-next-checker 'python-flake8 'python-ruff))

;; (after! python
;;   ;; Disable or adjust hooks that setup isort, black, etc.
;;   (remove-hook 'python-mode-hook #'pyimport-mode)
;;   (remove-hook 'python-mode-hook #'blacken-mode))

;; Disable exit confirmation
(setq confirm-kill-emacs nil)

;; Better buffer management
(map! "C-x b"   #'counsel-buffer-or-recentf
      "C-x C-b"  #'counsel-switch-buffer)
(defun zz/counsel-buffer-or-recentf-candidates ()
  "Return candidates for `counsel-buffer-or-recentf'."
  (require 'recentf)
  (recentf-mode)
  (let ((buffers
         (delq nil
               (mapcar (lambda (b)
                         (when (buffer-file-name b)
                           (abbreviate-file-name (buffer-file-name b))))
                       (delq (current-buffer) (buffer-list))))))
    (append
     buffers
     (cl-remove-if (lambda (f) (member f buffers))
                   (counsel-recentf-candidates)))))

(advice-add #'counsel-buffer-or-recentf-candidates
            :override #'zz/counsel-buffer-or-recentf-candidates)

(use-package! switch-buffer-functions
  :after recentf
  :preface
  (defun my-recentf-track-visited-file (_prev _curr)
    (and buffer-file-name
         (recentf-add-file buffer-file-name)))
  :init
  (add-hook 'switch-buffer-functions #'my-recentf-track-visited-file))

;; Docker
;; (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
;; (put 'dockerfile-image-name 'safe-local-variable #'stringp)
;; (defun plain-pipe-for-process () (setq-local process-connection-type nil))
;; (add-hook 'compilation-mode-hook 'plain-pipe-for-process)

;; Flycheck
(after! flycheck
  (setq-default flycheck-disabled-checkers
                '(
                  python-pylint python-flake8
                  )))
