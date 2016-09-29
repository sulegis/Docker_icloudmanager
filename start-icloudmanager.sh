#!/bin/bash

die() {
  echo "ERROR: $1"
  exit 2
}

PATH_database_properties=$ICM_CONFIG_PATH/database.properties
PATH_icloud_properties=$ICM_CONFIG_PATH/icloud.properties
PATH_zabbix_properties=$ICM_CONFIG_PATH/zabbix.properties
PATH_email_properties=$ICM_CONFIG_PATH/email.properties

# deal database.properties
[[ -z "$DB_TYPE" ]] && DB_TYPE="sqlite"
[[ -z "$DB_URL" ]] && DB_URL="jdbc:sqlite:\${cloudmgnConfigPath}/database.db"
[[ -z "$DB_USER" ]] && DB_USER="icloud"
[[ -z "$DB_PASSWORD" ]] && DB_PASSWORD="icloud"
[[ -z "$DB_MAXPOOLSIZE" ]] && DB_MAXPOOLSIZE=1
[[ -z "$DB_INITIALPOOLSIZE" ]] && DB_INITIALPOOLSIZE=1
[[ -z "$DB_MINPOOLSIZE" ]] && DB_MINPOOLSIZE=1
[[ -z "$DB_MAXIDLETIME" ]] && DB_MAXIDLETIME=3000
[[ -z "$DB_CHECKOUTTIMEOUT" ]] && DB_CHECKOUTTIMEOUT=0

echo "database_type=$DB_TYPE" > $PATH_database_properties
echo "jdbcUrl=$DB_URL" >> $PATH_database_properties
echo "database_user=$DB_USER" >> $PATH_database_properties
echo "database_password=$DB_PASSWORD" >> $PATH_database_properties
echo "maxPoolSize=$DB_MAXPOOLSIZE" >> $PATH_database_properties
echo "initialPoolSize=$DB_INITIALPOOLSIZE" >> $PATH_database_properties
echo "minPoolSize=$DB_MINPOOLSIZE" >> $PATH_database_properties
echo "maxIdleTime=$DB_MAXIDLETIME" >> $PATH_database_properties
echo "checkoutTimeout=$DB_CHECKOUTTIMEOUT" >> $PATH_database_properties


# deal icloud.properties
[[ -z "$PLATFORMTYPE" ]] && PLATFORMTYPE="DOCKER"
[[ -z "$DOCKER_SERVERIP" ]] && DOCKER_SERVERIP="127.0.0.1"
[[ -z "$DOCKER_SERVERPORT" ]] && DOCKER_SERVERPORT="2375"
[[ -z "$DOCKER_PROTOCOL" ]] && DOCKER_PROTOCOL="tcp"
[[ -z "$DOCKER_API_VERSION" ]] && DOCKER_API_VERSION="1.22"

echo "docker_protocol=$DOCKER_PROTOCOL" > $PATH_icloud_properties
echo "platformType=$PLATFORMTYPE" >> $PATH_icloud_properties
echo "docker_serverPort=$DOCKER_SERVERPORT" >> $PATH_icloud_properties
echo "docker_serverIP=$DOCKER_SERVERIP" >> $PATH_icloud_properties
echo "docker_api_version=$DOCKER_API_VERSION" >> $PATH_icloud_properties

# deal zabbix.properties
[[ -z "$ZABBIX_URI" ]] && die "Missing environment variable: ZABBIX_URI = http://**/*/api_jsonrpc.php"
[[ -z "$ZABBIX_USERNAME" ]] && die "Missing environment variable: ZABBIX_USERNAME = username"
[[ -z "$ZABBIX_PASSWORD" ]] && die "Missing environment variable: ZABBIX_PASSWORD = password"

echo "zabbix_uri=$ZABBIX_URI" > $PATH_zabbix_properties
echo "zabbix_userName=$ZABBIX_USERNAME" >> $PATH_zabbix_properties
echo "zabbix_password=$(printf $ZABBIX_PASSWORD | base64)" >> $PATH_zabbix_properties

# deal email.properties

echo "emailSettings.fromEmail=$EMAILSETTINGS_FROMEMAIL" > $PATH_email_properties
echo "emailSettings.password=$EMAILSETTINGS_PASSWORD" >> $PATH_email_properties
echo "emailSettings.hostName=$EMAILSETTINGS_HOSTNAME" >> $PATH_email_properties
echo "emailSettings.smtpPort=$EMAILSETTINGS_SMTPPROT" >> $PATH_email_properties
echo "emailSettings.toEmail=$EMAILSETTINGS_TOEMAIL" >> $PATH_email_properties
echo "emailSettings.userName=$EMAILSETTINGS_USERNAME" >> $PATH_email_properties
echo "emailSettings.secureConnection=$EMAILSETTINGS_SECURECONNECTION" >> $PATH_email_properties
echo "emailSettings.fromUserName=$EMAILSETTINGS_FROMUSERNAME" >> $PATH_email_properties

# initCloudMgn
[[ -z "$ICM_HOME" ]] && ICM_HOME="/etc/icloud/SuperMapiCloudManager/webapps/icloud"
[[ -z "$ADMIN_USERNAME" ]] && ADMIN_USERNAME="admin"
[[ -z "$ADMIN_PASSWORD" ]] && ADMIN_PASSWORD="supermap"
[[ -z "$TEMPLATE_ISERVER" ]] && TEMPLATE_ISERVER="supermap/iserver"
[[ -z "$TEMPLATE_IPORTAL" ]] && TEMPLATE_IPORTAL="supermap/iportal"
[[ -z "$TEMPLATE_DESKTOP" ]] && TEMPLATE_DESKTOP="supermap/idesktop-cross"
[[ -z "$TEMPLATE_NGINX" ]] && TEMPLATE_NGINX=""

/etc/icloud/SuperMapiCloudManager/support/jre/bin/java -classpath /etc/icloud/SuperMapiCloudManager/webapps/icloud/WEB-INF/lib/*: com.supermap.icloud.init.CloudMgnInit -home $ICM_HOME -cloudmgnConfigPath $ICM_CONFIG_PATH -userName $ADMIN_USERNAME -password $ADMIN_PASSWORD -iserverTemplate $TEMPLATE_ISERVER -iportalTemplate $TEMPLATE_IPORTAL -desktopTemplate $TEMPLATE_DESKTOP -nginxTemplate $TEMPLATE_NGINX

# start icloudmanager
cd /etc/icloud/aksusbd
./dunst
./dinst
cd /etc/icloud/SuperMapiCloudManager/bin
./catalina.sh run
