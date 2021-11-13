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

	-- clean up zip code
	SET @zip = REPLACE(@zip, '-','')

	-- need to have at least 1 address line present
	IF (@addr1 IS NULL OR LEN(@addr1) = 0) AND (@addr2 IS NULL OR LEN(@addr2) = 0) 
		SET @errMsg = 'Address Incomplete'
	ELSE
	BEGIN
		BEGIN
			-- city must be present
			IF @city IS NULL OR LEN(@city) = 0 
				SET @errMsg = 'Missing City'
			ELSE
			BEGIN
				-- state must be present
				IF @state IS NULL OR LEN(@state) = 0 
					SET @errMsg = 'Missing State'
				ELSE
				BEGIN
					-- zip code must be present
					IF @zip IS NULL OR LEN(@zip) = 0
						SET @errMsg = 'Missing Zip Code'
					ELSE
					BEGIN 
						-- validate that US Zip Codes are 5 or 9 digits. if a zip code is NOT
						-- numeric then it is not a US address and validation can be skipped.
						IF ISNUMERIC(@zip) = 1 AND NOT (LEN(@zip) = 5 OR LEN(@zip) = 9)
						BEGIN
							SET @errMsg = 'Invalid Zip Code'
						END 
					END 
				END
			END
		END
	END 

	RETURN @errMsg
END
