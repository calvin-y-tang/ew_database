CREATE TABLE [dbo].[tblEWSecurityProfile] (
    [SecurityProfileID]     INT           NOT NULL,
    [Name]                  VARCHAR (20)  NULL,
    [Description]           VARCHAR (100) NULL,
    [MinPwdLength]          INT           NULL,
    [RequireNumber]         BIT           NULL,
    [RequireUpperCase]      BIT           NULL,
    [RequireLowerCase]      BIT           NULL,
    [RequireSymbol]         BIT           NULL,
    [PwdHistoryCount]       INT           NULL,
    [MinPwdAge]             INT           NULL,
    [MaxPwdAge]             INT           NULL,
    [MaxFailedLoginAttempt] INT           NULL,
    [LockoutDuration]       INT           NULL,
    [SessionTimeOut]        INT           NULL,
    CONSTRAINT [PK_tblEWSecurityProfile] PRIMARY KEY CLUSTERED ([SecurityProfileID] ASC)
);

