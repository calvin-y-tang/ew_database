CREATE TABLE [dbo].[tblWebPasswordHistory] (
    [WebUserID]            INT           NULL,
    [PasswordDate]         DATETIME      NULL,
    [Password]             VARCHAR (200) NULL,
    [WebPasswordHistoryID] INT           IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_tblWebPasswordHistory] PRIMARY KEY CLUSTERED ([WebPasswordHistoryID] ASC)
);

