CREATE TABLE [dbo].[InfoWindowsDomain] (
    [DomainName] VARCHAR (50) NOT NULL,
    [DL]         BIT          NULL,
    CONSTRAINT [PK_InfoWindowsDomain] PRIMARY KEY CLUSTERED ([DomainName] ASC)
);

