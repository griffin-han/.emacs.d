;;; package --- Summary
;; run package-install-selected-packages and then edit jedi:environment-root below and run M-x jedi:install-server run once
(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize) ;; You might already have this line
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("b59d7adea7873d58160d368d42828e7ac670340f11f36f67fa8071dbf957236a" default)))
 '(package-selected-packages
   (quote
    (airline-themes evil-terminal-cursor-changer evil-nerd-commenter evil yasnippet-snippets yasnippet ace-window ein sr-speedbar py-autopep8 flycheck jedi smartparens avy monokai-pro-theme neotree))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(setq auto-save-default nil)
(setq make-backup-files nil)
(load-theme 'monokai-pro t)
(global-set-key (kbd "M-s n") 'neotree-toggle)
;;(display-line-numbers-mode 1)

(defun neotree-startup ()
  (interactive)
  (neotree-show)
  (call-interactively 'other-window))

(if (daemonp)
    (add-hook 'server-switch-hook #'neotree-startup)
  (add-hook 'after-init-hook #'neotree-startup)
  )

(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))
(global-set-key (kbd "M-s f") 'avy-goto-char)
(setq electric-pair-preserve-balance nil)
(require 'smartparens-config)

(global-set-key (kbd "M-s g") 'goto-line)

(define-globalized-minor-mode my-smartparens-mode
  smartparens-mode(lambda () (smartparens-mode t)))
(my-smartparens-mode t)

;; Standard Jedi.el setting
(setq jedi:environment-root "/data/hanbing/miniconda2/envs/emacs")
;; (jedi:install-server)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
;; (setq jedi:use-shortcuts t)



(require 'evil)
(evil-mode 1)
(global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)
(require 'airline-themes)
(load-theme 'airline-light)

(require 'yasnippet)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)


(add-hook 'python-mode-hook (semantic-mode 1))
(add-hook 'speedbar-load-hook (lambda () (require 'semantic/sb)))
(global-set-key (kbd "M-s p") 'sr-speedbar-toggle)

(add-hook 'after-init-hook #'global-flycheck-mode)
(global-set-key (kbd "M-s l") 'py-autopep8-buffer)

(global-set-key (kbd "M-RET") (lambda ()
                                (interactive)
                                (beginning-of-line)
                                (newline-and-indent)
                                (previous-line)
                                ;; (end-of-line)
                                ))
(global-set-key (kbd "M-s m") 'cua-rectangle-mark-mode)
