

CREATE PROCEDURE [dbo].[proc_WebActivation_Insert]
(
 @ActivationID varchar(40) = NULL output,
 @WebUserID int = NULL,
 @Type varchar(15) = NULL,
 @RequestedFrom varchar(1) = NULL,
 @DateAdded datetime = NULL,
 @UserIDAdded varchar(15) = NULL,
 @SentDate datetime = NULL,
 @ExpirationDate datetime = NULL,
 @ActivatedDate datetime = NULL,
 @WebUserFullName varchar(35) = NULL,
 @EmailAddress varchar(100) = NULL,
 @Status varchar(10) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DECLARE @NewGUID varchar(40)

 SET @NewGUID = (SELECT newid())

 INSERT
 INTO [tblWebActivation]
 (
  [ActivationID],
  [WebUserID],
  [Type],
  [RequestedFrom],
  [DateAdded],
  [UserIDAdded],
  [SentDate],
  [ExpirationDate],
  [ActivatedDate],
  [WebUserFullName],
  [EmailAddress],
  [Status]
 )
 VALUES
 (
  @NewGUID,
  @WebUserID,
  @Type,
  @RequestedFrom,
  @DateAdded,
  @UserIDAdded,
  @SentDate,
  @ExpirationDate,
  @ActivatedDate,
  @WebUserFullName,
  @EmailAddress,
  @Status
 )

 SET @Err = @@Error

 SELECT @ActivationID = @NewGUID

 RETURN @Err
END

