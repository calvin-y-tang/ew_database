CREATE TABLE [dbo].[tblEWBusLine] (
    [EWBusLineID]  INT          NOT NULL,
    [SeqNo]        INT          NULL,
    [Name]         VARCHAR (20) NULL,
    [GPGLAcctPart] VARCHAR (2)  NULL,
    [Mapping1]     VARCHAR (10) NULL,
    [Mapping2]     VARCHAR (10) NULL,
    [Mapping3]     VARCHAR (10) NULL,
    CONSTRAINT [PK_tblEWBusLine] PRIMARY KEY CLUSTERED ([EWBusLineID] ASC)
);

