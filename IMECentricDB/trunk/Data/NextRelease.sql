
-- Issue 11736 - data patch from UserBillingEntity to BillingEntity column
-- existing UseBillingEntity column
-- 0 = none or case client 
-- 1 = billing client
-- for new BillingEntity column
--   0 = none
--   1 = case service client
--   2 = billing client
--   3 = Both
-- set to Billing Client where orig column = 1
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

