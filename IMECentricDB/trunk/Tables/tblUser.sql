CREATE TABLE [dbo].[tblUser] (
    [UserID]                 VARCHAR (15)     NOT NULL,
    [UserType]               VARCHAR (5)      NOT NULL,
    [LastName]               VARCHAR (50)     NULL,
    [FirstName]              VARCHAR (50)     NULL,
    [Email]                  VARCHAR (50)     NULL,
    [Phone]                  VARCHAR (15)     NULL,
    [PhoneExt]               VARCHAR (15)     NULL,
    [DateEdited]             DATETIME         NULL,
    [UserIDEdited]           VARCHAR (15)     NULL,
    [DateAdded]              DATETIME         NULL,
    [UserIDAdded]            VARCHAR (15)     NULL,
    [Password]               VARCHAR (20)     NULL,
    [ComputerUser]           BIT              NULL,
    [Param]                  VARCHAR (50)     NULL,
    [LastComputerName]       VARCHAR (256)    NULL,
    [LastLogin]              DATETIME         NULL,
    [WebGUID]                UNIQUEIDENTIFIER NULL,
    [DefaultDymoPrinter]     VARCHAR (100)    NULL,
    [WindowsUsername]        VARCHAR (100)    NULL,
    [SeqNo]                  INT              IDENTITY (1, 1) NOT NULL,
    [Admin]                  BIT              CONSTRAINT [DF_tblUser_Admin] DEFAULT ((0)) NOT NULL,
    [HorzRes]                INT              NULL,
    [VertRes]                INT              NULL,
    [ColorDepth]             INT              NULL,
    [FontSize]               INT              NULL,
    [MonitorCount]           INT              NULL,
    [TotalRAM]               INT              NULL,
    [AvailRAM]               INT              NULL,
    [TransCode]              INT              NULL,
    [AdminFinance]           BIT              CONSTRAINT [DF_tblUser_AdminFinance] DEFAULT ((0)) NOT NULL,
    [MaintenanceAccessLevel] INT              CONSTRAINT [DF_tblUser_MaintenanceAccessLevel] DEFAULT ((0)) NOT NULL, 
    [UserVersion]			 INT			  CONSTRAINT [DF_tblUser_UserVersion] DEFAULT ((1)) NOT NULL, 
	[RestrictToFavorites]    BIT              CONSTRAINT [DF_tblUser_RestrictToFavorites] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblUser] PRIMARY KEY ([SeqNo])
);






GO
CREATE NONCLUSTERED INDEX [IX_tblUser_WindowsUsername]
    ON [dbo].[tblUser]([WindowsUsername] ASC);


GO

CREATE UNIQUE INDEX [IX_U_tblUser_UserIDUserType]
	ON [dbo].[tblUser] ([UserID], [UserType])
