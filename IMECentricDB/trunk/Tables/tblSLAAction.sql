CREATE TABLE [dbo].[tblSLAAction] (
    [SLAActionID]    INT          IDENTITY (1, 1) NOT NULL,
    [Name]           VARCHAR (25) NULL,
    [RequireComment] BIT          DEFAULT ((0)) NOT NULL,
    [IsResolution]   BIT          DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblSLAAction] PRIMARY KEY CLUSTERED ([SLAActionID] ASC)
);


