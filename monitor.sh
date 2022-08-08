#!/bin/bash

rundir=
pipeline=sppcomp


soft1=bwa-mem2
soft2=samtools

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
/usr/bin/time -v git clone --recursive https://github.com/$soft2/$soft2.git --branch 1.14 2> $soft2.err

check=$(grep Exit $soft2.err | cut -d":" -f2 | tr -d "[:blank:]")
	if [ $check !=  0 ]
	then
	var_sms2=$(echo "Exit")
	else
	var_sms2=$(echo "OK")	
	fi

time=$(date)

/home/ntellini/tools/conda_pacbio_env/bin/telegram-send "$time" "LICO report" "Pipeline $pipeline:" "$soft1: $var_sms1" "$soft2: $var_sms2"

cd ..

rm -fr $rundir/$pipeline $rundir/nohup.out
