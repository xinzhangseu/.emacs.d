(define-package "magit" "20220603.1738" "A Git porcelain inside Emacs."
  '((emacs "25.1")
    (compat "28.1.1.0")
    (dash "20210826")
    (git-commit "20220222")
    (magit-section "20220325")
    (transient "20220325")
    (with-editor "20220318"))
  :commit "475bc370ff9e567c69944e1611107584810a79aa" :authors
  '(("Marius Vollmer" . "marius.vollmer@gmail.com")
    ("Jonas Bernoulli" . "jonas@bernoul.li"))
  :maintainer
  '("Jonas Bernoulli" . "jonas@bernoul.li")
  :keywords
  '("git" "tools" "vc")
  :url "https://github.com/magit/magit")
;; Local Variables:
;; no-byte-compile: t
;; End:
