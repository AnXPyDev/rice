(defun theme/tty()
  (set-face-attribute 'company-tooltip nil
		      :background "#FFFFFF"))

(defun theme/gui()
  (interactive)
  (package-use 'nord-theme)
  (package-use 'kaolin-themes)
  (package-use 'doom-themes)
  (setq x-theme-name (x-get-resource "themeName" "emacs"))
  (if x-theme-name
      (load-theme (intern x-theme-name) t)
    (load-theme 'kaolin-ocean t))
  (global-hl-line-mode)
  (when nil
    (set-face-attribute 'default nil
			:background "#121212"
			:foreground "#FFFFFF")
    (set-face-attribute 'mode-line nil
			:background "#202020")
    (set-face-attribute 'linum nil
			:foreground "#AAAAAA")
    (set-face-attribute 'region nil
			:background "#202040")
    (set-face-attribute 'hl-line nil
			:background "#202020")
    (set-face-attribute 'cursor nil
			:background "#CCCCCC"
			:foreground "#151515")
    )


  (setq font-name "Undefined")
	(setq x-font-name (x-get-resource "fontName" "emacs"))
  (setq backup-fonts '("Cascadia Mono" "Consolas"))

	(if x-font-name
      (setq font-name x-font-name)
    (progn
      (catch 'loop
        (dolist (font backup-fonts)
          (when (find-font (font-spec :name font))
            (setq font-name font)
            (throw 'loop nil))))))

  
	(set-face-attribute 'default nil
											:family font-name
											:height 112)
  (set-face-attribute 'linum nil
											:height 112))

(defun theme/general())

(theme/general)

(if (and (display-graphic-p) (not (daemonp)))
    (theme/gui)
  (theme/tty))
