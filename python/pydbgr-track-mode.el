;;; pydbgr-track-mode.el --- Ruby "pydbgr" Debugger tracking a comint
;;; or eshell buffer.

(eval-when-compile (require 'cl))

(defun pydbgr-directory ()
  "The directory of this file, or nil."
  (let ((file-name (or load-file-name
                       (symbol-file 'pydbgr-track-mode))))
    (if file-name
        (file-name-directory file-name)
      nil)))

(setq load-path (cons nil 
		      (cons (format "%s.." (pydbgr-directory))
				    (cons (pydbgr-directory) load-path))))
(require 'dbgr-track-mode)
(require 'pydbgr-core)
(setq load-path (cdddr load-path))


(defun pydbgr-track-mode-body()
  "Called when entering or leaving pydbgr-track-mode"
  (dbgr-track-set-debugger "pydbgr")
  (if pydbgr-track-mode
      (progn 
	(dbgr-track-mode 't)
 	;; FIXME: until I figure out why this isn't set in the mode
        (local-set-key "\C-ce"  'pydbgr-goto-traceback-line)
	(run-mode-hooks 'pydbgr-track-mode-hook))
    (progn 
      (dbgr-track-mode nil)
      (local-unset-key "\C-ce")
    )))

(defvar pydbgr-track-mode nil
  "Non-nil if using pydbgr-track mode as a minor mode of some other mode.
Use the command `pydbgr-track-mode' to toggle or set this variable.")

(defvar pydbgr-track-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map [C-c e]	'pydbgr-goto-traceback-line)
    map)
  "Keymap used in `pydbgr-track-mode'.")

(define-minor-mode pydbgr-track-mode
  "Minor mode for tracking ruby debugging inside a process shell."
  :init-value nil
  ;; :lighter " pydbgr"   ;; mode-line indicator from dbgr-track is sufficient.
  ;; The minor mode bindings.
  :global nil
  :group 'pydbgr
  :keymap pydbgr-track-mode-map
  (pydbgr-track-mode-body)
)

;; -------------------------------------------------------------------
;; The end.
;;

(provide 'pydbgr-track-mode)

;;; Local variables:
;;; eval:(put 'rbdbg-debug-enter 'lisp-indent-hook 1)
;;; End:

;;; pydbgr-track.el ends here
