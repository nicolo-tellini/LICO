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

controller () {
 exfile=$1
 soft=$2
 con=$(grep -w Exit $exfile | cut -d":" -f2 | tr -d "[:blank:]")
  if [ $con != 0 ]
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
  controller $soft.err $soft
  else
  # GitHub link
  soft=$(echo $link | rev | cut -d"/" -f1 | rev | cut -d"." -f1)
  /usr/bin/time -v git clone --recursive $link 2> $soft.err
  controller $soft.err $soft
  fi
done < $file

telegram-send "$time" "LICO report" "Pipeline $pipeline:" "$var_sms"

cd ..

# rm -fr $rundir/$pipeline $rundir/nohup.out
