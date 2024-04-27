;;; private/my-python/config.el -*- lexical-binding: t; -*-
(defvar +python-ipython-command '("ipython" "-i" "--simple-prompt" "--no-color-info")
  "Command to initialize the ipython REPL for `+python/open-ipython-repl'.")

(defvar +python-jupyter-command '("jupyter" "console" "--simple-prompt")
  "Command to initialize the jupyter REPL for `+python/open-jupyter-repl'.")

(after! projectile
  (pushnew! projectile-project-root-files "pyproject.toml" "requirements.txt" "setup.py"))

(use-package! python
  :init
  (setq python-environment-directory doom-cache-dir
        python-indent-guess-indent-offset-verbose nil)

  (add-hook 'python-mode-local-vars-hook #'lsp! 'append)
  (add-hook 'python-mode-local-vars-hook #'tree-sitter! 'append)

  :config
  (set-repl-handler! 'python-mode #'+python/open-repl
    :persist t
    :send-region #'python-shell-send-region
    :send-buffer #'python-shell-send-buffer)
  (set-docsets! '(python-mode inferior-python-mode) "Python 3" "NumPy" "SciPy" "Pandas")
  (set-ligatures! 'python-mode
    ;; Functional
    :def "def"
    :lambda "lambda"
    ;; Types
    :null "None"
    :true "True" :false "False"
    :int "int" :str "str"
    :float "float"
    :bool "bool"
    :tuple "tuple"
    ;; Flow
    :not "not"
    :in "in" :not-in "not in"
    :and "and" :or "or"
    :for "for"
    :return "return" :yield "yield")

  ;; ;; Stop the spam!
  ;; (setq python-indent-guess-indent-offset-verbose nil)
  (when (and (executable-find "python3")
             (string= python-shell-interpreter "python"))
    (setq python-shell-interpreter "python3"))

  (add-hook! 'python-mode-hook
    (defun +python-use-correct-flycheck-executables-h ()
      "Use the correct Python executables for Flycheck."
      (let ((executable python-shell-interpreter))
        (save-excursion
          (goto-char (point-min))
          (save-match-data
            (when (or (looking-at "#!/usr/bin/env \\(python[^ \n]+\\)")
                      (looking-at "#!\\([^ \n]+/python[^ \n]+\\)"))
              (setq executable (substring-no-properties (match-string 1))))))
        ;; Try to compile using the appropriate version of Python for
        ;; the file.
        (setq-local flycheck-python-pycompile-executable executable)
        ;; We might be running inside a virtualenv, in which case the
        ;; modules won't be available. But calling the executables
        ;; directly will work.
	(setq-local flycheck-python-ruff-executable "ruff")
	(setq-local flycheck-python-mypy-executable "mypy")
        )))

  (advice-add #'pythonic-activate :after-while #'+modeline-update-env-in-all-windows-h)
  (advice-add #'pythonic-deactivate :after #'+modeline-clear-env-in-all-windows-h)
  (setq-hook! 'python-mode-hook tab-width python-indent-offset))

(use-package! python-pytest
  :commands python-pytest-dispatch
  :init
  (map! ;;:after python
        :localleader
        :map python-mode-map
        :prefix ("t" . "test")
        "a" #'python-pytest
        "f" #'python-pytest-file-dwim
        "F" #'python-pytest-file
        "t" #'python-pytest-function-dwim
        "T" #'python-pytest-function
        "r" #'python-pytest-repeat
        "p" #'python-pytest-dispatch))

(defun projectile-pyenv-mode-set ()
  "Set pyenv version matching project name."
  (let ((project (projectile-project-name)))
    (if (member project (pyenv-mode-versions))
        (pyenv-mode-set project)
      (pyenv-mode-unset))))

(add-hook 'projectile-after-switch-project-hook 'projectile-pyenv-mode-set)

(use-package! pyenv-mode
  ;; :after python
  :config
  (when (executable-find "pyenv")
    (pyenv-mode +1)
    (add-to-list 'exec-path (expand-file-name "shims" (or (getenv "PYENV_ROOT") "~/.pyenv"))))
  (add-hook 'python-mode-local-vars-hook #'+python-pyenv-mode-set-auto-h)
  (add-hook 'doom-switch-buffer-hook #'+python-pyenv-mode-set-auto-h)
)

  (use-package! lsp-pyright
    :init
    :after lsp-mode)
