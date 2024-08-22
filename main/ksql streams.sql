
--#### Important Links

	--kSQL serialization 
		https://docs.ksqldb.io/en/latest/reference/serialization/#kafka
		
	--serialization issue using JSON as vALUE_FORMAT
		https://stackoverflow.com/questions/73062155/issue-with-ksql-struct-with-value-format-json


--#### Queries  
 
	--Test messages of a Topic using ksql 

	PRINT 'mssql-source-topic.TRYIT.dbo.TestCacheKafkaConnect' FROM BEGINNING;



	-- Create Kafka Stream using KSQL; 
	-- Kafka Stream will use Kafka topic created by Kafka Connect Connector which contains SQL Server table change data.
	-- Only payload from the message is used in the kafka streams sql query

	DROP STREAM raw_stream_kafka_connect;

	CREATE STREAM raw_stream_kafka_connect 
	(
		payload varchar
	)
	WITH (
	KAFKA_TOPIC='mssql-source-topic.TRYIT.dbo.TestCacheKafkaConnect', 
	VALUE_FORMAT='JSON'
	);
	   
	Select * from raw_stream_kafka_connect;


	-- kafka stream from previous step will be further used to tranform the data and push it to a new topic.
	-- This new topic will be used to push data to Redis
	-- VALUE_FORMAT is KAFKA and PARTITION BY is also required as this topic's data needs to be pushed to Redis which needs Key and Value. Partition BY will assign Key to the Message and Kafka serializer will serialize the Value in plain text instead of JSON
	DROP STREAM transformed_stream_kafka_connect;

	CREATE STREAM transformed_stream_kafka_connect
	WITH (
	KAFKA_TOPIC='ksqldb-tranform-kafka-connect-payload',
	VALUE_FORMAT='KAFKA' 
	)AS 
	SELECT 
	EXTRACTJSONFIELD(PAYLOAD, '$.after.RedisKey') as RedisKey,
	EXTRACTJSONFIELD(PAYLOAD, '$.after.RedisValue') as RedisValue 
	from  raw_stream_kafka_connect 
    WHERE EXTRACTJSONFIELD(PAYLOAD, '$.after.RedisKey') is not null
    partition by EXTRACTJSONFIELD(PAYLOAD, '$.after.RedisKey');


	Select * from transformed_stream_kafka_connect;
	
	--Test messages of Topic created using able ksql
	PRINT 'ksqldb-tranform-kafka-connect-payload' FROM BEGINNING;


--#### Issues
	-- While creating Streams, Messages were not getting populated.
		-- Issue was due to serialization.
		-- Resolution :
			-- Changed Key and Value converter to "org.apache.kafka.connect.json.JsonConverter" in the json config file of sql server connector, the topic created by the 	connector will be using JSON format for messages
			-- Used VALUE_FORMAT in ksql query as JSON and used only 1 column called payload with varchar as datatype. This will extract only the payload of value section from json messgae which also contains lot of additional details along with required value fields.
			-- Used EXTRACTJSONFIELD to get the appropriate field values.
			--serialization issue using JSON as vALUE_FORMAT
				https://stackoverflow.com/questions/73062155/issue-with-ksql-struct-with-value-format-json