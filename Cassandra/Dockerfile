FROM cassandra

# Require user & pass for accessing Cassandra instance within container
RUN echo "authenticator: PasswordAuthenticator" >> /etc/cassandra/cassandra.yaml

EXPOSE 9042