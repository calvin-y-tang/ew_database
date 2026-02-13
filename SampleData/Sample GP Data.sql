SET IDENTITY_INSERT IBIS_CheckRegisterExport ON
INSERT INTO IBIS_CheckRegisterExport
(
	RowID,
    CMRECNUM,
    FormatVersion,
    ExportDate,
    BatchNo,
    GPFacilityID,
    PaymentNo,
    CheckNo,
    CheckDate,
    CheckBookID,
    CheckAmount,
    MonetaryUnit,
    CheckReqNo,
    GPVendorID,
    Void,
    VoidDate,
    ProcessedFlag
)
SELECT TOP 1000
*
FROM [GPSQLSERVER5\GP].EW.dbo.ibis_checkRegisterExport
WHERE BatchNo<>0
ORDER BY ROWID DESC
SET IDENTITY_INSERT IBIS_CheckRegisterExport OFF
GO



SET IDENTITY_INSERT IBIS_PayablesExport ON
INSERT INTO IBIS_PayablesExport
(
	RowID,
    FormatVersion,
    ExportDate,
    BatchNo,
    GPFacilityID,
    PaymentNo,
    DocumentType,
    CheckNo,
    AppliedDate,
    AppliedAmount,
    MonetaryUnit,
    GPVendorID,
    VoucherNo,
    VoucherType,
    CaseNo,
    ProcessedFlag
)
SELECT TOP 1000
*
FROM [GPSQLSERVER5\GP].EW.dbo.IBIS_PayablesExport
WHERE BatchNo<>0
ORDER BY ROWID DESC
SET IDENTITY_INSERT IBIS_PayablesExport OFF
GO




SET IDENTITY_INSERT IBIS_ReceivingsExport ON
INSERT INTO IBIS_ReceivingsExport
(
	RowID,
    FormatVersion,
    ExportDate,
    GPFacilityID,
    BatchNo,
    PaymentNo,
    DocumentType,
    AppliedDate,
    AppliedAmount,
    MonetaryUnit,
    GPCompanyID,
    InvoiceNo,
    APTODCTY,
    CaseNo,
    CheckNo,
    ProcessedFlag,
    ApyToSource,
    Action,
    CreatedDate,
    FromIBISproc,
    ClientRefNo,
    IsPartial,
    DATE1,
    DISTKNAM,
    WROFAMNT
)
SELECT TOP 1000
*
FROM [GPSQLSERVER5\GP].EW.dbo.IBIS_ReceivingsExport
WHERE BatchNo<>0
ORDER BY ROWID DESC
SET IDENTITY_INSERT IBIS_ReceivingsExport OFF
GO
