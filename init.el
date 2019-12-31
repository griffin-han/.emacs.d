;; run package-install-selected-packages and then edit jedi:environment-root below and run M-x jedi:install-server run once

;; set below 3lines in .bashrc, mod EMACS_BIN_PATH if nessary
;;EMACS_BIN_PATH='/data/miniconda3/envs/emacs/bin/'
;;alias emacs='TERM=xterm-256color PATH=$EMACS_BIN_PATH:$PATH emacs'
;;alias et='ALTERNATE_EDITOR="" PATH=$EMACS_BIN_PATH:$PATH emacsclient -tty'

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
    (flycheck evil-terminal-cursor-changer evil-nerd-commenter evil yasnippet-snippets yasnippet ace-window ein sr-speedbar py-autopep8 jedi smartparens avy monokai-pro-theme neotree))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; turn off autosave and backupfile
(setq auto-save-default nil)
(setq make-backup-files nil)

;; load theme
(load-theme 'monokai-pro t)

;; start evil mode
(require 'evil)
(evil-mode 1)
(global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)
;; evil-esc-delay to adjust esc behave as 'M' or 'vim esc'
(setq evil-esc-delay 0.05)
(define-key evil-normal-state-map (kbd "f") 'avy-goto-char)
(define-key evil-normal-state-map (kbd "TAB") 'global-display-line-numbers-mode)
(define-key evil-normal-state-map (kbd "C-n") 'neotree-toggle)
;; for paste use, toggle auto indent
(define-key evil-normal-state-map (kbd "M-y") 'electric-indent-mode)
;; only when python mode, add this key map
(add-hook 'python-mode-hook
          (lambda ()
            (define-key evil-normal-state-map (kbd "t") 'py-autopep8-buffer)
                              ;;(local-set-key (kbd "M-s l") 'py-autopep8-buffer)
          ))
;; show line number
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

;; (setq electric-pair-preserve-balance nil)
;; smart pairs and start it
(require 'smartparens-config)
(define-globalized-minor-mode my-smartparens-mode
  smartparens-mode(lambda () (smartparens-mode t)))
(my-smartparens-mode t)

;; can relpaced by evil mode goto
;; (global-set-key (kbd "M-s g") 'goto-line)


;; Standard Jedi.el setting
(setq jedi:environment-root "/data/miniconda3/envs/emacs")
;; (jedi:install-server)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
;; (setq jedi:use-shortcuts t)


;; let neotree key behacve normal when using evil mode
(evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-quick-look)
(evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
(evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
(evil-define-key 'normal neotree-mode-map (kbd "n") 'neotree-next-line)
(evil-define-key 'normal neotree-mode-map (kbd "p") 'neotree-previous-line)
(evil-define-key 'normal neotree-mode-map (kbd "A") 'neotree-stretch-toggle)
(evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle)

;; mode line change color when mode changes
(eval-when-compile (require 'cl))
(lexical-let ((default-color (cons (face-background 'mode-line)
                                   (face-foreground 'mode-line))))
  (add-hook 'post-command-hook
    (lambda ()
      (let ((color (cond ((minibufferp) default-color)
                         ((evil-insert-state-p) '("#008000" . "#ffffff"))
                         ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                         ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                         (t default-color))))
        (set-face-background 'mode-line (car color))
        (set-face-foreground 'mode-line (cdr color))))))

;; YASnippet is a template system for Emacs
(require 'yasnippet)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)

;; let sppedbar use semantic to parse code file
(add-hook 'python-mode-hook (semantic-mode 1))
(add-hook 'speedbar-load-hook (lambda () (require 'semantic/sb)))
(global-set-key (kbd "M-s p") 'sr-speedbar-toggle)

;; start check code syntax
(add-hook 'after-init-hook #'global-flycheck-mode)


;; insert a new line before current line, replaced by evil mode shift-O
;; (global-set-key (kbd "M-RET") (lambda ()
;;                                 (interactive)
;;                                 (beginning-of-line)
;;                                 (newline-and-indent)
;;                                 (previous-line)
;;                                 ;; (end-of-line)
;;                                 ))

(global-set-key (kbd "M-s m") 'cua-rectangle-mark-mode)

;; make flycheck error msg buffer stay below
(add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
               (display-buffer-reuse-window
                display-buffer-in-side-window)
               (side            . bottom)
               (reusable-frames . visible)
               (window-height   . 0.2)))
;;flycheck buffer toggle func
(defun toggle-flycheck-error-buffer ()
  "toggle a flycheck error buffer."
  (interactive)
  (if (string-match-p "Flycheck errors" (format "%s" (window-list)))
      (dolist (w (window-list))
        (when (string-match-p "*Flycheck errors*" (buffer-name (window-buffer w)))
          (delete-window w)
          ))
    (flycheck-list-errors)
    )
    )
(define-key evil-normal-state-map (kbd "e") 'toggle-flycheck-error-buffer)
