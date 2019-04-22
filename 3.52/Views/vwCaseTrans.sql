CREATE VIEW vwCaseTrans
AS
    SELECT  tblCaseTrans.CaseNbr ,
            tblCaseTrans.LineNbr ,
            tblCaseTrans.Type ,
            tblCaseTrans.Date ,
            tblCaseTrans.ProdCode ,
            tblCaseTrans.CPTCode ,
            tblCaseTrans.LongDesc ,
            tblCaseTrans.unit ,
            tblCaseTrans.unitAmount ,
            tblCaseTrans.extendedAmount ,
            tblCaseTrans.Taxable ,
            tblCaseTrans.DateAdded ,
            tblCaseTrans.UserIDAdded ,
            tblCaseTrans.DateEdited ,
            tblCaseTrans.UserIDEdited ,
            tblCaseTrans.DrOPCode ,
            tblCaseTrans.DrOPType ,
            tblCaseTrans.SeqNo ,
            tblCaseTrans.LineItemType ,
            tblCaseTrans.Location ,
            tblCaseTrans.UnitOfMeasureCode,
			tblCaseTrans.CreateInvoiceVoucher
    FROM    tblCaseTrans
    WHERE   HeaderID IS NULL
