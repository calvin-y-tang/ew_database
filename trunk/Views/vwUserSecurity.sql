CREATE VIEW vwUserSecurity
AS
    SELECT  DISTINCT
            tblUserSecurity.UserID ,
            tblGroupFunction.FunctionCode
    FROM    tblUserSecurity
            INNER JOIN tblGroupFunction ON tblUserSecurity.GroupCode = tblGroupFunction.GroupCode
