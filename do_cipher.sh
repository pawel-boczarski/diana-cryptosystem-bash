#!/bin/bash

echo "Arguments: $*"

. cipher_book
OTP=`cat one_time_pad | sed 's/ //g'`
LETTERS=ABCDEFGHIJKLMNOPQRSTUVWXYZ

#echo "OTP: $OTP"
do_word()
{
	arg=$1
	letter=${arg:0:1}
	letterno=-1
	for i in `seq 0 $((${#LETTERS} - 1))`
	do
		if [ "$letter" = "${LETTERS:$i:1}" ]
		then
			letterno=$i
			break
		fi
	done

	otp_letter=${OTP:0:1}
	OTP=${OTP:1}

	varname=KEY_$otp_letter
	eval line=\$$varname

	echo -n ${line:$letterno:1}
	
	arg=${arg:1}
	if [ 0 -ne ${#arg} ]
	then
		do_word $arg
	fi
}


for i in "$@"
do
	do_word $i
	echo -n " "
done
