;; mode: emacs-lisp; coding: utf-8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; By: Exaos Lee
;; URL: https://gist.github.com/4493582
;; References:
;;  - http://baohaojun.github.com/perfect-emacs-chinese-font.html
;;  - http://fonts.jp/hanazono/
;;  - http://ergoemacs.org/emacs/emacs_n_unicode.html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
;; [Logging]
;; 2013-04-11
;;   - http://www.cnblogs.com/bamanzi/archive/2012/12/08/emacs-24_3-cygwin-w32-gui.html
;;   - 本文件在 cygwin 下与 emacs-win32 配合不佳
;; 2013-04-13  字体的问题
;;   - 将 mintty 的 locale 修改为 GBK 之后，启动 emacs-w32 就正常了。
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                  字体显示测试                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
;; 中英文对齐
;;-------1---------2---------3---------4---------5---------6---------7--
;; abab  abababab  abababab  abababab  abababababab
;; 你我  你我你我  你我你我  你我你我  你我你我你我
;;3456789+123456789+123456789+123456789+123456789+123456789+123456789+12
;; 半角： 0 o O 1 l I | i ; : . ~ \ / - _ = ! @ # $ % ^ & * ` ' " () [] {}
;; 全角：  ， ； 、 。 ？ ！
;; —— “ ” ‘ ’ 《 》 ［ ］ 「」『』〈〉《》〖〗【】〔〕
;;---------------------------------------------------------------
;; 这儿的字符至少应该显示正常！
;; Esperanto: ĉ Ĉ ĝ Ĝ ĥ Ĥ ĵ Ĵ ŝ Ŝ ŭ Ŭ -- Ĵaudo Ĥoro aĝo antaŭ ĝoja
;; 化学元素： 𨧀 dù, 𨨏 (钅波) bō ㄅㄛ 𨭆 hēi 䥑 鐽 dá ㄉㄚˊ鎶
;; IPA: ðɫŋɹɾʃθtʒæɑəəɚɜɛɝɪɪ̈ɒɔʊʊ̈ʌ
;; àáâãäåæç èéêë ìíîï ðñòóôõö øùúûüýþÿ ÀÁÂÃÄÅ
;; Ç ÈÉÊË ÌÍÎÏ ÐÑ ÒÓÔÕÖ ØÙÚÛÜÝÞß
;; ¢ € ₠ £ ¥ ¤ ° © ® ™ § ¶ † ‡ ※ •◦ ‣ ✓●■◆○□◇★☆♠♣♥♦♤♧♡♢
;; ←→↑↓↔↖↗↙↘⇐⇒⇑⇓⇔⇗⇦⇨⇧⇩ ↞↠↟↡ ↺↻ ☞☜☝☟ ∀¬∧∨∃⊦∵∴∅∈∉⊂⊃⊆⊇⊄⋂⋃
;; ♩♪♫♬♭♮♯  ➀➁➂➃➄➅➆➇➈➉ 卐卍✝✚✡☥⎈☭☪☮☺☹ ☯☰☱☲☳☴☵☶☷
;; ☠☢☣☤♲♳⌬♨♿ ☉☼☾☽ ♀♂ ♔♕♖ ♗♘♙ ♚♛ ♜♝♞♟
 
;; 查看某个字符是什么字体，使用函数: (describe-char); 默认绑定的按键是: C-u C-x =
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(defun qiang-font-existsp (font)
  (if (null (x-list-fonts font)) nil t))
 
(defun qiang-make-font-string (font-name font-size)
  (if (and (stringp font-size) 
           (equal ":" (string (elt font-size 0))))
      (format "%s%s" font-name font-size)
    (format "%s-%s" font-name font-size)))
 
