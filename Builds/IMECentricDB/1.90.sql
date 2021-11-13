
--View Changes for Appointment History
CREATE VIEW [dbo].[vwCaseAppt]
AS 
WITH allDoctors AS (
		SELECT  
			CA.CaseApptID ,
			ISNULL(CA.DoctorCode, CAP.DoctorCode) AS DoctorCode,
			CASE WHEN CA.DoctorCode IS NULL THEN
			LTRIM(RTRIM(ISNULL(DP.FirstName,'')+' '+ISNULL(DP.LastName,'')+' '+ISNULL(DP.Credentials,'')))
			ELSE
			LTRIM(RTRIM(ISNULL(D.FirstName,'')+' '+ISNULL(D.LastName,'')+' '+ISNULL(D.Credentials,'')))
			END AS DoctorName,
			ISNULL(CA.SpecialtyCode, CAP.SpecialtyCode) AS SpecialtyCode
		 FROM tblCaseAppt AS CA
		 LEFT OUTER JOIN tblDoctor AS D ON CA.DoctorCode=D.DoctorCode
		 LEFT OUTER JOIN tblCaseApptPanel AS CAP ON CA.CaseApptID=CAP.CaseApptID
		 LEFT OUTER JOIN tblDoctor AS DP ON CAP.DoctorCode=DP.DoctorCode
)
SELECT  DISTINCT
		CA.CaseApptID ,
        CA.CaseNbr ,
        CA.ApptStatusID ,
        S.Name AS ApptStatus,

        CA.ApptTime ,
        CA.LocationCode ,
        L.Location,

        CA.CanceledByID ,
        CB.Name AS CanceledBy ,
        CA.Reason ,
        
        CA.DateAdded ,
        CA.UserIDAdded ,
        CA.DateEdited ,
        CA.UserIDEdited ,
        CA.LastStatusChg ,
        CAST(CASE WHEN CA.DoctorCode IS NULL THEN 1 ELSE 0 END AS BIT) AS IsPanel,
        (STUFF((
        SELECT '\'+ CAST(DoctorCode AS VARCHAR) FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
		FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(max)'),1,1,'')) AS DoctorCodes,
        (STUFF((
        SELECT '\'+DoctorName FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
		FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(max)'),1,1,'')) AS DoctorNames,
        (STUFF((
        SELECT '\'+ SpecialtyCode FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
		FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(max)'),1,1,'')) AS Specialties
     FROM tblCaseAppt AS CA
     INNER JOIN tblApptStatus AS S ON CA.ApptStatusID = S.ApptStatusID
     LEFT OUTER JOIN tblCanceledBy AS CB ON CA.CanceledByID=CB.CanceledByID
     LEFT OUTER JOIN tblLocation AS L ON CA.LocationCode=L.LocationCode
GO



DROP VIEW vwAcctingSummaryWithSecurity
GO
CREATE VIEW vwAcctingSummaryWithSecurity
AS
    SELECT TOP 100 PERCENT
            tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename ,
            tblacctingtrans.DrOpType ,
            tblCase.PanelNbr ,
            CASE ISNULL(tblcase.panelnbr, 0)
              WHEN 0
              THEN CASE tblacctingtrans.droptype
                     WHEN 'DR'
                     THEN ISNULL(tbldoctor.lastname, '') + ', '
                          + ISNULL(tbldoctor.firstname, '')
                     WHEN ''
                     THEN ISNULL(tbldoctor.lastname, '') + ', '
                          + ISNULL(tbldoctor.firstname, '')
                     WHEN '' THEN ISNULL(tblcase.doctorname, '')
                     WHEN 'OP' THEN tbldoctor.companyname
                   END
              ELSE CASE tblacctingtrans.droptype
                     WHEN 'DR' THEN ISNULL(tblcase.doctorname, '')
                     WHEN '' THEN ISNULL(tblcase.doctorname, '')
                     WHEN 'OP' THEN tbldoctor.companyname
                   END
            END AS doctorname ,
            tblClient.lastname + ', ' + tblClient.firstname AS clientname ,
            tblCompany.intname AS companyname ,
            tblCase.priority ,
            ISNULL(tblLocation_1.locationcode, tblCase.doctorlocation) AS doctorlocation ,
            tblAcctingTrans.blnselect AS billedselect ,
            tblCase.servicecode ,
            tblQueues.statusdesc ,
            tblCase.miscselect ,
            tblcase.marketercode ,
            tblacctingtrans.statuscode ,
            tblCase.voucherselect ,
            tblacctingtrans.documentnbr ,
            tblacctingtrans.documentdate ,
            tblacctingtrans.documentamount ,
            tblServices.description AS servicedesc ,
            tblCase.officecode ,
            tblDoctor.companyname AS otherpartyname ,
            tblDoctor.doctorcode ,
            tblCase.casenbr ,
            tblacctingtrans.SeqNO ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.schedulercode ,
            tblCase.QARep ,
            tblacctingtrans.type ,
            DATEDIFF(day, tblacctingtrans.laststatuschg, GETDATE()) AS IQ ,
            tblCase.laststatuschg ,
            ISNULL(tblacctingtrans.apptdate, tblCase.ApptDate) AS apptdate ,
            ISNULL(tblLocation_1.location, tblLocation.location) AS location ,
            tblacctingtrans.appttime ,
            tblApptStatus.Name AS Result,
            tblCase.mastersubcase ,
            tblqueues.functioncode ,
            tblUserofficefunction.userid ,
            tblcase.billingnote ,
            tblCase.rptStatus ,
            tblCase.casetype,
            tblAcctingTrans.ApptStatusID
    FROM    tblCase
            INNER JOIN tblacctingtrans ON tblCase.casenbr = tblacctingtrans.casenbr
            INNER JOIN tblQueues ON tblacctingtrans.statuscode = tblQueues.statuscode
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblUserOffice ON tblCase.officecode = tblUserOffice.officecode
            INNER JOIN tbluserofficefunction ON tblUserOffice.userid = tbluserofficefunction.userid
                                                AND tblUserOffice.officecode = tbluserofficefunction.officecode
                                                AND tblqueues.functioncode = tbluserofficefunction.functioncode
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            LEFT OUTER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode 
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
            LEFT OUTER JOIN tblLocation tblLocation_1 ON tblacctingtrans.doctorlocation = tblLocation_1.locationcode
            LEFT OUTER JOIN tblDoctor ON tblacctingtrans.DrOpCode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblApptStatus ON tblAcctingTrans.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( tblacctingtrans.statuscode <> 20 )

GO


DROP VIEW vwacctingsummary
GO

CREATE VIEW vwAcctingSummary
AS
    SELECT TOP 100 PERCENT
            tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename ,
            tblacctingtrans.DrOpType ,
            tblCase.PanelNbr ,
            CASE ISNULL(tblcase.panelnbr, 0)
              WHEN 0
              THEN CASE tblacctingtrans.droptype
                     WHEN 'DR'
                     THEN ISNULL(tbldoctor.lastname, '') + ', '
                          + ISNULL(tbldoctor.firstname, '')
                     WHEN ''
                     THEN ISNULL(tbldoctor.lastname, '') + ', '
                          + ISNULL(tbldoctor.firstname, '')
                     WHEN '' THEN ISNULL(tblcase.doctorname, '')
                     WHEN 'OP' THEN tbldoctor.companyname
                   END
              ELSE CASE tblacctingtrans.droptype
                     WHEN 'DR' THEN ISNULL(tblcase.doctorname, '')
                     WHEN '' THEN ISNULL(tblcase.doctorname, '')
                     WHEN 'OP' THEN tbldoctor.companyname
                   END
            END AS doctorname ,
            tblClient.lastname + ', ' + tblClient.firstname AS clientname ,
            tblCompany.intname AS companyname ,
            tblCase.priority ,
            tblCase.dateadded ,
            tblCase.claimnbr ,
            ISNULL(tblLocation_1.locationcode, tblCase.doctorlocation) AS doctorlocation ,
            tblCase.shownoshow ,
            tblCase.transcode ,
            tblCase.rptstatus ,
            tblCase.dateedited ,
            tblCase.useridedited ,
            tblCase.apptselect ,
            tblClient.email AS adjusteremail ,
            tblClient.fax AS adjusterfax ,
            tblCase.marketercode ,
            tblCase.requesteddoc ,
            tblCase.invoicedate ,
            tblCase.invoiceamt ,
            tblCase.datedrchart ,
            tblCase.drchartselect ,
            tblCase.inqaselect ,
            tblCase.intransselect ,
            tblAcctingTrans.blnselect AS billedselect ,
            tblCase.awaittransselect ,
            tblCase.chartprepselect ,
            tblCase.apptrptsselect ,
            tblCase.transreceived ,
            tblCase.servicecode ,
            tblQueues.statusdesc ,
            tblCase.miscselect ,
            tblCase.useridadded ,
            tblacctingtrans.statuscode ,
            tblCase.voucherselect ,
            tblacctingtrans.documentnbr ,
            tblacctingtrans.documentdate ,
            tblacctingtrans.documentamount ,
            tblServices.description AS servicedesc ,
            tblCase.officecode ,
            tblDoctor.companyname AS otherpartyname ,
            tblDoctor.doctorcode ,
            tblCase.casenbr ,
            tblacctingtrans.SeqNO ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.schedulercode ,
            tblCase.notes ,
            tblDoctor.notes AS doctornotes ,
            tblCompany.notes AS companynotes ,
            tblClient.notes AS clientnotes ,
            tblCase.QARep ,
            tblacctingtrans.type ,
            DATEDIFF(day, tblacctingtrans.laststatuschg, GETDATE()) AS IQ ,
            tblCase.laststatuschg ,
            ISNULL(tblacctingtrans.apptdate, tblCase.ApptDate) AS apptdate ,
            ISNULL(tblLocation_1.location, tblLocation.location) AS location ,
            tblacctingtrans.appttime ,
            tblApptStatus.Name AS Result ,
            tblCase.mastersubcase ,
            tblcase.billingnote ,
            tblcasetype.description AS CaseType ,
            tblAcctingTrans.ApptStatusID
    FROM    tblCase
            INNER JOIN tblacctingtrans ON tblCase.casenbr = tblacctingtrans.casenbr
            INNER JOIN tblQueues ON tblacctingtrans.statuscode = tblQueues.statuscode
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblcasetype ON tblcasetype.code = tblcase.casetype
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            LEFT OUTER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
            LEFT OUTER JOIN tblLocation tblLocation_1 ON tblacctingtrans.doctorlocation = tblLocation_1.locationcode
            LEFT OUTER JOIN tblDoctor ON tblacctingtrans.DrOpCode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblApptStatus ON tblAcctingTrans.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( tblacctingtrans.statuscode <> 20 )
    ORDER BY tblCase.ApptDate


GO

DROP VIEW vwAcctingVOSummary
GO
CREATE VIEW vwAcctingVOSummary
AS
    SELECT TOP 100 PERCENT
            tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename ,
            tblacctingtrans.DrOpType ,
            CASE tblacctingtrans.droptype
              WHEN 'DR'
              THEN ISNULL(tbldoctor.lastname, '') + ', '
                   + ISNULL(tbldoctor.firstname, '')
              WHEN ''
              THEN ISNULL(tbldoctor.lastname, '') + ', '
                   + ISNULL(tbldoctor.firstname, '')
              WHEN '' THEN ISNULL(tblcase.doctorname, '')
              WHEN 'OP' THEN tbldoctor.companyname
            END AS doctorname ,
            tblClient.lastname + ', ' + tblClient.firstname AS clientname ,
            tblCompany.intname AS companyname ,
            tblCase.priority ,
            tblCase.dateadded ,
            tblCase.claimnbr ,
            ISNULL(tblLocation_1.locationcode, tblCase.doctorlocation) AS doctorlocation ,
            tblCase.shownoshow ,
            tblCase.transcode ,
            tblCase.rptstatus ,
            tblCase.dateedited ,
            tblCase.useridedited ,
            tblCase.apptselect ,
            tblClient.email AS adjusteremail ,
            tblClient.fax AS adjusterfax ,
            tblCase.marketercode ,
            tblCase.requesteddoc ,
            tblCase.invoicedate ,
            tblCase.invoiceamt ,
            tblCase.datedrchart ,
            tblCase.drchartselect ,
            tblCase.inqaselect ,
            tblCase.intransselect ,
            tblAcctingTrans.blnselect AS billedselect ,
            tblCase.awaittransselect ,
            tblCase.chartprepselect ,
            tblCase.apptrptsselect ,
            tblCase.transreceived ,
            tblCase.servicecode ,
            tblQueues.statusdesc ,
            tblCase.miscselect ,
            tblCase.useridadded ,
            tblacctingtrans.statuscode ,
            tblCase.voucherselect ,
            tblacctingtrans.documentnbr ,
            tblacctingtrans.documentdate ,
            tblacctingtrans.documentamount ,
            tblServices.description AS servicedesc ,
            tblCase.officecode ,
            tblDoctor.companyname AS otherpartyname ,
            tblDoctor.doctorcode ,
            tblCase.casenbr ,
            tblacctingtrans.SeqNO ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.schedulercode ,
            tblCase.notes ,
            tblDoctor.notes AS doctornotes ,
            tblCompany.notes AS companynotes ,
            tblClient.notes AS clientnotes ,
            tblCase.QARep ,
            tblacctingtrans.type ,
            DATEDIFF(day, tblacctingtrans.laststatuschg, GETDATE()) AS IQ ,
            tblCase.laststatuschg ,
            ISNULL(tblacctingtrans.apptdate, tblCase.ApptDate) AS apptdate ,
            ISNULL(tblLocation_1.location, tblLocation.location) AS location ,
            tblacctingtrans.appttime ,
            tblApptStatus.Name AS Result ,
            tblCase.mastersubcase ,
            tblcase.billingnote ,
            tblcasetype.description AS CaseType,
            tblAcctingTrans.ApptStatusID
    FROM    tblCase
            INNER JOIN tblacctingtrans ON tblCase.casenbr = tblacctingtrans.casenbr
            INNER JOIN tblQueues ON tblacctingtrans.statuscode = tblQueues.statuscode
            INNER JOIN tblCaseType ON tblcasetype.code = tblcase.casetype
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            LEFT OUTER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
            LEFT OUTER JOIN tblLocation tblLocation_1 ON tblacctingtrans.doctorlocation = tblLocation_1.locationcode
            LEFT OUTER JOIN tblDoctor ON tblacctingtrans.DrOpCode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblApptStatus ON tblAcctingTrans.ApptStatusID=tblApptStatus.ApptStatusID
    WHERE   ( tblacctingtrans.statuscode <> 20 )
            AND tblacctingtrans.type = 'VO'
    ORDER BY tblCase.ApptDate


GO


DROP PROCEDURE spExamineeCases
GO
CREATE PROCEDURE [dbo].[spExamineeCases]
    (
      @ChartNbr INTEGER ,
      @userid VARCHAR(30)
    )
AS 
    SELECT TOP 100 PERCENT
            tblCase.CaseNbr ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, tblCaseAppt.ApptTime)) AS ApptDate ,
            tblCase.ChartNbr ,
            tblClient.lastname + ', ' + tblClient.firstname AS clientname ,
            tblLocation.Location ,
            tblQueues.StatusDesc ,
            ISNULL(tblSpecialty_2.description, tblSpecialty_1.description) AS SpecialtyDesc ,
            tblSpecialty_1.description ,
            tblServices.ShortDesc ,
            tblCase.MasterSubCase ,
            ISNULL(tblCase.mastercasenbr, tblCase.casenbr) AS MasterCaseNbr ,
            tblDoctor.FirstName+' '+tblDoctor.LastName AS DoctorName ,
            tbloffice.shortdesc AS Office ,
            tblApptStatus.Name AS Result
    FROM    tblCase
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblUserOffice ON tblCase.officecode = tblUserOffice.officecode
            INNER JOIN tbloffice ON tbloffice.officecode = tblcase.officecode
            LEFT OUTER JOIN	tblCaseAppt ON tblCase.CaseNbr = tblCaseAppt.CaseNbr
            LEFT OUTER JOIN tblApptStatus ON tblCaseAppt.ApptStatusID = tblApptStatus.ApptStatusID
            LEFT OUTER JOIN tblSpecialty tblSpecialty_1 ON tblCase.sreqspecialty = tblSpecialty_1.specialtycode
            LEFT OUTER JOIN tblSpecialty tblSpecialty_2 ON tblSpecialty_2.specialtycode = tblCaseAppt.SpecialtyCode
            LEFT OUTER JOIN tblDoctor ON tblCaseAppt.DoctorCode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblLocation ON tblCaseAppt.LocationCode = tblLocation.locationcode
            LEFT OUTER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
    WHERE   ( tblCase.chartnbr = @chartnbr )
            AND ( tblUserOffice.userid = @userid )
    ORDER BY ISNULL(tblCase.mastercasenbr, tblCase.casenbr) DESC ,
            tblCase.mastersubcase ,
            tblCase.ApptDate DESC



GO

DROP VIEW vwOfficeIMEData
GO

CREATE VIEW vwOfficeIMEData
AS
    SELECT  tblOffice.OfficeCode ,
            tblIMEData.*
    FROM    tblOffice
            INNER JOIN tblIMEData ON tblOffice.IMECode = tblIMEData.IMEcode

GO


DROP VIEW dbo.vwapptlogbyappt
GO
CREATE VIEW dbo.vwApptLogByAppt
AS
    SELECT TOP 100 PERCENT
            dbo.tblCase.ApptDate ,
            dbo.tblCaseType.ShortDesc AS [Case Type] ,
            dbo.tblCase.DoctorName AS Doctor ,
            dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS Client ,
            dbo.tblCompany.intname AS Company ,
            dbo.tblCase.DoctorLocation ,
            dbo.tblLocation.Location ,
            dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS Examinee ,
            dbo.tblCase.MarketerCode ,
            dbo.tblCase.SchedulerCode ,
            dbo.tblExaminee.SSN ,
            dbo.tblQueues.statusdesc ,
            dbo.tblDoctor.doctorcode ,
            dbo.tblCase.clientcode ,
            dbo.tblCompany.companycode ,
            dbo.tblCase.dateadded ,
            ISNULL(dbo.tblClient.phone1, '') + ' '
            + ISNULL(dbo.tblClient.phone1ext, '') AS clientphone ,
            dbo.tblCase.Appttime ,
            dbo.tblCase.CaseNbr ,
            dbo.tblCase.priority ,
            dbo.tblCase.commitdate ,
            dbo.tblCase.status ,
            dbo.tblCase.servicecode ,
            dbo.tblServices.shortdesc ,
            dbo.tblSpecialty.description ,
            dbo.tblCase.officecode ,
            dbo.tblOffice.description AS OfficeName ,
            GETDATE() AS today ,
            dbo.tblCase.QARep AS QARepcode ,
            dbo.tblCase.HearingDate ,
            dbo.tblCase.casetype ,
            dbo.tblCase.PanelNbr ,
            dbo.tblCase.mastersubcase ,
            ( SELECT TOP 1
                        tblCaseAppt.ApptTime
              FROM      tblCaseAppt
              WHERE     tblCaseAppt.CaseNbr = tblCase.CaseNbr
                        AND tblCaseAppt.CaseApptID<tblCase.CaseApptID
              ORDER BY  tblCaseAppt.CaseApptID DESC
            ) AS PreviousApptTime ,
            dbo.tblDoctor.ProvTypeCode ,
            dbo.tblDoctor.phone AS DoctorPhone ,
            dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS DoctorSortName ,
            dbo.tblCase.ExternalDueDate ,
            dbo.tblCase.InternalDueDate ,
            dbo.tblCase.ForecastDate
    FROM    dbo.tblCase
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
            INNER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
            INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
            INNER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode
            LEFT OUTER JOIN dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode
            LEFT OUTER JOIN dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
            LEFT OUTER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
    WHERE   ( dbo.tblCase.status <> 9 )
    GROUP BY dbo.tblCase.ApptDate ,
            dbo.tblCaseType.ShortDesc ,
            dbo.tblCase.DoctorName ,
            dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname ,
            dbo.tblCompany.intname ,
            dbo.tblCase.doctorlocation ,
            dbo.tblLocation.location ,
            dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname ,
            dbo.tblCase.marketercode ,
            dbo.tblCase.schedulercode ,
            dbo.tblExaminee.SSN ,
            dbo.tblQueues.statusdesc ,
            dbo.tblDoctor.doctorcode ,
            dbo.tblCase.clientcode ,
            dbo.tblCompany.companycode ,
            dbo.tblCase.dateadded ,
            ISNULL(dbo.tblClient.phone1, '') + ' '
            + ISNULL(dbo.tblClient.phone1ext, '') ,
            dbo.tblCase.Appttime ,
            dbo.tblCase.casenbr ,
            dbo.tblCase.priority ,
            dbo.tblCase.commitdate ,
            dbo.tblCase.status ,
            dbo.tblCase.servicecode ,
            dbo.tblServices.shortdesc ,
            dbo.tblSpecialty.description ,
            dbo.tblCase.officecode ,
            dbo.tblOffice.description ,
            dbo.tblCase.QARep ,
            dbo.tblCase.HearingDate ,
            dbo.tblCase.casetype ,
            dbo.tblCase.PanelNbr ,
            dbo.tblCase.mastersubcase ,
            dbo.tblDoctor.ProvTypeCode ,
            dbo.tblDoctor.phone ,
            dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname ,
            dbo.tblCase.ExternalDueDate ,
            dbo.tblCase.InternalDueDate ,
            dbo.tblCase.ForecastDate,
            dbo.tblCase.CaseApptID


GO


DROP VIEW vwapptlogbyapptDocs
GO
CREATE VIEW vwApptLogByApptDocs
AS
    SELECT TOP 100 PERCENT
            tblCase.ApptDate ,
            tblCaseType.shortdesc AS [Case Type] ,
            tblcase.doctorname AS Doctor ,
            tblClient.firstname + ' ' + tblClient.lastname AS client ,
            tblCompany.intname AS Company ,
            tblCase.doctorlocation ,
            tblLocation.location ,
            tblExaminee.firstname + ' ' + tblExaminee.lastname AS Examinee ,
            tblCase.marketercode ,
            tblCase.schedulercode ,
            tblExaminee.SSN ,
            tblQueues.statusdesc ,
            tblDoctor.doctorcode ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.dateadded ,
            ISNULL(tblClient.phone1, '') + ' ' + ISNULL(tblClient.phone1ext,
                                                        '') AS clientphone ,
            tblCase.Appttime ,
            tblCase.casenbr ,
            tblCase.priority ,
            tblCase.commitdate ,
            tblCase.status ,
            tblCase.servicecode ,
            tblServices.shortdesc ,
            tblSpecialty.description ,
            tblCase.officecode ,
            tblOffice.description AS OfficeName ,
            GETDATE() AS today ,
            tblCase.QARep AS QARepcode ,
            tblCase.HearingDate ,
            tblCase.casetype ,
            tblcase.panelnbr ,
            tblcase.mastersubcase ,
            ( SELECT TOP 1
                        tblCaseAppt.ApptTime
              FROM      tblCaseAppt
              WHERE     tblCaseAppt.CaseNbr = tblCase.CaseNbr
                        AND tblCaseAppt.CaseApptID < tblCase.CaseApptID
              ORDER BY  tblCaseAppt.CaseApptID DESC
            ) AS PreviousApptTime ,
            tbldoctor.provtypecode ,
            tblDoctor.phone AS DoctorPhone ,
            tblDoctor.lastname + ', ' + tblDoctor.firstname AS DoctorSortName ,
            tblcase.externalduedate ,
            tblcase.internalduedate
    FROM    tblCase
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            LEFT OUTER JOIN tblSpecialty ON tblCase.doctorspecialty = tblSpecialty.specialtycode
            LEFT OUTER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
            LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
            LEFT OUTER JOIN tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
    WHERE   ( tblCase.status <> 9 )
    GROUP BY tblCase.ApptDate ,
            tblCaseType.shortdesc ,
            tblcase.doctorname ,
            tblClient.firstname + ' ' + tblClient.lastname ,
            tblCompany.intname ,
            tblCase.doctorlocation ,
            tblLocation.location ,
            tblExaminee.firstname + ' ' + tblExaminee.lastname ,
            tblCase.marketercode ,
            tblCase.schedulercode ,
            tblExaminee.SSN ,
            tblQueues.statusdesc ,
            tblDoctor.doctorcode ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.dateadded ,
            ISNULL(tblClient.phone1, '') + ' ' + ISNULL(tblClient.phone1ext,
                                                        '') ,
            tblCase.Appttime ,
            tblCase.casenbr ,
            tblCase.priority ,
            tblCase.commitdate ,
            tblCase.status ,
            tblCase.servicecode ,
            tblServices.shortdesc ,
            tblSpecialty.description ,
            tblCase.officecode ,
            tblOffice.description ,
            tblCase.QARep ,
            tblCase.HearingDate ,
            tblCase.casetype ,
            tblcase.panelnbr ,
            tblcase.mastersubcase ,
            tbldoctor.provtypecode ,
            tblDoctor.phone ,
            tblDoctor.lastname + ', ' + tblDoctor.firstname ,
            tblcase.externalduedate ,
            tblcase.internalduedate ,
            tblCase.CaseApptID
    UNION
    SELECT TOP 100 PERCENT
            tblCase.ApptDate ,
            tblCaseType.shortdesc AS [Case Type] ,
            tblcase.doctorname AS Doctor ,
            tblClient.firstname + ' ' + tblClient.lastname AS client ,
            tblCompany.intname AS Company ,
            tblCase.doctorlocation ,
            tblLocation.location ,
            tblExaminee.firstname + ' ' + tblExaminee.lastname AS Examinee ,
            tblCase.marketercode ,
            tblCase.schedulercode ,
            tblExaminee.SSN ,
            tblQueues.statusdesc ,
            tblDoctor.doctorcode ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.dateadded ,
            ISNULL(tblClient.phone1, '') + ' ' + ISNULL(tblClient.phone1ext,
                                                        '') AS clientphone ,
            tblCase.Appttime ,
            tblCase.casenbr ,
            tblCase.priority ,
            tblCase.commitdate ,
            tblCase.status ,
            tblCase.servicecode ,
            tblServices.shortdesc ,
            tblSpecialty.description ,
            tblCase.officecode ,
            tblOffice.description AS OfficeName ,
            GETDATE() AS today ,
            tblCase.QARep AS QARepcode ,
            tblCase.HearingDate ,
            tblCase.casetype ,
            tblcase.panelnbr ,
            tblcase.mastersubcase ,
            ( SELECT TOP 1
                        tblCaseAppt.ApptTime
              FROM      tblCaseAppt
              WHERE     tblCaseAppt.CaseNbr = tblCase.CaseNbr
                        AND tblCaseAppt.CaseApptID < tblCase.CaseApptID
              ORDER BY  tblCaseAppt.CaseApptID DESC
            ) AS PreviousApptTime ,
            tbldoctor.provtypecode ,
            tblDoctor.phone AS DoctorPhone ,
            tblDoctor.lastname + ', ' + tblDoctor.firstname AS DoctorSortName ,
            tblcase.externalduedate ,
            tblcase.internalduedate
    FROM    tblCase
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            INNER JOIN tblCasePanel ON tblCase.PanelNbr = tblCasePanel.panelnbr
            INNER JOIN tblDoctor ON tblCasePanel.doctorcode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblSpecialty ON tblCase.doctorspecialty = tblSpecialty.specialtycode
            LEFT OUTER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
            LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
    WHERE   ( tblCase.status <> 9 )
    GROUP BY tblCase.ApptDate ,
            tblCaseType.shortdesc ,
            tblcase.doctorname ,
            tblClient.firstname + ' ' + tblClient.lastname ,
            tblCompany.intname ,
            tblCase.doctorlocation ,
            tblLocation.location ,
            tblExaminee.firstname + ' ' + tblExaminee.lastname ,
            tblCase.marketercode ,
            tblCase.schedulercode ,
            tblExaminee.SSN ,
            tblQueues.statusdesc ,
            tblDoctor.doctorcode ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.dateadded ,
            ISNULL(tblClient.phone1, '') + ' ' + ISNULL(tblClient.phone1ext,
                                                        '') ,
            tblCase.Appttime ,
            tblCase.casenbr ,
            tblCase.priority ,
            tblCase.commitdate ,
            tblCase.status ,
            tblCase.servicecode ,
            tblServices.shortdesc ,
            tblSpecialty.description ,
            tblCase.officecode ,
            tblOffice.description ,
            tblCase.QARep ,
            tblCase.HearingDate ,
            tblCase.casetype ,
            tblCase.panelnbr ,
            tblcase.mastersubcase ,
            tbldoctor.provtypecode ,
            tblDoctor.phone ,
            tblDoctor.lastname + ', ' + tblDoctor.firstname ,
            tblcase.externalduedate ,
            tblcase.internalduedate ,
            tblCase.CaseApptID


GO


DROP VIEW vwRptNoShowDetail
GO
CREATE VIEW vwRptNoShowDetail
AS
    SELECT TOP 100 PERCENT
            vwCaseAppt.CaseNbr ,
            vwCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, vwCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.description AS [Case Type] ,
            vwCaseAppt.DoctorNames AS Doctor ,
            tblClient.firstname + ' ' + tblClient.lastname AS Client ,
            tblCompany.intname AS Company ,
            vwCaseAppt.LocationCode ,
            tblLocation.Location ,
            tblExaminee.firstname + ' ' + tblExaminee.lastname AS examinee ,
            tblCase.marketercode ,
            tblCase.schedulercode ,
            tblExaminee.SSN ,
            tblQueues.statusdesc ,
            vwCaseAppt.DoctorCodes ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.dateadded ,
            tblCase.priority ,
            tblCase.commitdate ,
            tblCase.servicecode ,
            tblServices.shortdesc ,
            tblSpecialty.description ,
            tblCase.officecode ,
            tblOffice.description AS OfficeName ,
            tblCase.QARep AS QARepcode ,
            vwCaseAppt.ApptStatusID ,
            vwCaseAppt.ApptStatus ,
            tblCase.casetype
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            LEFT OUTER JOIN tblSpecialty ON tblCase.doctorspecialty = tblSpecialty.specialtycode
            LEFT OUTER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
            LEFT OUTER JOIN tblLocation ON vwCaseAppt.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
    ORDER BY vwCaseAppt.ApptTime, vwCaseAppt.CaseNbr, vwCaseAppt.CaseApptID

GO

DROP VIEW vwRptNoShowDetailDocs
GO

CREATE VIEW vwRptNoShowDetailDocs
AS
    SELECT TOP 100 PERCENT
            vwCaseAppt.CaseNbr ,
            vwCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, vwCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.description AS [Case Type] ,
            ISNULL(tblDoctor.firstname, '') + ' ' + ISNULL(tblDoctor.lastname,
                                                           '') AS Doctor ,
            tblClient.firstname + ' ' + tblClient.lastname AS Client ,
            tblCompany.intname AS Company ,
            vwCaseAppt.LocationCode ,
            tblLocation.location ,
            tblExaminee.firstname + ' ' + tblExaminee.lastname AS examinee ,
            tblCase.marketercode ,
            tblCase.schedulercode ,
            tblExaminee.SSN ,
            tblQueues.statusdesc ,
            tblDoctor.doctorcode ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.dateadded ,
            tblCase.priority ,
            tblCase.commitdate ,
            tblCase.servicecode ,
            tblServices.shortdesc ,
            tblSpecialty.description ,
            tblCase.officecode ,
            tblOffice.description AS OfficeName ,
            tblCase.QARep AS QARepcode ,
            vwCaseAppt.ApptStatusID ,
            vwCaseAppt.ApptStatus ,
            tblCase.casetype
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            INNER JOIN tblCaseApptPanel ON tblCaseApptPanel.CaseApptID = vwCaseAppt.CaseApptID
            INNER JOIN tblDoctor ON tblCaseApptPanel.DoctorCode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblSpecialty ON tblCase.doctorspecialty = tblSpecialty.specialtycode
            LEFT OUTER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
            LEFT OUTER JOIN tblLocation ON vwCaseAppt.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
    ORDER BY vwCaseAppt.ApptTime, vwCaseAppt.CaseNbr, vwCaseAppt.CaseApptID

GO

DROP VIEW vwRptCancelDetail
GO

CREATE VIEW vwRptCancelDetail
AS
    SELECT TOP 100 PERCENT
            vwCaseAppt.CaseNbr ,
            vwCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, vwCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.description AS [Case Type] ,
            vwCaseAppt.DoctorNames AS Doctor ,
            tblClient.firstname + ' ' + tblClient.lastname AS Client ,
            tblCompany.intname AS Company ,
            vwCaseAppt.LocationCode ,
            tblLocation.location ,
            tblExaminee.firstname + ' ' + tblExaminee.lastname AS examinee ,
            tblCase.marketercode ,
            tblCase.schedulercode ,
            tblExaminee.SSN ,
            tblQueues.statusdesc ,
            vwCaseAppt.DoctorCodes ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.dateadded ,
            tblCase.priority ,
            tblCase.commitdate ,
            tblCase.servicecode ,
            tblServices.shortdesc ,
            tblSpecialty.description ,
            tblCase.officecode ,
            tblOffice.description AS OfficeName ,
            tblCase.QARep AS QARepcode ,
            vwCaseAppt.ApptStatusID ,
            vwCaseAppt.ApptStatus ,
            vwCaseAppt.LastStatusChg ,
            vwCaseAppt.Reason ,
            vwCaseAppt.CanceledBy ,
            tblCase.casetype ,
            tblCase.mastersubcase
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            LEFT OUTER JOIN tblSpecialty ON tblCase.doctorspecialty = tblSpecialty.specialtycode
            LEFT OUTER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
            LEFT OUTER JOIN tblLocation ON vwCaseAppt.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
    WHERE   vwCaseAppt.ApptStatusID IN (50, 51)
    ORDER BY vwCaseAppt.ApptTime, vwCaseAppt.CaseNbr, vwCaseAppt.CaseApptID

GO


DROP VIEW vwRptCancelDetailDocs
GO

CREATE VIEW vwRptCancelDetailDocs
AS
    SELECT TOP 100 PERCENT
            tblCaseAppt.CaseNbr ,
            tblCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, tblCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.description AS [Case Type] ,
            ISNULL(tblDoctor.firstname, '') + ' ' + ISNULL(tblDoctor.lastname,
                                                           '') AS Doctor ,
            tblClient.firstname + ' ' + tblClient.lastname AS Client ,
            tblCompany.intname AS Company ,
            tblCaseAppt.LocationCode ,
            tblLocation.location ,
            tblExaminee.firstname + ' ' + tblExaminee.lastname AS examinee ,
            tblCase.marketercode ,
            tblCase.schedulercode ,
            tblExaminee.SSN ,
            tblQueues.statusdesc ,
            tblDoctor.DoctorCode ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.dateadded ,
            tblCase.priority ,
            tblCase.commitdate ,
            tblCase.servicecode ,
            tblServices.shortdesc ,
            tblSpecialty.description ,
            tblCase.officecode ,
            tblOffice.description AS OfficeName ,
            tblCase.QARep AS QARepcode ,
            tblCaseAppt.ApptStatusID ,
            tblApptStatus.Name AS ApptStatus ,
            tblCaseAppt.LastStatusChg ,
            tblCaseAppt.Reason ,
            tblCanceledBy.Name AS CanceledBy ,
            tblCase.casetype ,
            tblcase.mastersubcase
    FROM    tblCaseAppt
			INNER JOIN tblApptStatus ON tblCaseAppt.ApptStatusID = tblApptStatus.ApptStatusID
            INNER JOIN tblCase ON tblCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            LEFT OUTER JOIN tblCaseApptPanel ON tblCaseAppt.CaseApptID = tblCaseApptPanel.CaseApptID
            LEFT OUTER JOIN tblCanceledBy ON tblCanceledBy.CanceledByID = tblCaseAppt.CanceledByID
            LEFT OUTER JOIN tblDoctor ON ISNULL(tblCaseAppt.DoctorCode, tblCaseApptPanel.DoctorCode) = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblSpecialty ON tblCase.doctorspecialty = tblSpecialty.specialtycode
            LEFT OUTER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
            LEFT OUTER JOIN tblLocation ON tblCaseAppt.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
    WHERE   tblCaseAppt.ApptStatusID IN (50, 51)
    ORDER BY tblCaseAppt.ApptTime, tblCaseAppt.CaseNbr, tblCaseAppt.CaseApptID

GO

DROP VIEW vwDocument
GO

CREATE VIEW [dbo].[vwDocument]
AS
    SELECT  tblCase.casenbr ,
            tblCase.claimnbr ,
            tblExaminee.addr1 AS examineeaddr1 ,
            tblExaminee.addr2 AS examineeaddr2 ,
            tblExaminee.city + ', ' + tblExaminee.state + '  '
            + tblExaminee.zip AS examineecitystatezip ,
            tblExaminee.SSN ,
            tblClient.firstname + ' ' + tblClient.lastname AS clientname ,
            tblCompany.extname AS company ,
            tblClient.phone1 + ' ' + ISNULL(tblClient.phone1ext, ' ') AS clientphone ,
            tblClient.phone2 + ' ' + ISNULL(tblClient.phone2ext, ' ') AS clientphone2 ,
            tblLocation.addr1 AS doctoraddr1 ,
            tblLocation.addr2 AS doctoraddr2 ,
            tblLocation.city + ', ' + tblLocation.state + '  '
            + tblLocation.zip AS doctorcitystatezip ,
            tblCase.ApptDate ,
            tblCase.Appttime ,
            tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename ,
            tblExaminee.phone1 AS examineephone ,
            tblExaminee.sex ,
            tblExaminee.DOB ,
            tblLocation.Phone AS doctorphone ,
            tblClient.addr1 AS clientaddr1 ,
            tblClient.addr2 AS clientaddr2 ,
            tblClient.city + ', ' + tblClient.state + '  ' + tblClient.zip AS clientcitystatezip ,
            tblClient.fax AS clientfax ,
            tblClient.email AS clientemail ,
            ISNULL(tblUser.lastname, '')
            + CASE WHEN ISNULL(tblUser.LastName, '') = ''
                        OR ISNULL(tblUser.FirstName, '') = '' THEN ''
                   ELSE ', '
              END + ISNULL(tblUser.firstname, '') AS scheduler ,
            tblCase.marketercode AS marketer ,
            tblCase.dateadded AS datecalledin ,
            tblCase.dateofinjury AS DOI ,
            tblCase.allegation ,
            tblCase.notes ,
            tblCase.casetype ,
            'Dear ' + tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineesalutation ,
            tblCase.status ,
            tblCase.calledinby ,
            tblCase.chartnbr ,
            'Dear ' + tblClient.firstname + ' ' + tblClient.lastname AS clientsalutation ,
            'Dear ' + tblDoctor.firstname + ' ' + tblDoctor.lastname + ', '
            + ISNULL(tblDoctor.credentials, '') AS doctorsalutation ,
            tblLocation.insidedr ,
            tblLocation.email AS doctoremail ,
            tblLocation.fax AS doctorfax ,
            tblLocation.faxdrschedule ,
            tblLocation.medrcdletter ,
            tblLocation.drletter ,
            tblCase.reportverbal ,
            tblCase.datemedsrecd AS medsrecd ,
            tblCCAddress_2.firstname + ' ' + tblCCAddress_2.lastname AS Pattorneyname ,
            'Dear ' + ISNULL(tblCCAddress_2.firstname, '') + ' '
            + ISNULL(tblCCAddress_2.lastname, '') AS Pattorneysalutation ,
            tblCCAddress_2.company AS Pattorneycompany ,
            tblCCAddress_2.address1 AS Pattorneyaddr1 ,
            tblCCAddress_2.address2 AS Pattorneyaddr2 ,
            tblCCAddress_2.city + ', ' + tblCCAddress_2.state + '  '
            + tblCCAddress_2.zip AS Pattorneycitystatezip ,
            tblCCAddress_2.phone + ISNULL(tblCCAddress_2.phoneextension, '') AS Pattorneyphone ,
            tblCCAddress_2.fax AS Pattorneyfax ,
            tblCCAddress_2.email AS Pattorneyemail ,
            tblCCAddress_1.firstname + ' ' + tblCCAddress_1.lastname AS Dattorneyname ,
            'Dear ' + ISNULL(tblCCAddress_1.firstname, '') + ' '
            + ISNULL(tblCCAddress_1.lastname, '') AS Dattorneysalutation ,
            tblCCAddress_1.company AS Dattorneycompany ,
            tblCCAddress_1.address1 AS Dattorneyaddr1 ,
            tblCCAddress_1.address2 AS Dattorneyaddr2 ,
            tblCCAddress_1.city + ', ' + tblCCAddress_1.state + '  '
            + tblCCAddress_1.zip AS Dattorneycitystatezip ,
            tblCCAddress_1.phone + ' ' + ISNULL(tblCCAddress_1.phoneextension,
                                                '') AS Dattorneyphone ,
            tblCCAddress_1.fax AS Dattorneyfax ,
            tblCCAddress_1.email AS Dattorneyemail ,
            tblCCAddress_1.fax ,
            tblCCAddress_3.firstname + ' ' + tblCCAddress_3.lastname AS DParaLegalname ,
            'Dear ' + ISNULL(tblCCAddress_3.firstname, '') + ' '
            + ISNULL(tblCCAddress_3.lastname, '') AS DParaLegalsalutation ,
            tblCCAddress_3.company AS DParaLegalcompany ,
            tblCCAddress_3.address1 AS DParaLegaladdr1 ,
            tblCCAddress_3.address2 AS DParaLegaladdr2 ,
            tblCCAddress_3.city + ', ' + tblCCAddress_3.state + '  '
            + tblCCAddress_3.zip AS DParaLegalcitystatezip ,
            tblCCAddress_3.phone + ' ' + ISNULL(tblCCAddress_3.phoneextension,
                                                '') AS DParaLegalphone ,
            tblCCAddress_3.email AS DParaLegalemail ,
            tblCCAddress_3.fax AS DParaLegalfax ,
            tblCase.typemedsrecd ,
            tblCase.plaintiffattorneycode ,
            tblCase.defenseattorneycode ,
            tblCase.servicecode ,
            tblCase.faxPattny ,
            tblCase.faxdoctor ,
            tblCase.faxclient ,
            tblCase.emailclient ,
            tblCase.emaildoctor ,
            tblCase.emailPattny ,
            tblCase.invoicedate ,
            tblCase.invoiceamt ,
            tblCase.commitdate ,
            tblCase.WCBNbr ,
            tblCase.specialinstructions ,
            tblCase.priority ,
            tblServices.description AS servicedesc ,
            tblCase.usdvarchar1 AS caseusdvarchar1 ,
            tblCase.usdvarchar2 AS caseusdvarchar2 ,
            tblCase.usddate1 AS caseusddate1 ,
            tblCase.usddate2 AS caseusddate2 ,
            tblCase.usdtext1 AS caseusdtext1 ,
            tblCase.usdtext2 AS caseusdtext2 ,
            tblCase.usdint1 AS caseusdint1 ,
            tblCase.usdint2 AS caseusdint2 ,
            tblCase.usdmoney1 AS caseusdmoney1 ,
            tblCase.usdmoney2 AS caseusdmoney2 ,
            tblClient.title AS clienttitle ,
            tblClient.prefix AS clientprefix ,
            tblClient.suffix AS clientsuffix ,
            tblClient.usdvarchar1 AS clientusdvarchar1 ,
            tblClient.usdvarchar2 AS clientusdvarchar2 ,
            tblClient.usddate1 AS clientusddate1 ,
            tblClient.usddate2 AS clientusddate2 ,
            tblClient.usdtext1 AS clientusdtext1 ,
            tblClient.usdtext2 AS clientusdtext2 ,
            tblClient.usdint1 AS clientusdint1 ,
            tblClient.usdint2 AS clientusdint2 ,
            tblClient.usdmoney1 AS clientusdmoney1 ,
            tblClient.usdmoney2 AS clientusdmoney2 ,
            tblDoctor.notes AS doctornotes ,
            tblDoctor.prefix AS doctorprefix ,
            tblDoctor.addr1 AS doctorcorrespaddr1 ,
            tblDoctor.addr2 AS doctorcorrespaddr2 ,
            tblDoctor.city + ', ' + tblDoctor.state + '  ' + tblDoctor.zip AS doctorcorrespcitystatezip ,
            tblDoctor.phone + ' ' + ISNULL(tblDoctor.phoneExt, ' ') AS doctorcorrespphone ,
            tblDoctor.faxNbr AS doctorcorrespfax ,
            tblDoctor.emailAddr AS doctorcorrespemail ,
            tblDoctor.qualifications ,
            tblDoctor.prepaid ,
            tblDoctor.county AS doctorcorrespcounty ,
            tblLocation.county AS doctorcounty ,
            tblLocation.vicinity AS doctorvicinity ,
            tblExaminee.county AS examineecounty ,
            tblExaminee.prefix AS examineeprefix ,
            tblExaminee.usdvarchar1 AS examineeusdvarchar1 ,
            tblExaminee.usdvarchar2 AS examineeusdvarchar2 ,
            tblExaminee.usddate1 AS examineeusddate1 ,
            tblExaminee.usddate2 AS examineeusddate2 ,
            tblExaminee.usdtext1 AS examineeusdtext1 ,
            tblExaminee.usdtext2 AS examineeusdtext2 ,
            tblExaminee.usdint1 AS examineeusdint1 ,
            tblExaminee.usdint2 AS examineeusdint2 ,
            tblExaminee.usdmoney1 AS examineeusdmoney1 ,
            tblExaminee.usdmoney2 AS examineeusdmoney2 ,
            tblDoctor.usdvarchar1 AS doctorusdvarchar1 ,
            tblDoctor.usdvarchar2 AS doctorusdvarchar2 ,
            tblDoctor.usddate1 AS doctorusddate1 ,
            tblDoctor.usddate2 AS doctorusddate2 ,
            tblDoctor.usdtext1 AS doctorusdtext1 ,
            tblDoctor.usdtext2 AS doctorusdtext2 ,
            tblDoctor.usdint1 AS doctorusdint1 ,
            tblDoctor.usdint2 AS doctorusdint2 ,
            tblDoctor.usdmoney1 AS doctorusdmoney1 ,
            tblDoctor.usdmoney2 AS doctorusdmoney2 ,
            tblCase.schedulenotes ,
            tblCase.requesteddoc ,
            tblCompany.usdvarchar1 AS companyusdvarchar1 ,
            tblCompany.usdvarchar2 AS companyusdvarchar2 ,
            tblCompany.usddate1 AS companyusddate1 ,
            tblCompany.usddate2 AS companyusddate2 ,
            tblCompany.usdtext1 AS companyusdtext1 ,
            tblCompany.usdtext2 AS companyusdtext2 ,
            tblCompany.usdint1 AS companyusdint1 ,
            tblCompany.usdint2 AS companyusdint2 ,
            tblCompany.usdmoney1 AS companyusdmoney1 ,
            tblCompany.usdmoney2 AS companyusdmoney2 ,
            tblDoctor.WCNbr AS doctorwcnbr ,
            tblCaseType.description AS casetypedesc ,
            tblLocation.location ,
            tblCase.doctorlocation ,
            tblCase.sinternalcasenbr AS internalcasenbr ,
            tblDoctor.credentials AS doctordegree ,
            tblSpecialty.description AS specialtydesc ,
            tblExaminee.note AS chartnotes ,
            tblExaminee.fax AS examineefax ,
            tblExaminee.email AS examineeemail ,
            tblExaminee.insured AS examineeinsured ,
            tblCase.clientcode ,
            tblCase.doctorcode ,
            tblCase.feecode ,
            tblClient.companycode ,
            tblClient.notes AS clientnotes ,
            tblCompany.notes AS companynotes ,
            tblClient.billaddr1 ,
            tblClient.billaddr2 ,
            tblClient.billcity ,
            tblClient.billstate ,
            tblClient.billzip ,
            tblClient.billattn ,
            tblClient.ARKey ,
            tblCase.icd9code ,
            tblDoctor.remitattn ,
            tblDoctor.remitaddr1 ,
            tblDoctor.remitaddr2 ,
            tblDoctor.remitcity ,
            tblDoctor.remitstate ,
            tblDoctor.remitzip ,
            tblCase.doctorspecialty ,
            tblServices.shortdesc ,
            tblDoctor.licensenbr AS doctorlicense ,
            tblLocation.notes AS doctorlocationnotes ,
            tblLocation.contactfirst + ' ' + tblLocation.contactlast AS doctorlocationcontact ,
            'Dear ' + tblLocation.contactfirst + ' ' + tblLocation.contactlast AS doctorlocationcontactsalutation ,
            tblRecordStatus.description AS medsstatus ,
            tblExaminee.employer ,
            tblExaminee.treatingphysician ,
            tblExaminee.city AS examineecity ,
            tblExaminee.state AS examineestate ,
            tblExaminee.zip AS examineezip ,
            tblDoctor.SSNTaxID AS DoctorTaxID ,
            tblCase.billclientcode AS casebillclientcode ,
            tblCase.billaddr1 AS casebilladdr1 ,
            tblCase.billaddr2 AS casebilladdr2 ,
            tblCase.billcity AS casebillcity ,
            tblCase.billstate AS casebillstate ,
            tblCase.billzip AS casebillzip ,
            tblCase.billARKey AS casebillarkey ,
            tblCase.billcompany AS casebillcompany ,
            tblCase.billcontact AS casebillcontact ,
            tblSpecialty.specialtycode ,
            tblDoctorLocation.correspondence AS doctorcorrespondence ,
            tblExaminee.lastname AS examineelastname ,
            tblExaminee.firstname AS examineefirstname ,
            tblCase.billfax AS casebillfax ,
            tblClient.billfax AS clientbillfax ,
            tblCase.officecode ,
            tblDoctor.lastname AS doctorlastname ,
            tblDoctor.firstname AS doctorfirstname ,
            tblDoctor.middleinitial AS doctormiddleinitial ,
            ISNULL(LEFT(tblDoctor.firstname, 1), '')
            + ISNULL(LEFT(tblDoctor.middleinitial, 1), '')
            + ISNULL(LEFT(tblDoctor.lastname, 1), '') AS doctorinitials ,
            tblCase.QARep ,
            tblClient.lastname AS clientlastname ,
            tblClient.firstname AS clientfirstname ,
            tblCCAddress_1.prefix AS dattorneyprefix ,
            tblCCAddress_1.lastname AS dattorneylastname ,
            tblCCAddress_1.firstname AS dattorneyfirstname ,
            tblCCAddress_2.prefix AS pattorneyprefix ,
            tblCCAddress_2.lastname AS pattorneylastname ,
            tblCCAddress_2.firstname AS pattorneyfirstname ,
            tblLocation.contactprefix AS doctorlocationcontactprefix ,
            tblLocation.contactfirst AS doctorlocationcontactfirstname ,
            tblLocation.contactlast AS doctorlocationcontactlastname ,
            tblExaminee.middleinitial AS examineemiddleinitial ,
            tblCase.ICD9Code2 ,
            tblCase.ICD9Code3 ,
            tblCase.ICD9Code4 ,
            tblExaminee.InsuredAddr1 ,
            tblExaminee.InsuredCity ,
            tblExaminee.InsuredState ,
            tblExaminee.InsuredZip ,
            tblExaminee.InsuredSex ,
            tblExaminee.InsuredRelationship ,
            tblExaminee.InsuredPhone ,
            tblExaminee.InsuredPhoneExt ,
            tblExaminee.InsuredFax ,
            tblExaminee.InsuredEmail ,
            tblExaminee.ExamineeStatus ,
            tblExaminee.TreatingPhysicianAddr1 ,
            tblExaminee.TreatingPhysicianCity ,
            tblExaminee.TreatingPhysicianState ,
            tblExaminee.TreatingPhysicianZip ,
            tblExaminee.TreatingPhysicianPhone ,
            tblExaminee.TreatingPhysicianPhoneExt ,
            tblExaminee.TreatingPhysicianFax ,
            tblExaminee.TreatingPhysicianEmail ,
            tblExaminee.TreatingPhysicianLicenseNbr ,
            tblExaminee.EmployerAddr1 ,
            tblExaminee.EmployerCity ,
            tblExaminee.EmployerState ,
            tblExaminee.EmployerZip ,
            tblExaminee.EmployerPhone ,
            tblExaminee.EmployerPhoneExt ,
            tblExaminee.EmployerFax ,
            tblExaminee.EmployerEmail ,
            tblExaminee.TreatingPhysicianTaxID ,
            tblExaminee.Country ,
            tblDoctor.UPIN ,
            tblDoctor.schedulepriority ,
            tblDoctor.feecode AS drfeecode ,
            tblCase.PanelNbr ,
            tblState.StateName AS Jurisdiction ,
            tblCase.photoRqd ,
            tblCase.CertMailNbr ,
            tblCase.HearingDate ,
            tblCase.DoctorName ,
            tblCase.DefParaLegal ,
            tblLocation.state AS doctorstate ,
            tblClient.state AS clientstate ,
            tblDoctor.state AS doctorcorrespstate ,
            tblCCAddress_1.state AS dattorneystate ,
            tblCCAddress_2.state AS pattorneystate ,
            tblCase.prevappt ,
            tblCase.mastersubcase ,
            tblCase.mastercasenbr ,
            tblLocation.city AS doctorcity ,
            tblLocation.zip AS doctorzip ,
            tblClient.city AS clientcity ,
            tblClient.zip AS clientzip ,
            tblExaminee.policynumber ,
            tblCCAddress_2.city AS pattorneycity ,
            tblCCAddress_2.zip AS pattorneyzip ,
            tblDoctorSchedule.duration AS ApptDuration ,
            tblDoctor.companyname AS PracticeName ,
            tblCase.AssessmentToAddress ,
            tblCase.OCF25Date ,
            tblCase.AssessingFacility ,
            tblCase.DateForminDispute ,
            tblExaminee.EmployerContactLastName ,
            tblExaminee.EmployerContactFirstName ,
            tblDoctor.NPINbr AS DoctorNPINbr ,
            tblCase.PublishOnWeb ,
            tblProviderType.description AS DoctorProviderType ,
            tblDoctor.ProvTypeCode ,
            tblCase.Jurisdiction AS JurisdictionCode ,
            tblCase.LegalEvent ,
            tblCase.PILegalEvent ,
            tblCase.Transcode ,
            tblTranscription.transcompany ,
            tblCase.DateReceived ,
            tblCase.usddate3 AS caseusddate3 ,
            tblCase.usddate4 AS caseusddate4 ,
            tblCase.UsdBit1 AS caseusdboolean1 ,
            tblCase.UsdBit2 AS caseusdboolean2 ,
            tblCase.usddate5 AS caseusddate5 ,
            tblDoctor.usddate3 AS doctorusddate3 ,
            tblDoctor.usddate4 AS doctorusddate4 ,
            tblDoctor.usdvarchar3 AS doctorusdvarchar3 ,
            tblDoctor.usddate5 AS doctorusddate5 ,
            tblDoctor.usddate6 AS doctorusddate6 ,
            tblDoctor.usddate7 AS doctorusddate7 ,
            tblCase.ClaimNbrExt ,
            tblCase.sreqspecialty AS RequestedSpecialty ,
            tblQueues.statusdesc ,
            tblCase.AttorneyNote ,
            tblCaseType.ShortDesc AS CaseTypeShortDesc ,
            tblCase.ExternalDueDate ,
            tblCase.InternalDueDate ,
            tblLocation.ExtName AS LocationExtName ,
            tblVenue.County AS Venue ,
            tblOffice.description AS office ,
            tblOffice.usdvarchar1 AS OfficeUSDVarChar1 ,
            tblOffice.usdvarchar2 AS OfficeUSDVarChar2 ,
            tblCase.TransportationRequired ,
            tblCase.InterpreterRequired ,
            tblLanguage.Description AS LANGUAGE ,
            tblCase.ForecastDate ,
            tblCase.EWReferralType ,
            tblCase.EWReferralEWFacilityID ,
            tblEWFacilityLocal.DoctorCode AS EWFacilityDoctorCode ,
            tblDoctor.PrintOnCheckAs ,
            tblExaminee.TreatingPhysicianCredentials AS TreatingPhysicianDegree ,
            tblCase.CaseApptID ,
            tblCase.ApptStatusID ,
            tblApptStatus.Name AS ApptStatus ,
            tblCase.RptFinalizedDate
    FROM    tblCase
            INNER JOIN tblExaminee ON tblExaminee.chartnbr = tblCase.chartnbr
            INNER JOIN tblOffice ON tblOffice.officecode = tblCase.officecode
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
            LEFT OUTER JOIN tblApptStatus ON tblCase.ApptStatusID = tblApptStatus.ApptStatusID
            LEFT OUTER JOIN tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblProviderType ON tblDoctor.ProvTypeCode = tblProviderType.ProvTypeCode
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
            LEFT OUTER JOIN tblDoctorLocation ON tblCase.doctorlocation = tblDoctorLocation.locationcode
                                                 AND tblCase.doctorcode = tblDoctorLocation.doctorcode
            LEFT OUTER JOIN tblVenue ON tblCase.VenueID = tblVenue.VenueID
            LEFT OUTER JOIN tblTranscription ON tblCase.Transcode = tblTranscription.Transcode
            LEFT OUTER JOIN tblDoctorSchedule ON tblCase.schedcode = tblDoctorSchedule.schedcode
            LEFT OUTER JOIN tblState ON tblCase.Jurisdiction = tblState.Statecode
            LEFT OUTER JOIN tblRecordStatus ON tblCase.reccode = tblRecordStatus.reccode
            LEFT OUTER JOIN tblUser ON tblCase.schedulercode = tblUser.userid
            LEFT OUTER JOIN tblSpecialty ON tblCase.doctorspecialty = tblSpecialty.specialtycode
            LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_1 ON tblCase.defenseattorneycode = tblCCAddress_1.cccode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 ON tblCase.plaintiffattorneycode = tblCCAddress_2.cccode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_3 ON tblCCAddress_3.cccode = tblCase.DefParaLegal
            LEFT OUTER JOIN tblLanguage ON tblLanguage.LanguageID = tblCase.LanguageID
            LEFT OUTER JOIN tblEWFacilityLocal ON tblCase.EWReferralEWFacilityID = tblEWFacilityLocal.EWFacilityID
GO

DROP VIEW vwapptlog
GO
CREATE VIEW vwApptLog
AS
    SELECT TOP 100 PERCENT
            vwCaseAppt.casenbr ,
            vwCaseAppt.DateAdded ,
            vwCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, vwCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.description AS [Case Type] ,
            vwCaseAppt.DoctorNames AS Doctor,
            tblClient.firstname + ' ' + tblClient.lastname AS Client ,
            tblCompany.intname AS Company ,
            tblCase.doctorlocation ,
            tblLocation.location ,
            tblExaminee.firstname + ' ' + tblExaminee.lastname AS examinee ,
            tblCase.marketercode ,
            tblCase.schedulercode ,
            tblExaminee.SSN ,
            tblQueues.statusdesc ,
            vwCaseAppt.DoctorCodes AS DoctorCode ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.priority ,
            tblCase.commitdate ,
            tblCase.servicecode ,
            tblServices.shortdesc ,
            vwCaseAppt.Specialties AS Specialty ,
            tblCase.officecode ,
            tblOffice.description AS OfficeName ,
            tblCase.QARep AS QARepcode ,
            tblCase.casetype ,
            tblCase.mastersubcase ,
            ( SELECT TOP 1
                        tblCaseAppt.ApptTime
              FROM      tblCaseAppt
              WHERE     tblCaseAppt.CaseNbr = tblCase.CaseNbr
                        AND tblCaseAppt.CaseApptID<vwCaseAppt.CaseApptID
              ORDER BY  tblCaseAppt.CaseApptID DESC
            ) AS PreviousApptTime ,
            '' AS ProvTypeCode 
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            LEFT OUTER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
            LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
    WHERE   tblCase.status <> 9 
    ORDER BY vwCaseAppt.DateAdded, tblCase.CaseNbr, vwCaseAppt.CaseApptID


GO

DROP VIEW vwApptLogDocs
GO
CREATE VIEW vwApptLogDocs
AS
    SELECT TOP 100 PERCENT
            tblCase.casenbr ,
            CA.DateAdded ,
            CA.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, CA.ApptTime)) AS ApptDate ,
            tblCaseType.description AS [Case Type] ,
            ISNULL(tblDoctor.firstname, '') + ' ' + ISNULL(tblDoctor.lastname, '') AS Doctor ,
            tblClient.firstname + ' ' + tblClient.lastname AS Client ,
            tblCompany.intname AS Company ,
            tblCase.doctorlocation ,
            tblLocation.location ,
            tblExaminee.firstname + ' ' + tblExaminee.lastname AS examinee ,
            tblCase.marketercode ,
            tblCase.schedulercode ,
            tblExaminee.SSN ,
            tblQueues.statusdesc ,
            tblDoctor.DoctorCode ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.priority ,
            tblCase.commitdate ,
            tblCase.servicecode ,
            tblServices.shortdesc ,
            ISNULL(CA.SpecialtyCode, tblCaseApptPanel.SpecialtyCode) AS Specialty ,
            tblCase.officecode ,
            tblOffice.description AS OfficeName ,
            tblCase.QARep AS QARepcode ,
            tblCase.casetype ,
            tblCase.mastersubcase ,
            ( SELECT TOP 1
                        PriorAppt.ApptTime
              FROM      tblCaseAppt AS PriorAppt
                        WHERE PriorAppt.CaseNbr = tblCase.CaseNbr
                        AND PriorAppt.CaseApptID<CA.CaseApptID
              ORDER BY  PriorAppt.CaseApptID DESC
            ) AS PreviousApptTime ,
            tblDoctor.ProvTypeCode
    FROM    tblCaseAppt AS CA
			INNER JOIN tblApptStatus ON CA.ApptStatusID = tblApptStatus.ApptStatusID
            INNER JOIN tblCase ON CA.CaseNbr = tblCase.CaseNbr

            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            
			LEFT OUTER JOIN tblCaseApptPanel ON CA.CaseApptID = tblCaseApptPanel.CaseApptID
            LEFT OUTER JOIN tblCanceledBy ON tblCanceledBy.CanceledByID = CA.CanceledByID
            LEFT OUTER JOIN tblDoctor ON ISNULL(CA.DoctorCode, tblCaseApptPanel.DoctorCode) = tblDoctor.DoctorCode

            LEFT OUTER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
            LEFT OUTER JOIN tblLocation ON CA.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
    WHERE   tblCase.status <> 9 
    ORDER BY CA.DateAdded, tblCase.CaseNbr, CA.CaseApptID


GO

DROP VIEW vwCancelAppt
GO
CREATE VIEW vwCancelAppt
AS
    SELECT DISTINCT TOP 100 PERCENT
            vwCaseAppt.LastStatusChg ,
            vwCaseAppt.ApptStatus ,
            vwCaseAppt.DoctorNames ,
            tblLocation.Location ,
            vwCaseAppt.CanceledBy ,
            vwCaseAppt.Reason ,
            vwCaseAppt.ApptTime ,
            vwCaseAppt.DateEdited ,
            vwCaseAppt.UserIDEdited ,
            tblOffice.description AS Office ,
            tblCaseType.description AS CaseType ,
            vwclient.Client ,
            vwclient.intname AS Company ,
            tblExaminee.lastname + ', ' + tblExaminee.firstname AS Examinee ,
            tblServices.description AS Service ,
            tblCase.MarketerCode ,
            tblCase.CaseNbr ,
            tblCase.QARep ,
            tblCase.OfficeCode ,
            tblCaseType.Code ,
            vwclient.CompanyCode ,
            vwclient.ClientCode ,
            tblExaminee.ChartNbr ,
            tblServices.ServiceCode
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            INNER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
            INNER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            LEFT OUTER JOIN vwclient ON tblCase.clientcode = vwclient.clientcode
            LEFT OUTER JOIN tblLocation ON vwCaseAppt.LocationCode = tblLocation.LocationCode
    WHERE   vwCaseAppt.ApptStatusID IN (50, 51)
    ORDER BY vwCaseAppt.LastStatusChg

GO



DROP VIEW vwapptsbymth

GO

CREATE VIEW [dbo].[vwApptsByMth]
AS
    SELECT DISTINCT
            dbo.tblCase.casenbr ,
            tblCaseAppt.DoctorCode ,
            tblCaseAppt.LocationCode ,
            dbo.tblCase.marketercode ,
            dbo.tblCase.clientcode ,
            dbo.tblClient.companycode ,
            CASE WHEN tblCaseAppt.ApptStatusID = 101 THEN 'NoShow'
                 ELSE 'Show'
            END AS EventDesc ,
            ISNULL(tblUser.LastName, '')
            + CASE WHEN ISNULL(tblUser.LastName, '') = ''
                        OR ISNULL(tblUser.FirstName, '') = '' THEN ''
                   ELSE ', '
              END + ISNULL(tblUser.FirstName, '') AS marketer ,
            CASE WHEN tblCaseAppt.ApptStatusID = 101 THEN 'NoShow'
                 ELSE 'Show'
            END AS Type ,
            dbo.tblCase.ApptDate ,
            dbo.tblCompany.intname AS companyname ,
            dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS adjustername ,
            dbo.tblClient.lastname ,
            dbo.tblDoctor.firstname + ' ' + dbo.tblDoctor.lastname AS doctorname ,
            dbo.tblLocation.location ,
            YEAR(dbo.tblCase.ApptDate) AS year ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 1 THEN 1
                 ELSE 0
            END AS jan ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 1
                      AND tblCaseAppt.ApptStatusID = 101 THEN 1
                 ELSE 0
            END AS janns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 2 THEN 1
                 ELSE 0
            END AS feb ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 2
                      AND tblCaseAppt.ApptStatusID = 101 THEN 1
                 ELSE 0
            END AS febns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 3 THEN 1
                 ELSE 0
            END AS mar ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 3
                      AND tblCaseAppt.ApptStatusID = 101 THEN 1
                 ELSE 0
            END AS marns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 4 THEN 1
                 ELSE 0
            END AS apr ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 4
                      AND tblCaseAppt.ApptStatusID = 101 THEN 1
                 ELSE 0
            END AS aprns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 5 THEN 1
                 ELSE 0
            END AS may ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 5
                      AND tblCaseAppt.ApptStatusID = 101 THEN 1
                 ELSE 0
            END AS mayns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 6 THEN 1
                 ELSE 0
            END AS jun ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 6
                      AND tblCaseAppt.ApptStatusID = 101 THEN 1
                 ELSE 0
            END AS junns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 7 THEN 1
                 ELSE 0
            END AS jul ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 7
                      AND tblCaseAppt.ApptStatusID = 101 THEN 1
                 ELSE 0
            END AS julns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 8 THEN 1
                 ELSE 0
            END AS aug ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 8
                      AND tblCaseAppt.ApptStatusID = 101 THEN 1
                 ELSE 0
            END AS augns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 9 THEN 1
                 ELSE 0
            END AS sep ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 9
                      AND tblCaseAppt.ApptStatusID = 101 THEN 1
                 ELSE 0
            END AS sepns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 10 THEN 1
                 ELSE 0
            END AS oct ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 10
                      AND tblCaseAppt.ApptStatusID = 101 THEN 1
                 ELSE 0
            END AS octns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 11 THEN 1
                 ELSE 0
            END AS nov ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 11
                      AND tblCaseAppt.ApptStatusID = 101 THEN 1
                 ELSE 0
            END AS novns ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 12 THEN 1
                 ELSE 0
            END AS dec ,
            CASE WHEN MONTH(dbo.tblCase.apptdate) = 12
                      AND tblCaseAppt.ApptStatusID = 101 THEN 1
                 ELSE 0
            END AS decns ,
            1 AS total ,
            CASE WHEN tblCaseAppt.ApptStatusID = 101
                      OR dbo.tblCase.status = 9 THEN 1
                 ELSE 0
            END AS totalns ,
            dbo.tblCase.officecode
    FROM    dbo.tblCase
            INNER JOIN tblCaseAppt ON tblCase.CaseNbr = tblCaseAppt.CaseNbr
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
            LEFT OUTER JOIN dbo.tblUser ON dbo.tblCase.marketercode = dbo.tblUser.userid
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCaseAppt.LocationCode = dbo.tblLocation.locationcode
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCaseAppt.DoctorCode = dbo.tblDoctor.doctorcode
    WHERE   tblCaseAppt.ApptStatusID IN ( 100, 101 )


GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[vwExamineeCasesAbeton]') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP VIEW vwExamineeCasesAbeton;
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[vwnoshows]') AND OBJECTPROPERTY(id,N'IsView') = 1)
    DROP VIEW vwnoshows;
GO


----------------------------------------------
--Create Appt History Data for existing cases
----------------------------------------------

--Add Case Appt for non-panel cases
INSERT  INTO tblCaseAppt
        ( CaseNbr ,
          ApptTime ,
          DoctorCode ,
          LocationCode ,
          SpecialtyCode ,
          ApptStatusID ,
          DateAdded ,
          UserIDAdded ,
          DateEdited ,
          UserIDEdited ,
          CanceledByID ,
          Reason ,
          LastStatusChg
        )
        SELECT  C.CaseNbr ,
                C.ApptTime ,
                C.DoctorCode ,
                C.DoctorLocation ,
                C.DoctorSpecialty ,
                ISNULL(CH.ApptStatusID, 10) AS ApptStatusID ,
                ApptMadeDate ,
                UserIDAdded ,
                ApptMadeDate ,
                UserIDEdited ,
                NULL ,
                LEFT(CH.Reason, 300) ,
                CH.EventDate
        FROM    tblCase AS C
                LEFT OUTER JOIN ( SELECT    CaseNbr ,
                                            ROW_NUMBER() OVER ( PARTITION BY CaseNbr ORDER BY ID DESC ) AS CHRow ,
                                            CASE ( Type )
                                              WHEN 'Scheduled' THEN 10
                                              WHEN 'Cancelled' THEN 50
                                              WHEN 'Cancel' THEN 50
                                              WHEN 'LateCancel' THEN 51
                                              WHEN 'Show' THEN 100
                                              WHEN 'NoShow' THEN 101
                                              WHEN 'Unable' THEN 102
                                              --WHEN 'Web' THEN 10
                                              ELSE 10
                                            END AS ApptStatusID ,
                                            EventDate ,
                                            CASE WHEN PATINDEX('%Reason: %',
                                                              OtherInfo) > 0
                                                      AND LEN(OtherInfo)
                                                      - PATINDEX('%Reason: %',
                                                              OtherInfo) - 7 > 0
                                                 THEN RIGHT(OtherInfo,
                                                            LEN(OtherInfo)
                                                            - PATINDEX('%Reason: %',
                                                              OtherInfo) - 7)
                                                 ELSE NULL
                                            END AS Reason
                                  FROM      tblCaseHistory AS CH
                                  WHERE     Type IN ( 'Show', 'NoShow',
                                                      'LateCancel', 'Cancel',
                                                      'Cancelled', 'Unable',
                                                      'Scheduled' )
                                            --OR (Type='Web' AND Eventdesc='Scheduled')
                                ) AS CH ON C.CaseNbr = CH.CaseNbr
        WHERE   C.PanelNbr IS NULL
                AND C.ApptTime IS NOT NULL
                AND C.ServiceCode IN ( SELECT   ServiceCode
                                       FROM     tblServices
                                       WHERE    ApptBased = 1 )
                AND ISNULL(CH.CHRow, 1) = 1
        ORDER BY C.CaseNbr


--Add Case Appt for panel cases
INSERT  INTO tblCaseAppt
        ( CaseNbr ,
          ApptTime ,
          DoctorCode ,
          LocationCode ,
          SpecialtyCode ,
          ApptStatusID ,
          DateAdded ,
          UserIDAdded ,
          DateEdited ,
          UserIDEdited ,
          CanceledByID ,
          Reason ,
          LastStatusChg
        )
        SELECT  C.CaseNbr ,
                C.ApptTime ,
                NULL ,
                C.DoctorLocation ,
                NULL ,
                ISNULL(CH.ApptStatusID, 10) AS ApptStatusID ,
                C.ApptMadeDate ,
                C.UserIDAdded ,
                C.ApptMadeDate ,
                C.UserIDEdited ,
                NULL ,
                LEFT(CH.Reason, 300) ,
                CH.EventDate
        FROM    tblCase AS C
                LEFT OUTER JOIN ( SELECT    CaseNbr ,
                                            ROW_NUMBER() OVER ( PARTITION BY CaseNbr ORDER BY ID DESC ) AS CHRow ,
                                            CASE ( Type )
                                              WHEN 'Scheduled' THEN 10
                                              WHEN 'Cancelled' THEN 50
                                              WHEN 'Cancel' THEN 50
                                              WHEN 'LateCancel' THEN 51
                                              WHEN 'Show' THEN 100
                                              WHEN 'NoShow' THEN 101
                                              WHEN 'Unable' THEN 102
                                              ELSE 10
                                            END AS ApptStatusID ,
                                            EventDate ,
                                            CASE WHEN PATINDEX('%Reason: %',
                                                              OtherInfo) > 0
                                                      AND LEN(OtherInfo)
                                                      - PATINDEX('%Reason: %',
                                                              OtherInfo) - 7 > 0
                                                 THEN RIGHT(OtherInfo,
                                                            LEN(OtherInfo)
                                                            - PATINDEX('%Reason: %',
                                                              OtherInfo) - 7)
                                                 ELSE NULL
                                            END AS Reason
                                  FROM      tblCaseHistory AS CH
                                  WHERE     Type IN ( 'Show', 'NoShow',
                                                      'LateCancel', 'Cancel',
                                                      'Cancelled', 'Unable',
                                                      'Scheduled' )
                                ) AS CH ON C.CaseNbr = CH.CaseNbr
        WHERE   C.PanelNbr IS NOT NULL
                AND C.ApptTime IS NOT NULL
                AND C.ServiceCode IN ( SELECT   ServiceCode
                                       FROM     tblServices
                                       WHERE    ApptBased = 1 )
                AND ISNULL(CH.CHRow, 1) = 1
        ORDER BY C.CaseNbr

INSERT  INTO tblCaseApptPanel
        ( CaseApptID ,
          DoctorCode ,
          SpecialtyCode
        )
        SELECT  ca.CaseApptID ,
                CP.DoctorCode ,
                cp.SpecialtyCode
        FROM    tblCaseAppt AS CA
                INNER JOIN tblCase AS C ON CA.CaseNbr = C.CaseNbr
                INNER JOIN tblCasePanel AS CP ON C.PanelNbr = CP.PanelNbr

--Update Accounting Tracker and Header appointment status ID
UPDATE  tblAcctingTrans
SET     ApptStatusID = CASE Result
                         WHEN 'NoShow' THEN 101
                         WHEN 'Unable' THEN 102
                         WHEN 'Cancel' THEN 50
                         WHEN 'LateCancel' THEN 51
                       END
WHERE   ISNULL(Result, '') <> ''

UPDATE  tblAcctHeader
SET     ApptStatusID = ( SELECT ApptStatusID
                         FROM   tblAcctingTrans
                         WHERE  tblAcctingTrans.SeqNO = tblAcctHeader.SeqNo
                                AND tblAcctingTrans.ApptStatusID IS NOT NULL
                       )

--Update Case appointment information
UPDATE  tblCase
SET     CaseApptID = ( SELECT   CaseApptID
                       FROM     tblCaseAppt
                       WHERE    tblCase.CaseNbr = tblCaseAppt.CaseNbr
                     )
UPDATE  tblCase
SET     ApptStatusID = ( SELECT ApptStatusID
                         FROM   tblCaseAppt
                         WHERE  tblCase.CaseNbr = tblCaseAppt.CaseNbr
                       )
GO


--Web Portal Changes for Appt History from Gary

/****** Object:  StoredProcedure [proc_AreNPCasesPresentByUser]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_AreNPCasesPresentByUser]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_AreNPCasesPresentByUser];
GO

CREATE PROCEDURE [proc_AreNPCasesPresentByUser]
@ewwebuserid int

AS

SELECT TOP 1 CaseNbr FROM tblCase
            WHERE ClientCode IN (SELECT UserCode FROM tblWebUserAccount WHERE WebUserID IN
            (SELECT WebuserID from tblWebUser where ewwebuserid = @ewwebuserid)) AND tblCase.PublishOnWeb = 1


GO


/****** Object:  StoredProcedure [proc_CaseAppt_Delete]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseAppt_Delete]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseAppt_Delete];
GO

CREATE PROCEDURE [proc_CaseAppt_Delete]
(
	@CaseApptId int
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	DELETE
	FROM [tblCaseAppt]
	WHERE
		[CaseApptId] = @CaseApptId
	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_CaseAppt_Insert]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseAppt_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseAppt_Insert];
GO

CREATE PROCEDURE [proc_CaseAppt_Insert]
(
	@CaseApptId int = NULL output,
	@CaseNbr int,
	@ApptTime datetime,
	@DoctorCode int = NULL,
	@LocationCode int = NULL,
	@SpecialtyCode varchar(50) = NULL,
	@ApptStatusId int,
	@DateAdded datetime = NULL,
	@UserIdAdded varchar(15) = NULL,
	@DateEdited datetime = NULL,
	@UserIdEdited varchar(15) = NULL,
	@CanceledById int = NULL,
	@Reason varchar(300) = NULL,
	@LastStatusChg datetime = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseAppt]
	(
		[CaseNbr],
		[ApptTime],
		[DoctorCode],
		[LocationCode],
		[SpecialtyCode],
		[ApptStatusId],
		[DateAdded],
		[UserIdAdded],
		[DateEdited],
		[UserIdEdited],
		[CanceledById],
		[Reason],
		[LastStatusChg]
	)
	VALUES
	(
		@CaseNbr,
		@ApptTime,
		@DoctorCode,
		@LocationCode,
		@SpecialtyCode,
		@ApptStatusId,
		@DateAdded,
		@UserIdAdded,
		@DateEdited,
		@UserIdEdited,
		@CanceledById,
		@Reason,
		@LastStatusChg
	)

	SET @Err = @@Error

	SELECT @CaseApptId = SCOPE_IDENTITY()

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_CaseAppt_LoadByPrimaryKey]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseAppt_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseAppt_LoadByPrimaryKey];
GO

CREATE PROCEDURE [proc_CaseAppt_LoadByPrimaryKey]
(
	@CaseApptId int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCaseAppt]
	WHERE
		([CaseApptId] = @CaseApptId)

	SET @Err = @@Error

	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_IMECase_Insert]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_IMECase_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_IMECase_Insert];
GO

CREATE PROCEDURE [proc_IMECase_Insert]
(
	@casenbr int = NULL output,
	@chartnbr int = NULL,
	@doctorlocation varchar(10) = NULL,
	@clientcode int = NULL,
	@marketercode varchar(15) = NULL,
	@schedulercode varchar(15) = NULL,
	@priority varchar(15) = NULL,
	@status int = NULL,
	@casetype int = NULL,
	@dateadded datetime = NULL,
	@dateedited datetime = NULL,
	@useridadded varchar(15) = NULL,
	@useridedited varchar(15) = NULL,
	@schedcode int = NULL,
	@ApptDate datetime = NULL,
	@Appttime datetime = NULL,
	@claimnbr varchar(50) = NULL,
	@dateofinjury datetime = NULL,
	@allegation text = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
	@schedulenotes text = NULL,
	@requesteddoc varchar(50) = NULL,
	@datemedsrecd datetime = NULL,
	@typemedsrecd varchar(50) = NULL,
	@transreceived datetime = NULL,
	@shownoshow int = NULL,
	@rptstatus varchar(50) = NULL,
	@reportverbal bit = NULL,
	@emailclient bit = NULL,
	@emaildoctor bit = NULL,
	@emailPattny bit = NULL,
	@faxclient bit = NULL,
	@faxdoctor bit = NULL,
	@faxPattny bit = NULL,
	@apptrptsselect bit = NULL,
	@chartprepselect bit = NULL,
	@apptselect bit = NULL,
	@awaittransselect bit = NULL,
	@intransselect bit = NULL,
	@inqaselect bit = NULL,
	@drchartselect bit = NULL,
	@datedrchart datetime = NULL,
	@billedselect bit = NULL,
	@miscselect bit = NULL,
	@invoicedate datetime = NULL,
	@invoiceamt money = NULL,
	@plaintiffattorneycode int = NULL,
	@defenseattorneycode int = NULL,
	@commitdate datetime = NULL,
	@servicecode int = NULL,
	@issuecode int = NULL,
	@doctorcode int = NULL,
	@WCBNbr varchar(50) = NULL,
	@specialinstructions text = NULL,
	@usdvarchar1 varchar(50) = NULL,
	@usdvarchar2 varchar(50) = NULL,
	@usddate1 datetime = NULL,
	@usddate2 datetime = NULL,
	@usdtext1 text = NULL,
	@usdtext2 text = NULL,
	@usdint1 int = NULL,
	@usdint2 int = NULL,
	@usdmoney1 money = NULL,
	@usdmoney2 money = NULL,
	@bComplete bit = NULL,
	@bhanddelivery bit = NULL,
	@sinternalcasenbr varchar(70) = NULL,
	@sreqspecialty varchar(50) = NULL,
	@doctorspecialty varchar(50) = NULL,
	@feecode int = NULL,
	@voucherselect bit = NULL,
	@voucheramt money = NULL,
	@voucherdate datetime = NULL,
	@icd9code varchar(70) = NULL,
	@reccode int = NULL,
	@billclientcode int = NULL,
	@billcompany varchar(100) = NULL,
	@billcontact varchar(70) = NULL,
	@billaddr1 varchar(70) = NULL,
	@billaddr2 varchar(70) = NULL,
	@billcity varchar(70) = NULL,
	@billstate varchar(2) = NULL,
	@billzip varchar(10) = NULL,
	@billARKey varchar(100) = NULL,
	@billfax varchar(15) = NULL,
	@officecode int = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@CertifiedMail bit = NULL,
	@ICD9Code2 varchar(70) = NULL,
	@ICD9Code3 varchar(70) = NULL,
	@ICD9Code4 varchar(70) = NULL,
	@PanelNbr int = NULL,
	@DoctorName varchar(100) = NULL,
	@HearingDate smalldatetime = NULL,
	@CertMailNbr varchar(30) = NULL,
	@laststatuschg datetime = NULL,
	@Jurisdiction varchar(5) = NULL,
	@prevappt datetime = NULL,
	@mastersubcase varchar(1) = NULL,
	@mastercasenbr int = NULL,
	@PublishOnWeb bit = NULL,
	@WebNotifyEmail varchar(200) = NULL,
	@AssessmentToAddress varchar(50) = NULL,
	@OCF25Date smalldatetime = NULL,
	@DateForminDispute smalldatetime = NULL,
	@AssessingFacility varchar(100) = NULL,
	@referralmethod int = NULL,
	@referraltype int = NULL,
	@CSR1 varchar(15) = NULL,
	@CSR2 varchar(15) = NULL,
	@LegalEvent bit = NULL,
	@PILegalEvent bit = NULL,
	@Transcode int = NULL,
	@PublishDocuments bit = NULL,
	@DateReceived datetime = NULL,
	@usddate3 datetime = NULL,
	@usddate4 datetime = NULL,
	@usddate5 datetime = NULL,
	@UsdBit1 bit = NULL,
	@UsdBit2 bit = NULL,
	@ClaimNbrExt varchar(50) = NULL,
	@DefParaLegal int = NULL,
	@AttorneyNote text = NULL,
	@BillingNote text = NULL,
	@InterpreterRequired bit = NULL,
	@TransportationRequired bit = NULL,
	@LanguageID int = NULL,
	@InputSourceID int = NULL,
	@ReqEWAccreditationID int = NULL,
	@RptInitialDraftDate datetime = NULL,
	@RptSentDate datetime = NULL,
	@ApptStatusId int = NULL,
	@CaseApptId int = NULL
	)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCase]
	(
		[chartnbr],
		[doctorlocation],
		[clientcode],
		[marketercode],
		[schedulercode],
		[priority],
		[status],
		[casetype],
		[dateadded],
		[dateedited],
		[useridadded],
		[useridedited],
		[schedcode],
		[ApptDate],
		[Appttime],
		[claimnbr],
		[dateofinjury],
		[allegation],
		[calledinby],
		[notes],
		[schedulenotes],
		[requesteddoc],
		[datemedsrecd],
		[typemedsrecd],
		[transreceived],
		[shownoshow],
		[rptstatus],
		[reportverbal],
		[emailclient],
		[emaildoctor],
		[emailPattny],
		[faxclient],
		[faxdoctor],
		[faxPattny],
		[apptrptsselect],
		[chartprepselect],
		[apptselect],
		[awaittransselect],
		[intransselect],
		[inqaselect],
		[drchartselect],
		[datedrchart],
		[billedselect],
		[miscselect],
		[invoicedate],
		[invoiceamt],
		[plaintiffattorneycode],
		[defenseattorneycode],
		[commitdate],
		[servicecode],
		[issuecode],
		[doctorcode],
		[WCBNbr],
		[specialinstructions],
		[usdvarchar1],
		[usdvarchar2],
		[usddate1],
		[usddate2],
		[usdtext1],
		[usdtext2],
		[usdint1],
		[usdint2],
		[usdmoney1],
		[usdmoney2],
		[bComplete],
		[bhanddelivery],
		[sinternalcasenbr],
		[sreqspecialty],
		[doctorspecialty],
		[feecode],
		[voucherselect],
		[voucheramt],
		[voucherdate],
		[icd9code],
		[reccode],
		[billclientcode],
		[billcompany],
		[billcontact],
		[billaddr1],
		[billaddr2],
		[billcity],
		[billstate],
		[billzip],
		[billARKey],
		[billfax],
		[officecode],
		[QARep],
		[photoRqd],
		[CertifiedMail],
		[ICD9Code2],
		[ICD9Code3],
		[ICD9Code4],
		[PanelNbr],
		[DoctorName],
		[HearingDate],
		[CertMailNbr],
		[laststatuschg],
		[Jurisdiction],
		[prevappt],
		[mastersubcase],
		[mastercasenbr],
		[PublishOnWeb],
		[WebNotifyEmail],
		[AssessmentToAddress],
		[OCF25Date],
		[DateForminDispute],
		[AssessingFacility],
		[referralmethod],
		[referraltype],
		[CSR1],
		[CSR2],
		[LegalEvent],
		[PILegalEvent],
		[Transcode],
		[PublishDocuments],
		[DateReceived],
		[usddate3],
		[usddate4],
		[usddate5],
		[UsdBit1],
		[UsdBit2],
		[ClaimNbrExt],
		[DefParaLegal],
		[AttorneyNote],
		[BillingNote],
		[InterpreterRequired],
		[TransportationRequired],
		[LanguageID],
		[InputSourceID],
		[ReqEWAccreditationID],
		[RptInitialDraftDate],
		[RptSentDate],
		[ApptStatusId],
		[CaseApptId]				
	)
	VALUES
	(
		@chartnbr,
		@doctorlocation,
		@clientcode,
		@marketercode,
		@schedulercode,
		@priority,
		@status,
		@casetype,
		@dateadded,
		@dateedited,
		@useridadded,
		@useridedited,
		@schedcode,
		@ApptDate,
		@Appttime,
		@claimnbr,
		@dateofinjury,
		@allegation,
		@calledinby,
		@notes,
		@schedulenotes,
		@requesteddoc,
		@datemedsrecd,
		@typemedsrecd,
		@transreceived,
		@shownoshow,
		@rptstatus,
		@reportverbal,
		@emailclient,
		@emaildoctor,
		@emailPattny,
		@faxclient,
		@faxdoctor,
		@faxPattny,
		@apptrptsselect,
		@chartprepselect,
		@apptselect,
		@awaittransselect,
		@intransselect,
		@inqaselect,
		@drchartselect,
		@datedrchart,
		@billedselect,
		@miscselect,
		@invoicedate,
		@invoiceamt,
		@plaintiffattorneycode,
		@defenseattorneycode,
		@commitdate,
		@servicecode,
		@issuecode,
		@doctorcode,
		@WCBNbr,
		@specialinstructions,
		@usdvarchar1,
		@usdvarchar2,
		@usddate1,
		@usddate2,
		@usdtext1,
		@usdtext2,
		@usdint1,
		@usdint2,
		@usdmoney1,
		@usdmoney2,
		@bComplete,
		@bhanddelivery,
		@sinternalcasenbr,
		@sreqspecialty,
		@doctorspecialty,
		@feecode,
		@voucherselect,
		@voucheramt,
		@voucherdate,
		@icd9code,
		@reccode,
		@billclientcode,
		@billcompany,
		@billcontact,
		@billaddr1,
		@billaddr2,
		@billcity,
		@billstate,
		@billzip,
		@billARKey,
		@billfax,
		@officecode,
		@QARep,
		@photoRqd,
		@CertifiedMail,
		@ICD9Code2,
		@ICD9Code3,
		@ICD9Code4,
		@PanelNbr,
		@DoctorName,
		@HearingDate,
		@CertMailNbr,
		@laststatuschg,
		@Jurisdiction,
		@prevappt,
		@mastersubcase,
		@mastercasenbr,
		@PublishOnWeb,
		@WebNotifyEmail,
		@AssessmentToAddress,
		@OCF25Date,
		@DateForminDispute,
		@AssessingFacility,
		@referralmethod,
		@referraltype,
		@CSR1,
		@CSR2,
		@LegalEvent,
		@PILegalEvent,
		@Transcode,
		@PublishDocuments,
		@DateReceived,
		@usddate3,
		@usddate4,
		@usddate5,
		@UsdBit1,
		@UsdBit2,
		@ClaimNbrExt,
		@DefParaLegal,
		@AttorneyNote,
		@BillingNote,
		@InterpreterRequired,
		@TransportationRequired,
		@LanguageID,
		@InputSourceID,		
		@ReqEWAccreditationID,
		@RptInitialDraftDate,
		@RptSentDate,
		@ApptStatusId,
		@CaseApptId		
	)

	SET @Err = @@Error

	SELECT @casenbr = SCOPE_IDENTITY()

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_IMECase_Update]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_IMECase_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_IMECase_Update];
GO

CREATE PROCEDURE [proc_IMECase_Update]
(
	@casenbr int,
	@chartnbr int = NULL,
	@doctorlocation varchar(10) = NULL,
	@clientcode int = NULL,
	@marketercode varchar(15) = NULL,
	@schedulercode varchar(15) = NULL,
	@priority varchar(15) = NULL,
	@status int = NULL,
	@casetype int = NULL,
	@dateadded datetime = NULL,
	@dateedited datetime = NULL,
	@useridadded varchar(15) = NULL,
	@useridedited varchar(15) = NULL,
	@schedcode int = NULL,
	@ApptDate datetime = NULL,
	@Appttime datetime = NULL,
	@claimnbr varchar(50) = NULL,
	@dateofinjury datetime = NULL,
	@allegation text = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
	@schedulenotes text = NULL,
	@requesteddoc varchar(50) = NULL,
	@datemedsrecd datetime = NULL,
	@typemedsrecd varchar(50) = NULL,
	@transreceived datetime = NULL,
	@shownoshow int = NULL,
	@rptstatus varchar(50) = NULL,
	@reportverbal bit = NULL,
	@emailclient bit = NULL,
	@emaildoctor bit = NULL,
	@emailPattny bit = NULL,
	@faxclient bit = NULL,
	@faxdoctor bit = NULL,
	@faxPattny bit = NULL,
	@apptrptsselect bit = NULL,
	@chartprepselect bit = NULL,
	@apptselect bit = NULL,
	@awaittransselect bit = NULL,
	@intransselect bit = NULL,
	@inqaselect bit = NULL,
	@drchartselect bit = NULL,
	@datedrchart datetime = NULL,
	@billedselect bit = NULL,
	@miscselect bit = NULL,
	@invoicedate datetime = NULL,
	@invoiceamt money = NULL,
	@plaintiffattorneycode int = NULL,
	@defenseattorneycode int = NULL,
	@commitdate datetime = NULL,
	@servicecode int = NULL,
	@issuecode int = NULL,
	@doctorcode int = NULL,
	@WCBNbr varchar(50) = NULL,
	@specialinstructions text = NULL,
	@usdvarchar1 varchar(50) = NULL,
	@usdvarchar2 varchar(50) = NULL,
	@usddate1 datetime = NULL,
	@usddate2 datetime = NULL,
	@usdtext1 text = NULL,
	@usdtext2 text = NULL,
	@usdint1 int = NULL,
	@usdint2 int = NULL,
	@usdmoney1 money = NULL,
	@usdmoney2 money = NULL,
	@bComplete bit = NULL,
	@bhanddelivery bit = NULL,
	@sinternalcasenbr varchar(70) = NULL,
	@sreqspecialty varchar(50) = NULL,
	@doctorspecialty varchar(50) = NULL,
	@feecode int = NULL,
	@voucherselect bit = NULL,
	@voucheramt money = NULL,
	@voucherdate datetime = NULL,
	@icd9code varchar(70) = NULL,
	@reccode int = NULL,
	@billclientcode int = NULL,
	@billcompany varchar(100) = NULL,
	@billcontact varchar(70) = NULL,
	@billaddr1 varchar(70) = NULL,
	@billaddr2 varchar(70) = NULL,
	@billcity varchar(70) = NULL,
	@billstate varchar(2) = NULL,
	@billzip varchar(10) = NULL,
	@billARKey varchar(100) = NULL,
	@billfax varchar(15) = NULL,
	@officecode int = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@CertifiedMail bit = NULL,
	@ICD9Code2 varchar(70) = NULL,
	@ICD9Code3 varchar(70) = NULL,
	@ICD9Code4 varchar(70) = NULL,
	@PanelNbr int = NULL,
	@DoctorName varchar(100) = NULL,
	@HearingDate smalldatetime = NULL,
	@CertMailNbr varchar(30) = NULL,
	@laststatuschg datetime = NULL,
	@Jurisdiction varchar(5) = NULL,
	@prevappt datetime = NULL,
	@mastersubcase varchar(1) = NULL,
	@mastercasenbr int = NULL,
	@PublishOnWeb bit = NULL,
	@WebNotifyEmail varchar(200) = NULL,
	@AssessmentToAddress varchar(50) = NULL,
	@OCF25Date smalldatetime = NULL,
	@DateForminDispute smalldatetime = NULL,
	@AssessingFacility varchar(100) = NULL,
	@referralmethod int = NULL,
	@referraltype int = NULL,
	@CSR1 varchar(15) = NULL,
	@CSR2 varchar(15) = NULL,
	@LegalEvent bit = NULL,
	@PILegalEvent bit = NULL,
	@Transcode int = NULL,
	@PublishDocuments bit = NULL,
	@DateReceived datetime = NULL,
	@usddate3 datetime = NULL,
	@usddate4 datetime = NULL,
	@usddate5 datetime = NULL,
	@UsdBit1 bit = NULL,
	@UsdBit2 bit = NULL,
	@ClaimNbrExt varchar(50) = NULL,
	@DefParaLegal int = NULL,
	@AttorneyNote text = NULL,
	@BillingNote text = NULL,
	@InterpreterRequired bit = NULL,
	@TransportationRequired bit = NULL,
	@LanguageID int = NULL,
	@InputSourceID int = NULL,
	@ReqEWAccreditationID int = NULL,
	@RptInitialDraftDate datetime = NULL,
	@RptSentDate datetime = NULL,
	@ApptStatusId int = NULL,
	@CaseApptId int = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCase]
	SET
		[chartnbr] = @chartnbr,
		[doctorlocation] = @doctorlocation,
		[clientcode] = @clientcode,
		[marketercode] = @marketercode,
		[schedulercode] = @schedulercode,
		[priority] = @priority,
		[status] = @status,
		[casetype] = @casetype,
		[dateadded] = @dateadded,
		[dateedited] = @dateedited,
		[useridadded] = @useridadded,
		[useridedited] = @useridedited,
		[schedcode] = @schedcode,
		[ApptDate] = @ApptDate,
		[Appttime] = @Appttime,
		[claimnbr] = @claimnbr,
		[dateofinjury] = @dateofinjury,
		[allegation] = @allegation,
		[calledinby] = @calledinby,
		[notes] = @notes,
		[schedulenotes] = @schedulenotes,
		[requesteddoc] = @requesteddoc,
		[datemedsrecd] = @datemedsrecd,
		[typemedsrecd] = @typemedsrecd,
		[transreceived] = @transreceived,
		[shownoshow] = @shownoshow,
		[rptstatus] = @rptstatus,
		[reportverbal] = @reportverbal,
		[emailclient] = @emailclient,
		[emaildoctor] = @emaildoctor,
		[emailPattny] = @emailPattny,
		[faxclient] = @faxclient,
		[faxdoctor] = @faxdoctor,
		[faxPattny] = @faxPattny,
		[apptrptsselect] = @apptrptsselect,
		[chartprepselect] = @chartprepselect,
		[apptselect] = @apptselect,
		[awaittransselect] = @awaittransselect,
		[intransselect] = @intransselect,
		[inqaselect] = @inqaselect,
		[drchartselect] = @drchartselect,
		[datedrchart] = @datedrchart,
		[billedselect] = @billedselect,
		[miscselect] = @miscselect,
		[invoicedate] = @invoicedate,
		[invoiceamt] = @invoiceamt,
		[plaintiffattorneycode] = @plaintiffattorneycode,
		[defenseattorneycode] = @defenseattorneycode,
		[commitdate] = @commitdate,
		[servicecode] = @servicecode,
		[issuecode] = @issuecode,
		[doctorcode] = @doctorcode,
		[WCBNbr] = @WCBNbr,
		[specialinstructions] = @specialinstructions,
		[usdvarchar1] = @usdvarchar1,
		[usdvarchar2] = @usdvarchar2,
		[usddate1] = @usddate1,
		[usddate2] = @usddate2,
		[usdtext1] = @usdtext1,
		[usdtext2] = @usdtext2,
		[usdint1] = @usdint1,
		[usdint2] = @usdint2,
		[usdmoney1] = @usdmoney1,
		[usdmoney2] = @usdmoney2,
		[bComplete] = @bComplete,
		[bhanddelivery] = @bhanddelivery,
		[sinternalcasenbr] = @sinternalcasenbr,
		[sreqspecialty] = @sreqspecialty,
		[doctorspecialty] = @doctorspecialty,
		[feecode] = @feecode,
		[voucherselect] = @voucherselect,
		[voucheramt] = @voucheramt,
		[voucherdate] = @voucherdate,
		[icd9code] = @icd9code,
		[reccode] = @reccode,
		[billclientcode] = @billclientcode,
		[billcompany] = @billcompany,
		[billcontact] = @billcontact,
		[billaddr1] = @billaddr1,
		[billaddr2] = @billaddr2,
		[billcity] = @billcity,
		[billstate] = @billstate,
		[billzip] = @billzip,
		[billARKey] = @billARKey,
		[billfax] = @billfax,
		[officecode] = @officecode,
		[QARep] = @QARep,
		[photoRqd] = @photoRqd,
		[CertifiedMail] = @CertifiedMail,
		[ICD9Code2] = @ICD9Code2,
		[ICD9Code3] = @ICD9Code3,
		[ICD9Code4] = @ICD9Code4,
		[PanelNbr] = @PanelNbr,
		[DoctorName] = @DoctorName,
		[HearingDate] = @HearingDate,
		[CertMailNbr] = @CertMailNbr,
		[laststatuschg] = @laststatuschg,
		[Jurisdiction] = @Jurisdiction,
		[prevappt] = @prevappt,
		[mastersubcase] = @mastersubcase,
		[mastercasenbr] = @mastercasenbr,
		[PublishOnWeb] = @PublishOnWeb,
		[WebNotifyEmail] = @WebNotifyEmail,
		[AssessmentToAddress] = @AssessmentToAddress,
		[OCF25Date] = @OCF25Date,
		[DateForminDispute] = @DateForminDispute,
		[AssessingFacility] = @AssessingFacility,
		[referralmethod] = @referralmethod,
		[referraltype] = @referraltype,
		[CSR1] = @CSR1,
		[CSR2] = @CSR2,
		[LegalEvent] = @LegalEvent,
		[PILegalEvent] = @PILegalEvent,
		[Transcode] = @Transcode,
		[PublishDocuments] = @PublishDocuments,
		[DateReceived] = @DateReceived,
		[usddate3] = @usddate3,
		[usddate4] = @usddate4,
		[usddate5] = @usddate5,
		[UsdBit1] = @UsdBit1,
		[UsdBit2] = @UsdBit2,
		[ClaimNbrExt] = @ClaimNbrExt,
		[DefParaLegal] = @DefParaLegal,
		[AttorneyNote] = @AttorneyNote,
		[BillingNote] = @BillingNote,
		[InterpreterRequired] = @InterpreterRequired,
		[TransportationRequired] = @TransportationRequired,
		[LanguageID] = @LanguageID,
		[InputSourceID] = @InputSourceID,
		[ReqEWAccreditationID] = @ReqEWAccreditationID,
		[RptInitialDraftDate] =	@RptInitialDraftDate,
		[RptSentDate] =	@RptSentDate,		
		[ApptStatusId] = @ApptStatusId,	
		[CaseApptId] = @CaseApptId			
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
GO


UPDATE tblControl SET DBVersion='1.90'
GO
