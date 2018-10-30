CREATE TABLE [dbo].[tblEWWebUser] (
    [EWWebUserID]            INT           NOT NULL,
    [UserID]                 VARCHAR (100) NULL,
    [Password]               VARCHAR (200) NULL,
    [UserType]               VARCHAR (2)   NOT NULL,
    [EWEntityID]             INT           NOT NULL,
    [ProviderSearch]         BIT           NOT NULL,
    [AutoPublishNewCases]    BIT           NOT NULL,
    [StatusID]               INT           NOT NULL,
    [LastLoginDate]          DATETIME      NULL,
    [FailedLoginAttempts]    INT           NOT NULL,
    [LockoutDate]            DATETIME      NULL,
    [LastPasswordChangeDate] DATETIME      NULL,
    [DateAdded]              DATETIME      NULL,
    [UserIDAdded]            VARCHAR (50)  NULL,
    [DateEdited]             DATETIME      NULL,
    [UserIDEdited]           VARCHAR (50)  NULL,
    [DisplayClient]          BIT           CONSTRAINT [DF_tblEWWebUser_DisplayClient] DEFAULT ((1)) NOT NULL,
    [ShowThirdPartyBilling]  BIT           CONSTRAINT [DF_tblEWWebUser_ShowThirdPartyBilling] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblEWWebUser] PRIMARY KEY CLUSTERED ([EWWebUserID] ASC)
);




GO



GO
CREATE NONCLUSTERED INDEX [IX_tblEWWebUser_UserTypeEWEntityID]
    ON [dbo].[tblEWWebUser]([UserType] ASC, [EWEntityID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblEWWebUser_UserID]
    ON [dbo].[tblEWWebUser]([UserID] ASC);

