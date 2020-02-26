(defun get-last-eshell-buffer()
  (catch 'buffer
    (dolist (buffer (buffer-list))
      (when (cl-search "*eshell*" (buffer-name buffer))
        (throw 'buffer buffer)))))

(defun switch-to-last-eshell-buffer()
  (let ((buffer (get-last-eshell-buffer)))
    (if buffer
        (switch-to-buffer buffer)
      (eshell))))

(defun eshell-toggle()
  (interactive)
  (if (cl-search "*eshell" (buffer-name))
      (switch-to-prev-buffer)
    (switch-to-last-eshell-buffer)))

(add-hook 'eshell-mode-hook (lambda() (interactive)
			      (linum-mode 0)))

(setq eshell-count 1)

(defun eshell-new()
	(interactive)
	(eshell eshell-count)
	(setq eshell-count (+ 1 eshell-count)))
