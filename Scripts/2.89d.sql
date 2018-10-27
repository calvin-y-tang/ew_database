--Patch for fee schedule and product changes
UPDATE tblDoctorOffice SET FeeCode=D.FeeCode
 FROM tblDoctorOffice AS DO INNER JOIN tblDoctor AS D ON D.DoctorCode = DO.DoctorCode
 WHERE DO.FeeCode IS NULL AND D.FeeCode IS NOT NULL
GO
UPDATE CO SET CO.FeeCode=C.FeeCode
 FROM tblCompany AS C
 INNER JOIN tblCompanyOffice AS CO ON CO.CompanyCode = C.CompanyCode
 WHERE CO.FeeCode IS NULL AND C.FeeCode IS NOT NULL
GO
UPDATE CO SET CO.InvoiceDocument=C.InvoiceDocument
 FROM tblCompany AS C
 INNER JOIN tblCompanyOffice AS CO ON CO.CompanyCode = C.CompanyCode
 WHERE CO.InvoiceDocument IS NULL AND C.InvoiceDocument IS NOT NULL
GO

TRUNCATE TABLE tblProductOffice
INSERT INTO tblProductOffice
        (
         ProdCode,
         OfficeCode,
         DateAdded,
         UserIDAdded
        )
SELECT ProdCode, O.OfficeCode, GETDATE(), 'Convert'
 FROM tblProduct AS P
 INNER JOIN tblOffice AS O ON O.Status='Active'
GO


TRUNCATE TABLE tblFeeHeaderOffice
INSERT INTO tblFeeHeaderOffice
        (
         FeeCode,
         OfficeCode,
         DateAdded,
         UserIDAdded
        )
SELECT FeeCode, O.OfficeCode, GETDATE(), 'Convert'
 FROM tblFeeHeader AS F
 INNER JOIN tblOffice AS O ON O.Status='Active'
 WHERE F.FeeCalcMethod=1
GO




Delete FROM tblServiceWorkflowQueueDocument
 WHERE Document NOT IN (SELECT Document FROM tblDocument)
GO

DELETE FROM tblPublishOnWeb WHERE TableType='tblQueueDocuments'
GO
