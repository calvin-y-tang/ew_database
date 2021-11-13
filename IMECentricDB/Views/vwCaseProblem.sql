CREATE VIEW vwCaseProblem
AS
	SELECT        dbo.tblCaseProblem.CaseNbr, dbo.tblCaseProblem.ProblemCode, 
	dbo.tblProblem.Description, ISNULL(dbo.tblProblemArea.Description, '') AS AreaDesc
	FROM            dbo.tblCaseProblem 
	INNER JOIN dbo.tblProblem ON dbo.tblCaseProblem.ProblemCode = dbo.tblProblem.ProblemCode 
	LEFT OUTER JOIN  dbo.tblProblemArea ON dbo.tblCaseProblem.ProblemAreaCode = dbo.tblProblemArea.ProblemAreaCode
