
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_WriteAcknowledgementRecordsPack2to1]  
AS
BEGIN
update SedgwickMCCAcknowledgement 
SET 
FailureReasonCode1 = FailureReasonCode2, 
FailureReasonDescription1  = FailureReasonDescription2, 
FailureReasonCode2 = '00000', 
FailureReasonDescription2 = 'No errors reported'  
WHERE FailureReasonCode1 = 0 and FailureReasonCode2 != 0;
END
