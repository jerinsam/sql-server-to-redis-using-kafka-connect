### For Redis Sink Connector 


##### Redis Kafka Sink Connector Properties:
- https://docs.confluent.io/kafka-connectors/redis/current/overview.html
	
##### Steps used to register the connector
- Go to Confluent UI
- Click on Cluster and go to Connect section
- Go to Connect Cluster and click on add connector
- Upload JSON config, a page will pop up with the connector properties filled from the uploaded JSON config
- Click Next and OK
- Task will be created and it should be in Running state
- In case of Error, Go to Connect Docker and check the logs

##### Important Properties of Redis Connector
    "name": "redis-sink",
    "connector.class": "com.github.jcustenborder.kafka.connect.redis.RedisSinkConnector",
    "tasks.max": "1",
    "key.converter": "org.apache.kafka.connect.storage.ByteArrayConverter",
    "value.converter": "org.apache.kafka.connect.storage.ByteArrayConverter",
    "topics": "ksqldb-tranform-kafka-connect-payload",
    "redis.hosts": "redis:6379"

##### Topics used in Redis Sink
- Topic used in the config is cerated using KSQL Streams (scripts can be found in ksql folder). 
- KSQL is used to transform the records coming from the topic used by sql server connector to push the table rows.


##### Errors faced during the development
- Error : Redis Sink Connect unable to connect to redis server throwing error "Unable to connect to localhost:6379"
    - Resolution : 
        - In the connector configuration json add "redis.hosts" property with value "redis:6379" (** This is the host name value passed in redis container section of docker compose yaml)
        - Host names is generally used to communicate across different docker containers and localhost:port is used by the host system to communicate with docker container.
        - In config json, always mention bootstrap server or host name mentioned in docker compose yaml, instead of localhost. If localhost is passed then there will be error.

- Error : Task threw an uncaught and unrecoverable exception. 
    - Resolution : 
        - This is caused due to Key and Value Converter (Serializer)
        - Previously used JSON convertor "org.apache.kafka.connect.json.JsonConverter" which was causing the issue.
        - After changing Key and Value convertor to "org.apache.kafka.connect.converters.ByteArrayConverter" solved the issue.
        - Redis sink supports only "org.apache.kafka.connect.converters.ByteArrayConverter" and "org.apache.kafka.connect.storage.StringConverter" converter.
        - This information is documented in the Confluent Redis Sink website 
            - https://docs.confluent.io/kafka-connectors/redis/current/overview.html

- Error: The key for the record can not be null.
    - Resolution : Add "partition by" in the KSQL query and use "VALUE_FORMAT = "KAFKA""
    - "partition by" will populate message key with RedisKey column vale
    - "VALUE_FORMAT = "KAFKA"" will serialize the data in plain text, this will help value in Redis to be as we have in SQL Server
    - Also added a where statement when Key is not Null in KSQL query
	
##### Test the redis sink
- Check all the records getting pushed in the redis
    - "redis-cli MONITOR"

- Get value of the redis keys
    - Used to get into redis-cli
        - "redis-cli" 
    - Check database; if it is db1 then 1 will be the database id
        - "INFO keyspace"
    - Go to database 1; In this case only 1 DB exists that is db1 with id 1
        - "SELECT 1"
    - Message is streamed with Key "Sachin" and Value "{HERO : PINK_FLASH}". To check if the message is properly udpated in the Redis use GET method.
        - "GET 'SACHIN'"

##### Important Links 
- Confluent Kafka Connect Cluster- Worker configuration properties
    - https://docs.confluent.io/platform/current/connect/references/allconfigs.html


