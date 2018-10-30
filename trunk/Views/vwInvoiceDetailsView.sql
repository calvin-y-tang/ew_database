CREATE VIEW vwInvoiceDetailsView
AS
		select
			P.Description as Product,
			AD.Date,
			AD.Unit,
			AD.CPTCode,
			AD.LongDesc,
			AD.UnitAmount,
			AD.ExtendedAmount,
			AD.Taxable,
			AD.HeaderID
		from tblAcctDetail as AD
			  left outer join tblProduct as P on AD.ProdCode = P.ProdCode 
