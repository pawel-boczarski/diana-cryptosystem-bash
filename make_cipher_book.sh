#!/bin/bash

# source the function making permutations
. ./perm.sh

LETTERS=ABCDEFGHIJKLMNOPQRSTUVWXYZ

# symmetric permutation - make permutation that applied twice will make identity
# this will be useful for deciphering being implemented in the same way cipher is 
echo_alphabet_simperm()
{
	NEW_PERM=$LETTERS
	# make random permutation of alphabet.
	# Consecutive letters in the permutation (0-1), (2-3)... etc.
	# will be those that will be mutually swapped with each other in the symmetric permutation
	simple_perm=`perm $LETTERS`
	for i in `seq 0 $(( ${#LETTERS} / 2 - 1))`
	do
		j=$(($i * 2))
		k=$(($i * 2 + 1))

		# find alphabetic index of letters that are at pos j, j+1 in simple_perm
		# TODO can this be done even easier?
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

		# from now j and k will be the indices of letters in alphabet that will be swapped
		if [ $jj -lt $kk ]
		then
			k=$kk
			j=$jj
		else
			j=$kk
			k=$jj
		fi

		# rewrite current symetric permutation only swapping the letters at j, k positions
		NEW_PERM=${NEW_PERM:0:$j}${LETTERS:$k:1}${NEW_PERM:$(($j+1)):$(($k-$j-1))}${LETTERS:$j:1}${NEW_PERM:$(($k+1))}
	done
	echo $NEW_PERM
}

for i in `seq 1 ${#LETTERS}`
do
	echo -n "KEY_${LETTERS:$(($i - 1)):1}="
	echo_alphabet_simperm
done
