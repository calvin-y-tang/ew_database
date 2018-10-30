 
CREATE VIEW vwRptOutstandingRecords
AS
    SELECT DISTINCT
            tblFacility.Name AS Facility ,
            tblFacility.Phone AS FacilityPhone ,
            tblFacility.Fax AS FacilityFax ,
            tblRecordsObtainment.CheckDate ,
            tblRecordsObtainment.Fee ,
            tblRecordsObtainment.CheckNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS Examinee ,
            tblCase.ClaimNbr ,
            tblCase.CaseNbr ,
            tblRecordsObtainmentDetail.DateReceived ,
            tblCase.OfficeCode ,
            tblRecordsObtainment.WaitingForInvoice ,
            tblRecordsObtainmentDetail.NotAvailable , 
			dbo.tblCase.ExtCaseNbr 
    FROM    tblRecordsObtainment
            INNER JOIN tblRecordsObtainmentDetail ON tblRecordsObtainment.RecordsID = tblRecordsObtainmentDetail.RecordsID
            INNER JOIN tblFacility ON tblRecordsObtainment.FacilityID = tblFacility.FacilityID
            INNER JOIN tblCase ON tblRecordsObtainment.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
    WHERE   ( tblRecordsObtainmentDetail.DateReceived IS NULL )
            AND ( tblRecordsObtainmentDetail.NotAvailable = 0
                  OR tblRecordsObtainmentDetail.NotAvailable IS NULL
                )
            AND ( tblRecordsObtainment.CheckNbr IS NOT NULL )
            AND ( tblRecordsObtainment.Fee <> 0 )
