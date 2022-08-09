#!/bin/bash

file=$1
rundir=$2
pipeline=$3

# enter rundir

cd $rundir

# make pipeline dir
mkdir -p $pipeline
cp -r $file $pipeline
cd $pipeline

# Date
time=$(date)

controller () {
 exfile=$1
 soft=$2
 con=$(grep -w Exit $exfile | cut -d":" -f2 | tr -d "[:blank:]")
  if [ $con != 0 ]
  then
  var_sms="${var_sms}${soft}:Exit;___"

  else
  var_sms="${var_sms}${soft}:Ok;___"
  fi
  }

var_sms=""
while read -r link;
do
 githubrepo=$(echo $link | grep "github.com" | grep ".git$")
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
done < $rundir/$pipeline/$file

var_sms=$(echo "${var_sms/%;___/.}")

telcom=$(whereis telegram-send | cut -d":" -f2 | tr -d [:blank:])

$telcom "$time" "LICO report" "Pipeline: $pipeline" "${var_sms}" "The run is over. Thank you for using LICO." "Please, remind to delete the directory $rundir/$pipeline to avoid Exit 128 : directory exists at the next run."
