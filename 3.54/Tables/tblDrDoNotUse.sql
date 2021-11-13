CREATE TABLE [dbo].[tblDrDoNotUse] (
    [Code]        INT          NOT NULL,
    [Type]        VARCHAR (2)  NOT NULL,
    [DoctorCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (30) NULL,
    CONSTRAINT [PK_tblDrDoNotUse] PRIMARY KEY CLUSTERED ([Code] ASC, [Type] ASC, [DoctorCode] ASC)
);

