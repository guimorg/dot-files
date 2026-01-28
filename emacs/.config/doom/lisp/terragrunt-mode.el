;;; terragrunt-mode.el

;; to use terragrunt-mode, save this file to $DOOMDIR/lisp/terragrunt-mode.el, add this line to your $DOOMDIR/config.el:
;;
;; (load! "lisp/terragrunt-mode.el")

(require 'hcl-mode) ; for highlighting and such
(require 'transient) ; for clean, easy menus for common operations
(require 'project) ; for looking for files in the current project

(define-derived-mode terragrunt-mode hcl-mode "Terragrunt"
  "Major mode for editing terragrunt files.")

(after! format
  (set-formatter! 'terragrunt-fmt
    '("terragrunt" "hcl" "fmt" "--stdin")
    :modes '(terragrunt-mode)))

(add-to-list 'auto-mode-alist '("terragrunt\\(?:\\.stack\\)?\\.hcl\\'" . terragrunt-mode))

(defun tg-mode/generate-stack ()
  "Locate the parent terragrunt.stack.hcl and run 'terragrunt stack generate'.
Reverts the current buffer if the file on disk was modified by the command."
  (let* ((origin-buffer (current-buffer)))
    (when-let* ((stack-dir (locate-dominating-file default-directory "terragrunt.stack.hcl"))
                (default-directory stack-dir)) ;; Temporarily switch to stack root
      (message "Found stack config. Generating stack in %s..." stack-dir)
      ;; Run synchronously so it finishes before the next command
      (let ((exit-code (call-process-shell-command "terragrunt stack generate" nil "*Terragrunt Stack Gen*" t)))
        (if (eq exit-code 0)
            (progn
              (message "Stack generation successful.")
              ;; Switch back to the original buffer context
              (with-current-buffer origin-buffer
                ;; Check if the file on disk has changed (modtime mismatch)
                (unless (verify-visited-file-modtime)
                  (revert-buffer nil t) ;; nil=ignore auto-save, t=no confirmation
                  (message "Re-reading file after stack generation."))))
          (error "Terragrunt stack generation failed. Check *Terragrunt Stack Gen* buffer."))))))

(defun tg-mode/open-stack ()
  "Locate the parent terragrunt.stack.hcl and run 'terragrunt stack generate'.
Reverts the current buffer if the file on disk was modified by the command."
  (interactive)
  (let* ((origin-buffer (current-buffer)))
    (when-let* ((stack-dir (locate-dominating-file default-directory "terragrunt.stack.hcl"))
                (default-directory stack-dir)) ;; Temporarily switch to stack root
      (message "Found stack config. Generating stack in %s..." stack-dir)
      ;; Run synchronously so it finishes before the next command
      (find-file (file-relative-name "terragrunt.stack.hcl" stack-dir)))))

(defun tg-mode/terragrunt-run (command &rest rest)
  "Run a terragrunt command with the flags currently active in the transient menu.
If -G is active, generate the stack first."
  (when (buffer-file-name)
    (save-buffer))
  (interactive)
  (let* ((args (transient-args 'tg-mode/terragrunt-menu))
         ;; Check if our special meta-flag is present
         (generate-stack-p (member ":generate-stack" args))
         ;; Remove the meta-flag so it is NOT passed to the shell command
         (cli-args (remove ":generate-stack" args))
         (full-cmd (format "terragrunt %s %s %s"
                           command
                           (mapconcat #'identity cli-args " ")
                           (mapconcat #'identity rest " "))))
    (when generate-stack-p
      (tg-mode/generate-stack))
    (compile full-cmd t)))

(transient-define-prefix tg-mode/terragrunt-menu ()
  "Terragrunt Dispatch Menu"
  ["Terragrunt Flags"
   ("-u" "Update Source" "--source-update")
   ("-n" "Non-Interactive" "--non-interactive")
   ("-d" "Debug Logging" "--log-level debug")
   ("-a" "All units" "--all")
   ("-G" "Generate Stack" ":generate-stack")]

  ["Terraform Flags"
   ("-y" "Auto Approve" "-auto-approve")
   ("-r" "Reconfigure" "-reconfigure")
   ("-u" "init upgrade" "-upgrade")]

  ["Commands"
   ("a" "Apply" (lambda () (interactive) (tg-mode/terragrunt-run "apply")))
   ("p" "Plan" (lambda () (interactive) (tg-mode/terragrunt-run "plan")))
   ("i" "Init" (lambda () (interactive) (tg-mode/terragrunt-run "init")))
   ("v" "Validate" (lambda () (interactive) (tg-mode/terragrunt-run "validate")))])


(defun tg-mode/terragrunt-list-dependencies ()
  "Run 'terragrunt find', show results in a selection menu, and open the chosen file."
  (interactive)
  (message "Fetching dependencies...")
  (let* ((cmd "terragrunt find --external --dependencies --include")
         (output (string-trim (shell-command-to-string cmd)))
         (paths (split-string output "\n" t)))

    (if (null paths)
        (message "No dependencies found.")
      (let ((selected-file (completing-read "Open dependency: " paths)))
        (when selected-file
          (find-file (expand-file-name "terragrunt.hcl" selected-file)))))))

(defun tg-mode/remove-terragrunt-cache ()
  "Delete the .terragrunt-cache directory in the current buffer's directory."
  (interactive)
  (let ((cache-dir (expand-file-name ".terragrunt-cache" default-directory)))
    (if (not (file-exists-p cache-dir))
        (message "No .terragrunt-cache found here.")
      ;; Prompt for confirmation before deleting recursively
      (when (y-or-n-p (format "Recursively delete %s? " cache-dir))
        (delete-directory cache-dir t nil) ;; 't' for recursive
        (message "Cache deleted.")))))

(defun tg-mode/add-dependency ()
  "Search project for terragrunt.hcl files, select one, and insert a dependency block.
Calculates the relative path from current buffer to the target."
  (interactive)
  (let* ((root (or (vc-root-dir)
                   (locate-dominating-file default-directory ".git")
                   default-directory))
         (candidates (split-string (shell-command-to-string (format "terragrunt find --working-dir %s" root)) "\n" t)))
    (if (null candidates)
        (message "No terragrunt files found in project.")
      (let* ((target-dir (completing-read "Select dependency target: " candidates))
             (abs-target-dir (expand-file-name target-dir root))
             ;; Calculate config_path relative to current buffer
             (rel-path (replace-regexp-in-string "\\.\\./" "" (file-relative-name abs-target-dir default-directory)))
             ;; Use the folder name as the dependency name (e.g., "vpc")
             (dep-name (file-name-nondirectory (directory-file-name target-dir))))

        ;; Move to a new line if not on one
        (unless (bolp) (newline))
        (insert (format "dependency \"%s\" {\n  config_path = find_in_parent_folders(\"%s\")\n}\n"
                        dep-name
                        rel-path))
        ;; Try to indent the inserted region
        (indent-region (line-beginning-position -2) (point))
        (message "Added dependency '%s'" dep-name)))))

(defun tg-mode/terragrunt-check-output ()
  "Execute 'terragrunt output' for one of the dependencies of the currently selected terragrunt.hcl file
From there, the output can easily be copied into a mock_outputs block, if needed"
  (interactive)
  (let* ((output (string-trim (shell-command-to-string "terragrunt find --external --dependencies")))
         (paths (split-string output "\n" t)))
    (if (null paths)
        (message "No dependencies found.")
      (let ((selected-file (completing-read "Open dependency: " paths)))
        (when selected-file
          (tg-mode/terragrunt-run "--log-level error" "output" "--working-dir" (expand-file-name selected-file default-directory)))))))


(after! flycheck
  (flycheck-define-checker terragrunt-validate
    "A custom syntax checker for Terragrunt, based off of the `terragrunt validate` command."
    :command ("terragrunt" "hcl" "validate" "--json" "--log-level" "stderr")
    :predicate (lambda () (and (buffer-file-name) (string-match-p "terragrunt\\.hcl$" (buffer-file-name))))
    :error-parser (lambda (output checker buffer)
                    (if (string-match "\\[" output)
                        ;; Extract content starting from the first '[' to ignore preamble logs
                        (let* ((json-str (substring output (match-beginning 0)))
                               ;; Parse JSON into Hash Tables for easier access
                               (errors (json-parse-string json-str
                                                          :object-type 'hash-table
                                                          :array-type 'list)))
                          (mapcar (lambda (err)
                                    (let* ((range (gethash "range" err))
                                           (start (gethash "start" range))
                                           (end (gethash "end" range))
                                           (sev (pcase (gethash "severity" err)
                                                  ("error" 'error)
                                                  ("warning" 'warning)
                                                  (_ 'info))))
                                      (flycheck-error-new-at
                                       (gethash "line" start)
                                       (gethash "column" start)
                                       sev
                                       (format "%s: %s" (gethash "summary" err) (gethash "detail" err))
                                       :checker checker
                                       :buffer buffer
                                       :filename (gethash "filename" range)
                                       :end-line (gethash "line" end)
                                       :end-column (gethash "column" end))))
                                  errors))
                      ;; If no JSON found, return nil (or parse standard output if needed)
                      nil))
    :modes (terragrunt-mode))
  (add-to-list 'flycheck-checkers 'terragrunt-validate))

(map! :map terragrunt-mode-map
      :mode terragrunt-mode
      :localleader
      :desc "Terragrunt Plan" "p" (lambda () (interactive) (tg-mode/terragrunt-run "plan"))
      :desc "Terragrunt Menu" "m" #'tg-mode/terragrunt-menu
      :desc "Show Dependencies" "d" #'tg-mode/terragrunt-list-dependencies
      :desc "Check outputs for dep" "o" #'tg-mode/terragrunt-check-output
      :desc "Add Dependency" "D" #'tg-mode/add-dependency
      :desc "Generate Stack" "G" (lambda () (interactive) (tg-mode/generate-stack))
      :desc "Open Stack" "S" #'tg-mode/open-stack
      :desc "Delete terragrunt cache" "r" #'tg-mode/remove-terragrunt-cache
      :desc "Unlock" "u" (lambda () (interactive) (tg-mode/terragrunt-run "force-unlock" "-force" (read-string "Unlock id: "))))

(provide 'terragrunt-mode)
