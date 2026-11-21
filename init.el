;; -*- lexical-binding: t; -*-

;; Environment variables:
;;
;; NOTES_DIR  Directory used by Denote for notes (`denote-directory').
;;            Defaults to ~/notes if unset or empty, and a warning is shown
;;            at startup.

;; External executables expected on PATH:
;;
;; fd     Used by `consult-fd' (called fdfind on Ubuntu).
;; git    Used by straight.el to fetch packages and by Magit.
;; rg     Used by `consult-ripgrep'.
;; xclip  Clipboard integration in terminal Emacs.
;;
;; Install on Fedora:
;;   sudo dnf install fd-find git ripgrep xclip
;; Install on Ubuntu:
;;   sudo apt install fd-find git ripgrep xclip

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
  (prog-mode . display-line-numbers-mode)

  :custom
  (auto-revert-verbose nil)
  (auto-save-default nil)
  (create-lockfiles nil)
  (custom-file (locate-user-emacs-file "customizations.el"))
  (display-fill-column-indicator-column 80)
  (display-line-numbers-width 3)
  (global-auto-revert-non-file-buffers t)
  (indent-tabs-mode nil)
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
  ;; TODO: Check if this is actually useful
  (visible-cursor nil)

  :config
  (blink-cursor-mode -1)
  (column-number-mode 1)
  (global-auto-revert-mode 1)
  (global-hl-line-mode 1)
  (recentf-mode 1)
  (tooltip-mode -1))

(use-package consult
  ;; Search and navigate via completing-read.
  :straight t

  :bind
  ("C-x b" . consult-buffer)
  ("C-x p b" . consult-project-buffer)
  ("C-x p f" . consult-fd)
  ("M-g g" . consult-goto-line)
  ("M-s g" . consult-ripgrep)
  ("M-s l" . consult-line)
  ("M-y" . consult-yank-pop)

  :init
  (unless (or (executable-find "fd") (executable-find "fdfind"))
    (display-warning 'consult
                     "fd not found on PATH. consult-fd will not work.
Install it with:
Fedora: sudo dnf install fd-find
Ubuntu: sudo apt install fd-find"))

  (unless (executable-find "rg")
    (display-warning 'consult
                     "rg not found on PATH. consult-ripgrep will not work.
Install it with:
Fedora: sudo dnf install ripgrep
Ubuntu: sudo apt install ripgrep")))

(use-package consult-denote
  ;; Enhance Denote with previews and more.
  :straight t
  :after denote

  :config
  (consult-denote-mode 1))

(use-package denote
  ;; Simple note-taking with predictable file names.
  :straight t

  :hook
  (dired-mode . denote-dired-mode)

  :init
  (when (member (getenv "NOTES_DIR") '(nil ""))
    (display-warning 'denote
                     "NOTES_DIR is not set. Using ~/notes as default.
Set it in your environment, e.g.:
export NOTES_DIR=~/notes"))

  :custom
  (denote-directory (file-name-as-directory
                     (expand-file-name
                      (let ((dir (getenv "NOTES_DIR")))
                        (if (member dir '(nil "")) "~/notes" dir))))))

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
