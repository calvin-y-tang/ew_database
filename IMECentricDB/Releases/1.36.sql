


------------------------------------------------------------------------------------------------
--Updated Exception stored procedure so that exceptions for status changes that were for <all>
--statuses do not get displayed twice
------------------------------------------------------------------------------------------------
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

ALTER    PROCEDURE [dbo].[proc_IMEException]

@ExceptionID int,				-- ExceptionID we are looking for
@IMECentricCode int,			-- code related to the Entity.  Will be -1 if exception is not case related.
@CaseTypeCode int,				-- will be -1 if not applicable
@ServiceCode int,				-- will be -1 if not applicable
@StatusCode int,				-- will be -1 if not applicable
@EnterLeave int,				-- will be 0 if not applicable.  Will be 1 if we are looking for an exception with a case that has a statuscode that just entered the status, 2 if the case just left the statuscode
@CaseNbr int					-- will be -1 if not applicable

AS

--declare local variables
DECLARE @clientcode int
DECLARE @companycode int
DECLARE @doctorcode int
DECLARE @plaintiffattorneycode int
DECLARE @defenseattorneycode int
DECLARE @defparalegal int
SET NOCOUNT ON

IF @CaseNbr <> -1 
BEGIN
	--fill variables
	SELECT @clientcode = tblclient.clientcode, 
			@companycode = tblclient.companycode,
			@doctorcode = doctorcode, 
			@plaintiffattorneycode = plaintiffattorneycode, 
			@defenseattorneycode = defenseattorneycode, 
			@defparalegal = defparalegal
	FROM tblCase
		INNER JOIN tblclient ON tblclient.clientcode = tblcase.clientcode
			WHERE casenbr = @CaseNbr
END
ELSE BEGIN
	select @clientcode = -1,
	       @companycode = -1,
               @doctorcode = -1,
               @plaintiffattorneycode = -1,
               @defenseattorneycode = -1,
               @defparalegal = -1
END

--declare temp table to hold return values
DECLARE @tblException TABLE
(
  ExceptionDefID int
)

DECLARE @entity_loop varchar(10)
DECLARE @IMECentricCode_loop int
DECLARE @CaseTypeCode_loop int
DECLARE @ServiceCode_loop int
DECLARE @StatusCode_loop int
DECLARE @StatusCodeValue_loop int
DECLARE @ExceptionDefID_loop int
DECLARE list cursor for
SELECT Entity, IMECentricCode, CaseTypeCode, ServiceCode, StatusCode, StatusCodeValue, ExceptionDefID 
	FROM tblExceptionDefinition WHERE ExceptionID = @ExceptionID AND status = 'Active'

OPEN list
FETCH NEXT FROM list 
	INTO @entity_loop, @IMECentricCode_loop, @CaseTypeCode_loop, @ServiceCode_loop, @StatusCode_loop, @StatusCodeValue_loop, @ExceptionDefID_loop
