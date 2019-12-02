(setq self-inserting-characters '("`" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "-" "=" "q" "w" "e" "r" "t" "y" "u" "i" "o" "p" "[" "]" "a" "s" "d" "f" "g" "h" "j" "k" "l" ";" "'" "\\" "z" "x" "c" "v" "b" "n" "m" "," "." "/" "TAB" "SPC" "<tab>" "<space>" "~" "@" "#" "$" "%" "^" "&" "*" "(" ")" "_" "+" "Q" "W" "E" "R" "T" "Y" "U" "I" "O" "P" "{" "}" "A" "S" "D" "F" "G" "H" "J" "K" "L" ":" "\"" "|" ">" "Z" "X" "C" "V" "B" "N" "M" "<" ">" "?" "DEL"))

(defun make-normal-sparse-keymap()
  (setq result (make-sparse-keymap))
  (dolist (char self-inserting-characters)
    (define-key result (kbd char) 'ignore))
  result)

(provide 'make-normal-sparse-keymap)
