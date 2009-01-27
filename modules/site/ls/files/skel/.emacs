;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
(setq require-final-newline t)

;; Backcountry.com customizations

;; No backup files (file~)
(setq make-backup-files nil)

;; No ~/.saves-pid-host files
(setq auto-save-list-file-prefix nil)

;; Stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

;; 4-space tab indents
(setq-default tab-width 4)

