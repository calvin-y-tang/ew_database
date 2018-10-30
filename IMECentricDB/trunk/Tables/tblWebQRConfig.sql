CREATE TABLE [dbo].[tblWebQRConfig] (
    [EWFacilityID]         INT           NOT NULL,
    [QuickReferralEnabled] BIT           NOT NULL,
    [Email]                VARCHAR (200) NOT NULL,
    CONSTRAINT [PK_tblWebQRConfig] PRIMARY KEY CLUSTERED ([EWFacilityID] ASC)
);

