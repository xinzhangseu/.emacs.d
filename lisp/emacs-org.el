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


(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))



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
