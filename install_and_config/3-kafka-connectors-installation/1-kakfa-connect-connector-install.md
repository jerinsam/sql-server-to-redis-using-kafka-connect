### Kafka Connector Installation

#### Confluent hub can be used to install the connectors
- Refer Folder : confluent-hub-configure, and Read Shell scripts for details 
- Manual Installation deatisl are given below, this is used in this POC 


### MANUAL CONNECTOR INSTALLATION

#### SQL SERVER DEBEZIUM CONNECTOR FOR KAFKA CONNECT - Source Confluent Website
- Connector from Confluent is used in this PoC

- SQL Server Connector : https://www.confluent.io/hub/debezium/debezium-connector-sqlserver
- Download the connector in local environment
- Go to folder /etc/kafka in docker image of kafka connect
- Open file "connect-standalone.properties" or "connect-distributed.properties" and identify the plugin.path (e.g. /usr/share/confluent-hub-components)
- unzip the zip file and copy unzipped folder from local to docker container plugin.path
- Restart Docker

- Docker copy script to copy from local to docker container plugin.path : execute in local system command prompt (*windows) and make sure docker container is up.
    - script format : docker cp c:\path\to\local\file container_name:/path/to/target/dir/

          docker cp C:\Users\jerin\Desktop\Connectors\debezium-debezium-connector-sqlserver-2.5.4 connect:/usr/share/confluent-hub-components

- ** To get docker container name , execute below script in local system command prompt 

      docker ps --format "{{.Names}}"


#### SQL SERVER DEBEZIUM CONNECTOR FOR KAFKA CONNECT - Source Debezium Website

- Debezium SQL Server Connector: https://debezium.io/documentation/reference/stable/connectors/sqlserver.html#sqlserver-deploying-a-connector
- Go to folder /etc/kafka in docker image of kafka connect
- Open file "connect-standalone.properties" or "connect-distributed.properties" and identify the plugin.path (e.g. /usr/share/confluent-hub-components)
- Downlaod the connector tar file and unzip it in the plugin.path
- Restart Docker

- Execute below script in Docker Container for kafka connect

      cd /usr/share/confluent-hub-components
      wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-sqlserver/2.6.2.Final/debezium-connector-sqlserver-2.6.2.Final-plugin.tar.gz
      tar -xzvf ./debezium-connector-sqlserver-2.6.2.Final-plugin.tar.gz
      rm ./debezium-connector-sqlserver-2.6.2.Final-plugin.tar.gz



#### REDIS CONNECTOR FOR KAFKA CONNECT

- Redis Connector : https://www.confluent.io/hub/jcustenborder/kafka-connect-redis
- Download the connector in local environment
- Go to folder /etc/kafka in docker image of kafka connect
- Open file "connect-standalone.properties" or "connect-distributed.properties" and identify the plugin.path (e.g. /usr/share/confluent-hub-components)
- unzip the zip file and copy unzipped folder from local to docker container plugin.path
- Restart Docker

- Docker copy script to copy from local to docker container plugin.path : execute in local system command prompt (*windows) and make sure docker container is up.
    - script format : docker cp c:\path\to\local\file container_name:/path/to/target/dir/

          docker cp C:\Users\jerin\Desktop\Connectors\jcustenborder-kafka-connect-redis-0.0.7 connect:/usr/share/confluent-hub-components

- ** To get docker container name , execute below script in local system command prompt 
        docker ps --format "{{.Names}}"


#### Execute below script in Docker kafka connect Container to check if folder from local is copied

    cd /usr/share/confluent-hub-components
    ls ./jcustenborder-kafka-connect-redis-0.0.7


### AFTER INSTALLATION 

- Restart Docker Kafka Connect Container and navigate to KAKFA Confluent UI (e.g. http://localhost:9021/clusters)
- Click on Kafka Broker and then click on Kafka Connect Server and click Connect service
- On the side bar, click on connect and then add connectors. If SQL Server and Redis Sink shows there then Installation is successful.