/****** Object:  StoredProcedure [proc_CaseHistory_UpdateViewed]    Script Date: 2/16/2010 11:24:36 PM ******/
CREATE PROCEDURE [proc_CaseHistory_UpdateViewed]

@casenbr int

AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE tblCaseHistory SET viewed = 1 WHERE casenbr = @casenbr 

	SET @Err = @@Error

	RETURN @Err
END
GO
