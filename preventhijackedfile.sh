/* Prevent Prestashop files get hacked, hijacked and edited */
/* First copy the multiple folders which are clean without any Malware, hijacked and trojan Files. */
/* You can download a new installation file, make a backup and put it into your current Prestashop folder. */
/* create a crontab */30 * * * * preventhijackedfile.sh */

#!/bin/bash
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin

DATE=`date +"%m_%d_%Y_%H-%M"`
BACKUP_DIR=/home/username/www/foldername/public_html

echo -e  "\n==========  $DATE  START ==========" 

echo -e  "\n===  Class diff  ====" 

diff_result="$(diff -qr ${BACKUP_DIR}/original/classes ${BACKUP_DIR}/classes)"
exit_code="$?"
echo -e "\n exit code: ${exit_code}" 

if [ ${exit_code} -eq 1 ]
then
  echo -e  "\n Class is diff & Rsync !" 
  rsync -avz ${BACKUP_DIR}/original/classes/ ${BACKUP_DIR}/classes/  
elif [ ${exit_code} -eq 0 ]
then
  echo -e  "\n Class is no diff !" 
fi

echo -e  "\n===  admin diff  ====" 

diff_result="$(diff -qr --exclude=php_errorlog ${BACKUP_DIR}/original/admin ${BACKUP_DIR}/admin)"
exit_code="$?"
echo -e "\n exit code: ${exit_code}" 

if [ ${exit_code} -eq 1 ]
then
  echo -e "\n admin diff & Rsync !"
  rsync -avz --exclude 'php_errorlog' ${BACKUP_DIR}/original/admin/ ${BACKUP_DIR}/admin/  
elif [ ${exit_code} -eq 0 ]
then
  echo -e "\n admin no diff !"
fi

echo -e  "\n===  controllers diff  ====" 

diff_result="$(diff -qr ${BACKUP_DIR}/original/controllers ${BACKUP_DIR}/controllers)"
exit_code="$?"
echo -e "\n exit code: ${exit_code}"

if [ ${exit_code} -eq 1 ]
then
  echo -e "\n controllers diff & Rsync !"
  rsync -avz ${BACKUP_DIR}/original/controllers/ ${BACKUP_DIR}/controllers/  
elif [ ${exit_code} -eq 0 ]
then
  echo -e "\n controllers no diff !"
fi

echo -e  "\n===  js diff  ====" 

diff_result="$(diff -qr ${BACKUP_DIR}/original/js ${BACKUP_DIR}/js)"
exit_code="$?"
echo -e "\n exit code: ${exit_code}"

if [ ${exit_code} -eq 1 ]
then
  echo -e "\n js diff & Rsync !"
  rsync -avz --delete ${BACKUP_DIR}/original/js/ ${BACKUP_DIR}/js/
elif [ ${exit_code} -eq 0 ]
then
  echo -e "\n js no diff !"
fi

echo -e  "\n===  override diff  ====" 

diff_result="$(diff -qr ${BACKUP_DIR}/original/override ${BACKUP_DIR}/override)"
exit_code="$?"
echo -e "\n exit code: ${exit_code}"

if [ ${exit_code} -eq 1 ]
then
  echo -e "\n override diff & Rsync !"
  rsync -avz ${BACKUP_DIR}/original/override/ ${BACKUP_DIR}/override/  
elif [ ${exit_code} -eq 0 ]
then
  echo -e "\n override no diff !"
fi

echo -e  "\n===  bin diff  ====" 

diff_result="$(diff -qr ${BACKUP_DIR}/original/bin ${BACKUP_DIR}/bin)"
exit_code="$?"
echo -e "\n exit code: ${exit_code}"

if [ ${exit_code} -eq 1 ]
then
  echo -e "\n bin diff & Rsync !"
  rsync -avz ${BACKUP_DIR}/original/bin/ ${BACKUP_DIR}/bin/  
elif [ ${exit_code} -eq 0 ]
then
  echo -e "\n bin no diff !"
fi

echo -e  "==========  $DATE  END ==========\n"
