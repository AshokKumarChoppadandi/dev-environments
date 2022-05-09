# PostgreSQL Setup

# Add User as SUDO User

# Setup Static IP

# Disable Firewall

# Update the Packages

sudo dnf update -y

# Add the PostgreSQL Yum Repository

sudo dnf install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-42.0-24.noarch.rpm -y

# Install PostgreSQL 13

We need to disable the PostgreSQL AppStream repository on CentOS 8 | RHEL 8 Linux which contains some other version of PostgreSQL.

sudo dnf -qy module disable postgresql

sudo dnf repolist

## Search for PostgreSQL 13 packages

sudo yum search postgresql13

## Install PostgreSQL 13

sudo dnf install postgresql13 postgresql13-server -y

# Initialize and start database service

sudo /usr/pgsql-13/bin/postgresql-13-setup initdb

# Config file location:

 /var/lib/pgsql/13/data/postgresql.conf

 ls /var/lib/pgsql/13/data/


