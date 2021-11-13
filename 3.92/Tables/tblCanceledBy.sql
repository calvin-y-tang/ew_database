CREATE TABLE [dbo].[tblCanceledBy] (
    [CanceledByID] INT          NOT NULL,
    [Name]         VARCHAR (25) NULL,
    [ExtName]      VARCHAR (25) NULL,
    CONSTRAINT [PK_tblCanceledBy] PRIMARY KEY CLUSTERED ([CanceledByID] ASC)
);

