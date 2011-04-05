;; -*- mode: lisp-interaction -*-
;; Massimo Lauria,  2011
;;
;; This bbdb-query allows to quert BBDB and to obtain output which is useful for
;; Mutt mail client.



(require 'cl)
(require 'bbdb-com)
(require 'bbdb)
(setq bbdb-file "~/personal/agenda/contacts.bbdb")

(setq bbdb-no-duplicates-p t)

(defun bbdb-mutt-query (string)
  "Print all entries in the BBDB matching the regexp STRING
in either the name(s), company, network address, or notes."
  (interactive
   (list (bbdb-search-prompt "Search records %m regexp: ")
         current-prefix-arg))
  (let* ((notes (cons '* string))
         (records
          (bbdb-search (bbdb-records) string string string notes
                       nil)))
    ;; No entry found
    (if (not records)
        (progn
          (princ (format "Sorry, no records matching '%s'" string))
          (kill-emacs 1)
          ))

    (princ "Address\tName\tAlias")
    (loop  for arecord in records do
           (loop
            for netaddress in (bbdb-record-net arecord)
            do
            (princ "\n")
            (princ (format "%s\t%s\t%s" netaddress
                           (bbdb-record-name arecord)
                           (bbdb-record-getprop arecord 'anniversary)
                           )
            )))
  ))


(defun bbdb-mutt-add (name address)
  (interactive "sContact name: \nsContact Email: ")
  (bbdb-create-internal name nil (list address) nil nil nil)
  (call-interactively 'bbdb-save-db)
)