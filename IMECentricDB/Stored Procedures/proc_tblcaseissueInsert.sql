CREATE PROCEDURE [dbo].[proc_tblcaseissueInsert]
(
	@casenbr int,
	@issuecode int,
	@dateadded datetime = NULL,
	@useridadded varchar(15) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblcaseissue]
	(
		[casenbr],
		[issuecode],
		[dateadded],
		[useridadded]
	)
	VALUES
	(
		@casenbr,
		@issuecode,
		@dateadded,
		@useridadded
	)

	SET @Err = @@Error


	RETURN @Err
END
