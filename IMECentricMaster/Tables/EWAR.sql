CREATE TABLE [dbo].[EWAR] (
    [EWARID]             INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EWFacilityID]       INT      NOT NULL,
    [ARDate]             DATETIME NOT NULL,
    [MonetaryUnit]       INT      NOT NULL,
    [ExchangeRate]       MONEY    NOT NULL,
    [ARTotal]            MONEY    NULL,
    [ARTotalUS]          MONEY    NULL,
    [ARCurrent]          MONEY    NULL,
    [ARCurrentUS]        MONEY    NULL,
    [AROver30]           MONEY    NULL,
    [AROver30US]         MONEY    NULL,
    [AROver60]           MONEY    NULL,
    [AROver60US]         MONEY    NULL,
    [AROver90]           MONEY    NULL,
    [AROver90US]         MONEY    NULL,
    [AROver120]          MONEY    NULL,
    [AROver120US]        MONEY    NULL,
    [MTDCashCollected]   MONEY    NULL,
    [MTDCashCollectedUS] MONEY    NULL,
    [FormatVersion]      INT      CONSTRAINT [DF_EWAR_FormatVersion] DEFAULT ((1)) NOT NULL,
    [AROver180]          MONEY    NULL,
    [AROver180US]        MONEY    NULL,
    [AROver365]          MONEY    NULL,
    [AROver365US]        MONEY    NULL,
    CONSTRAINT [PK_EWAR] PRIMARY KEY CLUSTERED ([EWARID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_EWAR_ARDate]
    ON [dbo].[EWAR]([ARDate] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_EWAR_EWFacilityID]
    ON [dbo].[EWAR]([EWFacilityID] ASC) WITH (FILLFACTOR = 90);

