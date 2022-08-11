#!/bin/bash

while getopts "l:p:n:h" arg; do
  case $arg in
    h) echo " Hi! (^０^)ノ "
       echo ""
       echo "monitor usage:"
       echo ""
       echo "monitor.sh -l <file.txt> -p <rundir> -n <pipeline>"
       echo ""
       echo "<file.txt>: a txt file with the GitHub/HTTP links (one link per line);"
       echo ""
       echo "<rundir>: path to /favorite/dir where <file.txt> is stored;"
       echo ""
       echo "<pipeline>: the name of your pipeline (to send you a meaningful report)."
       echo ""
       exit 0
       ;;
    n) pipeline=$OPTARG;;
    l) file=$OPTARG;;
    p) rundir=$OPTARG;;
  esac
done
echo "";

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
  var_sms="${var_sms}${soft}:EXIT; "

  else
  var_sms="${var_sms}${soft}:OK; "
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

var_sms=$(echo "${var_sms/%; /.}")

telcom=$(whereis telegram-send | cut -d":" -f2 | tr -d [:blank:])

$telcom "$time" "LICO report" "Pipeline: $pipeline" "${var_sms}" "The run is over." "Please, remind to delete the directory $rundir/$pipeline to avoid Exit 128 : directory exists at the next run." "Thank you for using LICO. ( ´ ω ` )ノﾞ	"
