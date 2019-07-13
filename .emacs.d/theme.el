(defun theme/tty()
  (set-face-attribute 'company-tooltip nil
		      :background "#FFFFFF"))

(defun theme/gui()
  (interactive)
  (package-use 'doom-themes)
  (load-theme 'doom-one t)
  (global-hl-line-mode)
  (when t
    (set-face-attribute 'default nil
			:background "#101010"
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
