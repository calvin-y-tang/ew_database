
CREATE PROCEDURE [proc_RelatedParty_Delete]
(
 @rpcode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblRelatedParty]
 WHERE
  [rpcode] = @rpcode
 SET @Err = @@Error

 RETURN @Err
END
