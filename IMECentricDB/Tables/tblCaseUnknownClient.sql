CREATE TABLE [dbo].[tblCaseUnknownClient] (
    [CaseNbr]       INT          NOT NULL,
    [ReferralEmail] VARCHAR (70) NULL,
    [Processed]     BIT          NULL,
    CONSTRAINT [PK_tblCaseUnknownClient] PRIMARY KEY CLUSTERED ([CaseNbr] ASC)
);

