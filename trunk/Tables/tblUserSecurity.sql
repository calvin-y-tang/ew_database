CREATE TABLE [dbo].[tblUserSecurity] (
    [UserID]    VARCHAR (15) NOT NULL,
    [GroupCode] VARCHAR (15) NOT NULL,
    CONSTRAINT [PK_tblUserSecurity] PRIMARY KEY CLUSTERED ([UserID] ASC, [GroupCode] ASC)
);

