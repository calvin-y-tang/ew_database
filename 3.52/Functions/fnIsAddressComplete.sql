CREATE FUNCTION [dbo].[fnIsAddressComplete]
(
	@addr1 VARCHAR(50), 
	@addr2 VARCHAR(50), 
	@city VARCHAR(50),
	@state VARCHAR(2),
	@zip VARCHAR(10)
)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @errMsg VARCHAR(100)

	-- return empty string when all is good
	SET @errMsg = ''

	-- need to have at least 1 address line present
	IF (@addr1 IS NULL OR LEN(@addr1) = 0) AND (@addr2 IS NULL OR LEN(@addr2) = 0) 
		SET @errMsg = 'Address Incomplete'
	ELSE
	BEGIN
		BEGIN
			IF @city IS NULL OR LEN(@city) = 0 
				SET @errMsg = 'Missing City'
			ELSE
			BEGIN
				IF @state IS NULL OR LEN(@state) = 0 
					SET @errMsg = 'Missing State'
				ELSE
				BEGIN
					IF @zip IS NULL OR LEN(@zip) = 0
						SET @errMsg = 'Missing Zip Code'
				END
			END
		END
	END 

	RETURN @errMsg
END
