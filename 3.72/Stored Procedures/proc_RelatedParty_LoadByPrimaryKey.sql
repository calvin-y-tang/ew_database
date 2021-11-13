
CREATE PROCEDURE [proc_RelatedParty_LoadByPrimaryKey]
(
 @rpcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblRelatedParty]
 WHERE
  ([rpcode] = @rpcode)

 SET @Err = @@Error

 RETURN @Err
END
