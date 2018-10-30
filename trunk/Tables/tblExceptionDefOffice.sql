CREATE TABLE [dbo].[tblExceptionDefOffice] (
    [ExceptionDefID] INT NOT NULL,
    [OfficeCode]     INT NOT NULL,
    CONSTRAINT [PK_tblExceptionDefOffice] PRIMARY KEY CLUSTERED ([ExceptionDefID] ASC, [OfficeCode] ASC)
);

