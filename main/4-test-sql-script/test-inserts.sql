-- Use this insterts to test whether messages are streamed

delete from [dbo].[TestCacheKafkaConnect] ;


INSERT INTO [dbo].[TestCacheKafkaConnect] (RedisKey, RedisValue, CreatedDate)
VALUES ('ABCD','{HRO : FLASH}', GETDATE())


INSERT INTO [dbo].[TestCacheKafkaConnect] (RedisKey, RedisValue, CreatedDate)
VALUES ('SACHIN','{HERO : YFLASH}', GETDATE())


INSERT INTO [dbo].[TestCacheKafkaConnect] (RedisKey, RedisValue, CreatedDate)
VALUES ('PRITI','{SPIDER : MAN}', GETDATE())


INSERT INTO [dbo].[TestCacheKafkaConnect] (RedisKey, RedisValue, CreatedDate)
VALUES ('NEERAJ','{SAND : MAN}', GETDATE())
