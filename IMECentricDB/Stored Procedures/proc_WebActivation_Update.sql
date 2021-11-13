

CREATE PROCEDURE [dbo].[proc_WebActivation_Update]
(
 @ActivationID varchar(40),
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

 UPDATE [tblWebActivation]
 SET
  [WebUserID] = @WebUserID,
  [Type] = @Type,
  [RequestedFrom] = @RequestedFrom,
  [DateAdded] = @DateAdded,
  [UserIDAdded] = @UserIDAdded,
  [SentDate] = @SentDate,
  [ExpirationDate] = @ExpirationDate,
  [ActivatedDate] = @ActivatedDate,
  [WebUserFullName] = @WebUserFullName,
  [EmailAddress] = @EmailAddress,
  [Status] = @Status
 WHERE
  [ActivationID] = @ActivationID

 SET @Err = @@Error

 RETURN @Err
END

