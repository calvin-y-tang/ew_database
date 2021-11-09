
-- create the stored procedure
CREATE PROCEDURE [dbo].[proc_WriteAcknowledgementRecordsSetDefaultError]  
AS
BEGIN
update SedgwickMCCAcknowledgement 
  set 
  FailureReasonCode1 = case when FailureReasonCode1 = 0 AND FailureReasonCode2 = 0  AND FailureReasonCode3 = 0  then '00000' else FailureReasonCode1 end, 
  FailureReasonDescription1 = case when LTRIM(FailureReasonDescription1) = '' AND LTRIM(FailureReasonDescription2)  = ''  AND LTRIM(FailureReasonDescription3) = ''  then 'No errors reported' else FailureReasonDescription1  end
END
