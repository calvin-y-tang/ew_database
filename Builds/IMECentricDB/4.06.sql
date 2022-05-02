

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
PRINT N'Altering [dbo].[tblDoctor]...';


GO
ALTER TABLE [dbo].[tblDoctor]
    ADD [IsMDorDO]                   BIT            NULL,
        [URAC]                       BIT            NULL,
        [CertificationStatusID]      INT            NULL,
        [CertificationStatusName]    VARCHAR (50)   NULL,
        [ActiveTreatingName]         VARCHAR (20)   NULL,
        [PracticeTreatingPercentage] DECIMAL (9, 5) NULL,
        [PracticeOtherPercentage]    DECIMAL (9, 5) NULL,
        [MeetsLookbackThreshold]     BIT            NULL,
        [RetirementDate]             DATETIME       NULL;


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
PRINT N'Altering [dbo].[spGetAllBusinessRules]...';


GO
ALTER PROCEDURE dbo.spGetAllBusinessRules
(
    @eventID INT,
    @clientCode INT,
    @billClientCode INT,
    @officeCode INT,
    @caseType INT,
    @serviceCode INT,
    @jurisdiction VARCHAR(5)
)
AS
BEGIN

	SET NOCOUNT ON

	SELECT DISTINCT *, ROW_NUMBER() OVER (PARTITION BY BusinessRuleID ORDER BY BusinessRuleID, ProcessOrder ASC ) AS RuleOrder 
	INTO #tmp_GetAllBusinessRules
	FROM (
			SELECT BR.BusinessRuleID, BR.Category, BR.Name,	 
			 tmpBR.BusinessRuleConditionID,
			 tmpBR.Param1,
			 tmpBR.Param2,
			 tmpBR.Param3,
			 tmpBR.Param4,
			 tmpBR.Param5,
			 tmpBR.EntityType,
			 tmpBR.ProcessOrder,
			 tmpBR.Skip, 
			 tmpBR.Param6
			FROM
				 (SELECT 1 AS GroupID, BRC.*
					FROM tblBusinessRuleCondition AS BRC
						LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @billClientCode
						LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
					WHERE 1=1
						AND (BRC.BillingEntity IN (0,2))
						AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

					UNION

					SELECT 2 AS GroupID, BRC.*
					FROM tblBusinessRuleCondition AS BRC
						LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @clientCode
						LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
					WHERE 1=1
						AND (BRC.BillingEntity IN (1,2))
						AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

					UNION

					SELECT 3 AS GroupID, BRC.*
					FROM tblBusinessRuleCondition AS BRC
					WHERE 1=1
						AND (BRC.EntityType='SW')
				) AS tmpBR
						INNER JOIN tblBusinessRule AS BR ON BR.BusinessRuleID = tmpBR.BusinessRuleID
						LEFT OUTER JOIN tblCaseType AS CT ON CT.Code = @caseType
						LEFT OUTER JOIN tblServices AS S ON S.ServiceCode = @serviceCode
			WHERE BR.IsActive = 1
				and BR.EventID = @eventID
				AND (tmpBR.OfficeCode IS NULL OR tmpBR.OfficeCode = @officeCode)
				AND (tmpBR.EWBusLineID IS NULL OR tmpBR.EWBusLineID = CT.EWBusLineID)
				AND (tmpBR.EWServiceTypeID IS NULL OR tmpBR.EWServiceTypeID = S.EWServiceTypeID)
				AND (tmpBR.Jurisdiction Is Null Or tmpBR.Jurisdiction = @jurisdiction)
	) AS sortedBR	
	ORDER BY sortedBR.BusinessRuleID, sortedBR.ProcessOrder

	SELECT BusinessRuleID, 
		   Category, 
		   Name,	 
		   BusinessRuleConditionID,
		   Param1,
		   Param2,
		   Param3,
		   Param4,
		   Param5,
		   EntityType,
		   ProcessOrder,
		   Skip, 
		   Param6 
	FROM #tmp_GetAllBusinessRules
	WHERE RuleOrder = 1 AND Skip = 0

END
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

-- Sprint 83

-- IMEC-12703 security tokens and business rules for Hartford Qualified Doctor. 
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('ScheduleNonQualifiedDoctor','Appointments - Non-Qualified Doctor Override', GetDate()),
       ('SchedUnknownQualifiedDoctor','Appointments - Unknown Qual Doctor Override', GetDate())      
GO

INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (142, 'ScheduleQualifiedDoctor', 'Case', 'Schedule Qualified Doctor', 1, 1101, 1, 'CustomerName', 'SubFormToDisplay', NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 32, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, NULL, 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 33, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, NULL, 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 34, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, NULL, 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 13, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, NULL, 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 14, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, NULL, 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 15, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, NULL, 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 16, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, NULL, 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 38, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, NULL, 1, NULL),
       (142, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 40, 3, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, NULL, 1, NULL),
       (142, 'PC', 30, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Hartford', 'subfrmDoctorNonQualifiedDetails', NULL, NULL, NULL, 0, NULL)
GO
