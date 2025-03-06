ALTER TABLE [dbo].[tblCaseStatistics] DROP CONSTRAINT [PK_casestatistics]
GO
ALTER TABLE [dbo].[tblWebApptRequest] DROP CONSTRAINT [PK_tblWebApptRequest]
GO
ALTER TABLE [dbo].[tblWebApptRequest] DROP CONSTRAINT [DF_tblWebApptRequest_officecode]
GO
ALTER TABLE [dbo].[tblWebClient] DROP CONSTRAINT [PK_tblWebClient]
GO
DROP TABLE [dbo].[tblWebClient]
GO
DROP TABLE [dbo].[tblWebAdjuster]
GO
DROP TABLE [dbo].[tblCaseStatistics]
GO
DROP TABLE [dbo].[tblWebApptRequest]
GO
DROP PROCEDURE [dbo].[proc_casesToSynch]
GO
DROP PROCEDURE [dbo].[proc_tblCaseHistoryUpdate]
GO
DROP PROCEDURE [dbo].[proc_tblCaseHistoryInsert]
GO
DROP PROCEDURE [dbo].[proc_tblCaseDocumentsUpdate]
GO
DROP PROCEDURE [dbo].[proc_tblCaseDocumentsInsert]
GO

IF EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[dtproperties]')
                    AND OBJECTPROPERTY(id, N'IsUserTable') = 1 )
DROP TABLE dtproperties
GO




ALTER TABLE [dbo].[tblCaseRelatedParty] ADD CONSTRAINT [PK_tblCaseRelatedParty] PRIMARY KEY CLUSTERED  ([CaseRPID])
GO


CREATE VIEW [dbo].[vwRptMEINotification]
AS
SELECT     dbo.tblCase.casenbr, dbo.tblExaminee.addr1 AS examineeaddr1, dbo.tblExaminee.addr2 AS examineeaddr2, 
                      dbo.tblExaminee.city + ', ' + dbo.tblExaminee.state + '  ' + dbo.tblExaminee.zip AS examineecitystatezip, dbo.tblLocation.addr1 AS doctoraddr1, 
                      dbo.tblLocation.addr2 AS doctoraddr2, dbo.tblLocation.city + ', ' + dbo.tblLocation.state + '  ' + dbo.tblLocation.zip AS doctorcitystatezip, dbo.tblCase.ApptDate, 
                      dbo.tblCase.Appttime, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, dbo.tblExaminee.phone1 AS examineephone, 
                      tblCCAddress_2.firstname + ' ' + tblCCAddress_2.lastname AS attorneyname, tblCCAddress_2.company AS attorneycompany, 
                      tblCCAddress_2.address1 AS attorneyaddr1, tblCCAddress_2.address2 AS attorneyaddr2, 
                      tblCCAddress_2.city + ', ' + tblCCAddress_2.state + '  ' + tblCCAddress_2.zip AS attorneycitystatezip, 
                      tblCCAddress_2.phone + ISNULL(tblCCAddress_2.phoneextension, '') AS attorneyphone, tblCCAddress_2.fax AS attorneyfax, tblCCAddress_2.email AS attorneyemail, 
                      dbo.tblLocation.location, dbo.tblExaminee.email AS examineeemail, dbo.tblCase.officecode, dbo.tblCase.DoctorName, dbo.tblCase.bln3DayNotifClaimant, 
                      dbo.tblCase.bln3DayNotifAttorney, dbo.tblCase.bln14DayNotifClaimant, dbo.tblCase.bln14DayNotifAttorney, dbo.tblServices.description AS servicedesc, 
                      dbo.tblCase.doctorcode, dbo.tblCase.status
FROM         dbo.tblOffice INNER JOIN
                      dbo.tblExaminee INNER JOIN
                      dbo.tblCase ON dbo.tblExaminee.chartnbr = dbo.tblCase.chartnbr ON dbo.tblOffice.officecode = dbo.tblCase.officecode INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblCCAddress AS tblCCAddress_2 ON dbo.tblCase.plaintiffattorneycode = tblCCAddress_2.cccode INNER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
