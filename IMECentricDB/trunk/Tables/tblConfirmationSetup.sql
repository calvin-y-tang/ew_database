CREATE TABLE [dbo].[tblConfirmationSetup] (
    [ConfirmationSetupID]  INT              IDENTITY (1, 1) NOT NULL,
    [CallerIDNumber]       VARCHAR (15)     NULL,
    [DefaultStartTime]     DATETIME         NOT NULL,
    [DefaultEndTime]       DATETIME         NOT NULL,
    [TimeZone]             VARCHAR (4)      NULL,
    [InstallationGUID]     UNIQUEIDENTIFIER NULL,
    [FileNamePattern]      VARCHAR (50)     NULL,
    [ServerAddress]        VARCHAR (70)     NULL,
    [Username]             VARCHAR (50)     NULL,
    [Password]             VARCHAR (50)     NULL,
    [ConfirmationSystemID] INT              CONSTRAINT [DF_tblConfirmationSetup_ConfirmationSystemID] DEFAULT ((1)) NOT NULL,
    [Name]                 VARCHAR (20)     NULL,
    [MinCallsPerHr]        INT              NULL,
    [RetryPeriodMins]      INT              NULL,
    [SubmitIntervalMins]   INT              NULL,
    [TransferPhone]        VARCHAR (15)     NULL,
    [EWTimeZoneID]         INT              NULL, 
    [SMSShortCodeNumber]   VARCHAR(5)       NULL, 
    CONSTRAINT [PK_tblConfirmationSetup] PRIMARY KEY CLUSTERED ([ConfirmationSetupID] ASC)
);










