CREATE TABLE [dbo].[tblSLAAction] (
    [SLAActionID]    INT          IDENTITY (1, 1) NOT NULL,
    [Name]           VARCHAR (25) NULL,
    [RequireComment] BIT          CONSTRAINT [DF_tblSLAAction_RequireComment] DEFAULT ((0)) NOT NULL,
    [IsResolution]   BIT          CONSTRAINT [DF_tblSLAAction_IsResolution] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblSLAAction] PRIMARY KEY CLUSTERED ([SLAActionID] ASC)
);


