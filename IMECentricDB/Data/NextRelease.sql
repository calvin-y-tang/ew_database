
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


-- issue 12851 - make frmStatusHCAIExport an accounting form
UPDATE tblQueues SET SubType = 'Accting' WHERE FormToOpen = 'frmStatusHCAIExport'
GO
