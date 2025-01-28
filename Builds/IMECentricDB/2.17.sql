

DROP VIEW vwOfficeIMEData
GO
CREATE VIEW vwOfficeIMEData
AS
    SELECT  tblOffice.OfficeCode ,
            tblIMEData.CompanyName ,
            tblIMEData.Addr1 ,
            tblIMEData.Addr2 ,
            tblIMEData.City ,
            tblIMEData.State ,
            tblIMEData.Zip ,
            tblIMEData.Phone ,
            tblIMEData.Fax ,
            tblIMEData.Website ,
            tblIMEData.EmailAddress ,
            tblIMEData.DirTemplate ,
            tblIMEData.DirDocument ,
            tblIMEData.DirDirections ,
            tblIMEData.NoShowLtrDocument ,
            tblIMEData.EmailCapability ,
            tblIMEData.FaxCapability ,
            tblIMEData.LabelCapability ,
            tblIMEData.SupportCompany ,
            tblIMEData.SupportEmail ,
            tblIMEData.FaxServerName ,
            tblIMEData.FaxCoverPage ,
            tblIMEData.UserIDAdded ,
            tblIMEData.DateAdded ,
            tblIMEData.UserIDEdited ,
            tblIMEData.DateEdited ,
            tblIMEData.DistanceUofM ,
            tblIMEData.MedsRecdDocument ,
            tblIMEData.DaysToCancel ,
            tblIMEData.OrderCCDropdown ,
            tblIMEData.IMECreate ,
            tblIMEData.RequirePDF ,
            tblIMEData.VerbalDocument ,
            tblIMEData.VerbalQueue ,
            tblIMEData.BrqInternalCaseNbr ,
            tblIMEData.SortCaseHistoryDesc ,
            tblIMEData.INFeeCode ,
            tblIMEData.VOFeeCode ,
            tblIMEData.NextInvoiceNbr ,
            tblIMEData.INDocumentCode ,
            tblIMEData.VODocumentCode ,
            tblIMEData.AccountingSystem ,
            tblIMEData.CreateVouchers ,
            tblIMEData.InvoiceDesc ,
            tblIMEData.NextVoucherNbr ,
            tblIMEData.IMEAccount ,
            tblIMEData.StdTerms ,
            tblIMEData.NextBatchNbr ,
            tblIMEData.TaxCode ,
            tblIMEData.InvoiceCopies ,
            tblIMEData.DirImport ,
            tblIMEData.VoucherCopies ,
            tblIMEData.SourceDirectory ,
            tblIMEData.Country ,
            tblIMEData.IMECode ,
            tblIMEData.QAfterNoShow ,
            tblIMEData.UsePanelExam ,
            tblIMEData.blnUseSubCases ,
            tblIMEData.ShowOntarioAutoFields ,
            tblIMEData.DirAcctDocument ,
            tblIMEData.DefaultAddressLabel ,
            tblIMEData.DefaultCaseLabel ,
            tblIMEData.UseBillingCompany ,
            tblIMEData.InvoiceNoShows ,
            tblIMEData.InvoiceLateCancels ,
            tblIMEData.VoucherNoShows ,
            tblIMEData.VoucherLateCancels ,
            tblIMEData.ShowEWFacilityOnInvVo ,
            tblIMEData.ShowProductDescOnClaimForm ,
            tblIMEData.ShowClientAsReferringProvider ,
            tblIMEData.UseHCAIInterface ,
            tblIMEData.NextEDIBatchNbr ,
            tblIMEData.FaxServerType ,
            tblIMEData.ATSecurityProfileID ,
            tblIMEData.CLSecurityProfileID ,
            tblIMEData.DRSecurityProfileID ,
            tblIMEData.OPSecurityProfileID ,
            tblIMEData.TRSecurityProfileID ,
            tblIMEData.ApptDuration ,
            tblIMEData.MonetaryUnit ,
            tblIMEData.UseMutipleTreatingPhysicians ,
            tblIMEData.MultiPortal ,
            tblIMEData.TranscriptionCapability ,
            tblIMEData.UseCustomRptCoverLetterDir ,
            tblIMEData.DirRptCoverLetter ,
            tblIMEData.DirDictationFiles ,
            tblIMEData.DirTranscription ,
            tblIMEData.WorkHourStart ,
            tblIMEData.WorkHourEnd ,
            tblIMEData.CountryID ,
            tblIMEData.DirVoicePlayer ,
            tblIMEData.DrDocFolderID ,
            tblIMEData.QAfterLateCancel ,
            tblIMEData.CalcTaxOnVouchers ,
            tblIMEData.TaxCalcMethod ,
            tblIMEData.IncludeSubCaseOnMaster
    FROM    tblOffice
            INNER JOIN tblIMEData ON tblOffice.IMECode = tblIMEData.IMEcode
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetCaseDocsToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetCaseDocsToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetCaseHistoryToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetCaseHistoryToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetCaseInfoToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetCaseInfoToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetCaseIssuesToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetCaseIssuesToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetCaseNbrFromGUID') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetCaseNbrFromGUID
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetCaseProblemsToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetCaseProblemsToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetCaseSpecialtiesToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetCaseSpecialtiesToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetCaseTypesToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetCaseTypesToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetCasesToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetCasesToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetClientsToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetClientsToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetCompaniesToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetCompaniesToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetIssuesToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetIssuesToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetOfficesToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetOfficesToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetProblemsToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetProblemsToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetQueuesToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetQueuesToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetRecStatusToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetRecStatusToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetServicesToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetServicesToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetSpecialtyToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetSpecialtyToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetUsersToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetUsersToSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_ImportCC') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_ImportCC
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_ImportCase') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_ImportCase
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_ImportCaseAlreadySynched') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_ImportCaseAlreadySynched
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_ImportCaseDocument') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_ImportCaseDocument
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_ImportCaseHistory') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_ImportCaseHistory
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_ImportCaseIssue') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_ImportCaseIssue
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_ImportCaseProblem') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_ImportCaseProblem
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_ImportExaminee') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_ImportExaminee
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_SetActionResponse') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_SetActionResponse
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_SetCaseDocSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_SetCaseDocSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_SetCaseHistorySynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_SetCaseHistorySynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_SetCaseSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_SetCaseSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_SetClientSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_SetClientSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_SetCompanySynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_SetCompanySynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_SetCutoffDate') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_SetCutoffDate
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_SetCutoffSuccessful') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_SetCutoffSuccessful
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_SetOfficeSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_SetOfficeSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_SetQueueSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_SetQueueSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_SetUserSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_SetUserSynch
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_SynchLog_AddNew') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_SynchLog_AddNew
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_CaseDocUpdateFileName') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_CaseDocUpdateFileName
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetActionsToSync') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetActionsToSync
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'spIMEWORKFLOW_GetCaseDefenseToSynch') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE spIMEWORKFLOW_GetCaseDefenseToSynch
GO


DROP TABLE tblBillingCompany
GO

DROP TABLE tblProductTax
GO

ALTER TABLE tblProduct
 DROP COLUMN EWServiceTypeID
GO



UPDATE tblControl SET DBVersion='2.17'
GO
