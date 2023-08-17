# webDev-server-setup-script
a script that automates the process of setting up a web development server

make sure to read the [nginx_notes](https://github.com/BeanGreen247/webDev-server-setup-script/blob/main/nginx_notes) file for more information

### what about ssh and vnc remote desktop?

use raspi-config and go here, there you will find the follwing option and enable SSH and VNC

3 Interface Options    Configure connections to peripherals

### what happens when running headless now?

well it defaults to a pretty resolution of 1024x768 so use the resolutions.sh script at startup or use arandr software

### what if i do not want to manage the db using commandline tools?

i personally use [DBeaver](https://github.com/dbeaver/dbeaver)

### make sure to do this

sudo nano /etc/mysql/mariadb.cnf

and uncomment the port 3306
