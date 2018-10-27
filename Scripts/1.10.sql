CREATE PROCEDURE [proc_GetOfficeComboItems]

AS

SELECT [Officecode], [description] FROM [tblOffice] 
WHERE PublishOnWeb = 1
ORDER BY [description]

GO


CREATE PROCEDURE proc_CalcNonWorkDay

@BeginDate datetime,
@EndDate datetime

AS

select nonworkday from tblnonworkdays where nonworkday >= @BeginDate and nonworkday <= @EndDate


GO

DROP PROCEDURE [spCaseDocuments]
GO


CREATE PROCEDURE [dbo].[spCaseDocuments](@casenbr integer)
AS
 SELECT casenbr, document, type, description, sfilename, dateadded, useridadded, PublishOnWeb, dateedited,
  useridedited, seqno, PublishedTo, Source, FileSize
 FROM dbo.tblCaseDocuments
 WHERE (casenbr = @casenbr) AND (type <> 'Report')
 ORDER BY dateadded DESC


GO

DROP PROCEDURE [spCaseReports]
GO



CREATE PROCEDURE [dbo].[spCaseReports](@casenbr integer)
AS SELECT     TOP 100 PERCENT casenbr, document, type, description, sfilename, dateadded, useridadded, reporttype, PublishOnWeb, dateedited, useridedited, 
                      seqno, PublishedTo, Source, FileSize
FROM         dbo.tblCaseDocuments
WHERE     (casenbr = @casenbr) AND (type = 'Report')
ORDER BY dateadded DESC


GO

DROP PROCEDURE [proc_GetProviderSearch]
GO


CREATE PROCEDURE [proc_GetProviderSearch]

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
        ISNULL(lastname, '') + ', ' + ISNULL(firstname, '') + ' ' + ISNULL(credentials, '') AS doctorname 
        FROM tblDoctor
        LEFT JOIN tblDoctorSpecialty ON tblDoctor.doctorcode = tblDoctorSpecialty.doctorcode
        LEFT JOIN tblSpecialty ON tblDoctorSpecialty.specialtycode = tblSpecialty.specialtycode
        LEFT JOIN tbldoctordocuments ON tblDoctor.doctorcode = tbldoctordocuments.doctorcode AND tbldoctordocuments.publishonweb = 1
        LEFT JOIN tblDoctorKeyWord ON tblDoctor.doctorcode = tblDoctorKeyWord.doctorcode
        LEFT JOIN tblDoctorLocation ON tblDoctor.doctorcode = tblDoctorLocation.doctorcode
        LEFT JOIN tblLocation ON tblDoctorLocation.locationcode = tblLocation.locationcode
        WHERE (tblDoctor.status = 'Active') AND (OPType = 'DR') AND (tblDoctor.publishonweb = 1) AND (tblLocation.locationcode is not null)

SET @Err = @@Error
RETURN @Err
 


GO

DROP PROCEDURE [proc_GetDoctorLocationsAndSchedule]
GO


CREATE PROCEDURE [dbo].[proc_GetDoctorLocationsAndSchedule]

@DoctorCode int = NULL,
@ApptDate datetime = NULL

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT DISTINCT tblLocation.locationcode, 
  tblLocation.location, 
  tblLocation.location as locname, 
  tblLocation.addr1 + '  ' + tblLocation.city + '  ' + tblLocation.state + ' ' + ISNULL(tblLocation.zip, '') as locaddress,
  ISNULL(tblLocation.County, '') + ' County ' as loccounty
  FROM tbllocation
  INNER JOIN tblDoctorLocation ON tblLocation.locationcode = tblDoctorLocation.locationcode AND tblDoctorLocation.PublishOnWeb = 1
  INNER JOIN tblDoctor ON tblDoctorLocation.doctorcode = tblDoctor.doctorcode AND tblDoctor.publishonweb = 1
  INNER JOIN tblDoctorSchedule ON tblDoctor.doctorcode = tblDoctorSchedule.doctorcode
  INNER JOIN tblDoctorOffice ON tblDoctor.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 3
  WHERE tblLocation.insidedr = 1
  AND tblDoctor.DoctorCode = COALESCE(@DoctorCode,tblDoctor.DoctorCode) 
  AND tblDoctorSchedule.date = COALESCE(@ApptDate,tblDoctorSchedule.date) 

 SET @Err = @@Error

 RETURN @Err
END


GO


update tblControl set DBVersion='1.10'
GO