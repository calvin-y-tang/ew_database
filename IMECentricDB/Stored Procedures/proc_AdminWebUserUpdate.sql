

CREATE PROCEDURE [proc_AdminWebUserUpdate]

@WebUserID int,
@UserID varchar(100),
@Password varchar(100),
@DateEdited smalldatetime,
@UserIDEdited varchar(30),
@Email varchar(70),
@UserType as varchar(2)



AS

SET NOCOUNT OFF
DECLARE @Err int

UPDATE tblWebUser SET 
[UserID] = @UserID,
Password = @Password,
DateEdited = @DateEdited,
UserIDEdited = @UserIDEdited

WHERE WebUserID = @WebUserID

IF @UserType = 'CL'
BEGIN
 UPDATE tblClient SET email = @Email WHERE tblClient.WebUserID = @WebUserID
END
ELSE IF @UserType IN ('OP', 'DR')
BEGIN
 UPDATE tblDoctor SET emailAddr = @Email WHERE tblDoctor.WebUserID = @WebUserID
END
ELSE IF @UserType IN ('AT','CC')
BEGIN
 UPDATE tblCCAddress SET email = @Email WHERE tblCCAddress.WebUserID = @WebUserID
END
ELSE IF @UserType = 'TR'
BEGIN
 UPDATE tblTranscription SET email = @Email WHERE tblTranscription.WebUserID = @WebUserID
END

SET @Err = @@Error
RETURN @Err
 



