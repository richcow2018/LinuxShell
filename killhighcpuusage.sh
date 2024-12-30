// monitor the cpu usage of processes. if it is over certain percentage, kill it or restart the service.

#!/bin/bash
pid=$(ps -eo %cpu,pid,user,command --sort -%cpu | head -n 2 | awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $6}')
echo -e  "\n==========  $(date +%F_%T) Monitor High CPU Usage START ==========" 
#echo "result0 = " $pid
if [[ -n $pid ]]; then
    kcpu=$(echo $pid | awk '{print $5}')
    kpid=$(echo $pid | awk '{print $6}')
    kuser=$(echo $pid | awk '{print $7}')
    kcom=$(echo $pid | awk '{print $8 " " $9 " " $10}')
    ift=$(echo "200"'<'$kcpu | bc -l)
 #   echo "result1 = " $kcpu
 #   echo "result2 = " $kpid
 #   echo "result3 = " $kuser
 #   echo "result4 = " $kcom
    if [ $ift -eq "1" ] && [ $kuser = "mysql" ]; then
        echo "It is going to restart the SQL/Apache server"
        echo $pid
        systemctl restart service   //you restart the service 
        #kill $kpid                 //or kill the process directly
    fi
else
  echo "no process is exist"
fi
echo -e  "\n==========  $(date +%F_%T) Monitor High CPU Usage END  ==========" 
