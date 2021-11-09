CREATE TABLE [dbo].[EWCoverLetterBusLine] (
    [EWCoverLetterBusLineID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EWCoverLetterID]        INT          NOT NULL,
    [EWBusLineID]            INT          NOT NULL,
    [UserIDAdded]            VARCHAR (30) NULL,
    [DateAdded]              DATETIME     NULL,
    CONSTRAINT [PK_EWCoverLetterBusLine] PRIMARY KEY CLUSTERED ([EWCoverLetterBusLineID] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_EWCoverLetterBusLine_EWCoverLetterIDEWBusLineID]
    ON [dbo].[EWCoverLetterBusLine]([EWCoverLetterID] ASC, [EWBusLineID] ASC);

