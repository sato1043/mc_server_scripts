#! /bin/bash

#===============================================================
# マインクラフトサーバー管理・共通変数定義
#===============================================================

# 実行タイムスタンプ文字列
TIMESTAMP=`date +%Y%m%d-%H%M%S`

# スタートアップシェル格納パス
SH_DIR='/home/mc'
test -d $SH_DIR || { echo "SH_DIR does not exists; ($SH_DIR)" ; exit -1; }

#===============================================================

# サーバー起動ユーザー
USERNAME='mc'
test `whoami` == $USERNAME || { echo "Please run by $USERNAME." ; exit -1; }

# サーバー格納パス
MC_DIR='/home/mc/server'
test -d $MC_DIR || { echo "MC_DIR does not exists; ($MC_DIR)" ; exit -1; }

# サーバーjar
SERVICE='paper-1.16.5-586.jar'
test -f "$MC_DIR/$SERVICE" || { echo "SERVICE does not exists; ($MC_DIR/$SERVICE)" ; exit -1; }

# screenのサーバーセッション名
SCNAME='mc'

#===============================================================

# フルバックアップ保存世代数
FULL_BK_GEN="3"
FULL_TAIL_GEN="+4"

# フルバックアップ格納パス
FULL_BK_DIR='/home/mc/__full_backups'
test -d $FULL_BK_DIR || { echo "FULL_BK_DIR does not exists; ($FULL_BK_DIR)" ; exit -1; }

# フルバックアップファイル名
FULL_BK_NAME="${FULL_BK_DIR}/${TIMESTAMP}_full.tgz"
FULL_TGT_FILE="${FULL_BK_DIR}/????????-??????_full.tgz"

#===============================================================

# マップバックアップ保存世代数
MAPS_BK_GEN="3"
MAPS_TAIL_GEN="+4"

# マップバックアップ対象マップ
MAPS_BK_FILE="Torn2 lotr odyssey oshode"

# バックアップ格納パス
MAPS_BK_DIR='/home/mc/__maps_backups'
test -d $MAPS_BK_DIR || { echo "MAPS_BK_DIR does not exists; ($MAPS_BK_DIR)" ; exit -1; }

# マップバックアップファイル名
MAPS_BK_NAME="${MAPS_BK_DIR}/${TIMESTAMP}_maps.tgz"
MAPS_TGT_FILE="${MAPS_BK_DIR}/????????-??????_maps.tgz"

#===============================================================

# データベースバックアップファイル名
DB_BK_NAME="${MC_DIR}/all-databases.sql.gz"
test -f $DB_BK_NAME && { echo "DB_BK_NAME already exists; ($DB_BK_NAME)" ; exit -1; }

#===============================================================

# ログファイル名
LOGS_TGT_FILE="${MC_DIR}/logs/????-??-??-*.log.gz"

# ログファイル保存世代数
LOGS_BK_GEN="30"
LOGS_TAIL_GEN="+31"

#===============================================================

CMDLINE=$(cat /proc/$$/cmdline | xargs --null)
if [[ $$ -ne $(pgrep -oxf "${CMDLINE}") ]]; then
  echo "shell is already running." >&2
  exit 9
fi

#__END__
