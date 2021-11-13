PRINT N'Altering [dbo].[tblAddressAbbreviation]...';


GO
ALTER TABLE [dbo].[tblAddressAbbreviation]
    ADD [ForAddressLine] BIT CONSTRAINT [DF_tblAddressAbbreviation_ForAddressLine] DEFAULT ((0)) NOT NULL,
        [ForCity]        BIT CONSTRAINT [DF_tblAddressAbbreviation_ForCity] DEFAULT ((0)) NOT NULL;


GO
ALTER TABLE [dbo].[tblDPSBundle]
    ADD [ExtDocumentID] VARCHAR (100) NULL,
        [DPSPriorityID] INT           NULL;


GO
PRINT N'Altering [dbo].[tblEWFlashCategory]...';


GO
ALTER TABLE [dbo].[tblEWFlashCategory]
    ADD [Mapping7] VARCHAR (10) NULL;


GO
PRINT N'Creating [dbo].[tblDPSPriority]...';


GO
CREATE TABLE [dbo].[tblDPSPriority] (
    [DPSPriorityID]   INT          IDENTITY (1, 1) NOT NULL,
    [Name]            VARCHAR (25) NULL,
    [ExtPriorityCode] VARCHAR (10) NULL,
    CONSTRAINT [PK_tblDPSPriority] PRIMARY KEY CLUSTERED ([DPSPriorityID] ASC)
);


GO
PRINT N'Altering [dbo].[vwPDFDoctorData]...';


GO
ALTER VIEW vwPDFDoctorData
AS
    SELECT  DoctorCode ,
			LTRIM(RTRIM(ISNULL(firstName,'') + ' ' + ISNULL(lastName,'') + ' ' + ISNULL(credentials,''))) AS DoctorFullName ,
			[Credentials] AS DoctorDegree ,

            NPINbr AS DoctorNPINbr ,
			CASE WHEN ISNULL(NPINbr, '') = '' THEN '99999' ELSE NPINbr END AS DoctorNPINbr99999,
			B.BlankValue AS	DoctorWALINbr ,
            LicenseNbr AS DoctorLicense ,
			CASE WHEN ISNULL(LicenseNbr,'')='' THEN '' ELSE '0B' END AS DoctorLicenseQualID ,
			CASE WHEN ISNULL(LicenseNbr,'')='' THEN '' ELSE '0B ' + LicenseNbr END AS DoctorLicenseWithQualPrefix ,
			LEFT(LicenseNbr, 2) + RIGHT(LicenseNbr, 2) AS TexasDoctorLicenseType ,
            
			Addr1 AS DoctorCorrespAddr1 ,
            Addr2 AS DoctorCorrespAddr2 ,
            City + ', ' + State + '  ' + Zip AS DoctorCorrespCityStateZip ,

			B.BlankValueLong AS DoctorCorrespFullAddress ,

			USDVarchar1 AS DoctorUSDVarchar1 ,
			USDVarchar2 AS DoctorUSDVarchar2 ,
			USDText1 AS DoctorUSDText1 ,
			USDText2 AS DoctorUSDText2 ,

            
			Phone + ' ' + ISNULL(PhoneExt, '') AS DoctorCorrespPhone ,
			Phone AS DoctorCorrespPhoneAreaCode ,
			Phone AS DoctorCorrespPhoneNumber , 

			TXMTaxID AS DoctorTXMTaxID , 
			SORMTaxID AS DoctorSORMTaxID , 
			TXMProviderName AS DoctorTXMProviderName , 
			SORMProviderName AS DoctorSORMProviderName 

    FROM    tblDoctor
			LEFT OUTER JOIN tblBlank AS B ON 1=1
GO

INSERT INTO tblSetting (Name, Value) Values ('ESISInvoiceDiscountThreshold','12')
GO
INSERT INTO tblSetting VALUES ('ESISInvoiceChangeStartDate', '2017/06/01')
GO


