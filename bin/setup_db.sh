#!/bin/bash
#
# Run this as root to setup the MySQL database

# First off, run a MySQL daemon, e.g. `sudo systemctl start mysqld`.
# Second, create databases and users
mysql -u root <<EOF
    CREATE USER 'gamification'@'localhost' IDENTIFIED BY 'hallo';
    CREATE DATABASE gamification;
    GRANT ALL PRIVILEGES ON gamification.* TO 'gamification'@'localhost'
        WITH GRANT OPTION;

    CREATE USER 'travis'@'localhost';
    CREATE DATABASE gamification_test;
    GRANT ALL PRIVILEGES ON gamification_test.* TO 'travis'@'localhost'
        WITH GRANT OPTION;
EOF
