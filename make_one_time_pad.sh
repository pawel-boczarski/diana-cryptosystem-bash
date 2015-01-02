#!/bin/bash

if [ 1 -gt $# ] ; then
	nwords=5
else
	nwords=$1
fi

LETTERS=QWERTYUIOPASDFGHJKLZXCVBNM


word()
{
	for i in 1 2 3 4 5
	do
		no=$(($RANDOM % ${#LETTERS}))
		echo -n ${LETTERS:$no:1}
	done
}

for i in `seq 1 $nwords`
do
	word
	echo -n " "
done

