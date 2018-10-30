

CREATE PROCEDURE [dbo].[proc_Transcription_LoadByPrimaryKey]
(
 @TransCode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblTranscription]
 WHERE
  ([TransCode] = @TransCode)

 SET @Err = @@Error

 RETURN @Err
END

