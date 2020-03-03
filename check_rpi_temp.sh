#!/bin/bash
#FOR NAGIOS, ADD:"/bin/chmod u+s /opt/vc/bin/vcgencmd" TO /etc/rc.local (last line must be exit 0)
SHUT_HIGH_TEMP=70
SHUT_MIN_TEMP=5
CRIT_HIGH_TEMP=67
CRIT_MIN_TEMP=10
WARNING_HIGH_TEMP=58
WARNING_MIN_TEMP=10
CPU_TEMP=`/opt/vc/bin/vcgencmd measure_temp`
CPU_TEMP=${CPU_TEMP:5:-4}

function checkcommandexists ()
 {
 if which $1 >/dev/null; then
  COMMANDFOUND=1
 else
  echo "CRITICAL - Command $1 is missing"
  exit 2
 fi
 }

checkcommandexists vcgencmd

if [ "$CPU_TEMP" -gt "$WARNING_MIN_TEMP" ] && [ "$CPU_TEMP" -lt "$WARNING_HIGH_TEMP" ];
 then
  echo "OK - Core is $CPU_TEMP Celsius"
  exit 0
fi

if [ "$CPU_TEMP" -lt "$SHUT_MIN_TEMP" ] || [ "$CPU_TEMP" -ge "$SHUT_HIGH_TEMP" ];
 then
  echo "CRITICAL - SHUTING DOWN - Core is $CPU_TEMP Celsius"
  /sbin/shutdown -hP -t 2
  exit 2
fi

if [ "$CPU_TEMP" -le "$CRIT_MIN_TEMP" ] || [ "$CPU_TEMP" -ge "$CRIT_HIGH_TEMP" ];
 then
  echo "CRITICAL - Core is $CPU_TEMP Celsius"
  exit 2
 else
  echo "WARNING - Core is $CPU_TEMP Celsius"
 exit 1
fi

echo "UNKNOWN - Script Internal problem"
exit 3

