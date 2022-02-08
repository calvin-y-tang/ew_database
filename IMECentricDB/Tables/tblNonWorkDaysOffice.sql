CREATE TABLE [dbo].[tblNonWorkDaysOffice] (
    [NonWorkDay]  DATETIME     NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (50) NULL,
    [Description] VARCHAR (25) NULL,
    CONSTRAINT [PK_tblNonWorkDaysOffice] PRIMARY KEY CLUSTERED ([NonWorkDay] ASC, [OfficeCode] ASC)
);


