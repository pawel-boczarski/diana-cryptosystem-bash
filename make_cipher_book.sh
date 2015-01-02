#!/bin/bash

. ./perm.sh

LETTERS=ABCDEFGHIJKLMNOPQRSTUVWXYZ
#LETTERS=ABCDEF

# symmetric permutation
do_simperm()
{
	NEW_PERM=$LETTERS
	simple_perm=`perm $LETTERS`
	for i in `seq 0 $(( ${#LETTERS} / 2 - 1))`
	do
		j=$(($i * 2))
		k=$(($i * 2 + 1))
		for i in `seq 0 $(( ${#LETTERS} - 1))`
		do
			if [ "${LETTERS:$i:1}" = "${simple_perm:j:1}" ]
			then
				jj=$i
			elif [ "${LETTERS:$i:1}" = "${simple_perm:k:1}" ]
			then
				kk=$i
			fi
		done

		if [ $jj -lt $kk ]
		then
			k=$kk
			j=$jj
		else
			j=$kk
			k=$jj
		fi
		NEW_PERM=${NEW_PERM:0:$j}${LETTERS:$k:1}${NEW_PERM:$(($j+1)):$(($k-$j-1))}${LETTERS:$j:1}${NEW_PERM:$(($k+1))}
	done
	echo $NEW_PERM
}

#do_simperm
#exit -1

for i in `seq 1 ${#LETTERS}`
do
	echo -n "KEY_${LETTERS:$(($i - 1)):1}="
	do_simperm
done
