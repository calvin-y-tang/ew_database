CREATE TABLE [dbo].[tblEWFacilityGroup] (
    [EWFacilityGroupID] INT          IDENTITY (1, 1) NOT NULL,
    [GroupName]         VARCHAR (20) NULL,
    [CategoryID]        INT          NULL,
    [SeqNo]             INT          NULL,
    [CountryCode]       VARCHAR (2)  NULL,
    [Brand]             VARCHAR (5)  NULL,
    CONSTRAINT [PK_tblEWFacilityGroup] PRIMARY KEY CLUSTERED ([EWFacilityGroupID] ASC)
);

