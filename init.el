;;; medicated.el --- Medicated Emacs, a minimal and modern Emacs configuration
;;
;;; Commentary:
;;
;; A lightweight, opinionated Emacs starter configuration that provides
;; modern conveniences while staying true to standard Emacs patterns.
;;
;; PHILOSOPHY:
;;
;; This config enhances Emacs without hiding it. Everything uses standard
;; Emacs patterns and conventions. If you know how to customize vanilla
;; Emacs, you know how to customize this config - there are no frameworks,
;; wrappers, or special systems to learn.
;;
;; The goal is to provide a good starting point with:
;; - Modern completion (Vertico + Orderless + Marginalia)
;; - LSP support via Eglot (built-in)
;; - Git integration (Magit + diff-hl)
;; - Quality-of-life improvements (better defaults, recent files, etc.)
;; - Common language modes pre-installed
;;
;; REQUIREMENTS:
;;
;; - Emacs 29.0 or later
;; - Internet connection (for first-time package installation)
;; - LSP servers installed separately if you want LSP features
;;   (e.g., clangd for C/C++, rust-analyzer for Rust, etc.)
;;
;; INSTALLATION:
;;
;; 1. Ensure you have an empty Emacs configuration directory, or none at all.
;;    Your Emacs config directory is typically one of:
;;    - ~/.emacs.d/
;;    - ~/.config/emacs/
;;
;;    If these exist and contain files, back them up and delete them,
;;    or Emacs may load conflicting configurations.
;;
;; 2. Place this file as "init.el" in one of these locations:
;;    - ~/.emacs.d/init.el (traditional location, always checked first)
;;    - ~/.config/emacs/init.el (XDG-compliant location)
;;
;;    Note: Emacs prefers ~/.emacs.d/ if it exists. To use the XDG location,
;;    ensure ~/.emacs.d/ does not exist.
;;
;; 3. Launch Emacs. On first run:
;;    - All packages will be automatically downloaded and installed
;;    - A message will appear: "First-time setup complete. Please restart Emacs."
;;    - Emacs will automatically close after 10 seconds
;;
;; 4. Restart Emacs. Your configuration is now ready to use.
;;
;; TROUBLESHOOTING:
;;
;; If the configuration doesn't work after restarting:
;; 1. Delete ALL files (including hidden files) in your Emacs directory
;; 2. Try the installation process again
;; 3. If problems persist, file a bug report with details about your
;;    Emacs version, operating system, and the exact error messages
;;
;; LEARNING EMACS:
;;
;; If you're new to Emacs, start with the built-in tutorial:
;;   M-x help-with-tutorial RET
;; (That's: Alt+x, type "help-with-tutorial", press Enter)
;;
;; Learn Emacs as you would with vanilla Emacs - this config doesn't
;; change fundamental Emacs concepts or introduce special systems.
;; Standard Emacs documentation and resources apply directly.
;;
;; CUSTOMIZATION:
;;
;; Don't like something? Change it as you would in vanilla Emacs:
;; - Theme: M-x customize-themes or edit 'custom-enabled-themes
;; - Font: M-x customize-face default or set in 'default-frame-alist
;; - Keybindings: Use global-set-key or local-set-key
;; - Any setting: M-x customize-variable or edit custom-set-variables
;;
;; This config does nothing special - it's just Emacs with better defaults.
;;
;; EXPECTED BEHAVIOR:
;;
;; All behavior (both functional and errors) from this config represents
;; the normal Emacs experience, or bugs in the included third-party packages.
;;
;; EGLOT (LSP) NOTES:
;;
;; Eglot (the built-in LSP client) is enabled by default in all programming
;; modes via prog-mode-hook. This is the most common source of errors because:
;;
;; - Eglot expects LSP servers to be already installed on your system
;; - If a language server is missing, Eglot will show error messages
;; - Different languages need different LSP servers:
;;   * C/C++: clangd
;;   * Rust: rust-analyzer  
;;   * Python: pyright or pylsp
;;   * Go: gopls
;;   * JavaScript/TypeScript: typescript-language-server
;;   * Lua: lua-language-server
;;   And so on...
;;
;; If Eglot causes issues, you can:
;; 1. Remove 'eglot-ensure from prog-mode-hook in custom-set-variables
;; 2. Add it to specific language mode hooks instead:
;;    (add-hook 'rust-mode-hook #'eglot-ensure)
;; 3. Or disable it entirely and use Emacs without LSP
;;
;; PACKAGE LIST:
;;
;; This config installs these third-party packages:
;; - csv-mode: CSV file editing
;; - diff-hl: Git diff indicators in the fringe
;; - doom-modeline: Modern mode-line
;; - doom-themes: Collection of themes (Gruvbox used by default)
;; - go-mode: Go language support
;; - helpful: Better help buffers
;; - json-mode: JSON highlight support
;; - lua-mode: Lua language support
;; - magit: Git interface
;; - marginalia: Completion annotations
;; - markdown-mode: Markdown editing
;; - orderless: Fuzzy completion matching
;; - rainbow-delimiters: Colored parentheses by depth
;; - rust-mode: Rust language support
;; - typescript-mode: TypeScript language support
;; - vertico: Vertical completion UI
;; - which key: Displays possible key bindings
;; - yaml-mode: YAML file editing
;;
;;; Code:

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Bootstrap 'use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Local executables support
(add-to-list 'exec-path (expand-file-name "~/.local/bin"))

;;; Functions
(defun mode-has-lsp-p ()
  "Check if MODE (or current major-mode) has an LSP server configured in Eglot."
  (require 'eglot nil t)
  (and (buffer-file-name)
       (ignore-errors (cl-fourth (eglot--guess-contact)))))

(defun move-line-up (arg)
  "Drag current line to previous line, keeping point on current line.
With argument ARG, takes current line and moves it past ARG lines."
  (interactive "*p")
  (let ((original-column (current-column)))
    (dotimes (i arg)
      (transpose-lines 1)
      (previous-line 2)
      (move-to-column original-column))))

(defun move-line-down (arg)
  "Drag current line to next line, keeping point on current line.
With argument ARG, takes current line and moves it past ARG lines."
  (interactive "*p")
  (let ((original-column (current-column)))
    (dotimes (i arg)
      (next-line)
      (transpose-lines 1)
      (previous-line 1)
      (move-to-column original-column))))

;; Packages
(use-package csv-mode)
(use-package diff-hl)
(use-package doom-modeline)
(use-package doom-themes)
(use-package go-mode)
(use-package helpful)
(use-package json-mode)
(use-package lua-mode)
(use-package magit)
(use-package marginalia)
(use-package markdown-mode)
(use-package orderless)
(use-package rainbow-delimiters)
(use-package rust-mode)
(use-package typescript-mode)
(use-package vertico)
(use-package which-key)
(use-package yaml-mode)

;; Variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-saves/" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/")))
 '(byte-compile-verbose nil)
 '(byte-compile-warnings '(cl-functions))
 '(column-number-mode t)
 '(comment-style 'multi-line)
 '(completion-styles '(orderless basic))
 '(custom-enabled-themes '(doom-gruvbox))
 '(custom-safe-themes
   '("f1e8339b04aef8f145dd4782d03499d9d716fdc0361319411ac2efc603249326" default))
 '(default-frame-alist '((menu-bar-line)))
 '(delete-selection-mode t)
 '(dired-dwim-target t)
 '(dired-listing-switches "-al --group-directories-first")
 '(dired-recursive-copies 'always)
 '(dired-recursive-deletes 'always)
 '(dired-use-ls-dired t)
 '(display-line-numbers 'visual)
 '(doom-modeline-mode t)
 '(eglot-ignored-server-capabilities '(:documentHighlightProvider :inlayHintProvider))
 '(fill-column 80)
 '(global-auto-revert-mode t)
 '(global-diff-hl-mode t)
 '(indicate-empty-lines t)
 '(initial-buffer-choice t)
 '(initial-major-mode 'fundamental-mode)
 '(initial-scratch-message nil)
 '(lua-indent-level 2)
 '(marginalia-mode t)
 '(org-hide-leading-stars t)
 '(package-selected-packages nil)
 '(prog-mode-hook
   '(subword-mode
     (lambda nil (when (mode-has-lsp-p) (eglot-ensure)))
     electric-pair-local-mode))
 '(recentf-mode t)
 '(ring-bell-function 'ignore)
 '(save-place-mode t)
 '(savehist-mode t)
 '(scroll-bar-mode nil)
 '(scroll-conservatively 5)
 '(scroll-margin 5)
 '(scroll-step 1)
 '(sentence-end-double-space nil)
 '(size-indication-mode t)
 '(text-mode-hook '(text-mode-hook-identify toggle-word-wrap))
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style 'forward nil (uniquify))
 '(use-short-answers t)
 '(vertico-mode t)
 '(which-key-mode t)
 '(winner-mode t))

