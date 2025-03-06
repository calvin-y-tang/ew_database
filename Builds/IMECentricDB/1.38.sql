
----------------------------------------------------
--Add new tblEWFlashCategory
----------------------------------------------------

IF not EXISTS ( SELECT  *
            FROM    dbo.sysobjects
            WHERE   id = OBJECT_ID(N'[dbo].[tblEWFlashCategory]')
                    AND OBJECTPROPERTY(id, N'IsTable') = 1 ) 


CREATE TABLE [tblEWFlashCategory]
(
[EWFlashCategoryID] [int] NOT NULL,
[Category] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Descrip] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL,
CONSTRAINT [PK_EWFlashCategory] PRIMARY KEY CLUSTERED  ([EWFlashCategoryID])
)

GO

----------------------------------------------------
--Add new mapping field for tblEWFlashCategory
----------------------------------------------------

IF NOT EXISTS ( SELECT  *
                FROM    syscolumns
                WHERE   id = OBJECT_ID('tblFRCategory')
                        AND name = 'EWFlashCategoryID' ) 
    ALTER TABLE [tblFRCategory]
    ADD [EWFlashCategoryID] INT
GO

----------------------------------------------------
--Add an option to use PDF Reader to print for PDF documents
----------------------------------------------------

ALTER TABLE [tblDocument]
  ADD [UsePDFReaderToPrint] BIT
GO

update tblControl set DBVersion='1.38'
GO