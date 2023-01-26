;;; emacs-org.el --- for org-mode

;; Copyright 2009 Longmin WANG
;;
;; Author:xin.zhang.nku@gmail.com
;; Version: $Id: emacs-org.el,v 0.0 2009/08/18 15:32:18 sde Exp $
;; Keywords: 
;; X-URL: not distributed yet

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; 

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'emacs-org)

;;; Code:


;; ;; export to HTML
;; (setq org-export-html-style-include-default nil)

;; ;; export to HTML
;; (setq org-export-html-style-include-default nil)


;; (setq org-export-html-style "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://xzhang.imwork.net:6789/notes/css/org.css\">")

;; cdlatex mode
;; (add-hook 'org-mode-hook 'turn-on-org-cdlatex)




;;(require 'org)

(use-package org
  :ensure t
  :config                                        ; use the symbol when line is folding
  (setq org-ellipsis "******")
  (setq org-src-fontify-natively t)
                                        ; enable auto indent
  (setq org-startup-indented t)
                                        ; enable auto change line
  (add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
                                        ; enable auto add CLOSED time when change the TODO status to DONE
  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "|" "DRAFT(d)" "DONE(d)"))))
  (setq org-log-done 'time)
  )





(use-package ox-hugo
  :ensure t            ;Auto-install the package from Melpa (optional)
  :after ox)

(use-package org-superstar
  :hook
  (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-headline-bullets-list '("☰" "☷" "☵" "☲"  "☳" "☴"  "☶"  "☱" ))
  )
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))




(use-package org-fancy-priorities
  :diminish
  :ensure t
  :hook (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-priority-faces                                                      ; Set colors
        '((?A . "#ff5d38")
          (?B . "orange")
          (?C . "#98be65")
	  (?D . "red")
	  (?E . "#98be65")))
  (setq org-fancy-priorities-list '("🅰" "🅱" "🅲" "🅳" "🅴"))
  )

  


;;==========================================================Org管理待办任务============================================================================================>
;;设置 org-todo-keywords, 定义常用的 TODO 关键词，这些定义对所有文件都适用
(setq org-todo-keywords '((type "工作(w!)" "学习(s!)" "生活(l!)" "|") 
			 ;; (sequence "DOING(i!)" "TODO(t!)" "|" "DONE(d!)" "ABORT(a@/!)")
			  (sequence
			            "☞ TODO(t!)"  ; A task that needs doing & is ready to do
			            ;;"PROJ(p)"  ; An ongoing project that cannot be completed in one step
			            "⚔ INPROCESS(s)"  ; A task that is in progress
			            "⚑ PENDING(p!)"  ; Something is holding up this task; or it is paused
			            "|"
			            "☟ NEXT(n!)"
			            "✰ Important(i!)" 
			            "✔ DONE(d!)"  ; Task successfully completed
			            "✘ ABORT(a@/!)") ; Task was cancelled, aborted or is no longer applicable
			  ))
;;设置 TODO 关键词的外观变量 org-todo-keyword-faces, 用不同颜色的标签对日程表的事件进行强化分类
(setq org-todo-keyword-faces '
      (("工作" . (:background "red" :foreground "white" :weight bold)) 
       ("学习" . (:background "white" :foreground "red" :weight bold)) 
       ("生活" . (:foreground "MediumBlue" :weight bold)) 
       ("DOING" . (:background "LightGreen" :foreground "gray" :weight bold)) 
       ("TODO" . (:background "DarkOrange" :foreground "black" :weight bold)) 
       ("DONE" . (:background "azure" :foreground "Darkgreen" :weight bold)) 
       ("ABORT" . (:background "gray" :foreground "black"))
       ))
