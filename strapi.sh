#!/bin/sh
set -ea

_stopStrapi() {
  echo "Stopping strapi"
  kill -SIGINT "$strapiPID"
  wait "$strapiPID"
}

trap _stopStrapi SIGTERM SIGINT

cd /app

if [ ! -f "$APP_NAME/package.json" ]
then
    strapi new ${APP_NAME} --dbclient=$DATABASE_CLIENT --dbhost=$DATABASE_HOST --dbport=$DATABASE_PORT --dbname=$DATABASE_NAME --dbusername=$DATABASE_USERNAME --dbpassword=$DATABASE_PASSWORD --dbssl=$DATABASE_SSL --dbauth=$DATABASE_AUTHENTICATION_DATABASE
elif [ ! -d "$APP_NAME/node_modules" ]
then
    npm install --prefix ./$APP_NAME
fi

cd $APP_NAME

if [ "$NODE_ENV" = "production" ]
then
  node_modules/.bin/pm2 start --no-daemon node_modules/strapi/bin/strapi.js start &
  node_modules/.bin/pm2 start --watch --ignore-watch='admin config plugins public node_modules' --no-daemon node_modules/strapi/bin/strapi.js start &
fi

node_modules/.bin/pm2 start --watch --ignore-watch='admin config plugins public node_modules' --no-daemon npm -- start &

strapiPID=$!
wait "$strapiPID"
