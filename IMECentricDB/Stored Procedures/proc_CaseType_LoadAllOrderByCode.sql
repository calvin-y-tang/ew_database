
CREATE PROCEDURE [proc_CaseType_LoadAllOrderByCode]

AS
BEGIN

        SET NOCOUNT ON
        DECLARE @Err int

        SELECT *

        FROM [tblCaseType]
        WHERE PublishOnWeb = 1
        ORDER BY [code]

        SET @Err = @@Error

        RETURN @Err
END
