ALTER TABLE [dbo].[tblUser] DROP CONSTRAINT [PK_tblUser]
GO
ALTER TABLE [dbo].[tblUser] ADD CONSTRAINT [PK_tblUser] PRIMARY KEY CLUSTERED ([SeqNo])
GO
DROP INDEX [IX_tblDocument_Document]  ON [dbo].[tblDocument];
GO
DROP INDEX [IX_U_tblUser_UserIDUserType] ON [dbo].[tblUser] 
GO


PRINT N'Creating [dbo].[tblUser].[IX_U_tblUser_UserIDUserType]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblUser_UserIDUserType]
    ON [dbo].[tblUser]([UserID] ASC, [UserType] ASC);


GO
PRINT N'Creating [dbo].[tblDocument].[IX_U_tblDocument_Document]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblDocument_Document]
    ON [dbo].[tblDocument]([Document] ASC);


GO
PRINT N'Altering [dbo].[vwDoctorSchedule]...';


GO
ALTER VIEW vwDoctorSchedule
AS
     select  tblDoctorSchedule.SchedCode ,
			tblDoctorSchedule.LocationCode ,
            tblDoctorSchedule.date,
            tblDoctorSchedule.StartTime, 
            tblDoctorSchedule.Description ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.DoctorCode ,            
            tblCase.CaseNbr , 
			tblCase.ExtCaseNbr , 
            tblCompany.ExtName AS Company ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName ,
            tblLocation.Location ,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS Casetypedesc ,
			tblCaseType.EWBusLineID, 
            tblServices.Description AS Servicedesc ,
            CAST(tblCase.SpecialInstructions AS VARCHAR(1000)) AS specialinstructions ,
            tblCase.WCBNbr ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.Fax AS DoctorFax ,
            tblCase.PhotoRqd ,
            tblClient.Phone1 AS ClientPhone ,
            tblCase.DoctorName AS Paneldesc ,
            tblCase.PanelNbr ,
            NULL AS Panelnote ,
            tblCase.OfficeCode ,
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblEWFacility.Fax ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
			CASE WHEN tblCase.LanguageID > 0 THEN tblLanguage.Description
				ELSE ''
			END AS [Language],
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName ,
            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = tblCase.CaseNbr
                      ) = 'F' THEN 'Films'
                 ELSE ''
            END AS films
from tblDoctorSchedule 
	inner join tblDoctor on tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode	
	inner join tblLocation on tblDoctorSchedule.LocationCode = tblLocation.LocationCode
	left outer join tblCase
		inner join tblClient on tblCase.ClientCode = tblClient.ClientCode
		inner join tblCompany on tblClient.CompanyCode = tblCompany.CompanyCode
		inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
		inner join tblEWFacility on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
		inner join tblServices on tblCase.ServiceCode = tblServices.ServiceCode 
		inner join tblExaminee on tblCase.ChartNbr = tblExaminee.ChartNbr
		inner join tblCaseType on tblCase.CaseType = tblCaseType.Code
		left outer join tblLanguage on tblLanguage.LanguageID = tblcase.LanguageID
	on tblDoctorSchedule.SchedCode = tblCase.SchedCode	
    UNION
    SELECT tblDoctorSchedule.SchedCode ,
			tblDoctorSchedule.LocationCode ,
            tblDoctorSchedule.date,
            tblDoctorSchedule.StartTime, 
            tblDoctorSchedule.Description ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.DoctorCode ,            
            tblCase.CaseNbr , 
			tblCase.ExtCaseNbr , 
            tblCompany.ExtName AS Company ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName ,
            tblLocation.Location ,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS Casetypedesc , 
			tblCaseType.EWBusLineID, 
            tblServices.Description AS Servicedesc ,
            CAST(tblCase.SpecialInstructions AS VARCHAR(1000)) AS specialinstructions ,
            tblCase.WCBNbr ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.Fax AS DoctorFax ,
            tblCase.PhotoRqd ,
            tblClient.Phone1 AS ClientPhone ,
            tblCase.DoctorName AS Paneldesc ,
            tblCase.PanelNbr ,
            NULL AS Panelnote ,
            tblCase.OfficeCode ,
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblEWFacility.Fax ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
			CASE WHEN tblCase.LanguageID > 0 THEN tblLanguage.Description
				ELSE ''
			END AS [Language],
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName ,
            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = tblCase.CaseNbr
                      ) = 'F' THEN 'Films'
                 ELSE ''
            END AS films
    FROM    tblDoctorSchedule 
				inner join tblDoctor on tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode	
				inner join tblLocation on tblDoctorSchedule.LocationCode = tblLocation.LocationCode
				inner join tblCasePanel on tblDoctorSchedule.SchedCode = tblCasePanel.SchedCode
				left outer join tblCase
					inner join tblClient on tblCase.ClientCode = tblClient.ClientCode
					inner join tblCompany on tblClient.CompanyCode = tblCompany.CompanyCode
					inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
					inner join tblEWFacility on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
					inner join tblServices on tblCase.ServiceCode = tblServices.ServiceCode 
					inner join tblExaminee on tblCase.ChartNbr = tblExaminee.ChartNbr
					inner join tblCaseType on tblCase.CaseType = tblCaseType.Code		
					left outer join tblLanguage on tblLanguage.LanguageID = tblcase.LanguageID			
				on tblCasePanel.PanelNbr = tblCase.PanelNbr
    WHERE   tblCase.PanelNbr IS NOT NULL
