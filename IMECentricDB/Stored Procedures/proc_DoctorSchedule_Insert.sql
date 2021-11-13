

CREATE PROCEDURE [proc_DoctorSchedule_Insert]
(
 @schedcode int = NULL output,
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
 @doctorcode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblDoctorSchedule]
 (
  [locationcode],
  [date],
  [starttime],
  [description],
  [status],
  [duration],
  [casenbr1],
  [casenbr1desc],
  [casenbr2],
  [casenbr2desc],
  [dateadded],
  [useridadded],
  [dateedited],
  [useridedited],
  [doctorcode]
 )
 VALUES
 (
  @locationcode,
  @date,
  @starttime,
  @description,
  @status,
  @duration,
  @casenbr1,
  @casenbr1desc,
  @casenbr2,
  @casenbr2desc,
  @dateadded,
  @useridadded,
  @dateedited,
  @useridedited,
  @doctorcode
 )

 SET @Err = @@Error

 SELECT @schedcode = SCOPE_IDENTITY()

 RETURN @Err
END


