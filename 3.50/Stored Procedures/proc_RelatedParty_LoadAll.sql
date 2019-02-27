
CREATE PROCEDURE [proc_RelatedParty_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblRelatedParty]


 SET @Err = @@Error

 RETURN @Err
END
