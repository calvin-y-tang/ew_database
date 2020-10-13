CREATE TABLE [dbo].[tblRecordsObtainment] (
    [RecordsID]         INT          IDENTITY (1, 1) NOT NULL,
    [CaseNbr]           INT          NOT NULL,
    [ObtainmentTypeID]  INT          NULL,
    [DateRequested]     DATETIME     NULL,
    [FacilityID]        INT          NULL,
    [Fee]               FLOAT (53)   NULL,
    [CheckDate]         DATETIME     NULL,
    [CheckNbr]          VARCHAR (10) NULL,
    [DateReceived]      DATETIME     NULL,
    [Status]            VARCHAR (20) NULL,
    [UserIDAdded]       VARCHAR (50) NULL,
    [DateAdded]         DATETIME     NULL,
    [UserIDEdited]      VARCHAR (50) NULL,
    [DateEdited]        DATETIME     NULL,
    [WaitingForInvoice] BIT          NULL,
    [AccountNbr]        VARCHAR (15) NULL,
    [ExtNotes]          TEXT         NULL,
    [IntNotes]          TEXT         NULL,
    [InvHeaderID]       INT          NULL,
    CONSTRAINT [PK_tblRecordsObtainment] PRIMARY KEY CLUSTERED ([RecordsID] ASC) WITH (FILLFACTOR = 90)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblRecordsObtainment_CaseNbr]
    ON [dbo].[tblRecordsObtainment]([CaseNbr] ASC);

