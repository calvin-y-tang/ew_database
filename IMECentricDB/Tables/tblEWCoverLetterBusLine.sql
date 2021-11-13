CREATE TABLE [dbo].[tblEWCoverLetterBusLine] (
    [EWCoverLetterBusLineID] INT          NOT NULL,
    [EWCoverLetterID]        INT          NOT NULL,
    [EWBusLineID]            INT          NOT NULL,
    [UserIDAdded]            VARCHAR (30) NULL,
    [DateAdded]              DATETIME     NULL,
    CONSTRAINT [PK_tblEWCoverLetterBusLine] PRIMARY KEY CLUSTERED ([EWCoverLetterBusLineID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEWCoverLetterBusLine_EWCoverLetterIDEWBusLineID]
    ON [dbo].[tblEWCoverLetterBusLine]([EWCoverLetterID] ASC, [EWBusLineID] ASC);

