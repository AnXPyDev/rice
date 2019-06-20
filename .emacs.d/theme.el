(defun theme/tty()
  (set-face-attribute 'company-tooltip nil
		      :background "#FFFFFF"))

(defun theme/gui()
  (interactive)
  (package-use 'doom-themes)
  (load-theme 'doom-one t))
(defun theme/general())

(theme/general)

(if (display-graphic-p)
    (theme/gui)
  (theme/tty))
