CREATE TABLE [dbo].[tblSLARuleDetail] (
    [SLARuleDetailID]        INT          IDENTITY (1, 1) NOT NULL,
    [SLARuleID]              INT          NOT NULL,
    [TATCalculationMethodID] INT          NOT NULL,
    [DisplayOrder]           INT          NOT NULL,
    [RequiredNbr]            INT          NOT NULL,
    [ToleranceNbr]           INT          NOT NULL,
    [DateAdded]              DATETIME     NULL,
    [UserIDAdded]            VARCHAR (15) NULL,
    [DateEdited]             DATETIME     NULL,
    [UserIDEdited]           VARCHAR (15) NULL,
    [ExceptionDefIDTmp]      INT          NULL,
    [Network]                INT          NULL,
    [Amount]                 MONEY        NULL,
    [Priority]               INT          NULL,
    [Responsible]            VARCHAR (50) NULL,
    [NextAction]             VARCHAR (50) NULL,
    CONSTRAINT [PK_tblSLARuleDetail] PRIMARY KEY CLUSTERED ([SLARuleDetailID] ASC)
);

