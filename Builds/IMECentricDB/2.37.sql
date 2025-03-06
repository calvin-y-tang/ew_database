ALTER VIEW [dbo].[vwExportSummaryWithSecurity]
AS
SELECT  tblCase.CaseNbr, tblAcctHeader.documenttype, tblAcctHeader.documentNbr, tblAcctingTrans.StatusCode, 
			                  tblAcctHeader.EDIBatchNbr, tblAcctHeader.EDIStatus, tblAcctHeader.EDILastStatusChg, tblAcctHeader.EDIRejectedMsg,
                        tblQueues.StatUSDesc, tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName, tblAcctingTrans.DrOpType, 
                        CASE ISNULL(tblCase.PanelNbr, 0) WHEN 0 THEN CASE tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(tblDoctor.LastName, '') 
                        + ', ' + ISNULL(tblDoctor.FirstName, '') WHEN '' THEN ISNULL(tblDoctor.LastName, '') + ', ' + ISNULL(tblDoctor.FirstName, '') 
                        WHEN '' THEN ISNULL(tblCase.DoctorName, '') 
                        WHEN 'OP' THEN tblDoctor.CompanyName END ELSE CASE tblacctingtrans.droptype WHEN 'DR' THEN ISNULL(tblCase.DoctorName, '') 
                        WHEN '' THEN ISNULL(tblCase.DoctorName, '') WHEN 'OP' THEN tblDoctor.CompanyName END END AS DoctorName, 
                        tblClient.LastName + ', ' + tblClient.FirstName AS ClientName, tblCompany.IntName AS CompanyName, tblCase.Priority, 
                        tblCase.ApptDate, tblCase.DateAdded, tblCase.ClaimNbr, tblCase.DoctorLocation, tblCase.ApptTime, tblCase.DateEdited, 
                        tblCase.UserIDEdited, tblClient.Email AS AdjusterEmail, tblClient.Fax AS AdjusterFax, tblCase.MarketerCode, tblCase.UserIDAdded, 
                        tblAcctHeader.documentDate, tblAcctHeader.INBatchSelect, tblAcctHeader.VOBatchSelect, tblAcctHeader.taxCode, 
                        tblAcctHeader.taxtotal, tblAcctHeader.documenttotal, tblAcctHeader.documentStatus, tblCase.ClientCode, tblCase.DoctorCode, 
                        tblAcctHeader.batchNbr, tblCase.OfficeCode, tblCase.SchedulerCode, tblClient.CompanyCode, tblCase.QARep, 
                        tblCase.PanelNbr, DATEDIFF(day, tblAcctingTrans.LastStatuschg, GETDATE()) AS IQ, tblCase.MastersubCase, 
                        tblqueues_1.StatUSDesc AS CaseStatus, tblUserOfficeFunction.UserID, tblQueues.functionCode, tblServices.ShortDesc AS Service, 
                        tblCase.ServiceCode, tblCase.Casetype, tblCase.InputSourceID,   tblCompany.BulkBillingID,
		   tblAcctHeader.EDISubmissionCount, tblAcctHeader.EDISubmissionDateTime
FROM          tblAcctHeader INNER JOIN
                        tblAcctingTrans ON tblAcctHeader.seqno = tblAcctingTrans.SeqNO INNER JOIN
                        tblCase ON tblAcctHeader.CaseNbr = tblCase.CaseNbr LEFT OUTER JOIN
                        tblCompany ON tblAcctHeader.CompanyCode = tblCompany.CompanyCode LEFT OUTER JOIN
                        tblClient ON tblAcctHeader.ClientCode = tblClient.ClientCode INNER JOIN
                        tblQueues ON tblAcctingTrans.StatusCode = tblQueues.StatusCode INNER JOIN
                        tblQueues tblqueues_1 ON tblCase.Status = tblqueues_1.StatusCode LEFT OUTER JOIN
                        tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode LEFT OUTER JOIN
                        tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr INNER JOIN
                        tblServices ON tblServices.ServiceCode = tblCase.ServiceCode INNER JOIN
                        tblUserOffice ON tblCase.OfficeCode = tblUserOffice.OfficeCode INNER JOIN
                        tblUserOfficeFunction ON tblUserOffice.UserID = tblUserOfficeFunction.UserID AND 
                        tblUserOfficeFunction.OfficeCode = tblCase.OfficeCode AND tblQueues.functionCode = tblUserOfficeFunction.functionCode
