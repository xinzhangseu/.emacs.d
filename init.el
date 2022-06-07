;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:


(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory)) ; 设定源码加载路径

;;(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
;;(defconst *is-a-mac* (eq system-type 'darwin))



(desktop-save-mode 1)              ;;Emacs自带保存桌面功能.
(setq desktop-save-directory "~/.emacs.d/.emacs-deskop")
(setq desktop-change-dir "~/.emacs.d/.emacs-deskop")

(server-start)

;;==================================================Package Source=========================================================================>>
;; 这两段一定要在 init.el 的最上方
(require 'package)
;; 初始化包管理器
(package-initialize)
;;;Package Source
;; ------ 官方源 ------
;;(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
;;	("melpa" . "https://melpa.org/packages/")))

;; ------ Emacs China 源 ------
;;(setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
;;			 ("melpa" . "http://elpa.emacs-china.org/melpa/")))

;; ------ 腾讯源 ------
;;(setq package-archives '(("gnu"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")
;;                         ("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")))

;; ------ 清华源 ------
(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                        ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))


;;(setq package-archives '(("gnu"   . "http://mirror.nju.edu.cn/elpa/gnu/")
;;                         ("melpa" . "http://mirror.nju.edu.cn/elpa/melpa/")))
;;=====================================================================================================================================>>


;;==================================================use-package=========================================================================>>
;; 如果 use-package 没安装
(unless (package-installed-p 'use-package)
  ;; 更新本地缓存
  (package-refresh-contents)
  ;; 之后安装它。use-package 应该是你配置中唯一一个需要这样安装的包。
  (package-install 'use-package))

(require 'use-package)
;; 让 use-package 永远按需安装软件包
(setq use-package-always-ensure t)
;;=====================================================================================================================================>>

;;====================================Projectile===========================================================================================>

(use-package projectile
  :config
  ;; 把它的缓存挪到 ~/.emacs.d/.cache/ 文件夹下，让 gitignore 好做
  (setq projectile-cache-file (expand-file-name ".cache/projectile.cache" user-emacs-directory))
  ;; 全局 enable 这个 minor mode
  (projectile-mode 1)
  ;; 定义和它有关的功能的 leader key
  (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map))

;;=========================================================================================================================================>



;;=======================================================ivy===============================================================================>

(use-package ivy
  :ensure t
  :diminish ivy-mode
  :hook (after-init . ivy-mode))

;;=========================================================================================================================================>


;;======================================git============================================================================================>>
(use-package magit
  :ensure t
)
;;=====================================================================================================================================>>


(require 'init-general)
(require 'emacs-tex)
(require 'emacs-org)

;;=========================================================================================================================================>



;(add-hook 'org-mode-hook 'flyspell-mode)
;(add-hook 'org-mode-hook 'flyspell-Company)
;;=========================================Zotero==========================================================================================>

(use-package zotxt
  :ensure t
  :hook
  (org-mode . org-zotxt-mode)
)

(use-package zotelo
  :ensure t
  :hook
  (TeX-mode . zotelo-minor-mode)
)
;;=========================================================================================================================================>


;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(package-selected-packages
;;    '(org zotxt company auto-complete-auctex auto-complete auctex)))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )
;;; package --- Summary
;;; Commentary:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(magit org-bullets projectile zotxt use-package company auto-complete-auctex auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
