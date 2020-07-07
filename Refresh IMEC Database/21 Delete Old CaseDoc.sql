/*
This is one way to move data back from tmp table.
It seems quicker for table with few indexes,
and also possible to generate this script by reading table definition from sys tables.
*/

--Delete CaseDoc before 2020
--SELECT TOP 1 CaseNbr FROM tblCase WHERE DateAdded>='2020-01-01' ORDER BY CaseNbr

SELECT * INTO tmpCaseDocuments FROM tblCaseDocuments WHERE SeqNo>=39072318
TRUNCATE TABLE tblCaseDocuments
SET IDENTITY_INSERT tblCaseDocuments ON
INSERT INTO tblCaseDocuments
(
    CaseNbr,
    Document,
    Type,
    ReportType,
    Description,
    sFilename,
    DateAdded,
    UserIDAdded,
    PublishOnWeb,
    WebSynchDate,
    DateEdited,
    UserIDEdited,
    SeqNo,
    WebGUID,
    PublishedTo,
    FileMoved,
    Source,
    FileSize,
    Pages,
    Viewed,
    FolderID,
    SubFolder,
    CaseDocTypeID,
    ReportApproved,
    SharedDoc,
    MasterCaseNbr,
    FirstViewedOnWebBy,
    FirstViewedOnWebDate
)
SELECT * FROM tmpCaseDocuments
SET IDENTITY_INSERT tblCaseDocuments OFF
DROP TABLE tmpCaseDocuments
GO

