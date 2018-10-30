CREATE PROCEDURE [proc_CaseDocuments_Update]
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
	@seqno int,
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

	UPDATE [tblCaseDocuments]
	SET
		[casenbr] = @casenbr,
		[document] = @document,
		[type] = @type,
		[reporttype] = @reporttype,
		[description] = @description,
		[sfilename] = @sfilename,
		[dateadded] = @dateadded,
		[useridadded] = @useridadded,
		[dateedited] = @dateedited,
		[useridedited] = @useridedited,
		[PublishedTo] = @PublishedTo,
		[Viewed] = @Viewed,
		[FileMoved] = @FileMoved,
		[FileSize] = @FileSize,
		[Source] = @Source,
		[FolderID] = @FolderID,
		[SubFolder] = @SubFolder,
		[CaseDocTypeId] = @CaseDocTypeId
	WHERE
		[seqno] = @seqno


	SET @Err = @@Error


	RETURN @Err
END
GO