;; Bindings
(global-set-key (kbd "C-x C-b") #'ibuffer)
(global-set-key (kbd "M-s i") #'imenu)
(global-set-key (kbd "M-<up>") #'move-line-up)
(global-set-key (kbd "M-<down>") #'move-line-down)
(global-set-key (kbd "M-p") #'move-line-up)
(global-set-key (kbd "M-n") #'move-line-down)

(global-set-key (kbd "C-c C-d") #'helpful-at-point)
(global-set-key (kbd "C-h F") #'helpful-function)
(global-set-key (kbd "C-h f") #'helpful-callable)
(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)
(global-set-key (kbd "C-h x") #'helpful-command)

;; Lazy loading of rainboe del. mode
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; Backups
(make-directory (expand-file-name "auto-saves" user-emacs-directory) t)
(make-directory (expand-file-name "backups" user-emacs-directory) t)

;; First-time setup
(unless (file-exists-p "~/.emacs.d/.first-run")
  (write-region "" nil "~/.emacs.d/.first-run")
  (run-with-timer 1 nil
                  (lambda ()
		    (ignore-errors (kill-buffer "*Compile-Log*"))
		    (delete-other-windows)
                    (message "First-time setup complete. Please restart Emacs. Closing in 10 seconds")
		    (run-with-timer 10 nil #'save-buffers-kill-emacs))))

(provide 'init.el)

;; Copyright (C) 2025 Roland Marchand <roland.marchand@protonmail.com>
;;
;; Permission to use, copy, modify, and/or distribute this software for
;; any purpose with or without fee is hereby granted.
;;
;; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
;; WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
;; WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
;; AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
;; DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
;; PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
;; TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
;; PERFORMANCE OF THIS SOFTWARE.

;;; init.el ends here