;; (setq org-todo-keywords
;;       '((sequence
;;          "☞ TODO(t)"  ; A task that needs doing & is ready to do
;;          "PROJ(p)"  ; An ongoing project that cannot be completed in one step
;;          "⚔ INPROCESS(s)"  ; A task that is in progress
;;          "⚑ WAITING(w)"  ; Something is holding up this task; or it is paused
;;          "|"
;;          "☟ NEXT(n)"
;;          "✰ Important(i)" 
;;          "✔ DONE(d)"  ; Task successfully completed
;;          "✘ CANCELED(c@)") ; Task was cancelled, aborted or is no longer applicable
;;         (sequence
;;          "✍ NOTE(N)"
;;          "FIXME(f)"
;;          "☕ BREAK(b)"
;;          "❤ Love(l)"
;;          "REVIEW(r)"
;;          ))) ; Task was completed
;; 优先级范围和默认任务的优先级
(setq org-highest-priority ?A)
(setq org-lowest-priority  ?E)
(setq org-default-priority ?C)
;; ;; 优先级醒目外观
;; (setq org-priority-faces
;;       '((?A . (:background "red" :foreground "white" :weight bold))
;; 	(?B . (:background "DarkOrange" :foreground "white" :weight bold))
;; 	(?C . (:background "yellow" :foreground "DarkGreen" :weight bold))
;; 	(?D . (:background "DodgerBlue" :foreground "black" :weight bold))
;; 	(?E . (:background "SkyBlue" :foreground "black" :weight bold))
;; 	))
;;设置后每次将任务改变为 DONE 状态时在任务下添加一行内容 CLOSED: [timestamp] ，而再将 DONE 状态改为 TODO 时该行内容被自动删除
;;如果项目结束时你还想对它写点评价子类的话，可以设置(setq org-log-done 'note),这样每次任务结束时Org就会提示你输入备注，并把它放到“Closing Note”标题下
(setq org-log-done 'time)




;;设置agenda搜索目录
(setq org-agenda-files (list "~/Sync/Emacs/Org"))
;;设置Org-mode 产生日程表的快捷键
(global-set-key "\C-ca" 'org-agenda)
(setq org-agenda-custom-commands
      '(
        ("w" . "任务安排")
        ("wa" "重要且紧急的任务" tags-todo "+PRIORITY=\"A\"")
        ("wb" "重要且不紧急的任务" tags-todo "-weekly-monthly-daily+PRIORITY=\"B\"")
        ("wc" "不重要且紧急的任务" tags-todo "+PRIORITY=\"C\"")
        ("W" "Weekly Review"
         ((stuck "") ;; review stuck projects as designated by org-stuck-projects
          (tags-todo "project")
          (tags-todo "daily")
          (tags-todo "weekly")
          (tags-todo "school")
          (tags-todo "code")
          (tags-todo "theory")
          ))
        ))



;; org-capture;
;;(setq org-default-notes-file "~/Sync/Emacs/Org/agenda/todo.org")
(global-set-key "\C-cc" 'org-capture)
;; (setq org-capture-templates
;;       '(("t" "Todo" entry (file+headline org-default-notes-file "待办事项")
;;          "* TODO %?\n  %i\n  %a")
;;         ("s" "收集篮" entry (file+headline org-default-notes-file "Quick notes")
;;          "* Quick notes %?\n %i\n %a")
;;         ))

(setq org-capture-templates
      '(("w" "Work Task" entry
         (file+headline "~/Sync/Emacs/Org/Tasks.org" "Work")
         "* TODO [#C] %^{任务名}\n%u\n%a\n" :clock-in t :clock-resume t :empty-lines 1)
	("r" "Research Task" entry
         (file+headline "~/Sync/Emacs/Org/Tasks.org" "Research")
         "* TODO [#C] %^{任务名}\n%u\n%a\n" :clock-in t :clock-resume t :empty-lines 1)
	;;("t" "Work Task" entry (file+headline "~/Sync/Emacs/Org/Tasks.org" "Work")
         ;;"* TODO [#C] %?\n %i\n %T\n %i\n %a" :empty-lines 1)
	("b" "Book Reading Task" entry
         (file+olp "~/Sync/Emacs/Org/Tasks.org" "Reading" "Book")
         "* TODO %^{书名}\n%u\n%a\n" :clock-in t :clock-resume t :empty-lines 1)
	("P" "Plan Task" entry (file+headline "~/Sync/Emacs/Org/Tasks.org" "Plan")
         "* TODO [#D] %?\n %i\n %T\n %i\n %a" :empty-lines 1)
	;;("W" "Web Collections" entry
        ;; (file+headline "~/Sync/Emacs/Org/Tasks.org" "Web Collections")
        ;; "* %U %:annotation\n\n%:initial\n\n%?")
	("n" "Notes" entry (file "~/Sync/Emacs/Org/Notes.org")
         "* %^{heading} %t %^g\n  %?\n")
        ("j" "Journal" entry (file+datetree "~/Sync/Emacs/Org/Journal.org")
         "* %U - %^{heading}\n  %?\n %a" :empty-lines 1)))

