(defun config/path(path)
  (concat user-emacs-directory path))

(defun config/reload()
  (interactive)
  (org-babel-load-file (config/path "config.org")))

(require 'package)

(package-initialize)
(setq package-archives '(("melpa" . "http://melpa.org/packages/")
                         ("elpa" . "http://elpa.gnu.org/packages/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(defun package-use(name &rest args)
  (unless (package-installed-p name)
    (package-install name))
  (setq arg-require (plist-get args :require))
  (setq arg-require-name (plist-get args :require-name))
  (if arg-require
      (require name)
    (when arg-require-name
      (require arg-require-name))))

(setq ring-bell-function 'ignore)

(ignore-errors (tool-bar-mode 0))
(ignore-errors (menu-bar-mode 0))
(ignore-errors (scroll-bar-mode 0))
(add-hook 'after-init-hook (lambda() (interactive) (ignore-errors (scroll-bar-mode 0))))

(setq make-backup-files nil)
(setq auto-save-default nil)

(electric-pair-mode 1)

(global-linum-mode 1)
(setq linum-format " %d ")

(global-visual-line-mode 1)

(setq config/indent-size 2)
(setq-default indent-tabs-mode nil)
(setq-default tab-width config/indent-size)

(setq-default scroll-step 1)

(setq auto-revert-verbose nil)
(global-auto-revert-mode)

(defalias 'yes-or-no-p 'y-or-n-p)

(package-use 'general :require t)

(package-use 'which-key :require t)
(which-key-mode 1)

(package-use 'swiper :require t)

(package-use 'company :require t)

(package-use 'projectile :require t)
(projectile-global-mode 1)

(package-use 'ivy :require t)
(ivy-mode 1)

(package-use 'beacon :require t)
(beacon-mode 1)

(package-use 'highlight-parentheses :require t)
(global-highlight-parentheses-mode)

(package-use 'dashboard :require t)
(dashboard-setup-startup-hook)
(setq dashboard-startup-banner (config/path "banner.png"))
(setq dashboard-items '((recents . 5)
      (projects . 5)))
(setq dashboard-banner-logo-title "Welcome to Emacs.")

(package-use 'minor-mode-hack :require t)

(package-use 'avy :require t)

(package-use 'elmacro :require t)
(elmacro-mode 1)

(package-use 'exwm :require t)

(package-use 'undo-tree :require t)
(global-undo-tree-mode)

(package-use 'expand-region :require t)

(package-use 'multiple-cursors :require t)

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

(package-use 'origami :require t)
(global-origami-mode t)

(package-use 'lua-mode :require t)

(package-use 'company-lua :require t)
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-lua))

(setq lua-indent-level tab-width)

(defun lua-calculate-modifier (modifier)
  (if (= modifier 0)
      0
    lua-indent-level))

(defun lua-calculate-indentation (&optional parse-start)
  (save-excursion
    (let ((continuing-p (lua-is-continuing-statement-p))
          (cur-line-begin-pos (line-beginning-position)))
      (or
       (lua-calculate-indentation-override)

       (when (lua-forward-line-skip-blanks 'back)
         (let* ((modifier
                 (lua-calculate-indentation-block-modifier cur-line-begin-pos)))
           (+ (current-indentation) (lua-calculate-modifier modifier))))
       0))))

(defun lua-calculate-indentation-override (&optional parse-start)
  "Return overriding indentation amount for special cases.
Look for an uninterrupted sequence of block-closing tokens that starts
at the beginning of the line. For each of these tokens, shift indentation
to the left by the amount specified in lua-indent-level."
  (let ((indentation-modifier 0)
        (case-fold-search nil)
        (block-token nil))
    (save-excursion
      (if parse-start (goto-char parse-start))
      ;; Look for the last block closing token
      (back-to-indentation)
      (if (and (not (lua-comment-or-string-p))
               (looking-at lua-indentation-modifier-regexp)
               (let ((token-info (lua-get-block-token-info (match-string 0))))
                 (and token-info
                      (not (eq 'open (lua-get-token-type token-info))))))
          (when (lua-goto-matching-block-token nil nil 'backward)
            ;; Exception cases: when the start of the line is an assignment,
            ;; go to the start of the assignment instead of the matching item
            (let ((block-start-column (current-column))
                  (block-start-point (point)))
              (if (lua-point-is-after-left-shifter-p)
                  (current-indentation)
                block-start-column)))))))

(defun lua-calculate-indentation-override (&optional parse-start)
  "Return overriding indentation amount for special cases.
Look for an uninterrupted sequence of block-closing tokens that starts
at the beginning of the line. For each of these tokens, shift indentation
to the left by the amount specified in lua-indent-level."
  (let ((indentation-modifier 0)
        (case-fold-search nil)
        (block-token nil))
    (save-excursion
      (if parse-start (goto-char parse-start))
      ;; Look for the last block closing token
      (back-to-indentation)
      (if (and (not (lua-comment-or-string-p))
               (looking-at lua-indentation-modifier-regexp)
               (let ((token-info (lua-get-block-token-info (match-string 0))))
                 (and token-info
                      (not (eq 'open (lua-get-token-type token-info))))))
          (when (lua-goto-matching-block-token)
            ;; Exception cases: when the start of the line is an assignment,
            ;; go to the start of the assignment instead of the matching item
            (let ((block-start-column (current-column))
                  (block-start-point (point)))
              (if (lua-point-is-after-left-shifter-p)
                  (current-indentation)
                (current-indentation))))))))

(package-use 'moonscript :require t)

(package-use 'irony :require t)
(package-use 'company-irony :require t)
(package-use 'company-c-headers :require t)

(defun lang-c/add-hook (func-name)
  (add-hook 'c++-mode-hook func-name)
  (add-hook 'c-mode-hook func-name))

(when (not (string-equal system-type "windows-nt"))
  (lang-c/add-hook 'irony-mode))

(defun lang-c/change-checker()
  (add-to-list 'flycheck-disabled-checkers 'c/c++-clang)
  (add-to-list 'flycheck-enabled-checkers 'c/c++-gcc)
  (delete 'c/c++-clang flycheck-enabled-checkers))

(lang-c/add-hook 'lang-c/change-checker)

(setq-default sh-basic-offset tab-width)

(package-use 'd-mode :require t)

(setq self-inserting-characters '("`" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "-" "=" "q" "w" "e" "r" "t" "y" "u" "i" "o" "p" "[" "]" "a" "s" "d" "f" "g" "h" "j" "k" "l" ";" "'" "\\" "z" "x" "c" "v" "b" "n" "m" "," "." "/" "TAB" "SPC" "<tab>" "<space>" "~" "@" "#" "$" "%" "^" "&" "*" "(" ")" "_" "+" "Q" "W" "E" "R" "T" "Y" "U" "I" "O" "P" "{" "}" "A" "S" "D" "F" "G" "H" "J" "K" "L" ":" "\"" "|" ">" "Z" "X" "C" "V" "B" "N" "M" "<" ">" "?" "DEL"))

(defun make-normal-sparse-keymap()
  (setq result (make-sparse-keymap))
  (dolist (char self-inserting-characters)
    (define-key result (kbd char) 'ignore))
  result)

(setq modal/ignored-major-modes (list "dired-mode" "eshell-mode" "ibuffer-mode"))

(setq modal/emacs-map (make-sparse-keymap))
(setq modal/normal-map (make-sparse-keymap))
(setq modal/insert-map (make-sparse-keymap))
(setq modal/region-map (make-sparse-keymap))
(setq modal/rectangle-map (make-sparse-keymap))
(setq modal/multiple-cursors-map (make-sparse-keymap))

(defun modal/initialize()
  (define-minor-mode modal/normal-mode "Normal mode" nil "<Normal>" modal/normal-map)
  (define-minor-mode modal/emacs-mode "Emacs mode" nil "<Emacs>" modal/emacs-map)
  (define-minor-mode modal/insert-mode "Insert mode" nil "<Insert>" modal/insert-map)
  (define-minor-mode modal/region-mode "Region mode" nil "<Region>" modal/region-map)
  (define-minor-mode modal/rectangle-mode "Rectangle mode" nil "<Rectangle>" modal/rectangle-map)
  (define-minor-mode modal/multiple-cursors-mode nil nil nil modal/multiple-cursors-map
    (if modal/multiple-cursors-mode
        (raise-minor-mode-map-alist 'modal/multiple-cursors-mode))))

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
                 (member (symbol-name major-mode) modal/ignored-major-modes)))
        (modal/enable-normal)
      (modal/enable-emacs))))

(define-global-minor-mode global-modal-mode modal-mode (lambda() (modal-mode 1)))

(defun edit/surround(start end open close)
  (save-excursion
    (goto-char start)
    (insert open)
    (goto-char (+ end 1))
    (insert close)))

(defun edit/surround-region(open close)
  (when (region-active-p)
    (edit/surround (region-beginning) (region-end) open close)))

(defun edit/insert-after()
  (interactive)
  (forward-char)
  (modal/enable-insert))

(defun edit/insert-end-of-line()
  (interactive)
  (end-of-line)
  (modal/enable-insert))

(defun edit/insert-beginning-of-line()
  (interactive)
  (beginning-of-line)
  (modal/enable-insert))

(defun edit/set-region()
  (interactive)
  (set-mark (point))
  (modal/enable-region))

(defun edit/set-region-line()
  (interactive)
  (beginning-of-line)
  (set-mark (point))
  (end-of-line)
  (modal/enable-region))

(defun edit/open-line()
  (interactive)
  (end-of-line)
  (open-line 1)
  (next-line))

(defun edit/open-line-above()
  (interactive)
  (beginning-of-line)
  (open-line 1))

(defun edit/yank-line()
  (interactive)
  (save-excursion
    (edit/open-line)
    (yank)
    (delete-blank-lines)))

(defun edit/kill-whole-word()
  (interactive)
  (backward-char)
  (forward-word)
  (backward-kill-word 1))

(defun edit/copy-whole-line()
  (interactive)
  (save-excursion
    (kill-whole-line)
    (yank)))

(defun edit/yank-region()
  (interactive)
  (kill-region (region-beginning) (region-end))
  (yank 2)
  (modal/enable-normal))

(defun edit/insert-mark()
  (interactive)
  (insert "<++>"))

(defun edit/goto-mark()
  (interactive)
  (search-forward "<++>")
  (search-backward "<")
  (delete-char  4)
  (modal/enable-insert))

(defun edit/fold-toggle()
  (interactive)
  (if (string-equal major-mode "org-mode")
      (org-cycle)
    (origami-toggle-node (current-buffer) (point))))

(defun macro-make-function(&optional name)
  (interactive)
  (if (called-interactively-p 'any)
      (setq name (read-string "Macro name: "))
    (setq name (if name name "last-macro")))
  (setq function-string (pp-to-string (elmacro-make-defun (make-symbol (concat "macros/" name)) (elmacro-extract-last-macro elmacro-command-history))))
  (message function-string)
  (set-buffer (generate-new-buffer "*temporaryMacroBuffer*"))
  (erase-buffer)
  (insert function-string)
  (eval-buffer)
  (message function-string)
  (kill-buffer "*temporaryMacroBuffer*"))

(defun eshell/get-last-eshell-buffer()
  (catch 'buffer
    (dolist (buffer (buffer-list))
      (when (cl-search "*eshell*" (buffer-name buffer))
        (throw 'buffer buffer)))))

(defun eshell/switch-to-last-eshell-buffer()
  (let ((buffer (eshell/get-last-eshell-buffer)))
    (if buffer
        (switch-to-buffer buffer)
      (eshell))))

(defun eshell/toggle()
  (interactive)
  (if (cl-search "*eshell" (buffer-name))
      (switch-to-prev-buffer)
    (eshell/switch-to-last-eshell-buffer)))

(setq eshell/new-count 1)
(defun eshell/new()
  (interactive)
  (eshell eshell/new-count)
  (setq eshell/new-count (+ 1 eshell/new-count)))

(add-hook 'eshell-mode-hook (lambda() (interactive) (linum-mode 0)))

(general-define-key
 "C-x =" 'macro-make-function
 "C-x C-b" 'ibuffer)

(general-create-definer general-leader-define-key
  :prefix "C-c")

(general-leader-define-key
  "RET" 'eshell/toggle
  "<return>" 'eshell/toggle
  "C-RET" 'eshell/new
  "C-<return>" 'eshell/new
  "e b" 'eval-buffer
  "e r" 'eval-region
  "e e" 'eval-expression)

(general-define-key
 :keymaps 'modal/emacs-map
 "<escape>" (kbd "C-g")
 "M-g" (kbd "C-g")
 "M-q" 'modal/enable-normal
 "M-e" 'modal/enable-emacs)

(setq modal/normal-bare-map (make-sparse-keymap))

(general-define-key
 :keymaps 'modal/normal-bare-map
 "k" 'previous-line
 "K" 'scroll-down-command
 "j" 'next-line
 "J" 'scroll-up-command
 "h" 'backward-char
 "H" 'backward-word
 "l" 'forward-char
 "L" 'forward-word
 "a" 'beginning-of-line
 "f" 'end-of-line
 "SPC SPC" 'execute-extended-command
 "SPC s" 'save-some-buffers
 "SPC b" 'ivy-switch-buffer
 "SPC f" 'find-file
 "SPC d" 'dired
 "SPC k" 'kill-buffer
 "SPC RET" 'eshell/toggle
 "SPC S-RET" 'eshell/new)

(setq modal/normal-map (make-composed-keymap (list (copy-keymap modal/emacs-map) (copy-keymap modal/normal-bare-map)) (make-normal-sparse-keymap)))

(general-define-key
 :keymaps 'modal/normal-map
 "q" 'modal/enable-insert
 "Q" 'edit/insert-beginning-of-line
 "r" 'edit/insert-after
 "R" 'edit/insert-end-of-line
 "e" 'edit/set-region
 "E" 'edit/set-region-line
 "s" 'edit/copy-whole-line
 "d" (kbd "C-d")
 "D" 'kill-whole-line
 "w" 'yank
 "W" 'edit/yank-line
 "/" 'swiper
 "u" 'undo-tree-undo
 "U" 'undo-tree-redo
 "n" 'edit/open-line
 "N" (lambda() (interactive) (edit/open-line) (modal/enable-insert))
 "p" 'edit/open-line-above
 "P" (lambda() (interactive) (edit/open-line-above) (modal/enable-insert))
 "g" nil
 "g l" 'isearch-forward
 "g h" 'isearch-backward
 "g c" 'avy-goto-char
 "g l" 'avy-goto-line
 "m" 'edit/insert-mark
 "M" 'edit/goto-mark
 "TAB" 'edit/fold-toggle
 "<tab>" 'edit/fold-toggle)

(setq modal/region-map (make-composed-keymap (list (copy-keymap modal/emacs-map) (copy-keymap modal/normal-bare-map)) (make-normal-sparse-keymap)))

(general-define-key
 :keymaps 'modal/region-map
 "t" (lambda() (interactive) (kill-region (region-beginning) (region-end)) (modal/enable-insert))
 "s" (lambda() (interactive) (copy-region-as-kill (region-beginning) (region-end)) (modal/enable-normal))
 "d" (lambda() (interactive) (kill-region (region-beginning) (region-end)) (modal/enable-normal))
 "w" 'edit/yank-region
 "C-g" (lambda() (interactive) (pop-mark) (modal/enable-normal))
 "M-q" (lambda() (interactive) (pop-mark) (modal/enable-normal))
 "<escape>" (lambda() (interactive) (pop-mark) (modal/enable-normal))
 "e" 'er/expand-region
 "TAB" (lambda() (interactive) (indent-region (region-beginning) (region-end)) (modal/enable-normal))
 "<tab>" (lambda() (interactive) (indent-region (region-beginning) (region-end)) (modal/enable-normal))
 "g" nil
 "g l" 'isearch-forward
 "g h" 'isearch-backward
 ";" 'comment-or-uncomment-region
 "o" nil
 "m" (lambda() (interactive) (modal/multiple-cursors-mode 1))
 "o (" (lambda() (interactive) (edit/surround-region "(" ")") (modal/enable-normal))
 "o o" (lambda() (interactive) (edit/surround-region (read-from-minibuffer "left: ") (read-from-minibuffer "right: ")) (modal/enable-normal))
 "o )" (lambda() (interactive) (edit/surround-region "(" ")") (modal/enable-normal))
 "o {" (lambda() (interactive) (edit/surround-region "{" "}") (modal/enable-normal))
 "o }" (lambda() (interactive) (edit/surround-region "{" "}") (modal/enable-normal))
 "o [" (lambda() (interactive) (edit/surround-region "[" "]") (modal/enable-normal))
 "o ]" (lambda() (interactive) (edit/surround-region "[" "]") (modal/enable-normal))
 "o \"" (lambda() (interactive) (edit/surround-region "\"" "\"") (modal/enable-normal))
 "o <" (lambda() (interactive) (edit/surround-region "<" ">") (modal/enable-normal))
 "o '" (lambda() (interactive) (edit/surround-region "'" "'") (modal/enable-normal)))

(setq modal/insert-map (copy-keymap modal/emacs-map))

(general-define-key
 :keymaps 'modal/insert-map
 "C-g" 'modal/enable-normal)

(general-define-key
 :keymaps 'company-active-map
 "<tab>" 'company-complete
 "TAB" 'company-complete)

(defun set-eshell-custom-map()
  (general-leader-define-key
    :keymaps 'eshell-mode-map
    "RET" 'eshell/toggle
    "<return>" 'eshell/toggle))

(add-hook 'eshell-mode-hook 'set-eshell-custom-map)

(setq modal/multiple-cursors-map (make-normal-sparse-keymap))

(general-define-key
 :keymaps 'modal/multiple-cursors-map
 "n" 'mc/mark-next-like-this
 "p" 'mc/mark-pop
 "a" 'mc/mark-all-like-this
 "r" 'mc/mark-in-region
 "q" (lambda() (interactive) (modal/multiple-cursors-mode 0))
 "M-q" (lambda() (interactive) (modal/multiple-cursors-mode 0))
 "C-g" (lambda() (interactive) (modal/multiple-cursors-mode 0)))

(setq dired-mode-map (make-composed-keymap (list (copy-keymap modal/normal-bare-map)) dired-mode-map))

(general-define-key
 :keymaps 'dired-mode-map)

(general-define-key
 :keymaps 'ivy-minibuffer-map
 "M-j" 'ivy-next-line
 "M-k" 'ivy-previous-line
 "RET" 'ivy-immediate-done
 "TAB" 'ivy-partial-or-done)

(modal/initialize)
(global-modal-mode t)

(package-use 'all-the-icons :require t)
(package-use 'all-the-icons-dired :require t)

(package-use 'doom-modeline :require t)
(setq doom-modeline-height 32)
(doom-modeline-mode 1)

(defun theme/tty()
  (set-face-attribute 'company-tooltip nil
          :background "#FFFFFF"))

(defun theme/gui()
  (interactive)
  (package-use 'kaolin-themes)
  (setq x-theme-name (x-get-resource "themeName" "emacs"))
  (if x-theme-name
      (load-theme (intern x-theme-name) t)
    (load-theme 'kaolin-ocean t))
  (global-hl-line-mode)
  (when nil
    (set-face-attribute 'default nil
      :background "#121212"
      :foreground "#FFFFFF")
    (set-face-attribute 'mode-line nil
      :background "#202020")
    (set-face-attribute 'linum nil
      :foreground "#AAAAAA")
    (set-face-attribute 'region nil
      :background "#202040")
    (set-face-attribute 'hl-line nil
      :background "#202020")
    (set-face-attribute 'cursor nil
      :background "#CCCCCC"
      :foreground "#151515")
    )


  (setq font-name "monospace")
  (setq x-font-name (x-get-resource "fontName" "emacs"))
  (setq backup-fonts '("Cascadia Mono" "Consolas"))

  (if x-font-name
      (setq font-name x-font-name)
    (progn
      (catch 'loop
        (dolist (font backup-fonts)
          (when (find-font (font-spec :name font))
            (setq font-name font)
            (throw 'loop nil))))))


  (set-face-attribute 'default nil
                      :family font-name
                      :height 112)
  (set-face-attribute 'linum nil
                      :height 112))

(if (and (display-graphic-p) (not (daemonp)))
    (theme/gui)
  (theme/tty))
