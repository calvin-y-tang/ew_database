CREATE FUNCTION [dbo].[fnParseKeyValueStringForKey]
(
	@QueryString AS VARCHAR(MAX),
	@QueryKey AS VARCHAR(100), 
	@pairSeparator CHAR(1),
	@kvSeparator CHAR(1)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @QueryStringPair VARCHAR(MAX)
	DECLARE @Key VARCHAR(100)
	DECLARE @Value VARCHAR(MAX)
	DECLARE @result VARCHAR(MAX)
	
	-- loop across the KeyValue pair string processing each KeyValue pair until we find that one we are looking for
	WHILE LEN(@QueryString) > 0
	BEGIN
		-- extract the Key Value pair
		SET @QueryStringPair = LEFT ( @QueryString, ISNULL(NULLIF(CHARINDEX(@pairSeparator, @QueryString) - 1, -1), LEN(@QueryString)))
		-- is key we are looking for contained in the pair?
		IF CHARINDEX(@QueryKey, @QueryStringPair) > 0
		BEGIN
			-- this is the key we want; extract value from the key value pair and return
			SELECT @result = REPLACE(SUBSTRING( @QueryStringPair, ISNULL(NULLIF(CHARINDEX(@kvSeparator, @QueryStringPair), 0), LEN(@QueryStringPair)) + 1, LEN(@QueryStringPair)), '"', '')
			BREAK
		END
		--  remove keyvalue pair just processed from query string and loop
		SET @QueryString = SUBSTRING( @QueryString, ISNULL(NULLIF(CHARINDEX(@pairSeparator, @QueryString), 0), LEN(@QueryString)) + 1, LEN(@QueryString))
    END

    RETURN @result

END
