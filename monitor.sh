#!/bin/bash

rundir=/favorite/dir/ # this is the path where monitor.sh is stored
pipeline=mypipeline # the name of your pipeline. It is used to send you an apporpriate report on Telegram

soft1=bwa-mem2 # the name of the software we want to check the link status.
soft2=samtools  # the name of the software we want to check the link status.

# CHANGE THE PATH/TO/telegram-send at line 42

cd $rundir

mkdir $pipeline

cd $pipeline

# link 1
/usr/bin/time -v git clone --recursive https://github.com/$soft1/$soft1.git 2> $soft1.err

check=$(grep Exit $soft1.err | cut -d":" -f2 | tr -d "[:blank:]")
	if [ $check != 0 ]
	then
	var_sms1=$(echo "Exit")
	else
	var_sms1=$(echo "OK")	
	fi

# link 2
/usr/bin/time -v git clone --recursive https://github.com/$soft2/$soft2.git 2> $soft2.err

check=$(grep Exit $soft2.err | cut -d":" -f2 | tr -d "[:blank:]")
	if [ $check !=  0 ]
	then
	var_sms2=$(echo "Exit")
	else
	var_sms2=$(echo "OK")	
	fi

time=$(date)

# CHANGE THE PATH/TO/telegram-send 
paht/to/telegram-send "$time" "LICO report" "Pipeline $pipeline:" "$soft1: $var_sms1" "$soft2: $var_sms2"

cd ..

# rm -fr $rundir/$pipeline $rundir/nohup.out
