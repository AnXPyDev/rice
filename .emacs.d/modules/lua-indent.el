(defun lua-calculate-modifier (modifier)
  (if (= modifier 0)
      0
    lua-indent-level))

(defun lua-calculate-indentation (&optional parse-start)
  (save-excursion
    (let ((continuing-p (lua-is-continuing-statement-p))
          (cur-line-begin-pos (line-beginning-position)))
      (or
       (lua-calculate-indentation-override)

       (when (lua-forward-line-skip-blanks 'back)
         (let* ((modifier
                 (lua-calculate-indentation-block-modifier cur-line-begin-pos)))
           (+ (current-indentation) (lua-calculate-modifier modifier))))
       0))))
