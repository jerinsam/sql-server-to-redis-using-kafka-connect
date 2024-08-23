### For SQL Server Source Connector


##### Confluent Kakfa Connect tutorial 
- https://docs.confluent.io/platform/current/platform-quickstart.html


##### SQL Server Kafka Connector Properties:
- https://zakir-hossain.medium.com/debezium-source-connector-on-confluent-platform-d00494c29d17 
- https://debezium.io/documentation/reference/stable/connectors/sqlserver.html
- https://docs.confluent.io/kafka-connectors/debezium-sqlserver-source/current/overview.html
- https://docs.confluent.io/kafka-connectors/debezium-sqlserver-source/current/sqlserver_source_connector_config.html#advanced-properties

##### Steps used to register the connector
- Go to Confluent UI
- Click on Cluster and go to Connect section
- Go to Connect Cluster and click on add connector
- Upload JSON config, a page will pop up with the connector properties filled from the uploaded JSON config
- Click Next and OK
- Task will be created and it should be in Running state
- In case of Error, Go to Connect Docker and check the logs

##### Important Properties of the connector
    "connector.class": "io.debezium.connector.sqlserver.SqlServerConnector",
    "name": "mssql-source-config-json",
    "tasks.max": "1",
    "topic.prefix": "mssql-source-topic",
    "database.names": "TRYIT",
    "database.hostname": "10.10.13.121",
    "database.port": "1433",
    "database.user": "js",
    "database.password": "js",
    "database.encrypt": "true",
    "database.trustServerCertificate": "true",
    "table.include.list": "dbo.TestCacheKafkaConnect",
    "schema.history.internal.kafka.bootstrap.servers": "broker:29092",
    "schema.history.internal.kafka.topic": "schema.changes.sqlserverSource",
    "snapshot.mode": "initial",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter", 
    "key.converter": "org.apache.kafka.connect.json.JsonConverter"


##### Value and Key converter (serializer) - different types : Used to convert (serialize) the message to a common format 
- Producer and Consumer should use same serializers to properly convert the messages.
    - https://www.confluent.io/blog/kafka-connect-deep-dive-converters-serialization-explained/


##### Errors faced during the development

- Issue with SQL Server Connection
    - This Issue won't allow us to create the Task. Connector will give error while clicking next after uploading JSON config
    - Resolution : 
        - Make sure IP address of the SQL Server is correct.
        - Config property in JSON "database.trustServerCertificate" should be true.

- Error - Kafka Connect unaable to connect to kafka broker with error "Connection to node -1 (localhost/127.0.0.1:9092) could not be established. Broker may not be available."
    - Resolution : In the connector configuration json add "schema.history.internal.kafka.bootstrap.servers" property with value "broker:29092" (** This is the bootstrap server value present in Connect container section of docker compose yaml)
    - bootstrap server is generally used to communicate across different docker containers and localhost:port is used by the host system to communicate with docker container.
    - In config json, always mention bootstrap server or host name mentioned in docker compose yaml, instead of localhost. If localhost is passed then there will be error.

- Issue with unregistered topics
    - Resolution : Create topic mentioned in the "schema.history.internal.kafka.topic" property of connector config json before creating the connector 

- Error - "The db history topic or its content is fully or partially missing. Please check database schema history topic configuration and re-execute the snapshot."
    - Workaround : Configure connector with different name 
    - Resolution : Topic of "schema.history.internal.kafka.topic" should have "retention.ms" property as -1 and "retention.bytes" as -1. -1 denotes infinity.
    - Refer : https://basantakharel.com/setting-up-kafka-connect-with-debezium-connectors-importance-of-database-history-parameters


##### Test the stream (CDC SQL Server)
- List all topics 
    - Script : "kafka-topics --bootstrap-server broker:29092 --list"
    - Execute above shell script in broker's shell. 
    - You will find a new topic with name starting with the value mentioned in "topic.prefix" 
- Create Console Consumer to validate the data 
    - "kafka-console-consumer --bootstrap-server broker:29092 --topic mssql-source-topic.TRYIT.dbo.TestCacheKafkaConnect -from-beginning --property print.key=true --property print.value=true --property value.deserializer=org.apache.kafka.common.serialization.StringDeserializer"
    - Execute above shell script in broker's shell.          
- Add new records in the table mentioned in the connector configuration
    - All the new records will start showing up in the console 
    - Use Insert into SQL Server Table scripts in the test-sql-script folder
 

##### Important Links
 - Confluent Kafka Connect Cluster- Worker configuration properties
    - https://docs.confluent.io/platform/current/connect/references/allconfigs.html


