CREATE TABLE [dbo].[ESReferralDetail] (
    [ESReferralDetailID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ESReferralHdrID]    INT           NOT NULL,
    [ReferralID]         VARCHAR (256) NULL,
    [ClaimNumber]        VARCHAR (32)  NULL,
    [ExamineeFirstName]  VARCHAR (64)  NULL,
    [ExamineeLastName]   VARCHAR (64)  NULL,
    [AdjustorFirstName]  VARCHAR (64)  NULL,
    [AdjustorLastName]   VARCHAR (64)  NULL,
    [Office]             VARCHAR (30)  NULL,
    [Reason]             INT           NOT NULL,
    [Phone1]             VARCHAR (15)  NULL,
    [Phone2]             VARCHAR (15)  NULL,
    [Notes]              VARCHAR (MAX) NULL,
    CONSTRAINT [PK_ESReferralDetail] PRIMARY KEY CLUSTERED ([ESReferralDetailID] ASC),
    CONSTRAINT [FK_ESReferralDetail_ESReferralHdr] FOREIGN KEY ([ESReferralHdrID]) REFERENCES [dbo].[ESReferralHdr] ([ESReferralHdrID])
);

