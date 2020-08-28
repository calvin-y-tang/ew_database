
IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[tblCaseEnvelope]...';


GO
ALTER TABLE [dbo].[tblCaseEnvelope]
    ADD [PageCount] INT NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[tblExceptionDefinition]...';


GO
ALTER TABLE [dbo].[tblExceptionDefinition]
    ADD [BillingEntity] INT CONSTRAINT [DF_tblExceptionDefinition_BillingEntity] DEFAULT ((0)) NOT NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[tblOffice]...';


GO
ALTER TABLE [dbo].[tblOffice] DROP COLUMN [RecordRetrievalMethod];


GO
ALTER TABLE [dbo].[tblOffice]
    ADD [RecordRetrievalDocument] VARCHAR (15) NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[tblOfficeDPSSortModel]...';


GO
ALTER TABLE [dbo].[tblOfficeDPSSortModel] ALTER COLUMN [CaseType] INT NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[tblOfficeDPSSortModel].[IX_U_tblOfficeDPSSortModel_OfficeCodeSortModelID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblOfficeDPSSortModel_OfficeCodeSortModelID]
    ON [dbo].[tblOfficeDPSSortModel]([Officecode] ASC, [SortModelID] ASC);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[tblWebSuperUser]...';


GO
CREATE TABLE [dbo].[tblWebSuperUser] (
    [SuperUserID]     INT           IDENTITY (1, 1) NOT NULL,
    [WebUserID]       INT           NULL,
    [EWBusLineID]     INT           NULL,
    [ParentCompanyID] INT           NULL,
    [CompanyCode]     INT           NULL,
    [SuperUserType]   CHAR (2)      NULL,
    [DateAdded]       SMALLDATETIME NULL,
    [UserIDAdded]     VARCHAR (255) NULL,
    [DateEdited]      SMALLDATETIME NULL,
    [UserIDEdited]    VARCHAR (255) NULL,
    CONSTRAINT [PK_tblWebSuperUser] PRIMARY KEY CLUSTERED ([SuperUserID] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[tblDoctorDPSSortModel].[IX_U_tblDoctorDPSSortModel_DoctorCodeCaseType]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblDoctorDPSSortModel_DoctorCodeCaseType]
    ON [dbo].[tblDoctorDPSSortModel]([DoctorCode] ASC, [CaseType] ASC);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

-- Didn't originally make it into the current release branch
PRINT N'Altering Procedure proc_IMEException...';


GO
ALTER PROCEDURE [dbo].[proc_IMEException]
    @ExceptionID INT ,
    @OfficeCode INT ,
    @CaseTypeCode INT ,
    @ServiceCode INT ,
    @StatusCode INT ,
    @EnterLeave INT ,
    @CaseNbr INT, 
	@SLARuleDetailID INT
AS
BEGIN

    SET NOCOUNT ON;
    DECLARE @Err INT;

	-- DEV NOTE: Changed this to be a SELECT DISTINCT when the SLA tables were added to this.
	--	the problem is with tblSLARuleDetail because that will have multiple items for each SLA Rule.
	--	Just need to keep this point in mind when making any future changes to this stored procedure.

    SELECT  DISTINCT 
		ED.ExceptionDefID, 
		ED.Description, 
		ED.Entity, 
		ED.IMECentricCode,
		ED.ExceptionID, 
		ED.CaseTypeCode, 
		ED.ServiceCode, 
		ED.StatusCodeValue, 
		ED.DisplayMessage, 
		ED.RequireComment, 
		ED.EmailMessage,
		ED.EditEMail, 
		ED.GenerateDocument, 
		CAST(ED.Message AS VARCHAR(MAX)) AS Message, 
		ED.EmailScheduler, 
		ED.EmailQA, 
		ED.EmailOther, 
		ED.EmailSubject, 
		CAST(ED.EmailText AS VARCHAR(MAX)) AS EmailText, 
		ED.Document1, 
		ED.Document2, 
		ED.Status,
		ED.DateAdded, 
		ED.UserIDAdded, 
		ED.DateEdited, 
		ED.UserIDEdited, 
		ED.UseBillingEntity, 
		ED.AllOffice, 
		ED.CreateCHAlert,
		ED.CHEventDesc,
		ED.ChOtherInfo,
		ED.AllEWServiceType, 
		ED.AllCaseType, 
		ED.AllService, 
		ED.AllSLARuleDetail,
          ED.BillingEntity, 
		ISNULL(C.CaseNbr, -1) AS CaseNbr ,
		CL.ClientCode ,
		CO.ParentCompanyID ,
		CL.CompanyCode ,
		C.DoctorCode ,
		C.PlaintiffAttorneyCode ,
		C.DefenseAttorneyCode ,
		C.DefParaLegal ,
		BCL.ClientCode AS BillClientCode ,
		BCO.ParentCompanyID AS BillParentCompanyID ,
		BCL.CompanyCode AS BillCompanyCode
    FROM    tblExceptionDefinition AS ED
            LEFT OUTER JOIN tblCase AS C ON C.CaseNbr = @CaseNbr
            LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
            LEFT OUTER JOIN tblCompany AS CO ON CL.CompanyCode = CO.CompanyCode
            LEFT OUTER JOIN tblClient AS BCL ON BCL.ClientCode = ISNULL(C.BillClientCode, C.ClientCode)
            LEFT OUTER JOIN tblCompany AS BCO ON BCO.CompanyCode = BCL.CompanyCode
			LEFT OUTER JOIN tblEmployer AS ER ON ER.EmployerID = C.EmployerID
			LEFT OUTER JOIN tblEWParentEmployer AS PE ON PE.EWParentEmployerID = ER.EWParentEmployerID
			LEFT OUTER JOIN tblSLARule AS  SLA ON SLA.SLARuleID = C.SLARuleID 
			LEFT OUTER JOIN tblSLARuleDetail AS SLADET ON SLADET.SLARuleID = SLA.SLARuleID 
    WHERE   ED.Status = 'Active' AND ED.ExceptionID = @ExceptionID
			AND
			(
				( ED.Entity = 'CA' 
					AND C.CaseNbr IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
				)
				OR
				( ED.Entity = 'CS'
	                OR ( ED.Entity = 'PC'
	                    AND ( CO.ParentCompanyID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                            AND (ISNULL(ED.BillingEntity, 0) = 1 OR ISNULL(ED.BillingEntity, 0) = 3)
	                        
	                    OR  BCO.ParentCompanyID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                        AND (ISNULL(ED.BillingEntity, 0) = 2 OR ISNULL(ED.BillingEntity, 0) = 3)
	                        )
	                    )
	                OR ( ED.Entity = 'CO'
	                    AND ( CL.CompanyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                            AND (ISNULL(ED.BillingEntity, 0) = 1 OR ISNULL(ED.BillingEntity, 0) = 3)
	                        
	                    OR  BCL.CompanyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                        AND (ISNULL(ED.BillingEntity, 0) = 2 OR ISNULL(ED.BillingEntity, 0) = 3)
	                        )
	                    )
	                OR ( ED.Entity = 'CL'
	                    AND ( CL.ClientCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                            AND (ISNULL(ED.BillingEntity, 0) = 1 OR ISNULL(ED.BillingEntity, 0) = 3)
	                       
	                    OR  BCL.ClientCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                        AND (ISNULL(ED.BillingEntity, 0) = 2 OR ISNULL(ED.BillingEntity, 0) = 3)
	                        )
	                    )
	                OR ( ED.Entity = 'DR'
	        			AND ( C.DoctorCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID) )
	                    )
	                OR ( ED.Entity = 'AT'
	                    AND ( C.PlaintiffAttorneyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                    
						OR C.DefenseAttorneyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
	                        )
	                    )
	                OR ( ED.Entity = 'PE'
	                    AND ( ER.EWParentEmployerID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID) )
	                    )
	                OR ( ED.Entity = 'ER'
	                    AND ( C.EmployerID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID) )
	                    )
	            )
			)
            AND ( ED.AllOffice = 1
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefOffice WHERE OfficeCode = C.OfficeCode )
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefOffice WHERE OfficeCode = @OfficeCode )
                )
            AND ( ED.AllCaseType = 1
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefCaseType WHERE CaseTypeCode = C.CaseType )
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefCaseType WHERE CaseTypeCode = @CaseTypeCode )
                )
            AND 
				( ED.AllService = 1
					OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefService WHERE ServiceCode = C.ServiceCode )
					OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefService WHERE ServiceCode = @ServiceCode )
				)
			AND
				( ED.AllEWServiceType = 1
					OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefEWServiceType AS tEWS
										INNER JOIN tblServices AS tS ON tEWS.EWServiceTypeID = tS.EWServiceTypeID 
										WHERE tS.ServiceCode = C.ServiceCode )
					OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefEWServiceType AS tEWS
										INNER JOIN tblServices AS tS ON tEWS.EWServiceTypeID = tS.EWServiceTypeID 
										WHERE tS.ServiceCode = @ServiceCode )
				)
            AND ( ( ED.StatusCode = -1
                    AND ( ED.ExceptionID <> 18
                            OR ISNULL(ED.StatusCodeValue, 1) = @EnterLeave
                        )
                    )
                    OR ( ED.StatusCode = @StatusCode
                        AND ED.StatusCodeValue = @EnterLeave
                        )
                )
			AND 
				( ED.AllSLARuleDetail = 1
					OR SLADET.SLARuleDetailID IN (SELECT SLARuleDetailID 
					                                FROM tblExceptionDefSLARuleDetail 
												   WHERE SLARuleDetailID = @SLARuleDetailID 
												     AND ExceptionDefID = ED.ExceptionDefID)
				)

    SET @Err = @@Error;

    RETURN @Err;
