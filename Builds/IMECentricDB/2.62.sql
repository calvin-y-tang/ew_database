ALTER TABLE [tblCase]
  ADD [PhotoRcvd] BIT DEFAULT 0 NOT NULL
GO

ALTER TABLE tblCaseTrans
  ADD CreateInvoiceVoucher bit DEFAULT(0)
GO

ALTER TABLE tblIMEData
 ADD ShowCaseNotification BIT NOT NULL DEFAULT 0
GO

ALTER TABLE tblIMEData
 ADD UseICDRequest BIT NOT NULL DEFAULT 0
GO

ALTER TABLE tblControl
 ADD AllowCompanyCPTOverride BIT NOT NULL DEFAULT 0
GO


INSERT  INTO tblUserFunction
        ( FunctionCode ,
          FunctionDesc 
        )
        SELECT  'CustomMEIProgram' ,
                'Custom - MEI Program'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'CustomMEIProgram' )

GO
INSERT  INTO tblUserFunction
        ( FunctionCode ,
          FunctionDesc 
        )
        SELECT  'CustomFMSProgram' ,
                'Custom - FMS Program'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'CustomFMSProgram' )

GO
INSERT  INTO tblUserFunction
        ( FunctionCode ,
          FunctionDesc 
        )
        SELECT  'RptDrDistribution' ,
                'Report - Doctor Distribution'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'RptDrDistribution' )

GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[spCase_GetDocumentPath]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [spCase_GetDocumentPath];
GO

CREATE PROCEDURE [dbo].[spCase_GetDocumentPath]
 @CaseNbr int,
 @DocType varchar(25) = NULL,
 @DocPath varchar(90) OUTPUT
AS
BEGIN
 DECLARE @BasePath varchar(70), @CaseAddedDate datetime, @DateCode varchar(7)

 -- STEP 1: Get The Case Added Date
 SELECT @CaseAddedDate = dateadded 
 FROM tblCase
 WHERE CaseNbr = @CaseNbr

 -- RETURN Error 99 if no case found
 IF (ISDATE(@CaseAddedDate) = 0) 
 BEGIN
  RETURN 99
 END
 
 -- STEP 2. Get The Document Base Path
 IF @DocType = 'invoice' OR @DocType = 'voucher'
  BEGIN
   SELECT @BasePath = dirAcctDocument 
   FROM tblIMEData 
  END
 IF @DocType = 'trans' 
  BEGIN
   SELECT @BasePath = dirTranscription 
	FROM tblIMEData  
  END
 ELSE IF (@BasePath IS NULL)
  BEGIN
   SELECT @BasePath = dirdocument 
	FROM tblIMEData  
  END

 -- RETURN Error 98, no base path found
 IF (@BasePath IS NULL)
 BEGIN
  RETURN 98
 END

 -- STEP 3. Get The Date Code (use YY-MM of case added), pad with zero if neccessary
 SET @DateCode = CONVERT(varchar(4), YEAR(@CaseAddedDate)) + '-'
 IF (MONTH(@CaseAddedDate) < 10)
 BEGIN
  SET @DateCode = @DateCode + '0'
 END
 SET @DateCode = @DateCode + CONVERT(varchar(2), MONTH(@CaseAddedDate))
 
 -- Step 4. Combine The Base Directory with the date code (Base Directory (with trailing \) + Date Code + \ + CaseNbr + \) 
 SET @DocPath = @BasePath + @DateCode + '\' + CONVERT(varchar(20), @CaseNbr) + '\'

END


GO

UPDATE tblControl SET DBVersion='2.62'
GO
