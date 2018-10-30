

CREATE PROCEDURE [proc_CaseDefDocument_Update]
(
 @casenbr int,
 @documentcode varchar(15),
 @documentqueue int,
 @dateadded datetime = NULL,
 @useridadded varchar(20) = NULL,
 @dateedited datetime = NULL,
 @useridedited varchar(20) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblcasedefdocument]
 SET
  [dateadded] = @dateadded,
  [useridadded] = @useridadded,
  [dateedited] = @dateedited,
  [useridedited] = @useridedited
 WHERE
  [casenbr] = @casenbr
 AND [documentcode] = @documentcode
 AND [documentqueue] = @documentqueue


 SET @Err = @@Error


 RETURN @Err
END


