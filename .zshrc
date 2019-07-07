[ -f $ZDOTDIR/.zshrc_local ] && . $ZDOTDIR/.zshrc_local
. $ZDOTDIR/gconf.zsh

# エイリアス
alias ls='ls -G'
alias vi='vim'
alias ll='ls -l -h'

# 自動補完
autoload -Uz compinit; compinit

# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
# 例： /usr/bin と入力すると /usr/bin ディレクトリに移動
setopt auto_cd

# cd した先のディレクトリをディレクトリスタックに追加する
# ディレクトリスタックとは今までに行ったディレクトリの履歴のこと
# `cd +<Tab>` でディレクトリの履歴が表示され、そこに移動できる
setopt auto_pushd

# 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
# コマンド履歴とは今まで入力したコマンドの一覧のことで、上下キーでたどれる
setopt hist_ignore_all_dups

# プロンプト設定
setopt prompt_subst
precmd () {
  vcs_info
}
PROMPT='
%F{032}[%n] %~%{${reset_color}%} ${vcs_info_msg_0_}
%F{250}%(!.#.>)%{$reset_color%} '
RPROMPT=''

# gitの表示
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr "%F{214}+%{$reset_color%}"
zstyle ':vcs_info:git:*' stagedstr "%F{214}!%{$reset_color%}"
zstyle ':vcs_info:*' formats "%F{250}(%c%u%F{250}%b%F{250})%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

# 文字コードの指定
export LANG=ja_JP.UTF-8

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# 色を使用出来るようにする
autoload -Uz colors
colors

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_dups

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 履歴をpecoで選択できるようにする
function peco-select-history() {
  BUFFER=$(\history -n 1 | tac | peco)
  CURSOR=$#BUFFER
#  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# docker関連のエイリアス
alias dcup='docker-compose -f $(ls -l | grep \.yml | awk '\''{print $8}'\'' | peco) up -d'
alias dcdown='docker-compose -f $(ls -l | grep \.yml | awk '\''{print $8}'\'' | peco) down'
alias dps='docker ps --format "{{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Command}}\t{{.RunningFor}}"'
alias dexec='docker exec -it `dps | peco | cut -f 1` /bin/bash'

# ec-cubeプラグイン圧縮 - ec-cube3系のルートディレクトリでこの関数を使う
function plugin-pkg {
  CODE=$(ls -l ./app/Plugin | grep ^d | awk '{print $8}' | peco)
  TARGET=app/Plugin/$CODE
  OUTPUT=~/$CODE.tar.gz
  
  tar -zcf $OUTPUT $TARGET/*
  
  echo "$(pwd)/$TARGET\n-> $OUTPUT"
}

# gcpのインスタンスを選択してssh
function gcp-ssh {
  PROJECT_ID=$(gcloud projects list --format="value(projectId)" | peco)
  INSTANCE=${(z)$(gcloud --project=${PROJECT_ID} compute instances list --format="value(name,zone)" | peco)}
  NAME=${INSTANCE[1]}
  ZONE=${INSTANCE[2]}
  gcloud --project=${PROJECT_ID} compute ssh ${NAME} --zone=${ZONE}
}

# Processを選択してkill
alias kill-ps='kill $(ps aux | peco)'