UNION
SELECT     tblCase_1.casenbr, tblExaminee_1.addr1 AS examineeaddr1, tblExaminee_1.addr2 AS examineeaddr2, 
                      tblExaminee_1.city + ', ' + tblExaminee_1.state + '  ' + tblExaminee_1.zip AS examineecitystatezip, tblLocation_1.addr1 AS doctoraddr1, 
                      tblLocation_1.addr2 AS doctoraddr2, tblLocation_1.city + ', ' + tblLocation_1.state + '  ' + tblLocation_1.zip AS doctorcitystatezip, tblCase_1.ApptDate, 
                      tblCase_1.Appttime, tblExaminee_1.firstname + ' ' + tblExaminee_1.lastname AS examineename, tblExaminee_1.phone1 AS examineephone, 
                      tblCCAddress_2.firstname + ' ' + tblCCAddress_2.lastname AS attorneyname, tblCCAddress_2.company AS attorneycompany, 
                      tblCCAddress_2.address1 AS attorneyaddr1, tblCCAddress_2.address2 AS attorneyaddr2, 
                      tblCCAddress_2.city + ', ' + tblCCAddress_2.state + '  ' + tblCCAddress_2.zip AS attorneycitystatezip, 
                      tblCCAddress_2.phone + ISNULL(tblCCAddress_2.phoneextension, '') AS attorneyphone, tblCCAddress_2.fax AS attorneyfax, tblCCAddress_2.email AS attorneyemail, 
                      tblLocation_1.location, tblExaminee_1.email AS examineeemail, tblCase_1.officecode, tblCase_1.DoctorName, tblCase_1.bln3DayNotifClaimant, 
                      tblCase_1.bln3DayNotifAttorney, tblCase_1.bln14DayNotifClaimant, tblCase_1.bln14DayNotifAttorney, tblServices_1.description AS servicedesc, 
                      dbo.tblCasePanel.doctorcode, tblCase_1.status
FROM         dbo.tblOffice AS tblOffice_1 INNER JOIN
                      dbo.tblExaminee AS tblExaminee_1 INNER JOIN
                      dbo.tblCase AS tblCase_1 ON tblExaminee_1.chartnbr = tblCase_1.chartnbr ON tblOffice_1.officecode = tblCase_1.officecode INNER JOIN
                      dbo.tblServices AS tblServices_1 ON tblCase_1.servicecode = tblServices_1.servicecode INNER JOIN
                      dbo.tblCasePanel ON tblCase_1.PanelNbr = dbo.tblCasePanel.panelnbr LEFT OUTER JOIN
                      dbo.tblLocation AS tblLocation_1 ON tblCase_1.doctorlocation = tblLocation_1.locationcode LEFT OUTER JOIN
                      dbo.tblCCAddress AS tblCCAddress_2 ON tblCase_1.plaintiffattorneycode = tblCCAddress_2.cccode
GO
CREATE TABLE [dbo].[tblRptMEINotification]
(
[ProcessID] [int] NOT NULL,
[Casenbr] [int] NULL,
[ApptDate] [datetime] NULL,
[CancelDate] [datetime] NULL,
[ExamineeName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExamineeAddr1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExamineeAddr2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExamineeCityStateZip] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Examineephone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyCompany] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyAddr1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyAddr2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyCityStateZip] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attorneyphone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyEmail] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bln3DayNotifClaimant] [bit] NULL,
[bln3DayNotifAttorney] [bit] NULL,
[bln14DayNotifClaimant] [bit] NULL,
[bln14DayNotifAttorney] [bit] NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_tblRptMEINotification] ON [dbo].[tblRptMEINotification] ([ProcessID])
GO






IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_GetCaseAccredidationByCaseNbr]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROC [proc_GetCaseAccredidationByCaseNbr];
GO