(require 'org-protocol)
(add-to-list 'org-capture-templates '("W" "Web Collections"))
(defun org-capture-template-goto-link ()
  (org-capture-put :target (list 'file+headline
                                 (nth 1 (org-capture-get :target))
                                 (org-capture-get :annotation)))
  (org-capture-put-target-region-and-position)
  (widen)
  (let ((hd (nth 2 (org-capture-get :target))))
    (goto-char (point-min))
    (if (re-search-forward
         (format org-complex-heading-regexp-format (regexp-quote hd)) nil t)
        (org-end-of-subtree)
      (goto-char (point-max))
      (or (bolp) (insert "\n"))
      (insert "* " hd "\n"))))
  (add-to-list 'org-capture-templates
               '("Wa" "Web Annotation" plain
		 (file+function "~/Sync/Emacs/Org/web.org" org-capture-template-goto-link)
		 "  %U - %?\n\n  %:initial" :empty-lines 1))


;; (add-to-list 'load-path "~/.emacs.d/lisp/org-protocol-capture-html")
(require 'org-protocol-capture-html)

(defun web-file-to-save ()
 (concat "~/Sync/Emacs/Org" (org-capture-get :description) ".org"))

(add-to-list 'org-capture-templates
             '("Wr" "Web Reading" plain
               ;; (function web-file-to-save)
               ;; "LINK: %:link\n\n%:initial" :immediate-finish t))
	       (file+function "~/Sync/Emacs/Org/web.org" web-file-to-save)
	       "* %a :website:\n %U \n %?\n\n%:initial" :empty-lines 1))
(use-package orca
  :ensure t
  :config
  )




