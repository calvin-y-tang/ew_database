-- **********************************************************************************************************
--
--   Description:
--        process Accounting Data table. Items that have been marked for deletion will be removed
--        from the tables.
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- clean up accounting tables for INVOICES
     DELETE
       FROM tblAcctDetail
      WHERE DocumentType='IN'
        AND DocumentNbr IN (SELECT ID FROM getID('Invoice'))

     DELETE
       FROM tblClaimInfo
      WHERE InvoiceNbr IN (SELECT ID FROM getID('Invoice'))

     DELETE
       FROM tblGPInvoice
      WHERE InvoiceNbr IN (SELECT ID FROM getID('Invoice'))

     DELETE
       FROM tblGPInvoiceEDIStatus
      WHERE InvoiceNbr IN (SELECT ID FROM getID('Invoice'))

     DELETE
       FROM tblAcctHeader
      WHERE DocumentType='IN'
        AND DocumentNbr IN (SELECT ID FROM getID('Invoice'))

     DELETE
       FROM tblInvoiceAttachments
      WHERE DocumentType='IN'
        AND DocumentNbr IN (SELECT ID FROM getID('Invoice'))

-- clean up accounting tables for VOUCHERS
     DELETE
       FROM tblAcctDetail
      WHERE DocumentType='VO'
        AND DocumentNbr IN (SELECT ID FROM getID('Voucher'))

     DELETE
       FROM tblGPVoucher
      WHERE VoucherNbr IN (SELECT ID FROM getID('Voucher'))

     DELETE
      FROM tblAcctHeader
     WHERE DocumentType='VO'
       AND DocumentNbr IN (SELECT ID FROM getID('Voucher'))