WHILE @@FETCH_STATUS = 0
BEGIN
	-- if exception is for a case @IMECentricCode should be -1
	IF @entity_loop = 'CS'
	BEGIN
		IF @IMECentricCode = -1
		BEGIN
			IF @CaseTypeCode = @CaseTypeCode_loop
			BEGIN
				IF @ServiceCode = @ServiceCode_loop
				BEGIN
					IF @StatusCode = @StatusCode_loop
					BEGIN
						IF @StatusCode <> -1
						BEGIN
							IF @StatusCodeValue_loop = @EnterLeave
							BEGIN
								-- If casetype, service, and status all equal
								--do insert
								INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
							END																
						END		
					END
					-- if casetype, service equal and status = -1 then insert
					IF @StatusCode = -1
					BEGIN
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END											
				END
				-- if casetype equals and service and status = -1 then insert
				IF @ServiceCode_loop = -1
				BEGIN
					-- only include exception if just changed into that status
					IF @StatusCodeValue_loop = @EnterLeave
					BEGIN
						--do insert
						INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
					END
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = @casetype and service = -1 and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END

				END										
			END
			
			IF @CaseTypeCode_loop = -1
			BEGIN
				IF @ServiceCode_loop = -1
				BEGIN
					IF @StatusCode_loop = -1
					BEGIN
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = -1 and service = -1 and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END
				END	
				IF @ServiceCode = @ServiceCode_loop
				BEGIN
					IF @StatusCode_loop = -1
					BEGIN
						-- if casetype = -1 and servicecode = @servicecode and statuscode = -1 then insert
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END	
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = -1 and service = @servicecode and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END
				END
			END		
		END
	END

	-- if exception is for a client
	IF @entity_loop = 'CL'
	BEGIN
		IF @clientcode =  @IMECentricCode_loop
		BEGIN
			IF @CaseTypeCode = @CaseTypeCode_loop
			BEGIN
				IF @ServiceCode = @ServiceCode_loop
				BEGIN
					IF @StatusCode = @StatusCode_loop
					BEGIN
						IF @StatusCode <> -1
						BEGIN
							IF @StatusCodeValue_loop = @EnterLeave
							BEGIN
								-- If casetype, service, and status all equal
								--do insert
								INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
							END																
						END		
					END
					-- if casetype, service equal and status = -1 then insert
					IF @StatusCode_loop = -1
					BEGIN
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END											
				END
				-- if casetype equals and service and status = -1 then insert
				IF @ServiceCode_loop = -1
				BEGIN
					IF @StatusCode_loop = -1
					BEGIN
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END	
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = @casetype and service = -1 and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END

				END										
			END
			
			IF @CaseTypeCode_loop = -1
			BEGIN
				IF @ServiceCode_loop = -1
				BEGIN
					IF @StatusCode_loop = -1
					BEGIN
						-- if casetype = -1, service = -1 and status = -1, then insert
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave 
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END	
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = -1 and service = -1 and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END
				END	
				IF @ServiceCode = @ServiceCode_loop
				BEGIN
					IF @StatusCode_loop = -1
					BEGIN
						-- if casetype = -1 and servicecode = @servicecode and statuscode = -1 then insert
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave 
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END	
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = -1 and service = @servicecode and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END
				END
			END		
		END
	END

	-- if exception is for a company
	IF @entity_loop = 'CO'
	BEGIN
		IF @companycode =  @IMECentricCode_loop
		BEGIN
			IF @CaseTypeCode = @CaseTypeCode_loop
			BEGIN
				IF @ServiceCode = @ServiceCode_loop
				BEGIN
					IF @StatusCode = @StatusCode_loop
					BEGIN
						IF @StatusCode <> -1
						BEGIN
							IF @StatusCodeValue_loop = @EnterLeave
							BEGIN
								-- If casetype, service, and status all equal
								--do insert
								INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
							END																
						END		
					END
					-- if casetype, service equal and status = -1 then insert
					IF @StatusCode_loop = -1
					BEGIN
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave 
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END											
				END
				-- if casetype equals and service and status = -1 then insert
				IF @ServiceCode_loop = -1
				BEGIN
					IF @StatusCode_loop = -1
					BEGIN
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END	
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = @casetype and service = -1 and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END

				END										
			END
			
			IF @CaseTypeCode_loop = -1
			BEGIN
				IF @ServiceCode_loop = -1
				BEGIN
					IF @StatusCode_loop = -1
					BEGIN
						-- if casetype = -1, service = -1 and status = -1, then insert
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END	
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = -1 and service = -1 and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END
				END	
				IF @ServiceCode = @ServiceCode_loop
				BEGIN
					IF @StatusCode_loop = -1
					BEGIN
						-- if casetype = -1 and servicecode = @servicecode and statuscode = -1 then insert
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END	
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = -1 and service = @servicecode and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END
				END
			END		
		END
	END

	-- if exception is for a doctor
	IF @entity_loop = 'DR'
	BEGIN
		IF @doctorcode =  @IMECentricCode_loop
		BEGIN
			IF @CaseTypeCode = @CaseTypeCode_loop
			BEGIN
				IF @ServiceCode = @ServiceCode_loop
				BEGIN
					IF @StatusCode = @StatusCode_loop
					BEGIN
						IF @StatusCode <> -1
						BEGIN
							IF @StatusCodeValue_loop = @EnterLeave
							BEGIN
								-- If casetype, service, and status all equal
								--do insert
								INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
							END																
						END		
					END
					-- if casetype, service equal and status = -1 then insert
					IF @StatusCode_Loop = -1
					BEGIN
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END											
				END
				-- if casetype equals and service and status = -1 then insert
				IF @ServiceCode_loop = -1
				BEGIN
					IF @StatusCode_loop = -1
					BEGIN
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END	
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = @casetype and service = -1 and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END

				END										
			END
			
			IF @CaseTypeCode_loop = -1
			BEGIN
				IF @ServiceCode_loop = -1
				BEGIN
					IF @StatusCode_loop = -1
					BEGIN
						-- if casetype = -1, service = -1 and status = -1, then insert
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END	
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = -1 and service = -1 and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END
				END	
				IF @ServiceCode = @ServiceCode_loop
				BEGIN
					IF @StatusCode_loop = -1
					BEGIN
						-- if casetype = -1 and servicecode = @servicecode and statuscode = -1 then insert
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END	
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = -1 and service = @servicecode and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END
				END
			END		
		END
	END

	-- if exception is for an attorney
	IF @entity_loop = 'AT'
	BEGIN
		IF @defenseattorneycode =  @IMECentricCode_loop or  @plaintiffattorneycode =  @IMECentricCode_loop
		BEGIN
			IF @CaseTypeCode = @CaseTypeCode_loop
			BEGIN
				IF @ServiceCode = @ServiceCode_loop
				BEGIN
					IF @StatusCode = @StatusCode_loop
					BEGIN
						IF @StatusCode <> -1
						BEGIN
							IF @StatusCodeValue_loop = @EnterLeave
							BEGIN
								-- If casetype, service, and status all equal
								--do insert
								INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
							END																
						END		
					END
					-- if casetype, service equal and status = -1 then insert
					IF @StatusCode_loop = -1
					BEGIN
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END											
				END
				-- if casetype equals and service and status = -1 then insert
				IF @ServiceCode_loop = -1
				BEGIN
					IF @StatusCode_loop = -1
					BEGIN
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave 
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END	
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = @casetype and service = -1 and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END

				END										
			END
			
			IF @CaseTypeCode_loop = -1
			BEGIN
				IF @ServiceCode_loop = -1
				BEGIN
					IF @StatusCode_loop = -1
					BEGIN
						-- if casetype = -1, service = -1 and status = -1, then insert
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave 
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END	
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = -1 and service = -1 and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END
				END	
				IF @ServiceCode = @ServiceCode_loop
				BEGIN
					IF @StatusCode_loop = -1
					BEGIN
						-- if casetype = -1 and servicecode = @servicecode and statuscode = -1 then insert
						-- only include exception if just changed into that status
						IF @StatusCodeValue_loop = @EnterLeave 
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)														
						END
					END	
					IF @StatusCode = @StatusCode_loop
					BEGIN
						-- if casetype = -1 and service = @servicecode and status = @status then insert
						IF @StatusCodeValue_loop = @EnterLeave
						BEGIN
							--do insert
							INSERT INTO @tblException (ExceptionDefID) VALUES (@ExceptionDefID_loop)
						END																
					END
				END
			END		
		END
	END


	FETCH NEXT FROM list 
		INTO @entity_loop, @IMECentricCode_loop, @CaseTypeCode_loop, @ServiceCode_loop, @StatusCode_loop, @StatusCodeValue_loop, @ExceptionDefID_loop
