/*
Display the configuration data
*/

SELECT
DBID, AppTitle, IsTestSystem,
CountryID, PortalMasterDBID, GPDBID, XMediusFaxPrefix
FROM tblControl

SELECT
DirDirections, DirTemplate, DirVoicePlayer, DirIMECentricHelper, SourceDirectory
FROM tblControl

SELECT DISTINCT CaseDocFolderID, AcctDocFolderID, DirImport FROM tblIMEData

SELECT TD.* FROM tblEWTransDept AS TD
INNER JOIN tblControl ON tblControl.DBID = TD.DBID

SELECT DISTINCT EWTransDeptID FROM tblOffice

SELECT * FROM tblEWFolderDef
WHERE FolderID IN (SELECT CaseDocFolderID FROM tblIMEData)
OR FolderID IN (SELECT AcctDocFolderID FROM tblIMEData)
OR FolderID IN (SELECT FolderID FROM tblEWTransDept INNER JOIN tblControl ON tblControl.DBID = tblEWTransDept.DBID)