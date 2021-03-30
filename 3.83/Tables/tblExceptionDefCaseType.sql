CREATE TABLE [dbo].[tblExceptionDefCaseType] (
    [ExceptionDefID] INT NOT NULL,
    [CaseTypeCode]     INT NOT NULL,
    CONSTRAINT [PK_tblExceptionDefCaseType] PRIMARY KEY CLUSTERED ([ExceptionDefID] ASC, [CaseTypeCode] ASC)
);

