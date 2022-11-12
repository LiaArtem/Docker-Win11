# use MongoDB image
FROM mongo:latest

# copy the database files from host to container
COPY ./mongo-init/init.js /docker-entrypoint-initdb.d

# set environment variables
ENV MONGO_INITDB_ROOT_USERNAME=root
ENV MONGO_INITDB_ROOT_PASSWORD=!Aa112233