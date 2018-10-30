CREATE TABLE [dbo].[tblWebNotifyReason] (
    [ReasonCode]  INT           NOT NULL,
    [Description] VARCHAR (100) NULL,
    CONSTRAINT [PK_tblWebNotifyReason] PRIMARY KEY CLUSTERED ([ReasonCode] ASC)
);

