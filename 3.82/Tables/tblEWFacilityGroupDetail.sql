CREATE TABLE [dbo].[tblEWFacilityGroupDetail] (
    [EWFacilityGroupID] INT NOT NULL,
    [EWFacilityID]      INT NOT NULL,
    CONSTRAINT [PK_tblEWFacilityGroupDetail] PRIMARY KEY CLUSTERED ([EWFacilityGroupID] ASC, [EWFacilityID] ASC)
);

