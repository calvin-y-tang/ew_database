
---------------------------------------------
--Correct spelling of interpreter
---------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwDoctorSchedule]
AS
SELECT      TOP 100 PERCENT dbo.tblDoctorSchedule.locationcode, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime, 
                        dbo.tblDoctorSchedule.description, dbo.tblDoctorSchedule.status, dbo.tblDoctorSchedule.doctorcode, dbo.tblDoctorSchedule.schedcode, 
                        dbo.tblCase.casenbr, dbo.tblCompany.extname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, 
                        dbo.tblLocation.location, dbo.tblIMEData.companyname, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') 
                        + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblCase.claimnbr, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, 
                        dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, CAST(dbo.tblCase.specialinstructions AS varchar(1000)) 
                        AS specialinstructions, dbo.tblCase.WCBNbr, dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.fax AS doctorfax, dbo.tblCase.photoRqd, 
                        dbo.tblClient.phone1 AS clientphone, dbo.tblCase.DoctorName AS paneldesc, dbo.tblCase.PanelNbr, NULL AS panelnote, 
                        CASE WHEN dbo.tblcase.casenbr IS NULL THEN dbo.tbldoctorschedule.casenbr1desc ELSE NULL END AS scheduledescription, 
                        tblservices.shortdesc, tblimedata.fax, CASE WHEN tblcase.interpreterrequired = 1 THEN 'Interpreter' ELSE '' END AS Interpreter, 
                        tblDoctorSchedule.duration, tblCompany.intname AS CompanyIntName
FROM          dbo.tblLocation INNER JOIN
                        dbo.tblDoctorSchedule INNER JOIN
                        dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode ON 
                        dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode LEFT OUTER JOIN
                        dbo.tblCaseType INNER JOIN
                        dbo.tblClient INNER JOIN
                        dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                        dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                        dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr ON dbo.tblCaseType.code = dbo.tblCase.casetype INNER JOIN
                        dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode ON 
                        dbo.tblDoctorSchedule.schedcode = dbo.tblCase.schedcode LEFT OUTER JOIN
                        dbo.tblIMEData INNER JOIN
                        dbo.tblOffice INNER JOIN
                        dbo.tblDoctorOffice ON dbo.tblOffice.officecode = dbo.tblDoctorOffice.officecode ON dbo.tblIMEData.IMEcode = dbo.tblOffice.imecode ON 
                        dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctorOffice.doctorcode
WHERE      (dbo.tblDoctorSchedule.status = 'open') OR
                        (dbo.tblDoctorSchedule.status = 'Hold') OR
                        ((dbo.tblDoctorSchedule.status = 'scheduled') AND (dbo.tblcase.schedcode IS NOT NULL))
UNION
SELECT      TOP 100 PERCENT dbo.tblDoctorSchedule.locationcode, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime, 
                        dbo.tblDoctorSchedule.description, dbo.tblDoctorSchedule.status, dbo.tblDoctorSchedule.doctorcode, dbo.tblDoctorSchedule.schedcode, 
                        dbo.tblCase.casenbr, dbo.tblCompany.extname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, 
                        dbo.tblLocation.location, dbo.tblIMEData.companyname, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') 
                        + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblCase.claimnbr, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, 
                        dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, CAST(dbo.tblCase.specialinstructions AS varchar(1000)) 
                        AS specialinstructions, dbo.tblCase.WCBNbr, dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.fax AS doctorfax, dbo.tblCase.photoRqd, 
                        dbo.tblClient.phone1 AS clientphone, dbo.tblCase.DoctorName AS paneldesc, dbo.tblCase.PanelNbr, CAST(dbo.tblCasePanel.panelnote AS varchar(50)) 
                        AS panelnote, CASE WHEN dbo.tblcase.casenbr IS NULL THEN dbo.tbldoctorschedule.casenbr1desc ELSE NULL END AS scheduledescription, 
                        tblservices.shortdesc, tblimedata.fax, CASE WHEN tblcase.interpreterrequired = 1 THEN 'Interpreter' ELSE '' END AS Interpreter, 
                        tblDoctorSchedule.duration, tblCompany.intname AS CompanyIntName
FROM          dbo.tblCaseType INNER JOIN
                        dbo.tblClient INNER JOIN
                        dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                        dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                        dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr ON dbo.tblCaseType.code = dbo.tblCase.casetype INNER JOIN
                        dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                        dbo.tblCasePanel ON dbo.tblCase.PanelNbr = dbo.tblCasePanel.panelnbr RIGHT OUTER JOIN
                        dbo.tblLocation INNER JOIN
                        dbo.tblDoctorSchedule INNER JOIN
                        dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode ON 
                        dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode ON 
                        dbo.tblCasePanel.schedcode = dbo.tblDoctorSchedule.schedcode LEFT OUTER JOIN
                        dbo.tblIMEData INNER JOIN
                        dbo.tblOffice INNER JOIN
                        dbo.tblDoctorOffice ON dbo.tblOffice.officecode = dbo.tblDoctorOffice.officecode ON dbo.tblIMEData.IMEcode = dbo.tblOffice.imecode ON 
                        dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctorOffice.doctorcode
WHERE      ((dbo.tblDoctorSchedule.status = 'open') OR
                        (dbo.tblDoctorSchedule.status = 'scheduled') OR
                        (dbo.tblDoctorSchedule.status = 'Hold')) AND dbo.tblcase.panelnbr IS NOT NULL
