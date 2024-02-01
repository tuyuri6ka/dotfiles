#!/bin/bash

# 色装飾参考:
# https://qiita.com/MasaoSasaki/items/f10ab4cd54e228fb436f

# 変数一覧：
# https://qiita.com/ko1nksm/items/095bdb8f0eca6d327233
# ========================================================
eval "$(printf "TAB='\\011' LF='\\012' ESC='\\033'")"
ESC=$(printf '\033') RESET="${ESC}[0m"

BOLD="${ESC}[1m"        FAINT="${ESC}[2m"       ITALIC="${ESC}[3m"
UNDERLINE="${ESC}[4m"   BLINK="${ESC}[5m"       FAST_BLINK="${ESC}[6m"
REVERSE="${ESC}[7m"     CONCEAL="${ESC}[8m"     STRIKE="${ESC}[9m"

GOTHIC="${ESC}[20m"     DOUBLE_UNDERLINE="${ESC}[21m" NORMAL="${ESC}[22m"
NO_ITALIC="${ESC}[23m"  NO_UNDERLINE="${ESC}[24m"     NO_BLINK="${ESC}[25m"
NO_REVERSE="${ESC}[27m" NO_CONCEAL="${ESC}[28m"       NO_STRIKE="${ESC}[29m"

BLACK="${ESC}[30m"      RED="${ESC}[31m"        GREEN="${ESC}[32m"
YELLOW="${ESC}[33m"     BLUE="${ESC}[34m"       MAGENTA="${ESC}[35m"
CYAN="${ESC}[36m"       WHITE="${ESC}[37m"      DEFAULT="${ESC}[39m"

BG_BLACK="${ESC}[40m"   BG_RED="${ESC}[41m"     BG_GREEN="${ESC}[42m"
BG_YELLOW="${ESC}[43m"  BG_BLUE="${ESC}[44m"    BG_MAGENTA="${ESC}[45m"
BG_CYAN="${ESC}[46m"    BG_WHITE="${ESC}[47m"   BG_DEFAULT="${ESC}[49m"
# ========================================================

ERR_FLG=0
ERROR_WORDS=(hoge fuga)

# このファイル自体はチェックから除く
printf "${BOLD}${WHITE} Check NG word:${RESET}${LF}"

# 必要あれば、ここで対象ファイルを絞る
# 必要あれば、モジュール専用 check ng words/テンプレ専用 check ng word とファイルを分けても良い。
for path in `git diff --name-only --cached | grep -v "check_ng_words"`
do
    if [ ! -f $path ]; then
        continue;
    fi

    CHK=0
    for ngword in ${ERROR_WORDS[@]} ;do
        if [ -e $path ]; then
            hit_num=`grep -Ic ${ngword} $path`
            if [ ${hit_num} -gt 0 ]; then
                printf "  ${RED} × NG:${RESET} '${ngword}' is detected at $path ${LF}"
                ERR_FLG=1
                CHK=1
            fi
        fi
    done
    if [ $CHK = 0 ]; then
        printf "  ${GREEN} ✓ OK:${RESET} $path ${LF}"
    fi
done

# commit NG
if [ $ERR_FLG = 1 ]; then
    printf "${RED} Checking NG word Error: Commit is aborted. Please fix commit-blocking bugs${RESET}${LF}"
    exit 1
fi

# commit OK
printf "${BOLD}${GREEN}✨ Check NG word is ALL PASS!!${RESET}${LF}"
exit 0
