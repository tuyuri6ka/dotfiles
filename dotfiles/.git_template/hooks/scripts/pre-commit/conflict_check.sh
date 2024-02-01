#!/bin/bash

ERR_FLG=0
CONFLICT_WORDS="^\+<<<<<<<\|^\+=======$\|^\+>>>>>>>"
DISP_CONFLICT_WORDS=('+<<<<<<<' '+=======' '+>>>>>>>')

for path in `git diff --name-only --cached | grep -v "\.jpg$\|\.png$\|\.gif$\|\.swf$"`
do
	if [ ! -f $path ]; then
		continue;
	fi

	if [ -e $path ]; then
		hit_words=`git diff --cached  $path | grep -e ${CONFLICT_WORDS}`
		if [ "${hit_words}" ]; then
			for disp_word in ${DISP_CONFLICT_WORDS[@]}; do
				for hit_word in ${hit_words[@]};do
					if [ ${hit_word} == ${disp_word} ]; then
						echo "conflict word ${disp_word} is detected on your commit at ${path}"
						ERR_FLG=1
					fi
				done
			done
		fi
	fi
done

# commit NG
if [ $ERR_FLG = 1 ]; then
	echo "Commit is aborted. Please fix commit-blocking bugs"
	exit 1
fi

# commit OK
exit 0
