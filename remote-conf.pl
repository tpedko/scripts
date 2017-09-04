#!/usr/bin/perl
#----------------------------------------------------------------------
# Description:
# Version: 2.2.0
# Author: Pedko Timofey <tpedko@rnd.beeline.ru>
# Created at:  01.07.2011
#
# Copyright (c) 2011 Pedko Timofey All rights reserved.
#
#----------------------------------------------------------------------
#
#

use English;
use Expect;

$USER ="USER";
$PASS_USER = "Password";

$tftpserver =		'1.2.3.4';
$RW =			'RW';

$filename_host = 	'/etc/hosts';

# Открываем файл hosts и считываем из него хосты
open DATA, $filename_host or die "Невозможно открыть $filename_host: $!";
while (<DATA>)
{
chomp;
# тепеь в $_ есть строка (ip адрес hostname) и мы ее разделяем на переменные $ip и $name
($ip, $name) = split(/ /);

if ($ip=~/^#/)
    {
# Тут пока не чёго не делаем, может вообще не чё делать не будем, не придумал.
#	print "#### $name - $ip\n";
    }
    elsif ($name=~/^asa/ or $name=~/^pix/)
    {
system ("/bin/echo -e $name");
    }
    elsif ($name=~/^cs/ or $name=~/^swl3/ or $name=~/^sw/)
    {
# Если это Маршрутизатор или свитч IOS
system ("/bin/echo -e $name");
system ("snmpset -v 2c -c $RW -t 5 $name .1.3.6.1.4.1.9.2.1.53.$tftpserver s config.snmp");
system ("snmpset -v 2c -c $RW -t 5 $name .1.3.6.1.4.1.9.2.1.54.0 i 1");
#system ("snmpset -v 2c -O qv -c $RW $ip .1.3.6.1.4.1.9.2.1.55.172.25.15.8 s /conf/$name");
    }
}
close DATA;

