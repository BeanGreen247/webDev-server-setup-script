# links
# http://10.10.0.124:8080/phpMyAdmin/phpMyAdmin

pass="dev"
username="dev"
stringLogDir='${APACHE_LOG_DIR}'

function quit {
    echo -e "Script created by \e[1;32mBeanGreen247\e[1;0m \e[1;31mhttps://github.com/BeanGreen247 \e[1;0m\n"
    echo "Please reboot..."
    exit 1
}

function main {
    echo $pass | sudo -S rm -rf phpMyAdmin-* phpmyadmin.keyring /var/www/html/phpMyAdmin temp*.txt
    wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip.asc
    gpg --verify phpMyAdmin-5.2.1-all-languages.zip.asc
    gpg --update-trustdb
    wget https://files.phpmyadmin.net/phpmyadmin.keyring
    gpg --import phpmyadmin.keyring
    gpg --update-trustdb
    wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.tar.gz
    echo $pass | sudo -S mkdir /var/www/html/phpMyAdmin
    echo $pass | sudo -S tar xvf phpMyAdmin-5.2.1-all-languages.tar.gz --strip-components=1 -C /var/www/html/phpMyAdmin
    echo $pass | sudo -S cp /var/www/html/phpMyAdmin/config.sample.inc.php /var/www/html/phpMyAdmin/config.inc.php
    echo "Open /var/www/html/phpMyAdmin/config.inc.php using nano as root and fill in the line here $cfg['blowfish_secret'] = ''; with $cfg['blowfish_secret'] = '$username';"
    echo "then save and exit..."
    echo "Once done press any key..."
    read -rsn1 inputTemp
    echo $pass | sudo -S chown -Rfv www-data:www-data /opt/phpMyAdmin #may not be needed

    echo $pass | sudo -S echo -e "<?php\nphpinfo();" >temp.txt
    echo $pass | sudo -S mv temp.txt /var/www/html/info.php

    echo $pass | sudo -S systemctl enable apache2 vsftpd
    echo $pass | sudo -S systemctl restart apache2

    echo $pass | sudo -S echo "<VirtualHost *:9000>" >temp.txt
    echo $pass | sudo -S echo "ServerAdmin $username@localhost" >>temp.txt
    echo $pass | sudo -S echo -e "DocumentRoot /var/www/html/phpMyAdmin\n" >>temp.txt
    echo $pass | sudo -S echo "<Directory /var/www/html/phpMyAdmin>" >>temp.txt
    echo $pass | sudo -S echo "Options Indexes FollowSymLinks" >>temp.txt
    echo $pass | sudo -S echo "AllowOverride none" >>temp.txt
    echo $pass | sudo -S echo "Require all granted" >>temp.txt
    echo $pass | sudo -S echo "</Directory>" >>temp.txt
    echo $pass | sudo -S echo "ErrorLog "$stringLogDir"/error_phpmyadmin.log" >>temp.txt
    echo $pass | sudo -S echo "CustomLog "$stringLogDir"/access_phpmyadmin.log combined" >>temp.txt
    echo $pass | sudo -S echo "</VirtualHost>" >>temp.txt

    echo $pass | sudo -S mv temp.txt /etc/apache2/sites-available/phpmyadmin.conf

    echo $pass | sudo -S sudo systemctl restart apache2

    echo $pass | sudo -S cp -r /etc/vsftpd.conf /etc/vsftpd.conf.bak
    echo $pass | sudo -S echo "local_enable=YES" >temp.txt
    echo $pass | sudo -S echo "listen=YES" >>temp.txt
    echo $pass | sudo -S echo "#listen_ipv6=NO" >>temp.txt
    echo $pass | sudo -S echo "write_enable=YES" >>temp.txt
    echo $pass | sudo -S echo "listen_port=21" >>temp.txt
    echo $pass | sudo -S echo "chroot_local_user=YES" >>temp.txt
    echo $pass | sudo -S echo "chroot_list_enable=YES" >>temp.txt
    echo $pass | sudo -S echo "chroot_list_file=/etc/vsftpd.chroot_list" >>temp.txt
    echo $pass | sudo -S echo "secure_chroot_dir=/var/run/vsftpd/empty" >>temp.txt
    echo $pass | sudo -S echo "pam_service_name=vsftpd" >>temp.txt
    echo $pass | sudo -S echo "rsa_cert_file=/etc/ssl/private/vsftpd.pem" >>temp.txt

    echo $pass | sudo -S echo "$username" >temp1.txt

    echo $pass | sudo -S mv temp.txt /etc/vsftpd.conf
    echo $pass | sudo -S mv temp1.txt /etc/vsftpd.chroot_list

    echo $pass | sudo -S systemctl restart vsftpd

    echo $pass | sudo -S systemctl enable ufw
    echo $pass | sudo -S ufw allow ftp
    echo $pass | sudo -S ufw allow 21
    echo $pass | sudo -S ufw allow 22
    echo $pass | sudo -S ufw allow 61208
    echo $pass | sudo -S ufw allow 5900
    echo $pass | sudo -S ufw reload

    echo $pass | sudo -S sudo systemctl kill apache2
    echo $pass | sudo -S sudo systemctl enable nginx
    echo $pass | sudo -S sudo systemctl enable apache2

    echo $pass | sudo -S rm -rf phpMyAdmin-* phpmyadmin.keyring temp*.txt

    echo "
        In /etc/apache2/ports.conf, change the port as

        Listen 8080

        Then go to /etc/apache2/sites-enabled/000-default.conf

        And change the first line as

        <VirtualHost *: 8080>

        Now restart

        sudo systemctl start apache2

        Apache will now listen on port 8080 and redirect to /var/www/html"

    echo "
    Now use the example default file to use php in your nginx server and make sure to create the directory needed

    sudo mkdir /home/$username/all-webs 

    and after that restart apache and nginx

    sudo systemctl restart apache2 nginx
    "

    quit
}

