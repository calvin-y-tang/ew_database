CREATE TABLE [dbo].[tblLogChangeTracking](
	[LogChangeTrackingID] [int] IDENTITY(1,1) NOT NULL,
	[HostName]		varchar(128) NULL,
	[HostIPAddr]	varchar(16) NULL,
	[AppName]		varchar(128) NULL,
	[TableName]		varchar(128) NULL,
	[ColumnName]	varchar(128) NULL,
	[TablePkID]		int NULL,
	[OldValue]		varchar(256) NULL,
	[NewValue]		varchar(256) NULL,
	[ModifeDate]	datetime NULL,
	[Msg]			VARCHAR(512) NULL, 
    CONSTRAINT [PK_tblLogChangeTracking] PRIMARY KEY CLUSTERED ([LogChangeTrackingID] ASC)
 );
