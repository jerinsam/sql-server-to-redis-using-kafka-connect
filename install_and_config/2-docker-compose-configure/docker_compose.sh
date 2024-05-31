###### Got to Confluent Github page and Download Docker Compose File #######
# url : https://github.com/confluentinc/cp-all-in-one/tree/7.5.0-post/cp-all-in-one
# Folder : cp-all-in-one

# Download Docker
# Download Docker Compose yaml file from the above mentioned github page and use docker compose command to download and start the service

# Execute the below command to pull and configure all the images defined in the docker-compose.yaml file
# this needs to be executed in the same folder where docker-compose.yaml file exists

docker compose up -d

# To stop Container Services 

docker-compose stop

#To connect to services in Docker, refer to the following ports.
#This may change, check git Readme file for latest updates and also double check docker compose file: 
  
# ZooKeeper: 2181
# Kafka broker: 9092
# Kafka broker JMX: 9101
# Confluent Schema Registry: 8081
# Kafka Connect: 8083
# Confluent Control Center: 9021 - Confluent Control Center is a UI to manage the kafka and its associated services. 
# ksqlDB: 8088
# Confluent REST Proxy: 8082
 

##### Important Links to Follow ######

# https://zakir-hossain.medium.com/debezium-source-connector-on-confluent-platform-d00494c29d17
# https://zakir-hossain.medium.com/running-confluent-platform-locally-with-docker-compose-ba6d9ad113e7
# https://docs.confluent.io/platform/7.4/connect/confluent-hub/client.html
# https://docs.confluent.io/platform/6.2/quickstart/ce-docker-quickstart.html


#### Issue faced : 
# If Docker Desktop is installed on Windows and Ubuntu VM is being used for development then change network adaptor setting to Bridged Adaptor and access the localhost using Windows wifi/LAN IP address. e.g. instead of http://localhost:9091/ use http://10.10.15.229:9021/.
