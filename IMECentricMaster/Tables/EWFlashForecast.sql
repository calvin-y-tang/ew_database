CREATE TABLE [dbo].[EWFlashForecast] (
    [PrimaryKey]        INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EWFGBusUnitID]     INT      NOT NULL,
    [EWFlashCategoryID] INT      NOT NULL,
    [UnitsThisMonth]    INT      NULL,
    [UnitsNextMonth]    INT      NULL,
    [DateEdited]        DATETIME NULL,
    [UserIDEdited]      INT      NULL,
    CONSTRAINT [PK_EWFlashForecast] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_EWFlashForecast_EWFGBusUnitIDEWFlashCategoryID]
    ON [dbo].[EWFlashForecast]([EWFGBusUnitID] ASC, [EWFlashCategoryID] ASC);