END
CLOSE list
DEALLOCATE list

SELECT DISTINCT * FROM @tblException


update tblexceptiondefinition 
set StatusCodeValue = 1
where exceptionid = 18 and statuscode = -1


GO

--------------------------------------------------------------------------------------------------------
--Security and Password Changes
--------------------------------------------------------------------------------------------------------

--Schema Changes


CREATE TABLE [tblWebPasswordHistory] (
  [WebUserID] INTEGER,
  [PasswordDate] DATETIME,
  [Password] VARCHAR(200) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [WebPasswordHistoryID] INTEGER IDENTITY(1,1) NOT NULL
)
GO

CREATE TABLE [tblWebUserStatus] (
  [StatusID] INTEGER NOT NULL,
  [Description] VARCHAR(35) COLLATE SQL_Latin1_General_CP1_CI_AS,
  CONSTRAINT [PK_tblWebUserStatus] PRIMARY KEY CLUSTERED ([StatusID])
)
GO

CREATE TABLE [tblWebActivation] (
  [ActivationID] VARCHAR(40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [WebUserID] INTEGER,
  [Type] VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [Status] VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [DateAdded] DATETIME,
  [UserIDAdded] VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [SentDate] DATETIME,
  [ExpirationDate] DATETIME,
  [ActivatedDate] DATETIME,
  [WebUserFullName] VARCHAR(35) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [EmailAddress] VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [RequestedFrom] VARCHAR(1) COLLATE SQL_Latin1_General_CP1_CI_AS,
  CONSTRAINT [PK_tblWebActivation] PRIMARY KEY CLUSTERED ([ActivationID])
)
GO

CREATE TABLE [tblEWSecurityProfile] (
  [SecurityProfileID] INTEGER NOT NULL,
  [Name] VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [Description] VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [MinPwdLength] INTEGER,
  [RequireNumber] BIT,
  [RequireUpperCase] BIT,
  [RequireLowerCase] BIT,
  [RequireSymbol] BIT,
  [PwdHistoryCount] INTEGER,
  [MinPwdAge] INTEGER,
  [MaxPwdAge] INTEGER,
  [MaxFailedLoginAttempt] INTEGER,
  [LockoutDuration] INTEGER,
  [SessionTimeOut] INTEGER,
  CONSTRAINT [PK_tblEWSecurityProfile] PRIMARY KEY CLUSTERED ([SecurityProfileID])
)
GO


ALTER TABLE [tblCompany]
  ADD [SecurityProfileID] INTEGER
GO


ALTER TABLE [tblWebUser]
  ADD [LastPasswordChangeDate] DATETIME
GO

ALTER TABLE [tblWebUser]
  ADD [StatusID] INTEGER
GO

ALTER TABLE [tblWebUser]
  ADD [FailedLoginAttempts] INTEGER
GO

ALTER TABLE [tblWebUser]
  ADD [LockoutDate] DATETIME
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_tblWebUser_UserID] ON [tblWebUser]([UserID])
GO

