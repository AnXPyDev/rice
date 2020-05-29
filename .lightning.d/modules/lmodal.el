(defvar lmodal-default-mode nil
  "Mode used by default in buffers with a major mode that is not paired with another mode and is not ignored")
(defvar lmodal-modes '()
  "List of modal modes")
(defvar lmodal-major-mode-pairs '()
  "Associative list of major modes with their default modal modes")
(defvar lmodal-ignored-major-modes '()
  "List of ignored major modes")

(defun lmodal-extern-mode-name(name)
  (intern (concat "lmodal-" (symbol-name name) "-mode")))

(defun lmodal-raise-function-name(name)
  (intern (concat "lmodal-raise-" (symbol-name name) "-mode")))

(defun lmodal-extern-hook-name(name)
  (intern (concat (symbol-name (lmodal-extern-mode-name name)) "-hook")))

(defmacro lmodal-define-mode(name &rest args)
  `(progn
     (push ',name lmodal-modes)
     (define-minor-mode ,(lmodal-extern-mode-name name)
       ,(plist-get args :doc)
       ,nil
       ,(plist-get args :lighter)
       ,(plist-get args :keymap)
       (if ,(lmodal-extern-mode-name name)
         (progn
           ,(plist-get args :on-enable)
           ,(when (plist-member args :cursor)
              `(setq cursor-type ,(plist-get args :cursor)))
           )
         ,(plist-get args :on-disable)))
     (defun ,(lmodal-raise-function-name name) nil
       (interactive)
       (lmodal-raise-mode ,name))))

(defmacro lmodal-add-hook(name function)
  `(add-hook ',(lmodal-extern-hook-name name) ,function))

(defmacro lmodal-remove-hook(name function)
  `(remove-hook ',(lmodal-extern-hook-name name) ,function))
(defmacro lmodal-pair-major-mode(major-mode-name name)
  `(push (cons ',major-mode-name ',name) lmodal-major-mode-pairs))

(defmacro lmodal-ignore-major-mode(major-mode-name)
  `(push ',major-mode-name lmodal-ignored-major-modes))

(defmacro lmodal-set-default-mode(name)
  `(setq lmodal-default-mode ',name))

(defmacro lmodal-disable-mode(name)
  `(,(lmodal-extern-mode-name name) 0))

(defmacro lmodal-enable-mode(name)
  `(,(lmodal-extern-mode-name name) 1))

(defun lmodal-disable-all-modes()
  (interactive)
  (dolist (mode lmodal-modes)
    (eval `(lmodal-disable-mode ,mode))))

(defmacro lmodal-raise-mode(name)
  `(progn
     (dolist (mode lmodal-modes)
       (eval `(lmodal-disable-mode ,mode)))
     (lmodal-enable-mode ,name)))

(defun lmodal-raise-default-mode()
  (interactive)
  (let ((default-mode (catch 'default-mode
    (if (not (or (member major-mode lmodal-ignored-major-modes) (minibufferp)))
	(throw 'default-mode (or (cdr (assoc major-mode lmodal-major-mode-pairs)) lmodal-default-mode))
      (throw 'default-mode nil)))))
    (if default-mode
	(eval `(lmodal-raise-mode ,default-mode))
      (lmodal-disable-all-modes))))


(define-minor-mode lmodal-mode "Minor mode that manages lmodal modes" nil " Lmodal" nil
  (when lmodal-mode
    (lmodal-raise-default-mode)))

(define-globalized-minor-mode lmodal-global-mode lmodal-mode (lambda() (lmodal-mode 1)))
