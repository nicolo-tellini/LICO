#!/bin/bash

while getopts "l:p:n:h" arg; do
  case $arg in
    h) echo "(^０^)ノ Hi! "
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
  var_sms="${var_sms}${soft}:EXIT;\n"
  else
  var_sms="${var_sms}${soft}:OK;\n"
  fi
  }

# The code for the prgressbar was proposed by the user fearside in StackOverflow :
# https://stackoverflow.com/questions/238073/how-to-add-a-progress-bar-to-a-shell-script
function ProgressBar {
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
printf "\rProgress : ${_fill// /▇}${_empty// /} ${_progress}%%"
}

_start=1
_end=$(wc -l $file | cut -d " " -f1)

i=1
while read -r link;
do

 ProgressBar ${i} ${_end}

 githubrepo=$(echo $link | grep "github.com" | grep ".git$")


  if [ -z "$githubrepo" ]
  then
  # HTTP link
  soft=$(echo $link | rev | cut -d"/" -f1 | rev)
  /usr/bin/time -v wget $link > /dev/null 2> $soft.err
  controller $soft.err $soft
  else
  # GitHub link
  soft=$(echo $link | rev | cut -d"/" -f1 | rev | cut -d"." -f1)
  /usr/bin/time -v git clone --recursive $link > /dev/null 2> $soft.err
  controller $soft.err $soft
  fi
i=$(($i +1))
done < $rundir/$pipeline/$file

var_sms=$(echo "${var_sms/%; /.}")

echo -e "\n The run is over.\n" "Here the output:\n\n" "$var_sms\n" "Please, remind to delete the directory $rundir/$pipeline to avoid Exit 128 : directory exists at the next run.\n" "Thank you for using LICO.\n"
