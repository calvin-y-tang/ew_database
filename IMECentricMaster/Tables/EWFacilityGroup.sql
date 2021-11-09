CREATE TABLE [dbo].[EWFacilityGroup] (
    [EWFacilityGroupID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [GroupName]         VARCHAR (20) NULL,
    [CategoryID]        INT          NULL,
    [SeqNo]             INT          NULL,
    [CountryCode]       VARCHAR (2)  NULL,
    [Brand]             VARCHAR (5)  NULL,
    CONSTRAINT [PK_EWFacilityGroup] PRIMARY KEY CLUSTERED ([EWFacilityGroupID] ASC)
);

