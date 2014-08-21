(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(column-number-mode t)
 '(fill-column 80)
 '(indent-tabs-mode nil)
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(make-backup-files nil)
 '(safe-local-variable-values (quote ((c-file-offsets (innamespace . 0) (inline-open . 0) (case-label . +)))))
 '(show-trailing-whitespace t)
 '(visible-bell t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Bitstream Vera Sans Mono" :foundry "bitstream" :slant normal :weight normal :height 90 :width normal))))
 '(markdown-header-delimiter-face ((t (:inherit font-lock-function-name-face :underline t :weight bold))) t)
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.5))) t)
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.3))) t)
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :underline t :height 1.2))) t)
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :underline t :height 1.1))) t)
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :underline t))) t)
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :underline t))) t))

;; Turn on warn highlighting for characters outside of the 'width' char limit
(defun font-lock-width-keyword (width)
  "Return a font-lock style keyword for a string beyond width WIDTH
   that uses 'font-lock-warning-face'."
  `((,(format "^%s\\(.+\\)" (make-string width ?.))
     (1 font-lock-warning-face t))))

(font-lock-add-keywords 'c-mode (font-lock-width-keyword 80))
(font-lock-add-keywords 'c++-mode (font-lock-width-keyword 80))

;; Format the title-bar to always include the buffer name
(setq frame-title-format "emacs - %b")

;; Scroll line by line
(setq scroll-step 1)

;; show matching parens:
(show-paren-mode 1)
(setq show-paren-delay 0)

;; treat .h files as c++ files
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; AUCTeX
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

;; ECoding style
;; http://trac.enlightenment.org/e/wiki/ECoding/Emacs
(c-add-style
 "e"
 '("gnu"
   (show-trailing-whitespace t)
   (indent-tabs-mode . nil)
   (tab-width . 8)
   (c-offsets-alist.
    ((defun-block-intro . 3)
     (statement-block-intro . 3)
     (case-label . 1)
     (statement-case-intro . 3)
     (inclass . 3)
     ))))

;; user style (using Qt coding conventions)
(setq c-basic-offset 4)

;; yasnippet install stuff
(add-to-list 'load-path "/usr/share/emacs/site-lisp/yas")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/global-mode 1) ;; or manually load it with yas-global-mode

;; auto-complete install stuff
(add-to-list 'load-path "/usr/share/emacs/site-lisp/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/usr/share/emacs/site-lisp/auto-complete/ac-dict")
(ac-config-default)

;; auto-complete config stuff
(setq ac-auto-start nil)
(setq ac-expand-on-auto-complete nil)
(setq ac-quick-help-delay 0.5)
(define-key ac-mode-map [C-tab] 'auto-complete)

;;;; auto-complete-clang install stuff
(require 'auto-complete-clang-async)

;;;; auto-complete-clang config stuff
(defun ac-cc-mode-setup ()
  ;(setq ac-clang-complete-executable "~/.emacs.d/clang-complete")
  (setq ac-sources '(ac-source-clang-async))
  (ac-clang-launch-completion-process)
)

(defun my-ac-config ()
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))

(my-ac-config)

;; CMake mode stuff
(require 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode)
                ("\\.cmake\\'" . cmake-mode))
              auto-mode-alist))

(defun cmake-rename-buffer ()
  "Renames a CMakeLists.txt buffer to cmake-<directory name>."
  (interactive)
  ;(print (concat "buffer-filename = " (buffer-file-name)))
  ;(print (concat "buffer-name     = " (buffer-name)))
  (when (and (buffer-file-name) (string-match "CMakeLists.txt" (buffer-name)))
    ;(setq file-name (file-name-nondirectory (buffer-file-name)))
    (setq parent-dir (file-name-nondirectory (directory-file-name (file-name-directory (buffer-file-name)))))
    ;(print (concat "parent-dir = " parent-dir))
    (setq new-buffer-name (concat "cmake-" parent-dir))
    ;(print (concat "new-buffer-name= " new-buffer-name))
    (rename-buffer new-buffer-name t)
    )
  )

(add-hook 'cmake-mode-hook (function cmake-rename-buffer))

;; PKGBUILD stuff
(setq auto-mode-alist
      (append '(("/PKGBUILD$" . shell-script-mode))
              auto-mode-alist))

;; LLVM stuff
(setq load-path
    (cons (expand-file-name "~/.emacs.d/llvm") load-path))
(require 'llvm-mode)
(require 'tablegen-mode)

;; MarkDown stuff

(autoload 'markdown-mode "markdown-mode" "Markdown mode" t)
(setq auto-mode-alist (cons '("\\.md\\'" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.markdown\\'" . markdown-mode) auto-mode-alist))


(put 'set-goal-column 'disabled nil)

;; Fuc*ing C++ mode keeps identing namespace members
;(defconst my-cc-style
;  '("cc-mode"
;    (c-offsets-alist . ((innamespace . [0])))))
;
;(c-add-style "my-cc-mode" my-cc-style)
(defun my-c-setup ()
  (c-set-offset 'innamespace [0]))
(add-hook 'c++-mode-hook 'my-c-setup)

;; Quickly switching between header and implementation
(add-hook 'c-mode-common-hook
  (lambda()
    (local-set-key  (kbd "C-c t") 'ff-find-other-file)))

;; Spray - an open spritz implementation
(setq load-path
    (cons (expand-file-name "~/.emacs.d/spray") load-path))
(require 'spray)
(global-set-key (kbd "<f6>") 'spray-mode)
