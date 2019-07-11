(defun theme/tty()
  (set-face-attribute 'company-tooltip nil
		      :background "#FFFFFF"))

(defun theme/gui()
  (interactive)
  (package-use 'kaolin-themes)
  (load-theme 'kaolin-galaxy t)
  (global-hl-line-mode)
  (when nil
    (set-face-attribute 'default nil
			:background "#151515"
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
	(set-face-attribute 'default nil
											:family "Hack"
											:height 112))

(defun theme/general())

(theme/general)

(if (and (display-graphic-p) (not (daemonp)))
    (theme/gui)
  (theme/tty))
