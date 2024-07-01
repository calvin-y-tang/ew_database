CREATE VIEW vwCaseProblem
AS
	SELECT 
		tblCaseProblem.CaseNbr, 
		tblCaseProblem.ProblemCode, 
		tblProblem.Description, 
		ISNULL(tblProblemArea.Description, '') AS AreaDesc
	FROM tblCaseProblem 
		INNER JOIN vwtblProblem AS tblProblem ON tblCaseProblem.ProblemCode = tblProblem.ProblemCode 
		LEFT OUTER JOIN tblProblemArea ON tblCaseProblem.ProblemAreaCode = tblProblemArea.ProblemAreaCode
		
