(defun mass-define-key(keymap keys)
  (dolist (key keys)
    (define-key keymap (kbd (car key)) (cdr key))))
