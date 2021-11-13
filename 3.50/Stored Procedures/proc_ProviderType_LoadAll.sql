

CREATE PROCEDURE [proc_ProviderType_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT * FROM tblProviderType ORDER BY description

 SET @Err = @@Error

 RETURN @Err
END


