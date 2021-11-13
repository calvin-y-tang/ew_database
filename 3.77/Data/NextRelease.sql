INSERT INTO tblUserFunction
(
    FunctionCode,
    FunctionDesc,
    DateAdded
)
VALUES
(   'CustomATICExport',
    'Custom - ATIC Export',
    GETDATE()
    )

GO


-- Issue 11728 - New Quote number token and bookmark
INSERT INTO tblMessageToken (Name) VALUES ('@QuoteNbr@')

INSERT INTO tblMessageToken (Name) VALUES('@Jurisdiction@');
GO
