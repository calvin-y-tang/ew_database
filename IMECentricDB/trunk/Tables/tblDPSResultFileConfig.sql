CREATE TABLE [dbo].[tblDPSResultFileConfig]
(
    [ResultFileConfigID]   INT         IDENTITY (1, 1) NOT NULL, 
    [EWServiceTypeID]      INT         NOT NULL, 
    [FileIndex]            INT         NOT NULL, 
    [Description]          VARCHAR(50) NOT NULL, 
    [CombinedFileName]     VARCHAR(50) NOT NULL, 
    [CombineFileSeqNo]     INT         NOT NULL,
	CONSTRAINT [PK_tblDPSResultFileConfig] PRIMARY KEY CLUSTERED ([ResultFileConfigID] ASC)
)
