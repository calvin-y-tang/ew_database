CREATE TABLE [dbo].[InfoUserEWFacilityGroup] (
    [UserID]            INT NOT NULL,
    [EWFacilityGroupID] INT NOT NULL,
    CONSTRAINT [PK_InfoUserEWFacilityGroup] PRIMARY KEY CLUSTERED ([UserID] ASC, [EWFacilityGroupID] ASC) WITH (FILLFACTOR = 90)
);

