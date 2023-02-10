-- Sprint 104

-- IMEC-13365 - only allow CV Dr Document Type to be set for Publish to Web
USE IMECentricMaster 
GO
 UPDATE EWDrDocType
   SET AllowPublishOnWeb = 0
 WHERE EWDrDocTypeID <> 5
GO
