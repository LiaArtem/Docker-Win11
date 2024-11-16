# use MSSQL 2022 image
FROM mcr.microsoft.com/mssql/server:2022-latest
USER root

# create directory within SQL container for database files
RUN mkdir -p /opt/mssql-scripts

# copy the database files from host to container
COPY sql_add_mssql.sql /opt/mssql-scripts

# set environment variables
ENV MSSQL_SA_PASSWORD=!Aa112233
ENV ACCEPT_EULA=Y

# run initial scripts
RUN /opt/mssql/bin/sqlservr --accept-eula & sleep 30 \
    && /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P '!Aa112233' -C -i /opt/mssql-scripts/sql_add_mssql.sql \
    && pkill sqlservr