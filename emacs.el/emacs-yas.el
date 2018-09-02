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

;;(add-to-list 'load-path "~/Dropbox/uemacs/emacs.el/yasnippet/yasnippet.el")
;;(require 'yasnippet)
;;(yas/initialize)
;;(setq yas/snippet-dirs "/home/alsichkann/Dropbox/uemacs/emacs.el/yasnippet/snippets")
;;(yas/load-directory yas/snippet-dirs)

;;(add-to-list 'load-path "~/Sync/Dropbox/uemacs/emacs.el/yasnippet/yasnippet.el")
(require 'yasnippet)
;; (yas/initialize)
(yas-global-mode 1)
(setq yas-snippet-dirs "~/.emacs.d/el-get/yasnippet/snippets")
;; (yas/load-directory yas/root-directory)


;;   The `dropdown-list.el' extension is bundled with YASnippet, you
;;   can optionally use it the preferred "prompting method", puting in
;;   your .emacs file, for example:

(require 'dropdown-list)
      (setq yas/prompt-functions '(yas/dropdown-prompt
                                    yas/ido-prompt
                                    yas/completing-prompt))




;;(yas/initialize)

;;(setq yas/my-directory "~/Dropbox/uemacs/emacs.el/yasnippet/snippets")

;;(yas/load-directory yas/my-directory)

(provide 'emacs-yas)
;;; emacs-yas.el ends here
