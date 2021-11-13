CREATE PROCEDURE [proc_CaseDocuments_CheckIfExists]

@CaseNbr int,
@SFileName varchar(200)

AS

SELECT SeqNo FROM tblCaseDocuments WHERE CaseNbr = @CaseNbr AND sFileName = @SFileName
GO