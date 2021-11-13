
--Only display Case Status on the latest appointment line or no appointment
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
            tblClient.lastname + ', ' + tblClient.firstname AS ClientName ,
            tblLocation.Location ,
            CASE WHEN
             tblCaseAppt.CaseApptID=tblCase.CaseApptID OR 
             ROW_NUMBER() OVER (PARTITION BY tblCase.CaseNbr ORDER BY tblCaseAppt.CaseApptID DESC)=1
            THEN tblQueues.StatusDesc
            ELSE ''
            END AS StatusDesc ,
            ISNULL(ApptSpec.Description, ISNULL(CaseSpec.Description, ReqSpec.Description)) AS SpecialtyDesc ,
            ReqSpec.Description ,
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
            LEFT OUTER JOIN tblSpecialty AS	ReqSpec ON tblCase.sreqspecialty = ReqSpec.specialtycode
            LEFT OUTER JOIN tblSpecialty AS CaseSpec ON tblCase.DoctorSpecialty = CaseSpec.specialtycode
            LEFT OUTER JOIN tblSpecialty AS ApptSpec ON ApptSpec.specialtycode = tblCaseAppt.SpecialtyCode
            LEFT OUTER JOIN tblDoctor ON ISNULL(tblCaseAppt.DoctorCode, tblCase.DoctorCode) = tblDoctor.doctorcode
            LEFT OUTER JOIN tblLocation ON tblCaseAppt.LocationCode = tblLocation.locationcode
            LEFT OUTER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
    WHERE   ( tblCase.chartnbr = @chartnbr )
            AND ( tblUserOffice.userid = @userid )
    ORDER BY ISNULL(tblCase.mastercasenbr, tblCase.casenbr) DESC ,
            tblCase.mastersubcase ,
            tblCase.ApptDate DESC ,
            tblCaseAppt.CaseApptID DESC
GO


--Add a new linkage field between tblAcctHeader and tblCaseDocument.SeqNo
ALTER TABLE [tblAcctHeader]
  ADD [CaseDocID] INTEGER
GO


UPDATE tblControl SET DBVersion='1.92'
GO