INSERT INTO tblUserFunction VALUES ('ESISInvoice', 'ESIS - Invoicing Override')
GO
 Insert into tblUserFunction 
 values 
 ('ApptSearchInactiveDoctor','Case - Search for Inactive Doctor')
GO













PRINT N'Altering [dbo].[spAvailableDoctors]...';


GO
ALTER PROCEDURE [dbo].[spAvailableDoctors]
    @startdate AS DATETIME ,
    @doctorcode AS INTEGER ,
    @locationcode AS INTEGER ,
    @city AS VARCHAR(50) ,
    @state AS VARCHAR(2) ,
    @vicinity AS VARCHAR(50) ,
    @county AS VARCHAR(50) ,
    @degree AS VARCHAR(50) ,
    @KeyWordIDs AS VARCHAR(100) ,
    @Specialties AS VARCHAR(200) ,
    @PanelExam AS BIT ,
    @ProvTypeCode AS INTEGER ,
    @EWAccreditationID AS INTEGER, 
	@IncludeInactiveDoctor AS BIT
AS 
    DECLARE @sColumns VARCHAR(2000)
    DECLARE @sFrom VARCHAR(2000)
    DECLARE @sWhere VARCHAR(2000)
    DECLARE @sGroupBy VARCHAR(2000)
    DECLARE @sHaving VARCHAR(2000)
    DECLARE @sSqlString NVARCHAR(4000)
    DECLARE @sOrderBy VARCHAR(1000)


    SET @sColumns = 'dbo.tblDoctor.lastname + '', '' + isnull(dbo.tblDoctor.firstname,'''') AS doctorname, dbo.tblDoctor.status, '
        + 'dbo.tblDoctorLocation.schedulethru, dbo.tblLocation.location, MIN(dbo.tblDoctorSchedule.date) AS firstavail, dbo.tblLocation.city, dbo.tblLocation.state, '
        + 'dbo.tblLocation.Phone, dbo.tblLocation.insidedr, dbo.tblDoctor.doctorcode, dbo.tblDoctor.schedulepriority, dbo.tblDoctorLocation.locationcode, '
        + 'dbo.tblDoctor.prepaid, dbo.tblLocation.vicinity, dbo.tblLocation.county, dbo.tblLocation.zip, dbo.tblDoctor.credentials AS degree, '
        + 'CASE WHEN MIN(dbo.tblDoctorSchedule.date) is null then 1 else 0 end AS sortorder, dbo.tbllocation.locationcode, dbo.tbldoctor.provtypecode, dbo.tbldoctor.optype  ' 
    SET @sFrom = 'FROM         dbo.tblLocation INNER JOIN '
        + 'dbo.tblDoctorLocation ON dbo.tblLocation.locationcode = dbo.tblDoctorLocation.locationcode LEFT OUTER JOIN '
        + 'dbo.tblDoctorSchedule ON dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode AND '
        + 'dbo.tblDoctorLocation.doctorcode = dbo.tblDoctorSchedule.doctorcode LEFT OUTER JOIN '
        + 'dbo.tblDoctor ON dbo.tblDoctorLocation.doctorcode = dbo.tblDoctor.doctorcode ' 

    SET @sWhere = ''
	
    SET @sGroupBy = 'GROUP BY ALL dbo.tblDoctor.status, dbo.tblDoctorLocation.schedulethru, dbo.tblLocation.location, dbo.tblLocation.city, dbo.tblLocation.state, '
        + 'dbo.tblLocation.Phone, dbo.tblLocation.insidedr, dbo.tblDoctor.doctorcode, dbo.tblDoctor.schedulepriority, dbo.tblDoctorLocation.locationcode, '
        + 'dbo.tblLocation.vicinity, dbo.tblDoctor.prepaid, dbo.tblDoctor.lastname + '', '' + ISNULL(dbo.tblDoctor.firstname, ''''), dbo.tblLocation.county, '
        + 'dbo.tblLocation.zip, dbo.tblDoctor.credentials, dbo.tblDoctorLocation.status,CASE WHEN (dbo.tblDoctorSchedule.date) is null then 1 else 0 end,dbo.tbllocation.locationcode,dbo.tbldoctor.provtypecode, dbo.tbldoctor.optype ' 

	-- Issue  5501 - JAP - allow for inclusion of inactive Doctors
	IF @IncludeInactiveDoctor IS NULL OR @IncludeInactiveDoctor = 0
	BEGIN
		-- Normal use which only includes active doctors
		SET @sHaving = 'HAVING (dbo.tblDoctor.status = ''Active'') AND '
			+ '(dbo.tblDoctorLocation.status = ''Active'') AND dbo.tbldoctor.OPType = ''DR'' '
	END
	ELSE
	BEGIN
		-- Need to include active and inactive doctors
		SET @sHaving = 'HAVING dbo.tbldoctor.OPType = ''DR'' '
	END

	SET @sOrderBy = ''

	--Use different where and having clause for panel exam
    IF @PanelExam IS NULL 
        BEGIN
            SET @sColumns = @sColumns
                + ', MIN(dbo.tblDoctorSchedule.starttime) AS starttime ' 

            SET @sWhere = 'WHERE ( (dbo.tblDoctorSchedule.date >= '''
                + CONVERT(VARCHAR, @startdate, 101)
                + ''' AND dbo.tblDoctorSchedule.status = ''Open'') OR '
                + '(dbo.tblDoctorSchedule.date IS NULL AND dbo.tblDoctorSchedule.status IS NULL)) '  

            SET @sOrderBy = 'ORDER BY dbo.tblDoctor.schedulepriority,CASE WHEN MIN(dbo.tblDoctorSchedule.date) is null then 1 else 0 end, MIN(dbo.tblDoctorSchedule.date), dbo.tblDoctor.lastname + '', '' + ISNULL(dbo.tblDoctor.firstname, '''') '
        END
    ELSE 
        BEGIN
            SET @sColumns = @sColumns
                + ', dbo.tblDoctorSchedule.starttime AS starttime, dbo.tbldoctorschedule.status, '
                + '(select count(*) from tbldoctorschedule a where a.locationcode = tbllocation.locationcode and '
                + 'a.starttime = tbldoctorschedule.starttime AND a.status = ''Open'') as apptcount '
            SET @sGroupBy = @sGroupBy
                + ', dbo.tblDoctorSchedule.starttime, dbo.tblDoctorSchedule.status '
            SET @sWhere = ' '  
            SET @sHaving = @sHaving
                + ' AND (dbo.tbldoctorschedule.starttime >= '''
                + CONVERT(VARCHAR, @startdate, 101)
                + ''' AND dbo.tblDoctorSchedule.status = ''Open'')  '
                + ' and (select count(*) from tbldoctorschedule a where a.locationcode = tbllocation.locationcode and '
                + ' a.starttime = tbldoctorschedule.starttime AND a.status = ''Open'') > 1 '
            SET @sOrderBy = 'ORDER BY dbo.tblDoctorSchedule.starttime, dbo.tbllocation.location, dbo.tblDoctor.lastname + '', '' + ISNULL(dbo.tblDoctor.firstname, ''''), dbo.tblSpecialty.description '
        END


	-- if specialties exist, add the appropriate statements to the select clause
    IF @Specialties IS NOT NULL 
        BEGIN
            SET @specialties = REPLACE(@Specialties, '*', '''')
            SET @sColumns = @sColumns
                + ', dbo.tblDoctorSpecialty.specialtycode, dbo.tblSpecialty.description '
            SET @sFrom = @sFrom
                + ' INNER JOIN dbo.tblDoctorSpecialty ON dbo.tblDoctorLocation.doctorcode = dbo.tblDoctorSpecialty.doctorcode INNER JOIN '
                + ' dbo.tblSpecialty ON dbo.tblDoctorSpecialty.specialtycode = dbo.tblSpecialty.specialtycode '
            SET @sGroupBy = @sGroupBy
                + ',dbo.tblDoctorSpecialty.specialtycode, dbo.tblSpecialty.description '
            SET @sHaving = @sHaving
                + ' AND (dbo.tblDoctorSpecialty.specialtycode in ('
                + @Specialties + ') ) '

        END
	-- if keywords exist, add the appropriate statements to the select clause
    IF @KeyWordIDs IS NOT NULL 
        BEGIN
            SET @sColumns = @sColumns
                + ', dbo.tblDoctorKeyWord.keywordID, dbo.tblKeyWord.keyword '
            SET @sFrom = @sFrom
                + 'INNER JOIN dbo.tblDoctorKeyWord ON dbo.tblDoctorLocation.doctorcode = dbo.tblDoctorKeyWord.doctorcode INNER JOIN '
                + 'dbo.tblKeyWord ON dbo.tblDoctorKeyWord.keywordID = dbo.tblKeyWord.keywordID '
            SET @sGroupBy = @sGroupBy
                + ',dbo.tblDoctorKeyWord.keywordID, dbo.tblKeyWord.keyword '
            SET @sHaving = @sHaving
                + ' AND (dbo.tblDoctorKeyWord.KeyWordID in (' + @KeywordIDs
                + ') ) '
        END




	--Filter data if parameter is supplied
    IF @doctorcode IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND ' + '(dbo.tbldoctor.doctorcode = '
                + CAST(@doctorcode AS VARCHAR(10)) + ') ' 
        END

    IF @locationcode IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND '
                + '(dbo.tbldoctorlocation.locationcode = '
                + CAST(@locationcode AS VARCHAR(10)) + ') ' 
        END
    IF @city IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND ' + '(dbo.tbllocation.city = '''
                + @city + ''') ' 
        END
    IF @state IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND ' + '(dbo.tbllocation.state = '''
                + @state + ''') ' 
        END

    IF @vicinity IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND '
                + '(dbo.tbllocation.vicinity = ''' + @vicinity + ''') ' 
        END

    IF @county IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND ' + '(dbo.tbllocation.county = '''
                + @county + ''') ' 
        END

    IF @degree IS NOT NULL 
        BEGIN

            SET @sHaving = @sHaving + ' AND '
                + '(dbo.tbldoctor.credentials = ''' + @degree + ''') ' 
        END

    IF @ProvtypeCode IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND '
                + '(dbo.tbldoctor.provtypecode = '
                + CAST(@ProvTypeCode AS VARCHAR(10)) + ') ' 
        END

	--Check for Accreditation        
    IF @EWAccreditationID IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND '
                + 'tblDoctor.DoctorCode in (SELECT DoctorCode FROM tblDoctorAccreditation WHERE EWAccreditationID='
                + CAST(@EWAccreditationID AS VARCHAR) + ')'
        END



-- build sql statement
    SET @sSqlString = 'SELECT DISTINCT TOP 100 PERCENT ' + @scolumns + ' '
        + @sFrom + ' ' + @swhere + ' ' + @sGroupby + ' ' + @sHaving + ' '
        + @sOrderby

   --print '@scolumns ' + @scolumns
   --print '@sfrom ' + @sfrom
   --print '@swhere ' + @swhere
   --print '@sgroupby ' + @sgroupby
   --print '@shaving ' + @shaving
   --print '@sorderby ' + @sorderby
   --print 'sqlstring ' +  @ssqlstring

-- execute sql statement
    EXEC Sp_executesql @sSqlString
GO








PRINT N'Altering [dbo].[tblDPSBundle]...';
GO
ALTER TABLE [dbo].[tblDPSBundle] DROP COLUMN [Priority];
GO







UPDATE tblControl SET DBVersion='3.10'
GO
