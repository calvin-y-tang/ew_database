CREATE TABLE [dbo].[tblExceptionDefSLARuleDetail]
(
	[ExceptionDefID] [int] NOT NULL,
	[SLARuleDetailID] [int] NOT NULL,
	CONSTRAINT [PK_tblExceptionDefSLARuleDetail] PRIMARY KEY CLUSTERED ([ExceptionDefID] ASC, [SLARuleDetailID] ASC)
)