;; (setq org-capture-templates
;;       '(("z" "Todo" )
;; 	("zw" "Well"  entry (file+headline "~/Sync/Emacs/Org/Tasks.org" "Welldot Tasks")
;;          "** TODO %?
;; :PROPERTIES:
;; :ID:       %(shell-command-to-string \"uuidgen\"):CREATED:  %U
;; %i
;; %a
;; :END:" :prepend t)))










;;==========================================================------------============================================================================================>







;; Populates only the EXPORT_FILE_NAME property in the inserted headline.
(with-eval-after-load 'org-capture
  (defun org-hugo-new-subtree-post-capture-template ()
    "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
    (let* (
	   (date (format-time-string (org-time-stamp-format :long :inactive) (org-current-time)))
           (title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " fname)
                   ,(concat ":EXPORT_DATE: " date)
                   ":END:"
                   "%?\n")          ;Place the cursor here finally
                 "\n")))

  (add-to-list 'org-capture-templates
               '("h"                ;`org-capture' binding + h
                 "Hugo post"
                 entry
                 ;; It is assumed that below file is present in `org-directory'
                 ;; and that it has a "Blog Ideas" heading. It can even be a
                 ;; symlink pointing to the actual location of all-posts.org!
                 (file+olp "~/Sync/Emacs/Orgtest.org" "test")
                 (function org-hugo-new-subtree-post-capture-template))))

(global-set-key (kbd "C-c r") 'org-capture)



(setq org-support-shift-select t)
;(add-hook 'org-mode-hook 'turn-on-org-cdlatex)



(setq org-html-doctype "html5") ;;;设置导出为HTML5格式, 默认貌似是XML.
(setq org-html-xml-declaration nil);;;;不生成XML头信息.
;;(setq org-html-postamble nil);;;;默认情况下导出的HTML末尾会有几行信息, 例如由org8导出, 作者是谁谁谁,日期多少多少. 我觉得这部分信息比较low, 于是通过这行代码取消postamble的生成.










(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(setq org-latex-compiler "xelatex")

(require 'ox-latex)
(setq org-export-latex-listings t)


;; (unless (boundp 'org-export-latex-classes)
;; (setq org-export-latex-classes nil)
(add-to-list 'org-latex-classes
             '("myarticle"
               "% !TEX encoding = UTF-8
     \\documentclass[a4paper,UTF8,12pt]{article}
\\renewcommand\\contentsname{目录}
\\renewcommand{\\baselinestretch}{1.3} % 行距
     \\usepackage{ifpdf}
     \\usepackage{ifxetex}
     \\ifxetex  
     \\usepackage[bookmarksnumbered, bookmarksopen,colorlinks,linkcolor=blue,anchorcolor=blue,citecolor=blue,breaklinks]{hyperref} \\usepackage{graphicx}
     \\usepackage{amsmath,amssymb}
     \\usepackage[mathscr]{eucal}
    \\usepackage[top=1.2in,bottom=1.2in,left=1.2in,right=1in]{geometry}
\\usepackage[numbers,sort&compress]{natbib}
   \\usepackage[cm-default]{fontspec}
   \\usepackage{xunicode,xltxtra}
   \\defaultfontfeatures{Mapping=tex-text}
 \\XeTeXlinebreaklocale \"zh\" 
\\XeTeXlinebreakskip = 0pt plus 1pt minus 0.1pt
\\setmainfont{Microsoft YaHei}
\\setmonofont{NSimSun}
     \\else
     \\ifpdf
     \\usepackage[pdftex,unicode,bookmarksnumbered, bookmarksopen,colorlinks,citecolor=blue,linkcolor=blue,CJKbookmarks]{hyperref}
     \\usepackage{graphicx}
     \\usepackage{amsmath,amssymb,amsfonts,amsthm}
     \\usepackage[mathscr]{eucal}
    \\usepackage[top=1.2in,bottom=1.2in,left=1.2in,right=1in]{geometry}
    \\usepackage[numbers,sort&compress]{natbib}
        \\else
     \\usepackage[dvipdfm,unicode]{hyperref}
     \\fi
     \\fi"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(setq org-export-latex-default-class "myarticle")



;; 有两个方法，一是在 org 文件头进行指定，如下：
;; #+LATEX_CMD: xelatex
;; 如果不想每次都在 org 文件头指定，可以在 emacs 配置文件中进行如下设定：

;; (setq org-latex-pdf-process '("xelatex -interaction nonstopmode %f"
;;                               "xelatex -interaction nonstopmode %f"))


;;;;;;;;;可以添加org-latex导出默认的package
(setq org-latex-default-packages-alist
      '(
        ;;("" "fontenc" nil)
        ;;("AUTO" "inputenc" t)
        ;;("" "fixltx2e" nil)
       ;; ("" "graphicx" nil)
        ;;("" "longtable" nil)
        ;;("" "float" nil)
        ;;("" "wrapfig" nil)
        ;;("" "rotating" nil)
        ("normalem" "ulem" t)
        ;;("" "amsmath" nil)
        ("" "textcomp" t)
        ("" "marvosym" t)
        ("" "wasysym" t)
        ("" "multicol" t)  ; 這是我另外加的，因為常需要多欄位文件版面。
        ;;("" "amssymb" nil)
        "\\tolerance=1000"))


(require 'ox-publish)

;; (setq org-publish-project-alist
;;       '(
;;         ("org-notes2011anal-org"
;;          :base-directory "~/Sync/Dropbox/Emacs/Org/" ;;project directory to store you source(.org) files.
;;          :base-extension "org"
;;          :publishing-directory "/xzhangweb@alsichkann.f3322.net:/volume1/web/notes/" ;;export directory
;;          ;;:publishing-directory "~/myemacs/org-publish/public_html" ;;export directory
;;          :html-head "<link href="http://fonts.googleapis.com/css?family=Roboto+Slab:400,700|Inconsolata:400,700" rel="stylesheet" type="text/css"/>"
;;          :html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://xzhang.imwork.net:6789/notes/css/style.css\"/>"
;;          :recursive t
;;          :publishing-function org-html-publish-to-html
;;          :headline-levels 4             ;; Just the default for this project.
;;          :auto-preamble t
;;          :auto-index t                  ; Generate index.org automagically...
;;          :index-filename "sitemap.org"  ; ... call it sitemap.org ...
;;          :index-title "Sitemap"         ; ... with title 'Sitemap'.
;;          )
;;         ;; ("org-static"  ;; synchronization for other related resource for html pages.
;;         ;; :base-directory  "~/myemacs/org/"
;;         ;; :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|txt\\|zip\\|rar"
;;         ;; :publishing-directory "~/myemacs/org-publish/public_html/"
;;         ;; :recursive t
;;         ;; :publishing-function org-publish-attachment
;;         ;; )


(setq org-publish-project-alist
      '(
        ("org-notes2011anal-org"
         :base-directory "~/Sync/Emacs/Org/" ;;project directory to store you source(.org) files.
         :base-extension "org"
         :publishing-directory "/ssh:Alsichkann@xzhang.ink#1819:/volume1/web/xzhang/" ;;export directory
         ;;:publishing-directory "~/myemacs/org-publish/public_html" ;;export directory
         :html-head "<link href=\"http://www.pirilampo.org/styles/readtheorg/css/htmlize.css\" rel=\"stylesheet\" type=\"text/css\" />"
         :html-head "<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js\"></script>"
         :html-head "<script src=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js\"></script>"
         :html-head "<script type=\"text/javascript\" src=\"http://www.pirilampo.org/styles/readtheorg/js/readtheorg.js\"></script>"
         :html-head "<script type=\"text/javascript\" src=\"http://xzhang.ink:7000/xzhang/css/org-script.js\"></script>"
         :html-head "<link href=\"http://xzhang.ink:7000/xzhang/css/readtheorg.css\" rel=\"stylesheet\" type=\"text/css\" />"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 4             ;; Just the default for this project.
         :auto-preamble t
         :auto-index t                  ; Generate index.org automagically...
         :index-filename "sitemap.org"  ; ... call it sitemap.org ...
         :index-title "Sitemap"         ; ... with title 'Sitemap'.
         )
        ;; ("org-static"  ;; synchronization for other related resource for html pages.
        ;; :base-directory  "~/myemacs/org/"
        ;; :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|txt\\|zip\\|rar"
        ;; :publishing-directory "~/myemacs/org-publish/public_html/"
        ;; :recursive t
        ;; :publishing-function org-publish-attachment
        ;; )


















("org-notes2011anal-pdf"
         :base-directory "~/Sync/Emacs/Org/"
         :base-extension "org"
         :publishing-directory "~/Sync/Emacs/Org/"
         ;;:recursive t
         :publishing-function org-latex-publish-to-pdf
         ;;:auto-preamble t
         )
        ("org-notes2011anal-upload"
         :base-directory "~/Sync/Emacs/Org/"
         :base-extension "jpg\\|gif\\|png\\|pdf"
         :publishing-directory "/ssh:Alsichkann@xzhang.ink#1819:/volume1/web/xzhang/"
         :recursive t
         :publishing-function org-publish-attachment)

        ("org-notes2011anal" :components ("org-notes2011anal-org" "org-notes2011anal-pdf" "org-notes2011anal-upload"))
        ))






















(provide 'emacs-org)    
;; (eval-when-compile
;;   (require 'cl))


;;; emacs-org.el ends here
