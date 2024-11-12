create table [dbo].[tblFeeScheduleTiers]
(
    [TierID] bigint not null identity (1, 1),
    [Tier] varchar (128) not null,
    [DoctorCode] int not null,
    [ParentCompanyID] int null,
	[EWBusLineID] [int] NULL,
    [DateAdded] datetime constraint [DF_Tier_DateAdded] DEFAULT (getdate()) NULL,
    [UserIDAdded] varchar (64) null,
    constraint [PK_tblFeeScheduleTiers] primary key ([TierID])
);
