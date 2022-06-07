;;; emacs-tex.el --- Set up for ConTeXt

;; Copyright (C) 2009  Longmin Wang

;; Author: Xin Zhang <nku.x.zhang@gmail.com>
;; Keywords: tex, local

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:



;;;;;;;;;;;;;;AUCTex initiating;;;;
;;(add-to-list 'load-path "/usr/local/share/emacs/site-lisp")

;;(load "auctex.el" nil t t)
;;(load "tex-site.el" nil t t)
;;(load "preview-latex.el" nil t t)

(require 'auctex-latexmk)
(auctex-latexmk-setup)



(setq TeX-show-compilation nil) 

(setq reftex-external-file-finders 
      '(("tex" . "/Library/TeX/texbin/kpsewhich -format=.tex %f") 
        ("bib" . "/Library/TeX/texbin/kpsewhich -format=.bib %f")))
'(reftex-use-external-file-finders t)


(setq TeX-auto-save t)
(setq TeX-parse-self t)
;;(setq-default TeX-master nil)
(setq TeX-source-specials-mode t)
(setq TeX-parse-all-errors nil)
;;(setq TeX-electric-escape nil) ;;; Avoid input "\" to turn to the minibuffer.


;;(add-hook 'TeX-mode-hook 'zotelo-minor-mode)

;;;;;;;;;;;;RefTex;;;;;;;;;;;;;;;;
(require 'reftex)
;;(require 'auto-complete)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
(add-hook 'latex-mode-hook 'turn-on-reftex)   ; with Emacs latex mode


(setq reftex-enable-partial-scans t)
(setq reftex-save-parse-info t)
(setq reftex-use-multiple-selection-buffers t)
(setq reftex-toc-split-windows-horizontally t) ;;*toc*buffer在左侧。
(setq reftex-toc-split-windows-fraction 0.2)  ;;*toc*buffer 使用整个frame的比例。
(autoload 'reftex-mode "reftex" "RefTeX Minor Mode" t)
(autoload 'turn-on-reftex "reftex" "RefTeX Minor Mode" nil)
(autoload 'reftex-citation "reftex-cite" "Make citation" nil)  
(autoload 'reftex-index-phrase-mode "reftex-index" "Phrase mode" t)




(setq default-major-mode 'latex-mode)

;;;;;;;;;math-mode;;;;;;;;;;;;;;;
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

 ;;;;;;;;;LaTex-mode settings;;;;;
(add-hook 'LaTeX-mode-hook (lambda ()
                             (turn-off-auto-fill)              ;;LaTeX模式下，不打开自动折行
                             (auto-complete-mode 1)
                             ;;(outline-minor-mode 1)            ;;使用 LaTeX mode 的时候打开 outline mode
                             ;;(setq TeX-show-compilation nil)   ;;NOT display compilation windows
                             (setq TeX-global-PDF-mode t       ;;PDF mode enable, not plain
                                   TeX-engine 'xetex)  ;;use xelatex default
                             (setq TeX-clean-confirm nil)
                             (setq TeX-save-query nil)
                             (imenu-add-menubar-index)
                             (setq font-latex-fontify-script t)
                             (define-key LaTeX-mode-map (kbd "TAB") 'TeX-complete-symbol)
                             (setq TeX-electric-escape nil)      ;; 按 \ 后光标不跳到mini-buffer里面输入命令
                             ;; Compile XeLaTeX, -synctex=-1可使得pdf实现反向搜索。
                             ;;在SumatraPdf\setting\option\set inverse search command line: D:\Emacs23.1\bin\gnuclientw.exe +%l "%f"
                             (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex -synctex=1%(mode)%' %t" TeX-run-TeX nil
                                                              (latex-mode doctex-mode)
                                                              :help "Run LaTeX"))
                             (add-to-list 'TeX-command-list '("PDFLaTeX" "%`pdflatex -synctex=1%(mode)%' %t" TeX-run-TeX nil
                                                              (latex-mode doctex-mode)
                                                              :help "Run LaTeX"))
                             (add-to-list 'TeX-command-list '("View" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b" TeX-run-TeX nil
                                                              (latex-mode doctex-mode)
                                                              :help "Run LaTeX"))
                             (setq TeX-command-default "View");;设置默认XeLaTex编译tex文件
                             (setq TeX-command-default "XeLaTeX");;设置默认XeLaTex编译tex文件
                             (setq TeX-fold-env-spec-list (quote (("[comment]" ("comment")) ("[figure]" ("figure")) ("[table]" ("table"))("[itemize]"("itemize"))("[enumerate]"("enumerate"))("[description]"("description"))("[overpic]"("overpic"))("[tabularx]"("tabularx"))("[code]"("code"))("[shell]"("shell")))))
                             ;;定义latex-mode下的快捷键
                             (define-key LaTeX-mode-map (kbd "C-c p") 'reftex-parse-all)                         
                  ;;;;;;设置更深层的目录;;;;;;;;;;;;;
                             (setq reftex-section-levels
                                   '(("part" . 0) ("chapter" . 1) ("section" . 2) ("subsection" . 3)
                                     ("frametitle" . 4) ("subsubsection" . 4) ("paragraph" . 5)
                                     ("subparagraph" . 6) ("addchap" . -1) ("addsec" . -2)))
                             (setq LaTeX-section-hook
                                   '(LaTeX-section-heading
                                     LaTeX-section-title
                                     ;;LaTeX-section-toc
                                     LaTeX-section-section
                                     LaTeX-section-label))
                             ));;




(add-hook 'TeX-mode-hook
           (lambda ()
             (local-set-key "("
                            '(lambda ()
                               (interactive)
                               (insert-balanced ?\( ?\))))))

;; Compile XeTeX
(add-hook 'TeX-mode-hook 
          (lambda()
            (add-to-list 'TeX-command-list '("XeTeX" "xetex %t" TeX-run-TeX nil
                                             (plain-tex-mode ams-tex-mode texinfo-mode)
                                             :help "Run plain TeX"))
            (add-to-list 'TeX-command-list '("View" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b" TeX-run-TeX nil
                                             (latex-mode doctex-mode)
                                             :help "Run LaTeX"))
                        ;;    (add-to-list 'TeX-output-view-style
            ;;                 (("^pdf$" "." "okular %o %(outpage)")))
            ;;    (custom-set-variables
            ;;     '(TeX-output-view-style (quote (("^pdf$" "." "okular %o %(outpage)"))))
            ;;     )
            ))



(setq TeX-view-program-list
      '(("SumatraPDF" "SumatraPDF.exe %o")
        ("Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")
        ("Gsview" "gsview32.exe %o")
        ("Okular" "okular --unique %o")
        ("Evince" "evince %o")
        ("Firefox" "firefox %o")))
(cond
 ((eq system-type 'darwin)
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (setq TeX-view-program-selection '((output-pdf "Skim")
                                                 (output-dvi "Yap"))))))
 ((eq system-type 'windows-nt)
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (setq TeX-view-program-selection '((output-pdf "SumatraPDF")
                                                 (output-dvi "Yap"))))))
 ((eq system-type 'gnu/linux)
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (setq TeX-view-program-selection '((output-pdf "Okular")
                                                 (output-dvi "Okular")))))))


