#!/bin/bash

file=$1
pipeline=$2

# enter rundir
rundir=$(pwd) 
cd $rundir

# make pipeline dir
mkdir $pipeline
cd $pipeline

# Date
time=$(date)

controller ("$1") {
  control=$(grep Exit "$1" | cut -d":" -f2 | tr -d "[:blank:]")
  if [ $control != 0 ]
  then
    var_sms="$var_sms, $soft:Exit"
   else
    var_sms="$var_sms, $soft:OK"
   fi
}

var_sms=""
while read -r link;
do

githubrepo=$(grep "github.com" $line)

if [ -z "$githubrepo" ]
then

# HTTP link
soft=$(echo $link | rev | cut -d"/" -f1 | rev)
/usr/bin/time -v wget $link 2> $soft.err

controller $soft.err

else

# GitHub link
soft=$(echo $link | rev | cut -d"/" -f1 | rev | cut -d"." -f1)
/usr/bin/time -v git clone --recursive $link 2> $soft.err

controller $soft.err
fi

done < $file

telegram-send "$time" "LICO report" "Pipeline $pipeline:" "$var_sms"

cd ..

# rm -fr $rundir/$pipeline $rundir/nohup.out
