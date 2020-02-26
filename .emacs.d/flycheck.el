(package-use 'flycheck :require t)
(global-flycheck-mode t)

(define-fringe-bitmap 'flycheck-fringe-bitmap-rectangle
  (vector #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000
          #b11100000))

(flycheck-define-error-level 'error
  ;;:overlay-category 'flycheck-error-overlay
  :fringe-bitmap 'flycheck-fringe-bitmap-rectangle
  :fringe-face 'flycheck-fringe-error
  :error-list-face 'flycheck-error-list-error)

(flycheck-define-error-level 'warning
  ;;:overlay-category 'flycheck-warning-overlay
  :fringe-bitmap 'flycheck-fringe-bitmap-rectangle
  :fringe-face 'flycheck-fringe-warning
  :error-list-face 'flycheck-error-list-warning)

(flycheck-define-error-level 'info
  ;;:overlay-category 'flycheck-info-overlay
  :fringe-bitmap 'flycheck-fringe-bitmap-rectangle
  :fringe-face 'flycheck-fringe-info
  :error-list-face 'flycheck-error-list-info)

(setq flycheck-display-errors-function nil)