ALTER TABLE [tblWebUser]
  ALTER COLUMN [Password] VARCHAR(200)
GO


ALTER TABLE [tblIMEData]
  ADD [ATSecurityProfileID] INTEGER
GO

ALTER TABLE [tblIMEData]
  ADD [CLSecurityProfileID] INTEGER
GO

ALTER TABLE [tblIMEData]
  ADD [DRSecurityProfileID] INTEGER
GO

ALTER TABLE [tblIMEData]
  ADD [OPSecurityProfileID] INTEGER
GO

ALTER TABLE [tblIMEData]
  ADD [TRSecurityProfileID] INTEGER
GO


CREATE PROCEDURE [dbo].[proc_WebPasswordHistory_LoadByPrimaryKey]
(
 @WebPasswordHistoryID int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebPasswordHistory]
 WHERE
  ([WebPasswordHistoryID] = @WebPasswordHistoryID)

 SET @Err = @@Error

 RETURN @Err
END

GO


CREATE PROCEDURE [dbo].[proc_WebPasswordHistory_Delete]
(
 @WebPasswordHistoryID int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblWebPasswordHistory]
 WHERE
  [WebPasswordHistoryID] = @WebPasswordHistoryID
 SET @Err = @@Error

 RETURN @Err
END

GO


CREATE PROCEDURE [dbo].[proc_WebPasswordHistory_Insert]
(
 @WebPasswordHistoryID int = NULL output,
 @WebUserID int,
 @PasswordDate datetime,
 @Password varchar(200) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblWebPasswordHistory]
 (
  [WebUserID],
  [PasswordDate],
  [Password]
 )
 VALUES
 (
  @WebUserID,
  @PasswordDate,
  @Password
 )

 SET @Err = @@Error

 SELECT @WebPasswordHistoryID = SCOPE_IDENTITY()

 RETURN @Err
END

GO


CREATE PROCEDURE [dbo].[proc_WebPasswordHistory_Update]
(
 @WebPasswordHistoryID int,
 @WebUserID int,
 @PasswordDate datetime,
 @Password varchar(200) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblWebPasswordHistory]
 SET
  [WebUserID] = @WebUserID,
  [PasswordDate] = @PasswordDate,
  [Password] = @Password
 WHERE
  [WebPasswordHistoryID] = @WebPasswordHistoryID

 SET @Err = @@Error

 RETURN @Err
END

GO


