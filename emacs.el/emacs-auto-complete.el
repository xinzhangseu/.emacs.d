;;; emacs-yas.el --- yet another snippet extension for Emacs.

;; Copyright (C) 2009 Xin Zhang

;; Author: Xin Zhang <nku.x.zhang@gmail.com>
;; Keywords: local, c, lisp, tex, extensions, abbrev

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

(add-to-list 'load-path "~/.emacs.d/el-get/auto-complete/")
(add-to-list 'ac-dictionary-directories "~/.emacs.d/el-get/auto-complete/dict")
(require 'auto-complete-config)
(ac-config-default)


(global-auto-complete-mode t)
(define-key ac-complete-mode-map (kbd "<return>") 'ac-complete)
(define-key ac-complete-mode-map (kbd "M-j")      'ac-complete)
(define-key ac-complete-mode-map (kbd "M-n")      'ac-next)
(define-key ac-complete-mode-map (kbd "M-p")      'ac-previous)

(require 'auto-complete-yasnippet)

(setq ac-sources
             '(;;ac-source-semantic
               ac-source-yasnippet
               ac-source-abbrev
               ac-source-words-in-buffer
               ac-source-words-in-all-buffer
               ;;ac-source-imenu
               ac-source-files-in-current-dir
               ;;ac-source-filename
))

(setq ac-modes (append ac-modes '(latex-mode)))

(add-hook 'latex-mode-hook
          (lambda ()
            (push 'ac-source-yasnippet ac-sources)
            (push 'ac-source-words-in-buffer ac-sources)
            (push 'ac-source-words-in-all-buffer ac-sources)
            (push 'ac-source-files-in-current-dir ac-sources)
            (push 'ac-source-filename ac-sources)
            ;;(push 'ac-source-imenu ac-sources)
                                                     ))

;; 启动热键
(ac-set-trigger-key "TAB")
;; 候補的最大件数（缺省 10件）
(setq ac-candidate-max 20)

(require 'ac-math)

;;(add-to-list 'ac-modes 'latex-mode)   ; make auto-complete aware of {{{latex-mode}}}

(defun ac-latex-mode-setup ()         ; add ac-sources to default ac-sources
  (setq ac-sources
        (append '(ac-source-math-latex ac-source-latex-commands ac-source-math-unicode 'ac-source-yasnippet ac-source-words-in-buffer ac-source-words-in-all-buffer)
               ac-sources))
)

(add-hook 'LaTeX-mode-hook 'ac-latex-mode-setup)

;; ac-source-math-unicode

(ac-flyspell-workaround)



(provide 'emacs-auto-complete)
;;; emacs-auto-complete.el ends here
