CREATE PROCEDURE [proc_CaseDocuments_Insert]
(
	@casenbr int,
	@document varchar(20),
	@type varchar(20) = NULL,
	@reporttype varchar(20) = NULL,
	@description varchar(200) = NULL,
	@sfilename varchar(200) = NULL,
	@dateadded datetime,
	@useridadded varchar(20) = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(30) = NULL,
	@seqno int = NULL output,
	@PublishedTo varchar(50) = NULL,
	@Viewed bit,
	@FileMoved bit,
	@FileSize int,
	@Source varchar(15),
	@FolderID int,
	@SubFolder varchar(32),
	@CaseDocTypeId int
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseDocuments]
	(
		[casenbr],
		[document],
		[type],
		[reporttype],
		[description],
		[sfilename],
		[dateadded],
		[useridadded],
		[dateedited],
		[useridedited],
		[PublishedTo],
		[Viewed],
		[FileMoved],
		[FileSize],
		[Source],
		[FolderID],
		[SubFolder],
		[CaseDocTypeId]
	)
	VALUES
	(
		@casenbr,
		@document,
		@type,
		@reporttype,
		@description,
		@sfilename,
		@dateadded,
		@useridadded,
		@dateedited,
		@useridedited,
		@PublishedTo,
		@Viewed,
		@FileMoved,
		@FileSize,
		@Source,
		@FolderID,
		@SubFolder,
		@CaseDocTypeId
	)

	SET @Err = @@Error

	SELECT @seqno = SCOPE_IDENTITY()

	RETURN @Err
END
GO