WHERE      (tblAcctingTrans.StatusCode <> 20) AND (tblAcctHeader.batchNbr IS NULL) AND (tblAcctHeader.documentStatus = 'Final')

/*	Refresh View */
GO
exec sp_refreshview 'vwExportSummaryWithSecurity'


/****** Object:  Table [dbo].[tblQueues] ******/
GO
SET IDENTITY_INSERT [dbo].[tblQueues] ON
GO
INSERT INTO [dbo].[tblQueues]
           ([StatusCode]
		   ,[StatusDesc]
           ,[Type]
           ,[ShortDesc]
           ,[DisplayOrder]
           ,[FormToOpen]
           ,[DateAdded]
           ,[DateEdited]
           ,[UserIDAdded]
           ,[UserIDEdited]
           ,[Status]
           ,[SubType]
           ,[FunctionCode]
           ,[WebStatusCode]
           ,[WebGUID]
           ,[NotifyScheduler]
           ,[NotifyQARep]
           ,[NotifyIMECompany]
           ,[AllowToAwaitingScheduling])
     VALUES
           (26, 
		    'Invoices Awaiting Electronic Processor Export', 
			'System', 
			'EIPExp', 
			450, 
			'frmStatusEIPExport', 
			getdate(), 
			getdate(), 
			'admin',   
			'admin',
			'Active',
			'Accting',
			'EDIExport',
			NULL,
			NULL,
			0,
			0,
			1,
			NULL)
GO
INSERT INTO [dbo].[tblQueues]
           ([StatusCode]
		   ,[StatusDesc]
           ,[Type]
           ,[ShortDesc]
           ,[DisplayOrder]
           ,[FormToOpen]
           ,[DateAdded]
           ,[DateEdited]
           ,[UserIDAdded]
           ,[UserIDEdited]
           ,[Status]
           ,[SubType]
           ,[FunctionCode]
           ,[WebStatusCode]
           ,[WebGUID]
           ,[NotifyScheduler]
           ,[NotifyQARep]
           ,[NotifyIMECompany]
           ,[AllowToAwaitingScheduling])
     VALUES
           (27, 
		    'Invoices Awaiting Electronic Acknowledgement', 
			'System', 
			'EIPExp', 
			451, 
			'frmStatusEIPSubmit', 
			getdate(), 
			getdate(), 
			'admin',   
			'admin',
			'Active',
			'Accting',
			'EDIExport',
			NULL,
			NULL,
			0,
			0,
			1,
			NULL)
GO
INSERT INTO [dbo].[tblQueues]
           ([StatusCode]
		   ,[StatusDesc]
           ,[Type]
           ,[ShortDesc]
           ,[DisplayOrder]
           ,[FormToOpen]
           ,[DateAdded]
           ,[DateEdited]
           ,[UserIDAdded]
           ,[UserIDEdited]
           ,[Status]
           ,[SubType]
           ,[FunctionCode]
           ,[WebStatusCode]
           ,[WebGUID]
           ,[NotifyScheduler]
           ,[NotifyQARep]
           ,[NotifyIMECompany]
           ,[AllowToAwaitingScheduling])
     VALUES
           (28, 
		    'Invoices with Electronic Acknowledgement Errors', 
			'System', 
			'EIPExp', 
			452, 
			'frmStatusEIPAckErr', 
			getdate(), 
			getdate(), 
			'Admin',   
			'Admin',
			'Active',
			'Accting',
			'EDIExport',
			NULL,
			NULL,
			0,
			0,
			1,
			NULL)
GO
INSERT INTO [dbo].[tblQueues]
           ([StatusCode]
		   ,[StatusDesc]
           ,[Type]
           ,[ShortDesc]
           ,[DisplayOrder]
           ,[FormToOpen]
           ,[DateAdded]
           ,[DateEdited]
           ,[UserIDAdded]
           ,[UserIDEdited]
           ,[Status]
           ,[SubType]
           ,[FunctionCode]
           ,[WebStatusCode]
           ,[WebGUID]
           ,[NotifyScheduler]
           ,[NotifyQARep]
           ,[NotifyIMECompany]
           ,[AllowToAwaitingScheduling])
     VALUES
           (29, 
		    'Exported Invoices with Payment Errors', 
			'System', 
			'EIPExp', 
			2200,
			'frmStatusEIPPayErr', 
			getdate(), 
			getdate(), 
			'admin',   
			'admin',
			'Active',
			'Accting',
			'EDIExport',
			NULL,
			NULL,
			0,
			0,
			1,
			NULL)
