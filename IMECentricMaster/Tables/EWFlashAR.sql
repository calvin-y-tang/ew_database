CREATE TABLE [dbo].[EWFlashAR] (
    [PrimaryKey]       INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EWFGBusUnitID]    INT      NOT NULL,
    [ARTotal]          MONEY    NULL,
    [ARCurrent]        MONEY    NULL,
    [AROver30]         MONEY    NULL,
    [AROver60]         MONEY    NULL,
    [AROver90]         MONEY    NULL,
    [AROver120]        MONEY    NULL,
    [MTDCashCollected] MONEY    NULL,
    [DateEdited]       DATETIME NULL,
    [UserIDEdited]     INT      NULL,
    CONSTRAINT [PK_EWFlashAR] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);

