# Zabbix alert scripts

Introduction
===============

[Zabbix](http://zabbix.com/) is a popular open source monitoring solution.

You can get Zabbix monitoring alerts like server down, disk near full, etc. to phone with *Twilio* by call or SMS.

## Install
* `git clone git://github.com/romeg/zabbix_twilio_alert.git /etc/zabbix/alert.d/`
* `mv twilio.php /var/www/zabbix_webgui/` - this file used for TwiML API.
* **Get and set an API keys** in .twilio_rc - to use Twilio API you need register at  [twilio.com](http://twilio.com)
* **Set SERVER_URL** in .twilio_rc where Twilio can get twilio.php
* Configure **Media types** and **Actions** 
* Profit!

## Test
To test script functionality - just run it in shell:
`./twilio.sh PHONE_NUM Wazzup`