GO
SET IDENTITY_INSERT [dbo].[tblQueues] OFF

/****** Object:  Table [dbo].[tblQueueForms] ******/
GO
DELETE FROM tblQueueForms WHERE FormName='frmStatusBrickExport'

INSERT INTO tblQueueForms VALUES ('frmStatusBrickExport', 'Form for Brickstreet EDI Export');
INSERT INTO tblQueueForms VALUES ('frmStatusEDIExport', 'Form for WA L&I EDI Export');
INSERT INTO tblQueueForms VALUES ('frmStatusEDISubmit', 'Form for WA L&I EDI Submitted');
INSERT INTO tblQueueForms VALUES ('frmStatusEDIError', 'Form for WA L&I EDI Errors');

INSERT INTO tblQueueForms VALUES ('frmStatusEIPExport', 'Form for Elec Invoice Export');
INSERT INTO tblQueueForms VALUES ('frmStatusEIPSubmit', 'Form for Elec Invoice Submitted');
INSERT INTO tblQueueForms VALUES ('frmStatusEIPAckErr', 'Form for Elec Invoice Ack Errors');
INSERT INTO tblQueueForms VALUES ('frmStatusEIPPayErr', 'Form for Elec Invoice Pay Errors');
GO

CREATE VIEW [dbo].[vwEDIExportSummaryWithSecurity]
AS
SELECT  tblCase.CaseNbr, tblAcctHeader.documenttype, tblAcctHeader.documentNbr, tblAcctingTrans.StatusCode, 
		tblAcctHeader.EDIBatchNbr, tblAcctHeader.EDIStatus, tblAcctHeader.EDILastStatusChg, tblAcctHeader.EDIRejectedMsg,
        tblQueues.StatUSDesc, tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName, tblAcctingTrans.DrOpType, 
        CASE ISNULL(tblCase.PanelNbr, 0) 
			WHEN 0 THEN CASE tblacctingtrans.droptype 
							WHEN 'DR' THEN ISNULL(tblDoctor.LastName, '') + ', ' + ISNULL(tblDoctor.FirstName, '') 
							WHEN '' THEN ISNULL(tblDoctor.LastName, '') + ', ' + ISNULL(tblDoctor.FirstName, '') 
							WHEN '' THEN ISNULL(tblCase.DoctorName, '') 
							WHEN 'OP' THEN tblDoctor.CompanyName 
						END 
			ELSE 
				CASE tblacctingtrans.droptype 
					WHEN 'DR' THEN ISNULL(tblCase.DoctorName, '') 
					WHEN '' THEN ISNULL(tblCase.DoctorName, '') 
					WHEN 'OP' THEN tblDoctor.CompanyName 
				END 
		END AS DoctorName, 
        tblClient.LastName + ', ' + tblClient.FirstName AS ClientName, tblCompany.IntName AS CompanyName, tblCase.Priority, 
        tblCase.ApptDate, tblCase.DateAdded, tblCase.ClaimNbr, tblCase.DoctorLocation, tblCase.ApptTime, tblCase.DateEdited, 
        tblCase.UserIDEdited, tblClient.Email AS AdjusterEmail, tblClient.Fax AS AdjusterFax, tblCase.MarketerCode, tblCase.UserIDAdded, 
        tblAcctHeader.documentDate, tblAcctHeader.INBatchSelect, tblAcctHeader.VOBatchSelect, tblAcctHeader.taxCode, 
        tblAcctHeader.taxtotal, tblAcctHeader.documenttotal, tblAcctHeader.documentStatus, tblCase.ClientCode, tblCase.DoctorCode, 
        tblAcctHeader.batchNbr, tblCase.OfficeCode, tblCase.SchedulerCode, tblClient.CompanyCode, tblCase.QARep, 
        tblCase.PanelNbr, DATEDIFF(day, tblAcctingTrans.LastStatuschg, GETDATE()) AS IQ, tblCase.MastersubCase, 
        tblqueues_1.StatUSDesc AS CaseStatus, tblUserOfficeFunction.UserID, tblQueues.functionCode, tblServices.ShortDesc AS Service, 
        tblCase.ServiceCode, tblCase.Casetype, tblCase.InputSourceID, tblCompany.BulkBillingID, tblAcctHeader.EDISubmissionCount, tblAcctHeader.EDISubmissionDateTime
