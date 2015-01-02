#!/bin/bash

echo "Making cipher book..."
./make_cipher_book.sh > cipher_book 
echo "Generating one time pad..."
./make_one_time_pad.sh 1000 > one_time_pad
