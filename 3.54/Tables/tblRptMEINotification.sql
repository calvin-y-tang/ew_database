CREATE TABLE [dbo].[tblRptMEINotification] (
    [ProcessID]             INT           NOT NULL,
    [Casenbr]               INT           NULL,
    [ApptDate]              DATETIME      NULL,
    [CancelDate]            DATETIME      NULL,
    [ExamineeName]          VARCHAR (100) NULL,
    [ExamineeAddr1]         VARCHAR (100) NULL,
    [ExamineeAddr2]         VARCHAR (100) NULL,
    [ExamineeCityStateZip]  VARCHAR (100) NULL,
    [Examineephone]         VARCHAR (20)  NULL,
    [AttorneyCompany]       VARCHAR (100) NULL,
    [AttorneyName]          VARCHAR (100) NULL,
    [AttorneyAddr1]         VARCHAR (100) NULL,
    [AttorneyAddr2]         VARCHAR (100) NULL,
    [AttorneyCityStateZip]  VARCHAR (100) NULL,
    [Attorneyphone]         VARCHAR (30)  NULL,
    [AttorneyEmail]         VARCHAR (100) NULL,
    [bln3DayNotifClaimant]  BIT           NULL,
    [bln3DayNotifAttorney]  BIT           NULL,
    [bln14DayNotifClaimant] BIT           NULL,
    [bln14DayNotifAttorney] BIT           NULL
);




GO
CREATE NONCLUSTERED INDEX [IX_tblRptMEINotification_ProcessID]
    ON [dbo].[tblRptMEINotification]([ProcessID] ASC);