FROM    tblAcctHeader 
			INNER JOIN tblAcctingTrans ON tblAcctHeader.seqno = tblAcctingTrans.SeqNO 
			INNER JOIN tblCase ON tblAcctHeader.CaseNbr = tblCase.CaseNbr 
			LEFT OUTER JOIN tblCompany ON tblAcctHeader.CompanyCode = tblCompany.CompanyCode 
			LEFT OUTER JOIN tblClient ON tblAcctHeader.ClientCode = tblClient.ClientCode 
			INNER JOIN tblQueues ON tblAcctingTrans.StatusCode = tblQueues.StatusCode 
			INNER JOIN tblQueues tblqueues_1 ON tblCase.Status = tblqueues_1.StatusCode 
			LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode 
			LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr 
			INNER JOIN tblServices ON tblServices.ServiceCode = tblCase.ServiceCode 
			INNER JOIN tblUserOffice ON tblCase.OfficeCode = tblUserOffice.OfficeCode 
			INNER JOIN tblUserOfficeFunction ON tblUserOffice.UserID = tblUserOfficeFunction.UserID 
				AND tblUserOfficeFunction.OfficeCode = tblCase.OfficeCode 
				AND tblQueues.functionCode = tblUserOfficeFunction.functionCode
WHERE (tblAcctingTrans.StatusCode <> 20) AND (tblAcctHeader.documentStatus = 'Final')
GO

ALTER TABLE tblEWBulkBilling ADD EDIExportToGPFirst BIT NULL DEFAULT 0
GO
ALTER TABLE tblEWBulkBilling ADD EDIExportAutoBatch BIT NULL DEFAULT 0
GO





-- 08/14/2014 - JAP - Issue 1278 - modify tblClient.Email to allow for a maximum of 150 characters
ALTER TABLE tblClient ALTER COLUMN Email VARCHAR(150) NULL
GO


CREATE TABLE [tblDoctorCheckRequest] (
  [CheckRequestID] INTEGER IDENTITY(1,1) NOT NULL,
  [AcctingTransID] INTEGER NOT NULL,
  [CaseNbr] INTEGER NOT NULL,
  [DoctorCode] INTEGER NOT NULL,
  [ApptTime] DATETIME,
  [EWFacilityID] INTEGER NOT NULL,
  [EWLocationID] INTEGER NOT NULL,
  [Amount] MONEY,
  [Comment] VARCHAR(30),
  [DateAdded] DATETIME NOT NULL,
  [UserIDAdded] VARCHAR(15),
  [FollowupDate] DATETIME,
  [BatchNbr] INTEGER,
  [ExportDate] DATETIME,
  CONSTRAINT [PK_tblDoctorCheckRequest] PRIMARY KEY ([CheckRequestID])
)
GO

CREATE UNIQUE INDEX [IdxtblDoctorCheckRequest_UNIQUE_AcctingTransID] ON [tblDoctorCheckRequest]([AcctingTransID])
GO

ALTER TABLE tblQueues
 ALTER COLUMN FormToOpen VARCHAR(30)
GO


