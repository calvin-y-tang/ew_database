CREATE VIEW [dbo].[vwDoctorDocument]
AS
SELECT  tblEWDrDocType.Name AS TYPE,
        tblDoctorDocuments.description ,
        tblDoctorDocuments.expiredate ,
        tblDoctor.lastname ,
        tblDoctor.firstname ,
        tblDoctor.prefix ,
        tblDoctor.addr1 ,
        tblDoctor.addr2 ,
        tblDoctor.city ,
        tblDoctor.state ,
        tblDoctor.zip ,
        tblDoctor.phone ,
        tblDoctor.phoneExt ,
        tblDoctor.faxNbr ,
        tblDoctor.emailAddr ,
        tblDoctorOffice.officecode ,
        tblDoctor.status ,
        ISNULL(tblDoctor.credentials, '') AS Credentials
FROM    tblDoctorDocuments
        INNER JOIN tblDoctor ON tblDoctorDocuments.doctorcode = tblDoctor.doctorcode
        INNER JOIN tblDoctorOffice ON tblDoctor.doctorcode = tblDoctorOffice.doctorcode
        LEFT OUTER JOIN tblEWDrDocType ON tblDoctorDocuments.EWDrDocTypeID=tblEWDrDocType.EWDrDocTypeID

