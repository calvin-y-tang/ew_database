CREATE TABLE [dbo].[EWNetwork] (
    [EWNetworkID]       INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]              VARCHAR (40) NULL,
    [OutOfNetwork]      BIT          NOT NULL,
    [Active]            BIT          NOT NULL,
    [SeqNo]             INT          NOT NULL,
    [IsFeeZoneRequired] BIT          CONSTRAINT [DF_EWNetwork_IsFeeZoneRequired] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_EWNetwork] PRIMARY KEY CLUSTERED ([EWNetworkID] ASC)
);

