CREATE TABLE [dbo].[tblEWParentEmployer]
(
	[EWParentEmployerID] INT         IDENTITY (1, 1) NOT NULL , 
    [ParentEmployer]     VARCHAR(70) NOT NULL, 
	CONSTRAINT [PK_tblEWParentEmployer] PRIMARY KEY CLUSTERED ([EWParentEmployerID] ASC)
)

