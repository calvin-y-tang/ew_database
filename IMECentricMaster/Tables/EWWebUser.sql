CREATE TABLE [dbo].[EWWebUser] (
    [EWWebUserID]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserID]                 VARCHAR (100) NULL,
    [Password]               VARCHAR (200) NULL,
    [UserType]               VARCHAR (2)   CONSTRAINT [DF_EWWebUser_UserType] DEFAULT ('CL') NOT NULL,
    [EWEntityID]             INT           NOT NULL,
    [ProviderSearch]         BIT           CONSTRAINT [DF_EWWebUser_ProviderSearch] DEFAULT ((1)) NOT NULL,
    [AutoPublishNewCases]    BIT           CONSTRAINT [DF_EWWebUser_AutoPublishNewCases] DEFAULT ((1)) NOT NULL,
    [StatusID]               INT           NOT NULL,
    [LastLoginDate]          DATETIME      NULL,
    [FailedLoginAttempts]    INT           NOT NULL,
    [LockoutDate]            DATETIME      NULL,
    [LastPasswordChangeDate] DATETIME      NULL,
    [DateAdded]              DATETIME      NULL,
    [UserIDAdded]            VARCHAR (50)  NULL,
    [DateEdited]             DATETIME      NULL,
    [UserIDEdited]           VARCHAR (50)  NULL,
    [DisplayClient]          BIT           CONSTRAINT [DF_EWWebUser_DisplayClient] DEFAULT ((1)) NOT NULL,
    [ShowThirdPartyBilling]  BIT           CONSTRAINT [DF_EWWebUser_ShowThirdPartyBilling] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_EWWebUser] PRIMARY KEY CLUSTERED ([EWWebUserID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_EWWebUser_UserTypeEWEntityID]
    ON [dbo].[EWWebUser]([UserType] ASC, [EWEntityID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_EWWebUser_UserID]
    ON [dbo].[EWWebUser]([UserID] ASC);