CREATE PROCEDURE [dbo].[proc_WebPasswordHistory_LoadByWebUserID]
(
 @WebUserID int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebPasswordHistory]
 WHERE
  ([WebUserID] = @WebUserID)

 ORDER BY 
  [PasswordDate] DESC

 SET @Err = @@Error

 RETURN @Err
END

GO


CREATE PROCEDURE [dbo].[proc_Client_LoadByUserIDAndEmail]
(
 @UserID varchar(100),
 @Email varchar(70)
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblClient]
  INNER JOIN [tblWebUser] ON [tblClient].WebUserID = [tblWebUser].WebUserID
 WHERE
  ([tblWebUser].UserID = @UserID)
 AND
  ([tblClient].Email = @Email)

 SET @Err = @@Error

 RETURN @Err
END

GO


CREATE PROCEDURE [dbo].[proc_WebActivation_Delete]
(
 @ActivationID int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblWebActivation]
 WHERE
  [ActivationID] = @ActivationID
 SET @Err = @@Error

 RETURN @Err
END

GO


CREATE PROCEDURE [dbo].[proc_WebActivation_LoadByPrimaryKey]
(
 @ActivationID varchar(40)
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebActivation]
 WHERE
  ([ActivationID] = @ActivationID)

 SET @Err = @@Error

 RETURN @Err
END

GO


CREATE PROCEDURE [dbo].[proc_WebUser_LoadByUserID]
(
 @UserID varchar(100)
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebUser]
 WHERE
  ([UserID] = @UserID)

 SET @Err = @@Error

 RETURN @Err
END

GO


CREATE PROCEDURE [dbo].[proc_Transcription_LoadByPrimaryKey]
(
 @TransCode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblTranscription]
 WHERE
  ([TransCode] = @TransCode)

 SET @Err = @@Error

 RETURN @Err
END

GO


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

GO


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

GO


CREATE PROCEDURE [dbo].[proc_WebActivation_LoadByWebUserID]
(
 @WebUserID int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebActivation]
 WHERE
  ([WebUserID] = @WebUserID)

 SET @Err = @@Error

 RETURN @Err
END

GO


CREATE PROCEDURE [dbo].[proc_EWSecurityProfile_LoadByPrimaryKey]
(
 @SecurityProfileID int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblEWSecurityProfile]
 WHERE
  ([SecurityProfileID] = @SecurityProfileID)

 SET @Err = @@Error

 RETURN @Err
END

GO


CREATE PROCEDURE [dbo].[proc_EWSecurityProfile_LoadByCompanyCode]
(
 @CompanyCode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblEWSecurityProfile]
  INNER JOIN [tblCompany] ON [tblCompany].SecurityProfileID = [tblEWSecurityProfile].SecurityProfileID
 WHERE
  ([tblCompany].CompanyCode = @CompanyCode)

 SET @Err = @@Error

 RETURN @Err
END

GO

DROP VIEW [vwOfficeIMEData]
GO

CREATE VIEW [dbo].[vwOfficeIMEData]
AS
    SELECT  dbo.tblOffice.officecode
           ,dbo.tblIMEData.*
    FROM    dbo.tblOffice
            INNER JOIN dbo.tblIMEData ON dbo.tblOffice.imecode = dbo.tblIMEData.IMEcode

GO

DROP VIEW [vw_WebCoverLetterInfo]
GO


CREATE VIEW [dbo].[vw_WebCoverLetterInfo]

AS

