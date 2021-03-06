;;; yasnippet-tests.el --- some yasnippet tests  -*- lexical-binding: t -*-

;; Copyright (C) 2012, 2013, 2014, 2015  Free Software Foundation, Inc.

;; Author: Jo?o T?vora <joaot@siscog.pt>
;; Keywords: emulations, convenience

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

;; Test basic snippet mechanics and the loading system

;;; Code:

(require 'yasnippet)
(require 'ert)
(require 'ert-x)
(require 'cl)


;;; Snippet mechanics

(defun yas--buffer-contents ()
  (buffer-substring-no-properties (point-min) (point-max)))

(ert-deftest field-navigation ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "${1:brother} from another ${2:mother}")
    (should (string= (yas--buffer-contents)
                     "brother from another mother"))

    (should (looking-at "brother"))
    (ert-simulate-command '(yas-next-field-or-maybe-expand))
    (should (looking-at "mother"))
    (ert-simulate-command '(yas-prev-field))
    (should (looking-at "brother"))))

(ert-deftest simple-mirror ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "${1:brother} from another $1")
    (should (string= (yas--buffer-contents)
                     "brother from another brother"))
    (yas-mock-insert "bla")
    (should (string= (yas--buffer-contents)
                     "bla from another bla"))))

(ert-deftest mirror-with-transformation ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "${1:brother} from another ${1:$(upcase yas-text)}")
    (should (string= (yas--buffer-contents)
                     "brother from another BROTHER"))
    (yas-mock-insert "bla")
    (should (string= (yas--buffer-contents)
                     "bla from another BLA"))))

(ert-deftest primary-field-transformation ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (let ((snippet "${1:$$(upcase yas-text)}${1:$(concat \"bar\" yas-text)}"))
      (yas-expand-snippet snippet)
      (should (string= (yas--buffer-contents) "bar"))
      (yas-mock-insert "foo")
      (should (string= (yas--buffer-contents) "FOObarFOO")))))

(ert-deftest nested-placeholders-kill-superfield ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "brother from ${2:another ${3:mother}}!")
    (should (string= (yas--buffer-contents)
                     "brother from another mother!"))
    (yas-mock-insert "bla")
    (should (string= (yas--buffer-contents)
                     "brother from bla!"))))

(ert-deftest nested-placeholders-use-subfield ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "brother from ${2:another ${3:mother}}!")
    (ert-simulate-command '(yas-next-field-or-maybe-expand))
    (yas-mock-insert "bla")
    (should (string= (yas--buffer-contents)
                     "brother from another bla!"))))

(ert-deftest mirrors-adjacent-to-fields-with-nested-mirrors ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "<%= f.submit \"${1:Submit}\"${2:$(and (yas-text) \", :disable_with => '\")}${2:$1ing...}${2:$(and (yas-text) \"'\")} %>")
    (should (string= (yas--buffer-contents)
                     "<%= f.submit \"Submit\", :disable_with => 'Submiting...' %>"))
    (yas-mock-insert "Send")
    (should (string= (yas--buffer-contents)
                     "<%= f.submit \"Send\", :disable_with => 'Sending...' %>"))))

(ert-deftest deep-nested-mirroring-issue-351 ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "${1:FOOOOOOO}${2:$1}${3:$2}${4:$3}")
    (yas-mock-insert "abc")
    (should (string= (yas--buffer-contents) "abcabcabcabc"))))

(ert-deftest delete-numberless-inner-snippet-issue-562 ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "${3:${test}bla}$0${2:ble}")
    (ert-simulate-command '(yas-next-field-or-maybe-expand))
    (should (looking-at "testblable"))
    (ert-simulate-command '(yas-next-field-or-maybe-expand))
    (ert-simulate-command '(yas-skip-and-clear-or-delete-char))
    (should (looking-at "ble"))
    (should (null (yas--snippets-at-point)))))

(ert-deftest ignore-trailing-whitespace ()
  (should (equal
           (with-temp-buffer
             (insert "# key: foo\n# --\nfoo")
             (yas--parse-template))
           (with-temp-buffer
             (insert "# key: foo \n# --\nfoo")
             (yas--parse-template)))))

;; (ert-deftest in-snippet-undo ()
;;   (with-temp-buffer
;;     (yas-minor-mode 1)
;;     (yas-expand-snippet "brother from ${2:another ${3:mother}}!")
;;     (ert-simulate-command '(yas-next-field-or-maybe-expand))
;;     (yas-mock-insert "bla")
;;     (ert-simulate-command '(undo))
;;     (should (string= (yas--buffer-contents)
;;                      "brother from another mother!"))))

(ert-deftest dont-clear-on-partial-deletion-issue-515 ()
  "Ensure fields are not cleared when user doesn't really mean to."
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "my ${1:kid brother} from another ${2:mother}")

    (ert-simulate-command '(kill-word 1))
    (ert-simulate-command '(delete-char 1))

    (should (string= (yas--buffer-contents)
                     "my brother from another mother"))
    (should (looking-at "brother"))

    (ert-simulate-command '(yas-next-field))
    (should (looking-at "mother"))
    (ert-simulate-command '(yas-prev-field))
    (should (looking-at "brother"))))

(ert-deftest do-clear-on-yank-issue-515 ()
  "A yank should clear an unmodified field."
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "my ${1:kid brother} from another ${2:mother}")
    (yas-mock-yank "little sibling")
    (should (string= (yas--buffer-contents)
                     "my little sibling from another mother"))
    (ert-simulate-command '(yas-next-field))
    (ert-simulate-command '(yas-prev-field))
    (should (looking-at "little sibling"))))


;;; Snippet expansion and character escaping
;;; Thanks to @zw963 (Billy) for the testing
;;;
(ert-deftest escape-dollar ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "bla\\${1:bla}ble")
    (should (string= (yas--buffer-contents) "bla${1:bla}ble"))))

(ert-deftest escape-closing-brace ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "bla${1:bla\\}}ble")
    (should (string= (yas--buffer-contents) "blabla}ble"))
    (should (string= (yas-field-value 1) "bla}"))))

(ert-deftest escape-backslashes ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "bla\\ble")
    (should (string= (yas--buffer-contents) "bla\\ble"))))

