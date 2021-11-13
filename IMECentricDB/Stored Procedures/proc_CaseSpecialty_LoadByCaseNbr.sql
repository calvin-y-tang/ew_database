
CREATE PROCEDURE [proc_CaseSpecialty_LoadByCaseNbr]
(
        @casenbr int
)
AS
BEGIN
        SET NOCOUNT ON
        DECLARE @Err int

        SELECT * FROM tblCaseSpecialty INNER JOIN tblSpecialty ON tblCaseSpecialty.specialtyCode = tblSpecialty.specialtyCode 
                WHERE
                ([casenbr] = @casenbr) 

        SET @Err = @@Error

        RETURN @Err
END
