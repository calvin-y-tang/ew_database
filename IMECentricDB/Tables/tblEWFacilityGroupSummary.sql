CREATE TABLE [dbo].[tblEWFacilityGroupSummary] (
    [EWFacilityID]       INT          NOT NULL,
    [Facility]           VARCHAR (20) NULL,
    [RegionGroupID]      INT          NULL,
    [RegionGroupName]    VARCHAR (20) NULL,
    [SubRegionGroupID]   INT          NULL,
    [SubRegionGroupName] VARCHAR (20) NULL,
    [BusUnitGroupID]     INT          NULL,
    [BusUnitGroupName]   VARCHAR (20) NULL,
    [FacilitySeqNo]      INT          NULL,
    [RegionSeqNo]        INT          NULL,
    [SubRegionSeqNo]     INT          NULL,
    [BusUnitSeqNo]       INT          NULL,
    [DivisionGroupID]    INT          NULL,
    [DivisionGroupName]  VARCHAR (20) NULL,
    [DivisionSeqNo]      INT          NULL,
    CONSTRAINT [PK_tblEWFacilityGroupSummary] PRIMARY KEY CLUSTERED ([EWFacilityID] ASC)
);



