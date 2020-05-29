(require 'package)

(package-initialize)
(setq package-archives '())
(push (cons "elpa" "http://elpa.gnu.org/packages/") package-archives)
(push (cons "melpa" "http://melpa.org/packages/") package-archives)
