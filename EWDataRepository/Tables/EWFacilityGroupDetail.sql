CREATE TABLE [dbo].[EWFacilityGroupDetail] (
    [EWFacilityGroupID] INT NOT NULL,
    [EWFacilityID]      INT NOT NULL,
    CONSTRAINT [PK_EWFacilityGroupDetail] PRIMARY KEY CLUSTERED ([EWFacilityGroupID] ASC, [EWFacilityID] ASC)
);

