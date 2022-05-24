CREATE PROCEDURE dbo.spGetAllBusinessRules
(
    @eventID INT,
    @clientCode INT,
    @billClientCode INT,
    @officeCode INT,
    @caseType INT,
    @serviceCode INT,
    @jurisdiction VARCHAR(5)
)
AS
BEGIN

	SET NOCOUNT ON

	SELECT DISTINCT *, ROW_NUMBER() OVER (PARTITION BY BusinessRuleID ORDER BY BusinessRuleID, ProcessOrder ASC ) AS RuleOrder 
	INTO #tmp_GetAllBusinessRules
	FROM (
			SELECT BR.BusinessRuleID, BR.Category, BR.Name,	 
			 tmpBR.BusinessRuleConditionID,
			 tmpBR.Param1,
			 tmpBR.Param2,
			 tmpBR.Param3,
			 tmpBR.Param4,
			 tmpBR.Param5,
			 tmpBR.EntityType,
			 tmpBR.ProcessOrder,
			 tmpBR.Skip, 
			 tmpBR.Param6
			FROM
				 (SELECT 1 AS GroupID, BRC.*
					FROM tblBusinessRuleCondition AS BRC
						LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @billClientCode
						LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
					WHERE 1=1
						AND (BRC.BillingEntity IN (0,2))
						AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

					UNION

					SELECT 2 AS GroupID, BRC.*
					FROM tblBusinessRuleCondition AS BRC
						LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @clientCode
						LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
					WHERE 1=1
						AND (BRC.BillingEntity IN (1,2))
						AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

					UNION

					SELECT 3 AS GroupID, BRC.*
					FROM tblBusinessRuleCondition AS BRC
					WHERE 1=1
						AND (BRC.EntityType='SW')
				) AS tmpBR
						INNER JOIN tblBusinessRule AS BR ON BR.BusinessRuleID = tmpBR.BusinessRuleID
						LEFT OUTER JOIN tblCaseType AS CT ON CT.Code = @caseType
						LEFT OUTER JOIN tblServices AS S ON S.ServiceCode = @serviceCode
			WHERE BR.IsActive = 1
				and BR.EventID = @eventID
				AND (tmpBR.OfficeCode IS NULL OR tmpBR.OfficeCode = @officeCode)
				AND (tmpBR.EWBusLineID IS NULL OR tmpBR.EWBusLineID = CT.EWBusLineID)
				AND (tmpBR.EWServiceTypeID IS NULL OR tmpBR.EWServiceTypeID = S.EWServiceTypeID)
				AND (tmpBR.Jurisdiction Is Null Or tmpBR.Jurisdiction = @jurisdiction)
	) AS sortedBR	
	ORDER BY sortedBR.BusinessRuleID, sortedBR.ProcessOrder

	-- need to remove duplicate rules (same BusinessRuleConditionID)
	DELETE bizRules 
      FROM (SELECT BusinessRuleConditionID, 
               ROW_NUMBER() OVER (PARTITION BY BusinessRuleConditionID ORDER BY RuleOrder ASC) AS ROWNUM
              FROM #tmp_GetAllBusinessRules) AS bizRules
	 WHERE bizRules.RowNum > 1

    -- remove rules that have a condition that is set to skip
	DELETE 
      FROM #tmp_GetAllBusinessRules
      WHERE BusinessRuleID IN (SELECT BusinessRuleID
                                 FROM #tmp_GetAllBusinessRules
                                WHERE skip = 1)

	-- do not return rules that are set to be "skipped"
	SELECT BusinessRuleID, 
		   Category, 
		   Name,	 
		   BusinessRuleConditionID,
		   Param1,
		   Param2,
		   Param3,
		   Param4,
		   Param5,
		   EntityType,
		   ProcessOrder,
		   Skip, 
		   Param6 
	FROM #tmp_GetAllBusinessRules
	WHERE Skip = 0

END
