#!/usr/bin/env bash

# -------------------------------------------------------
# This script is under MIT License
# Written by: @TurhanOz
# Last updated on: 2020/05/10
# -------------------------------------------------------

echo "---------------------------------------------------------"
echo "Website configuration: "
read -p 'project name: ' project_name

while [[ -z $website_type ]] || [[ $website_type > 0 ]]
do
    read -p 'which website do you want [0. prestashop]: ' website_type
done
read -p 'domain.tld: ' domain
read -p 'port (be carefull to not select an existing one): ' port
read -p 'email: ' email


case $website_type in
  0)
    folder=prestashop_template
    ;;

  *)
    echo -n "unknown"
    ;;
esac

echo "---------------------------------------------------------"
echo "generating new ${domain} folder & subfolders"
## copy new website
cp -r $folder $domain
mkdir $domain/volumes/database
mkdir $domain/volumes/prestashop


## replace in docker-compose.yml
app_container_name="${project_name}-app-container"
database_container_name="${project_name}-database-container"
network_name="${project_name}-network"
main_docker_compose="${domain}/docker-compose.yml"
app_docker_file="${domain}/app/Dockerfile"
database_docker_file="${domain}/database/Dockerfile"


echo "---------------------------------------------------------"
echo "generating database/Dockerfile"
## replace in database Dockerfile
database_password=`strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo`
sed -i.bak "s/{database_password}/$database_password/g" "${database_docker_file}" && rm "${database_docker_file}.bak"
cat ${domain}/database/Dockerfile
echo "done"


echo "---------------------------------------------------------"
echo "generating docker-compose"

sed -i.bak "s/{app_container_name}/$app_container_name/g" "${main_docker_compose}" && rm "${main_docker_compose}.bak"
sed -i.bak "s/{database_container_name}/$database_container_name/g" "${main_docker_compose}" && rm "${main_docker_compose}.bak"
sed -i.bak "s/{domain}/$domain/g" "${main_docker_compose}" && rm "${main_docker_compose}.bak"
sed -i.bak "s/{port}/$port/g" "${main_docker_compose}" && rm "${main_docker_compose}.bak"
sed -i.bak "s/{email}/$email/g" "${main_docker_compose}" && rm "${main_docker_compose}.bak"
sed -i.bak "s/{network}/$network_name/g" "${main_docker_compose}" && rm "${main_docker_compose}.bak"
echo "done"

echo "---------------------------------------------------------"
echo "generating app/Dockerfile"
## replace in app Dockerfile
sed -i.bak "s/{port}/$port/g" "${app_docker_file}" && rm "${app_docker_file}.bak"
sed -i.bak "s/{database_password}/$database_password/g" "${app_docker_file}" && rm "${app_docker_file}.bak"
sed -i.bak "s/{database_container_name}/$database_container_name/g" "${app_docker_file}" && rm "${app_docker_file}.bak"
echo "done"

echo "--------------------------------------------------------'"
echo "installing ${project_name}"
cd $domain
docker-compose up -d
echo "done"

echo "---------------------------------------------------------"
echo "your database password is"
echo $database_password
echo "keep it safe"
echo "---------------------------------------------------------"
echo "## Prestashop Installation Procedure"
echo "go to ${domain} to start the installation of your website (the page might take some time to load the first time as a certificate is being generated & website is put inche"
echo "at the installation, the database server is ${database_container_name} and the root password is ${database_password}"
echo "---------------------------------------------------------"
echo "## Prestashop Admin & SSL configuration Procedure"
echo "once installation is complete"
echo "1. remove the folder in ${domain}/volumes/prestashop/install"
echo "2. rename the folder ${domain}/volumes/prestashop/admin into name you want. That will be the url to the admin panel"
echo "3. execute the following command from the host:"
echo "docker exec -i ${database_container_name} mysql -uroot -p${database_password}  <<< \"use prestashop; UPDATE ps_configuration SET value='1' WHERE name='PS_SSL_ENABLED';\""
echo "4. connect to ${domain}/[admin]/ and go to admin panel/general parameters to activate ssl on all pages as documented here : http://doc.prestashop.com/display/PS17/General+parameters"
echo "---------------------------------------------------------"
echo "## Prestashop Speed"
echo "the first time you launch the Admin panel or even the website, prestashop is very low. This is due to the fact that caching happens the first time. The subsequent loads will be quicker"
echo "done"



