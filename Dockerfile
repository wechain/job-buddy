FROM node:10-alpine

RUN mkdir -p /app
WORKDIR /app

RUN npm install -g strapi@3.0.0-alpha.13.1

COPY strapi.sh ./
RUN chmod +x ./strapi.sh

EXPOSE 1337

COPY healthcheck.js ./
HEALTHCHECK --interval=15s --timeout=5s --start-period=30s CMD node /app/healthcheck.js

CMD [ "./strapi.sh" ]
