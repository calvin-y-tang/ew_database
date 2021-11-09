CREATE TABLE [dbo].[EWFlashFinancial] (
    [PrimaryKey]        INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EWFGBusUnitID]     INT      NOT NULL,
    [EWFlashCategoryID] INT      NOT NULL,
    [Units]             INT      NULL,
    [GrossRevenue]      MONEY    NULL,
    [DoctorCost]        MONEY    NULL,
    [DateEdited]        DATETIME NULL,
    [UserIDEdited]      INT      NULL,
    CONSTRAINT [PK_EWFlashFinancial] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);

