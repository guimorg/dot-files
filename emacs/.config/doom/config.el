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
(setq org-directory "~/private/Org")


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
(setq projectile-project-search-path '("~/projects/work" "~/projects/work/wander" "~/projects/oss"))

;; gp
(setq epg-gpg-program "gpg2")

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

(use-package! wakatime-mode)
(global-wakatime-mode)

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

;; LSP
(setq lsp-pyright-multi-root nil)
(setq lsp-keep-workspace-alive nil)
(setq lsp-idle-delay 1)
(setq lsp-ui-doc-delay 1)
(setq lsp-enable-snippet nil)
(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]worktrees]]'" t))

;; all the icons
(use-package! all-the-icons
  :if (display-graphic-p))

;; dired
(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file" "d v" #'dired-view-file)))

(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-find-file
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "K") 'dired-goto-file
  (kbd "M") 'dired-do-chmod
  (kbd "O") 'dired-do-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-do-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filename-as-kill
  (kbd "Z") 'dired-do-compress
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-do-kill-lines
  (kbd "% l") 'dired-downcase
  (kbd "% m") 'dired-mark-files-regexp
  (kbd "% u") 'dired-upcase
  (kbd "* %") 'dired-mark-files-regexp
  (kbd "* .") 'dired-mark-extension\
  (kbd "* /") 'dired-mark-directories
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(setq delete-by-moving-to-trash t
      trash-directory "~/.Trash")
