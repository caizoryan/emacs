(tool-bar-mode -1)
(tooltip-mode -1)
(scroll-bar-mode -1)

(setq ns-auto-hide-menu-bar t)
;; (set-frame-position nil 0 -24)
;; (set-frame-size nil (display-pixel-width) (display-pixel-height) t)

(add-to-list 'frameset-filter-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(undecorated . t))

(load-theme 'doom-miramare)
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

(menu-bar-mode 1)
(load-theme 'tango-dark)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(column-number-mode)
(global-display-line-numbers-mode -1)
(global-display-line-numbers-mode 1)

(set-face-attribute 'default nil :height 150)
(set-face-attribute 'default nil :font "FuraMono Nerd Font Mono")

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents (package-refresh-contents))
;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; don't know how to set bindings without pacakge
;; so all general bindings are here lmao...
(use-package command-log-mode
  :bind (("C-c t" . load-theme)
	 ("C-c ." . eval-last-sexp)
	 ))


(defun proj ()
	"Opens find-file in personal projects folder."
	(interactive)
	(let ((default-directory "~/Downloads/projects/"))
		  (call-interactively 'find-file)))


(let ((percent (/ (float (point))
				  (float (point-max)))))
	  (concat "cursor is "
			  (number-to-string
			  (truncate (* percent 100)))
			  "% through"))

(use-package magit)

(use-package pbcopy)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)
	   (doom-modeline-icon nil)
	   (doom-modeline-lsp-icon nil)
	   (doom-modeline-lsp nil)
	   (doom-modeline-project-name t)
	   (doom-modeline-time t)
	   (doom-modeline-buffer-encoding nil)
	   (doom-modeline-indent-info t)
	   )
  )

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package flycheck) 
(global-flycheck-mode)

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))
(use-package counsel
  :init (counsel-mode)
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer))
  :config
  (setq ivy-initial-input-alist nil))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)

  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)

  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package evil

  :init
  (setq evil-want-integration t)
  (setq evil-want-C-u-scroll t)

  :config
  (evil-mode 1))

(hs-minor-mode)

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :after evil
  :config
  
  (general-create-definer efs/leader-keys
    :keymaps '(normal visual emacs)
    :prefix "SPC"
    :global-prefix "SPC")

   ;(general-nvmap
   ;  "'" (general-simulate-keys "C-c")
   ;)

  (efs/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")

    "x"  '(counsel-M-x :which-key "M-x")
    "b"  '(counsel-ibuffer :which-key "switch buffer")

    ; killing windows and buffers
    "k"  '(:ignore t :which-key "kill")
    "kw"  '(evil-window-delete :which-key "kill window")
    "kb"  '(kill-buffer :which-key "kill buffer")

    ; find file
    "ff"  '(counsel-find-file :which-key "find files")))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typsecript-mode . lsp-deferred))

(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package doom-themes)

(use-package org
  :config
  (setq org-agenda-files
	'("~/.config/emacs/org-files/tasks.org"
	  "~/.config/emacs/org-files/birthdays.org"))
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-ellipsis " ▾"
	org-hide-emphasis-markers t)
  )

(use-package volatile-highlights)
(volatile-highlights-mode t)

(use-package org-bullets
    :hook (org-mode . org-bullets-mode))

(use-package company-box
  :hook (company-mode . company-box-mode))

(dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  (setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

