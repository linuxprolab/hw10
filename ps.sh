#!/bin/bash
echo PID USER STATE CMDLINE
procs=$(ls /proc/ | grep [0-9] | sort -n)
for proc in $procs
do
  PID=${proc}
  if [[ -f /proc/${proc}/status  ]]
  then
    USERID=$(grep Uid /proc/${proc}/status | cut -f 2)
  if [[ USERID -eq 0  ]]
  then
    USER='root'
  else
    USER=$(grep ${USERID} /etc/passwd | cut -d ":" -f 1)
  fi
  STATE=$(grep State /proc/${proc}/status | cut -f 2 | cut -d " " -f 1)
  CMDLINE=$(cat /proc/${proc}/cmdline)
  if [[ -z $CMDLINE  ]]
  then
    CMDLINE=$(grep Name /proc/${proc}/status | cut -f 2)
  else
    CMDLINE=$(cat /proc/${proc}/cmdline | tr '\0' ' ')
  fi
  echo $PID $USER $STATE $CMDLINE
  fi
done

