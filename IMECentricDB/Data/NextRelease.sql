<<<<<<< HEAD

-- Sprint 86

-- IMEC-12772 remove arch claim setting
DELETE FROM tblSetting WHERE Name = 'UseARCHClaimInfo'
GO

-- IMEC=12084 - new setting for PDF Printing/Merging
INSERT INTO tblSetting(Name, Value)
VALUES('PDFProcessingTimeout', '45'), 
      ('PDFPrintMethod','QuickPDF')
GO
=======

-- Sprint 87

INSERT INTO tblUserFunction
(
    FunctionCode,
    FunctionDesc,
    DateAdded
)
VALUES
(   'DicomExtractor',
    'DicomExtractor - Run',
    GETDATE()
    )
GO


INSERT tblSetting
(
    Name,
    Value
)
VALUES
(   'UseRibbonDefault',
    'False'
    )
GO

UPDATE tblControl SET DirIcon='\\IMECDocs5.ew.domain.local\IMECentricDocs\Icon\'
UPDATE tblControl SET DirDicomExtractor='\\EWISApp1.ew.domain.local\Deploy\DicomExtractor\'
GO



>>>>>>> develop
