CREATE TABLE [dbo].[EWWebUserAccount] (
    [EWWebUserID] INT      NOT NULL,
    [EWEntityID]  INT      NOT NULL,
    [UserType]    CHAR (2) NOT NULL,
    [IsUser]      BIT      NOT NULL,
    [DateAdded]   DATETIME NULL,
    CONSTRAINT [PK_EWWebUserAccount] PRIMARY KEY CLUSTERED ([EWWebUserID] ASC, [EWEntityID] ASC, [UserType] ASC)
);

