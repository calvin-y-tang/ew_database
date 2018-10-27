PRINT N'Creating [dbo].[tblServiceIncludeExclude]...';


GO
CREATE TABLE [dbo].[tblServiceIncludeExclude] (
    [Code]        INT          NOT NULL,
    [Type]        VARCHAR (2)  NOT NULL,
    [ServiceCode] INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (30) NULL,
    CONSTRAINT [PK_tblServiceIncludeExclude] PRIMARY KEY CLUSTERED ([Code] ASC, [Type] ASC, [ServiceCode] ASC)
);


GO






PRINT N'Altering [dbo].[proc_GetProviderSearch]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [proc_GetProviderSearch]

@clientCode int,
@companyCode int

AS

SET NOCOUNT OFF
DECLARE @Err int


	SELECT DISTINCT
		tblLocation.locationcode,
		tbldoctor.lastname,
		tblDoctor.firstname,
		tbldoctor.credentials,
		tblSpecialty.description specialty,
		tblSpecialty.specialtycode,
		tblLocation.zip,
		tblLocation.city,
		tblLocation.location,
		tblLocation.state,
		tbldoctor.prepaid,
		tblLocation.county,
		tblLocation.phone,
		tblDoctor.ProvTypeCode,
		tblDoctorKeyword.keywordID,
		tblDoctor.doctorcode,
		'' as Proximity,
		ISNULL(lastname, '') + ', ' + ISNULL(firstname, '') + ' ' + ISNULL(credentials, '') AS doctorname
		FROM tblDoctor
		LEFT JOIN tblDoctorSpecialty ON tblDoctor.doctorcode = tblDoctorSpecialty.doctorcode
		LEFT JOIN tblSpecialty ON tblDoctorSpecialty.specialtycode = tblSpecialty.specialtycode
		LEFT JOIN tbldoctordocuments ON tblDoctor.doctorcode = tbldoctordocuments.doctorcode AND tbldoctordocuments.publishonweb = 1
		LEFT JOIN tblDoctorKeyWord ON tblDoctor.doctorcode = tblDoctorKeyWord.doctorcode
		LEFT JOIN tblDoctorLocation ON tblDoctor.doctorcode = tblDoctorLocation.doctorcode AND tblDoctorLocation.publishonweb = 1
		LEFT JOIN tblLocation ON tblDoctorLocation.locationcode = tblLocation.locationcode
		WHERE (tblDoctor.status = 'Active')
		AND (OPType = 'DR') AND (tblDoctor.publishonweb = 1)
		AND (tblLocation.locationcode is not null)
		AND (tblLocation.Status = 'Active')
		AND (tblDoctor.DoctorCode NOT IN (SELECT DoctorCode FROM tblDrDoNotUse WHERE Code = @ClientCode AND tblDrDoNotUse.DoctorCode = tblDoctor.DoctorCode AND Type = 'CL'))
		AND (tblDoctor.DoctorCode NOT IN (SELECT DoctorCode FROM tblDrDoNotUse WHERE Code = @CompanyCode AND tblDrDoNotUse.DoctorCode = tblDoctor.DoctorCode AND Type = 'CO'))

SET @Err = @@Error
RETURN @Err
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[proc_Service_LoadComboByOfficeCode]...';


GO
ALTER PROCEDURE [proc_Service_LoadComboByOfficeCode]

@OfficeCode nvarchar(100),
@ParentCompanyID int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @ServiceIncludeExclude bit

	SET @ServiceIncludeExclude = (SELECT ServiceIncludeExclude FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)

	DECLARE @strSQL nvarchar(800)

	SET @StrSQL = N'SELECT DISTINCT tblServices.ServiceCode, tblServices.Description FROM tblServices ' +
	'INNER JOIN tblServiceOffice on tblServices.servicecode = tblServiceOffice.servicecode ' +
	'WHERE tblServices.PublishOnWeb = 1 ' +
	'AND tblServiceOffice.OfficeCode IN(' + @OfficeCode + ') '

	IF (@ServiceIncludeExclude = 1)
		SET @StrSQL = @StrSQL + 'AND tblServices.ServiceCode IN (SELECT ServiceCode FROM tblServiceIncludeExclude WHERE tblServiceIncludeExclude.Type = ''PC'' AND tblServiceIncludeExclude.Code = ' + CAST(@ParentCompanyID AS VARCHAR(40)) + ') '
	ELSE IF (@ServiceIncludeExclude = 0)
		SET @StrSQL = @StrSQL + 'AND tblServices.ServiceCode NOT IN (SELECT ServiceCode FROM tblServiceIncludeExclude WHERE tblServiceIncludeExclude.Type = ''PC'' AND tblServiceIncludeExclude.Code = ' + CAST(@ParentCompanyID AS VARCHAR(40)) + ') '

	SET @StrSQL = @StrSQL + 'ORDER BY Description'

	BEGIN
	  EXEC SP_EXECUTESQL @StrSQL
	END

	SET @Err = @@Error

	RETURN @Err
END
GO






INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (13, 'PC', 960, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (15, 'PC', 960, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (18, 'PC', 960, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (19, 'PC', 960, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (20, 'PC', 960, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (25, 'PC', 960, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (31, 'PC', 960, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (37, 'PC', 960, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (44, 'PC', 960, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (52, 'PC', 960, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (59, 'PC', 960, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (60, 'PC', 960, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (92, 'PC', 960, getdate(), 'GR')

INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (33, 'PC', 2070, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (33, 'PC', 360, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (33, 'PC', 3160, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (33, 'PC', 310, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (33, 'PC', 330, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (33, 'PC', 350, getdate(), 'GR')
INSERT INTO tblServiceIncludeExclude (Code, Type, ServiceCode, DateAdded, UserIDAdded) VALUES (33, 'PC', 2350, getdate(), 'GR')

INSERT INTO tblMessageToken (Name, Description)
VALUES('@CaseTypeDesc@', '')
GO

INSERT INTO tblMessageToken (Name, Description)
VALUES('@ServiceDesc@', '')
GO


INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (0, 'New')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (10, 'Ready for Submit')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (20, 'Submitted')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (30, 'Processing')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (70, 'Combined')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (80, 'Complete')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (85, 'Pending for Cancel')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (90, 'Canceled')
GO


insert into tblUserFunction 
values 
('DeletePhysicalFile','Case – Delete Physical Documents')
GO



UPDATE tblControl SET DBVersion='3.07'
GO