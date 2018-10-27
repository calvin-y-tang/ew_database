
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblAddendumCodes]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblAddendumCodes
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblAnnouncement]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblAnnouncement
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblBillStatus]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblBillStatus
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblCaseAndClient]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblCaseAndClient
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblCaseTypeJurisdictionTerms]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblCaseTypeJurisdictionTerms
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblCaseTypeServiceDocument]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblCaseTypeServiceDocument
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblCCaddresstemp]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblCCaddresstemp
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblCompanyccEnvelope]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblCompanyccEnvelope
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblDoctorImport]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblDoctorImport
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblFRCategoryBak]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblFRCategoryBak
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblGPCaseType]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblGPCaseType
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblGPOffice]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblGPOffice
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblInterfaceLog]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblInterfaceLog
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblMRU]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblMRU
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestion]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestion
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestionCase]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestionCase
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestionDescription]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestionDescription
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestionHeading]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestionHeading
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestionInstruction]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestionInstruction
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestionIssue]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestionIssue
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestionProblem]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestionProblem
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblQuestionResponse]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblQuestionResponse
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblRating]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblRating
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblReferralmethod]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblReferralmethod
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblReferralType]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblReferralType
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblRegion]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblRegion
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblReport]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblReport
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblReportQuestion]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblReportQuestion
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblSpecialtyXref]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblSpecialtyXref
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblTreatingPhysician]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblTreatingPhysician
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblTempCustomers]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblTempCustomers
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblTempInvoices]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblTempInvoices
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblTempVendors]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblTempVendors
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblTempVouchers]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblTempVouchers
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblWebApptRequestReceived]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblWebApptRequestReceived
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblFRModifier]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblFRModifier
IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblProviderPercent]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
    DROP TABLE tblProviderPercent

GO



DROP VIEW [dbo].[vwCaseOtherContacts]
GO

CREATE VIEW [dbo].[vwCaseOtherContacts]
AS
SELECT CaseNbr, 'CC' AS Type, FirstName, LastName, Company, Email, Fax from vwCaseCC
UNION
SELECT C.CaseNbr, 'DefAttny', CC.FirstName, CC.LastName, CC.Company, CC.Email, CC.Fax FROM tblCase AS C INNER JOIN tblCCAddress AS CC ON DefenseAttorneyCode=CCCode
UNION
SELECT C.CaseNbr, 'DefParalegal:', CC.FirstName, CC.LastName, CC.Company, CC.Email, CC.Fax FROM tblCase AS C INNER JOIN tblCCAddress AS CC ON C.DefParaLegal=CCCode
UNION
SELECT casenbr, type, firstname, lastname, companyname, emailAddr, faxNbr from vwCaseOtherParty
UNION
SELECT C.CaseNbr, 'ExamLoc', L.ContactFirst, L.ContactLast, L.Location, L.Email, L.Fax FROM tblCase AS C INNER JOIN tblLocation AS L ON C.DoctorLocation=L.LocationCode
UNION
SELECT C.CaseNbr, 'Treat Phy', E.TreatingPhysician, '', '', E.TreatingPhysicianEmail, E.TreatingPhysicianFax FROM tblCase AS C INNER JOIN tblExaminee AS E ON C.ChartNbr=E.ChartNbr
UNION
SELECT C.CaseNbr, '3rd Party', CL.FirstName, CL.LastName, COM.IntName, CL.Email, COALESCE(NULLIF(CL.BillFax,''), NULLIF(CL.Fax,'')) FROM tblCase AS C INNER JOIN tblClient AS CL ON C.BillClientCode=CL.ClientCode INNER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode
UNION
SELECT C.CaseNbr, 'Processor', CL.ProcessorFirstName, CL.ProcessorLastName, COM.IntName, CL.ProcessorEmail, CL.ProcessorFax FROM tblCase AS C INNER JOIN tblClient AS CL ON C.ClientCode=CL.ClientCode INNER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode
UNION
SELECT TRO.CaseNbr, 'Facility', TF.ContactFirst, TF.ContactLast, TF.Name, TF.Email, TF.Fax FROM tblCase AS C INNER JOIN tblRecordsObtainment AS TRO ON TRO.CaseNbr = C.CaseNbr INNER JOIN tblFacility AS TF ON TF.FacilityID = TRO.FacilityID

GO

DROP VIEW [vwClientDefaults]
GO

