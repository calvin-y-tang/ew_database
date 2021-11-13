CREATE TABLE [dbo].[tblEWWebUserAccount] (
    [EWWebUserID] INT      NOT NULL,
    [EWEntityID]  INT      NOT NULL,
    [UserType]    CHAR (2) NOT NULL,
    [IsUser]      BIT      NOT NULL,
    [DateAdded]   DATETIME NULL,
    CONSTRAINT [PK_tblEWWebUserAccount] PRIMARY KEY CLUSTERED ([EWWebUserID] ASC, [EWEntityID] ASC, [UserType] ASC)
);

