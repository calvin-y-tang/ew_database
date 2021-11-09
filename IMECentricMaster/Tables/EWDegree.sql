CREATE TABLE [dbo].[EWDegree] (
    [EWDegreeID]  INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DegreeCode]  VARCHAR (20) NULL,
    [Description] VARCHAR (50) NULL,
    CONSTRAINT [PK_EWDegree] PRIMARY KEY CLUSTERED ([EWDegreeID] ASC)
);

