(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize) ;; You might already have this line
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (py-autopep8 flycheck jedi smartparens comment-dwim-2 avy monokai-pro-theme neotree))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(setq make-backup-files nil)
(load-theme 'monokai-pro t)
(global-set-key [f8] 'neotree-toggle)
;;(display-line-numbers-mode 1)

(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))
(global-set-key (kbd "M-s f") 'avy-goto-char)
(global-set-key (kbd "M-s ;") 'comment-dwim-2)
(setq electric-pair-preserve-balance nil)
(require 'smartparens-config)


(define-globalized-minor-mode my-smartparens-mode
  smartparens-mode(lambda () (smartparens-mode t)))
(my-smartparens-mode t)

;; Standard Jedi.el setting
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
(add-hook 'after-init-hook #'global-flycheck-mode)
(global-set-key (kbd "M-s l") 'py-autopep8)

(global-set-key (kbd "M-RET") (lambda ()
                                (interactive)
                                (beginning-of-line)
                                (newline-and-indent)
                                (previous-line)
                                ;; (end-of-line)
                                ))