END;
GO




IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO
PRINT N'Update complete.';


GO
UPDATE tblExceptionDefinition
   SET BillingEntity = 2 -- Billing client
 WHERE UseBillingEntity = 1
GO
-- set to service client where origi column = 0 and entity is CO, CL, PC
UPDATE tblExceptionDefinition
   SET BillingEntity = 1 -- service client
 WHERE UseBillingEntity = 0 and Entity in ('CO', 'CL', 'PC')
-- all other entries default to None or 0
GO

-- Issue 11737 - Allstats VAT Changes - add business rule to change company name on correspondence
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(113, 'AllstatePolicyCompanyName', 'Case', 'Use the Company Name from tblCustomerData based on Allstate referral PolicyCompanyCode', 1, 1201, 0, NULL, NULL, NULL, NULL, NULL, 0)
GO

-- Issue 11742 - create some new Exception Triggers
INSERT INTO tblExceptionList (ExceptionID, Description, Status, DateAdded, UserIDAdded, Type)
VALUES(32, 'Create Invoice Quote', 'Active', GetDate(), 'Admin', 'Case'),
      (33, 'Create Voucher Quote', 'Active', GetDate(), 'Admin', 'Case')
GO

-- Issue 11716 - Add DPS Sort models for offices - all sort models for all offices CaseType = 10
  INSERT INTO tblOfficeDPSSortModel (Officecode, SortModelID, UserIDAdded, DateAdded) 
  SELECT O.OfficeCode, D.SortModelID, 'Admin', GetDate()
  FROM tblDPSSortModel AS D
  LEFT JOIN tblOffice AS O On 1=1
GO

