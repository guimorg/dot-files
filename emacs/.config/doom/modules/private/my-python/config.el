;;; private/my-python/config.el -*- lexical-binding: t; -*-

(defvar +python-ipython-command '("ipython" "-i" "--simple-prompt" "--no-color-info")
  "Command to initialize the ipython REPL for `+python/open-ipython-repl'.")

(defvar +python-jupyter-command '("jupyter" "console" "--simple-prompt")
  "Command to initialize the jupyter REPL for `+python/open-jupyter-repl'.")

(after! projectile
  (pushnew! projectile-project-root-files "pyproject.toml" "requirements.txt" "setup.py"))

(use-package! python
  :mode ("[./]flake8\\'" . conf-mode)
  :mode ("/Pipfile\\'" . conf-mode)
  :init
  (setq python-environment-directory doom-cache-dir
        python-indent-guess-indent-offset-verbose nil)

  (add-hook 'python-mode-local-vars-hook #'lsp! 'append)
  ;; Use "mspyls" in eglot if in PATH
  (when (executable-find "Microsoft.Python.LanguageServer")
    (set-eglot-client! 'python-mode '("Microsoft.Python.LanguageServer")))

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

  ;; Stop the spam!
  (setq python-indent-guess-indent-offset-verbose nil)

  ;; Default to Python 3. Prefer the versioned Python binaries since some
  ;; systems link the unversioned one to Python 2.
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
        (setq-local flycheck-python-mypy-executable "mypy"))))

  (setq-hook! 'python-mode-hook tab-width python-indent-offset))

(add-hook! python-mode
  (advice-add 'python-pytest-file :before
              (lambda (&rest args)
                (setq python-pytest-executable (+python-executable-find "pytest")))))

(use-package! python-pytest
  :commands python-pytest-dispatch
  :init
  (map! :after python
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

(use-package! lsp-pyright
  :init
  (when (executable-find "basedpyright")
    (setq lsp-pyright-langserver-command "basedpyright")))

(with-eval-after-load 'lsp-mode
  (when (or (executable-find "ty") (executable-find "uvx"))
    (lsp-register-client
     (make-lsp-client
      :new-connection (lsp-stdio-connection
                       (lambda ()
                         (if (executable-find "ty")
                             '("ty" "server")
                           '("uvx" "ty" "server"))))
      :major-modes '(python-mode python-ts-mode)
      :server-id 'ty
      :priority 1
      :add-on? nil))
    
    (setq lsp-enabled-clients '(ty pyright))
    (add-to-list 'lsp-language-id-configuration '(python-mode . "python"))
    (add-to-list 'lsp-language-id-configuration '(python-ts-mode . "python"))))

(use-package! uv-mode
  :when (executable-find "uv")
  :hook (python-mode . uv-mode)
  :config
  (setq uv-mode-auto-activate t))

(defun +python/find-pyproject-root ()
  (or
   (locate-dominating-file default-directory "pyproject.toml")
   (and (fboundp 'projectile-project-root) (projectile-project-root))
   default-directory))

(defun +python/uv-sync ()
  (interactive)
  (let ((default-directory (+python/find-pyproject-root)))
    (compile "uv sync")))

(defun +python/uv-add (package)
  (interactive "sPackage name: ")
  (let ((default-directory (+python/find-pyproject-root)))
    (compile (format "uv add %s" package))))

(defun +python/uv-remove (package)
  (interactive "sPackage name: ")
  (let ((default-directory (+python/find-pyproject-root)))
    (compile (format "uv remove %s" package))))

(defun +python/uv-run (command)
  (interactive "sCommand: ")
  (let ((default-directory (+python/find-pyproject-root)))
    (compile (format "uv run %s" command))))

(defun +python/uv-lock ()
  (interactive)
  (let ((default-directory (+python/find-pyproject-root)))
    (compile "uv lock")))

(defun +python/uv-pip-compile ()
  (interactive)
  (let ((default-directory (+python/find-pyproject-root)))
    (compile "uv pip compile pyproject.toml -o requirements.txt")))

(map! :after python
      :localleader
      :map python-mode-map
      :prefix ("u" . "uv")
      "s" #'+python/uv-sync
      "a" #'+python/uv-add
      "r" #'+python/uv-remove
      "x" #'+python/uv-run
      "l" #'+python/uv-lock
      "c" #'+python/uv-pip-compile)
