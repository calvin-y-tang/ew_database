/*
	Scalar-Valued Function that will return the value from a list of key value pairs in a string.
	Must enter the string name with the key-value pairs and the key you are looking for.
	The key value pairs are separated by a semicolon:
	   key1=value1;key2=value2;key3=value3;

*/

CREATE FUNCTION [dbo].[fnReturnValueFromKeyInString] 
( 
	@QueryString AS VARCHAR(1000),
	@QueryKey AS VARCHAR(100)
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @QueryStringPair        VARCHAR(2000)
    DECLARE @Key                    VARCHAR(100)
    DECLARE @Value                  VARCHAR(100)
	DECLARE @result					VARCHAR(100)
	DECLARE @QueryStringTable TABLE 
	( 
	[Key] VARCHAR(100), 
	[Value] VARCHAR(1000) )

    WHILE LEN(@QueryString) > 0
    BEGIN
        SET @QueryStringPair = LEFT ( @QueryString, ISNULL(NULLIF(CHARINDEX(';', @QueryString) - 1, -1), 
                                      LEN(@QueryString)))
        SET @QueryString = SUBSTRING( @QueryString, ISNULL(NULLIF(CHARINDEX(';', @QueryString), 0), 
                                      LEN(@QueryString)) + 1, LEN(@QueryString))

        SET @Key   = LEFT (@QueryStringPair, ISNULL(NULLIF(CHARINDEX('=', @QueryStringPair) - 1, -1), 
                           LEN(@QueryStringPair)))
        SET @Value = SUBSTRING( @QueryStringPair, ISNULL(NULLIF(CHARINDEX('=', @QueryStringPair), 0), 
                                LEN(@QueryStringPair)) + 1, LEN(@QueryStringPair))

        INSERT INTO @QueryStringTable ( [Key], [Value] )
        VALUES ( @Key, @Value )
    END

	SELECT @result = [Value] FROM @QueryStringTable WHERE [Key] = @QueryKey

    RETURN @result
END



