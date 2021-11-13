CREATE VIEW vwPDFStaticData
AS
	SELECT	B.BlankValue AS CurrentDate ,
			--B.BlankValue AS CurrentTime ,
			--B.BlankValue AS CurrentDateTime ,

			'Yes' AS Checked ,
			'No' AS Unchecked ,

			'' AS Blank
	FROM	tblBlank AS B
