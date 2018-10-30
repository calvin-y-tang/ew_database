

CREATE PROCEDURE [proc_ClientDefDocument_LoadByPrimaryKey]
(
 @clientcode int,
 @documentcode varchar(15),
 @documentqueue int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT
  [clientcode],
  [documentcode],
  [documentqueue],
  [dateadded],
  [useridadded],
  [dateedited],
  [useridedited]
 FROM [tblclientdefdocument]
 WHERE
  ([clientcode] = @clientcode) AND
  ([documentcode] = @documentcode) AND
  ([documentqueue] = @documentqueue)

 SET @Err = @@Error

 RETURN @Err
END


