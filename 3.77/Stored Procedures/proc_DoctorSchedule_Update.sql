CREATE PROCEDURE [proc_DoctorSchedule_Update]
(
	@schedcode int,
	@locationcode int,
	@date datetime,
	@starttime datetime,
	@description varchar(50) = NULL,
	@status varchar(15) = NULL,
	@duration int = NULL,
	@casenbr1 int = NULL,
	@casenbr1desc varchar(70) = NULL,
	@casenbr2 int = NULL,
	@casenbr2desc varchar(70) = NULL,
	@dateadded datetime = NULL,
	@useridadded varchar(15) = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(15) = NULL,
	@doctorcode int,
	@WasScheduled bit = true
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblDoctorSchedule]
	SET
		[date] = @date,
		[starttime] = @starttime,
		[description] = @description,
		[status] = @status,
		[duration] = @duration,
		[casenbr1] = @casenbr1,
		[casenbr1desc] = @casenbr1desc,
		[casenbr2] = @casenbr2,
		[casenbr2desc] = @casenbr2desc,
		[dateadded] = @dateadded,
		[useridadded] = @useridadded,
		[dateedited] = @dateedited,
		[useridedited] = @useridedited,
		[doctorcode] = @doctorcode,
		[WasScheduled] = @WasScheduled
	WHERE
		[schedcode] = @schedcode
	AND	[locationcode] = @locationcode


	SET @Err = @@Error


	RETURN @Err
END
GO