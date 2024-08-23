## SQL_SERVER_TO_REDIS_KAFKA_CONNECT
**DATA ENGINEERING SOLUTIONS - STREAM SQL SERVER DATA TO REDIS USING KAFKA CONNECT**

#### Problem Statement - 

There's a reporting application which populates charts based on filters applied by users. The underlying data resides in SQL Server and there are 2 major Fact tables with 5 Million and 3 Million respectively, with refresh frequency of weekly with full data load. These tables are used in the complex metric calculation queries (fully optimized queries) and reside in Stored Procedures. Whenever a user selects the filters, API calls these SPs and populates the data in the charts.

These calculations take 10-15 seconds to process the data and as per the standards data needs to be computed with in 5 seconds to keep users engaged on the App.

#### Solution - 
** Redis is an open source, in-memory, key-value store that stores data in RAM
To solve the above issue, Redis Cache has been implemented. Idea is, if a User select a specific filter and API will retrieve the desired output after executing the SP in 15 Seconds, that Output will be stored in JSON format in Redis Cache and also same Output will be used by UI to populate the chart. In this scenario, User will still be waiting for 15 seconds to view the chart with desired data (Initial wait issue). However, if next time, same filter criteria is selected by some other or same user then data will be retrieved in milliseconds.

To mitigate the initial wait issue, Pre-populating Redis cache with all the filter combination is the best option. To develop this solution, It's been decided to capture all the frequently used User Filters (which is used as Redis key) to a table and after the weekly data refresh, JSON output will be created for those Filter Criteria (by executing the SPs) and will be stored in a table. Once output for all the keys is populated, Redis keys will be updated with the latest JSON output. To process 1000 keys, DB takes 30 mins, which is acceptable in our use case and app will have downtime for that period. 

Now if any user selects new combination which does not exist in the Redis then again User will have to wait for 15 seconds and currently in DB there are ~200000 keys (combination of filters) and it’s not feasible to populate all the ~200k key at once as UI will be down for that long period.

Keeping all these issues in mind, Final Solution has following sections:
1. After Data Refresh, all the frequently used keys will be processed and loaded in Redis Cache.
2. Create all the filter combinations and identify the important keys based on Business use case.
3. Implement a SP which will continuously process the different filter combinations and store the JSON output in a table.
4. Implement a streaming solution which will push the new data available in the Table to Redis. 

This solution will not completely eliminate the Initial wait issue but will reduce a lot. 

### Implementation - 
In this POC, We are looking into the Point 4, i.e. Streaming app to push the processed data to Redis.
The solution is created on following are the list of Services:
1. Docker
2. Kafka
3. SQL Server CDC Implementation
4. Kafka Connect - SQL Server Source Connector
5. KSQL Kafka Streams for Transformation
6. Kafka Connect - Redis Sink Connector
7. Redis

#### Solution high level architecture
![alt text](https://github.com/jerinsam/sql-server-to-redis-using-kafka-connect/blob/main/main/kafka-connect-architecture.png?raw=true)

#### Install and Config

**Refer**: install_and_config Folder to get the details of the installation on the following - 
1. Configure Git for this project
2. Docker Compose for Confluent environment
3. Connectors installation in Docker
4. Enable CDC in SQL Server Table, which will be tracked by Kafka connect source connector 

#### Connector and Configuration

**Refer**: /main folder to get the details of Connector configuraton and KSQL stream transformation -
1. Sql Server Source Connector : Contains details of configuration details of the connector, important links to follow, along with errors faced during the development.

2. KSQL Kafka Streams : Contains KSQL Query for creating stream and transformations, important links to follow, along with errors faced during the development.

3. Redis Sink Connector : Contains configuration details of the connector, important links to follow, along with errors faced during the development.


#### Description:
1. **Source Connector** : In this solution, following steps are taken-
   - Configured SQL Server Debezium Source Connector - This connector will monitor the table where processed data from SP for redis is stored.
   - SQL Server CDC needs to be enabled on the Table which is being monitored.
   - Whenever a new data is pushed to the table, it will be streamed to kafka topic by the source connector.
   - Data is streamed in JSON format

2. **KSQL Kafka Streams** : In this step, following steps are taken - 
   - Create a stream using ksql query for the topic used by Source Connector where data from the sql server table is streamed.
   - JSON from the stream contains lots of additional information which is not required by Redis.
   - New transformation stream is created using KSQL query, this will extract only the required attributes from the JSON i.e. RedisKey and RedisValue.
   - The transformed message will be streamed to a new topic serialized in KAFKA format (which is in plain text format). 
   
3. **Sink Connector** : In this step, following steps are taken - 
   - Configured Redis Sink Connector - This connector is connected to the new topic which is created after transformation (using KSQL) of the messages from SQL Source Connector. This new topic contains only required data points.
   - Redis sink connector automatically inserts/updates Redis with the data coming from the new topic.


### Reference Links

#### Docker for Kafka : Reference
- Download Docker Compose File Confluent
   - url : https://github.com/confluentinc/cp-all-in-one/tree/7.5.0-post/cp-all-in-one
   - Folder : cp-all-in-one
- https://zakir-hossain.medium.com/debezium-source-connector-on-confluent-platform-d00494c29d17
- https://zakir-hossain.medium.com/running-confluent-platform-locally-with-docker-compose-ba6d9ad113e7
- https://docs.confluent.io/platform/7.4/connect/confluent-hub/client.html
- https://docs.confluent.io/platform/6.2/quickstart/ce-docker-quickstart.html


### Connector from Confluent is used in this PoC
- SQL Server Connector - Consluent : https://www.confluent.io/hub/debezium/debezium-connector-sqlserver html#sqlserver-deploying-a-connector
- Redis Connector : https://www.confluent.io/hub/jcustenborder/kafka-connect-redis

### Refer Confluent Link for CDC Setup
- https://docs.confluent.io/kafka-connectors/debezium-sqlserver-source/current/overview.html

### Confluent Kakfa Connect tutorial 
- https://docs.confluent.io/platform/current/platform-quickstart.html

### SQL Server Kafka Connector Properties:
- https://zakir-hossain.medium.com/debezium-source-connector-on-confluent-platform-d00494c29d17 
- https://debezium.io/documentation/reference/stable/connectors/sqlserver.html
- https://docs.confluent.io/kafka-connectors/debezium-sqlserver-source/current/overview.html
- https://docs.confluent.io/kafka-connectors/debezium-sqlserver-source/current/sqlserver_source_connector_config.html#advanced-properties
 
### Value and Key converter (serializer)
- https://www.confluent.io/blog/kafka-connect-deep-dive-converters-serialization-explained/
   

### KSQL Serialization 
- https://docs.ksqldb.io/en/latest/reference/serialization/#kafka
		
- Serialization issue using JSON as VALUE_FORMAT
   - https://stackoverflow.com/questions/73062155/issue-with-ksql-struct-with-value-format-json

### Redis Kafka Sink Connector Properties:
- https://docs.confluent.io/kafka-connectors/redis/current/overview.html
	
