CREATE TABLE [dbo].[tblNonWorkDays] (
    [NonWorkDay]  DATETIME     NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (50) NULL,
    [Description] VARCHAR (25) NULL,
    CONSTRAINT [PK_tblNonWorkDays] PRIMARY KEY CLUSTERED ([NonWorkDay] ASC)
);

