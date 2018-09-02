start: dev

stop:
	docker-compose stop

build:
	NODE_ENV=development docker-compose up -d --build

dev:
	NODE_ENV=development docker-compose up -d

prod:
	NODE_ENV=production docker-compose up -d --build

monit:
	docker exec -it job-buddy-site job-buddy/node_modules/.bin/pm2 monit