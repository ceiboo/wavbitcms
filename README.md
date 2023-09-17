# Nia Tracker System - Harbour Project on Docker

# INSTALL AND CONFIGURE PLATFORM
```bash
git clone https://github.com/ceiboo/wavbitcms.git
cd wavbitcms
mkdir .stogare
mkdir .stogare/data
chmod 777 -R .storage
```
### Create the dockers instances
`docker compose up -d --build`

### Install vendor packages for PHP
`docker compose exec cms composer install`

### Configure DATABASE connection
`cd /php/src/backend/.env`
`nano .env`
- Change: (if neccesary, for default this is ok with docker):

    - DB_DRIVER=mysql
    - DB_HOST=172.10.2.43
    - DB_PORT=3306
    - DB_NAME=wavbit-mysql
    - DB_USER=admin
    - DB_PASSWORD=123456

* You can use the data from the local database here


### Create Database structure and insert data
`docker compose exec cms php command Migrate`

### Test GetUser Command
`docker compose exec cms php command GetUsers`

### Down the platform
`docker compose down`


# EXECUTE PLATFORM

### Test GetUser Command
`docker compose exec cms php command GetUsers`

### Execute NIA Tracker System
`docker compose exec cms ./cms`
