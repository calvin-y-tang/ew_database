CREATE FUNCTION [dbo].[fnConfListIsPhoneValid]
(
	@phoneString AS VARCHAR(16)
)
RETURNS VARCHAR(8)
AS
BEGIN
	
    /*
        Dev Notes: 
            Created for use in Confirmation List processing to validate phone number.
            A valid phone number: 
                - has numeric digits  0 - 9
                - exactly 10 numeric digits
                - can also have the following formatting characters: "(", ")", "-" or " " (space)
    */

    DECLARE @tmpPhone VARCHAR(16)
    DECLARE @len INTEGER
    DECLARE @charPOS INTEGER
    DECLARE @oneChar CHAR(1)
    DECLARE @phoneIsValid VARCHAR(8)

    SET @len = LEN(@phoneString)
    SET @charPOS = 1

    -- can only have 0-9, hyphen, paren, or empty string
    SET @tmpPhone = ''
    SET @phoneIsValid = 'True'
    WHILE (@charPOS <= @len) and (@phoneIsValid = 'True')
    BEGIN

        SET @oneChar = SUBSTRING(@phoneString, @charPOS, 1)
        IF (@oneChar >= '0' and @oneChar <= '9') 
            SET @tmpPhone = @tmpPhone + @oneChar
        ELSE IF (@oneChar <> '-' AND @oneChar <> '(' AND @oneChar <> ')' AND @oneChar <> ' ')
            SET @phoneIsValid = 'False'
          
        SET @charPOS = @charPOS + 1

    END
     
    -- check to see if we have 10 digit phone
    If @phoneIsValid = 'True' AND LEN(@tmpPhone) <> 10 
        SET @phoneIsValid = 'False'
	
    RETURN @phoneIsValid

END
