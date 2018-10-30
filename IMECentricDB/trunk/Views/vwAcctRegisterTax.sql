CREATE  VIEW vwAcctRegisterTax
AS
    SELECT  x.taxcode ,
            x.HeaderID ,
            x.DocumentNbr ,
            x.DocumentType ,
            SUM(taxamount) AS taxamount
    FROM    ( SELECT    HeaderID ,
                        DocumentNbr ,
                        DocumentType ,
                        TaxCode1 AS taxcode ,
                        SUM(TaxAmount1) AS taxamount
              FROM      tblAcctHeader
              GROUP BY  TaxCode1 ,
                        HeaderID ,
                        DocumentNbr ,
                        DocumentType
              UNION
              SELECT    HeaderID ,
                        DocumentNbr ,
                        DocumentType ,
                        TaxCode2 AS taxcode ,
                        SUM(TaxAmount2) AS taxamount
              FROM      tblAcctHeader
              GROUP BY  TaxCode2 ,
                        HeaderID ,
                        DocumentNbr ,
                        DocumentType
              UNION
              SELECT    HeaderID ,
                        DocumentNbr ,
                        DocumentType ,
                        TaxCode3 AS taxcode ,
                        SUM(TaxAmount3) AS taxamount
              FROM      tblAcctHeader
              GROUP BY  TaxCode3 ,
                        HeaderID ,
                        DocumentNbr ,
                        DocumentType
            ) AS x
    GROUP BY x.taxcode ,
            x.HeaderID ,
            x.DocumentNbr ,
            x.DocumentType
    HAVING  SUM(taxamount) <> 0
            AND x.taxcode <> ''

