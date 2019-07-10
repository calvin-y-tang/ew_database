CREATE TABLE [dbo].[tblCustomerFeeHeader] (
    [CustomerFeeHeaderID] INT          IDENTITY (1, 1) NOT NULL,
    [Name]                VARCHAR (30) NULL,
    [EntityType]          VARCHAR (2)  NULL,
    [EntityID]            INT          NOT NULL,
    [StartDate]           DATETIME     NOT NULL,
    [EndDate]             DATETIME     NULL,
    [UserIDAdded]         VARCHAR (15) NULL,
    [DateAdded]           DATETIME     NULL,
    [UserIDEdited]        VARCHAR (15) NULL,
    [DateEdited]          DATETIME     NULL,
    CONSTRAINT [PK_tblCustomerFeeHeader] PRIMARY KEY CLUSTERED ([CustomerFeeHeaderID] ASC)
);

