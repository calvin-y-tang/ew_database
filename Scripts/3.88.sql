

IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[proc_Info_Hartford_MgtRpt_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS

--
-- Hartford Main Query 
-- 

SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_HartfordInvoices') IS NOT NULL DROP TABLE ##tmp_HartfordInvoices
print 'Gather main data set ...'

DECLARE @serviceVarianceValue INT = 19
DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdLIst

SELECT
    ewf.[DBID],
	ah.HeaderId,
	ah.SeqNo,
	ah.DocumentNbr,
	ewf.GPFacility + '-' + CAST(ah.DocumentNbr AS Varchar(16)) as "InvoiceNo",
	ah.DocumentDate as "InvoiceDate",
	S.[Description] as [Service],
    CT.[Description] as CaseType,
    c.CaseNbr,
	c.ExtCaseNbr,
	c.SLARuleID,
	co.IntName,
	EFGS.BusUnitGroupName as BusUnit,
	APS.Name as ApptStatus,
	ISNULL(cli.LastName, '') + ', ' + ISNULL(cli.FirstName, '') as "HIGRequestor",
	isnull(SPL.PrimarySpecialty, isnull(CA.SpecialtyCode, C.DoctorSpecialty)) as "Specialty",	
	SPL.SubSpecialty AS "SubSpecialty",	
	ISNULL(d.lastname, '') + ', ' + ISNULL(d.firstname, '') as "ProviderName",
	CONVERT(CHAR(4), EWBL.EWBusLineID) as "LOB",
	C.ClaimNbr as "ClaimNumber",
	E.LastName as "ClaimantLastName",
	E.FirstName as "ClaimantFirstName",
	ISNULL(AH.ServiceState, C.Jurisdiction) as "ServiceState",
	s.EWServiceTypeID as "ServiceTypeID",
	S.Description as "ServiceType",
	EWBL.Name as "CoverageType",
	CONVERT(VARCHAR(32), 'NA') as "LitOrAppeal",
	C.DateOfInjury as "DOI",
	ISNULL(ca.datereceived, c.DateReceived) as "ReferralDate",
	ISNULL(ca.datereceived, c.DateReceived) as "DateReceived",
	ISNULL(ca.datereceived, c.DateReceived) as "DateScheduled",
	ISNULL(ca.ApptTime, c.ApptTime) as "ExamDate",
	ISNULL(c.RptSentDate, c.RptFinalizedDate) as "ReportDelivered",
	NULL as "TotalDays",
	IIF(ISNULL(C.TATServiceLifeCycle, '') <> '', C.TATServiceLifeCycle - @serviceVarianceValue, 0) as "ServiceVariance",
	CONVERT(CHAR(8), NULL) as "JurisTAT",
	CAST(ISNULL(NW.EWNetworkID, '0') AS CHAR(8)) as "InOutNetwork",
	ISNULL(LI.ExamFee, '') as "ExamFee",
	ISNULL(AH.DocumentTotal, '') as "InvoiceFee",
	CONVERT(VARCHAR(300), NULL) as PrimaryException,
	CONVERT(VARCHAR(32), NULL) as PrimaryDriver,
	CONVERT(VARCHAR(300), NULL) as SecondaryException,
	CONVERT(VARCHAR(32), NULL) as SecondaryDriver,
	CONVERT(VARCHAR(800), NULL) as Comments,
	c.DoctorReason 
INTO ##tmp_HartfordInvoices
FROM tblAcctHeader as AH
	inner join tblClient as cli on AH.ClientCode = cli.ClientCode
	inner join tblCase as C on AH.CaseNbr = C.CaseNbr	
	inner join tblOffice as O on C.OfficeCode = O.OfficeCode
	inner join tblServices as S on C.ServiceCode = S.ServiceCode
	left outer join tblEWNetwork as NW on C.EWNetworkID = NW.EWNetworkID
	left outer join tblEWServiceType as EWS on S.EWServiceTypeID = EWS.EWServiceTypeID
	left outer join tblCaseType as CT on C.CaseType = CT.Code
	left outer join tblEWBusLine as EWBL on CT.EWBusLineID = EWBL.EWBusLineID
	left outer join tblEWFacility as EWF on AH.EWFacilityID = EWF.EWFacilityID
	left outer join tblExaminee as E on C.ChartNbr = E.ChartNbr
	left outer join tblClient as CL on AH.ClientCode = CL.ClientCode
	left outer join tblCompany as CO on AH.CompanyCode = CO.CompanyCode
	left outer join tblEWParentCompany as EWPC on CO.ParentCompanyID = EWPC.ParentCompanyID
	left outer join tblEWFacilityGroupSummary as EFGS on AH.EWFacilityID = EFGS.EWFacilityID
	left outer join tblCaseAppt as CA on ISNULL(AH.CaseApptID, C.CaseApptID) = CA.CaseApptID
	left outer join tblApptStatus as APS on ISNULL(AH.ApptStatusID, C.ApptStatusID) = APS.ApptStatusID
	left outer join tblDoctor as D on ISNULL(CA.DoctorCode, C.DoctorCode) = D.DoctorCode
	left outer join tblSpecialty as SPL on ISNULL(CA.SpecialtyCode, C.DoctorSpecialty) = SPL.SpecialtyCode		  
	left join
		  (select
			 tAD.HeaderID,
			 SUM(tAD.ExtAmountUS) as ExamFee
		   from tblAcctHeader as tAH
			   inner join tblAcctDetail as tAD on (tAH.HeaderID = tAD.HeaderID)
			   inner join tblCase as tC on tAH.CaseNbr = tC.CaseNbr
			   left outer join tblFRCategory as tFRC on tC.CaseType = tFRC.CaseType and tAD.ProdCode = tFRC.ProductCode
			   left outer join tblEWFlashCategory as tEWFC on tFRC.EWFlashCategoryID = tEWFC.EWFlashCategoryID
		   where tEWFC.Mapping3 = 'FeeAmount'
		   group by tAD.HeaderID
		  ) LI on AH.HeaderID = LI.HeaderID
WHERE (AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate)
      AND (AH.DocumentType = 'IN')
      AND (AH.DocumentStatus = 'Final')
      AND (EWPC.ParentCompanyID = 30)
	  AND (AH.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      AND ((EWS.Mapping1 in ('IME', 'MRR', 'ADD')) or (S.ShortDesc = 'FCE'))      
ORDER BY EWF.GPFacility, AH.DocumentNbr

print 'Data retrieved'
set nocount off
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO
PRINT N'Update complete.';


GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, 
Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(160, 'GenDocDefaultOtherEmail', 'Case', 'Set Default Email for Other Party when generating document', 1, 1201, 0, 'OtherEmail', NULL, NULL, NULL, NULL, 0)
