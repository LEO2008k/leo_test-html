#!/bin/bash
yum -y update
yum -y install mc vim net-tools wget git httpd 
echo "---------start httpd and add html page -------------"
privateip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<html><body bgcolor=black><center><h1><p><font color=red> Levko  web server with private ip $privateip</h1></center></body></html>" > /var/www/html/index.html
systemctl enable --now httpd
echo "UserData executed on $(date)" >>/var/www/html/log.txt
echo "_________finish_install_____________"
printf "%0.s="{1..35}; echo "configure SE_Linux"; printf "%0.s="{1..35};
yum -y install -y policycoreutils-python
yum -y install -y setroubleshoot
#Create a policy to assign the httpd_sys_content_t context to the /webapps directory, and all child directories and files.
semanage fcontext -a -t httpd_sys_content_t '/var/www/html/(/.*)?'

#Create a policy to assign the httpd_log_t context to the logging directories.
##exec semanage fcontext -a -t httpd_log_t "/webapps/logs(/.*)?"

#Create a policy to assign the httpd_cache_t context to our cache directories.

## semanage fcontext -a -t httpd_cache_t "/webapps/cache(/.*)?"

restorecon -Rv /var/www/html/
printf "%0.s="{1..35}; echo "configure firewall"; printf "%0.s="{1..35};

sudo firewall-cmd --zone=public --permanent --add-service=http

firewall-cmd --reload

printf "%0.s=" {1..35}; echo "firewall configured complete"; printf "%0.s=" {1..35};