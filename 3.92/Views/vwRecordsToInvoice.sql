CREATE VIEW vwRecordsToInvoice
AS
    SELECT  tblRecordsObtainment.CaseNbr ,
            tblObtainmentType.Description ,
            tblProduct.Description AS Product ,
            tblFacility.Name AS Facility ,
            tblRecordsObtainment.ObtainmentTypeID ,
            tblRecordsObtainment.Fee ,
            tblRecordsObtainment.RecordsID ,
            tblObtainmentType.ProdCode
    FROM    tblRecordsObtainment
            INNER JOIN tblObtainmentType ON tblRecordsObtainment.ObtainmentTypeID = tblObtainmentType.ObtainmentTypeID
            LEFT OUTER JOIN tblFacility ON tblRecordsObtainment.FacilityID = tblFacility.FacilityID
            LEFT OUTER JOIN tblProduct ON tblObtainmentType.ProdCode = tblProduct.ProdCode
    WHERE   ( tblRecordsObtainment.InvHeaderID IS NULL )
            AND ( tblRecordsObtainment.ObtainmentTypeID <> 1 )
            AND ( tblRecordsObtainment.Fee <> 0 )
