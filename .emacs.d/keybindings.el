(general-define-key
 :keymaps 'modal/emacs-map
 "M-q" 'modal/enable-normal
 "M-e" 'modal/enable-emacs)

(setq modal/normal-map (make-composed-keymap (make-normal-sparse-keymap) modal/emacs-map))
(setq modal/insert-map modal/emacs-map)

(general-define-key
 :keymaps 'modal/normal-map
 "p" 'previous-line
 "n" 'next-line
 "b" 'backward-char
 "o" 'forward-char
 "a" 'beginning-of-line
 "e" 'end-of-line
 "q" 'modal/enable-insert
 "Q" 'edit/insert-beginning-of-line
 "d" 'edit/insert-after
 "D" 'edit/insert-end-of-line)

(defhydra hydra-edit (:hint nil)
  ("n" next-line)
  ("p" previous-line)
  ("f" forward-char)
  ("b" backward-char)
  ("N" (lambda() (interactive) (next-line 10)))
  ("P" (lambda() (interactive) (previous-line 10)))
  ("F" forward-word)
  ("B" backward-word)
  ("C-n" ccm-scroll-up)
  ("C-p" ccm-scroll-down)  
  ("d" delete-char)
  ("D" kill-whole-line)
  ("a" beginning-of-line)
  ("e" end-of-line)
  ("SPC" set-mark-command)
  ("/" undo)
  ("C-g" keyboard-quit)
  ("C-SPC" (lambda() (interactive) (beginning-of-line) (set-mark (point)) (end-of-line) (next-line)))
  ("s (" (lambda() (interactive) (surround-region "(" ")")))
  ("s {" (lambda() (interactive) (surround-region "{" "}")))
  ("s \"" (lambda() (interactive) (surround-region "\"" "\"")))
  ("s '" (lambda() (interactive) (surround-region "' "'"")))
  ("s [" (lambda() (interactive) (surround-region "[" "]")))
  ("s <" (lambda() (interactive) (surround-region "<" ">")))
  ("C-a" beginning-of-line-text)
  ("C-e" end-of-line)
  ("m" hydra-multiple-cursors/body :exit t)
  ("q" nil))

(defhydra hydra-multiple-cursors (:hint nil)
  ("l" mc/edit-lines :exit t)
  ("a" mc/mark-all-like-this :exit t)
  ("n" mc/mark-next-like-this)
  ("C-n" mc/mark-next-word-like-this)
  ("<mouse-1>" mc/add-cursor-on-click)
  ;; Help with click recognition in this hydra
  ("<down-mouse-1>" ignore)
  ("<drag-mouse-1>" ignore)
  ("q" nil))

(general-define-key
 "C-s" 'swiper
 "C-x C-b" 'ibuffer
 "C-TAB" 'hydra-edit/body
 "C-<tab>" 'hydra-edit/body)

(general-define-key
 :keymaps 'company-active-map
 "<tab>" 'company-complete
 "TAB" 'company-complete)

(general-create-definer general-leader-define-key
  :prefix "C-c")

(general-leader-define-key
  "RET" 'eshell-toggle
  "<return>" 'eshell-toggle
  "e b" 'eval-buffer
  "e e" 'eval-expression)

(add-hook 'eshell-mode-hook (lambda()
			      (interactive)
			      (general-leader-define-key
				:keymaps 'eshell-mode-map
				"RET" 'eshell-toggle
				"<return>" 'eshell-toggle)))
