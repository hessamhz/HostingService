#!/bin/bash



if [ "$(/bin/bash ./check_user_exists.sh $2)" != "NO" ]; 
then

	echo -e $"This User already exists.\nPlease Try Another one"
	exit;
else 

	adduser $2 -m 
	echo -e "$3\n$3" | passwd $2
	usermod -aG users $2
	usermod -aG sudo $2
	setquota -u $2 1 $5 0 0 /
	setquota -u $2 -T 60 60 /
	domain=$1
	email=$4
	sitesEnabled='/etc/httpd/sites-enabled/'
	sitesAvailable='/etc/httpd/sites-available/'
	userDir='/var/www/'
	sitesAvailabledomain=$sitesAvailable$domain.conf
fi



if [ "$(whoami)" != 'root' ]; 
then
	echo $"You have no permission to run $0 as on-root user. Use sudo"
	exit 1;
fi


while [ "$domain" == "" ]
do
	echo -e $"Please provide domain. e.g.dev,staging"
	read domain
done


rootDir=$userDir$1



if [ -e $sitesAvailabledomain ]; then
	echo -e $"This domain already exists.\nPlease Try Another one"
	exit;
fi


if ! [ -d $rootDir ]; then

	mkdir $rootDir
	chown -R $2:users $rootDir
	chmod -R 755 $rootDir

	if ! echo "<?php echo phpinfo(); ?>" > $rootDir/phpinfo.php
	then
		echo $"ERROR: Not able to write in file $rootDir/phpinfo.php. Please check permissions"
		exit;
	else
		echo $"Added content to $rootDir/phpinfo.php"
	fi
fi


echo "($2:$1)" >> /home/user_domain
echo "($2:$3)" >> /home/user_passwd
echo "($2:$4)" >> /home/user_email
echo "($2:$5)" >> /home/user_volume


if ! echo "
<VirtualHost *:80>
	ServerAdmin $email
	ServerName $domain
	ServerAlias $domain
	DocumentRoot $rootDir
	<Directory $rootDir>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride all
		Require all granted
	</Directory>

</VirtualHost>" > $sitesAvailabledomain

then
	echo -e $"There is an ERROR creating $domain file"
	exit;
else
	ln -s $sitesAvailable$domain.conf $sitesEnabled
	touch $rootDir/index.html
	echo "
		<html>

		  <head>

		    <title>Welcome to $1!</title>

		  </head>

		  <body>

		    <h1>Success! The $1 virtual host is working for $2!</h1>

		  </body>

		</html>" > $rootDir/index.html
	echo -e $"\nNew Virtual Host Created on http protocol\n"
fi




if ! echo "127.0.0.1	$domain" >> /etc/hosts
then
	echo $"ERROR: Not able to write in /etc/hosts"
	exit;
else
	echo -e $"Host added to /etc/hosts file \n"
fi

mkdir /home/$2/ftp
chmod a-w /home/$2/ftp
chown $2:users /home/$2/ftp
#chmod 755 /home/$2/ftp
mkdir /home/$2/ftp/files
chown $2:users /home/$2/ftp/files

if ! echo "$2" | sudo tee -a /etc/vsftpd/user_list
then
	echo $"ERROR: Not able to write in /etc/vsftpd/user_list"
	exit;
else
	echo -e $"user added to /etc/vsftpd.userlist ftp access \n"
	echo "test for $2 ftp account" > /home/$2/ftp/files/test.txt
fi


iam=$(whoami)
if [ "$iam" == "root" ]; then
	chown -R $2:users $rootDir
else
	chown -R $iam:users $rootDir
fi

echo "alias newal='/home/mahya/HostingServie/Scripts/new_alias.sh'

alias removeal='/home/mahya/HostingServie/Scripts/remove_alias.sh'

alias edital='/home/mahya/HostingServie/Scripts/edit_alias.sh'

alias passwordch='/home/mahya/HostingServie/Scripts/change_password.sh" >> /home/$2/.bashrc


systemctl restart httpd
systemctl restart vsftpd


echo -e $"Complete! \nYou now have a new Virtual Host \nYour new host is: http://$domain \nAnd its located at $rootDir"
exit;

