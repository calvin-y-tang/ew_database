CREATE TABLE [dbo].[tblCaseSLARuleDetail] (
    [CaseNbr]           INT          NOT NULL,
    [SLARuleDetailID]   INT          NOT NULL,
    [RequiredDate]      DATETIME     NULL,
    [ToleranceDate]     DATETIME     NULL,
    [Fullfilled]        BIT          CONSTRAINT [DF_tblCaseSLARuleDetail_Fullfilled] DEFAULT ((0)) NOT NULL,
    [DateAdded]         DATETIME     CONSTRAINT [DF_tblCaseSLARuleDetail_DateAdded] DEFAULT (getdate()) NOT NULL,
    [SLAExceptionID]    INT          NULL,
    [Explanation]       VARCHAR(120) NULL, 
    [UserIDAdded]       VARCHAR(15)  NULL, 
    [DateEdited]        DATETIME     NULL, 
    [UserIDEdited]      VARCHAR(15)  NULL, 
	[SysExceptionFired] BIT          NULL,
    CONSTRAINT [PK_tblCaseSLARuleDetail] PRIMARY KEY CLUSTERED ([CaseNbr] ASC, [SLARuleDetailID] ASC)
);





