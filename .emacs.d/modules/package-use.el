(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(unless (file-directory-p (concat user-emacs-directory "elpa"))
  (package-refresh-contents))

(package-initialize)

(defun package-request(name)
  (unless (package-installed-p name)
    (package-install name)))

(defun package-use(name &rest args)
  (package-request name)
  (setq arg-require (plist-get args :require))
  (setq arg-require-name (plist-get args :require-name))
  (if arg-require
      (require name)
    (when arg-require-name
      (require arg-require-name))))


(provide 'package-use)
