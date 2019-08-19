;; In my modal config there is an emacs, normal, insert, region and rectangle mode

(setq modal/emacs-map (make-sparse-keymap))
(setq modal/normal-map (make-sparse-keymap))
(setq modal/insert-map (make-sparse-keymap))
(setq modal/region-map (make-sparse-keymap))
(setq modal/rectangle-map (make-sparse-keymap))

(defun modal/init()
  (interactive)
  (define-minor-mode modal/normal-mode "Normal mode" nil "<Normal>" modal/normal-map)
  (define-minor-mode modal/emacs-mode "Emacs mode" nil "<Emacs>" modal/emacs-map)
  (define-minor-mode modal/insert-mode "Insert mode" nil "<Insert>" modal/insert-map)
  (define-minor-mode modal/region-mode "Region mode" nil "<Region>" modal/region-map)
  (define-minor-mode modal/rectangle-mode "Rectangle mode" nil "<Rectangle>" modal/rectangle-map)
  (global-modal-mode 1))

(defun modal/clear()
  (interactive)
  (modal/normal-mode 0)
  (modal/emacs-mode 0)
  (modal/insert-mode 0)
  (modal/region-mode 0)
  (modal/rectangle-mode 0))

(defun modal/enable-normal()
  (interactive)
  (modal/clear)
  (setq cursor-type 'box)
  (modal/normal-mode 1))

(defun modal/enable-insert()
  (interactive)
  (modal/clear)
  (setq cursor-type 'bar)
  (modal/insert-mode 1))
(defun modal/enable-emacs()
  (interactive)
  (modal/clear)
  (setq cursor-type 'box)
  (modal/emacs-mode 1))
(defun modal/enable-region()
  (interactive)
  (modal/clear)
  (setq cursor-type 'box)
  (modal/region-mode 1))
(defun modal/enable-rectangle()
  (interactive)
  (modal/clear)
  (setq cursor-type 'box)
  (modal/rectangle-mode 1))

(define-minor-mode modal-mode "Mode that enbles modes on buffer" t "<Modal>" nil
	(when modal-mode
		(if (not (or (minibufferp)
                 (string-equal major-mode "eshell-mode")
                 (string-equal major-mode "dired-mode")
                 (string-equal major-mode "ibuffer-mode")))
				(modal/enable-normal)
			(modal/enable-emacs))))

;; Make modal-mode active by all buffers by default
(define-global-minor-mode global-modal-mode modal-mode (lambda() (modal-mode 1)))
