CREATE TABLE [dbo].[GPOPSubType] (
    [OPType]        VARCHAR (2)  NOT NULL,
    [OPSubType]     VARCHAR (15) NOT NULL,
    [GPVendorClass] VARCHAR (50) NULL,
    CONSTRAINT [PK_GPOPSubType] PRIMARY KEY CLUSTERED ([OPType] ASC, [OPSubType] ASC)
);

