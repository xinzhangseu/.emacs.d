;;将下载的lisp放在~/myemacs/packages
;;(add-to-list 'load-path "~/myemacs/emacs.el" "~/myemacs/emacs.init")
;;(mapc 'load (directory-files "~/myemacs/emacs.init" t "^[a-zA-Z0-9].*.el$"))
;;设置风格corlor theme


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq ns-pop-up-frames nil)

(add-to-list 'load-path  "~/.emacs.d/emacs.el")
(require 'myemacs)			

;;The following is test;;



;;(add-to-list 'load-path "~/Sync/Dropbox/Emacs/emacs.el")
;;(load "~/Sync/Dropbox/Emacs/emacs.el/subdirs")
;;(load "~/Sync/Dropbox/Emacs/emacs.el/myemacs")
;;(require 'myemacs)

;;The above is test;;

(global-set-key [(f1)] (lambda()        ;;设定F1为woman快捷键
                         (interactive) 
                         (let ((woman-topic-at-point t))
                           (woman))))
(setq woman-use-own-frame nil)


(setenv "PATH"
        (concat
         (getenv "PATH")
         ":""/Library/TeX/texbin"
         ;;":""/opt/local/sbin"
         ))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )





;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(TeX-command-BibTeX "/Library/TeX/texbin/bibtex")
;;  '(exec-path
;;    (quote
;;     ("/Library/TeX/texbin" "/usr/local/bin" "/usr/bin" "/bin" "/usr/sbin" "/sbin" "/Applications/Emacs.app/Contents/MacOS/bin-x86_64-10_9" "/Applications/Emacs.app/Contents/MacOS/libexec-x86_64-10_9" "/Applications/Emacs.app/Contents/MacOS/libexec" "/Applications/Emacs.app/Contents/MacOS/bin"))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/Sync/Dropbox/Emacs/Org/a.org")))
 '(package-selected-packages (quote (auctex))))
