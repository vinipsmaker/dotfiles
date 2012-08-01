(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(make-backup-files nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Bitstream Vera Sans Mono" :foundry "bitstream" :slant normal :weight normal :height 90 :width normal)))))

(setq auto-save-default nil)
(set-scroll-bar-mode `right)
(column-number-mode 1)

;; Turn on warn highlighting for characters outside of the 'width' char limit
(defun font-lock-width-keyword (width)
  "Return a font-lock style keyword for a string beyond width WIDTH
   that uses 'font-lock-warning-face'."
  `((,(format "^%s\\(.+\\)" (make-string width ?.))
     (1 font-lock-warning-face t))))

(font-lock-add-keywords 'c-mode (font-lock-width-keyword 80))
(font-lock-add-keywords 'c++-mode (font-lock-width-keyword 80))

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
(yas/initialize)
(yas/load-directory "/usr/share/emacs/site-lisp/yas/snippets")

;; auto-complete install stuff
(add-to-list 'load-path "/usr/share/emacs/site-lisp/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/usr/share/emacs/site-lisp/auto-complete/ac-dict")
(ac-config-default)

;; auto-complete-clang install stuff
(require 'auto-complete-clang)
(setq clang-completion-suppress-error 't)

;; auto-complete config stuff
(setq ac-auto-start nil)
(setq ac-expand-on-auto-complete nil)
(setq ac-quick-help-delay 0.5)
(define-key ac-mode-map [C-tab] 'auto-complete)

;; auto-complete-clang config stuff
(defun my-ac-cc-mode-setup ()
  (setq ac-sources (append '(ac-source-clang) ac-sources)))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)

(setq ac-clang-flags
      (mapcar (lambda (item)(concat "-I" item))
              (split-string
               "
 /usr/include/c++/4.7.1
 /usr/include/c++/4.7.1/x86_64-unknown-linux-gnu
 /usr/include/c++/4.7.1/backward
 /usr/lib/gcc/x86_64-unknown-linux-gnu/4.7.1/include
 /usr/local/include
 /usr/lib/gcc/x86_64-unknown-linux-gnu/4.7.1/include-fixed
 /usr/include
"
               )))
(setq ac-clang-flags (append '("-std=c++11") ac-clang-flags))
