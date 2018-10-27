CREATE TABLE tblGPInvoiceEDIStatus (
  PrimaryKey INTEGER IDENTITY(1,1) NOT NULL,
  ExportDate DATETIME,
  InvoiceNbr INTEGER NOT NULL,
  EDIStatus VARCHAR(15),
  EDINote VARCHAR(250),
  ClientContractNbr INT NULL,
  ClientName VARCHAR(100) NULL
  CONSTRAINT PK_tblGPInvoiceEDIStatus PRIMARY KEY CLUSTERED (PrimaryKey)
)
GO

UPDATE tblControl SET DBVersion='2.54'
GO
