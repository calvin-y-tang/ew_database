CREATE TABLE [dbo].[InfoLauncherUpdate] (
    [PrimaryKey]  INT          IDENTITY (1, 1) NOT NULL,
    [EntityType]  VARCHAR (15) NOT NULL,
    [EntityValue] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_InfoLauncherUpdate] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);

