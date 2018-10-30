CREATE PROCEDURE [proc_WebNotification_LoadByPrimaryKey]
(
	@WebNotificationID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblWebNotification]
	WHERE
		([WebNotificationID] = @WebNotificationID)

	SET @Err = @@Error

	RETURN @Err
END