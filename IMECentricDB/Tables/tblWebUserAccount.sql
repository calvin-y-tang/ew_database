CREATE TABLE [dbo].[tblWebUserAccount] (
    [WebUserID] INT      NOT NULL,
    [UserCode]  INT      NOT NULL,
    [IsUser]    BIT      CONSTRAINT [DF_tblWebUserAccount_IsUser] DEFAULT ((1)) NOT NULL,
    [DateAdded] DATETIME CONSTRAINT [DF_tblWebUserAccount_DateAdded] DEFAULT (getdate()) NULL,
    [IsActive]  BIT      CONSTRAINT [DF_tblWebUserAccount_IsActive] DEFAULT ((1)) NOT NULL,
    [UserType]  CHAR (2) NOT NULL,
    CONSTRAINT [PK_tblWebUserAccount] PRIMARY KEY CLUSTERED ([WebUserID] ASC, [UserCode] ASC, [UserType] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblWebUserAccount_UserCodeUserTypeIsActive]
    ON [dbo].[tblWebUserAccount]([UserCode] ASC, [UserType] ASC, [IsActive] ASC);