GO
PRINT N'Altering [dbo].[proc_CCAddress_Insert]...';


GO
ALTER PROCEDURE [proc_CCAddress_Insert]
(
	@cccode int = NULL output,
	@prefix varchar(5) = NULL,
	@lastname varchar(50) = NULL,
	@firstname varchar(50) = NULL,
	@company varchar(70) = NULL,
	@address1 varchar(50) = NULL,
	@address2 varchar(50) = NULL,
	@city varchar(50) = NULL,
	@state varchar(2) = NULL,
	@zip varchar(15) = NULL,
	@phone varchar(15) = NULL,
	@phoneextension varchar(15) = NULL,
	@fax varchar(15) = NULL,
	@email varchar(70) = NULL,
	@status varchar(10) = NULL,
	@useridadded varchar(15) = NULL,
	@dateadded datetime = NULL,
	@useridedited varchar(15) = NULL,
	@dateedited datetime = NULL,
	@WebUserID int = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCCAddress]
	(
		[prefix],
		[lastname],
		[firstname],
		[company],
		[address1],
		[address2],
		[city],
		[state],
		[zip],
		[phone],
		[phoneextension],
		[fax],
		[email],
		[status],
		[useridadded],
		[dateadded],
		[useridedited],
		[dateedited],
		[WebUserID]
	)
	VALUES
	(
		@prefix,
		@lastname,
		@firstname,
		@company,
		@address1,
		@address2,
		@city,
		@state,
		@zip,
		@phone,
		@phoneextension,
		@fax,
		@email,
		@status,
		@useridadded,
		@dateadded,
		@useridedited,
		@dateedited,
		@WebUserID
	)

	SET @Err = @@Error

	SELECT @cccode = SCOPE_IDENTITY()

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_CCAddress_Update]...';


GO
ALTER PROCEDURE [proc_CCAddress_Update]
(
	@cccode int,
	@prefix varchar(5) = NULL,
	@lastname varchar(50) = NULL,
	@firstname varchar(50) = NULL,
	@company varchar(70) = NULL,
	@address1 varchar(50) = NULL,
	@address2 varchar(50) = NULL,
	@city varchar(50) = NULL,
	@state varchar(2) = NULL,
	@zip varchar(15) = NULL,
	@phone varchar(15) = NULL,
	@phoneextension varchar(15) = NULL,
	@fax varchar(15) = NULL,
	@email varchar(70) = NULL,
	@status varchar(10) = NULL,
	@useridadded varchar(15) = NULL,
	@dateadded datetime = NULL,
	@useridedited varchar(15) = NULL,
	@dateedited datetime = NULL,
	@WebUserID int = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCCAddress]
	SET
		[prefix] = @prefix,
		[lastname] = @lastname,
		[firstname] = @firstname,
		[company] = @company,
		[address1] = @address1,
		[address2] = @address2,
		[city] = @city,
		[state] = @state,
		[zip] = @zip,
		[phone] = @phone,
		[phoneextension] = @phoneextension,
		[fax] = @fax,
		[email] = @email,
		[status] = @status,
		[useridadded] = @useridadded,
		[dateadded] = @dateadded,
		[useridedited] = @useridedited,
		[dateedited] = @dateedited,
		[WebUserID] = @WebUserID
	WHERE
		[cccode] = @cccode


	SET @Err = @@Error


	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_CCAddress_GetDefaultOffice]...';


GO
CREATE PROCEDURE [proc_CCAddress_GetDefaultOffice]
(
	@cccode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT  STUFF((SELECT  ',' + cast(officecode as varchar(200))
            FROM tblCCAddressOffice TCO
            WHERE  TCO.cccode=TC.cccode
            ORDER BY cccode
        FOR XML PATH('')), 1, 1, '') AS listStr

	FROM tblCCAddressOffice TC
	Where cccode = @cccode
	GROUP BY TC.cccode

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_Doctor_GetDefaultOffice]...';


GO
CREATE PROCEDURE [proc_Doctor_GetDefaultOffice]
(
	@DoctorCode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT  STUFF((SELECT  ',' + cast(officecode as varchar(200))
            FROM tblDoctorOffice TCO
            WHERE  TCO.DoctorCode=TC.DoctorCode
            ORDER BY DoctorCode
        FOR XML PATH('')), 1, 1, '') AS listStr

	FROM tblDoctorOffice TC
	Where DoctorCode = @DoctorCode
	GROUP BY TC.DoctorCode

	SET @Err = @@Error

	RETURN @Err
END
GO


UPDATE tblControl SET DBVersion='2.90'
GO