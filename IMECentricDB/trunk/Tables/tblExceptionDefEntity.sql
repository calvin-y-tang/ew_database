CREATE TABLE [dbo].[tblExceptionDefEntity] (
    [ExceptionDefID] INT          NOT NULL,
    [IMECentricCode] INT          NOT NULL,
    [Entity]         VARCHAR (10) NULL,
    CONSTRAINT [PK_tblExceptionDefEntity] PRIMARY KEY CLUSTERED ([ExceptionDefID] ASC, [IMECentricCode] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblExceptionDefEntity_IMECentricCode]
    ON [dbo].[tblExceptionDefEntity]([IMECentricCode] ASC);