(ert-deftest escape-backquotes ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "bla`(upcase \"foo\\`bar\")`ble")
    (should (string= (yas--buffer-contents) "blaFOO`BARble"))))

(ert-deftest escape-some-elisp-with-strings ()
  "elisp with strings and unbalance parens inside it"
  (with-temp-buffer
    (yas-minor-mode 1)
    ;; The rules here is: to output a literal `"' you need to escape
    ;; it with one backslash. You don't need to escape them in
    ;; embedded elisp.
    (yas-expand-snippet "soon \\\"`(concat (upcase \"(my arms\")\"\\\" were all around her\")`")
    (should (string= (yas--buffer-contents) "soon \"(MY ARMS\" were all around her"))))

(ert-deftest escape-some-elisp-with-backslashes ()
  (with-temp-buffer
    (yas-minor-mode 1)
    ;; And the rule here is: to output a literal `\' inside a string
    ;; inside embedded elisp you need a total of six `\'
    (yas-expand-snippet "bla`(upcase \"hey\\\\\\yo\")`ble")
    (should (string= (yas--buffer-contents) "blaHEY\\YOble"))))

(ert-deftest be-careful-when-escaping-in-yas-selected-text ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (let ((yas-selected-text "He\\\\o world!"))
      (yas-expand-snippet "Look ma! `(yas-selected-text)`")
      (should (string= (yas--buffer-contents) "Look ma! He\\\\o world!")))
    (yas-exit-all-snippets)
    (erase-buffer)
    (let ((yas-selected-text "He\"o world!"))
      (yas-expand-snippet "Look ma! `(yas-selected-text)`")
      (should (string= (yas--buffer-contents) "Look ma! He\"o world!")))
    (yas-exit-all-snippets)
    (erase-buffer)
    (let ((yas-selected-text "He\"\)\\o world!"))
      (yas-expand-snippet "Look ma! `(yas-selected-text)`")
      (should (string= (yas--buffer-contents) "Look ma! He\"\)\\o world!")))
    (yas-exit-all-snippets)
    (erase-buffer)))

(ert-deftest be-careful-when-escaping-in-yas-selected-text-2 ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (let ((yas-selected-text "He)}o world!"))
      (yas-expand-snippet "Look ma! ${1:`(yas-selected-text)`} OK?")
      (should (string= (yas--buffer-contents) "Look ma! He)}o world! OK?")))))

(ert-deftest example-for-issue-271 ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (let ((yas-selected-text "aaa")
          (snippet "if ${1:condition}\n`yas-selected-text`\nelse\n$3\nend"))
      (yas-expand-snippet snippet)
      (yas-next-field)
      (yas-mock-insert "bbb")
      (should (string= (yas--buffer-contents) "if condition\naaa\nelse\nbbb\nend")))))

