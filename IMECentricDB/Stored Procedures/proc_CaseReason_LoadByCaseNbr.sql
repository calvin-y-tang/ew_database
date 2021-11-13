
CREATE PROCEDURE [proc_CaseReason_LoadByCaseNbr]
(
        @casenbr int
)
AS
BEGIN
        SET NOCOUNT ON
        DECLARE @Err int

        SELECT * FROM tblCaseReason INNER JOIN tblReason ON tblCaseReason.ReasonCode = tblReason.ReasonCode 
        
                WHERE
                        ([casenbr] = @casenbr)

        SET @Err = @@Error

        RETURN @Err
END
