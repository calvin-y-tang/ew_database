-- Issue 11654 - add new token for claim number extension only
INSERT INTO [dbo].[tblMessageToken] ([Name], [Description]) VALUES ('@ClaimNbrExt@ ', '')
GO


UPDATE U SET U.DisplayOrder=SM.RowNbr
FROM tblDPSSortModel AS U
INNER JOIN
(SELECT SortModelID, Description, ROW_NUMBER() OVER (ORDER BY Description) AS RowNbr
FROM tblDPSSortModel) AS SM ON U.SortModelID = SM.SortModelID
GO

-- Issue 11137 - data patch fot acctquotefee to link in prodcode
     UPDATE AQF
        SET AQF.QuoteFeeConfigID = QFC.QuoteFeeConfigID
     FROM tblAcctQuoteFee AS AQF
               INNER JOIN tblQuoteFeeConfig as QFC ON QFC.FeeValueName = AQF.FeeValueName
GO 

-- Issue 11137 - patch tblAcctDetail to set existing row to FeeCodeSource where FeeCode is present
UPDATE tblAcctDetail SET FeeCodeSource = 1 WHERE FeeCode IS NOT NULL AND FeeCodeSource IS NULL
GO 

-- Issue 11137 - patch tblAcctHeader to set existing rows to FeeCodeSource where FeeCode is present
UPDATE tblAcctHeader SET FeeCodeSource = 1 WHERE FeeCode IS NOT NULL AND FeeCodeSource IS NULL
GO 

-- Issue 11137 - patch tblAcctQuoteFee to set value for QuoteFeeConfigID
UPDATE AQ
   SET AQ.QuoteFeeConfigID = QF.QuoteFeeConfigID
FROM tblAcctQuoteFee AS AQ
          INNER JOIN tblQuoteFeeConfig AS QF ON QF.FeeValueName = AQ.FeeValueName
WHERE AQ.QuoteFeeConfigID IS NULL
GO

DELETE FROM [tblCaseApptRequestStatus]
INSERT INTO [dbo].[tblCaseApptRequestStatus] ([CaseApptRequestStatusID], [Name]) VALUES (0, 'Pending Acceptance')
INSERT INTO [dbo].[tblCaseApptRequestStatus] ([CaseApptRequestStatusID], [Name]) VALUES (1, 'Accepted')
INSERT INTO [dbo].[tblCaseApptRequestStatus] ([CaseApptRequestStatusID], [Name]) VALUES (2, 'Rejected')
GO
