(defun edit/insert-after()
  (interactive)
  (forward-char)
  (modal/enable-insert))

(defun edit/insert-end-of-line()
  (interactive)
  (end-of-line)
  (modal/enable-insert))

(defun edit/insert-beginning-of-line()
  (interactive)
  (beginning-of-line)
  (modal/enable-insert))

(defun edit/set-region()
  (interactive)
  (set-mark (point))
  (modal/enable-region))
