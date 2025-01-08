-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 143
IF NOT EXISTS (SELECT 1 FROM dbo.tblSetting WHERE [Name] = 'PreventDupInvoicesAndVouchers')
BEGIN
	INSERT INTO dbo.tblSetting ([Name], [Value]) VALUES ('PreventDupInvoicesAndVouchers', 'True')
END
GO

-- Sprint 143
-- IMEC-14466 - existing bizRule for 2500 penalty fee message
-- Update the Param4Desc column in the tblBusinessRule table
declare @DocCancelledAptId int = (
	select BusinessRuleID
	from tblBusinessRule
	where name = 'DocCancelledApt'
)
declare @AllStGRDocFeeID int = (
	select BusinessRuleID
	from tblBusinessRule
	where name = 'AllStateGRDoctorCancelFee'
)
if @DocCancelledAptId is not null and @AllStGRDocFeeID is not null
begin
    UPDATE tblBusinessRule SET Param4Desc = '1-BusDay, 2-ActDay'  -- Setting the value to flag whether Business Days or Actual Days are used
    WHERE businessruleId = @DocCancelledAptId;  -- Updating the row where businessruleId is 188

    UPDATE tblBusinessRuleCondition
    SET EWServiceTypeId = 1
    WHERE BusinessRuleConditionID IN (
        SELECT brc.BusinessRuleConditionID
        FROM tblBusinessRuleCondition brc
        WHERE brc.BusinessRuleID = @AllStGRDocFeeID
            AND brc.EntityType = 'PC'
            AND brc.EntityID = 4
            AND brc.BillingEntity = 2
            AND brc.Param2 = 'Allstate - $100 penalty'
    );

    -- Insert a new business rule condition for email notification
    INSERT INTO tblBusinessRuleCondition (
        EntityType,               -- Entity type: 'PC' (Parent Company)
        EntityID,                 -- Entity ID: 4 (tblEWParentCompany)
        BillingEntity,            -- Billing entity: 2 (For Both Parent Company and Company Client)
        ProcessOrder,             -- Process order: 1 
        BusinessRuleID,           -- Business rule ID: 188 (ID of the specific business rule)
        DateAdded,                -- Date added: current date/time (GETDATE())
        UserIDAdded,              -- User who added the record: 'Admin'
        DateEdited,               -- Date edited: NULL (No edit date as of now)
        UserIDEdited,             -- User who last edited the record: NULL (No edit by any user yet)
        OfficeCode,               -- Office code: NULL (No office code specified)
        EWBusLineID,              -- Business line ID: 7 (Represents tblEWBusLine)
        EWServiceTypeID,          -- Service type ID: NULL (Not specified)
        Jurisdiction,             -- Jurisdiction: NULL (Represents a specific jurisdiction code)
        Param1,                   -- Parameter 1: 4 (Doctor ID)
        Param2,                   -- Parameter 2: 7 (No of days)
        Param3,                   -- Parameter 3: 7 (Days b/w case & Appointment)
        Param4,                   -- Parameter 4: 2 (Flag 1-BusDay, 2-ActDay)
        Param5,                   -- Parameter 5: 'ExamWorks now owes Allstate...' (Description or message for the business rule)
        Skip,                     -- Skip: 0 (Flag indicating whether to skip the rule or not)
        Param6,                   -- Parameter 6: NULL (No value for this parameter)
        ExcludeJurisdiction       -- Exclude jurisdiction: 0 (No exclusion of jurisdiction)
    )
    VALUES (
        'PC', 4, 2, 1, @DocCancelledAptId, GETDATE(), 'Admin', NULL, NULL, NULL, 7, NULL, NULL, '4', '7', '7', '2', NULL, 0, 'ExamWorks now owes Allstate the following:
    • A $2500 penalty fee
    • A refund of the testimony/deposition fee (if prepaid)
    • A refund of the original IME/MMR service fee
                                        Thank you.', 0
    ),
    (
        'PC', 4, 2, 1, @AllStGRDocFeeID, GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 7, NULL, 'brent.nalley@examworks.com',
        'Allstate - $2500 penalty', 'DoNotReply@ExamWorks.com', 'Brent', 'Nalley', 0, 'Examworks users were notified that we owe Allstate a $2500 penalty for Case Number @casenbr@.', 0
    );
end
GO

-- Sprint 143
-- IMEC- 14686 Checking CaseDate to Appointment Date
UPDATE tblBusinessRule SET Param3Desc='DaysbetwnApptC&ApptT' WHERE BusinessRuleID=188;
GO

-- IMEC-14600 - data patch for populating the new table used to keep track of case history notes for use overrides
INSERT INTO tblCaseHistoryOverrides (CasehistoryID)
SELECT ID FROM tblCaseHistory WHERE (Eventdesc LIKE '%guardrails override%' 
  OR Eventdesc LIKE '%QA Checklist completed with override%' 
  OR Eventdesc LIKE '%Doctor Scheduling Discipline Override%') AND EventDate > '2024-10-01 16:36:46.000'
ORDER BY EventDate
GO

-- IMEC-14657 - additional additional product for additonal Liberty fee = "Med Recs"
SET IDENTITY_INSERT tblProduct ON
INSERT INTO tblProduct (ProdCode, Description, LongDesc, Status, Taxable, INGLAcct,
      VOGLAcct, DateAdded, UserIDAdded, XferToVoucher, UnitOfMeasureCode, AllowVoNegativeAmount, AllowInvoice, AllowVoucher, IsStandard)
  Values(3060, 'Med Recs', 'Medical Records', 'Active', 1, '400??',
         '500??', GETDATE(), 'Admin', 0, 'PG', 0, 1, 0, 1)
SET IDENTITY_INSERT tblProduct OFF
GO

