### For KSQL KAFKA Streams

#### Important Links
- KSQL Serialization 
	- https://docs.ksqldb.io/en/latest/reference/serialization/#kafka
		
- Serialization issue using JSON as VALUE_FORMAT
	- https://stackoverflow.com/questions/73062155/issue-with-ksql-struct-with-value-format-json


- Errors faced during the development
	- While creating Streams, Messages were not getting populated.
		- Issue was due to serialization.
		- Resolution :
			- Changed Key and Value converter to "org.apache.kafka.connect.json.JsonConverter" in the json config file of sql server connector, the topic created by the 	connector will be using JSON format for messages
			- Used VALUE_FORMAT in ksql query as JSON and used only 1 column called payload with varchar as datatype. This will extract only the payload of value section from json messgae which also contains lot of additional details along with required value fields.
			- Used EXTRACTJSONFIELD to get the appropriate field values.
			- Important link on Serialization issue using JSON as VALUE_FORMAT
				- https://stackoverflow.com/questions/73062155/issue-with-ksql-struct-with-value-format-json


- Test the stream 
	- Use Insert into SQL Server Table scripts in the /Test folder to test 
    - Test (using ksql query) messages of Topic created using ksql, this contains transformed raw messages received from sql server source connector
		- PRINT 'ksqldb-tranform-kafka-connect-payload' FROM BEGINNING;