SELECT
 --case     
 tblCase.casenbr AS Casenbr,
 tblCase.chartnbr AS Chartnbr,
 tblCase.doctorlocation AS Doctorlocation,
 tblCase.clientcode AS clientcode,
 tblCase.Appttime AS Appttime,
 tblCase.dateofinjury AS DOI,
 tblCase.notes AS Casenotes,
 tblCase.DoctorName AS doctorformalname,
 tblCase.ClaimNbrExt AS ClaimNbrExt,
 tblCase.Jurisdiction AS Jurisdiction,
 tblCase.ApptDate AS Apptdate,
 tblCase.claimnbr AS claimnbr,
 tblCase.doctorspecialty AS Specialtydesc,
 
 --examinee
 tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename,
 tblExaminee.addr1 AS examineeaddr1,
 tblExaminee.addr2 AS examineeaddr2,
 tblExaminee.city AS ExamineeCity,
 tblExaminee.state AS ExamineeState,
 tblExaminee.zip AS ExamineeZip,
 tblExaminee.phone1 AS examineephone,
 tblExaminee.SSN AS ExamineeSSN,
 tblExaminee.sex AS ExamineeSex,
 tblExaminee.DOB AS ExamineeDOB,
 tblExaminee.insured AS insured,
 tblExaminee.employer AS Employer,
 tblExaminee.treatingphysician AS TreatingPhysician,
 tblExaminee.EmployerAddr1 AS Employeraddr1,
 tblExaminee.EmployerCity AS Employercity,
 tblExaminee.EmployerState AS Employerstate,
 tblExaminee.EmployerZip AS Employerzip,
 tblExaminee.EmployerPhone AS Employerphone,
 tblExaminee.EmployerFax AS Employerfax,
 tblExaminee.EmployerEmail AS Employeremail,
 
 --case type
 tblCaseType.description AS Casetype,

 --service
 tblServices.description AS servicedesc,
 
 --client
 tblClient.firstname + ' ' + tblClient.lastname AS clientname,
 tblClient.firstname + ' ' + tblClient.lastname AS clientname2,
 tblClient.phone1 AS clientphone,
 tblClient.fax AS Clientfax,
 
 --company
 tblCompany.intname company,
 
 --defense attorney
 cc1.firstname + ' ' + cc1.lastname AS dattorneyname,
 cc1.company AS dattorneycompany,
 cc1.address1 AS dattorneyaddr1,
 cc1.address2 AS dattorneyaddr2,
 cc1.phone AS dattorneyphone,
 cc1.fax AS dattorneyfax,
 cc1.email AS dattorneyemail,
 
 --plaintiff attorney
 cc2.firstname + ' ' + cc2.lastname AS pattorneyname,
 cc2.company AS pattorneycompany,
 cc2.address1 AS pattorneyaddr1,
 cc2.address2 AS pattorneyaddr2,
 cc2.phone AS pattorneyphone,
 cc2.fax AS pattorneyfax,
 cc2.email AS pattorneyemail,
 
 --doctor
 'Dr. ' + tblDoctor.firstname + ' ' + tblDoctor.lastname AS doctorsalutation,

 --problems
 tblProblem.description AS Problems

FROM  tblCase 
 INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
 INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode 
 INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
 LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code 
 LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
 LEFT OUTER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode 
 LEFT OUTER JOIN tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode 
 LEFT OUTER JOIN tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
 LEFT OUTER JOIN tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
 LEFT OUTER JOIN tblCaseProblem ON tblCase.casenbr = tblCaseProblem.casenbr
 LEFT OUTER JOIN tblProblem ON tblCaseProblem.problemcode = tblProblem.problemcode

GO

DROP VIEW [vwcompany]
GO




CREATE VIEW [dbo].[vwcompany]
AS
SELECT TOP 100 PERCENT dbo.tblCompany.*
 FROM dbo.tblCompany
 ORDER BY intname



GO

DROP PROCEDURE [proc_WebUser_Insert]
GO


