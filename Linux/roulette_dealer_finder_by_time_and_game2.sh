
cat $1_Dealer_schedule | awk -v n=$3 '{print $1,$2,$('$3,$4')}' | grep "$2"