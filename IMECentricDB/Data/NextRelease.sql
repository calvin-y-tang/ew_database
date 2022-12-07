-- Sprint 99

-- IMEC-13222 - modify business rule to allow for EWFacility matching and override
UPDATE tblBusinessRule
   SET Param3Desc = 'EWFacIDNormTaxes'
 WHERE BusinessRuleID = 155
 GO
UPDATE tblBusinessRuleCondition
   SET Param3 = ';5;'
 WHERE BusinessRuleID = 155
 GO
