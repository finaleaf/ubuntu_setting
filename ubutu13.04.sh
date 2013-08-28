#!/usr/bin/env bash

if [ $UID -ne 0 ]; then
    echo Non root user. Please run as root.
    exit 1;
fi

# BASIC SETUP TOOLS
msg() {
    printf '%b\n' "$1" >&2
}

success() {
    if [ "$ret" -eq '0' ]; then
    msg "\e[32m[✔]\e[0m ${1}${2}"
    fi
}

error() {
    msg "\e[31m[✘]\e[0m ${1}${2}"
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


# 기본 저장소를 다음으로 바꾸기. 빨라진다
sed -i 's/us.archive.ubuntu.com/ftp.daum.net/' /etc/apt/sources.list
sed -i 's/kr.archive.ubuntu.com/ftp.daum.net/' /etc/apt/sources.list

apt-get update && apt-get upgrade

apt-get install -y openssh-server

# Utillity
apt-get install -y cronolog vim ctags git subversion build-essential g++ curl libssl-dev apache2-utils sysv-rc-conf

# MySQL
apt-get install -y mysql-server mysql-client

# Redis
apt-get install -y redis-server

# Node.js
apt-get install -y python-software-properties software-properties-common
add-apt-repository ppa:chris-lea/node.js
apt-get update
apt-get install -y nodejs
npm install express jade stylus socket.io -g

# Java 7 Install
add-apt-repository ppa:webupd8team/java
apt-get update
apt-get install -y oracle-java7-installer

# Nginx
apt-get install python-software-properties
add-apt-repository ppa:nginx/stable
apt-get update && apt-get install nginx

# PHP-FPM
apt-get install -y python-software-properties
add-apt-repository ppa:l-mierzwa/lucid-php5
apt-get update
apt-get install -y php5-fpm php5-mysql php5-curl php5-gd php-pear php5-imap php5-mcrypt php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl

