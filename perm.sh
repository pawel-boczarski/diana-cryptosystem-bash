#!/bin/bash

perm()
{
	if [ 1 -ne $# ]
	then
		echo "perm: No argument!"
		exit -1
	fi

	arg=$1
	take=$(($RANDOM % ${#arg}))
	taken=${arg:$take:1}
	arg=${arg:0:$take}${arg:$(($take + 1))}
	echo -n $taken
	if [ 0 -ne ${#arg} ]
	then
		perm $arg
	fi
}

if [ 0 -ne $# ]
then
	perm $1
fi