(defun qiang-set-font ( english-fonts
			english-font-size
			chinese-fonts
			&optional unicode-fonts )
  "The english-font-size could be set to \":pixelsize=18\" or a integer.
If set/leave chinese-font-size to nil, it will follow english-font-size"
  (require 'cl)   ;; for find if
  (unless unicode-fonts (setq unicode-fonts chinese-fonts))
  (let ((en-font (qiang-make-font-string
                  (find-if #'qiang-font-existsp english-fonts)
                  english-font-size))
        (zh-font  (font-spec :family (find-if #'qiang-font-existsp chinese-fonts)))
	(uni-font (font-spec :family (find-if #'qiang-font-existsp unicode-fonts))))
    ;; Set the default English font: for most latin characters
    (message "Set English Font to %s" en-font)
    (set-face-attribute 'default nil :font en-font)
 
    ;; Set Chinese font
    (message "Set Chinese Font to %s" zh-font)
    (dolist (charset '(kana han symbol cjk-misc bopomofo gb18030))
      (set-fontset-font t charset zh-font))
 
    ;; Set the font for unicode not covered above
    ;;     'prepend -- do not override the previous settings
    (message "Set Unicode Font to %s" uni-font)
    (set-fontset-font t nil uni-font nil 'prepend)
    ))
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
;; 常见字体 -- 查看系统可用字体: (print (font-family-list))
 
;; 等宽字体： DejaVu Sans Mono, Andale Mono, Liberation Mono,
;;            Nimbus Mono L, FreeMono, Droid Sans Mono, Monaco
;; 中文字体： (直接用第一次出现的名称)
;;     Adobe 明體 Std,Adobe Ming Std
;;     AR PL UMing CN
;;     微软雅黑,Microsoft YaHei
;;     宋体,SimSun
;;     新宋体,NSimSun
;;     宋体\-方正超大字符集,Simsun (Founder Extended)
;;     文泉驿微米黑,文泉驛微米黑,WenQuanYi Micro Hei
;;     文泉驿正黑,文泉驛正黑,WenQuanYi Zen Hei
;; Unicode 扩展字体： 包括汉字 ExtB ExtC ExtD 等
;;   HanaMinB,花園明朝B  ---  http://fonts.jp/hanazono/
;;   SimSun-ExtB         ---  http://www.chinesecj.com/code/ext-b.php
;;   MingLiU-ExtB, PMingLiU-ExtB, MingLiU_HKSCS-ExtB
 
;; 等比例缩放汉字及 Unicode 字符
;; 注意： 添加字体一定要重启 Emacs 才会生效！ 参考
;;  - http://debbugs.gnu.org/db/17/1785.html
(setq face-font-rescale-alist
      '(("AR PL UMing CN" . 1.2)
	("SimSun"  . 1.2)
	("NSimSun" . 1.2)
	("宋体"   . 1.2)
	("新宋体" . 1.2)
	("HanaMinB" . 1.2)
	("SimSun-ExtB" . 1.2)
	("Adobe 明體 Std" . 1.2)
	("微软雅黑" . 1.2)
	("文泉驿正黑" . 1.2)
	))
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
;; 透明窗口
(defun toggle-transparency ()
  (interactive)
  (if (/= (cadr (frame-parameter nil 'alpha)) 100)
      (set-frame-parameter nil 'alpha '(100 100))
    (set-frame-parameter nil 'alpha '(85 50))))
(global-set-key (kbd "C-c t") 'toggle-transparency)
 
;; 默认风格 (frame)
(defun my-default-frame-face ()
  ;; Default font
  (qiang-set-font
   '("Monaco" "Consolas" "DejaVu Sans Mono" "Monospace") 10
   '("新宋体" "微软雅黑" "AR PL UMing CN" "文泉驿正黑")
   '("SimSun-ExtB" "HanaMinB" "MingLiU-ExtB"))
  (set-face-attribute 'default nil :font (font-spec))
 
  ;; Frame size, etc.
  (setq initial-frame-alist '((width . 100) (height . 40)))
  (tool-bar-mode 0)
  (menu-bar-mode t)
 
  ;; 'color-theme or 'load-theme (emacs24)
  (if (>= emacs-major-version 24)
      (load-theme 'misterioso  t)
    (when (require 'color-theme nil 'noerror)
      (color-theme-initialize)
      (color-theme-clarity)
      ))
 
  ;; 窗口初始不透明
  (set-frame-parameter (selected-frame) 'alpha '(100 100))
  (add-to-list 'initial-frame-alist '(alpha 100 100)) )
 
;; If not in terminal, load default style
(if (display-graphic-p)
    (my-default-frame-face))
 
;; For emacsclient: apply default frame style to each new frame
(add-hook 'after-make-frame-functions
	  (lambda (new-frame)
	    (select-frame new-frame)
	    (my-default-frame-face) ))

(provide 'my-font-set-tmp)
