CREATE TABLE [dbo].[tblParamProperty]
(
	[ParamPropertyID]      INT          IDENTITY (1, 1) NOT NULL,
	[ParamPropertyGroupID] INT          NOT NULL, 
	[LabelText]            VARCHAR(30)  NOT NULL,
	[FieldName]            VARCHAR(30)  NOT NULL, 
	[Required]             BIT          CONSTRAINT [DF_tblParamProperty_Required] DEFAULT ((0)) NOT NULL, 
	[AllowedValues]        VARCHAR(200) NULL,
	[DateAdded]            DATETIME NOT NULL, 
    [UserIDAdded]          VARCHAR(15) NOT NULL, 
    CONSTRAINT [PK_tblParamProperty] PRIMARY KEY CLUSTERED ([ParamPropertyID] ASC)
)
