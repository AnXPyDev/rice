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
 "J" 'edit/copy-whole-line
 "k" 'delete-char
 "K" 'edit/kill-whole-word
 "C-k" 'kill-whole-line
 "l" 'yank
 "L" 'edit/yank-line
 "f" 'swiper
 "/" 'undo-tree-undo
 "\\" 'undo-tree-redo
 "s" 'edit/open-line
 "S" (lambda() (interactive) (edit/open-line) (modal/enable-insert))
 "w" 'edit/open-line-above
 "W" (lambda() (interactive) (edit/open-line-above) (modal/enable-insert))
 "g" nil
 "g o" 'isearch-forward
 "g b" 'isearch-backward)

(setq modal/region-map (make-composed-keymap (list (copy-keymap modal/emacs-map) (copy-keymap modal/normal-bare-map)) (make-normal-sparse-keymap)))

(general-define-key
 :keymaps 'modal/region-map
 "h" (lambda() (interactive) (kill-region (region-beginning) (region-end)) (modal/enable-insert))
 "j" (lambda() (interactive) (copy-region-as-kill (region-beginning) (region-end)) (modal/enable-normal))
 "k" (lambda() (interactive) (kill-region (region-beginning) (region-end)) (modal/enable-normal))
 "l" 'edit/yank-region
 "C-g" (lambda() (interactive) (pop-mark) (modal/enable-normal))
 "M-q" (lambda() (interactive) (pop-mark) (modal/enable-normal))
 "r" 'er/expand-region
 "TAB" (lambda() (interactive) (indent-region (region-beginning) (region-end)) (modal/enable-normal))
 "<tab>" (lambda() (interactive) (indent-region (region-beginning) (region-end)) (modal/enable-normal))
 "g" nil
 "g o" 'isearch-forward
 "g b" 'isearch-backward
 "s" nil
 "m" (lambda() (interactive) (modal/multiple-cursors-mode 1))
 "s (" (lambda() (interactive) (surround-region "(" ")") (modal/enable-normal))
 "s )" (lambda() (interactive) (surround-region "(" ")") (modal/enable-normal))
 "s {" (lambda() (interactive) (surround-region "{" "}") (modal/enable-normal))
 "s }" (lambda() (interactive) (surround-region "{" "}") (modal/enable-normal))
 "s [" (lambda() (interactive) (surround-region "[" "]") (modal/enable-normal))
 "s ]" (lambda() (interactive) (surround-region "[" "]") (modal/enable-normal))
 "s \"" (lambda() (interactive) (surround-region "\"" "\"") (modal/enable-normal))
 "s '" (lambda() (interactive) (surround-region "'" "'") (modal/enable-normal)))

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

(setq modal/multiple-cursors-map (make-sparse-keymap))

(general-define-key
 :keymaps 'modal/multiple-cursors-map
 "n" 'mc/mark-next-like-this
 "p" 'mc/mark-pop
 "a" 'mc/mark-all-like-this
 "r" 'mc/mark-in-region
 "M-q" (lambda() (interactive) (pop-mark) (modal/multiple-cursors-mode 0) (modal/enable-normal))
 "C-g" (lambda() (interactive) (pop-mark) (modal/multiple-cursors-mode 0) (modal/enable-normal)))

(define-minor-mode modal/multiple-cursors-mode nil nil nil modal/multiple-cursors-map)
