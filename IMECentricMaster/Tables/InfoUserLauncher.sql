CREATE TABLE [dbo].[InfoUserLauncher] (
    [UserID]     INT NOT NULL,
    [LauncherID] INT NOT NULL,
    CONSTRAINT [PK_InfoUserLauncher] PRIMARY KEY CLUSTERED ([UserID] ASC, [LauncherID] ASC) WITH (FILLFACTOR = 90)
);

