(load-file "./behave.el")
(load-file "../python/pydbgr-regexp.el")

(behave-clear-contexts)


(setq tb (gethash "traceback" pydbgr-pat-hash))

(defun tb-loc-match(text) 
  (string-match (dbgr-loc-pat-regexp tb) text)
)

;; FIXME: we get a void variable somewhere in here when running
;;        even though we define it in lexical-let. Dunno why.
;;        setq however will workaround this.
(setq text "  File \"/usr/lib/python2.6/code.py\", line 281, in raw_input")
(context "traceback location matching"
	 (tag regexp-pydbgr)
	 (specify "basic traceback location"
		  (expect-t (numberp (tb-loc-match text))))
	 (specify "extract file name"
		  (expect-equal "/usr/lib/python2.6/code.py"
				(match-string (dbgr-loc-pat-file-group tb)
					      text)))
	 (specify "extract line number"
		  (expect-equal "281"
				(match-string (dbgr-loc-pat-line-group tb)
					      text)))
	   )

(behave "regexp-pydbgr")

