CREATE PROCEDURE [proc_CaseHistory_Update]
(
	@id int,
	@casenbr int,
	@eventdate datetime,
	@eventdesc varchar(50) = NULL,
	@userid varchar(15) = NULL,
	@otherinfo varchar(1000) = NULL,
	@duration int = NULL,
	@type varchar(20) = NULL,
	@status int = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(30) = NULL,
	@dateadded datetime = NULL,
	@SubCaseID int = NULL,
	@Highlight bit = NULL,
	@Viewed bit,
	@PublishedTo varchar(50) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCaseHistory]
	SET
		[casenbr] = @casenbr,
		[eventdate] = @eventdate,
		[eventdesc] = @eventdesc,
		[userid] = @userid,
		[otherinfo] = @otherinfo,
		[duration] = @duration,
		[type] = @type,
		[status] = @status,
		[dateedited] = @dateedited,
		[useridedited] = @useridedited,
		[dateadded] = @dateadded,
		[SubCaseID] = @SubCaseID,
		[Highlight] = @Highlight,
		[Viewed] = @Viewed,
		[PublishedTo] = @PublishedTo
	WHERE
		[id] = @id


	SET @Err = @@Error


	RETURN @Err
END
GO
