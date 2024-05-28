####### Install Confluent hub #########
## Confluent hub is used for installing debezium connectors for Kafka Connect
## Get the latest zip from https://docs.confluent.io/platform/7.4/connect/confluent-hub/client.html

## Shell Script
mkdir confluent-hub
cd ./confluent-hub
## Get the latest zip from https://docs.confluent.io/platform/7.4/connect/confluent-hub/client.html
wget https://client.hub.confluent.io/confluent-hub-client-latest.tar.gz
tar -zxvf confluent-hub-client-latest.tar.gz

## Add confluent-hub path in environmental variable 


##### Important Links to Follow ######

# https://zakir-hossain.medium.com/debezium-source-connector-on-confluent-platform-d00494c29d17
# https://zakir-hossain.medium.com/running-confluent-platform-locally-with-docker-compose-ba6d9ad113e7
# https://docs.confluent.io/platform/7.4/connect/confluent-hub/client.html
# https://docs.confluent.io/platform/6.2/quickstart/ce-docker-quickstart.html
