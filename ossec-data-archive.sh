#!/bin/bash
# Thiss program is to archive the ossec mysql data older than 7 days and save it in /var/ossec/data-archive/
# 1 Dec 2017 created by Jimmy Chu

## stop ossec server service
/var/ossec/bin/ossec-control stop

## define the cut off date
CutOffDate=$(date -d '7 days ago' +%Y-%m-%d)

## Archive [ALERT] and [DATA] tables older than 7 days

echo "====  mysqldump Start  =====" >> /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT_recordcount-error").log
mysqldump --user=username -ppassword ossec alert --log-error="/var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT_recordcount-error").log" --where="timestamp < UNIX_TIMESTAMP(date_sub(CURDATE(), interval 7 day))" > /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT").sql
echo "====  mysqldump End  =====" >> /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT_recordcount-error").log


## Table [data] is no longer exist after upgrade to ossec 2.9.2
# mysqldump --user=username -ppassword ossec data --log-error="/var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_DATA_recordcount-error").log" --where="timestamp < date_sub(CURDATE(), interval 7 day)" > /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_DATA").sql

sleep 1m

## Counting [ALERT] and [DATA] number of records are older than 7 days
echo "====  record count Start  =====" >> /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT_recordcount-error").log
mysql -h localhost -u username -ppassword ossec -e "select count(timestamp) from alert where timestamp < UNIX_TIMESTAMP(date_sub(NOW(), interval 7 day)); " >> /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT_recordcount-error").log
echo "====  record count End  =====" >> /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT_recordcount-error").log

## Table [data] is no longer exist after upgrade to ossec 2.9.2
# mysql -h localhost -u username -ppassword ossec -e "select count(timestamp) from data where timestamp < date_sub(CURDATE(), interval 7 day); " >> /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_DATA_recordcount-error").log

## Delete [ALERT] and [DATA] tables older than 7 days. Due to exceeded locked table issu, it needs to divide into 4 time period
echo "====  Delete Start  =====" >> /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT_recordcount-error").log
## mysql -h localhost -u username -ppassword ossec -e "DELETE FROM alert where timestamp < UNIX_TIMESTAMP(date_sub(NOW(), interval 7 day));" >> /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT_recordcount-error").log

mysql -h localhost -u username -ppassword ossec -Ae "DELETE FROM alert where timestamp between UNIX_TIMESTAMP('$CutOffDate 00:00:01') and UNIX_TIMESTAMP('$CutOffDate 05:59:59'); select row_count()" >> /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT_recordcount-error").log
mysql -h localhost -u username -ppassword ossec -Ae "DELETE FROM alert where timestamp between UNIX_TIMESTAMP('$CutOffDate 00:00:01') and UNIX_TIMESTAMP('$CutOffDate 11:59:59'); select row_count()" >> /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT_recordcount-error").log
mysql -h localhost -u username -ppassword ossec -Ae "DELETE FROM alert where timestamp between UNIX_TIMESTAMP('$CutOffDate 00:00:01') and UNIX_TIMESTAMP('$CutOffDate 15:59:59'); select row_count()" >> /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT_recordcount-error").log
mysql -h localhost -u username -ppassword ossec -Ae "DELETE FROM alert where timestamp between UNIX_TIMESTAMP('$CutOffDate 00:00:01') and UNIX_TIMESTAMP('$CutOffDate 23:59:59'); select row_count()" >> /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT_recordcount-error").log

echo "====  Delete end  =====" >> /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT_recordcount-error").log

## Table [data] is no longer exist after upgrade to ossec 2.9.2
# mysql -h localhost -u username -ppassword ossec -e "DELETE FROM data where timestamp < date_sub(CURDATE(), interval 7 day);" >> /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_DATA_recordcount-error").log

sleep 1m

## Compress [ALERT] and [DATA] archive data

xz -9 /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_ALERT").sql

## Table [data] is no longer exist after upgrade to ossec 2.9.2
# xz -9 /var/ossec/data-archive/$(date  --date="7 days ago" "+%Y-%m-%d_ossec_DATA").sql

## optimize the alert table
mysql -h localhost -u username -ppassword ossec -e "alter table alert ENGINE INNODB;"
#mysql -h localhost -u username -ppassword ossec -e "optimize table alert;"

# sleep 2m

## start the ossec service
 /var/ossec/bin/ossec-control start
