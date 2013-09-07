#!/usr/bin/env bash

if [ $UID -ne 0 ]; then
	echo Non root user. Please run as root.
	exit 1;
fi

BLACK='\e[0;30m'
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
MAGENTA='\e[0;35m'
CYAN='\e[0;36m'
WHITE='\e[0;37m'
END_COLOR='\e[0m'

# BASIC SETUP TOOLS
msg() {
	printf $MAGENTA'%b\n'$END_COLOR "$1" >&2
}

success() {
	echo -e "$GREEN[✔]$END_COLOR ${1}${2}"
}

error() {
	msg "$RED[✘]$END_COLOR ${1}${2}"
	exit 1
}

debug() {
	if [ "$debug_mode" -eq '1' ] && [ "$ret" -gt '1' ]; then
	  msg "An error occured in function \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}, we're sorry for that."
	fi
}

program_exists() {
	local ret='0'
	type $1 >/dev/null 2>&1 || { local ret='1'; }

	# throw error on non-zero return value
	if [ ! "$ret" -eq '0' ]; then
	error "$2"
	fi
}

repo_change() {
	# 기본 저장소를 다음으로 바꾸기. 빨라진다
	sed -i 's/us.archive.ubuntu.com/ftp.daum.net/' /etc/apt/sources.list
	sed -i 's/kr.archive.ubuntu.com/ftp.daum.net/' /etc/apt/sources.list
}

update() {
	msg "Ubuntu update start."
	apt-get update
	apt-get upgrade
	success "Update Complete"
}

openssh() {
	msg "Openssh install start."
	apt-get install -y openssh-server
	success "Install openssh-server"
}

utillity() {
	# Utillity install
	msg "Utillities install start."
	apt-get install -y cronolog vim ctags git subversion build-essential g++ curl libssl-dev sysv-rc-conf expect tmux
	success "Install Utillities"
}

# MySQL install
mysql() {
	msg "MySQL install start."
	apt-get install -y mysql-server mysql-client
	success "Install Mysql"
}

# Redis install
redis() {
	msg "Redis install start."
	apt-get install -y redis-server
	success "Install Reids"
}

# Node.js install
nodejs() {
	msg "Node.js install start."
	apt-get install -y python-software-properties software-properties-common
	add-apt-repository -y  "ppa:chris-lea/node.js"
	apt-get update
	apt-get install -y nodejs
	npm install express jade stylus socket.io locally -g
	success "Install Node.js"
}

# Java 7 install
java() {
	msg "Java install start."
	# Java 7 install
	add-apt-repository -y "ppa:webupd8team/java"
	apt-get update
	apt-get install -y oracle-java7-installer
	success "Install Java7"
}

# Nginx install
nginx() {
	msg "Nginx install start."
	apt-get install python-software-properties
	add-apt-repository -y "ppa:nginx/stable"
	apt-get update
	apt-get install -y nginx
	success "Install Nginx"
}

# PHP-FPM install
phpfpm() {
	msg "PHP-FPM install start."
	apt-get install -y python-software-properties
	add-apt-repository -y "ppa:l-mierzwa/lucid-php5"
	apt-get update
	apt-get install -y php5 php-apc php-pear php5-cli php5-common php5-curl php5-dev php5-fpm php5-gd php5-gmp php5-imap php5-ldap php5-mcrypt php5-memcache php5-memcached php5-mysql php5-odbc php5-pspell php5-recode php5-snmp php5-sqlite php5-sybase php5-tidy php5-xmlrpc php5-xsl libapache2-mod-php5 php5-mongo php5-xmlrpc
	success "Install PHP-FPM"
}

phpredis() {
	msg "phpredis install start"
	pecl install redis
	#git clone https://github.com/nicolasff/phpredis.git
	#cd phpredis
	#phpize
	#./configure [--enable-redis-igbinary]
	#make && make install
	#cd -
	#rm -rf phpredis
	success "Install phpredis"
}

samba() {
	msg "Samba install start"
	apt-get install -y samba
	success "Install samba"
}

copyconf() {
	msg "Copy service conf"
	msg "Nginx"
	curl https://raw.github.com/gyuha/ubuntu_setting/master/conf/nginx > /tmp/nginx.conf
	cp -f /tmp/nginx.conf /etc/nginx/sites-available/default
	rm -f /tmp/nginx.conf
	service nginx restart
	msg "php-fpm"
	curl https://raw.github.com/gyuha/ubuntu_setting/master/conf/php.dev.ini > /tmp/php.dev.ini
	cp -f /tmp/php.dev.ini /etc/php5/fpm/php.ini
	rm -f /tmp/php.dev.ini
	service php5-fpm restart
	success "Copy complete"
}

if [ $# -eq 0 ]; then
	msg "Select any packages.";
	exit;
fi

if [ $1 == "all" ]; then
	msg "Install all packages."
	repo_change;
	update;
	openssh;
	utillity;
	mysql;
	redis;
	nodejs;
	java;
	nginx;
	phpfpm;
	phpredis;
	msg "Complete."
	exit;
fi

for (( i=1;$i<=$#;i=$i+1 ))
do
	if type ${!i} | grep -i function > /dev/null &2>1; then
		eval ${!i};
	fi
done
