;;; zotelo-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "zotelo" "zotelo.el" (0 0 0 0))
;;; Generated autoloads from zotelo.el

(autoload 'zotelo-minor-mode "zotelo" "\
zotelo minor mode for interaction with Firefox.
With no argument, this command toggles the mode. Non-null prefix
argument turns on the mode. Null prefix argument turns off the
mode.

This is a minor mode.  If called interactively, toggle the
`Zotelo minor mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `zotelo-minor-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

When this minor mode is enabled, `zotelo-set-collection' prompts
for zotero collection and stores it as file local variable . To
manually update the BibTeX data base call
`zotelo-update-database'. The \"file_name.bib\" file will be
created with the exported zotero items. To specify the file_name
just insert insert \\bibliography{file_name} anywhere in the
buffer.

This mode is designed mainly for latex modes and works in
conjunction with RefTex, but it can be used in any other mode
such as org-mode.

\\{zotelo-minor-mode-map}

\(fn &optional ARG)" t nil)

(autoload 'zotelo-export-secondary "zotelo" "\
Export zotero collection into  secondary BibTeX database.
Before export, ask for a secondary database and zotero collection
to be exported into the database. Secondary databases are those
in \\bibliography{file1, file2, ...}, except the first one.

Throw error if there is only one (primary) file listed in
\\bibliography{...}. Throw error if zotero collection is not
found by MozRepl" t nil)

(autoload 'zotelo-set-charset "zotelo" "\
Ask to choose from available character sets for exporting the bibliography.
This function sets the variable `zotelo-charset'." t nil)

(autoload 'zotelo-update-database "zotelo" "\
Update the primary BibTeX database associated with the current buffer.
Primary database is the first file in \\bibliography{file1, file2,
...}, list. If you want to export into a different file use
`zotelo-update-database-secondary'.

When BIBFILE is supplied, use it instead of the file in
\\bibliography{...}. If ID is supplied, use it instead of the id
from file local variables. Through an error if zotero collection
has not been found by MozRepl

\(fn &optional CHECK-ZOTERO-CHANGE BIBFILE ID)" t nil)

(autoload 'zotelo-set-collection "zotelo" "\
Ask for a zotero collection.
Ido interface is used by default. If you don't like it set
`zotelo-use-ido' to nil.  In `ido-mode' use \"C-s\" and \"C-r\"
for navigation. See ido-mode emacs wiki for many more details.

If no-update is t, don't update after setting the collecton. If
no-file-local is non-nill don't set file-local variable. Return
the properized collection name.

\(fn &optional PROMPT NO-UPDATE NO-FILE-LOCAL)" t nil)

(autoload 'zotelo-reset "zotelo" "\
Reset zotelo." t nil)

(autoload 'moz-command "zotelo" "\
Send the moz-repl  process command COM and delete the output
from the MozRepl process buffer.  If an optional second argument BUF
exists, it must be a string or an existing buffer object. The
output is inserted in that buffer. BUF is erased before use.

New line is automatically appended.

\(fn COM &optional BUF)" nil nil)

(register-definition-prefixes "zotelo" '("moz-" "zotelo-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; zotelo-autoloads.el ends here
