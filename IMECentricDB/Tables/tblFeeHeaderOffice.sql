CREATE TABLE [dbo].[tblFeeHeaderOffice] (
    [FeeCode]    INT          NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblFeeHeaderOffice] PRIMARY KEY CLUSTERED ([FeeCode] ASC, [OfficeCode] ASC)
);