CREATE PROCEDURE [dbo].[proc_GetCaseAccredidationByCaseNbr]
(
	@casenbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT * FROM tblCaseAccredidation 
		INNER JOIN tblEWAccreditation ON tblCaseAccredidation.EWAccreditationID = tblEWAccreditation.EWAccreditationID 
		WHERE caseNbr = @casenbr

	SET @Err = @@Error

	RETURN @Err
END
GO




CREATE TABLE [dbo].[tblFeeDetailAbeton]
(
[feecode] [int] NOT NULL,
[officecode] [int] NOT NULL,
[casetype] [int] NOT NULL,
[prodcode] [int] NOT NULL,
[fee] [money] NULL,
[latecancelfee] [money] NULL,
[noshowfee] [money] NULL,
[dateadded] [datetime] NULL,
[useridadded] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateedited] [datetime] NULL,
[useridedited] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[drfee] [money] NULL,
[drlatecancelfee] [money] NULL,
[drnoshowfee] [money] NULL,
[canceldays] [int] NULL,
[feeplus] [money] NULL,
[MinFee] [money] NULL,
[Rounding] [int] NULL,
[RoundOn] [bit] NULL CONSTRAINT [DF_tblFeeDetailAbeton_RoundOn] DEFAULT ((0)),
[Divisor] [float] NULL,
[RevenueAcct] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpenseAcct] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dept] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flatfee] [money] NULL
)
GO
ALTER TABLE [dbo].[tblFeeDetailAbeton] ADD CONSTRAINT [PK_tblFeeDetailAbeton] PRIMARY KEY CLUSTERED  ([feecode], [officecode], [casetype], [prodcode])
GO

CREATE VIEW [dbo].[vwAbetonCompanyFees]
AS
SELECT     dbo.tblfeeheader.feecode, dbo.tblfeeheader.feedesc, dbo.tblfeeheader.begin_date, dbo.tblfeeheader.end_date, 
                      dbo.tblproduct.description AS ProductDesc, dbo.tblFeeDetailAbeton.latecancelfee AS FSLateCancel, dbo.tblFeeDetailAbeton.noshowfee AS FSNoShow, 
                      dbo.tblFeeDetailAbeton.canceldays AS FSCancelDays, dbo.tblFeeDetailAbeton.flatfee, dbo.tblFeeDetailAbeton.officecode, 
                      dbo.tblFeeDetailAbeton.casetype, dbo.tblFeeDetailAbeton.prodcode
FROM         dbo.tblFeeDetailAbeton INNER JOIN
                      dbo.tblfeeheader ON dbo.tblFeeDetailAbeton.feecode = dbo.tblfeeheader.feecode INNER JOIN
                      dbo.tblproduct ON dbo.tblFeeDetailAbeton.prodcode = dbo.tblproduct.prodcode