CREATE PROCEDURE [dbo].[proc_WebUser_Insert]
(
 @WebUserID int = NULL output,
 @UserID varchar(100) = NULL,
 @Password varchar(200) = NULL,
 @LastLoginDate datetime = NULL,
 @DateAdded datetime = NULL,
 @DateEdited datetime = NULL,
 @UseridAdded varchar(50) = NULL,
 @UseridEdited varchar(50) = NULL,
 @Active bit,
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
  [Active],
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
  @Active,
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


CREATE PROCEDURE [dbo].[proc_WebUser_Update]
(
 @WebUserID int,
 @UserID varchar(100) = NULL,
 @Password varchar(200) = NULL,
 @LastLoginDate datetime = NULL,
 @DateAdded datetime = NULL,
 @DateEdited datetime = NULL,
 @UseridAdded varchar(50) = NULL,
 @UseridEdited varchar(50) = NULL,
 @Active bit,
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
  [Active] = @Active,
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

DROP PROCEDURE [proc_ValidateUserNew]
GO


CREATE PROCEDURE [dbo].[proc_ValidateUserNew]

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
  AND tblWebUser.Active = 1
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
  AND tblWebUser.Active = 1
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
  AND tblWebUser.Active = 1
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
  AND tblWebUser.Active = 1
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
  AND tblWebUser.Active = 1
END

GO

DROP PROCEDURE [proc_FixWebUsers]
GO


CREATE PROCEDURE [dbo].[proc_FixWebUsers]

AS

--CLIENT CLEANUP
--update tblWebUserAccount with correct usercode
DECLARE @code NCHAR(20)
DECLARE @id NCHAR(20)
DECLARE @string NCHAR(500)
DECLARE @recCount int
SET @recCount = (SELECT COUNT(clientcode) FROM tblClient INNER JOIN tblWebUserAccount ON tblClient.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblClient.clientcode AND tblWebUserAccount.UserType = 'CL')
IF @recCount > 0
 BEGIN
  DECLARE reclist CURSOR FOR
  SELECT clientcode, tblClient.webuserid FROM tblClient INNER JOIN tblWebUserAccount ON tblClient.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblClient.clientcode AND tblWebUserAccount.UserType = 'CL'
  OPEN reclist
  FETCH NEXT FROM reclist 
  INTO @code, @id
  WHILE @@FETCH_STATUS = 0
  BEGIN

   SET @string = 'update tblWebUserAccount set usercode = ' + RTRIM(@code) + ' where webuserid = ' + RTRIM(@id) + ' and tblWebUserAccount.IsUser = 1'
   EXEC sp_executesql @string
   --PRINT @string

    FETCH NEXT FROM reclist 
   INTO @code, @id
  END
  CLOSE reclist
  DEALLOCATE reclist 
 END
--set records with invalid webuserid to null
UPDATE tblClient SET webuserid = NULL WHERE webuserid NOT IN (SELECT DISTINCT webuserid FROM tblWebUser)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--CCADDRESS CLEANUP
--update tblWebUserAccount with correct usercode
SET @recCount = (SELECT COUNT(cccode) FROM tblCCaddress INNER JOIN tblWebUserAccount ON tblCCaddress.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblCCaddress.cccode AND tblWebUserAccount.UserType = 'AT')
IF @recCount > 0
 BEGIN
  DECLARE reclist CURSOR FOR
  SELECT cccode, tblCCaddress.webuserid FROM tblCCaddress INNER JOIN tblWebUserAccount ON tblCCaddress.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblCCaddress.cccode AND tblWebUserAccount.UserType = 'AT'
  OPEN reclist
  FETCH NEXT FROM reclist 
  INTO @code, @id
  WHILE @@FETCH_STATUS = 0
  BEGIN

   SET @string = 'update tblWebUserAccount set usercode = ' + RTRIM(@code) + ' where webuserid = ' + RTRIM(@id) + ' and tblWebUserAccount.IsUser = 1'
   EXEC sp_executesql @string
   --PRINT @string

    FETCH NEXT FROM reclist 
   INTO @code, @id
  END
  CLOSE reclist
  DEALLOCATE reclist
 END
--set records with invalid webuserid to null
UPDATE tblCCAddress SET webuserid = NULL WHERE webuserid NOT IN (SELECT DISTINCT webuserid FROM tblWebUser)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--DOCTOR CLEANUP
--update tblWebUserAccount with correct usercode
SET @recCount = (SELECT COUNT(doctorcode) FROM tblDoctor INNER JOIN tblWebUserAccount ON tblDoctor.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblDoctor.doctorcode AND tblWebUserAccount.UserType IN ('DR', 'OP'))
IF @recCount > 0
 BEGIN
  DECLARE reclist CURSOR FOR
  SELECT doctorcode, tblDoctor.webuserid FROM tblDoctor INNER JOIN tblWebUserAccount ON tblDoctor.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblDoctor.doctorcode AND tblWebUserAccount.UserType IN ('DR', 'OP')
  OPEN reclist
  FETCH NEXT FROM reclist 
  INTO @code, @id
  WHILE @@FETCH_STATUS = 0
  BEGIN

   SET @string = 'update tblWebUserAccount set usercode = ' + RTRIM(@code) + ' where webuserid = ' + RTRIM(@id) + ' and tblWebUserAccount.IsUser = 1'
   EXEC sp_executesql @string
   --PRINT @string

    FETCH NEXT FROM reclist 
   INTO @code, @id
  END
  CLOSE reclist
  DEALLOCATE reclist
 END
--set records with invalid webuserid to null
UPDATE tblDoctor SET webuserid = NULL WHERE webuserid NOT IN (SELECT DISTINCT webuserid FROM tblWebUser)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--TRANS CLEANUP
--update tblWebUserAccount with correct usercode
SET @recCount = (SELECT COUNT(Transcode) FROM tblTranscription INNER JOIN tblWebUserAccount ON tblTranscription.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblTranscription.Transcode AND tblWebUserAccount.UserType = 'TR')
IF @recCount > 0
 BEGIN
  DECLARE reclist CURSOR FOR
  SELECT Transcode, tblTranscription.webuserid FROM tblTranscription INNER JOIN tblWebUserAccount ON tblTranscription.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblTranscription.Transcode AND tblWebUserAccount.UserType = 'TR'
  OPEN reclist
  FETCH NEXT FROM reclist 
  INTO @code, @id
  WHILE @@FETCH_STATUS = 0
  BEGIN

   SET @string = 'update tblWebUserAccount set usercode = ' + RTRIM(@code) + ' where webuserid = ' + RTRIM(@id) + ' and tblWebUserAccount.IsUser = 1'
   EXEC sp_executesql @string
   --PRINT @string

    FETCH NEXT FROM reclist 
   INTO @code, @id
  END
  CLOSE reclist
  DEALLOCATE reclist
 END
--set records with invalid webuserid to null
UPDATE tblTranscription SET webuserid = NULL WHERE webuserid NOT IN (SELECT DISTINCT webuserid FROM tblWebUser)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--WEBUSER CLEANUP
--delete any webuseraccount records with invalid webuserid
DELETE FROM tblWebUserAccount WHERE webuserid NOT IN (SELECT webuserid FROM tblWebUser) --clean up

--delete all webuser records with an invalid imecentriccode
DELETE FROM tblWebUser WHERE imecentriccode NOT IN 
(
SELECT cccode FROM tblCCAddress
UNION
SELECT clientcode FROM tblClient
UNION
SELECT transcode FROM tblTranscription
UNION
SELECT doctorcode FROM tblDoctor
)
AND userid <> 'admin'

--delete all webuseraccount records with an invalid usercode
DELETE FROM tblWebUserAccount WHERE UserCode NOT IN 
(
SELECT cccode FROM tblCCAddress
UNION
SELECT clientcode FROM tblClient
UNION
SELECT transcode FROM tblTranscription
UNION
SELECT doctorcode FROM tblDoctor
)
AND webuserid <> 999999


GO


--Data Changes

UPDATE tblUser SET password=''
GO

INSERT INTO tblWebUserStatus (StatusID, Description) VALUES  (1, 'Active')
INSERT INTO tblWebUserStatus (StatusID, Description) VALUES  (2, 'Inactive')
INSERT INTO tblWebUserStatus (StatusID, Description) VALUES  (3, 'Activation Pending')
INSERT INTO tblWebUserStatus (StatusID, Description) VALUES  (4, 'Password Reset Pending')
INSERT INTO tblWebUserStatus (StatusID, Description) VALUES  (5, 'Locked')
INSERT INTO tblWebUserStatus (StatusID, Description) VALUES  (6, 'Re-Activation Pending')
GO

UPDATE tblWebUser SET StatusID=1
GO

UPDATE tblIMEData SET
 ATSecurityProfileID=2,
 CLSecurityProfileID=1,
 DRSecurityProfileID=2,
 OPSecurityProfileID=2,
 TRSecurityProfileID=2
GO

INSERT INTO tbluserfunction (functioncode, functiondesc)
 SELECT 'CompanySetSecurityProfile', 'Company - Set Security Profile'
 WHERE NOT EXISTS (SELECT functionCode FROM tblUserFunction WHERE functionCode='CompanySetSecurityProfile')
GO

INSERT INTO tbluserfunction (functioncode, functiondesc)
 SELECT 'WebPasswordResetOverride', 'Web Portal - Reset Password within Min Pwd Age'
 WHERE NOT EXISTS (SELECT functionCode FROM tblUserFunction WHERE functionCode='WebPasswordResetOverride')
GO








UPDATE tblControl SET DBVersion = '1.36'
GO