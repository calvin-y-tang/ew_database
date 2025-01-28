

--------------------------------------------------
--Changes to drop tblWebUser.Active field
--------------------------------------------------


DROP PROCEDURE [proc_ValidateUserNew]
GO


CREATE PROCEDURE [proc_ValidateUserNew]

@UserID varchar(100),
@Password varchar(30)

AS

DECLARE @UserType CHAR(2)

SET @UserType = (SELECT UserType FROM tblWebUser WHERE UserID = @UserID AND Password = @Password)

IF @UserType = 'CL'
BEGIN
 SELECT 
  tblWebUser.*,
  tblClient.lastname,
  tblClient.firstname,
  tblClient.clientcode,
  tblClient.email,
  ISNULL(tblClient.DefOfficeCode,0) AS DefOfficeCode,
  tblCompany.intname AS CompanyName,
  tblCompany.companycode AS CompanyCode
 FROM tblCompany
  INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode AND tblClient.status = 'Active'
  INNER JOIN tblWebUser ON tblClient.clientcode = tblWebUser.IMECentricCode AND tblWebUser.UserType = 'CL'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblClient.clientcode
   AND tblWebUserAccount.UserType = 'CL'
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND ISNULL(tblClient.PublishOnWeb,0) = 1
END
ELSE IF @UserType IN ('OP')
BEGIN
 SELECT 
  tblWebUser.*, 
  tblDoctor.lastname,
  tblDoctor.firstname,
  tblDoctor.emailAddr AS Email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode AND OPType = 'OP' AND tblDoctor.status = 'Active'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND tblWebUserAccount.UserType = 'OP'  
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND ISNULL(tblDoctor.PublishOnWeb,0) = 1
END
ELSE IF @UserType IN ('AT','CC')
BEGIN
 SELECT 
  tblWebUser.*, 
  tblCCAddress.lastname,
  tblCCAddress.firstname,
  tblCCAddress.email,
  tblCCAddress.company AS CompanyName
 FROM tblWebUser
  INNER JOIN tblCCAddress ON tblWebUser.IMECentricCode = tblCCAddress.cccode AND tblCCAddress.status = 'Active'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblCCAddress.cccode
   AND tblWebUserAccount.UserType IN ('AT','CC')  
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
END
ELSE IF @UserType = 'DR'
BEGIN
 SELECT 
  tblWebUser.*, 
  tblDoctor.lastname,
  tblDoctor.firstname,
  tblDoctor.emailAddr AS Email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode AND tblDoctor.status = 'Active'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND tblWebUserAccount.UserType = 'DR'   
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND ISNULL(tblDoctor.PublishOnWeb,0) = 1
END
ELSE IF @UserType = 'TR'
BEGIN
 SELECT 
  tblWebUser.*, 
  tblTranscription.transcompany AS lastname,
  tblTranscription.email,
  tblWebUser.WebUserID AS firstname,
  tblTranscription.transcompany AS CompanyName
 FROM tblWebUser
  INNER JOIN tblTranscription ON tblWebUser.IMECentricCode = tblTranscription.Transcode AND tblTranscription.status = 'Active'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblTranscription.Transcode
   AND tblWebUserAccount.UserType = 'TR'  
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
END

GO

DROP PROCEDURE [proc_WebUser_Insert]
GO


