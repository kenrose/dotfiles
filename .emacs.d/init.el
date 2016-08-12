(add-to-list 'load-path "~/elisp")

(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("user42" . "http://download.tuxfamily.org/user42/elpa/packages/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar prelude-packages
  '(color-theme color-theme-sanityinc-tomorrow cmake-mode coffee-mode git-blame etags-select ensime
	   haml-mode haskell-mode magit markdown-mode paredit projectile ruby-mode
	   scala-mode sass-mode scss-mode thrift yaml-mode yasnippet)
  "A list of packages to ensure are installed at launch.")

(dolist (p prelude-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; Emacs 21.3.5 (and up) come with cua-mode preloaded
;; So only load CUA if it's not already defined
(if (fboundp 'cua-mode)
    (cua-mode t)
  (progn (require 'cua) (CUA-mode t)))

(setq cua-enable-cursor-indications t)

;; Tramp... better than ange-ftp
(require 'tramp)
(setq tramp-default-method "ssh")
(setq tramp-auto-save-directory "~/.tramp-autosave")

;; When we restart emacs, we have our minibuffer file history
;;(require 'save-history)
(savehist-mode 1)
(require 'desktop)

;; Make w3m the default browser
(setq browse-url-browser-function 'w3m-browse-url)

(require 'etags-select)
(global-set-key "\M-?" 'etags-select-find-tag-at-point)
;(global-set-key "\M-." 'find-tag)
(global-set-key "\M-`" 'ff-find-other-file)

(autoload 'thrift-mode "thrift" "Enter Thrift mode" t)
(autoload 'coffee-mode "coffee-mode" "Enter Coffee mode" t)

(require 'hideshow)

(setq exec-path (append exec-path '("/usr/local/bin")))
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

(defun my-scala-mode-shortcuts ()
  "Modify keymaps used by `ensime-mode'."
  (local-set-key '[f11] 'ensime-sbt-do-compile)
  )
(add-hook 'scala-mode-hook 'my-scala-mode-shortcuts)

;(setq ensime-sbt-command "/usr/local/bin/sbt")

;(add-to-list 'load-path "~/elisp/scala")
;(require 'scala-mode-auto)
;(require 'scala-mode2)
(autoload 'scala-mode "scala-mode2" "Enter Scala mode" t)

(defun pagerduty-scala-stuff ()
  "PagerDuty Scala coding guidelines"
  (setq indent-tabs-mode nil)
)
(add-hook 'scala-mode-hook 'pagerduty-scala-stuff)

(defun my-js-stuff ()
  "JavaScript coding guidelines"
  (setq indent-tabs-mode nil)
)
(add-hook 'js-mode-hook 'my-js-stuff)
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))

;; Ruby
(autoload 'ruby-mode "ruby-mode" nil t)
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru\\'" . ruby-mode))
(add-hook 'ruby-mode-hook '(lambda ()
			     (setq ruby-deep-arglist t)
			     (setq ruby-deep-indent-paren nil)
			     (setq c-tab-always-indent nil)
;;			     (require 'inf-ruby)
;;			     (require 'ruby-compilation)
			     ))

;; Set up matlab-mode to load on .m files
(autoload 'matlab-mode "matlab" "Enter MATLAB mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "matlab" "Interactive MATLAB mode." t)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Use ISwitchB... much better than default buffer handler
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ; Need edmacro to work with iswitchb buffer switching
;; (require 'edmacro) ; use require because it's needed right away
;; (require 'iswitchb)
;; (iswitchb-mode 1)
;; (global-set-key "\C-xb" 'iswitchb-buffer)
;; (setq iswitchb-default-method 'samewindow)
;; (defun iswitchb-local-keys ()
;;   (mapc (lambda (K) 
;; 	  (let* ((key (car K)) (fun (cdr K)))
;; 	    (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
;; 	'(("<right>" . iswitchb-next-match)
;; 	  ("<left>"  . iswitchb-prev-match)
;; 	  ("<up>"    . ignore             )
;; 	  ("<down>"  . ignore             ))))

;; (add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)
;; Actually.... use ido mode (does find files as well)
(ido-mode t)
(setq ido-default-file-method 'selected-window)
(setq ido-default-buffer-method 'selected-window)
(setq ido-max-prospects 0)

;; Subversion
;(require 'psvn)
(add-to-list 'vc-handled-backends 'SVN)

; make all yes/no prompts y/n instead
(fset 'yes-or-no-p 'y-or-n-p)

;; (require 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode)
		("\\.cmake\\'" . cmake-mode))
	      auto-mode-alist))


;; Support for wheel mice
(autoload 'mwheel-install "mwheel" "Enable wheely mouse")
(mwheel-install)

; Add syntax highlighting for .bat and .cmd files
(require 'generic-x)
(add-to-list 'auto-mode-alist '("\\.bat\\'" . bat-generic-mode))
(add-to-list 'auto-mode-alist '("\\.cmd\\'" . bat-generic-mode))

; Use pathnames instead of <n> to uniquify buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; Basic colors
;; (setq default-frame-alist '((foreground-color . "grey80")
;; 			    (background-color . "navy")))


(setq initial-frame-alist '((width . 90) (height . 60)))
(setq default-frame-alist initial-frame-alist)

(if (string= window-system "ns")
    (add-to-list 'default-frame-alist '(font . "-apple-Bitstream_Vera_Sans_Mono-medium-normal-normal-*-11-*-*-*-m-0-iso10646-1")))

;(add-to-list 'default-frame-alist '(font . "-apple-Bitstream_Vera_Sans_Mono-medium-normal-normal--12*"))

(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)
(setq mac-allow-anti-aliasing t)

;; Some code specific stuff
(global-font-lock-mode t)
(setq-default transient-mark-mode t)

;; KR TODO: Rewrite this using color-theme
;; (set-face-attribute 'font-lock-comment-face nil :foreground "turquoise" :weight 'bold)
;; (set-face-attribute 'font-lock-string-face nil :foreground "yellow")
;; (set-face-attribute 'font-lock-function-name-face nil :foreground "red")
;; (set-face-attribute 'font-lock-type-face nil :foreground "deep sky blue")
;; (set-face-attribute 'font-lock-keyword-face nil :foreground "PaleGreen")
;; (set-face-attribute 'font-lock-constant-face nil :foreground "PaleGreen")

;; (set-face-attribute 'ido-first-match nil :foreground "red1")
;; (set-face-attribute 'ido-subdir nil :foreground "yellow1" :weight 'bold)

;; Eshell should interpret colors
;;(add-to-list 'eshell-output-filter-functions 'eshell-handle-control-codes)

;; Make .gz files open automatically
(auto-compression-mode 1)

;; My pinky hurts always hitting C-x C-s to save
;; This allows me to do "Windows" type saving.  File menu, save M-f s
( global-unset-key "\M-f" )
( global-set-key "\M-fs" 'save-buffer )( global-set-key "\M-f\M-s" 'save-buffer )

;;
;; Never understood why Emacs doesn't have this function.
;;
(defun rename-file-and-buffer (new-name)
 "Renames both current buffer and file it's visiting to NEW-NAME." (interactive "sNew name: ")
 (let ((name (buffer-name))
	(filename (buffer-file-name)))
 (if (not filename)
	(message "Buffer '%s' is not visiting a file!" name)
 (if (get-buffer new-name)
	 (message "A buffer named '%s' already exists!" new-name)
	(progn 	 (rename-file name new-name 1) 	 (rename-buffer new-name) 	 (set-visited-file-name new-name) 	 (set-buffer-modified-p nil))))))
;;
;; Never understood why Emacs doesn't have this function, either.
;;
(defun move-buffer-file (dir)
 "Moves both current buffer and file it's visiting to DIR." (interactive "DNew directory: ")
 (let* ((name (buffer-name))
	 (filename (buffer-file-name))
	 (dir
	 (if (string-match dir "\\(?:/\\|\\\\)$")
	 (substring dir 0 -1) dir))
	 (newname (concat dir "/" name)))

 (if (not filename)
	(message "Buffer '%s' is not visiting a file!" name)
 (progn 	(copy-file filename newname 1) 	(delete-file filename) 	(set-visited-file-name newname) 	(set-buffer-modified-p nil) 	t)))) 


;; Mitra specific settings

(require 'cc-mode)
(c-set-offset 'substatement-open 0)
(c-set-offset 'case-label +1)
(setq truncate-lines t)
(setq tab-width 4)

(defun my-c++-indent-setup ()
  (setq c-basic-offset 4)
  (setq indent-tabs-mode nil)
  (setq truncate-lines t)
  (setq tab-width 4))

(add-hook 'c++-mode-hook 'my-c++-indent-setup)

;; Hide / Show Minor Mode should autoload when coding
;; See also semantic-tag-folding-mode
(add-hook 'c-mode-common-hook
	  (lambda () (hs-minor-mode 1)))
(add-hook 'hs-minor-mode-hook
	  (lambda () (local-set-key [(control ?=)] 'hs-show-block)))
(add-hook 'hs-minor-mode-hook
	  (lambda () (local-set-key [(control ?-)]
				    '(lambda () (interactive) (end-of-line) (hs-hide-block)))))


(defun ruby-hs-minor-mode (&optional arg)
  (interactive)
  (require 'hideshow)
  (unless (assoc 'ruby-mode hs-special-modes-alist)
    (setq
     hs-special-modes-alist
     (cons (list 'ruby-mode
                 "\\(def\\|do\\)"
                 "end"
                 "#"
                 (lambda (&rest args) (ruby-end-of-block))
                 ;(lambda (&rest args) (ruby-beginning-of-defun))
                 )
           hs-special-modes-alist)))
  (hs-minor-mode arg))

(defadvice goto-line (after expand-after-goto-line
			    activate compile)
  "hideshow-expand affected block when using goto-line in a collapsed buffer"
  (save-excursion
    (hs-show-block)))

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

 ;; Tell cc-mode not to check for old-style (K&R) function declarations.
 ;; This speeds up indenting a lot.
(setq c-recognize-knr-p nil)

;; Show the current function in the mode line
;; See also global-semantic-stickyfunc-mode
(which-function-mode)

; I rarely edit pure C... most of the time it's C++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; I hate having all these backup files lying around
(setq make-backup-files nil)
(setq truncate-lines t)

;; QBasic style window switching
(global-set-key '[f6] 'other-window)
(global-set-key '[S-f6] '(lambda () (interactive) (other-window -1)))

;; Quick keys for moving around files
(global-set-key '[f12] 'bookmark-jump)
(global-set-key '[f9] 'bookmark-set)
(global-set-key '[f5] 'goto-line)
(global-set-key '[C-f4] 'kill-this-buffer)
(global-set-key '[C-f11] 'revert-buffer)
(global-set-key '[f11] 'recompile)

(global-set-key '[C-tab] 'other-frame)
(global-set-key '[C-S-tab] '(lambda () (interactive) (other-frame -1)))

;; Page scrolling
(global-set-key '[C-down] '(lambda () (interactive) (scroll-up 1)))
(global-set-key '[C-up] '(lambda () (interactive) (scroll-down 1)))

(global-set-key '[C-kp-home] 'beginning-of-buffer)
(global-set-key '[C-kp-end] 'end-of-buffer)
(global-set-key '[S-kp-delete] 'cua-cut-region)
(global-set-key '[kp-delete] 'delete-char)

(global-set-key [mouse-3] 'imenu)

;; Screen space is precious... don't waste it on toolbars and scrollbars
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Set home directory to CCWD
(cd "~")

(setenv "CVS_RSH" "ssh")

(setq ring-bell-function (lambda ()))


;;

;;(setenv "CCACHE_DIR" "/v/rosek/.ccache" )
(setenv "PATH" (concat "/opt/local/bin/sbt:" (getenv "PATH")) )
;(setenv "PATH" (concat (concat (getenv "HOME") "/bin:") (getenv "PATH")) )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector (vector "#708183" "#c60007" "#728a05" "#a57705" "#2075c7" "#c61b6e" "#259185" "#042028"))
 '(custom-enabled-themes (quote (sanityinc-tomorrow-day)))
 '(custom-safe-themes (quote ("bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default)))
 '(fci-rule-color "#0a2832")
 ;; confluence customization
;; '(confluence-url "https://pagerduty.atlassian.net/rpc/xmlrpc")
 '(confluence-url "http://localhost:16000")
 '(confluence-default-space-alist (list (cons confluence-url "Platform")))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map (quote ((20 . "#c60007") (40 . "#bd3612") (60 . "#a57705") (80 . "#728a05") (100 . "#259185") (120 . "#2075c7") (140 . "#c61b6e") (160 . "#5859b7") (180 . "#c60007") (200 . "#bd3612") (220 . "#a57705") (240 . "#728a05") (260 . "#259185") (280 . "#2075c7") (300 . "#c61b6e") (320 . "#5859b7") (340 . "#c60007") (360 . "#bd3612"))))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;(require 'color-theme)
(color-theme-sanityinc-tomorrow-blue)
(put 'upcase-region 'disabled nil)

; Workaround for Mac OS El Capitan
(setq visible-bell nil) ;; The default
(setq ring-bell-function 'ignore)
