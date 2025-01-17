;;; em-modeline.el --- Module file for configuring the modeline.
;;
;; Copyright (C) 2018 Wojciech Kozlowski
;;
;; Author: Wojciech Kozlowski <wk@wojciechkozlowski.eu>
;; Created: 11 Feb 2018
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; This module is used for configuring the modeline.
;;
;;; License: GPLv3

;;; Required packages:

;;; Code:

;; FIXME: move back to doom-modeline package
;; Currently, I'm running doom-modeline from a local checkout, because the
;; newest versions don't play nicely with treemacs.

(defvar emodule/em-modeline-packages

  '(anzu
    ;; doom-modeline

    ;; doom-modeline dependencies.
    ;; Needed to load from local checkout.
    all-the-icons
    eldoc-eval
    shrink-path
    )

  )

;;; Configuration:

(defun emodule/em-modeline-init ()
  "Initialise the `em-modeline' module."

  ;; Note that doom-modeline requires all-the-icons which in turn require the
  ;; user to manually install the fonts with the command `M-x
  ;; all-the-icons-install-fonts'.
  (add-to-list 'load-path "~/.emacs.d/doom-modeline")
  (use-package doom-modeline
    :hook
    (after-init . doom-modeline-init)
    :config
    (setq-default doom-modeline-height 23)

    ;; Set anzu-mode
    (use-package anzu
      :config
      (global-anzu-mode 1))

    ;; Add perspective to modeline
    (doom-modeline-def-segment perspective-name
      "Perspectives list and selection. Requires `persp-mode' to be enabled."
      (if (bound-and-true-p persp-mode)
          (persp-format-name (persp-name (persp-curr)))
        ""))

    (doom-modeline-def-segment workspace-number
      "The current workspace name or number. Requires `eyebrowse-mode' to be
enabled."
      (if (bound-and-true-p eyebrowse-mode)
          (let* ((num (eyebrowse--get 'current-slot))
                 (tag (when num (nth 2 (assoc num (eyebrowse--get 'window-configs)))))
                 (str (if (and tag (< 0 (length tag)))
                          tag
                        (when num (int-to-string num)))))
            (propertize str 'face 'eyebrowse-mode-line-active))
        ""))

    ;; Necessary to play nice with Helm
    (add-hook 'helm-minibuffer-set-up-hook
              (lambda ()
                (advice-add #'doom-modeline--active :override (lambda () t))))
    (add-hook 'helm-cleanup-hook
              (lambda ()
                (advice-remove #'doom-modeline--active (lambda () t))))

    ;; Set the modeline
    (setq column-number-mode t)
    (setq doom-modeline-python-executable "python3")
    (doom-modeline-def-modeline 'main

                                '(bar
                                  "["
                                  perspective-name
                                  ":"
                                  workspace-number
                                  "]"
                                  window-number
                                  matches
                                  buffer-info
                                  remote-host
                                  buffer-position
                                  selection-info)

                                '(lsp
                                  debug
                                  buffer-encoding
                                  major-mode
                                  vcs
                                  checker))
    )
  )

(provide 'em-modeline)
;;; em-modeline.el ends here
