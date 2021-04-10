#!/bin/bash


cat $1_Dealer_schedule | awk -v n=$3 '{print $1,$2,$(2*n+1),$(2*n+2)}' | grep "$2"
