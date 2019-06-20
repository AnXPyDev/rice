(defun eshell-toggle()
  (interactive)
  (if (cl-search "*eshell" (buffer-name))
      (switch-to-prev-buffer)
    (eshell)))

(add-hook 'eshell-mode-hook (lambda() (interactive)
			      (linum-mode 0)))
