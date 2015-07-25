(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this

(require 'projectile)
(projectile-global-mode)
(require 'codesearch)
(setq projectile-require-project-root nil)
(setq projectile-enable-caching t)
(setq projectile-completion-system 'helm)
(require 'helm-projectile)
(helm-projectile-on)
(global-set-key (kbd "M-s") 'helm-swoop)
(global-linum-mode t)
(setq linum-format "%3d ")
(global-visual-line-mode)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(require 'auto-complete)
(global-auto-complete-mode t)

(require 'whitespace)
(setq whitespace-line-column 100) ;; limit line length
(setq whitespace-style '(face lines-tail))

(add-hook 'prog-mode-hook 'whitespace-mode)

;; pgrep for find . -name xx | xargs grep xx
;; =========================================

(global-hl-line-mode 1) ; turn it on for all modes by default
(set-face-background 'hl-line "#330")

(defun get-current-file-dir ()
  (file-name-directory (buffer-file-name))
  )

(defun get-grep-location ()
  (if (boundp 'grep-location)
      (if (string-prefix-p (get-current-file-dir) grep-location) ;;handle jumping to another project
  grep-location
(setq grep-location (get-current-file-dir))) ;;use the root directory of new project as search location
    (setq grep-location (get-current-file-dir)))
  )

(defun pgrep-buffer-extension ()
  (file-name-extension (buffer-file-name))
  )

(defun pgrep-get-name-pattern()
  (If (Pgrep-Buffer-Extension)
      (Concat "*." (pgrep-buffer-extension))
    (read-string "file name pattern:")))

(defun pgrep-get-what-to-grep()
  (if (use-region-p)
      (buffer-substring (region-beginning) (region-end))
    (read-string "what to grep: ")))

(defun pgrep (location file-pattern re)
  (interactive
  (list
    (read-directory-name "location to search: " (get-grep-location))
    (pgrep-get-name-pattern)
    (pgrep-get-what-to-grep))
  )
  (setq grep-location location)
  (let ((default-directory grep-location))
  (grep (concat  "find . -name \"" file-pattern "\" | xargs grep -n -e " re)))
  )

(define-key global-map "\C-xg" 'pgrep)
;; pgrep for find . -name xx | xargs grep xx
;; =========================================

(defun get-current-file-dir ()
  (file-name-directory (buffer-file-name))
  )

(defun get-grep-location ()
  (if (boundp 'grep-location)
      (if (string-prefix-p (get-current-file-dir) grep-location) ;;handle jumping to another project
  grep-location
(setq grep-location (get-current-file-dir))) ;;use the root directory of new project as search location
    (setq grep-location (get-current-file-dir)))
  )

(defun pgrep-buffer-extension ()
  (file-name-extension (buffer-file-name))
  )

(defun pgrep-get-name-pattern()
  (if (pgrep-buffer-extension)
      (concat "*." (pgrep-buffer-extension))
    (read-string "file name pattern:")))

(defun pgrep-get-what-to-grep()
  (if (use-region-p)
      (buffer-substring (region-beginning) (region-end))
    (read-string "what to grep: ")))

(defun pgrep (location file-pattern re)
  (interactive
  (list
    (read-directory-name "location to search: " (get-grep-location))
    (pgrep-get-name-pattern)
    (pgrep-get-what-to-grep))
  )
  (setq grep-location location)
  (let ((default-directory grep-location))
  (grep (concat  "find . -name \"" file-pattern "\" | xargs grep -n -e " re)))
  )

(define-key global-map "\C-xg" 'pgrep)

(require 'ace-jump-mode)

;; you can select the key you prefer to
(define-key global-map (kbd "C-x j") 'ace-jump-mode)

;;Tianshuo all in one

(require 'recentf)
(setq-default frame-title-format "%b (%f)")
(show-paren-mode 1)
(setq dired-use-ls-dired nil)
(global-set-key (kbd "C-x C-l") 'goto-last-change)
(global-set-key (kbd "<f5>") 'revert-buffer)
(global-auto-revert-mode t)
(setq python-indent-guess-indent-offset nil)
(setq python-indent-offset 2)
;; Python Hook
(add-hook 'python-mode-hook
          (function (lambda ()
                      (setq indent-tabs-mode nil
                            tab-width 2))))

(require 'saveplace)                          ;; get the package
(setq save-place-file "~/.emacs.d/saveplace") ;; keep my ~/ clean
(setq-default save-place t)                  ;; activate it for all buffers

(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

(electric-indent-mode +1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode t)
(setq auto-save-default nil)
(recentf-mode 1)
(global-set-key (kbd "M-r") 'recentf-open-files)
(global-linum-mode t)
(setq linum-format "%3d ")
(global-visual-line-mode 1)

(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] '(lambda ()
      (interactive)
      (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
      (interactive)
      (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
  )

(if window-system (tool-bar-mode -1))
(global-set-key [up] (lambda () (interactive) (scroll-down 1)))
(global-set-key [down] (lambda () (interactive) (scroll-up 1)))
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20  ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
      )

(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no region selected, copy the current line."
  (interactive
  (if mark-active (list (region-beginning) (region-end))
    (message "Copied line")
    (list (line-beginning-position)
  (line-beginning-position 2)
  )
    )
  )
  )

(defadvice kill-region (before slick-cut activate compile)
  "cut current line if no region is selected"
  (interactive
  (if mark-active
      (list (region-beginning)
    (region-end))
    (list (line-beginning-position)
  (line-beginning-position 2)))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-line ((t (:underline "brightgreen")))))
;; copy shit into osx clipboard
;;(shell-command-on-region (region-beginning) (region-end) "pbcopy")

(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

;; (require 'sublimity)
;; (require 'sublimity-scroll)
;; (require 'sublimity-map)
;; (require 'sublimity-attractive)
;; (sublimity-mode 1)
