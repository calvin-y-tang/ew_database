
CREATE PROCEDURE [proc_CaseRelatedParty_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCaseRelatedParty]

 SET @Err = @@Error

 RETURN @Err
END
