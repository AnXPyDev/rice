(load-file (concat user-emacs-directory "modules/package-use.el"))
(load-file (concat user-emacs-directory "modules/make-normal-sparse-keymap.el"))

(setq tab-width 2)
(setq make-backup-files nil)
(setq auto-save-default nil)
(electric-pair-mode)
(global-linum-mode)
(setq linum-format " %d ")

(setq initial-buffer-choice "*scratch*")

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

(package-use 'general :require t)

(package-use 'which-key :require t)
(which-key-mode 1)

(package-use 'swiper :require t)

(package-use 'lua-mode :require t)
(setq lua-indent-level 2)
(load-file (concat user-emacs-directory "modules/lua-indent.el"))

(package-use 'company-lua :require t)

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
(add-hook 'lua-mode-hook (lambda()
			   (setq-local company-backends '(comapny-lua))))

(global-company-mode)

(package-use 'centered-cursor-mode :require t)
(global-centered-cursor-mode)

(package-use 'projectile :require t)

(package-use 'ivy :require t)
(ivy-mode 1)

(package-use 'beacon :require t)
(beacon-mode 1)

(package-use 'multiple-cursors :require t)

(package-use 'hydra :require t)

(load-file (concat user-emacs-directory "eshell.el"))
(load-file (concat user-emacs-directory "theme.el"))
(load-file (concat user-emacs-directory "keybindings.el"))
