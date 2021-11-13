CREATE PROCEDURE [dbo].[spCaseHistory]
    @iCaseNbr INT ,
    @sSort VARCHAR(10) ,
    @sIncludeExclude VARCHAR(1) ,
    @sTypes VARCHAR(120) ,
    @blnNoAccting INT
AS
    DECLARE @sSelectStmt NVARCHAR(2000) ,
        @sCaseNbr AS NVARCHAR(10) ,
        @WhereClause AS NVARCHAR(500) ,
        @NoAccting AS NVARCHAR(100)
    SET NOCOUNT ON
    SET @sCaseNbr = CAST(@iCaseNbr AS VARCHAR(10))

    IF @blnNoAccting = 1
        BEGIN
            SET @NoAccting = ' and (CH.type is null or CH.type <> ''Acct'')  '
        END
    ELSE
        BEGIN
            SET @NoAccting = ''
        END
    IF @sIncludeExclude = ''  -- select everything
        BEGIN
            SET @WhereClause = 'where CH.CaseNbr = '
                + @sCaseNbr 
        END
    IF @sIncludeExclude = 'A'  -- include all records for this case
        BEGIN
            SET @WhereClause = 'where CH.CaseNbr = '
                + @sCaseNbr 
        END

    IF @sIncludeExclude = 'I'  -- only include certain types
        BEGIN
            SET @WhereClause = 'where CH.CaseNbr = '
                + @sCaseNbr + ' and (CH.type in (' + @stypes
                + '))' 
        END
    IF @sIncludeExclude = 'E'  -- only exclude certain types
        BEGIN
            SET @WhereClause = 'where CH.CaseNbr = '
                + @sCaseNbr
                + ' and (CH.type is null or CH.type not in ('
                + @sTypes + '))' 
        END
    SET @sSelectStmt = 'SELECT TOP 100 PERCENT CH.CaseNbr, CH.EventDate, CH.EventDesc, CH.UserID, CH.Highlight, '
        + 'CH.otherinfo, CH.type, CH.status, '
        + 'CASE WHEN CH.type = ''StatChg'' THEN cast(isnull(CH.duration / 24, DATEDIFF(day, C.laststatuschg, '
        + 'GETDATE())) AS decimal(6, 1)) END AS IQ, CH.ID, C.LastStatusChg, CH.Duration, '
        + 'CH.PublishOnWeb, CH.PublishedTo, CH.UserIDEdited '
        + 'FROM tblCaseHistory AS CH INNER JOIN tblCase AS C ON CH.CaseNbr = C.CaseNbr '
        + @WhereClause + @NoAccting
        + ' ORDER BY CH.EventDate ' + @sSort 

--print @sselectstmt
    EXEC Sp_executesql @sSelectStmt


GO


