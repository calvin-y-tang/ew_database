CREATE TABLE [dbo].[GPDB] (
    [GPDBID]          INT          NOT NULL,
    [Name]            VARCHAR (20) NULL,
    [SQLInstance]     VARCHAR (256) NULL,
    [SQLDatabaseName] VARCHAR (25) NULL,
    [SQLUserName]     VARCHAR (25) NULL,
    [SQLPassword]     VARCHAR (25) NULL,
    [LastID]          INT          NULL,
    [MonetaryUnit]    INT          NOT NULL,
    CONSTRAINT [PK_GPDB] PRIMARY KEY CLUSTERED ([GPDBID] ASC)
);

