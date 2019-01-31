CREATE TABLE [dbo].[tblDoctorSearchResult] (
    [PrimaryKey]     INT            IDENTITY (1, 1) NOT NULL,
    [SessionID]      VARCHAR (50)   NOT NULL,
    [DateAdded]      DATETIME       CONSTRAINT [DF_tblDoctorSearchResult_DateAdded] DEFAULT (getdate()) NOT NULL,
    [DoctorCode]     INT            NOT NULL,
    [LocationCode]   INT            NOT NULL,
    [SchedCode]      INT            NULL,
    [Selected]       BIT            CONSTRAINT [DF_tblDoctorSearchResult_Selected] DEFAULT ((0)) NOT NULL,
    [Proximity]      FLOAT (53)     NULL,
    [SpecialtyCodes] VARCHAR (300)  NULL,
    [AvgMargin]      DECIMAL (8, 2) CONSTRAINT [DF_tblDoctorSearchResult_AvgMargin] DEFAULT ((0)) NOT NULL,
    [CaseCount]      INT            CONSTRAINT [DF_tblDoctorSearchResult_CaseCount] DEFAULT ((0)) NOT NULL,
	[DisplayScore]   Numeric(35,13) NULL,
	[DoctorRank]     bigint         Null,
    CONSTRAINT [PK_tblDoctorSearchResult] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);








GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSearchResult_SessionIDDoctorCodeLocationCode]
    ON [dbo].[tblDoctorSearchResult]([SessionID] ASC, [DoctorCode] ASC, [LocationCode] ASC);