GO
CREATE TABLE [dbo].[tblAbetonProviderFees]
(
[DrOpCode] [int] NOT NULL,
[feecode] [int] NOT NULL,
[prodcode] [int] NOT NULL,
[officecode] [int] NOT NULL,
[casetype] [int] NOT NULL,
[ProviderFee] [money] NULL,
[InvoiceAmount] [money] NULL,
[InvoiceNoShowFee] [money] NULL,
[VoucherNoShowFee] [money] NULL,
[InvoiceLateCancelFee] [money] NULL,
[VoucherLateCancelFee] [money] NULL,
[LateCancelDays] [int] NULL,
[dateadded] [datetime] NULL,
[useridadded] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateedited] [datetime] NULL,
[useridedited] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DontUpdate] [bit] NULL
)
GO
ALTER TABLE [dbo].[tblAbetonProviderFees] ADD CONSTRAINT [PK_tblAbletonProviderFees] PRIMARY KEY CLUSTERED  ([DrOpCode], [feecode], [prodcode], [officecode], [casetype])
GO
CREATE VIEW [dbo].[vwAbetonProviderFees]
AS
SELECT     dbo.tblfeeheader.feecode, dbo.tblfeeheader.feedesc, dbo.tblfeeheader.begin_date, dbo.tblfeeheader.end_date, dbo.tblAbetonProviderFees.prodcode, 
                      dbo.tblAbetonProviderFees.ProviderFee AS DrFee, dbo.tblAbetonProviderFees.InvoiceAmount AS Fee, 
                      dbo.tblAbetonProviderFees.InvoiceNoShowFee AS NoShowFee, dbo.tblAbetonProviderFees.VoucherNoShowFee AS DrNoShowFee, 
                      dbo.tblAbetonProviderFees.InvoiceLateCancelFee AS LateCancelFee, dbo.tblAbetonProviderFees.VoucherLateCancelFee AS DrLateCancelFee, 
                      dbo.tblAbetonProviderFees.LateCancelDays AS CancelDays, dbo.tblproduct.description AS ProductDesc, dbo.tblAbetonProviderFees.DrOpCode, 
                      dbo.tblAbetonProviderFees.officecode, dbo.tblAbetonProviderFees.casetype, dbo.tblFeeDetailAbeton.latecancelfee AS FSLateCancel, 
                      dbo.tblFeeDetailAbeton.noshowfee AS FSNoShow, dbo.tblFeeDetailAbeton.canceldays AS FSCancelDays, dbo.tblFeeDetailAbeton.flatfee, 
                      dbo.tblFeeDetailAbeton.feeplus, dbo.tblFeeDetailAbeton.MinFee, dbo.tblFeeDetailAbeton.Rounding, dbo.tblFeeDetailAbeton.RoundOn, 
                      dbo.tblFeeDetailAbeton.Divisor, dbo.tblFeeDetailAbeton.RevenueAcct, dbo.tblFeeDetailAbeton.ExpenseAcct, dbo.tblFeeDetailAbeton.Dept
FROM         dbo.tblFeeDetailAbeton INNER JOIN
                      dbo.tblfeeheader ON dbo.tblFeeDetailAbeton.feecode = dbo.tblfeeheader.feecode INNER JOIN
                      dbo.tblproduct INNER JOIN
                      dbo.tblAbetonProviderFees ON dbo.tblproduct.prodcode = dbo.tblAbetonProviderFees.prodcode ON 
                      dbo.tblFeeDetailAbeton.feecode = dbo.tblAbetonProviderFees.feecode AND 
                      dbo.tblFeeDetailAbeton.officecode = dbo.tblAbetonProviderFees.officecode AND 
                      dbo.tblFeeDetailAbeton.casetype = dbo.tblAbetonProviderFees.casetype AND dbo.tblFeeDetailAbeton.prodcode = dbo.tblAbetonProviderFees.prodcode

GO
ALTER TABLE [dbo].[tblFeeDetail] ADD
[feeplus] [money] NULL,
[MinFee] [money] NULL,
[Rounding] [int] NULL,
[RoundOn] [bit] NULL,
[Divisor] [decimal] (18, 0) NULL,
[RevenueAcct] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpenseAcct] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Dept] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO


ALTER PROCEDURE [dbo].[proc_GetClientSubordinates]

@WebUserID int

AS 

SELECT DISTINCT lastname + ', ' + firstname + ' ' + tblCompany.intname name, clientcode FROM tblclient 
	INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
	WHERE clientcode IN (SELECT UserCode FROM tblWebUserAccount WHERE WebUserID = @WebUserID) ORDER BY name
GO


ALTER VIEW [dbo].[vwFeeDetail]
AS
    SELECT  tblfeedetail.* ,
            tblproduct.Description
    FROM    tblfeedetail
            INNER JOIN tblproduct ON tblfeedetail.prodCode = tblproduct.prodCode
GO


UPDATE tblControl SET DBVersion='2.69'
GO
