CREATE TABLE [dbo].[InfoUser] (
    [UserID]                 INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [WindowsUserName]        VARCHAR (50) NULL,
    [FirstName]              VARCHAR (50) NULL,
    [LastName]               VARCHAR (50) NULL,
    [DefaultDBID]            INT          NULL,
    [Active]                 BIT          NULL,
    [DateAdded]              DATETIME     NULL,
    [DateEdited]             DATETIME     NULL,
    [DateLastLogin]          DATETIME     NULL,
    [LoginCount]             INT          NULL,
    [AliasUserID]            INT          NULL,
    [WebAccess]              BIT          NULL,
    [DefaultCountryCode]     VARCHAR (2)  NULL,
    [Email]                  VARCHAR (70) NULL,
    [NDBAccess]              BIT          NULL,
    [Brands]                 VARCHAR (20) NULL,
    [Version]                VARCHAR (15) NULL,
    [IMECentricUserID]       VARCHAR (15) NULL,
    [Domain]                 VARCHAR (25) NULL,
    [ManagerUserID]          INT          NULL,
    [Grade]                  INT          NULL,
    [ADGUID]                 VARCHAR (32) NULL,
    [AddlDomain]             VARCHAR (25) NULL,
    [MaintenanceAccessLevel] INT          NULL,
    CONSTRAINT [PK_InfoUser] PRIMARY KEY CLUSTERED ([UserID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_InfoUser_WindowsUserName]
    ON [dbo].[InfoUser]([WindowsUserName] ASC) WITH (FILLFACTOR = 90);

