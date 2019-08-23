(load-file (concat user-emacs-directory "modules/package-use.el"))
(load-file (concat user-emacs-directory "modules/make-normal-sparse-keymap.el"))
(load-file (concat user-emacs-directory "modules/surround.el"))
(load-file (concat user-emacs-directory "modules/modal.el"))
(load-file (concat user-emacs-directory "modules/edit.el"))

(package-initialize)

(setq package-archives '(("melpa" . "http://melpa.org/packages/")
                         ("elpa" . "http://elpa.gnu.org/packages/")))

(unless (file-directory-p (concat user-emacs-directory "elpa"))
  (package-refresh-contents))

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

(setq make-backup-files nil)
(setq auto-save-default nil)
(electric-pair-mode)
(global-linum-mode 1)
(global-visual-line-mode 1)
(setq linum-format " %d ")

(defun reload-config()
  (interactive)
  (load-file (concat user-emacs-directory "config.el")))

(tool-bar-mode 0)
(menu-bar-mode 0)
(add-hook 'after-init-hook
					(lambda() (interactive) (scroll-bar-mode 0)))
;;(toggle-scroll-bar -1)


(defadvice text-scale-increase (after text-scale-after activate)
  (set-window-margins (selected-window) 1 1))
(defadvice text-scale-decrease (after text-scale-after activate)
  (set-window-margins (selected-window) 1 1))
(defadvice text-scale-set (after text-scale-after activate)
  (set-window-margins (selected-window) 1 1))

(package-use 'general :require t)

(package-use 'which-key :require t)
(which-key-mode 1)

(package-use 'swiper :require t)

(package-use 'lua-mode :require t)
(setq lua-indent-level 2)
(load-file (concat user-emacs-directory "modules/lua-indent.el"))
(package-use 'company-lua :require t)

(package-use 'moonscript :require t)

(package-use 'irony :require t)
(package-use 'company-irony :require t)
(package-use 'company-c-headers :require t)

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(package-use 'company :require t)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-c-headers))
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-lua))

(global-company-mode)

(package-use 'projectile :require t)

(package-use 'ivy :require t)
(ivy-mode 1)

(package-use 'beacon :require t)
(beacon-mode 1)

(package-use 'highlight-parentheses :require t)
(global-highlight-parentheses-mode)

(package-use 'all-the-icons :require t)
(package-use 'all-the-icons-dired :require t)

(add-hook 'dired-mode-hook (lambda() (auto-revert-mode)))

(package-use 'doom-modeline :require t)
;;(setq doom-modeline-icon nil)
(setq doom-modeline-height 32)
(doom-modeline-mode 1)

(package-use 'dashboard :require t)
(dashboard-setup-startup-hook)
(setq dashboard-startup-banner (concat user-emacs-directory "banner.png"))
(setq dashboard-items '((recents . 5)
			(projects . 5)))
(setq dashboard-banner-logo-title "Welcome to Emacs.")

(package-use 'expand-region :require t)

(package-use 'undo-tree :require t)
(global-undo-tree-mode)


(package-use 'minor-mode-hack :require t)

(package-use 'avy :require t)

(package-use 'elmacro :require t)

(package-use 'exwm :require t)

(package-use 'multiple-cursors
             :require t)

(load-file (concat user-emacs-directory "macro.el"))

(load-file (concat user-emacs-directory "eshell.el"))
(load-file (concat user-emacs-directory "theme.el"))
(load-file (concat user-emacs-directory "keybindings.el"))
(modal/init)
