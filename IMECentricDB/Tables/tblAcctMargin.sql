CREATE TABLE [dbo].[tblAcctMargin] (
    [PrimaryKey]      INT         IDENTITY (1, 1) NOT NULL,
    [DocumentDate]    DATETIME    NOT NULL,
    [DocumentType]    VARCHAR (2) NOT NULL,
    [EWFacilityID]    INT         NOT NULL,
    [ParentCompanyID] INT         NOT NULL,
    [EWBusLineID]     INT         NOT NULL,
    [EWServiceTypeID] INT         NOT NULL,
    [AmountUS]        MONEY       NOT NULL,
    [CaseCount]       INT         NOT NULL,
    CONSTRAINT [PK_tblAcctMargin] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_tblAcctMargin_DocumentDateDocumentTypeEWFacilityIDParentCompanyIDEWBusLineIDEWServiceTypeID]
    ON [dbo].[tblAcctMargin]([DocumentDate] ASC, [DocumentType] ASC, [EWFacilityID] ASC, [ParentCompanyID] ASC, [EWBusLineID] ASC, [EWServiceTypeID] ASC)
    INCLUDE([AmountUS], [CaseCount]);

