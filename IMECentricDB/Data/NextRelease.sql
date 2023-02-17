-- Sprint 104

-- IMEC-13365 - only allow CV Dr Document Type to be set for Publish to Web
 UPDATE tblEWDrDocType
   SET AllowPublishOnWeb = 1
 WHERE EWDrDocTypeID = 5
GO
UPDATE tblEWDrDocType
   SET AllowPublishOnWeb = 0
 WHERE EWDrDocTypeID <> 5
GO
