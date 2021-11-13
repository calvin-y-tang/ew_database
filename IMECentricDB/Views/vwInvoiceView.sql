CREATE VIEW vwInvoiceView
AS
		select
			AH.HeaderID,
			AH.DocumentNbr,
			AH.DocumentStatus,
			AH.DocumentType,
			AH.DocumentDate,
			AH.CaseNbr,
			C.ExtCaseNbr,
			AH.Terms,
			AH.ClaimNbr,
			AH.Examinee,
			AH.Doctor,
			AH.ClientRefNbr,
			AH.Address,
			AH.TaxTotal,
			AH.DocumentTotal,
			FH.FeeDesc as FeeSchedule,
			EWF.FacilityName,
			UF.FirstName + ' ' + UF.LastName as UserFinalized,
			AH.ApptDate,
			AH.Message,
			RAH.DocumentNbr as RelatedDocumentNbr,
			AH.FeeExplanation
		from tblAcctHeader as AH
			inner join tblCase as C on AH.CaseNbr = C.CaseNbr
			left outer join tblFeeHeader as FH on AH.FeeCode = FH.FeeCode    
			left outer join tblEWFacility as EWF on AH.EWFacilityID = EWF.EWFacilityID
			left outer join tblUser as UF on AH.UserIDFinalized = UF.UserID      
			left outer join tblAcctHeader as RAH on AH.RelatedInvHeaderID = RAH.HeaderID