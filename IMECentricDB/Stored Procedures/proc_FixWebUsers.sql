

CREATE PROCEDURE [dbo].[proc_FixWebUsers]

AS

--CLIENT CLEANUP
--update tblWebUserAccount with correct usercode
DECLARE @code NCHAR(20)
DECLARE @id NCHAR(20)
DECLARE @string NCHAR(500)
DECLARE @recCount int
SET @recCount = (SELECT COUNT(clientcode) FROM tblClient INNER JOIN tblWebUserAccount ON tblClient.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblClient.clientcode AND tblWebUserAccount.UserType = 'CL')
IF @recCount > 0
 BEGIN
  DECLARE reclist CURSOR FOR
  SELECT clientcode, tblClient.webuserid FROM tblClient INNER JOIN tblWebUserAccount ON tblClient.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblClient.clientcode AND tblWebUserAccount.UserType = 'CL'
  OPEN reclist
  FETCH NEXT FROM reclist 
  INTO @code, @id
  WHILE @@FETCH_STATUS = 0
  BEGIN

   SET @string = 'update tblWebUserAccount set usercode = ' + RTRIM(@code) + ' where webuserid = ' + RTRIM(@id) + ' and tblWebUserAccount.IsUser = 1'
   EXEC sp_executesql @string
   --PRINT @string

    FETCH NEXT FROM reclist 
   INTO @code, @id
  END
  CLOSE reclist
  DEALLOCATE reclist 
 END
--set records with invalid webuserid to null
UPDATE tblClient SET webuserid = NULL WHERE webuserid NOT IN (SELECT DISTINCT webuserid FROM tblWebUser)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--CCADDRESS CLEANUP
--update tblWebUserAccount with correct usercode
SET @recCount = (SELECT COUNT(cccode) FROM tblCCaddress INNER JOIN tblWebUserAccount ON tblCCaddress.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblCCaddress.cccode AND tblWebUserAccount.UserType = 'AT')
IF @recCount > 0
 BEGIN
  DECLARE reclist CURSOR FOR
  SELECT cccode, tblCCaddress.webuserid FROM tblCCaddress INNER JOIN tblWebUserAccount ON tblCCaddress.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblCCaddress.cccode AND tblWebUserAccount.UserType = 'AT'
  OPEN reclist
  FETCH NEXT FROM reclist 
  INTO @code, @id
  WHILE @@FETCH_STATUS = 0
  BEGIN

   SET @string = 'update tblWebUserAccount set usercode = ' + RTRIM(@code) + ' where webuserid = ' + RTRIM(@id) + ' and tblWebUserAccount.IsUser = 1'
   EXEC sp_executesql @string
   --PRINT @string

    FETCH NEXT FROM reclist 
   INTO @code, @id
  END
  CLOSE reclist
  DEALLOCATE reclist
 END
--set records with invalid webuserid to null
UPDATE tblCCAddress SET webuserid = NULL WHERE webuserid NOT IN (SELECT DISTINCT webuserid FROM tblWebUser)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--DOCTOR CLEANUP
--update tblWebUserAccount with correct usercode
SET @recCount = (SELECT COUNT(doctorcode) FROM tblDoctor INNER JOIN tblWebUserAccount ON tblDoctor.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblDoctor.doctorcode AND tblWebUserAccount.UserType IN ('DR', 'OP'))
IF @recCount > 0
 BEGIN
  DECLARE reclist CURSOR FOR
  SELECT doctorcode, tblDoctor.webuserid FROM tblDoctor INNER JOIN tblWebUserAccount ON tblDoctor.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblDoctor.doctorcode AND tblWebUserAccount.UserType IN ('DR', 'OP')
  OPEN reclist
  FETCH NEXT FROM reclist 
  INTO @code, @id
  WHILE @@FETCH_STATUS = 0
  BEGIN

   SET @string = 'update tblWebUserAccount set usercode = ' + RTRIM(@code) + ' where webuserid = ' + RTRIM(@id) + ' and tblWebUserAccount.IsUser = 1'
   EXEC sp_executesql @string
   --PRINT @string

    FETCH NEXT FROM reclist 
   INTO @code, @id
  END
  CLOSE reclist
  DEALLOCATE reclist
 END
--set records with invalid webuserid to null
UPDATE tblDoctor SET webuserid = NULL WHERE webuserid NOT IN (SELECT DISTINCT webuserid FROM tblWebUser)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--TRANS CLEANUP
--update tblWebUserAccount with correct usercode
SET @recCount = (SELECT COUNT(Transcode) FROM tblTranscription INNER JOIN tblWebUserAccount ON tblTranscription.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblTranscription.Transcode AND tblWebUserAccount.UserType = 'TR')
IF @recCount > 0
 BEGIN
  DECLARE reclist CURSOR FOR
  SELECT Transcode, tblTranscription.webuserid FROM tblTranscription INNER JOIN tblWebUserAccount ON tblTranscription.webuserid = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1 AND tblWebUserAccount.usercode <> tblTranscription.Transcode AND tblWebUserAccount.UserType = 'TR'
  OPEN reclist
  FETCH NEXT FROM reclist 
  INTO @code, @id
  WHILE @@FETCH_STATUS = 0
  BEGIN

   SET @string = 'update tblWebUserAccount set usercode = ' + RTRIM(@code) + ' where webuserid = ' + RTRIM(@id) + ' and tblWebUserAccount.IsUser = 1'
   EXEC sp_executesql @string
   --PRINT @string

    FETCH NEXT FROM reclist 
   INTO @code, @id
  END
  CLOSE reclist
  DEALLOCATE reclist
 END
--set records with invalid webuserid to null
UPDATE tblTranscription SET webuserid = NULL WHERE webuserid NOT IN (SELECT DISTINCT webuserid FROM tblWebUser)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--WEBUSER CLEANUP
--delete any webuseraccount records with invalid webuserid
DELETE FROM tblWebUserAccount WHERE webuserid NOT IN (SELECT webuserid FROM tblWebUser) --clean up

--delete all webuser records with an invalid imecentriccode
DELETE FROM tblWebUser WHERE imecentriccode NOT IN 
(
SELECT cccode FROM tblCCAddress
UNION
SELECT clientcode FROM tblClient
UNION
SELECT transcode FROM tblTranscription
UNION
SELECT doctorcode FROM tblDoctor
)
AND userid <> 'admin'

--delete all webuseraccount records with an invalid usercode
DELETE FROM tblWebUserAccount WHERE UserCode NOT IN 
(
SELECT cccode FROM tblCCAddress
UNION
SELECT clientcode FROM tblClient
UNION
SELECT transcode FROM tblTranscription
UNION
SELECT doctorcode FROM tblDoctor
)
AND webuserid <> 999999


