(defun surround(start end open close)
  (save-excursion
    (goto-char start)
    (insert open)
    (goto-char (+ end 1))
    (insert close)))

(defun surround-region(open close)
  (when (region-active-p)
    (surround (region-beginning) (region-end) open close)))
