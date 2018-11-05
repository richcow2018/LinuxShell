
#!/bin/bash
## script for restart the tomcat8090 and jstack and jmap
## edited by Jimmy @ 24Apr2018

## declare the present date and time
fulltime=$(date +"%Y%m%d-%H%M%S")
today=$(date +"%Y%m%d")

##declare the path of script
SCRIPT_PATH="/etc/init.d/tomcat_8090"

## store the first argument into variable
jmapSwitch=$1

for whoisit in `who am i | awk '{print $1}'` ; do echo "program started"
done

echo "Start === <$whoisit> triggered tomcat8090 ProC restart ===  $today " >> /usr/local/tomcat_8090/logs/memory-dump/tomcat8090-restart-$today.log

## getting the process id of tomcat8090
for PID in `ps -ef | grep tomcat_8090 | grep Djava | awk '{print $2}'`; do
  ## if PID is great than Zero
  if [ -n "$PID" ] ; then

    ## execute the jstack
    echo "Start JSTACK  $fulltime " >> /usr/local/tomcat_8090/logs/memory-dump/tomcat8090-restart-$today.log
    jstack -F $PID > /usr/local/tomcat_8090/logs/memory-dump/pid.thread-8090ProC-$fulltime.txt

    ## execute the jmap
    ## if jmap argument is input, below statment will be processed
    if [ $switch == '/jamp' ] || [ $switch == '-jmap' ]; then
      echo "Start JMAP  $fulltime " >> /usr/local/tomcat_8090/logs/memory-dump/tomcat8090-restart-$today.log
      jmap -F -dump:file=/usr/local/tomcat_8090/logs/memory-dump/mem-8090ProC-$fulltime.hprof $PID
    fi

    ## restart tomcat8090
    echo "Start TOMCAT8090 RESTART  $fulltime " >> /usr/local/tomcat_8090/logs/memory-dump/tomcat8090-restart-$today.log
   ## ./tomcat_8090 "restart"
   ##  bash "$SCRIPT_PATH" restart
    . "$SCRIPT_PATH" restart

    ## exti the loop
    break
  fi
done

echo "program ended"

echo "End === <$whoisit> triggered tomcat8090 ProC restart ===  $today \n" >> /usr/local/tomcat_8090/logs/memory-dump/tomcat8090-restart-$today.log