CREATE VIEW [dbo].[vwClientDefaults]
AS
    SELECT  tblClient.marketercode AS clientmarketer ,
            dbo.tblCompany.intname ,
            dbo.tblClient.reportphone ,
            dbo.tblClient.priority ,
            dbo.tblClient.clientcode ,
            dbo.tblClient.fax ,
            dbo.tblClient.email ,
            dbo.tblClient.phone1 ,
            dbo.tblClient.documentemail AS emailclient ,
            dbo.tblClient.documentfax AS faxclient ,
            dbo.tblClient.documentmail AS mailclient ,
            ISNULL(dbo.tblClient.casetype, tblCompany.CaseType) AS CaseType ,
            dbo.tblClient.feeschedule ,
            dbo.tblCompany.credithold ,
            dbo.tblCompany.preinvoice ,
            dbo.tblClient.billaddr1 ,
            dbo.tblClient.billaddr2 ,
            dbo.tblClient.billcity ,
            dbo.tblClient.billstate ,
            dbo.tblClient.billzip ,
            dbo.tblClient.billattn ,
            dbo.tblClient.ARKey ,
            dbo.tblClient.addr1 ,
            dbo.tblClient.addr2 ,
            dbo.tblClient.city ,
            dbo.tblClient.state ,
            dbo.tblClient.zip ,
            dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname ,
            dbo.tblClient.prefix AS clientprefix ,
            dbo.tblClient.suffix AS clientsuffix ,
            dbo.tblClient.lastname ,
            dbo.tblClient.firstname ,
            dbo.tblClient.billfax ,
            dbo.tblClient.QARep ,
            ISNULL(dbo.tblClient.photoRqd, tblCompany.photoRqd) AS photoRqd ,
            dbo.tblClient.CertifiedMail ,
            dbo.tblClient.PublishOnWeb ,
            dbo.tblClient.UseNotificationOverrides ,
            dbo.tblClient.CSR1 ,
            dbo.tblClient.CSR2 ,
            dbo.tblClient.AutoReschedule ,
            dbo.tblClient.DefOfficeCode ,
            ISNULL(dbo.tblClient.marketercode, tblCompany.marketercode) AS marketer ,
            dbo.tblCompany.Jurisdiction
    FROM    dbo.tblClient
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
GO

DROP VIEW vwCaseTrans
GO
CREATE VIEW vwCaseTrans

AS
    SELECT  tblCaseTrans.CaseNbr ,
            tblCaseTrans.LineNbr ,
            tblCaseTrans.Type ,
            tblCaseTrans.Date ,
            tblCaseTrans.ProdCode ,
            tblCaseTrans.CPTCode ,
            tblCaseTrans.LongDesc ,
            tblCaseTrans.unit ,
            tblCaseTrans.unitAmount ,
            tblCaseTrans.extendedAmount ,
            tblCaseTrans.Taxable ,
            tblCaseTrans.DateAdded ,
            tblCaseTrans.UserIDAdded ,
            tblCaseTrans.DateEdited ,
            tblCaseTrans.UserIDEdited ,
            tblCaseTrans.DocumentNbr ,
            tblCaseTrans.DrOPCode ,
            tblCaseTrans.DrOPType ,
            tblCaseTrans.SeqNo ,
            tblCaseTrans.LineItemType ,
            tblCaseTrans.Location ,
            tblCaseTrans.UnitOfMeasureCode,
			tblCaseTrans.CreateInvoiceVoucher
    FROM    TblCaseTrans
    WHERE   ( documentnbr IS NULL )
GO


UPDATE [tblExceptionList] 
SET [Description] = 'Appointment Cancellation' 
WHERE [ExceptionID] = 1;

UPDATE [tblExceptionList] 
SET [Description] = 'Appointment Cancellation with a Pre-Invoice Client' 
WHERE [ExceptionID] = 2;

UPDATE [tblExceptionList] 
SET [Description] = 'Appointment Cancellation with a Pre-Pay Doctor' 
WHERE [ExceptionID] = 3;

INSERT INTO [dbo].[tblExceptionList]
([Description], [Status], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited])
VALUES ('Case Cancellation', 'Active', GetDate(), 'Admin', GetDate(), 'Admin')

GO



UPDATE tblCompany set PhotoRqd = 0 where PhotoRqd is null

UPDATE tblCase set PhotoRqd = 0 where PhotoRqd is null 
GO

Update tblClient 
   set PhotoRqd = null 
  from tblClient cl 
          inner join tblCompany co on cl.CompanyCode = co.CompanyCode 
where cl.PhotoRqd = co.PhotoRqd

GO

DELETE FROM tblUserFunction
 WHERE FunctionCode='edituserdefined'
DELETE FROM tblGroupFunction
 WHERE FunctionCode='edituserdefined'
DELETE FROM tblUserOfficeFunction
 WHERE FunctionCode='edituserdefined'
GO

DELETE FROM tblUserFunction
 WHERE FunctionCode='CustomProgram'
DELETE FROM tblGroupFunction
 WHERE FunctionCode='CustomProgram'
DELETE FROM tblUserOfficeFunction
 WHERE FunctionCode='CustomProgram'
GO

UPDATE tblControl SET DBVersion='2.63'
GO
