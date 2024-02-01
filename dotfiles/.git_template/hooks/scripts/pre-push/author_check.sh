#!/bin/bash

# commitのauthorが設定されているかチェックする
# gwdev~の場合、author未指定でcommitされているためpushさせない

LATEST_COMMIT_AUTHOR=`git log -1 --pretty=format:"%an"`

# push NG
if [[ $LATEST_COMMIT_AUTHOR =~ ^test ]]; then
	echo "latest commit author=$LATEST_COMMIT_AUTHOR"
	echo "Push is aborted. Please add author to commit option."
	exit 1
fi

# push OK
exit 0
