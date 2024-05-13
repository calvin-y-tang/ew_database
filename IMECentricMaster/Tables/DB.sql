CREATE TABLE [dbo].[DB] (
    [DBID]            INT          NOT NULL,
    [Name]            VARCHAR (15) NULL,
    [SQLInstance]     VARCHAR (256) NULL,
    [SQLDatabaseName] VARCHAR (25) NULL,
    [SQLUserName]     VARCHAR (25) NULL,
    [SQLPassword]     VARCHAR (25) NULL,
    [SQLVersion]      VARCHAR (5)  NULL,
    [DBType]          INT          NULL,
    [Active]          BIT          NULL,
    [NationalPortal]  BIT          NULL,
    [NDB]             BIT          NULL,
    [Descrip]         VARCHAR (20) NULL,
    [SeqNo]           INT          NULL,
    [CountryCode]     VARCHAR (2)  NULL,
    CONSTRAINT [PK_DB] PRIMARY KEY CLUSTERED ([DBID] ASC)
);

