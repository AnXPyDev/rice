(setq lightning-user-name "AnXPyDev")
(setq lightning-user-indent-offset 2)
(setq lightning-user-indent-use-spaces t)
(setq lightning-user-default-cursor 'hbar)

(lightning-apply-user-variables)

(lightning-load-module "sensible-defaults")
(lightning-load-module "package-manager")

(pkg ivy
	:require t
	:config-after (ivy-mode 1))

(global-linum-mode 1)
(setq linum-format " %3d ")

(lightning-load-module "lmodal")
(lightning-load-module "make-no-insert-keymap")
