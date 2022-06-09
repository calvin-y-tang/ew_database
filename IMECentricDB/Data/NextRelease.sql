
-- Sprint 86

-- IMEC-12772 remove arch claim setting
DELETE FROM tblSetting WHERE Name = 'UseARCHClaimInfo'
GO

-- IMEC=12084 - new setting for PDF Printing/Merging
INSERT INTO tblSetting(Name, Value)
VALUES('PDFProcessingTimeout', '45'), 
      ('PDFPrintMethod','QuickPDF')
GO