(defmacro yas--with-font-locked-temp-buffer (&rest body)
  "Like `with-temp-buffer', but ensure `font-lock-mode'."
  (declare (indent 0) (debug t))
  (let ((temp-buffer (make-symbol "temp-buffer")))
    ;; NOTE: buffer name must not start with a space, otherwise
    ;; `font-lock-mode' doesn't turn on.
    `(let ((,temp-buffer (generate-new-buffer "*yas-temp*")))
       (with-current-buffer ,temp-buffer
         ;; pretend we're interactive so `font-lock-mode' turns on
         (let ((noninteractive nil)
               ;; turn on font locking after major mode change
               (change-major-mode-after-body-hook #'font-lock-mode))
           (unwind-protect
               (progn (require 'font-lock)
                      ;; turn on font locking before major mode change
                      (font-lock-mode +1)
                      ,@body)
             (and (buffer-name ,temp-buffer)
                  (kill-buffer ,temp-buffer))))))))

(defmacro yas-saving-variables (&rest body)
  `(yas-call-with-saving-variables #'(lambda () ,@body)))

(defmacro yas-with-snippet-dirs (dirs &rest body)
  (declare (indent defun))
  `(yas-call-with-snippet-dirs ,dirs
                               #'(lambda ()
                                   ,@body)))

(ert-deftest example-for-issue-474 ()
  (yas--with-font-locked-temp-buffer
    (c-mode)
    (yas-minor-mode 1)
    (insert "#include <foo>\n")
    (let ((yas-good-grace nil)) (yas-expand-snippet "`\"TODO: \"`"))
    (should (string= (yas--buffer-contents) "#include <foo>\nTODO: "))))

(ert-deftest example-for-issue-404 ()
  (yas--with-font-locked-temp-buffer
    (c++-mode)
    (yas-minor-mode 1)
    (insert "#include <foo>\n")
    (let ((yas-good-grace nil)) (yas-expand-snippet "main"))
    (should (string= (yas--buffer-contents) "#include <foo>\nmain"))))

(ert-deftest example-for-issue-404-c-mode ()
  (yas--with-font-locked-temp-buffer
    (c-mode)
    (yas-minor-mode 1)
    (insert "#include <foo>\n")
    (let ((yas-good-grace nil)) (yas-expand-snippet "main"))
    (should (string= (yas--buffer-contents) "#include <foo>\nmain"))))

(ert-deftest middle-of-buffer-snippet-insertion ()
  (with-temp-buffer
    (yas-minor-mode 1)
    (insert "beginning")
    (save-excursion (insert "end"))
    (yas-expand-snippet "-middle-")
    (should (string= (yas--buffer-contents) "beginning-middle-end"))))

(ert-deftest another-example-for-issue-271 ()
  ;; expect this to fail in batch mode since `region-active-p' doesn't
  ;; used by `yas-expand-snippet' doesn't make sense in that context.
  ;;
  :expected-result (if noninteractive
                       :failed
                     :passed)
  (with-temp-buffer
    (yas-minor-mode 1)
    (let ((snippet "\\${${1:1}:`yas-selected-text`}"))
      (insert "aaabbbccc")
      (set-mark 4)
      (goto-char 7)
      (yas-expand-snippet snippet)
      (should (string= (yas--buffer-contents) "aaa${1:bbb}ccc")))))

(ert-deftest string-match-with-subregexp-in-embedded-elisp ()
  (with-temp-buffer
    (yas-minor-mode 1)
    ;; the rule here is: To use regexps in embedded `(elisp)` expressions, write
    ;; it like you would normal elisp, i.e. no need to escape the backslashes.
    (let ((snippet "`(if (string-match \"foo\\\\(ba+r\\\\)foo\" \"foobaaaaaaaaaarfoo\")
                         \"ok\"
                         \"fail\")`"))
      (yas-expand-snippet snippet))
    (should (string= (yas--buffer-contents) "ok"))))

(ert-deftest string-match-with-subregexp-in-mirror-transformations ()
  (with-temp-buffer
    (yas-minor-mode 1)
    ;; the rule here is: To use regexps in embedded `(elisp)` expressions,
    ;; escape backslashes once, i.e. to use \\( \\) constructs, write \\\\( \\\\).
    (let ((snippet "$1${1:$(if (string-match \"foo\\\\\\\\(ba+r\\\\\\\\)baz\" yas-text)
                                \"ok\"
                                \"fail\")}"))
      (yas-expand-snippet snippet)
      (should (string= (yas--buffer-contents) "fail"))
      (yas-mock-insert "foobaaar")
      (should (string= (yas--buffer-contents) "foobaaarfail"))
      (yas-mock-insert "baz")
      (should (string= (yas--buffer-contents) "foobaaarbazok")))))


;;; Misc tests
;;;
(ert-deftest protection-overlay-no-cheating ()
  "Protection overlays at the very end of the buffer are dealt
  with by cheatingly inserting a newline!

TODO: correct this bug!"
  :expected-result :failed
  (with-temp-buffer
    (yas-minor-mode 1)
    (yas-expand-snippet "${2:brother} from another ${1:mother}")
    (should (string= (yas--buffer-contents)
                     "brother from another mother") ;; no newline should be here!
            )))

(defvar yas--barbaz)
(defvar yas--foobarbaz)

;; See issue #497. To understand this test, follow the example of the
;; `yas-key-syntaxes' docstring.
;;
(ert-deftest complicated-yas-key-syntaxes ()
  (with-temp-buffer
    (yas-saving-variables
     (yas-with-snippet-dirs
       '((".emacs.d/snippets"
          ("emacs-lisp-mode"
           ("foo-barbaz" . "# condition: yas--foobarbaz\n# --\nOKfoo-barbazOK")
           ("barbaz" . "# condition: yas--barbaz\n# --\nOKbarbazOK")
           ("baz" . "OKbazOK")
           ("'quote" . "OKquoteOK"))))
       (yas-reload-all)
       (emacs-lisp-mode)
       (yas-minor-mode-on)
       (let ((yas-key-syntaxes '("w" "w_")))
         (let ((yas--barbaz t))
           (yas-should-expand '(("foo-barbaz" . "foo-OKbarbazOK")
                                ("barbaz" . "OKbarbazOK"))))
         (let ((yas--foobarbaz t))
           (yas-should-expand '(("foo-barbaz" . "OKfoo-barbazOK"))))
         (let ((yas-key-syntaxes
                (cons #'(lambda (_start-point)
                          (unless (looking-back "-")
                            (backward-char)
                            'again))
                      yas-key-syntaxes))
               (yas--foobarbaz t))
           (yas-should-expand '(("foo-barbaz" . "foo-barOKbazOK")))))
       (let ((yas-key-syntaxes '(yas-try-key-from-whitespace)))
         (yas-should-expand '(("xxx\n'quote" . "xxx\nOKquoteOK")
                              ("xxx 'quote" . "xxx OKquoteOK"))))
       (let ((yas-key-syntaxes '(yas-shortest-key-until-whitespace))
             (yas--foobarbaz t) (yas--barbaz t))
         (yas-should-expand '(("foo-barbaz" . "foo-barOKbazOK")))
         (setq yas-key-syntaxes '(yas-longest-key-from-whitespace))
         (yas-should-expand '(("foo-barbaz" . "OKfoo-barbazOK")
                              ("foo " . "foo "))))))))


;;; Loading
;;;
(defun yas--call-with-temporary-redefinitions (function
                                               &rest function-names-and-overriding-functions)
  (let* ((overrides (remove-if-not #'(lambda (fdef)
                                       (fboundp (first fdef)))
                                   function-names-and-overriding-functions))
         (definition-names (mapcar #'first overrides))
         (overriding-functions (mapcar #'second overrides))
         (saved-functions (mapcar #'symbol-function definition-names)))
    ;; saving all definitions before overriding anything ensures FDEFINITION
    ;; errors don't cause accidental permanent redefinitions.
    ;;
    (cl-labels ((set-fdefinitions (names functions)
                                  (loop for name in names
                                        for fn in functions
                                        do (fset name fn))))
      (set-fdefinitions definition-names overriding-functions)
      (unwind-protect (funcall function)
	(set-fdefinitions definition-names saved-functions)))))

(defmacro yas--with-temporary-redefinitions (fdefinitions &rest body)
  ;; "Temporarily (but globally) redefine each function in FDEFINITIONS.
  ;; E.g.: (yas--with-temporary-redefinitions ((foo (x) ...)
  ;;                                           (bar (x) ...))
  ;;         ;; code that eventually calls foo, bar of (setf foo)
  ;;         ...)"
  ;; FIXME: This is hideous!  Better use defadvice (or at least letf).
  `(yas--call-with-temporary-redefinitions
    (lambda () ,@body)
    ,@(mapcar #'(lambda (thingy)
                  `(list ',(first thingy)
                         (lambda ,@(rest thingy))))
              fdefinitions)))

(defmacro yas-with-overriden-buffer-list (&rest body)
  (let ((saved-sym (make-symbol "yas--buffer-list")))
    `(let ((,saved-sym (symbol-function 'buffer-list)))
       (yas--with-temporary-redefinitions
           ((buffer-list ()
                         (remove-if #'(lambda (buf)
                                        (with-current-buffer buf
                                          (eq major-mode 'lisp-interaction-mode)))
                                    (funcall ,saved-sym))))
         ,@body))))


(defmacro yas-with-some-interesting-snippet-dirs (&rest body)
  `(yas-saving-variables
    (yas-with-overriden-buffer-list
     (yas-with-snippet-dirs
       '((".emacs.d/snippets"
          ("c-mode"
           (".yas-parents" . "cc-mode")
           ("printf" . "printf($1);"))  ;; notice the overriding for issue #281
          ("emacs-lisp-mode" ("ert-deftest" . "(ert-deftest ${1:name} () $0)"))
          ("lisp-interaction-mode" (".yas-parents" . "emacs-lisp-mode")))
         ("library/snippets"
          ("c-mode"
           (".yas-parents" . "c++-mode")
           ("printf" . "printf"))
          ("cc-mode" ("def" . "# define"))
          ("emacs-lisp-mode" ("dolist" . "(dolist)"))
          ("lisp-interaction-mode" ("sc" . "brother from another mother"))))
       ,@body))))

(ert-deftest snippet-lookup ()
  "Test `yas-lookup-snippet'."
  (yas-with-some-interesting-snippet-dirs
   (yas-reload-all 'no-jit)
   (should (equal (yas-lookup-snippet "printf" 'c-mode) "printf($1);"))
   (should (equal (yas-lookup-snippet "def" 'c-mode) "# define"))
   (should-not (yas-lookup-snippet "no such snippet" nil 'noerror))
   (should-not (yas-lookup-snippet "printf" 'emacs-lisp-mode 'noerror))))

(ert-deftest basic-jit-loading ()
  "Test basic loading and expansion of snippets"
  (yas-with-some-interesting-snippet-dirs
   (yas-reload-all)
   (yas--basic-jit-loading-1)))

(ert-deftest basic-jit-loading-with-compiled-snippets ()
  "Test basic loading and expansion of compiled snippets"
  (yas-with-some-interesting-snippet-dirs
   (yas-reload-all)
   (yas-recompile-all)
   (yas--with-temporary-redefinitions ((yas--load-directory-2
                                        (&rest _dummies)
                                        (ert-fail "yas--load-directory-2 shouldn't be called when snippets have been compiled")))
     (yas-reload-all)
     (yas--basic-jit-loading-1))))

(ert-deftest visiting-compiled-snippets ()
  "Test snippet visiting for compiled snippets."
  (yas-with-some-interesting-snippet-dirs
   (yas-recompile-all)
   (yas-reload-all 'no-jit) ; must be loaded for `yas-lookup-snippet' to work.
   (yas--with-temporary-redefinitions ((find-file-noselect
                                        (filename &rest _)
                                        (throw 'yas-snippet-file filename)))
     (should (string-suffix-p
              "cc-mode/def"
              (catch 'yas-snippet-file
                (yas--visit-snippet-file-1
                 (yas--lookup-snippet-1 "def" 'cc-mode))))))))

(ert-deftest loading-with-cyclic-parenthood ()
  "Test loading when cyclic parenthood is setup."
  (yas-saving-variables
   (yas-with-snippet-dirs '((".emacs.d/snippets"
                             ("c-mode"
                              (".yas-parents" . "cc-mode"))
                             ("cc-mode"
                              (".yas-parents" . "yet-another-c-mode and-that-one"))
                             ("yet-another-c-mode"
                              (".yas-parents" . "c-mode and-also-this-one lisp-interaction-mode"))))
     (yas-reload-all)
     (with-temp-buffer
       (let* ((major-mode 'c-mode)
              (expected `(c-mode
                          cc-mode
                          yet-another-c-mode
                          and-also-this-one
                          and-that-one
                          ;; prog-mode doesn't exist in emacs 24.3
                          ,@(if (fboundp 'prog-mode)
                                '(prog-mode))
                          emacs-lisp-mode
                          lisp-interaction-mode))
              (observed (yas--modes-to-activate)))
         (should (equal major-mode (car observed)))
         (should (equal (sort expected #'string<) (sort observed #'string<))))))))

(ert-deftest extra-modes-parenthood ()
  "Test activation of parents of `yas--extra-modes'."
  (yas-saving-variables
   (yas-with-snippet-dirs '((".emacs.d/snippets"
                             ("c-mode"
                              (".yas-parents" . "cc-mode"))
                             ("yet-another-c-mode"
                              (".yas-parents" . "c-mode and-also-this-one lisp-interaction-mode"))))
     (yas-reload-all)
     (with-temp-buffer
       (yas-activate-extra-mode 'c-mode)
       (yas-activate-extra-mode 'yet-another-c-mode)
       (yas-activate-extra-mode 'and-that-one)
       (let* ((expected-first `(and-that-one
                                yet-another-c-mode
                                c-mode
                                ,major-mode))
              (expected-rest `(cc-mode
                               ;; prog-mode doesn't exist in emacs 24.3
                               ,@(if (fboundp 'prog-mode)
                                     '(prog-mode))
                               emacs-lisp-mode
                               and-also-this-one
                               lisp-interaction-mode))
              (observed (yas--modes-to-activate)))
         (should (equal expected-first
                        (cl-subseq observed 0 (length expected-first))))
         (should (equal (sort expected-rest #'string<)
                        (sort (cl-subseq observed (length expected-first)) #'string<))))))))

(defalias 'yas--phony-c-mode 'c-mode)

(ert-deftest issue-492-and-494 ()
  (define-derived-mode yas--test-mode yas--phony-c-mode "Just a test mode")
  (yas-with-snippet-dirs '((".emacs.d/snippets"
                            ("yas--test-mode")))
                         (yas-reload-all)
                         (with-temp-buffer
                           (let* ((major-mode 'yas--test-mode)
                                  (expected `(c-mode
                                              ,@(if (fboundp 'prog-mode)
                                                    '(prog-mode))
                                              yas--phony-c-mode
                                              yas--test-mode))
                                  (observed (yas--modes-to-activate)))
                             (should (null (cl-set-exclusive-or expected observed)))
                             (should (= (length expected)
                                        (length observed)))))))

(define-derived-mode yas--test-mode c-mode "Just a test mode")
(define-derived-mode yas--another-test-mode c-mode "Another test mode")

(ert-deftest issue-504-tricky-jit ()
  (yas-with-snippet-dirs
   '((".emacs.d/snippets"
      ("yas--another-test-mode"
       (".yas-parents" . "yas--test-mode"))
      ("yas--test-mode")))
   (let ((b (with-current-buffer (generate-new-buffer "*yas-test*")
              (yas--another-test-mode)
              (current-buffer))))
     (unwind-protect
         (progn
           (yas-reload-all)
           (should (= 0 (hash-table-count yas--scheduled-jit-loads))))
       (kill-buffer b)))))

(defun yas--basic-jit-loading-1 ()
  (with-temp-buffer
    (should (= 4 (hash-table-count yas--scheduled-jit-loads)))
    (should (= 0 (hash-table-count yas--tables)))
    (lisp-interaction-mode)
    (yas-minor-mode 1)
    (should (= 2 (hash-table-count yas--scheduled-jit-loads)))
    (should (= 2 (hash-table-count yas--tables)))
    (should (= 1 (hash-table-count (yas--table-uuidhash (gethash 'lisp-interaction-mode yas--tables)))))
    (should (= 2 (hash-table-count (yas--table-uuidhash (gethash 'emacs-lisp-mode yas--tables)))))
    (yas-should-expand '(("sc" . "brother from another mother")
                         ("dolist" . "(dolist)")
                         ("ert-deftest" . "(ert-deftest name () )")))
    (c-mode)
    (yas-minor-mode 1)
    (should (= 0 (hash-table-count yas--scheduled-jit-loads)))
    (should (= 4 (hash-table-count yas--tables)))
    (should (= 1 (hash-table-count (yas--table-uuidhash (gethash 'c-mode yas--tables)))))
    (should (= 1 (hash-table-count (yas--table-uuidhash (gethash 'cc-mode yas--tables)))))
    (yas-should-expand '(("printf" . "printf();")
                         ("def" . "# define")))
    (yas-should-not-expand '("sc" "dolist" "ert-deftest"))))


;;; Menu
;;;
(defmacro yas-with-even-more-interesting-snippet-dirs (&rest body)
  `(yas-saving-variables
    (yas-with-snippet-dirs
      `((".emacs.d/snippets"
         ("c-mode"
          (".yas-make-groups" . "")
          ("printf" . "printf($1);")
          ("foo-group-a"
           ("fnprintf" . "fprintf($1);")
           ("snprintf" . "snprintf($1);"))
          ("foo-group-b"
           ("strcmp" . "strecmp($1);")
           ("strcasecmp" . "strcasecmp($1);")))
         ("lisp-interaction-mode"
          ("ert-deftest" . "# group: barbar\n# --\n(ert-deftest ${1:name} () $0)"))
         ("fancy-mode"
          ("a-guy" . "# uuid: 999\n# --\nyo!")
          ("a-sir" . "# uuid: 12345\n# --\nindeed!")
          ("a-lady" . "# uuid: 54321\n# --\noh-la-la!")
          ("a-beggar" . "# uuid: 0101\n# --\narrrgh!")
          ("an-outcast" . "# uuid: 666\n# --\narrrgh!")
          (".yas-setup.el" . , (pp-to-string
                                '(yas-define-menu 'fancy-mode
                                                  '((yas-ignore-item "0101")
                                                    (yas-item "999")
                                                    (yas-submenu "sirs"
                                                                 ((yas-item "12345")))
                                                    (yas-submenu "ladies"
                                                                 ((yas-item "54321"))))
                                                  '("666")))))))
      ,@body)))

(ert-deftest test-yas-define-menu ()
  (let ((yas-use-menu t))
    (yas-with-even-more-interesting-snippet-dirs
     (yas-reload-all 'no-jit)
     (let ((menu (cdr (gethash 'fancy-mode yas--menu-table))))
       (should (eql 4 (length menu)))
       (dolist (item '("a-guy" "a-beggar"))
         (should (find item menu :key #'third :test #'string=)))
       (should-not (find "an-outcast" menu :key #'third :test #'string=))
       (dolist (submenu '("sirs" "ladies"))
         (should (keymapp
                  (fourth
                   (find submenu menu :key #'third :test #'string=)))))
       ))))

(ert-deftest test-group-menus ()
  "Test group-based menus using .yas-make-groups and the group directive"
  (let ((yas-use-menu t))
    (yas-with-even-more-interesting-snippet-dirs
     (yas-reload-all 'no-jit)
     ;; first the subdir-based groups
     ;;
     (let ((menu (cdr (gethash 'c-mode yas--menu-table))))
       (should (eql 3 (length menu)))
       (dolist (item '("printf" "foo-group-a" "foo-group-b"))
         (should (find item menu :key #'third :test #'string=)))
       (dolist (submenu '("foo-group-a" "foo-group-b"))
         (should (keymapp
                  (fourth
                   (find submenu menu :key #'third :test #'string=))))))
     ;; now group directives
     ;;
     (let ((menu (cdr (gethash 'lisp-interaction-mode yas--menu-table))))
       (should (eql 1 (length menu)))
       (should (find "barbar" menu :key #'third :test #'string=))
       (should (keymapp
                (fourth
                 (find "barbar" menu :key #'third :test #'string=))))))))

(ert-deftest test-group-menus-twisted ()
  "Same as similarly named test, but be mean.

TODO: be meaner"
  (let ((yas-use-menu t))
    (yas-with-even-more-interesting-snippet-dirs
     ;; add a group directive conflicting with the subdir and watch
     ;; behaviour
     (with-temp-buffer
       (insert "# group: foo-group-c\n# --\nstrecmp($1)")
       (write-region nil nil (concat (first (yas-snippet-dirs))
                                     "/c-mode/foo-group-b/strcmp")))
     (yas-reload-all 'no-jit)
     (let ((menu (cdr (gethash 'c-mode yas--menu-table))))
       (should (eql 4 (length menu)))
       (dolist (item '("printf" "foo-group-a" "foo-group-b" "foo-group-c"))
         (should (find item menu :key #'third :test #'string=)))
       (dolist (submenu '("foo-group-a" "foo-group-b" "foo-group-c"))
         (should (keymapp
                  (fourth
                   (find submenu menu :key #'third :test #'string=))))))
     ;; delete the .yas-make-groups file and watch behaviour
     ;;
     (delete-file (concat (first (yas-snippet-dirs))
                          "/c-mode/.yas-make-groups"))
     (yas-reload-all 'no-jit)
     (let ((menu (cdr (gethash 'c-mode yas--menu-table))))
       (should (eql 5 (length menu))))
     ;; Change a group directive and reload
     ;;
     (let ((menu (cdr (gethash 'lisp-interaction-mode yas--menu-table))))
       (should (find "barbar" menu :key #'third :test #'string=)))

     (with-temp-buffer
       (insert "# group: foofoo\n# --\n(ert-deftest ${1:name} () $0)")
       (write-region nil nil (concat (first (yas-snippet-dirs))
                                     "/lisp-interaction-mode/ert-deftest")))
     (yas-reload-all 'no-jit)
     (let ((menu (cdr (gethash 'lisp-interaction-mode yas--menu-table))))
       (should (eql 1 (length menu)))
       (should (find "foofoo" menu :key #'third :test #'string=))
       (should (keymapp
                (fourth
                 (find "foofoo" menu :key #'third :test #'string=))))))))


;;; The infamous and problematic tab keybinding
;;;
(ert-deftest test-yas-tab-binding ()
  (with-temp-buffer
    (yas-minor-mode -1)
    (should (not (eq (key-binding (yas--read-keybinding "<tab>")) 'yas-expand)))
    (yas-minor-mode 1)
    (should (eq (key-binding (yas--read-keybinding "<tab>")) 'yas-expand))
    (yas-expand-snippet "$1 $2 $3")
    (should (eq (key-binding [(tab)]) 'yas-next-field-or-maybe-expand))
    (should (eq (key-binding (kbd "TAB")) 'yas-next-field-or-maybe-expand))
    (should (eq (key-binding [(shift tab)]) 'yas-prev-field))
    (should (eq (key-binding [backtab]) 'yas-prev-field))))

(ert-deftest test-rebindings ()
  (unwind-protect
      (progn
        (define-key yas-minor-mode-map [tab] nil)
        (define-key yas-minor-mode-map (kbd "TAB") nil)
        (define-key yas-minor-mode-map (kbd "SPC") 'yas-expand)
        (with-temp-buffer
          (yas-minor-mode 1)
          (should (not (eq (key-binding (yas--read-keybinding "TAB")) 'yas-expand)))
          (should (eq (key-binding (yas--read-keybinding "SPC")) 'yas-expand))
          (yas-reload-all)
          (should (not (eq (key-binding (yas--read-keybinding "TAB")) 'yas-expand)))
          (should (eq (key-binding (yas--read-keybinding "SPC")) 'yas-expand))))
    ;; FIXME: actually should restore to whatever saved values where there.
    ;;
    (define-key yas-minor-mode-map [tab] 'yas-expand)
    (define-key yas-minor-mode-map (kbd "TAB") 'yas-expand)
    (define-key yas-minor-mode-map (kbd "SPC") nil)))

(ert-deftest test-yas-in-org ()
  (with-temp-buffer
    (org-mode)
    (yas-minor-mode 1)
    (should (eq (key-binding [(tab)]) 'yas-expand))
    (should (eq (key-binding (kbd "TAB")) 'yas-expand))))

(ert-deftest test-yas-activate-extra-modes ()
  "Given a symbol, `yas-activate-extra-mode' should be able to
add the snippets associated with the given mode."
  (with-temp-buffer
    (yas-saving-variables
     (yas-with-snippet-dirs
       '((".emacs.d/snippets"
          ("markdown-mode"
           ("_" . "_Text_ "))
          ("emacs-lisp-mode"
           ("car" . "(car )"))))
       (yas-reload-all)
       (emacs-lisp-mode)
       (yas-minor-mode-on)
       (yas-activate-extra-mode 'markdown-mode)
       (should (eq 'markdown-mode (car yas--extra-modes)))
       (yas-should-expand '(("_" . "_Text_ ")))
       (yas-should-expand '(("car" . "(car )")))
       (yas-deactivate-extra-mode 'markdown-mode)
       (should-not (eq 'markdown-mode (car yas--extra-modes)))
       (yas-should-not-expand '("_"))
       (yas-should-expand '(("car" . "(car )")))))))


;;; Helpers
;;;
(defun yas-should-expand (keys-and-expansions)
  (dolist (key-and-expansion keys-and-expansions)
    (yas-exit-all-snippets)
    (narrow-to-region (point) (point))
    (insert (car key-and-expansion))
    (let ((yas-fallback-behavior nil))
      (ert-simulate-command '(yas-expand)))
    (unless (string= (yas--buffer-contents) (cdr key-and-expansion))
      (ert-fail (format "\"%s\" should have expanded to \"%s\" but got \"%s\""
                        (car key-and-expansion)
                        (cdr key-and-expansion)
                        (yas--buffer-contents)))))
  (yas-exit-all-snippets))

(defun yas-should-not-expand (keys)
  (dolist (key keys)
    (yas-exit-all-snippets)
    (narrow-to-region (point) (point))
    (insert key)
    (let ((yas-fallback-behavior nil))
      (ert-simulate-command '(yas-expand)))
    (unless (string= (yas--buffer-contents) key)
      (ert-fail (format "\"%s\" should have stayed put, but instead expanded to \"%s\""
                        key
                        (yas--buffer-contents))))))

(defun yas-mock-insert (string)
  (dotimes (i (length string))
    (let ((last-command-event (aref string i)))
      (ert-simulate-command '(self-insert-command 1)))))

(defun yas-mock-yank (string)
  (let ((interprogram-paste-function (lambda () string)))
    (ert-simulate-command '(yank nil))))

(defun yas-make-file-or-dirs (ass)
  (let ((file-or-dir-name (car ass))
        (content (cdr ass)))
    (cond ((listp content)
           (make-directory file-or-dir-name 'parents)
           (let ((default-directory (concat default-directory "/" file-or-dir-name)))
             (mapc #'yas-make-file-or-dirs content)))
          ((stringp content)
           (with-temp-buffer
             (insert content)
             (write-region nil nil file-or-dir-name nil 'nomessage)))
          (t
           (message "[yas] oops don't know this content")))))


(defun yas-variables ()
  (let ((syms))
    (mapatoms #'(lambda (sym)
                  (if (and (string-match "^yas-[^/]" (symbol-name sym))
                           (boundp sym))
                      (push sym syms))))
    syms))

(defun yas-call-with-saving-variables (fn)
  (let* ((vars (yas-variables))
         (saved-values (mapcar #'symbol-value vars)))
    (unwind-protect
        (funcall fn)
      (loop for var in vars
            for saved in saved-values
            do (set var saved)))))

(defun yas-call-with-snippet-dirs (dirs fn)
  (let* ((default-directory (make-temp-file "yasnippet-fixture" t))
         (yas-snippet-dirs (mapcar #'car dirs)))
    (with-temp-message ""
      (unwind-protect
          (progn
            (mapc #'yas-make-file-or-dirs dirs)
            (funcall fn))
        (when (>= emacs-major-version 24)
          (delete-directory default-directory 'recursive))))))

;;; Older emacsen
;;;
(unless (fboundp 'special-mode)
  ;; FIXME: Why provide this default definition here?!?
  (defalias 'special-mode 'fundamental))

(unless (fboundp 'string-suffix-p)
  ;; introduced in Emacs 24.4
  (defun string-suffix-p (suffix string &optional ignore-case)
    "Return non-nil if SUFFIX is a suffix of STRING.
If IGNORE-CASE is non-nil, the comparison is done without paying
attention to case differences."
    (let ((start-pos (- (length string) (length suffix))))
      (and (>= start-pos 0)
           (eq t (compare-strings suffix nil nil
                                  string start-pos nil ignore-case))))))

;;; btw to test this in emacs22 mac osx:
;;; curl -L -O https://github.com/mirrors/emacs/raw/master/lisp/emacs-lisp/ert.el
;;; curl -L -O https://github.com/mirrors/emacs/raw/master/lisp/emacs-lisp/ert-x.el
;;; /usr/bin/emacs -nw -Q -L . -l yasnippet-tests.el --batch -e ert


(put 'yas-saving-variables                   'edebug-form-spec t)
(put 'yas-with-snippet-dirs                  'edebug-form-spec t)
(put 'yas-with-overriden-buffer-list         'edebug-form-spec t)
(put 'yas-with-some-interesting-snippet-dirs 'edebug-form-spec t)


(put 'yas--with-temporary-redefinitions 'lisp-indent-function 1)
(put 'yas--with-temporary-redefinitions 'edebug-form-spec '((&rest (defun*)) cl-declarations body))




(provide 'yasnippet-tests)
;; Local Variables:
;; indent-tabs-mode: nil
;; byte-compile-warnings: (not cl-functions)
;; End:
;;; yasnippet-tests.el ends here
