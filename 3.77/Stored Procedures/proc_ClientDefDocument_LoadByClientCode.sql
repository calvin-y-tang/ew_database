

CREATE PROCEDURE [proc_ClientDefDocument_LoadByClientCode]
(
 @clientcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *
 FROM [tblclientdefdocument]
 WHERE
  ([clientcode] = @clientcode) 

 SET @Err = @@Error

 RETURN @Err
END


