CREATE TABLE [dbo].[tblEWAuditEntity] (
    [EntityType]  VARCHAR (50)  NOT NULL,
    [DisplayName] VARCHAR (100) NULL,
    CONSTRAINT [PK_tblEWAuditEntity] PRIMARY KEY CLUSTERED ([EntityType] ASC)
);

