CREATE TABLE [dbo].[tblFacilityOffice] (
    [FacilityID]	INT          NOT NULL,
    [OfficeCode]	INT          NOT NULL,
    [DateAdded]		DATETIME     NULL,
    [UserIDAdded]	VARCHAR (15) NULL,
    CONSTRAINT [PK_tblFacilityOffice] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [OfficeCode] ASC)
);

