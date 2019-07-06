(general-define-key
 :keymaps 'modal/emacs-map
 "M-q" 'modal/enable-normal
 "M-e" 'modal/enable-emacs)

(defadvice modal/enable-normal (after kill-region-on-normal-mode-enter)
	(pop-mark))

(setq modal/normal-bare-map (make-sparse-keymap))

(general-define-key
 :keymaps 'modal/normal-bare-map
 "p" 'previous-line
 "P" 'ccm-scroll-down
 "n" 'next-line
 "N" 'ccm-scroll-up
 "b" 'backward-char
 "B" 'backward-word
 "o" 'forward-char
 "O" 'forward-word
 "a" 'beginning-of-line
 "e" 'end-of-line)

(setq modal/normal-map (make-composed-keymap (list (copy-keymap modal/emacs-map) (copy-keymap modal/normal-bare-map)) (make-normal-sparse-keymap)))

(general-define-key
 :keymaps 'modal/normal-map
 "q" 'modal/enable-insert
 "Q" 'edit/insert-beginning-of-line
 "d" 'edit/insert-after
 "D" 'edit/insert-end-of-line
 "r" 'edit/set-region
 "k" 'delete-char
 "l" 'yank)

(setq modal/region-map (make-composed-keymap (list (copy-keymap modal/emacs-map) (copy-keymap modal/normal-bare-map)) (make-normal-sparse-keymap)))

(general-define-key
 :keymaps 'modal/region-map
 "j" (lambda() (interactive) (copy-region-as-kill (region-beginning) (region-end)) (modal/enable-normal))
 "k" (lambda() (interactive) (kill-region (region-beginning) (region-end)) (modal/enable-normal))
 "C-g" (lambda() (interactive) (keyboard-quit) (modal/enable-normal)))

(setq modal/insert-map (copy-keymap modal/emacs-map))

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
