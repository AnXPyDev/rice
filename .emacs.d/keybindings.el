(defhydra hydra-edit ()
  ("n" next-line)
  ("p" previous-line)
  ("f" forward-char)
  ("b" backward-char)
  ("N" (lambda() (interactive) (next-line 10)))
  ("P" (lambda() (interactive) (previous-line 10)))
  ("d" delete-char)
  ("D" kill-whole-line)
  ("a" beginning-of-line)
  ("e" end-of-line)
  ("C-a" beginning-of-line-text)
  ("C-e" end-of-line))

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
