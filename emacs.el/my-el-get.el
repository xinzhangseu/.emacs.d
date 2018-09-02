;使用package.el管理emacs宏包

(require 'cl)   ;elpa好像需要cl(内建支持)，所以先require一下
;;(require 'package)
;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.org/packages/"))




(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (if (boundp 'package-selected-packages)
            ;; Record this as a package the user installed explicitly
            (package-install package nil)
          (package-install package))
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))


(defun maybe-require-package (package &optional min-version no-refresh)
  "Try to install PACKAGE, and return non-nil if successful.
In the event of failure, return nil and print a warning message.
Optionally require MIN-VERSION.  If NO-REFRESH is non-nil, the
available package lists will not be re-downloaded in order to
locate PACKAGE."
  (condition-case err
      (require-package package min-version no-refresh)
    (error
     (message "Couldn't install optional package `%s': %S" package err)
     nil)))

(setq package-archives 
      '(("my-gnu" . "/Users/Alsichkann/Sync/Qsync/myelpa/gnu/")
        ("my-elpa-stable" . "/Users/Alsichkann/Sync/Qsync/myelpa/melpa-stable/")
        ("my-melpa" . "/Users/Alsichkann/Sync/Qsync/myelpa/melpa/")
        ("my-marmalade" . "/Users/Alsichkann/Sync/Qsync/myelpa/marmalade/")
        ("my-org" . "/Users/Alsichkann/Sync/Qsync/myelpa/org/")
        ("gnu-cn"          . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("melpa-cn"        . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ("melpa-stable-cn" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa-stable/")
        ("org-cn"          . "https://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
        ("marmalade-cn"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/marmalade/")
        ("gnu" . "http://elpa.gnu.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ))

;;(package-refresh-contents)

;; update the package metadata is the local cache is missing
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))



;; (setq package-archives 
;;       '(("local-dir" . "~/Sync/Dropbox/Emacs/packages/")
;;         ("gnu" . "http://elpa.gnu.org/packages/")
;;         ("marmalade" . "http://marmalade-repo.org/packages/")
;;         ("melpa" . "http://melpa.milkbox.net/packages/")))



;; (setq package-archives '(("local-dir" . "~/Sync/Dropbox/Emacs/packages/")
;;                          ("gnu"   . "http://elpa.emacs-china.org/gnu/")
;;                          ("marmalade" . "http://elpa.emacs-china.org/marmalade/")
;;                          ("melpa" . "http://elpa.emacs-china.org/melpa/")))

;;el-get setting

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(el-get 'sync)
;; now either el-get is `require'd already, or have been `load'ed by the
;; el-get installer.


;; set local recipes
(setq
 el-get-sources
 '((:name buffer-move   ; have to add your own keys
           :after (progn
                    (global-set-key (kbd "<C-up>") 'buf-move-up)
                    (global-set-key (kbd "<C-down>") 'buf-move-down)
                    (global-set-key (kbd "<C-left>") 'buf-move-left)
                    (global-set-key (kbd "<C-right>") 'buf-move-right)))
                                                                          ))
;; now set our own packages
(setq my-el-get-packages
      (append
      '(buffer-move el-get auto-complete)
       (mapcar 'el-get-source-name el-get-sources)))

(el-get 'sync my-el-get-packages)

(provide 'my-el-get)













;;el-get setting ended