;;(server-start); start emacs in server mode so that skim can talk to it






;; (add-hook 'LaTeX-mode-hook
;;     (lambda ()
;;    (setq TeX-output-view-style (cons '("^dvi$" "." "yap %o") 
;; TeX-output-view-style))
;;    ))
;;  (add-hook 'LaTeX-mode-hook
;;      (lambda ()
;;      (setq TeX-output-view-style (cons '("^pdf$" "." "okular %o %(outpage)") 
;;   TeX-output-view-style))
;;     ))


;;设置xelatex生成的pdf阅览器为SumatraPdf-Tex.exe
;; (add-hook 'LaTeX-mode-hook
;;     (lambda ()
;;     (setq TeX-output-view-style (cons '("^pdf$" "." "C:/CTEX/CTeX/ctex/bin/SumatraPDF-TeX.exe %o") 
;;  TeX-output-view-style))
;;    ))










;;设置用dviout预览dvi文件，dviout反向搜索在Option/setup parameters/common/src写入
;;D:\Emacs23.1\bin\gnuclientw.exe^s+%d "%s"
;;(add-hook 'LaTeX-mode-hook
                                        ;    (lambda ()
                                        ;   (setq TeX-output-view-style (cons '("^dvi$" "." "dviout %o") 
                                        ;TeX-output-view-style))
                                        ;   ))
;;设置xelatex生成的pdf阅览器为SumatraPdf-Tex.exe
                                        ;(add-hook 'LaTeX-mode-hook
                                        ;    (lambda ()
                                        ;    (setq TeX-output-view-style (cons '("^pdf$" "." "C:/texlive/SumatraPDF-TeX.exe %o") 
                                        ; TeX-output-view-style))
                                        ;   ))

