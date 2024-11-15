#!/bin/bash
# Inicia MariaDB
service mysql start

# Inicia Apache
apache2ctl -D FOREGROUND