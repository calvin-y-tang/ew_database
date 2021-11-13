CREATE TABLE [dbo].[tblClaimInfo] (
    [CMSBox23]           VARCHAR (30)  NULL,
    [CMSBox31Line1]      VARCHAR (100) NULL,
    [CMSBox31Line2]      VARCHAR (50)  NULL,
    [CMSBox32b]          VARCHAR (50)  NULL,
    [CMSBox33b]          VARCHAR (20)  NULL,
    [CMSBox24JNonNPINbr] VARCHAR (50)  NULL,
    [InvHeaderID]        INT           NOT NULL,
    CONSTRAINT [PK_tblClaimInfo] PRIMARY KEY CLUSTERED ([InvHeaderID] ASC)
);

