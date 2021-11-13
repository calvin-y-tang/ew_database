CREATE TABLE [dbo].[tblConfirmationStatus] (
    [ConfirmationStatusID] INT          NOT NULL,
    [Name]                 VARCHAR (30) NULL,
    CONSTRAINT [PK_tblConfirmationStatus] PRIMARY KEY CLUSTERED ([ConfirmationStatusID] ASC)
);

