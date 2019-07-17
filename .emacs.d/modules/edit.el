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

(defun edit/set-region-line()
  (interactive)
	(beginning-of-line)
  (set-mark (point))
	(end-of-line)
  (modal/enable-region))

(defun edit/open-line()
  (interactive)
  (end-of-line)
  (open-line 1)
	(next-line))

(defun edit/open-line-above()
	(interactive)
	(beginning-of-line)
	(open-line 1))

(defun edit/yank-line()
	(interactive)
	(save-excursion
		(edit/open-line)
		(yank)
		(delete-blank-lines)))

(defun edit/kill-whole-word()
	(interactive)
	(backward-char)
	(forward-word)
	(backward-kill-word 1))

(defun edit/copy-whole-line()
	(interactive)
	(save-excursion
		(kill-whole-line)
		(yank)))

(defun edit/yank-region()
	(interactive)
	(kill-region (region-beginning) (region-end))
	(yank))