CREATE PROCEDURE proc_GetNewBatchNbr
(
  @BatchType VARCHAR(2),
  @UserIDAdded VARCHAR(20),
  @BatchNbr INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @error INT

    DECLARE @imeCode INT
	DECLARE @offsetHours INT

	SELECT TOP 1 @offsetHours = OffsetHours FROM tblControl ORDER BY InstallID

    BEGIN TRAN
		SELECT TOP 1 @BatchNbr = NextBatchNbr, @imeCode = IMECode
		 FROM tblIMEData (UPDLOCK)
		 ORDER BY IMECode
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done

		UPDATE tblIMEData SET NextBatchNbr=@BatchNbr+1
		 WHERE IMECode=@imeCode
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done

		INSERT INTO tblbatch (BatchNbr, Type, DateAdded, UserIDAdded) VALUES
		(
			@BatchNbr,
			@BatchType,
			DATEADD(hh, @offsetHours, GETDATE()),
			@UserIDAdded
		)
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done

		--Commit transaction
	COMMIT TRAN
 
        Done:
        IF @error <> 0 
            SET @BatchNbr = NULL
        IF @BatchNbr IS NULL 
            ROLLBACK TRAN

        SET NOCOUNT OFF
        RETURN @error
END
GO


DROP VIEW vwAcctingSummaryWithSecurity
GO
CREATE VIEW vwAcctingSummaryWithSecurity
AS
    SELECT 
            tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename ,
            tblacctingtrans.DrOpType ,
            tblCase.PanelNbr ,
            CASE ISNULL(tblcase.panelnbr, 0)
              WHEN 0
              THEN CASE tblacctingtrans.droptype
                     WHEN 'DR'
                     THEN ISNULL(tbldoctor.lastname, '') + ', '
                          + ISNULL(tbldoctor.firstname, '')
                     WHEN ''
                     THEN ISNULL(tbldoctor.lastname, '') + ', '
                          + ISNULL(tbldoctor.firstname, '')
                     WHEN '' THEN ISNULL(tblcase.doctorname, '')
                     WHEN 'OP' THEN tbldoctor.companyname
                   END
              ELSE CASE tblacctingtrans.droptype
                     WHEN 'DR' THEN ISNULL(tblcase.doctorname, '')
                     WHEN '' THEN ISNULL(tblcase.doctorname, '')
                     WHEN 'OP' THEN tbldoctor.companyname
                   END
            END AS DoctorName ,
            CASE tblacctingtrans.DrOpType
                     WHEN 'OP' THEN tbldoctor.companyname
					 ELSE
                      ISNULL(tbldoctor.lastname, '') + ', '
                          + ISNULL(tbldoctor.firstname, '')
                   END AS DrOpName ,
            tblClient.lastname + ', ' + tblClient.firstname AS clientname ,
            tblCompany.intname AS companyname ,
            tblCase.priority ,
            tblLocation.locationcode AS doctorlocation ,
            tblAcctingTrans.blnselect AS billedselect ,
            tblCase.servicecode ,
            tblQueues.statusdesc ,
            tblCase.miscselect ,
            tblcase.marketercode ,
            tblacctingtrans.statuscode ,
            tblCase.voucherselect ,
            tblacctingtrans.documentnbr ,
            tblacctingtrans.documentdate ,
            tblacctingtrans.documentamount ,
            tblServices.description AS servicedesc ,
            tblCase.officecode ,
            tblDoctor.companyname AS otherpartyname ,
            tblDoctor.doctorcode ,
            tblCase.casenbr ,
			tblCase.ClaimNbr ,
            tblacctingtrans.SeqNO ,
            tblCase.clientcode ,
            tblCompany.companycode ,
            tblCase.schedulercode ,
            tblCase.QARep ,
            tblacctingtrans.type ,
            DATEDIFF(day, tblacctingtrans.laststatuschg, GETDATE()) AS IQ ,
            tblCase.laststatuschg ,
            ISNULL(tblacctingtrans.apptdate, tblCase.ApptDate) AS apptdate ,
            tblLocation.location ,
            tblacctingtrans.appttime ,
            tblApptStatus.Name AS Result,
            tblCase.mastersubcase ,
            tblqueues.functioncode ,
            tblUserofficefunction.userid ,
            tblcase.billingnote ,
            tblCase.rptStatus ,
            tblCase.casetype,
            tblAcctingTrans.ApptStatusID,
			tblCase.Status AS CaseStatusCode ,
			CaseQ.StatusDesc AS CaseStatusDesc
    FROM    tblCase
            INNER JOIN tblacctingtrans ON tblCase.casenbr = tblacctingtrans.casenbr
			INNER JOIN tblQueues AS CaseQ ON tblCase.Status = CaseQ.StatusCode
            INNER JOIN tblQueues ON tblacctingtrans.statuscode = tblQueues.statuscode
            INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
            INNER JOIN tblUserOffice ON tblCase.officecode = tblUserOffice.officecode
            INNER JOIN tbluserofficefunction ON tblUserOffice.userid = tbluserofficefunction.userid
                                                AND tblUserOffice.officecode = tbluserofficefunction.officecode
                                                AND tblqueues.functioncode = tbluserofficefunction.functioncode
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            LEFT OUTER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode 
            LEFT OUTER JOIN tblLocation ON tblacctingtrans.doctorlocation = tblLocation.locationcode
            LEFT OUTER JOIN tblDoctor ON tblacctingtrans.DrOpCode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblApptStatus ON tblAcctingTrans.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( tblacctingtrans.statuscode <> 20 )

GO



SET IDENTITY_INSERT tblQueues ON
INSERT INTO tblQueues
        ( StatusCode,
		  StatusDesc ,
          Type ,
          ShortDesc ,
          DisplayOrder ,
          FormToOpen ,
          DateAdded ,
          DateEdited ,
          UserIDAdded ,
          UserIDEdited ,
          Status ,
          SubType ,
          FunctionCode ,
          WebStatusCode ,
          WebGUID ,
          NotifyScheduler ,
          NotifyQARep ,
          NotifyIMECompany ,
          AllowToAwaitingScheduling
        )
VALUES  ( 30, 'Active Prepayments Awaiting Vouchering' , -- StatusDesc - varchar(50)
          'System' , -- Type - varchar(10)
          'PRActivePP' , -- ShortDesc - varchar(10)
          250 , -- DisplayOrder - int
          'frmStatusActivePrepay' , -- FormToOpen - varchar(20)
          GETDATE() , -- DateAdded - datetime
          GETDATE() , -- DateEdited - datetime
          'System' , -- UserIDAdded - varchar(20)
          'System' , -- UserIDEdited - varchar(20)
          'Active' , -- Status - varchar(10)
          'Accting' , -- SubType - varchar(10)
          'None' , -- FunctionCode - varchar(15)
          Null , -- WebStatusCode - int
          NULL , -- WebGUID - uniqueidentifier
          0 , -- NotifyScheduler - bit
          0 , -- NotifyQARep - bit
          0 , -- NotifyIMECompany - bit
          0  -- AllowToAwaitingScheduling - bit
        )
 
 SET IDENTITY_INSERT tblQueues OFF
 GO

 insert into tbluserfunction (functioncode, functiondesc)
 select 'GenerateDrPrepay', 'Accounting - PrePay Requests'
 where not exists (select functionCode from tblUserFunction where functionCode='GenerateDrPrepay')

GO




DROP PROCEDURE dbo.spCaseHistory
GO
CREATE PROCEDURE dbo.spCaseHistory
    @iCaseNbr INT ,
    @sSort VARCHAR(10) ,
    @sIncludeExclude VARCHAR(1) ,
    @sTypes VARCHAR(120) ,
    @blnNoAccting INT
AS
    DECLARE @sSelectStmt NVARCHAR(2000) ,
        @sCaseNbr AS NVARCHAR(10) ,
        @WhereClause AS NVARCHAR(500) ,
        @NoAccting AS NVARCHAR(100)
    SET NOCOUNT ON
    SET @sCaseNbr = CAST(@iCaseNbr AS VARCHAR(10))

    IF @blnNoAccting = 1
        BEGIN
            SET @NoAccting = ' and (CH.type is null or CH.type <> ''Acct'')  '
        END
    ELSE
        BEGIN
            SET @NoAccting = ''
        END
    IF @sIncludeExclude = ''  -- select everything
        BEGIN
            SET @WhereClause = 'where CH.CaseNbr = '
                + @sCaseNbr 
        END
    IF @sIncludeExclude = 'A'  -- include all records for this case
        BEGIN
            SET @WhereClause = 'where CH.CaseNbr = '
                + @sCaseNbr 
        END

    IF @sIncludeExclude = 'I'  -- only include certain types
        BEGIN
            SET @WhereClause = 'where CH.CaseNbr = '
                + @sCaseNbr + ' and (CH.type in (' + @stypes
                + '))' 
        END
    IF @sIncludeExclude = 'E'  -- only exclude certain types
        BEGIN
            SET @WhereClause = 'where CH.CaseNbr = '
                + @sCaseNbr
                + ' and (CH.type is null or CH.type not in ('
                + @sTypes + '))' 
        END
    SET @sSelectStmt = 'SELECT TOP 100 PERCENT CH.CaseNbr, CH.EventDate, CH.EventDesc, CH.UserID, CH.Highlight, '
        + 'CH.otherinfo, CH.type, CH.status, '
        + 'CASE WHEN CH.type = ''StatChg'' THEN cast(isnull(CH.duration / 24, DATEDIFF(day, C.laststatuschg, '
        + 'GETDATE())) AS decimal(6, 1)) END AS IQ, CH.ID, C.LastStatusChg, CH.Duration, '
        + 'CH.PublishOnWeb, CH.PublishedTo, CH.UserIDEdited '
        + 'FROM tblCaseHistory AS CH INNER JOIN tblCase AS C ON CH.CaseNbr = C.CaseNbr '
        + @WhereClause + @NoAccting
        + ' ORDER BY CH.EventDate ' + @sSort 

--print @sselectstmt
    EXEC Sp_executesql @sSelectStmt

GO



ALTER TABLE tblAcctHeader
  ADD FeeExplanation VARCHAR(90)
GO

CREATE TABLE [tblSetting] (
  [SettingID] INTEGER IDENTITY(1,1) NOT NULL,
  [Name] VARCHAR(30),
  [Value] VARCHAR(30),
  CONSTRAINT [PK_tblSetting] PRIMARY KEY ([SettingID])
)
GO

CREATE UNIQUE INDEX [IdxtblSetting_UNIQUE_Name] ON [tblSetting]([Name])
GO

INSERT INTO tblSetting
        ( Name, Value )
VALUES  ( 'ESISFeeExplanationAmt', -- Name - varchar(30)
          '2000'  -- Value - varchar(30)
          )
GO




DROP VIEW vwVoucherSelect
GO
CREATE VIEW vwVoucherSelect
AS
    SELECT  dbo.tblCase.CaseNbr ,
            dbo.tblCase.doctorcode AS OpCode ,
            ISNULL(dbo.tblDoctor.lastname, '') + ', '
            + ISNULL(dbo.tblDoctor.firstname, '') + ' '
            + ISNULL(dbo.tblDoctor.credentials, '') AS Provider ,
            tbldoctor.OpType, CreateVouchers, Prepaid
    FROM    dbo.tblCase
            INNER JOIN dbo.tblDoctor ON dbo.TblCase.doctorcode = dbo.tblDoctor.doctorcode
    UNION
    SELECT  dbo.tblCase.CaseNbr ,
            dbo.tblCaseotherparty.OpCode AS OpCode ,
            dbo.tblDoctor.companyname AS Provider ,
            tbldoctor.OpType, CreateVouchers, Prepaid
    FROM    dbo.tblCase
            INNER JOIN dbo.TblCaseOtherParty ON dbo.tblCase.CaseNbr = dbo.TblCaseOtherParty.CaseNbr
            INNER JOIN dbo.tblDoctor ON dbo.TblCaseOtherParty.OPCode = dbo.tblDoctor.doctorcode
    UNION
    SELECT  dbo.tblCase.CaseNbr ,
            dbo.tblCasePanel.doctorcode AS OpCode ,
            ISNULL(dbo.tblDoctor.lastname, '') + ', '
            + ISNULL(dbo.tblDoctor.firstname, '') + ' '
            + ISNULL(dbo.tblDoctor.credentials, '') AS Provider ,
            tbldoctor.OpType, CreateVouchers, Prepaid
    FROM    dbo.tblCase
            INNER JOIN dbo.tblCasePanel ON dbo.tblCase.PanelNbr = dbo.tblCasePanel.panelNbr
            INNER JOIN dbo.tblDoctor ON dbo.tblCasePanel.doctorcode = dbo.tblDoctor.doctorcode
GO






UPDATE tblQueues SET
 StatusDesc='Prepayment Requests for Providers',
 FormToOpen='frmStatusPrepayRequest'
 WHERE StatusCode=15
UPDATE tblQueues SET
 StatusDesc='Cases Awaiting Provider Vouchering'
 WHERE StatusCode=16
GO

 


--Data Patching
DELETE FROM tblAcctingTrans WHERE StatusCode=15
 AND 4=(SELECT MAX(dbid) FROM tblControl)
GO

DELETE FROM tblAcctingTrans WHERE StatusCode=15
 AND 12=(SELECT MAX(dbid) FROM tblControl)
 AND ApptDate<'7/1/2014'
GO


UPDATE tblControl SET DBVersion='2.37'
GO
