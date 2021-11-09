
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_WriteAcknowledgementRecordsPack3to2]  
AS
BEGIN
update SedgwickMCCAcknowledgement 
SET 
FailureReasonCode2 = FailureReasonCode3, 
FailureReasonDescription2  = FailureReasonDescription3, 
FailureReasonCode3 = '00000', 
FailureReasonDescription3 = 'No errors reported'  
WHERE FailureReasonCode2 = 0 and FailureReasonCode3 != 0;
END