CREATE PROCEDURE [proc_WebUser_Insert]
(
 @WebUserID int = NULL output,
 @UserID varchar(100) = NULL,
 @Password varchar(200) = NULL,
 @LastLoginDate datetime = NULL,
 @DateAdded datetime = NULL,
 @DateEdited datetime = NULL,
 @UseridAdded varchar(50) = NULL,
 @UseridEdited varchar(50) = NULL,
 @DisplayClient bit,
 @ProviderSearch bit,
 @IMECentricCode int,
 @UserType varchar(2),
 @AutoPublishNewCases bit,
 @IsClientAdmin bit,
 @UpdateFlag bit,
 @LastPasswordChangeDate datetime = NULL,
 @StatusID int = NULL,
 @FailedLoginAttempts int = NULL,
 @LockoutDate datetime = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblWebUser]
 (
  [UserID],
  [Password],
  [LastLoginDate],
  [DateAdded],
  [DateEdited],
  [UseridAdded],
  [UseridEdited],
  [DisplayClient],
  [ProviderSearch],
  [IMECentricCode],
  [UserType],
  [AutoPublishNewCases],
  [IsClientAdmin],
  [UpdateFlag],
  [LastPasswordChangeDate],
  [StatusID],
  [FailedLoginAttempts],
  [LockoutDate]
 )
 VALUES
 (
  @UserID,
  @Password,
  @LastLoginDate,
  @DateAdded,
  @DateEdited,
  @UseridAdded,
  @UseridEdited,
  @DisplayClient,
  @ProviderSearch,
  @IMECentricCode,
  @UserType,
  @AutoPublishNewCases,
  @IsClientAdmin,
  @UpdateFlag,
  @LastPasswordChangeDate,
  @StatusID,
  @FailedLoginAttempts,
  @LockoutDate
 )

 SET @Err = @@Error

 SELECT @WebUserID = SCOPE_IDENTITY()

 RETURN @Err
END

GO

DROP PROCEDURE [proc_WebUser_Update]
GO


CREATE PROCEDURE [proc_WebUser_Update]
(
 @WebUserID int,
 @UserID varchar(100) = NULL,
 @Password varchar(200) = NULL,
 @LastLoginDate datetime = NULL,
 @DateAdded datetime = NULL,
 @DateEdited datetime = NULL,
 @UseridAdded varchar(50) = NULL,
 @UseridEdited varchar(50) = NULL,
 @DisplayClient bit,
 @ProviderSearch bit,
 @IMECentricCode int,
 @UserType varchar(2),
 @AutoPublishNewCases bit,
 @IsClientAdmin bit,
 @UpdateFlag bit,
 @LastPasswordChangeDate datetime = NULL,
 @StatusID int = NULL,
 @FailedLoginAttempts int = NULL,
 @LockoutDate datetime = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblWebUser]
 SET
  [UserID] = @UserID,
  [Password] = @Password,
  [LastLoginDate] = @LastLoginDate,
  [DateAdded] = @DateAdded,
  [DateEdited] = @DateEdited,
  [UseridAdded] = @UseridAdded,
  [UseridEdited] = @UseridEdited,
  [DisplayClient] = @DisplayClient,
  [ProviderSearch] = @ProviderSearch,
  [IMECentricCode] = @IMECentricCode,
  [UserType] = @UserType,
  [AutoPublishNewCases] = @AutoPublishNewCases,
  [IsClientAdmin] = @IsClientAdmin,
  [UpdateFlag] = @UpdateFlag,
  [LastPasswordChangeDate] = @LastPasswordChangeDate,
  [StatusID] = @StatusID,
  [FailedLoginAttempts] = @FailedLoginAttempts,
  [LockoutDate] = @LockoutDate
 WHERE
  [WebUserID] = @WebUserID


 SET @Err = @@Error


 RETURN @Err
END

GO

DECLARE @Command NVARCHAR(1000)

SELECT  @Command = 'ALTER TABLE tblWebUser drop constraint ' + d.name
FROM    sys.tables t
        JOIN sys.default_constraints d ON d.parent_object_id = t.object_id
        JOIN sys.columns c ON c.object_id = t.object_id
                              AND c.column_id = d.parent_column_id
WHERE   t.name = 'tblWebUser'
        AND c.name = 'Active'
  
EXECUTE (@Command)
GO

ALTER TABLE [tblWebUser]
  DROP COLUMN [Active]
GO



UPDATE tblControl SET DBVersion='1.64'
GO
