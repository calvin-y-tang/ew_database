CREATE TABLE [dbo].[ISCustomer] (
    [CustomerID]              INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CompanyID]               INT            NOT NULL,
    [Name]                    VARCHAR (128)  NULL,
    [LocalBusUnitCompanyID]   INT            NULL,
    [Active]                  BIT            NOT NULL,
    [NationalPortalCompanyID] INT            NULL,
    [RootFolder]              VARCHAR (8000) NOT NULL,
    [LocalBUDBID]             INT            NULL,
    [MedicalDocFolder]        VARCHAR (8000) NULL,
    [ClientMatchingMethod]    TINYINT        NOT NULL,
    [Notes]                   TEXT           NULL,
    [EWParentCompanyID]       INT            NULL,
    [UnknownEWClientID]       INT            CONSTRAINT [DF_ISCustomer_UnknownEWClientID] DEFAULT ((0)) NOT NULL,
    [EWFolderDefID]           INT            NULL,
    CONSTRAINT [PK_ISCustomer] PRIMARY KEY CLUSTERED ([CustomerID] ASC)
);

