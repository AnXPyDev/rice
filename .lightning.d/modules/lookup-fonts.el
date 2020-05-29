(defun lookup-fonts(&rest fonts)
  "Finds the first available font from inputted arguments"
  (catch 'font
    (dolist (font fonts)
      (when (and font (find-font (font-spec :name font)))
	(throw 'font font)))))
