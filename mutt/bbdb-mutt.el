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


;; Query command
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


;; Add command
(defun bbdb-mutt-add (name address)
  (interactive "sContact name: \nsContact Email: ")
  (bbdb-create-internal name nil (list address) nil nil nil)
  (call-interactively 'bbdb-save-db)
)


;; Collect from file

;; Setup mail header separator.
(setq mail-header-separator "")


;; Stuff copied from moy-bbdb Matthieu Moy <Matthieu.Moy@imag.fr> -- START -------------

;; Copyright (C) 2002, 2011  Free Software Foundation, Inc.
;; Author: Matthieu Moy <Matthieu.Moy@imag.fr>
(defun bbdb/send-remove-nil-from-list (list)
  "expl : (\"hello\" nil \"world\") -> (\"hello\" \"world\")
  (nil nil nil) -> '()"
  (if (null list)
      list
    (if (null (car list))
	(bbdb/send-remove-nil-from-list (cdr list))
      (cons (car list) (bbdb/send-remove-nil-from-list (cdr list))))))




;; Copyright (C) 2002, 2011  Free Software Foundation, Inc.
;; Author: Matthieu Moy <Matthieu.Moy@imag.fr>
(defun bbdb/send-hook-fetch-fields (fields)


  (if (null fields)
      '()
    (let ((field-content (mail-fetch-field (car fields))))
      (append (if field-content
		  (mapcar
		   (lambda (elem)
		     (concat "\"" (car elem) "\" <" (cadr elem) ">"))
		   (bbdb-extract-address-components field-content)
		   )
		'())
	      (bbdb/send-hook-fetch-fields (cdr fields))))))


;; Copyright (C) 2002, 2011  Free Software Foundation, Inc.
;; Author: Matthieu Moy <Matthieu.Moy@imag.fr>
;; Modified: Massimo Lauria
(defun bbdb/send-hook-annotate-message (rcp)
  (if (not (string-match
	    (or bbdb-user-mail-names
		"$^") ;; Regexp matching nothing (?)
	    rcp))
      (if (bbdb-annotate-message-sender rcp nil t nil )
          (princ (format "Address %s added" rcp))
          )))


;; Copyright (C) 2002, 2011  Free Software Foundation, Inc.
;; Author: Matthieu Moy <Matthieu.Moy@imag.fr>
;; Modified: Massimo Lauria
(defun bbdb-mutt-collect ()
  "Parse headers of the message, insert the addresses of the
  recipients one by one into BBDB if they do not exist already"

  (interactive)
  (let ((bbdb-notice-hook nil))
    (save-restriction
      (widen)
      ;; Narrow to the headers region to use 'mail-fetch-field'
      (narrow-to-region (point-min)
			(progn (goto-char (point-min))
                   (if (string= mail-header-separator "")
                       (progn
                         (search-forward-regexp "\n\n")
                         (backward-char)
                       )
                     (search-forward mail-header-separator)
                     )
			       (beginning-of-line nil)
			       (point)
			       ))
      ;; Fetch the recipient's mail address.
      (let ((recipients (bbdb/send-hook-fetch-fields
			 '("to" "from" "cc" "bcc"))))
        (widen)
        ;; And add it to the database.
        (if recipients
            (let ((added-records
                   (bbdb/send-remove-nil-from-list
                    (mapcar 'bbdb/send-hook-annotate-message
                            recipients
                            ))))
              ;; If some record were added, show them.
              (if added-records
                  (bbdb-save-db)
                )
              )
          )
        )
      )
    )
  )

;; Stuff copied from moy-bbdb Matthieu Moy <Matthieu.Moy@imag.fr> -- END -----------
