CREATE PROCEDURE [proc_WebNotification_Update]
(
	@WebNotificationID int,
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
	@NotificationSubject varchar(100) = NULL,
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

	UPDATE [tblWebNotification]
	SET
		[NotificationType] = @NotificationType,
		[EntityId] = @EntityId,
		[EntityType] = @EntityType,
		[ImeCentricCode] = @ImeCentricCode,
		[UserType] = @UserType,
		[WebUserId] = @WebUserId,
		[WebUserCompanyName] = @WebUserCompanyName,
		[WebUserFirstName] = @WebUserFirstName,
		[WebUserLastName] = @WebUserLastName,
		[WebUserEmailAddress] = @WebUserEmailAddress,
		[ToEmailAddress] = @ToEmailAddress,
		[FromEmailAddress] = @FromEmailAddress,
		[NotificationSubject] = @NotificationSubject,
		[NotificationDetail] = @NotificationDetail,
		[ErrorMessage] = @ErrorMessage,
		[DateAdded] = @DateAdded,
		[UserIDAdded] = @UserIDAdded,
		[NotificationSent] = @NotificationSent,
		[NotificationSentDate] = @NotificationSentDate
	WHERE
		[WebNotificationID] = @WebNotificationID

	SET @Err = @@Error

	RETURN @Err
END