CREATE FUNCTION [dbo].[fnGetParamValue]
(
	@QueryString AS VARCHAR(MAX),
	@QueryKey AS VARCHAR(100)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	
	RETURN dbo.fnParseKeyValueStringForKey(@QueryString, @QueryKey, ';', '=')

END
