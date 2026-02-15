# CLAUDE.md

このリポジトリは **sharikae/dotfiles** — [skwp/dotfiles](https://github.com/skwp/dotfiles) をフォークした開発環境構成ファイル集。macOS、Ubuntu、Debian をサポート。

## リポジトリ構造

```
.
├── bin/          # CLIスクリプト群（dotfilesコマンド、fasd、プラグイン管理）
├── chrome/       # Chrome カスタムCSS
├── ctags/        # CTags 設定（JavaScript/Ruby対応強化）
├── doc/          # ドキュメント（Vim操作、Zshテーマ、プラグイン管理等）
├── fonts/        # Powerline/Lightline 対応パッチ済みフォント
├── git/          # Git 設定（gitconfig, gitignore）
├── iTerm2/       # iTerm2 Solarized カラースキーム
├── irb/          # Pry/IRB 設定（Ruby REPL）
├── ruby/         # gemrc, rdebugrc
├── tmux/         # Tmux 設定
├── vim/          # Vim プラグイン・設定一式
├── vimify/       # CLI ツール向け Vi モード（inputrc, editrc）
├── zsh/          # Zsh 設定・Prezto フレームワーク
├── vimrc         # Vim メイン設定ファイル
├── Rakefile      # インストール・アップデート用 Rake タスク
├── install.sh    # macOS 用インストーラ
├── install-linux.sh   # Ubuntu / Debian 用インストーラ
├── install-ubuntu.sh  # Ubuntu 用インストーラ（レガシー）
├── Dockerfile    # Docker コンテナ定義
└── docker-compose.yml
```

## インストール方法

**macOS:**
```sh
sh -c "`curl -fsSL https://raw.githubusercontent.com/sharikae/dotfiles/master/install.sh`"
```

**Ubuntu / Debian:**
```sh
bash install-linux.sh
```

内部的に `rake install` が実行され、シンボリックリンクの作成・プラグインのインストール・フォントの配置等が行われる。

## 主要コンポーネント

### Vim
- プラグインマネージャ: **Vundle**（`vim/vundles.vim`）
- リーダーキー: `,`（カンマ）
- インデント: スペース2つ
- スワップ/バックアップファイル無効、永続 undo 有効
- プラグインカテゴリ: `appearance`, `ruby`, `languages`, `git`, `search`, `project`, `vim-improvements`, `textobjects`
- 主要プラグイン: NERDTree, CtrlP, fzf, fugitive, syntastic, neocomplete, lightline, vim-surround, tcomment 等
- 設定ファイル群: `vim/settings/*.vim`

### Zsh
- フレームワーク: **Prezto**（git サブモジュール `zsh/prezto`）
- テーマ: `sorin`（zpreztorc で設定）
- Vi モードキーバインド + Emacs 風 `Ctrl-a`/`Ctrl-e`
- エイリアス多数（`zsh/aliases.zsh`）: Git 操作 50+、Rails/Ruby、ナビゲーション等
- fasd による高速ディレクトリ移動
- rbenv, nodebrew, gcloud, Go のパス設定

### Tmux
- プレフィックス: `Ctrl-a`
- ペイン分割: `v`（垂直）/ `s`（水平）
- vim-tmux-navigator によるシームレスなペイン移動（Ctrl-hjkl）
- ステータスバー: 上部表示、日時情報
- マウス操作有効

### Git
- エイリアス 50+（`git/gitconfig`）: `gs`=status, `ga`=add, `gco`=checkout, `gl`=log 等
- グローバル gitignore: macOS/Windows 固有ファイル、エディタ一時ファイル

## Rake タスク

- `rake install` — フルインストール（対話式 or バッチ）
- `rake update` — 既存インストールの更新
- `rake install_vundle` — Vundle のインストール
- `rake install_prezto` — Prezto のインストール

## プラグイン管理コマンド

- `yav -u [github-url]` — Vim プラグイン追加
- `ydv -u [github-path]` — Vim プラグイン削除
- `ylv` — Vim プラグイン一覧
- `yup` — 全プラグイン更新

## コーディング規約

- `.editorconfig` に準拠: インデントはスペース2つ、改行は LF、末尾空白の除去、最終行に改行
- 文字コード: UTF-8

## Docker

```sh
docker-compose up -d
docker-compose exec dotfiles /bin/zsh
```

Ubuntu 24.04 LTS ベースのコンテナで全設定を試せる。
