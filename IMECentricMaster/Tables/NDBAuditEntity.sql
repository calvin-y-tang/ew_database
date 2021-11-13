CREATE TABLE [dbo].[NDBAuditEntity] (
    [EntityType]  VARCHAR (50)  NOT NULL,
    [DisplayName] VARCHAR (100) NULL,
    CONSTRAINT [PK_NDBAuditEntity] PRIMARY KEY CLUSTERED ([EntityType] ASC)
);

