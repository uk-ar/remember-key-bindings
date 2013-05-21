;;; remember-key-bindings.el --- suggest key binding anytime
;;; Commentary:
;;; Code:

(defvar rkb-real-this-command nil
  "Real this command.")

(defun rkb-post-func ()
  "Show key bindings."
  ;; (message "rt:%s t:%s l:%s: rl:%s" rkb-real-this-command
  ;;          this-command last-command real-last-command)
  (when (and
         (where-is-internal this-command)
         ;;run-hook-with-args-until-success
         (or (and
              (or (eq rkb-real-this-command 'anything-execute-extended-command)
                  (eq rkb-real-this-command 'anything-exit-minibuffer)
                  ;; (not (eq rkb-real-this-command this-command))
                  ))
             (and (equal (this-command-keys-vector) [key-combo])
                  (not (equal (key-combo-keys-vector)
                              (where-is-internal
                               this-command overriding-local-map t nil nil)))
                  (not (symbolp (aref (where-is-internal
                                       this-command overriding-local-map t) 0)))
                  ;; (where-is-internal
                  ;;  this-command overriding-local-map t nil nil)
                  )
             (and (equal (this-command-keys-vector) [key-chord])
                  ;; function mode map
                  ;; (not (symbolp (aref (where-is-internal
                  ;;                      this-command overriding-local-map t) 0)))
                  ;; (where-is-internal
                  ;;  this-command overriding-local-map t nil nil)
                  )
             ))
    ;; You can run the command `forward-char' with C-f
    (message "You can run the command `%s' with %s" this-command
             (key-description (where-is-internal this-command overriding-local-map t nil nil)))
    ;;(sit-for suggest-key-bindings 0 2)
    (sit-for 2 0)
    ))
;; (key-chord-define-global "fc" 'forward-char)
;; (where-is-internal 'describe-function overriding-local-map t nil nil)

(defun rkb-pre-func ()
  "Save this command."
  (setq rkb-real-this-command this-command)
  ;; (message "thi-re:%s" rkb-real-this-command)
  )

(define-minor-mode remember-key-bindings-mode
  "Toggle Remember Key Bindings mode on or off.

With prefix ARG, turn Remember-Key-Bindings mode on if and only if ARG is positive."
  :group 'remember-key-bindings :lighter remember-key-bindings-minor-mode-string
  (if remember-key-bindings-mode
      (progn
        (add-hook 'pre-command-hook #'rkb-pre-func)
        (add-hook 'post-command-hook #'rkb-post-func))
    (remove-hook 'pre-command-hook #'rkb-pre-func)
    (remove-hook 'post-command-hook #'rkb-post-func)
    ))

(provide 'remember-key-bindings)
;;; remember-key-bindings.el ends here