;;;;Tex一键编译。
;; (require 'tex-buf)
;; (defun TeX-command-default (name)
;;   "Next TeX command to use. Most of the code is stolen from `TeX-command-query'."
;;   (cond ((if (string-equal name TeX-region)
;; 			     (TeX-check-files (concat name "." (TeX-output-extension))
;; 					      (list name)
;; 					      TeX-file-extensions)
;; 			   (TeX-save-document (TeX-master-file)))
;; 			 TeX-command-default)
;; 			((and (memq major-mode '(doctex-mode latex-mode))
;; 			      (TeX-check-files (concat name ".bbl")
;; 					       (mapcar 'car
;; 						       (LaTeX-bibliography-list))
;; 					       BibTeX-file-extensions))
;; 			 ;; We should check for bst files here as well.
;; 			 TeX-command-BibTeX)
;; 			((TeX-process-get-variable name
;; 						   'TeX-command-next
;; 						   TeX-command-Show))
;; 			(TeX-command-Show)))


;; (defcustom TeX-texify-Show t "Start view-command at end of TeX-texify?" :type 'boolean :group 'TeX-command)
;; (defcustom TeX-texify-max-runs-same-command 5 "Maximal run number of the same command" :type 'integer :group 'TeX-command)

;; (defun TeX-texify-sentinel (&optional proc sentinel)
;;   "Non-interactive! Call the standard-sentinel of the current LaTeX-process.
;; If there is still something left do do start the next latex-command."
;;   (set-buffer (process-buffer proc))
;;   (funcall TeX-texify-sentinel proc sentinel)
;;   (let ((case-fold-search nil))
;;     (when (string-match "\\(finished\\|exited\\)" sentinel)
;;       (set-buffer TeX-command-buffer)
;;       (unless (plist-get TeX-error-report-switches (intern (TeX-master-file)))
;; 	(TeX-texify)))))

;; (defun TeX-texify ()
;;   "Get everything done."
;;   (interactive)
;;   (let ((nextCmd (TeX-command-default (TeX-master-file)))
;; 	proc)
;;     (if (and (null TeX-texify-Show)
;; 	     (equal nextCmd TeX-command-Show))
;; 	(when  (called-interactively-p 'any)
;; 	  (message "TeX-texify: Nothing to be done."))
;;       (TeX-command nextCmd 'TeX-master-file)
;;       (when (or (called-interactively-p 'any)
;; 		(null (boundp 'TeX-texify-count-same-command))
;; 		(null (boundp 'TeX-texify-last-command))
;; 		(null (equal nextCmd TeX-texify-last-command)))
;; 	(mapc 'make-local-variable '(TeX-texify-sentinel TeX-texify-count-same-command TeX-texify-last-command))
;; 	(setq TeX-texify-count-same-command 1))
;;       (if (>= TeX-texify-count-same-command TeX-texify-max-runs-same-command)
;; 	  (message "TeX-texify: Did %S already %d times. Don't want to do it anymore." TeX-texify-last-command TeX-texify-count-same-command)
;; 	(setq TeX-texify-count-same-command (1+ TeX-texify-count-same-command))
;; 	(setq TeX-texify-last-command nextCmd)
;; 	(and (null (equal nextCmd TeX-command-Show))
;; 	     (setq proc (get-buffer-process (current-buffer)))
;; 	     (setq TeX-texify-sentinel (process-sentinel proc))
;; 	     (set-process-sentinel proc 'TeX-texify-sentinel))))))

;; (add-hook 'LaTeX-mode-hook '(lambda () (local-set-key (kbd "C-c C-a") 'TeX-texify)))

;;;;Tex一键编译。


;; CDLATEX对于公式较多的场合很方便的
;;(autoload 'cdlatex-mode "cdlatex" "CDLaTeX Mode" t)
;;(autoload 'turn-on-cdlatex "cdlatex" "CDLaTeX Mode" nil) 
;;(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)   ; with AUCTeX LaTeX mode
                                        ;(add-hook 'latex-mode-hook 'turn-on-cdlatex)   ; with Emacs latex mode

                                        ;工具栏添加 LaTeX 文档的章节索引
                                        ;使用 AUCTeX 和 RefTeX 编辑 LaTeX 文件时，如果你喜欢用鼠标，不妨试试这个，
                                        ;可以在工具栏添加一个“Index”菜单，直接在你的章节之间跳转。
                                        ;M-x imenu-add-menubar-index 或者

(setq reftex-load-hook (quote (imenu-add-menubar-index)))
(setq reftex-mode-hook (quote (imenu-add-menubar-index)))

;;(define-key LaTeX-mode-map (kbd "C-c C-p") 'reftex-parse-all)
;; ;; 定制数学环境下的快捷输入，``?'' 是指 (after `LaTeX-math-abbrev-prefix')
;; (setq LaTeX-math-list
;;       '((?/ "frac" "Constructs")
;;         (?2 "sqrt" "Constructs" 8730)
;;         (?p "partial" "Misc Symbol" 8706) ;; #X2202
;;         ("v ~" "widetilde" "Constructs" 771) ;; #X0303
;;         ))


;;(require 'sumatra-forward)
(provide 'emacs-tex)
