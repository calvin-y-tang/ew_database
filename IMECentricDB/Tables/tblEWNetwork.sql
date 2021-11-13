CREATE TABLE [dbo].[tblEWNetwork] (
    [EWNetworkID]       INT          IDENTITY (1, 1) NOT NULL,
    [Name]              VARCHAR (40) NULL,
    [OutOfNetwork]      BIT          NOT NULL,
    [Active]            BIT          NOT NULL,
    [SeqNo]             INT          NOT NULL,
    [IsFeeZoneRequired] BIT          CONSTRAINT [DF_tblEWNetwork_IsFeeZoneRequired] DEFAULT (0) NOT NULL, 
    CONSTRAINT [PK_tblEWNetwork] PRIMARY KEY CLUSTERED ([EWNetworkID] ASC)
);

