CREATE VIEW [dbo].[vwtblProblem]
	AS 
	SELECT 
        ProblemCode,
		CONVERT(VARCHAR(50), DECRYPTBYKEYAUTOCERT(CERT_ID('IMEC_CLE_Certificate'), NULL, Description_Encrypted)) AS Description,
		Status,
		DateAdded,
		UserIDAdded,
		DateEdited,
		UserIDEdited,
		PublishOnWeb,
		WebSynchDate,
		WebID
	 FROM tblProblem
