CREATE PROCEDURE [proc_WebNotification_Insert]
(
	@WebNotificationID int = NULL output,
	@NotificationType varchar(30),
	@EntityId int = NULL,
	@EntityType varchar(50) = NULL,
	@ImeCentricCode int = NULL,
	@UserType char(2) = NULL,
	@WebUserId int = NULL,
	@WebUserCompanyName varchar(100) = NULL,
	@WebUserFirstName varchar(50) = NULL,
	@WebUserLastName varchar(50) = NULL,
	@WebUserEmailAddress varchar(200) = NULL,
	@ToEmailAddress varchar(200) = NULL,
	@FromEmailAddress varchar(200) = NULL,
	@NotificationSubject varchar(1000) = NULL,
	@NotificationDetail varchar(MAX) = NULL,
	@ErrorMessage varchar(500) = NULL,
	@DateAdded smalldatetime = NULL,
	@UserIDAdded varchar(100) = NULL,
	@NotificationSent bit = NULL,
	@NotificationSentDate smalldatetime = NULL
)

AS

BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblWebNotification]
	(
		[NotificationType],
		[EntityId],
		[EntityType],
		[ImeCentricCode],
		[UserType],
		[WebUserId],
		[WebUserCompanyName],
		[WebUserFirstName],
		[WebUserLastName],
		[WebUserEmailAddress],
		[ToEmailAddress],
		[FromEmailAddress],
		[NotificationSubject],
		[NotificationDetail],
		[ErrorMessage],
		[DateAdded],
		[UserIDAdded],
		[NotificationSent],
		[NotificationSentDate]
	)
	VALUES
	(
		@NotificationType,
		@EntityId,
		@EntityType,
		@ImeCentricCode,
		@UserType,
		@WebUserId,
		@WebUserCompanyName,
		@WebUserFirstName,
		@WebUserLastName,
		@WebUserEmailAddress,
		@ToEmailAddress,
		@FromEmailAddress,
		@NotificationSubject,
		@NotificationDetail,
		@ErrorMessage,
		@DateAdded,
		@UserIDAdded,
		@NotificationSent,
		@NotificationSentDate
	)

	SET @Err = @@Error

	SELECT @WebNotificationID = SCOPE_IDENTITY()

	RETURN @Err
END