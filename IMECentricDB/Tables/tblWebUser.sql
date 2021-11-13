CREATE TABLE [dbo].[tblWebUser] (
    [WebUserID]              INT           IDENTITY (1, 1) NOT NULL,
    [UserID]                 VARCHAR (100) NULL,
    [Password]               VARCHAR (200) NULL,
    [LastLoginDate]          DATETIME      NULL,
    [DateAdded]              DATETIME      NULL,
    [DateEdited]             DATETIME      NULL,
    [UserIDAdded]            VARCHAR (50)  NULL,
    [UserIDEdited]           VARCHAR (50)  NULL,
    [DisplayClient]          BIT           CONSTRAINT [DF_tblWebUser_DisplayClient] DEFAULT (1) NOT NULL,
    [ProviderSearch]         BIT           CONSTRAINT [DF_tblWebUser_ProviderSearch] DEFAULT (1) NOT NULL,
    [IMECentricCode]         INT           NOT NULL,
    [UserType]               VARCHAR (2)   CONSTRAINT [DF_tblWebUser_UserType] DEFAULT ('CL') NOT NULL,
    [AutoPublishNewCases]    BIT           CONSTRAINT [DF_tblWebUser_AutoPublishNewCases] DEFAULT (1) NOT NULL,
    [IsChangePassword]       BIT           CONSTRAINT [DF_tblWebUser_IsChangePassword] DEFAULT ((0)) NOT NULL,
    [IsClientAdmin]          BIT           CONSTRAINT [DF_tblWebUser_IsClientAdmin] DEFAULT ((0)) NOT NULL,
    [UpDateFlag]             BIT           CONSTRAINT [DF_tblWebUser_UpDateFlag] DEFAULT ((0)) NOT NULL,
    [LastPasswordChangeDate] DATETIME      NULL,
    [StatusID]               INT           NULL,
    [FailedLoginAttempts]    INT           NULL,
    [LockoutDate]            DATETIME      NULL,
    [WebCompanyID]           INT           NULL,
    [EWWebUserID]            INT           NULL,
    [ShowThirdPartyBilling]  BIT           CONSTRAINT [DF_tblWebUser_ShowThirdPartyBilling] DEFAULT ((0)) NOT NULL,
	[PortalVersion]			 INT		   NULL,
	[EWTimeZoneID]			 INT		   NULL,
	[QuietTimeEnabled]		 BIT		   NULL,
	[QuietTimeStart]		 DATETIME	   NULL,	
	[QuietTimeEnd]			 DATETIME	   NULL,
	[ShowFinancialInfo]      BIT           CONSTRAINT [DF_tblWebUser_ShowFinancialInfo] DEFAULT ((0)) NOT NULL,
	[PasswordSalt]           VARCHAR(36)   CONSTRAINT [DF_tblWebUser_PasswordSalt] DEFAULT (NEWID()) NOT NULL,
    [ShowOpenBlockTimeAppts] BIT		   CONSTRAINT [DF_tblWebUser_ShowOpenBlockTimeAppts] DEFAULT ((0)) NOT NULL, 
	[AllowScheduling]        BIT           CONSTRAINT [DF_tblWebUser_AllowScheduling] DEFAULT ((0)) NULL,
	[InputSourceID]			 INT		   NOT NULL,
	[AllowMedIndex]          BIT           CONSTRAINT [DF_tblWebUser_AllowMedIndex] DEFAULT ((0)) NULL,
	[RecordRetrievalMethod]  INT           CONSTRAINT [DF_tblWebUser_RecordRetrievalMethod] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblWebUser] PRIMARY KEY CLUSTERED ([WebUserID] ASC) WITH (FILLFACTOR = 90)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblWebUser_UserID]
    ON [dbo].[tblWebUser]([UserID] ASC);

