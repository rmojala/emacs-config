;; -*- lexical-binding: t; -*-

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(use-package emacs
  :hook
  (before-save . delete-trailing-whitespace)
  (prog-mode . display-fill-column-indicator-mode)

  :custom
  (auto-revert-verbose nil)
  (auto-save-default nil)
  (create-lockfiles nil)
  (custom-file (locate-user-emacs-file "customizations.el"))
  (display-fill-column-indicator-column 80)
  (global-auto-revert-non-file-buffers t)
  (inhibit-startup-echo-area-message user-login-name)
  (inhibit-startup-screen t)
  (initial-scratch-message nil)
  (make-backup-files nil)
  (require-final-newline t)
  (ring-bell-function #'ignore)
  (save-interprogram-paste-before-kill t)
  (select-enable-clipboard t)
  (select-enable-primary nil)
  (use-dialog-box nil)
  (use-file-dialog nil)
  (use-short-answers t)

  :config
  (blink-cursor-mode -1)
  (global-auto-revert-mode 1)
  (global-hl-line-mode 1)
  (tooltip-mode -1))

(use-package dired
  :hook
  (dired-mode . dired-hide-details-mode)

  :custom
  (dired-dwim-target t)
  (dired-free-space nil)
  (dired-kill-when-opening-new-dired-buffer t))

(use-package magit
  :straight t

  :bind
  ("C-x g" . magit-status))

(use-package marginalia
  ;; Adds marginalia to minibuffer completions.
  :straight t

  :init
  (marginalia-mode))

(use-package modus-themes
  :straight t

  :config
  (load-theme 'modus-operandi-tinted t))

(use-package orderless
  ;; Completion style that matches multiple regexps in any order.
  :straight t

  :custom
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)
  (completion-styles '(orderless basic)))

(use-package rainbow-delimiters
  :straight t

  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package vertico
  ;; Vertical completion UI based on the default completion system.
  :straight t

  :config
  (vertico-mode))

(use-package which-key
  :config
  (which-key-mode))

(use-package xclip
  :straight t

  :init
  (unless (executable-find "xclip")
    (display-warning 'clipboard
                     "xclip not found on PATH. Clipboard integration will
not work in terminal. Install it with:
Fedora: sudo dnf install xclip
Ubuntu: sudo apt install xclip"))

  :config
  (xclip-mode 1))
