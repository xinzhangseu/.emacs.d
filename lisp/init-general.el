;;; hello -- Echo "Hello, world!"
;;; Commentary:
;;; Code:




;;===========================================================================================================================================>
;;;  Emacs 启动居于左半屏幕 
(if (not (eq window-system nil))
    (progn
      ;; top, left ... must be integer
      (add-to-list 'default-frame-alist
                   (cons 'top  (* (x-display-pixel-height) 0)))
      (add-to-list 'default-frame-alist
                   (cons 'left (* (x-display-pixel-width) 0)))
      (add-to-list 'default-frame-alist
                   (cons 'height (/ (* 5 (x-display-pixel-height))
                                    (* 5 (frame-char-height)))))
      (add-to-list 'default-frame-alist
                   (cons 'width (/ (* 49 (x-display-pixel-width))
                                   (* 100 (frame-char-width)))))))
;;===========================================================================================================================================>

(setq default-buffer-file-coding-system 'utf-8
    ; default-frame-alist (append '((top + 0)(left -0)(width . 128) (height . 80)) default-frame-alist);;; left +660 closetoright.
      visible-bell nil
      inhibit-startup-message t                ;;关闭启动 Emacs 时的欢迎界面
      transient-mark-mode t                    ;;加亮选中部分 
      default-major-mode 'text-mode            ;;设置缺省模式是text，而不是基本模式
      truncate-partial-width-windows nil       ;; 窗口中内容自动换行
      default-fill-column 256                  ;; 窗口中内容自动换行
      mouse-yank-at-point t                    ;; 支持中键粘贴
      make-backup-files nil                    ;; 关闭文件自动备份
      display-line-numbers-type 'relative      ;; （可选）显示相对行号
      ;;column-number-mode t                   ;; 在 mode-line 中显示列号
      ;; 备份目录
      backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t
      ;; 备份的版本控制
      version-control t
      kept-new-versions 3
      delete-old-versions t
      kept-old-versions 2
      dired-kept-versions 1
      ;; 设置 emacs 的标题
      frame-title-format "emacs@%b %f" 
      ;;设置 sentence-end 可以识别中文标点。不用在 fill 时在句号后插入两个空格。
      sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*"
      ;;设定句子结尾，主要针对中文设置
      ;; (setq sentence-end "\\([ $(A!##!#? (B]\\| $(A!-!- (B\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
      sentence-end-double-space nil
      ;;括号匹配时显示另外一边的括号，而不是烦人的跳到另一个括号。
      show-paren-style 'parentheses
      ;;防止页面滚动时跳动， scroll-margin 3 可以在靠近屏幕边沿3行时就开始滚动，可以很好的看到上下;文。
      scroll-margin 3 scroll-conservatively 10000
      ;;设置日历表的中文天干地支，在日期上按 `p C' 就可以显示农历和干支。
      ;;chinese-calendar-celestial-stem ["甲" "乙" "丙" "丁" "戊" "已" "庚" "辛" "壬" "癸"]
      ;;chinese-calendar-terrestrial-branch ["子" "丑" "寅" "卯" "辰" "巳" "午" "未" "申" "酉" "戌" "亥"]
      ;;时间显示设置 
      display-time-24hr-format t
      display-time-day-and-date t   
      user-full-name "Xin Zhang"
      user-mail-address "nku.x.zhang@gmail.com" 
      skeleton-pair t
      )
 



 





(electric-pair-mode t)                       ; 自动补全括号
(add-hook 'prog-mode-hook #'show-paren-mode) ; 编程模式下，光标在括号上时高亮另一个括号
(column-number-mode t)                       ; 在 Mode line 上显示列号
(global-auto-revert-mode t)                  ; 当另一程序修改了文件时，让 Emacs 及时刷新 Buffer
(delete-selection-mode t)                    ; 选中文本后输入文本会替换文本（更符合我们习惯了的其它编辑器的逻辑）
(add-hook 'prog-mode-hook #'hs-minor-mode)   ; 编程模式下，可以折叠代码块
(global-display-line-numbers-mode 1)         ; 在 Window 显示行号
(tool-bar-mode -1)                           ; 关闭 Tool bar
(global-font-lock-mode t)                    ; 语法高亮
(when (display-graphic-p) (toggle-scroll-bar -1)) ; 图形界面时关闭滚动条

(savehist-mode 1)                            ; （可选）打开 Buffer 历史记录保存
;(add-to-list 'default-frame-alist '(width . 90))  ; （可选）设定启动图形界面时的初始 Frame 宽度（字符数）
;(add-to-list 'default-frame-alist '(height . 55)) ; （可选）设定启动图形界面时的初始 Frame 高度（字符数）
(display-time-mode 1)  ; 启用时间显示设置

;;=========================================================================================================================================>


;;=======================================Emacs 中文日历======================================================================================>

(use-package cal-china-x
  :config
  (setq mark-holidays-in-calendar t)
  (setq my-holidays '(
		      ;;公历节日
		      (holiday-fixed 2 14 "情人节")
		      (holiday-fixed 9 10 "教师节") 
		      (holiday-float 6 0 3 "父亲节") 
		      ;; 农历节日 
		      (holiday-lunar 1 1 "春节" 0) 
		      (holiday-lunar 1 15 "元宵节" 0) 
		      (holiday-solar-term "清明" "清明节") 
		      (holiday-lunar 5 5 "端午节" 0) 
		      (holiday-lunar 7 7 "七夕情人节" 0) 
		      (holiday-lunar 8 15 "中秋节" 0)
		      ;;纪念日 
		      (holiday-fixed 9 7 "女儿生日") 
		      (holiday-lunar 3 11 "老婆生日" 0) 
		      (holiday-lunar 3 6 "我的生日" 0) )) 
  (setq calendar-holidays my-holidays);;只显示我定制的节假日
  ;;holiday-fixed 用于设定公历事件,  holiday-float 用于设定浮动公历事件,  holiday-lunar 用于设定农历事件，各项的意义参考后面的 diary-float 说明,
  ;;holiday-solar-term 是一些预定义但还需要特殊计算的节日，如农历的24节气
  )
;;=========================================================================================================================================>

;;================================拼写检查==================================================================================================>

;; for spell check
;; could be ispell as well, depending on your preferences
;;(setq ispell-program-name "hunspell")
;; this can obviously be set to any language your spell-checking program supports
;;(setq ispell-dictionary "en_US")
(use-package flyspell 
  :hook ((text-mode . flyspell-mode)
	 (org-mode . flyspell-mode)
	 ;;(org-mode . flyspell-Company)
	 (prog-mode . flyspell-prog-mode)) 
  :config 
  (when (executable-find "hunspell") 
    (setq ispell-program-name (executable-find "hunspell")) 
    (setq ispell-really-hunspell t) 
    (setenv "DICTIONARY" "en_US")) 
  (setq ispell-dictionary "en_US"))

;; ;; NO spell check for embedded snippets
;; (defadvice org-mode-flyspell-verify (after org-mode-flyspell-verify-hack activate)
;;   (let* ((rlt ad-return-value)
;;          (begin-regexp "^[ \t]*#\\+begin_\\(src\\|html\\|latex\\|example\\|quote\\)")
;;          (end-regexp "^[ \t]*#\\+end_\\(src\\|html\\|latex\\|example\\|quote\\)")
;;          (case-fold-search t)
;;          b e)
;;     (when ad-return-value
;;       (save-excursion
;;         (setq b (re-search-backward begin-regexp nil t))
;;         (if b (setq e (re-search-forward end-regexp nil t))))
;;       (if (and b e (< (point) e)) (setq rlt nil)))
;;     (setq ad-return-value rlt)))

;;=========================================================================================================================================>


;;==========================================buffer-mode===================================================================================>

(use-package company
  ;; 等价于 (add-hook 'after-init-hook #'global-company-mode)
  :hook (after-init . global-company-mode)
  :config
  ;; setq 可以像这样连着设置多个变量的值
  (setq company-tooltip-align-annotations t ; 注释贴右侧对齐
        company-tooltip-limit 20            ; 菜单里可选项数量
        company-show-numbers t              ; 显示编号（然后可以用 M-数字 快速选定某一项）
        company-idle-delay 0               ; 延时多少秒后弹出
        company-minimum-prefix-length 1     ; 至少几个字符后开始补全
        )
  ;; company mode 默认选择上一条和下一条候选项命令 M-n M-p
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))

;;=========================================================================================================================================>






;;;复制、粘贴、剪切、撤消、保存等快捷键设置为与os x一致

(global-set-key (kbd "M-a") 'mark-whole-buffer) ;;对应Windows上面的Ctrl-a 全选
(global-set-key (kbd "M-c") 'kill-ring-save) ;;对应Windows上面的Ctrl-c 复制
(global-set-key (kbd "M-s") 'save-buffer) ;; 对应Windows上面的Ctrl-s 保存
(global-set-key (kbd "M-v") 'yank) ;对应Windows上面的Ctrl-v 粘贴
(global-set-key (kbd "M-z") 'undo) ;对应Windows上面的Ctrol-z 撤销
(global-set-key (kbd "M-y") 'kill-region) ;对应Windows上面的Ctrol-x 剪切

;;=========================================================================================================================================>


;;=================================================代码格式化===============================================================================>
;; ;;Emacs 里对代码的格式化支持的非常好，不但可以在编辑的时候自动帮你格式化，还可以选中一块代码，按 Ctrl-Alt-\
;; ;;对这块代码重新进行格式化。如果要粘贴一块代码的话，粘贴完了紧接着按 Ctrl-Alt-\ 就可以把新加入的代码格式化
;; ;;对于这种粘贴加上重新格式化的机械操作，Emacs 应该可以将它自动化才能配得上它的名气，把下面的代码加到配置文件里
;; ;;你的 Emacs 就会拥有这种能力了
(dolist (command '(yank yank-pop))
  (eval
   `(defadvice ,command (after indent-region activate)
	  (and (not current-prefix-arg)
		   (member major-mode
				   '(emacs-lisp-mode
					 lisp-mode
					 clojure-mode
					 scheme-mode
					 haskell-mode
					 ruby-mode
					 rspec-mode
					 python-mode
					 c-mode
					 c++-mode
					 objc-mode
					 latex-mode
					 js-mode
					 plain-tex-mode))
		   (let ((mark-even-if-inactive transient-mark-mode))
			 (indent-region (region-beginning) (region-end) nil))))))
;;==========================================================================================================================================>

;; ;;括号匹配时显示另外一边的括号，而不是烦人的跳到另一个括号。
;; (show-paren-mode t)
;; (setq show-paren-style 'parentheses)  

;; (auto-fill-mode 1)
;; (auto-image-file-mode)
;; (blink-cursor-mode -1)             ;;光标不要闪烁
;; (mouse-avoidance-mode 'animate)    ;;光标靠近鼠标指针时，让鼠标指针自动让开，别挡住视线。
;; ;;(cua-mode)                         ;; copy/paste with C-c and C-v and C-x, check out C-RET too
;; (fset 'yes-or-no-p 'y-or-n-p)      ;; 把 yes or no 换为 y or n

;; ;; 不用 TAB 来缩进，只用空格。
;; (setq-default indent-tabs-mode nil)
;; (setq default-tab-width 4)
;; (setq tab-stop-list nil)
;; (add-hook 'text-mode-hook 'auto-fill-mode)

;;  ;     (append '((width . 78) (height . 98) (top . -15) (left . 0) (font . "4.System VIl-frame-alist))

;; ≈;(setq default-frame-alist
;;  ;     (append '((width . 78) (height . 98h) (top . -15) (left . 0) (font . "4.System VIO"))
;;   ;           default-frame-alist))

;; ;; (setq default-frame-alist
;; ;;       '((height . 40) (width . 80) (menu-bar-lines . 20) (tool-bar-lines . 0))) 

;; ;;启用时间显示设置 
;; (display-time-mode 1)  




;; ;; 这个是对 Linux 用的。设置之后才能从 emacs 拷贝到别的程序中

;; (when (eq window-system 'x)
;;   (setq x-select-enable-clipboard t))


;; ;; 记录修改时间，在文件头部加入 Time-stamp: <> 或者 Time-stamp: " "
;; (add-hook 'write-file-hooks 'time-stamp)
;; (setq time-stamp-format "%:u %02m/%02d/%04y %02H:%02M:%02S")


;; ;; =============== Spell Checking ====================>
;; ;(setq-default
;; ;              ;;Spell Checking
;; ;              ispell-program-name "aspell"
;; ;              ispell-local-dictionary "american"
;; ;              ;; 文本行间距
;; ;              line-spacing 4
;; ;              desktop-load-locked-desktop t
;; ;)

;; (add-hook 'text-mode-hook 'flyspell-mode)
;; (add-hook 'org-mode-hook 'turn-on-auto-fill)



;; ;; 如果没有激活的区域，就注释/反注释当前行，仅当在行尾的时候才在行尾加注释呢
;; (defun qiang-comment-dwim-line (&optional arg) 
;;   "Replacement for the comment-dwim command.
;; If no region is selected and current line is not blank and we are not at the end of the line,
;; then comment current line.
;; Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
;;   (interactive "*P")
;;   (comment-normalize-vars)
;;   (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
;;       (comment-or-uncomment-region (line-beginning-position) (line-end-position))
;;     (comment-dwim arg)))
;; (global-set-key "\M-;" 'qiang-comment-dwim-line)



;; ;;复制当前行
;; ;; Smart copy, if no region active, it simply copy the current whole line
;; (defadvice kill-line (before check-position activate)
;;   (if (member major-mode
;; 			  '(emacs-lisp-mode scheme-mode lisp-mode
;; 								c-mode c++-mode objc-mode js-mode
;; 								latex-mode plain-tex-mode))
;; 	  (if (and (eolp) (not (bolp)))
;; 		  (progn (forward-char 1)
;; 				 (just-one-space 0)
;; 				 (backward-char 1)))))

;; (defadvice kill-ring-save (before slick-copy activate compile)
;;   "When called interactively with no active region, copy a single line instead."
;;   (interactive (if mark-active (list (region-beginning) (region-end))
;; 				 (message "Copied line")
;; 				 (list (line-beginning-position)
;; 					   (line-beginning-position 2)))))

;; (defadvice kill-region (before slick-cut activate compile)
;;   "When called interactively with no active region, kill a single line instead."
;;   (interactive
;;    (if mark-active (list (region-beginning) (region-end))
;; 	 (list (line-beginning-position)
;; 		   (line-beginning-position 2)))))

;; ;; Copy line from point to the end, exclude the line break
;; (defun qiang-copy-line (arg)
;;   "Copy lines (as many as prefix argument) in the kill ring"
;;   (interactive "p")
;;   (kill-ring-save (point)
;; 				  (line-end-position))
;;   ;; (line-beginning-position (+ 1 arg)))
;;   (message "%d line%s copied" arg (if (= 1 arg) "" "s")))

;; (global-set-key (kbd "M-k") 'qiang-copy-line)


;; ;; tabbar 
;; (require 'tabbar)
;; (tabbar-mode t)
;; (global-set-key [(meta j)] 'tabbar-backward)  
;; (global-set-key [(meta l)] 'tabbar-forward)  
;; ;;;; 设置tabbar外观
;; ;; 设置默认主题: 字体, 背景和前景颜色，大小
;; (set-face-attribute 'tabbar-default nil
;;                     :family "Vera Sans YuanTi Mono"
;;                     :background "gray80"
;;                     :foreground "gray30"
;;                     :height 1.0
;;                     )
;; ;; 设置左边按钮外观：外框框边大小和颜色
;; (set-face-attribute 'tabbar-button nil 
;;                     :inherit 'tabbar-default
;;                     :box '(:line-width 1 :color "gray30")
;;                     )
;; ;; 设置当前tab外观：颜色，字体，外框大小和颜色
;; (set-face-attribute 'tabbar-selected nil
;;                     :inherit 'tabbar-default
;;                     :foreground "DarkGreen"
;;                     :background "LightGoldenrod"
;;                     :box '(:line-width 2 :color "DarkGoldenrod")
;;                     ;; :overline "black"
;;                     ;; :underline "black"
;;                     :weight 'bold
;;                     )
;; ;; 设置非当前tab外观：外框大小和颜色
;; (set-face-attribute 'tabbar-unselected nil
;;                     :inherit 'tabbar-default
;;                     :box '(:line-width 2 :color "gray70")
;;                     )

;;  (setq tabbar-buffer-groups-function
;;           (lambda ()
;;            (list "All"))) ;; code by Peter Barabas


;; ;;加强c-x c-b (buffer list)的功能，用起来和目录差不多, 按 g 刷新
;; (require 'ibuffer)
;; (global-set-key (kbd "C-x C-b") 'ibuffer)
;; (autoload 'ibuffer "ibuffer" "List buffers." t)
 
;; ;;用于在dired模式下直接修改文件或目录名(默认配置按r)
;; (require 'wdired)
;; (autoload 'wdired-change-to-wdired-mode "wdired")
;; (define-key dired-mode-map "r"
;; 'wdired-change-to-wdired-mode)



;; ;; use ido for minibuffer completion
;; (require 'ido)
;; (ido-mode t)
;; (setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
;; (setq ido-enable-flex-matching t)
;; (setq ido-use-filename-at-point 'guess)
;; (setq ido-show-dot-for-dired t)



;; ;;匹配括号等
;; (defun my-common-mode-auto-pair () 
;;   (interactive) 
;;   (make-local-variable 'skeleton-pair-alist) 
;;   (setq skeleton-pair-alist '( 
;;                               (? ? _ "''") 
;;                               (? ? _ """") 
;;                               (? ? _ "()") 
;;                               (? ? _ "$$") 
;;                               (? ? _ "[]") 
;;                               (? ? _ "{}")
;;                               ;;(?{ \n > _ \n ?} >)
;;                               )) 
;;   (setq skeleton-pair t) 
;;   (local-set-key (kbd "$") 'skeleton-pair-insert-maybe) 
;;   (local-set-key (kbd "(") 'skeleton-pair-insert-maybe) 
;;   (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe) 
;;   (local-set-key (kbd "{") 'skeleton-pair-insert-maybe) 
;;   (local-set-key (kbd "\'") 'skeleton-pair-insert-maybe) 
;;   (local-set-key (kbd "[") 'skeleton-pair-insert-maybe))
;; (add-hook 'LaTeX-mode-hook 'my-common-mode-auto-pair) 
;; (add-hook 'latex-mode-hook 'my-common-mode-auto-pair)  
;; (add-hook 'c++-mode-hook 'my-common-mode-auto-pair)
;; (add-hook 'org-mode-hook 'my-common-mode-auto-pair)

;; ;; C-x C-j opens dired with the cursor right on the file you're editing
;; (require 'dired-x)

;; (require 'emacs-auto-complete)
;; (require 'emacs-yas)



;; ;; 保存编辑位置
;; (require 'saveplace)
;; (setq save-place-file "~/.emacs.d/.emacs-places")
;; (setq-default save-place t)

;; (desktop-save-mode 1)              ;;Emacs自带保存桌面功能.
;; (setq desktop-save-directory "~/.emacs-deskop/")
;; (setq desktop-change-dir "~/.emacs-deskop/")





(provide 'init-general) ; 
;;; init-general.el ends here
