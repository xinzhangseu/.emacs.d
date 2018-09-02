(setenv "PATH" (concat "/usr/texbin:/usr/local/bin:" (getenv "PATH"))) 
       (setq exec-path (append '("/usr/texbin" "/usr/local/bin") exec-path))

(server-start) 

(require 'my-el-get)

 
;;设置风格corlor theme
;;(require 'color-theme)
   ; (color-theme-initialize)
  ;  (color-theme-robin-hood)
 ;   (color-theme-gnome2)
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
	 (color-theme-initialize)
	 (color-theme-blackboard)))

;;(require 'my-font-set)          ;;设置字体

;; 设置默认字体
(set-default-font "YaHei Consolas Hybrid")
(set-fontset-font "fontset-default"
  'unicode '("YaHei Consolas Hybrid" . "unicode-bmp"))

;; choose your own fonts, in a system dependant way
;(if (string-match "apple-darwin" system-configuration)
;    (set-face-font 'default "YaHei Consolas Hybrid")
;  (set-face-font 'default "YaHei Consolas Hybrid"))

;; choose your own fonts, in a system dependant way
;(if (string-match "apple-darwin" system-configuration)
;    (set-face-font 'default "Monaco-13")
;  (set-face-font 'default "Monospace-10"))



;; on to the visual settings
(require 'linum)             ;;显示行号与列号
(global-linum-mode t)    
(setq column-number-mode t)  ;; 在 mode-line 中显示列号

;;括号匹配时显示另外一边的括号，而不是烦人的跳到另一个括号。
(show-paren-mode t)
(setq show-paren-style 'parentheses)

(auto-fill-mode 1)
(auto-image-file-mode)
(global-font-lock-mode t)          ;; 语法高亮
(blink-cursor-mode -1)             ;;光标不要闪烁
(mouse-avoidance-mode 'animate)    ;;光标靠近鼠标指针时，让鼠标指针自动让开，别挡住视线。
;;(cua-mode)                         ;; copy/paste with C-c and C-v and C-x, check out C-RET too
(fset 'yes-or-no-p 'y-or-n-p)      ;; 把 yes or no 换为 y or n

;; 不用 TAB 来缩进，只用空格。
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-stop-list nil)
(add-hook 'text-mode-hook 'auto-fill-mode)



;;启用时间显示设置 
(display-time-mode 1)  

(setq default-buffer-file-coding-system 'utf-8
      default-frame-alist (append '((top + 0)(left + 0)(width . 80) (height . 70)) default-frame-alist);;; left +660 closetoright.
      visible-bell nil
      inhibit-startup-message t                ;;关闭启动时的 “开机画面”
      transient-mark-mode t                    ;;加亮选中部分 
      default-major-mode 'text-mode            ;;设置缺省模式是text，而不是基本模式
      truncate-partial-width-windows nil       ;; 窗口中内容自动换行
      default-fill-column 68                   ;; 窗口中内容自动换行
      mouse-yank-at-point t                    ;; 支持中键粘贴
      ;;column-number-mode t                     ;; 在 mode-line 中显示列号
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
 











;; 保存编辑位置
(require 'saveplace)
(setq save-place-file "~/.emacs.d/.emacs-places")
(setq-default save-place t)

(desktop-save-mode 1)              ;;Emacs自带保存桌面功能.
(setq desktop-save-directory "~/.emacs-deskop/")
(setq desktop-change-dir "~/.emacs-deskop/")





(provide 'myemacstmp)

