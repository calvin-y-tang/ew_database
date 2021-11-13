
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwLibertyExport]
AS
SELECT     dbo.tblCase.DateReceived, dbo.tblCase.claimnbr, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS ExamineeName, 
                      dbo.tblClient.lastname + '. ' + dbo.tblClient.firstname AS ClientName, dbo.tblCase.Jurisdiction, dbo.TblAcctHeader.apptdate, 
                      dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS Doctorname, dbo.tblSpecialty.description AS Specialty, dbo.TblAcctHeader.documenttotal AS Charge, 
                      dbo.TblAcctHeader.documentnbr, dbo.TblAcctHeader.documenttype, dbo.tblCompany.extname AS Company,
                          (SELECT     TOP (1) CPTcode
                            FROM          dbo.TblAcctDetail
                            WHERE      (documentnbr = dbo.TblAcctHeader.documentnbr) AND (documenttype = dbo.TblAcctHeader.documenttype)
                            ORDER BY linenbr) AS CPTCode,
                          (SELECT     TOP (1) modifier
                            FROM          dbo.TblAcctDetail AS TblAcctDetail_1
                            WHERE      (documentnbr = dbo.TblAcctHeader.documentnbr) AND (documenttype = dbo.TblAcctHeader.documenttype)
                            ORDER BY linenbr) AS CPTModifier,
                          (SELECT     TOP (1) eventdate
                            FROM          dbo.tblCaseHistory
                            WHERE      (casenbr = dbo.tblCase.casenbr)
                            ORDER BY eventdate DESC) AS DateFinalized, dbo.TblAcctHeader.documentdate, dbo.TblAcctHeader.documentstatus, dbo.TblAcctHeader.casenbr, 
                      dbo.tblCase.servicecode, dbo.tblServices.description AS Service, dbo.tblCaseType.ShortDesc AS CaseType, dbo.tblClient.usdvarchar2 AS Market, 
                      dbo.tblCase.usdvarchar1 AS RequestedAs, dbo.tblCase.usdint1 AS ReferralNbr
FROM         dbo.tblCase INNER JOIN
                      dbo.TblAcctHeader ON dbo.tblCase.casenbr = dbo.TblAcctHeader.casenbr INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode LEFT OUTER JOIN
                      dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.TblAcctHeader.DrOpCode = dbo.tblDoctor.doctorcode
WHERE     (dbo.TblAcctHeader.documenttype = 'IN') AND (dbo.TblAcctHeader.documentstatus = 'Final')
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER TABLE [tblDocument]
  ADD [OffsetX] FLOAT
GO

ALTER TABLE [tblDocument]
  ADD [OffsetY] FLOAT
GO


update tblControl set DBVersion='1.16'
GO
