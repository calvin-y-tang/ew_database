IF (SELECT COUNT(IMECode) FROM tblIMEData WHERE CaseDocFolderID IS NULL OR AcctDocFolderID IS NULL)>0
  BEGIN
    THROW 50000, 'Document Folder ID is not set', 1
  END
ELSE
  BEGIN
	UPDATE tblCaseDocuments 
	SET FolderID = Case [Type] 
						When 'Invoice' Then tblIMEData.AcctDocFolderID
						When 'Voucher' Then tblIMEData.AcctDocFolderID
						Else tblIMEData.CaseDocFolderID
					end,
		SubFolder = RTRIM(YEAR(tblCase.DateAdded)) 
						+ '-' 
						+ RIGHT('0' + RTRIM(MONTH(tblCase.DateAdded)), 2) 
						+ '\' 
						+ CONVERT(VARCHAR, tblCaseDocuments.CaseNbr)
						+ '\'
	FROM tblCaseDocuments
		inner join tblCase on tblCaseDocuments.CaseNbr = tblCase.CaseNbr
		left outer join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
		inner join tblIMEData on ISNULL(tblOffice.IMECode, 1) = tblIMEData.IMECode
	WHERE tblCaseDocuments.FolderID IS NULL or tblCaseDocuments.SubFolder IS NULL
  END
GO





