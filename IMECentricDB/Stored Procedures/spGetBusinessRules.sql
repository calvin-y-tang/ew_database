CREATE PROCEDURE dbo.spGetBusinessRules
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

	DECLARE @groupDigits INT

	SET @groupDigits = 10000000

	SELECT * FROM (
	SELECT BR.BusinessRuleID, BR.Category, BR.Name,
	 ROW_NUMBER() OVER (PARTITION BY BR.BusinessRuleID ORDER BY tmpBR.GroupID*@groupDigits+(CASE tmpBR.EntityType WHEN 'SW' THEN 4 WHEN 'PC' THEN 3 WHEN 'CO' THEN 2 WHEN 'CL' THEN 1 ELSE 9 END)*1000000+tmpBR.ProcessOrder) AS RowNbr,
	 tmpBR.BusinessRuleConditionID,
	 tmpBR.Param1,
	 tmpBR.Param2,
	 tmpBR.Param3,
	 tmpBR.Param4,
	 tmpBR.Param5,
	 tmpBR.EntityType,
	 tmpBR.ProcessOrder
	FROM
	(
	SELECT 1 AS GroupID, BRC.*
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
	WHERE BR.IsActive=1
	and BR.EventID=@eventID
	AND (tmpBR.OfficeCode IS NULL OR tmpBR.OfficeCode = @officeCode)
	AND (tmpBR.EWBusLineID IS NULL OR tmpBR.EWBusLineID = CT.EWBusLineID)
	AND (tmpBR.EWServiceTypeID IS NULL OR tmpBR.EWServiceTypeID = S.EWServiceTypeID)
	AND (tmpBR.Jurisdiction Is Null Or tmpBR.Jurisdiction = @jurisdiction)
	) AS sortedBR
	WHERE sortedBR.RowNbr=1
	ORDER BY sortedBR.BusinessRuleID
END