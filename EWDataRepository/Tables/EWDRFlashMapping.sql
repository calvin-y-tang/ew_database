CREATE TABLE [dbo].[EWDRFlashMapping] (
    [EWBusUnitID]     INT          NOT NULL,
    [EWServiceTypeID] INT          NOT NULL,
    [Category]        VARCHAR (25) NULL,
    CONSTRAINT [PK_EWDRFlashMapping] PRIMARY KEY CLUSTERED ([EWBusUnitID] ASC, [EWServiceTypeID] ASC)
);

