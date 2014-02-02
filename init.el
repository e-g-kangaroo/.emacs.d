;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-

;; おまじない
(require 'cl)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load-path 関連
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; elispとconfディレクトリをサブディレクトリごとload-pathに追加
(add-to-load-path "elisp" "conf")

;; (setq load-path (cons "/Applications/Emacs.app/Contents/Resources/site-lisp/" load-path))

;; より下に記述した物が PATH の先頭に追加
(dolist (dir (list
              "/sbin"
              "/usr/sbin"
              "/bin"
              "/usr/bin"
              "/opt/local/bin"
              ;; "/sw/bin"
              "/usr/local/bin"
              (expand-file-name "~/bin")
              ;; (expand-file-name "~/.emacs.d/bin")
              ))

  ;; PATH と exec-path に同じ物を追加
 (when (and (file-exists-p dir) (not (member dir exec-path)))
   (setenv "PATH" (concat dir ":" (getenv "PATH")))
   (setq exec-path (append (list dir) exec-path))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 表示関係
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 全画面表示
(set-frame-parameter nil 'fullscreen 'fullboth)

;; 警告音もフラッシュも全て無効(警告音が完全に鳴らなくなるので注意)
(setq ring-bell-function 'ignore)

;; タブの表示幅の指定&タブを使うのを抑止
(setq default-tab-width 2 indent-tabs-mode nil)

;; 保存時に自動的にタブをスペース
(require 'untabify-file)

;; 選択範囲の色の反転
(setq-default transient-mark-mode t)

;; 背景を黒に
(if window-system (progn
  (set-background-color "Black")       ; 背景色
  (set-foreground-color "White")       ; 前景色
  (set-cursor-color "Magenta")          ; カーソル色
  (set-frame-parameter nil 'alpha 70)  ; 透過具合
))

;; 行番号を表示
(require 'linum)
(global-linum-mode)

;; 行のハイライト
(defface hlline-face
  '((((class color)
      (background dark))
     ;;(:background "dark state gray"))
     (:background "gray10"
                  :underline "gray24"))
    (((class color)
      (background light))
     (:background "ForestGreen"
                  :underline nil))
    (t ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
;;(setq hl-line-face 'underline)
(global-hl-line-mode)

;; メニューバーにファイルのフルパスを表示
(setq frame-title-format
      (format "[%%b] %%f - Emacs"))

;; カーソルを点滅
(blink-cursor-mode t)

;; paren: 対応する括弧を光らせる
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)                    ; カッコ内の色も変更
(set-face-background 'show-paren-match-face nil)       ; カッコ内のフェイス
(set-face-underline-p 'show-paren-match-face "blue") ; カッコ内のフェイス

;; オートセーブ
(require 'auto-save-buffers)
(run-with-idle-timer 1.0 t 'auto-save-buffers)

;; Show tab, zenkaku-space, white spaces at end of line
;; http://www.bookshelf.jp/soft/meadow_26.html#SEC317
(defface my-face-tab         '((t (:background "Yellow"))) nil :group 'my-faces)
(defface my-face-zenkaku-spc '((t (:background "LightBlue"))) nil :group 'my-faces)
(defface my-face-spc-at-eol  '((t (:foreground "Red" :underline t))) nil :group 'my-faces)
(defvar my-face-tab         'my-face-tab)
(defvar my-face-zenkaku-spc 'my-face-zenkaku-spc)
(defvar my-face-spc-at-eol  'my-face-spc-at-eol)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(("\t" 0 my-face-tab append)
     ("　" 0 my-face-zenkaku-spc append)
     ("[ \t]+$" 0 my-face-spc-at-eol append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
;; settings for text file
(add-hook 'text-mode-hook
          '(lambda ()
             (progn
               (font-lock-mode t)
               (font-lock-fontify-buffer))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 非表示関係
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; スタートアップメッセージを非表示
(setq inhibit-startup-screen t)
(when window-system
  ;; tool-bar を非表示
  (tool-bar-mode 0)
  ;; scroll-bar を非表示
  (scroll-bar-mode 0))
;; menu-bar を非表示
(menu-bar-mode 0)

;; Emacsからの質問を y/n で回答する
(fset 'yes-or-no-p 'y-or-n-p)

;; バックアップファイルを作らない
(setq backup-inhibited t)

;;複数ウィンドウを開かないようにする
(setq ns-pop-up-frames nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; キーバインドの割り当て関係
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Macのキーバインドを使う。optionをメタキーにする。
;;(mac-key-mode 1)
;;(setq mac-option-modifier 'meta)

;;シフト押しながらキー移動で範囲選択
(setq pc-select-selection-keys-only t)
;; (pc-selection-mode 1)

;; C-kで行全体を削除
(setq kill-whole-line t)

;; バッファ全体をインデント
;; (define-key (kbd "C-<f8>") (kbd "C-x h TAB"))

;; "C-m" に newline-and-indent を割り当てる。初期値は newline
(define-key global-map (kbd "C-m") 'newline-and-indent)

;; "M-k" でカレントバッファを閉じる。初期値は kill-sentence
(define-key global-map (kbd "M-k") 'kill-this-buffer)

;; "C-t" でウィンドウを切り替える。初期値は transpose-chars
(define-key global-map (kbd "C-t") 'other-window)

;; Mac の command + → でウィンドウを左右に分割
(define-key global-map (kbd "s-<right>") 'split-window-horizontally)

;; Mac の Command + ↓ でウィンドウを上下に分割
(define-key global-map (kbd "s-<down>") 'split-window-vertically)

;; Mac の Command + w で現在のウィンドを削除
(define-key global-map (kbd "s-w") 'delete-window)

;;ウィンドウ移動
(global-set-key (kbd "C-s-<left>")  'windmove-left)
(global-set-key (kbd "C-s-<down>")  'windmove-down)
(global-set-key (kbd "C-s-<up>")    'windmove-up)
(global-set-key (kbd "C-s-<right>") 'windmove-right)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-install 関係
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (install-elisp "http://www.emacswiki.org/emacs/download/auto-install.el")
(when (require 'auto-install nil t)
  ; Emacs Lisp をインストールするディレクトリの指定
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ; EmacsWiki に登録されている elisp の名前を取得
  ;(auto-install-update-emacswiki-package-name t)
  ; プロキシの設定
  ;(setq url-proxy-services '(("http" . "localhost:8339")))
  ; install-elisp.elとコマンド名を同期
  (auto-install-compatibility-setup))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; anything 関係
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; anything
;; (auto-install-batch "anything")
;; (when (require 'anything nil t)
  (setq
   ;; 候補を表示するまでの時間。デフォルトは0.5
   anything-idle-delay 0.3
   ;; タイプして再描写するまでの時間。デフォルトは0.1
   anything-input-idle-delay 0.2
   ;; 候補の最大表示数。デフォルトは50
   anything-candidate-number-limit 100
   ;; 候補が多いときに体感速度を早くする
   anything-quick-update t
   ;; 候補選択ショートカットをアルファベットに
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
    ;; root権限でアクションを実行するときのコマンド
    ;; デフォルトは"su"
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)
  (and (equal current-language-environment "Japanese")
       (executable-find "cmigemo")
       (require 'anything-migemo nil t))
  (when (require 'anything-complete nil t)
    ;; M-xによる補完をAnythingで行なう
    ;; (anything-read-string-mode 1)
    ;; lispシンボルの補完候補の再検索時間
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
    ;; describe-bindingsをAnythingに置き換える
    (descbinds-anything-install))

  (require 'anything-grep nil t)

  ;; Command+f で anything
  (define-key global-map (kbd "s-f") 'anything)
  ;; Command+y で anything-show-kill-ring
  (define-key global-map (kbd "s-y") 'anything-show-kill-ring)

  ;; manやinfoを調べるコマンドを作成してみる
  ;; anything-for-document 用のソースを定義
  (setq anything-for-document-sources
      (list anything-c-source-man-pages
            anything-c-source-info-cl
            anything-c-source-info-pages
            anything-c-source-info-elisp
            anything-c-source-apropos-emacs-commands
            anything-c-source-apropos-emacs-functions
            anything-c-source-apropos-emacs-variables))
  ;; anything-for-document コマンドを作成
  (defun anything-for-document ()
    "Preconfigured `anything' for anything-for-document."
    (interactive)
    (anything anything-for-document-sources (thing-at-point 'symbol) nil nil nil "*anything for document*"))
  ;; Command+d に anything-for-documentを割り当て
  (define-key global-map (kbd "s-d") 'anything-for-document)
  (global-set-key (kbd "C-;") 'anything)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto Complete Mode 関係
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories (expand-file-name "~/.emacs.d/elisp//ac-dict"))
(ac-config-default)

(global-auto-complete-mode t)
(setq ac-auto-start t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Elscreen 関係
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Elscreen：GNU Screenライクなウィンドウ管理を実現
(when (require 'elscreen nil t)
  (if window-system
    (define-key elscreen-map (kbd "C-z") 'iconify-or-deiconify-frame)
    (define-key elscreen-map (kbd "C-z") 'suspend-emacs)))

(require 'elscreen-speedbar)

(require 'elscreen-server)

(require 'elscreen-dnd)

;; 以下は自動でスクリーンを生成する場合の設定
(defmacro elscreen-create-automatically (ad-do-it)
  `(if (not (elscreen-one-screen-p))
       ,ad-do-it
     (elscreen-create)
     (elscreen-notify-screen-modification 'force-immediately)
     (elscreen-message "New screen is automatically created")))

(defadvice elscreen-next (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

(defadvice elscreen-previous (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

(defadvice elscreen-toggle (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 拡張機能関係
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; undohist：閉じたバッファも Undo できる
;; (install-elisp "http://cx4a.org/pub/undohist.el")
(when (require 'undohist nil t)
  (undohist-initialize))

;; undo-tree：Undo の分岐を視覚化する
;; (install-elisp "http://www.dr-qubit.org/undo-tree/undo-tree.el")
(when (require 'undo-tree nil t)
  (global-undo-tree-mode t)
  (global-set-key (kbd "M-s-Ω") 'undo-tree-redo))

;; point-undo：カーソル位置を Undo
;; (install-elisp "http://www.emacswiki.org/cgi-bin/wiki/download/point-undo.el")
(when (require 'point-undo nil t)
  (define-key global-map (kbd "M-[") 'point-undo)
  (define-key global-map (kbd "M-]") 'point-redo))

;; wdiree：dired で直接ファイルをリネーム
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MySQL 関係
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; デフォルトの接続情報
(setq sql-user "root"
      sql-server "127.0.0.1"
      sql-product "mysql")

(autoload 'sql-mode "sql" "SQL Edit mode" t)
(autoload 'sql-oracle "sql" "SQL Edit mode" t)
(autoload 'sql-ms "sql" "SQL Edit mode" t)
(autoload 'master-mode "master" "Master mode minor mode." t)

;; SQL mode に入った時点で sql-indent / sql-complete を読み込む
(eval-after-load "sql"
  '(progn
     (load-library "sql-indent")
     (load-library "sql-complete")
     (load-library "sql-transform")
     ))

;; SQL モードの雑多な設定
(add-hook 'sql-mode-hook
    (function (lambda ()
                (setq sql-indent-offset 4)
                (setq sql-indent-maybe-tab t)
                (local-set-key "\C-cu" 'sql-to-update) ; sql-transform
                 ;; SQLi の自動ポップアップ
                   (setq sql-pop-to-buffer-after-send-region t)
                ;; master モードを有効にし、SQLi をスレーブバッファにする
                   (master-mode t)
                (master-set-slave sql-buffer)
                ))
    )
(add-hook 'sql-set-sqli-hook
          (function (lambda ()
                      (master-set-slave sql-buffer))))
(add-hook 'sql-interactive-mode-hook
          (function (lambda ()
                      ;; 「;」をタイプしたら SQL 文を実行
                         (setq sql-electric-stuff 'semicolon)
                      ;; comint 関係の設定
                         (setq comint-buffer-maximum-size 500)
                      (setq comint-input-autoexpand t)
                      (setq comint-output-filter-functions
                            'comint-truncate-buffer)))
          )

;; SQL モードから SQLi へ送った SQL 文も SQLi ヒストリの対象とする
(defadvice sql-send-region (after sql-store-in-history)
  "The region sent to the SQLi process is also stored in the history."
  (let ((history (buffer-substring-no-properties start end)))
    (save-excursion
      (set-buffer sql-buffer)
      (message history)
      (if (and (funcall comint-input-filter history)
               (or (null comint-input-ignoredups)
                   (not (ring-p comint-input-ring))
                   (ring-empty-p comint-input-ring)
                   (not (string-equal (ring-ref comint-input-ring 0)
                                      history))))
          (ring-insert comint-input-ring history))
      (setq comint-save-input-ring-index comint-input-ring-index)
      (setq comint-input-ring-index nil))))
(ad-activate 'sql-send-region)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PHP 関係
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; php-mode
(require 'php-mode)

(setq php-mode-force-pear t) ;PEAR規約のインデント設定にする
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode)) ;*.phpのファイルのときにphp-modeを自動起動する

;; php-mode-hook
(add-hook 'php-mode-hook
          (lambda ()
            (require 'php-completion)
            (php-completion-mode t)
            (define-key php-mode-map (kbd "C-o") 'phpcmp-complete) ;php-completionの補完実行キーバインドの設定
            (make-local-variable 'ac-sources)
            (setq ac-sources '(
                               ac-source-words-in-same-mode-buffers
                               ac-source-php-completion
                               ac-source-filename
                               ))))

;; php-modeでインデントを2つに
(add-hook 'php-mode-hook
      '(lambda()
         (setq indent-tabs-mode nil)
         (setq indent-level 2)
         (setq tab-width 2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ruby 関係
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; インデントを素敵にする
(defadvice ruby-indent-line (after unindent-closing-paren activate)
  (let ((column (current-column))
        indent offset)
    (save-excursion
      (back-to-indentation)
      (let ((state (syntax-ppss)))
        (setq offset (- column (current-column)))
        (when (and (eq (char-after) ?\))
                   (not (zerop (car state))))
          (goto-char (cadr state))
          (setq indent (current-indentation)))))
    (when indent
      (indent-line-to indent)
      (when (> offset 0) (forward-char offset)))))

;; ruby-mode
(setq load-path (cons (expand-file-name "~/elisp/ruby") load-path))
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda () (inf-ruby-keys)))

;; ruby-electric
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

;; rubydb
(autoload 'rubydb "rubydb3x"
  "run rubydb on program file in buffer *gud-file*.
the directory containing file becomes the initial working directory
and source-file directory for your debugger." t)

;; rails
(setq load-path (cons (expand-file-name "~/elisp/emacs-rails") load-path))
(defun try-complete-abbrev (old)
  (if (expand-abbrev) t nil))
(setq hippie-expand-try-functions-list
      '(try-complete-abbrev
        try-complete-file-name
        try-expand-dabbrev))
(setq rails-use-mongrel t)
;(require 'cl)
(require 'rails)

;; ruby-block
(require 'ruby-block)
(ruby-block-mode t)

;; ミニバッファに表示し, かつ, オーバレイする.
(setq ruby-block-highlight-toggle t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SCSS 関係
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp"))
(autoload 'scss-mode "scss-mode")

;; 自動コンパイルをオフにする
(setq scss-compile-at-save nil)
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

;; indent幅を2に
(defun scss-custom ()
  (setq indent-tabs-mode nil)
  (setq css-indent-offset 2)
  )
(add-hook 'scss-mode-hook
  '(lambda() (scss-custom)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; flymake 関係
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (require 'flymake nil t)
  (global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)

;; PHP用設定
(when (not (fboundp 'flymake-php-init))
  ;; flymake-php-initが未定義のバージョンだったら、自分で定義する
  (defun flymake-php-init ()
    (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
           (local-file  (file-relative-name
                         temp-file
                         (file-name-directory buffer-file-name))))
      (list "php" (list "-f" local-file "-l"))))
  (setq flymake-allowed-file-name-masks
        (append
         flymake-allowed-file-name-masks
         '(("\\.php[345]?$" flymake-php-init))))
  (setq flymake-err-line-patterns
        (cons
         '("\\(\\(?:Parse error\\|Fatal error\\|Warning\\): .*\\) in \\(.*\\) on line \\([0-9]+\\)" 2 3 nil 1)
         flymake-err-line-patterns)))

(add-hook 'php-mode-hook
          '(lambda() (flymake-mode t)))

;; JavaScript用設定
(when (not (fboundp 'flymake-javascript-init))
  ;; flymake-javascript-initが未定義のバージョンだったら、自分で定義する
  (defun flymake-javascript-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      ;;(list "js" (list "-s" local-file))
      (list "jsl" (list "-process" local-file))
      ))
  (setq flymake-allowed-file-name-masks
        (append
         flymake-allowed-file-name-masks
         '(("\\.json$" flymake-javascript-init)
           ("\\.js$" flymake-javascript-init))))
  (setq flymake-err-line-patterns
        (cons
         '("\\(.+\\)(\\([0-9]+\\)): \\(?:lint \\)?\\(\\(?:warning\\|SyntaxError\\):.+\\)" 1 2 nil 3)
         flymake-err-line-patterns)))

(add-hook 'javascript-mode-hook
          '(lambda() (flymake-mode t))))

;; ruby用設定
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))

(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)

(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

(add-hook 'ruby-mode-hook
          '(lambda ()

             ;; Don't want flymake mode for ruby regions in rhtml files and also on read only files
             (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
                 (flymake-mode t))
             ))

(global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)
(global-set-key "\C-cn" 'flymake-goto-next-error)
(global-set-key "\C-cp" 'flymake-goto-prev-error)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; font 関連
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-face-attribute 'default nil
                   :family "Ricty"
                   :height 110)
(set-fontset-font
 nil 'japanese-jisx0208
 (font-spec :family "Ricty"))


(set-language-environment "Japanese")
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)

;; for MacOSX
(require 'ucs-normalize)
(setq file-name-coding-system 'utf-8-hfs)
(setq locale-coding-system 'utf-8-hfs)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
