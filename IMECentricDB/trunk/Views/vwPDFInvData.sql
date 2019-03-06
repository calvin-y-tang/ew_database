CREATE VIEW vwPDFInvData
AS
    SELECT  AH.CaseNbr AS InvCaseNbr ,
            AT.ApptDate AS InvApptDate,
            AT.ApptTime AS InvApptTime,
            AT.DrOpCode AS InvDoctorCode ,
            AT.DoctorLocation AS InvLocationCode ,
			AH.CompanyCode AS InvCompanyCode ,

			AH.HeaderID ,
			AH.DocumentNbr ,
            AH.DocumentDate AS DocumentDateValue ,
			B.BlankValue AS DocumentDate ,
            AH.DocumentType ,
            AH.TaxTotal ,
            AH.DocumentTotal ,
            AH.EWFacilityID ,
            ISNULL(CO.InvRemitEWFacilityID, ISNULL(F.InvRemitEWFacilityID, AH.EWFacilityID)) AS RemitEWFacilityID ,

			B.BlankValue AS InvoiceAmtDollars,
			B.BlankValue AS InvoiceAmtCents,
			B.BlankValue AS InvoicePaymentCreditAmtDollars,
			B.BlankValue AS InvoicePaymentCreditAmtCents,
			B.BlankValue AS InvoiceBalanceDueDollars,
			B.BlankValue AS InvoiceBalanceDueCents,
            
			F.GPFacility ,
			F.LegalName AS BillingProviderName ,
			F.FedTaxID AS BillingProviderTaxID ,
            F.AcctingPhone AS BillingProviderPhone ,
			F.AcctingPhone AS BillingProviderPhoneAreaCode ,
			F.AcctingPhone AS BillingProviderPhoneNumber ,

			F.GPFacility+'-'+CAST(AH.DocumentNbr AS VARCHAR(20)) AS InvoiceNbr ,

			CASE WHEN ISNULL(FRemit.RemitAddress,'')='' THEN FRemit.Address ELSE FRemit.RemitAddress END AS BillingProviderAddress ,
			CASE WHEN ISNULL(FRemit.RemitAddress,'')='' THEN
			 ISNULL(FRemit.City, '') + ', ' + ISNULL(UPPER(FRemit.State), '') + ' ' + ISNULL(FRemit.Zip, '')
			ELSE
			  ISNULL(FRemit.RemitCity, '') + ', ' + ISNULL(UPPER(FRemit.RemitState), '') + ' ' + ISNULL(FRemit.RemitZip, '')
			END AS BillingProviderCityStateZip ,

			CO.ExtName AS InvCoExtName,
            
			CL.BillAddr1 AS InvClBillAddr1,
            CL.BillAddr2 AS InvClBillAddr2,
            CL.BillCity AS InvClBillCity ,
            UPPER(CL.BillState) AS InvClBillState ,
            CL.BillZip AS InvClBillZip ,
            CL.Addr1 AS InvClAddr1 ,
            CL.Addr2 AS InvClAddr2 ,
            CL.City AS InvClCity ,
            UPPER(CL.State) AS InvClState ,
            CL.Zip AS InvClZip ,
			
			B.BlankValueLong AS Payor

    FROM    tblAcctHeader AS AH
            LEFT OUTER JOIN tblAcctingTrans AS AT ON AT.SeqNO = AH.SeqNo
            LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = AH.ClientCode
            LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = AH.CompanyCode
            LEFT OUTER JOIN tblEWFacility AS F ON F.EWFacilityID = AH.EWFacilityID
			LEFT OUTER JOIN tblEWFacility AS FRemit ON ISNULL(CO.InvRemitEWFacilityID, ISNULL(F.InvRemitEWFacilityID, AH.EWFacilityID))=FRemit.EWFacilityID
			LEFT OUTER JOIN tblBlank AS B ON 1=1
