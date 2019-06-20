(load-file (concat user-emacs-directory "modules/package-use.el"))
(load-file (concat user-emacs-directory "modules/make-normal-sparse-keymap.el"))

(setq tab-width 2)
(setq make-backup-files nil)
(setq auto-save-default nil)
(electric-pair-mode)
(global-linum-mode)
(setq linum-format " %d ")

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

(package-use 'general :require t)

(package-use 'which-key :require t)
(which-key-mode 1)

(package-use 'swiper :require t)

(package-use 'irony :require t)
(package-use 'company-irony :require t)
(package-use 'company-irony-c-headers :require t)

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(eval-after-load 'company
	'(add-to-list 'company-backends 'comapny-irony))

(package-use 'company :require t)
(global-company-mode)

(package-use 'centered-cursor-mode :require t)
(global-centered-cursor-mode)

(package-use 'projectile :require t)

(package-use 'ivy :require t)
(ivy-mode 1)

(load-file (concat user-emacs-directory "eshell.el"))
(load-file (concat user-emacs-directory "theme.el"))
(load-file (concat user-emacs-directory "keybindings.el"))
