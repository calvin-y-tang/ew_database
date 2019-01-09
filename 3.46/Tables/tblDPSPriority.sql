CREATE TABLE [dbo].[tblDPSPriority] (
    [DPSPriorityID]   INT          IDENTITY (1, 1) NOT NULL,
    [Name]            VARCHAR (25) NULL,
    [ExtPriorityCode] VARCHAR (10) NULL,
    CONSTRAINT [PK_tblDPSPriority] PRIMARY KEY CLUSTERED ([DPSPriorityID] ASC)
);