ORDER BY dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwDoctorSchedulewithoffice]
AS
SELECT      TOP 100 PERCENT dbo.tblDoctorSchedule.locationcode, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime, 
                        dbo.tblDoctorSchedule.description, dbo.tblDoctorSchedule.status, dbo.tblDoctorSchedule.doctorcode, dbo.tblDoctorSchedule.schedcode, 
                        dbo.tblCase.casenbr, dbo.tblCompany.extname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, 
                        dbo.tblLocation.location, dbo.tblIMEData.companyname, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') 
                        + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblCase.claimnbr, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, 
                        dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, CAST(dbo.tblCase.specialinstructions AS varchar(1000)) 
                        AS specialinstructions, dbo.tblCase.WCBNbr, dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.fax AS doctorfax, dbo.tblCase.photoRqd, 
                        dbo.tblClient.phone1 AS clientphone, dbo.tblCase.DoctorName AS paneldesc, dbo.tblCase.PanelNbr, NULL AS panelnote, tbldoctoroffice.officecode, 
                        CASE WHEN dbo.tblcase.casenbr IS NULL THEN dbo.tbldoctorschedule.casenbr1desc ELSE NULL END AS scheduledescription, 
                        tblservices.shortdesc, tblimedata.fax, CASE WHEN tblcase.interpreterrequired = 1 THEN 'Interpreter' ELSE '' END AS Interpreter
FROM          dbo.tblLocation INNER JOIN
                        dbo.tblDoctorSchedule INNER JOIN
                        dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode ON 
                        dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode LEFT OUTER JOIN
                        dbo.tblCaseType INNER JOIN
                        dbo.tblClient INNER JOIN
                        dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                        dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                        dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr ON dbo.tblCaseType.code = dbo.tblCase.casetype INNER JOIN
                        dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode ON 
                        dbo.tblDoctorSchedule.schedcode = dbo.tblCase.schedcode LEFT OUTER JOIN
                        dbo.tblIMEData INNER JOIN
                        dbo.tblOffice INNER JOIN
                        dbo.tblDoctorOffice ON dbo.tblOffice.officecode = dbo.tblDoctorOffice.officecode ON dbo.tblIMEData.IMEcode = dbo.tblOffice.imecode ON 
                        dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctorOffice.doctorcode
WHERE      (dbo.tblDoctorSchedule.status = 'open') OR
                        (dbo.tblDoctorSchedule.status = 'Hold') OR
                        ((dbo.tblDoctorSchedule.status = 'scheduled') AND (dbo.tblcase.schedcode IS NOT NULL))
UNION
SELECT      TOP 100 PERCENT dbo.tblDoctorSchedule.locationcode, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime, 
                        dbo.tblDoctorSchedule.description, dbo.tblDoctorSchedule.status, dbo.tblDoctorSchedule.doctorcode, dbo.tblDoctorSchedule.schedcode, 
                        dbo.tblCase.casenbr, dbo.tblCompany.extname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, 
                        dbo.tblLocation.location, dbo.tblIMEData.companyname, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') 
                        + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblCase.claimnbr, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, 
                        dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, CAST(dbo.tblCase.specialinstructions AS varchar(1000)) 
                        AS specialinstructions, dbo.tblCase.WCBNbr, dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.fax AS doctorfax, dbo.tblCase.photoRqd, 
                        dbo.tblClient.phone1 AS clientphone, dbo.tblCase.DoctorName AS paneldesc, dbo.tblCase.PanelNbr, CAST(dbo.tblCasePanel.panelnote AS varchar(50)) 
                        AS panelnote, tbldoctoroffice.officecode, CASE WHEN dbo.tblcase.casenbr IS NULL THEN dbo.tbldoctorschedule.casenbr1desc ELSE NULL 
                        END AS scheduledescription, tblservices.shortdesc, tblimedata.fax, 
                        CASE WHEN tblcase.interpreterrequired = 1 THEN 'Interpreter' ELSE '' END AS Interpreter
FROM          dbo.tblCaseType INNER JOIN
                        dbo.tblClient INNER JOIN
                        dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                        dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                        dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr ON dbo.tblCaseType.code = dbo.tblCase.casetype INNER JOIN
                        dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                        dbo.tblCasePanel ON dbo.tblCase.PanelNbr = dbo.tblCasePanel.panelnbr RIGHT OUTER JOIN
                        dbo.tblLocation INNER JOIN
                        dbo.tblDoctorSchedule INNER JOIN
                        dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode ON 
                        dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode ON 
                        dbo.tblCasePanel.schedcode = dbo.tblDoctorSchedule.schedcode LEFT OUTER JOIN
                        dbo.tblIMEData INNER JOIN
                        dbo.tblOffice INNER JOIN
                        dbo.tblDoctorOffice ON dbo.tblOffice.officecode = dbo.tblDoctorOffice.officecode ON dbo.tblIMEData.IMEcode = dbo.tblOffice.imecode ON 
                        dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctorOffice.doctorcode
WHERE      ((dbo.tblDoctorSchedule.status = 'open') OR
                        (dbo.tblDoctorSchedule.status = 'scheduled') OR
                        (dbo.tblDoctorSchedule.status = 'Hold')) AND dbo.tblcase.panelnbr IS NOT NULL
ORDER BY dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




update tblControl set DBVersion='1.46'
GO
