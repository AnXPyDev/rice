(general-define-key
 :keymaps 'modal/emacs-map
 "M-q" 'modal/enable-normal
 "M-e" 'modal/enable-emacs)

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
 "R" 'edit/set-region-line
 "k" 'delete-char
 "K" 'edit/kill-whole-word
 "C-k" 'kill-whole-line
 "l" 'yank
 "L" 'edit/yank-line
 "f" 'swiper
 "/" 'undo
 "s" 'edit/open-line
 "S" (lambda() (interactive) (edit/open-line) (modal/enable-insert))
 "w" 'edit/open-line-above
 "W" (lambda() (interactive) (edit/open-line-above) (modal/enable-insert)))

(setq modal/region-map (make-composed-keymap (list (copy-keymap modal/emacs-map) (copy-keymap modal/normal-bare-map)) (make-normal-sparse-keymap)))

(general-define-key
 :keymaps 'modal/region-map
 "h" (lambda() (interactive) (kill-region (region-beginning) (region-end)) (modal/enable-insert))
 "j" (lambda() (interactive) (copy-region-as-kill (region-beginning) (region-end)) (modal/enable-normal))
 "k" (lambda() (interactive) (kill-region (region-beginning) (region-end)) (modal/enable-normal))
 "C-g" (lambda() (interactive) (pop-mark) (modal/enable-normal))
 "M-q" (lambda() (interactive) (pop-mark) (modal/enable-normal))
 "r" 'er/expand-region
 "TAB" 'indent-region
 "<tab>" 'indent-region)

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
