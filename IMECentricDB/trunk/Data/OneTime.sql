-- Issue 11744 - date patch for ProductOffice
INSERT INTO tblProductOffice (ProdCode, OfficeCode, DateAdded, UserIDAdded)
     SELECT DISTINCT ServDefProd.ProdCode AS DefaultBillingProdCode, POMatchDesc.OfficeCode AS MissingPOOffice, GETDATE(), 'System'
     FROM tblServices AS S
          LEFT OUTER JOIN tblProduct AS MatchProdDesc ON S.Description = MatchProdDesc.Description
          INNER JOIN tblProductOffice AS POMatchDesc ON MatchProdDesc.ProdCode = POMatchDesc.ProdCode
          LEFT OUTER JOIN tblProduct AS ServDefProd ON S.ProdCode = ServDefProd.ProdCode
          LEFT OUTER JOIN tblProductOffice AS PODefProd ON ServDefProd.ProdCode = PODefProd.ProdCode AND PODefProd.OfficeCode = POMatchDesc.OfficeCode
     WHERE (PODefProd.OfficeCode IS NULL)
GO
