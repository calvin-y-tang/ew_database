CREATE PROCEDURE [dbo].[proc_GetDoctorScheduleDatesByDoctorCode]

@DoctorCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT DISTINCT DATE FROM tblDoctorSchedule WHERE STATUS = 'Scheduled' and doctorcode = @DoctorCode and date >= getdate()

	SET @Err = @@Error

	RETURN @Err
END

GO