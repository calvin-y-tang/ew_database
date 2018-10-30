CREATE VIEW vw_EDIFileAttachments
AS
SELECT	cd.[Description], 
		cd.sFilename, 
        cd.SeqNo, 
        cd.CaseNbr, 
        ah.DocumentNbr, 
        ah.DocumentType, 
        ah.HeaderID, 
        ia.InvAttachID, 
        ia.AttachType, 
        cd.[Type]
FROM   tblAcctHeader as ah 
              INNER JOIN tblCase as c on ah.CaseNbr = c.CaseNbr
              INNER JOIN tblCaseDocuments as cd on c.CaseNbr = cd.CaseNbr
              LEFT OUTER JOIN tblInvoiceAttachments as ia on (ah.HeaderID = ia.InvHeaderID and cd.SeqNo = ia.SeqNo)
WHERE (cd.[Type] in ('document', 'report'))

