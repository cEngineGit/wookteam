#!/usr/bin/env bash

#fonts color
Green="\033[32m"
Red="\033[31m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

#notification information
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"

cur_path="$(pwd)"

supervisorctl_restart() {
    RES=`docker-compose exec php /bin/bash -c "supervisorctl update $1"`
    if [ -z "$RES" ];then
        docker-compose exec php /bin/bash -c "supervisorctl restart $1"
    else
        echo -e "$RES"
    fi
}

####################################################################################
####################################################################################
####################################################################################

COMPOSE="docker-compose"

if [ $# -gt 0 ];then
    if [[ "$1" == "init" ]] || [[ "$1" == "install" ]]; then
        shift 1
        if [ ! -f ".env" ];then
            cp .env.docker .env
        fi
        rm -rf composer.lock
        rm -rf package-lock.json
        $COMPOSE build php
        $COMPOSE up -d
        $COMPOSE restart php
        $COMPOSE exec php /bin/bash -c "composer install"
        $COMPOSE exec php /bin/bash -c "php artisan key:generate"
        $COMPOSE exec php /bin/bash -c "php artisan migrate --seed"
        $COMPOSE exec php /bin/bash -c "php bin/wookteam --port=8000 --ssl=44300"
        $COMPOSE exec php /bin/bash -c "php bin/wookteam --wookteam=prod"
        $COMPOSE stop
        $COMPOSE start
    elif [[ "$1" == "update" ]]; then
        shift 1
        git fetch --all
        git reset --hard origin/master
        git pull
        $COMPOSE exec php /bin/bash -c "composer install"
        $COMPOSE exec php /bin/bash -c "php artisan migrate"
        $COMPOSE stop
        $COMPOSE start
    elif [[ "$1" == "dev" ]]; then
        shift 1
        $COMPOSE exec php /bin/bash -c "php bin/wookteam --wookteam=dev"
        supervisorctl_restart php
        npm run hot
    elif [[ "$1" == "prod" ]]; then
        shift 1
        $COMPOSE exec php /bin/bash -c "php bin/wookteam --wookteam=prod"
        supervisorctl_restart php
        npm run prod
    elif [[ "$1" == "artisan" ]]; then
        shift 1
        e="php artisan $@" && $COMPOSE exec php /bin/bash -c "$e"
    elif [[ "$1" == "php" ]]; then
        shift 1
        e="php $@" && $COMPOSE exec php /bin/bash -c "$e"
    elif [[ "$1" == "composer" ]]; then
        shift 1
        e="composer $@" && $COMPOSE exec php /bin/bash -c "$e"
    elif [[ "$1" == "supervisorctl" ]]; then
        shift 1
        e="supervisorctl $@" && $COMPOSE exec php /bin/bash -c "$e"
    elif [[ "$1" == "test" ]]; then
        shift 1
        e="./vendor/bin/phpunit $@" && $COMPOSE exec php /bin/bash -c "$e"
    elif [[ "$1" == "npm" ]]; then
        shift 1
        e="npm $@" && $COMPOSE exec php /bin/bash -c "$e"
    elif [[ "$1" == "yarn" ]]; then
        shift 1
        e="yarn $@" && $COMPOSE exec php /bin/bash -c "$e"
    elif [[ "$1" == "mysql" ]]; then
        shift 1
        e="mysql $@" && $COMPOSE exec mariadb /bin/sh -c "$e"
    elif [[ "$1" == "restart" ]]; then
        shift 1
        $COMPOSE stop "$@"
        $COMPOSE start "$@"
    else
        $COMPOSE "$@"
    fi
else
    $COMPOSE ps
fi
