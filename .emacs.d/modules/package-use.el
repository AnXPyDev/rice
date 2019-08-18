(require 'package)

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