echo $pass | sudo -S apt update
echo $pass | sudo -S apt install -y wget curl apache2 mariadb-server mariadb-client php7.4 libapache2-mod-php7.4 php7.4-mysql php7.4-fpm php-pear vsftpd build-essential python3 python3-dev python3-jinja2 python3-psutil python3-setuptools psensor psensor-server python3-pip lm-sensors nodejs npm nginx

pip3 install --upgrade pip --user

echo $pass | sudo -S apt clean

echo "run sudo mysql_secure_installation and set up like this"
echo "As you have not yet set a root password for your database, hit Enter to skip the initial query. Complete the following queries:"
echo ""
echo "Switch to unix_socket authentication [Y/n] - Enter n to skip"
echo "Set root password? [Y/n] - Type y and press Enter to create a strong root password for your database."
echo "Remove anonymous users? [Y/n] - Type y and press Enter"
echo "Disallow root login remotely? [Y/n] - Type y and press Enter"
echo "Remove test database and access to it? [Y/n] - Type y and confirm with Enter"
echo "Reload privilege tables now? [Y/n] - Type y and confirm with Enter"
echo "Enter the database like so "
echo ""
echo "sudo mysql -u root"
echo ""
echo "Next run "
echo ""
echo "CREATE DATABASE yourDB;"
echo ""
echo "Next run "
echo ""
echo "CREATE USER '$username'@localhost IDENTIFIED BY '$username';"
echo ""
echo "Next run "
echo ""
echo "SELECT User FROM mysql.user;"
echo ""
echo "Next run "
echo ""
echo "GRANT ALL PRIVILEGES ON *.* TO '$username'@localhost IDENTIFIED BY '$username';"
echo ""
echo "Finally run"
echo ""
echo "FLUSH PRIVILEGES;"
echo ""
echo "Then quit out of mysql..."
echo "Waiting for user to press any key or Q to quit..."
read -rsn1 input
if [ "$input" = "q" ]; then
    quit
else
    main
fi
