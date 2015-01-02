#!/bin/bash

echo "Arguments: $*"

if [ 0 -eq $# ] || [ $1 != "-c" ] && [ $1 != "-d" ]
then
	echo "Use: "
	echo "   $0 -c WORDS TO CIPHER"
	echo " OR"
	echo "   $0 -d CIPHE RTEXT TODEC IPHER"
	exit -1
fi

# cipher book contains variables named KEY_A, KEY_B ...
# containing the code table row for the specified letter currently on one time pad
. cipher_book
OTP=`cat one_time_pad | sed 's/ //g'`
LETTERS=ABCDEFGHIJKLMNOPQRSTUVWXYZ

do_word()
{
	arg=$1
	letter=${arg:0:1}
	letterno=-1

	# TODO can we do this even simpler?
	for i in `seq 0 $((${#LETTERS} - 1))`
	do
		if [ "$letter" = "${LETTERS:$i:1}" ]
		then
			letterno=$i
			break
		fi
	done

	# next letter from one time pad
	otp_letter=${OTP:0:1}
	OTP=${OTP:1}

	# construct the variable name with code table row for letter from one time pad
	varname=KEY_$otp_letter
	eval line=\$$varname

	# write out next ciphertext letter
	CIPHER=$CIPHER${line:$letterno:1}
	# we add space each five ciphertext letters
	if [ 5 == $(( ${#CIPHER} % 6 )) ]
	then
		CIPHER="$CIPHER "
	fi
	
	# recursively cipher the rest of the word
	arg=${arg:1}
	if [ 0 -ne ${#arg} ]
	then
		do_word $arg
	fi
}

if [ "$1" == "-c" ] 	# plaintext => ciphertext
then
	first=1
	# glue up parameters making plaintext without spaces
	for i in "$@"
	do
		if [ 1 == $first ]	# discard unnecessary '-c'
		then
			first=0
			continue
		fi
		TO_CIPHER=$TO_CIPHER$i
	done

	# we emit first ten characters of one time pad discarding them
	CIPHER="${OTP:0:5} ${OTP:5:5} "
	OTP=${OTP:10}
	do_word $TO_CIPHER
	echo $CIPHER
else			# ciphertext => plaintext
	first=1
	for i in "$@"
	do
		if [ 1 == $first ]	# discard unnecessary '-d'
		then
			first=0
			continue
		fi
	
		TO_DECIPHER=$TO_DECIPHER$i
	done
	
	# first ten characters are plaintext characters from the one time pad
	# they need not be the ones from beginning so let's find them and discard the used part
	# of one time pad
	while [ ${TO_DECIPHER:0:10} != ${OTP:0:10} ]
	do
		OTP=${OTP:5}
	done
	OTP=${OTP:10}
	TO_DECIPHER=${TO_DECIPHER:10}

	# from now, ciphering works exactly the same way as deciphering.
	# this is due to code book being implemented as symmetric permutations
	do_word $TO_DECIPHER
	echo $CIPHER
fi
