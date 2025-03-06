PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [NewReferralStatusCode]  INT CONSTRAINT [DF_tblControl_NewReferralStatusCode] DEFAULT ((10)) NOT NULL,
        [EWTimeZoneID]           INT NULL,
        [MaintenanceAccessLevel] INT CONSTRAINT [DF_tblControl_MinMaintenanceAccessLevel] DEFAULT ((0)) NOT NULL,
        [SysTimerInterval]       INT CONSTRAINT [DF_tblControl_SysTimerInterval] DEFAULT ((0)) NOT NULL,
        [ExitWaitInterval]       INT CONSTRAINT [DF_tblControl_ExitWaitInterval] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Altering [dbo].[tblOffice]...';


GO
ALTER TABLE [dbo].[tblOffice]
    ADD [EWTimeZoneID] INT NULL;


GO
PRINT N'Altering [dbo].[tblUser]...';


GO
ALTER TABLE [dbo].[tblUser]
    ADD [MaintenanceAccessLevel] INT CONSTRAINT [DF_tblUser_MaintenanceAccessLevel] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Creating [dbo].[tblEWTimeZone]...';


GO
CREATE TABLE [dbo].[tblEWTimeZone] (
    [EWTimeZoneID]               INT           NOT NULL,
    [Name]                       VARCHAR (100) NOT NULL,
    [SupportsDaylightSavingTime] BIT           NOT NULL,
    [BaseUtcOffsetSec]           INT           NOT NULL,
    CONSTRAINT [PK_EWTimeZone] PRIMARY KEY CLUSTERED ([EWTimeZoneID] ASC)
);


GO
PRINT N'Creating [dbo].[tblEWTimeZone].[IX_U_EWTimeZone_Name]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_EWTimeZone_Name]
    ON [dbo].[tblEWTimeZone]([Name] ASC);


GO
PRINT N'Creating [dbo].[tblEWTimeZoneAdjustmentRule]...';


GO
CREATE TABLE [dbo].[tblEWTimeZoneAdjustmentRule] (
    [PrimaryKey]                             INT           NOT NULL,
    [EWTimeZoneID]                           INT           NOT NULL,
    [RuleNo]                                 INT           NOT NULL,
    [DateStart]                              DATETIME2 (7) NOT NULL,
    [DateEnd]                                DATETIME2 (7) NOT NULL,
    [DaylightTransitionStartIsFixedDateRule] BIT           NOT NULL,
    [DaylightTransitionStartMonth]           INT           NOT NULL,
    [DaylightTransitionStartDay]             INT           NOT NULL,
    [DaylightTransitionStartWeek]            INT           NOT NULL,
    [DaylightTransitionStartDayOfWeek]       INT           NOT NULL,
    [DaylightTransitionStartTimeOfDay]       TIME (7)      NOT NULL,
    [DaylightTransitionEndIsFixedDateRule]   BIT           NOT NULL,
    [DaylightTransitionEndMonth]             INT           NOT NULL,
    [DaylightTransitionEndDay]               INT           NOT NULL,
    [DaylightTransitionEndWeek]              INT           NOT NULL,
    [DaylightTransitionEndDayOfWeek]         INT           NOT NULL,
    [DaylightTransitionEndTimeOfDay]         TIME (7)      NOT NULL,
    [DaylightDeltaSec]                       INT           NOT NULL,
    CONSTRAINT [PK_EWTimeZoneAdjustmentRule] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
PRINT N'Creating [dbo].[tblEWTimeZoneAdjustmentRule].[IX_U_EWTimeZoneAdjustmentRule_EWTimeZoneID_DateStart_DateEnd]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_EWTimeZoneAdjustmentRule_EWTimeZoneID_DateStart_DateEnd]
    ON [dbo].[tblEWTimeZoneAdjustmentRule]([EWTimeZoneID] ASC, [DateStart] ASC, [DateEnd] ASC);


GO
PRINT N'Creating [dbo].[tblReferralAssignmentRule]...';


GO
CREATE TABLE [dbo].[tblReferralAssignmentRule] (
    [ReferralAssignmentRuleID] INT          IDENTITY (1, 1) NOT NULL,
    [ProcessOrder]             INT          NOT NULL,
    [Active]                   BIT          NOT NULL,
    [ToOfficeCode]             INT          NOT NULL,
    [CompanyName]              VARCHAR (50) NULL,
    [CompanyNameMatchType]     VARCHAR (1)  NULL,
    [CompanyCode]              INT          NULL,
    [CompanyState]             VARCHAR (2)  NULL,
    [ExamineeState]            VARCHAR (15) NULL,
    [CaseType]                 INT          NULL,
    [Jurisdiction]             VARCHAR (2)  NULL,
    CONSTRAINT [PK_tblReferralAssignmentRule] PRIMARY KEY CLUSTERED ([ReferralAssignmentRuleID] ASC)
);


GO
PRINT N'Creating [dbo].[DF_tblReferralAssignmentRule_Active]...';


GO
ALTER TABLE [dbo].[tblReferralAssignmentRule]
    ADD CONSTRAINT [DF_tblReferralAssignmentRule_Active] DEFAULT ((1)) FOR [Active];


GO
PRINT N'Creating [dbo].[fnGetLastWeekdayInMonth]...';


GO

CREATE FUNCTION dbo.[fnGetLastWeekdayInMonth]
(
    @DayOfWeek INT
    ,@ReferenceDate DATETIME2
)
RETURNS DATE
AS
BEGIN
	DECLARE
        @Result DATE = NULL
    ;

    -- support of .NET values
    IF @DayOfWeek = 0 BEGIN
        SET @DayOfWeek = 7;
    END;  

    DECLARE
        @FirstOfWeekday DATETIME2 = DATEADD(DAY, @DayOfWeek - 1, 0)
    ;  

    SELECT @Result =
        DATEADD(
            DAY
            ,DATEDIFF(
                DAY
                ,@FirstOfWeekday
                ,DATEADD(
                    MONTH
                    ,DATEDIFF(
                        MONTH
                        ,0
                        ,@ReferenceDate
                    )
                    ,DATEADD(
                        DAY
                        ,-1
                        ,DATEADD(
                            MONTH
                            ,1
                            ,0
                        )
                    )
                )
            ) / 7 * 7
            ,@FirstOfWeekday
        )
    ;

	RETURN @Result;

END
GO
PRINT N'Creating [dbo].[fnGetFirstWeekdayInMonth]...';


GO

CREATE FUNCTION [dbo].[fnGetFirstWeekdayInMonth]
(
    @DayOfWeek INT
    ,@ReferenceDate DATETIME2
)
RETURNS DATE
AS
BEGIN
	DECLARE
        @Result DATE = NULL
    ;  

    SELECT @Result =
        DATEADD(
            DAY
            ,7
            ,dbo.[fnGetLastWeekdayInMonth] (@DayOfWeek, DATEADD(MONTH, -1, @ReferenceDate))
        )
    ;

	RETURN @Result;

END
GO
PRINT N'Creating [dbo].[fnGetUTCOffset]...';


GO
CREATE FUNCTION [dbo].[fnGetUTCOffset]
(
    @EWTimeZoneID INT
    ,@UtcDate DATETIME2
)
RETURNS INT
AS
BEGIN
	DECLARE
        @Result INT = NULL
    ;

    SELECT @Result = 
       ([tz].[BaseUtcOffsetSec] + COALESCE([ar].[DaylightDeltaSec], 0))/60/60
    FROM
        dbo.tblEWTimeZone AS [tz] WITH (READUNCOMMITTED)
        LEFT JOIN dbo.tblEWTimeZoneAdjustmentRule AS [ar] WITH (READUNCOMMITTED)
            ON 1 = 1
            AND [ar].[EWTimeZoneID] = [tz].[EWTimeZoneID]
            AND CONVERT(DATE,
                    CASE
                        -- southern hemisphere
                        WHEN [ar].[DaylightTransitionStartMonth] > [ar].[DaylightTransitionEndMonth] THEN DATEADD(SECOND, [tz].[BaseUtcOffsetSec] + [ar].[DaylightDeltaSec], @UtcDate)
                        -- northern hemisphere
                        ELSE DATEADD(SECOND, [tz].[BaseUtcOffsetSec], @UtcDate)
                    END
                ) BETWEEN [ar].[DateStart] AND [ar].[DateEnd]
            AND ( 1 = 0
                OR ( 1 = 1
                    -- southern hemisphere
                    AND [ar].[DaylightTransitionStartMonth] > [ar].[DaylightTransitionEndMonth]
                    AND NOT ( 1 = 1
                        AND DATEADD(SECOND, [tz].[BaseUtcOffsetSec] + [ar].[DaylightDeltaSec], @UtcDate) >=
                            CASE
                                WHEN [ar].[DaylightTransitionEndIsFixedDateRule] = 1 THEN CONVERT(DATETIME2, RIGHT('0000' + CONVERT(NVARCHAR, YEAR(@UtcDate)), 4) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndMonth]), 2) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndDay]), 2) + ' ' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndTimeOfDay]), 121)
                                ELSE 
                                    CASE
                                        WHEN [ar].[DaylightTransitionEndWeek] = 5 THEN CONVERT(DATETIME2, CONVERT(NVARCHAR, dbo.[fnGetLastWeekdayInMonth] ([ar].[DaylightTransitionEndDayOfWeek], CONVERT(DATETIME2, RIGHT('0000' + CONVERT(NVARCHAR, YEAR(@UtcDate)), 4) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndMonth]), 2) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndDay]), 2), 121)), 121)  + ' ' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndTimeOfDay]), 121)
                                        ELSE CONVERT(DATETIME2, CONVERT(NVARCHAR, CONVERT(DATE, DATEADD(DAY, ([ar].[DaylightTransitionEndWeek] - 1) * 7, dbo.[fnGetFirstWeekdayInMonth] ([ar].[DaylightTransitionEndDayOfWeek], CONVERT(DATETIME2, RIGHT('0000' + CONVERT(NVARCHAR, YEAR(@UtcDate)), 4) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndMonth]), 2) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndDay]), 2), 121)))), 121)  + ' ' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndTimeOfDay]), 121)
                                    END
                            END
                        AND DATEADD(SECOND, [tz].[BaseUtcOffsetSec], @UtcDate) <=
                            CASE
                                WHEN [ar].[DaylightTransitionStartIsFixedDateRule] = 1 THEN CONVERT(DATETIME2, RIGHT('0000' + CONVERT(NVARCHAR, YEAR(@UtcDate)), 4) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartMonth]), 2) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartDay]), 2) + ' ' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartTimeOfDay]), 121)
                                ELSE 
                                    CASE
                                        WHEN [ar].[DaylightTransitionStartWeek] = 5 THEN CONVERT(DATETIME2, CONVERT(NVARCHAR, dbo.[fnGetLastWeekdayInMonth] ([ar].[DaylightTransitionStartDayOfWeek], CONVERT(DATETIME2, RIGHT('0000' + CONVERT(NVARCHAR, YEAR(@UtcDate)), 4) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartMonth]), 2) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartDay]), 2), 121)), 121)  + ' ' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartTimeOfDay]), 121)
                                        ELSE CONVERT(DATETIME2, CONVERT(NVARCHAR, CONVERT(DATE, DATEADD(DAY, ([ar].[DaylightTransitionStartWeek] - 1) * 7, dbo.[fnGetFirstWeekdayInMonth] ([ar].[DaylightTransitionStartDayOfWeek], CONVERT(DATETIME2, RIGHT('0000' + CONVERT(NVARCHAR, YEAR(@UtcDate)), 4) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartMonth]), 2) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartDay]), 2), 121)))), 121)  + ' ' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartTimeOfDay]), 121)
                                    END
                            END
                    )                          
                ) OR
                ( 1 = 1
                    -- northern hemisphere
                    AND [ar].[DaylightTransitionStartMonth] <= [ar].[DaylightTransitionEndMonth]
                    AND DATEADD(SECOND, [tz].[BaseUtcOffsetSec], @UtcDate) >=
                        CASE
                            WHEN [ar].[DaylightTransitionStartIsFixedDateRule] = 1 THEN CONVERT(DATETIME2, RIGHT('0000' + CONVERT(NVARCHAR, YEAR(@UtcDate)), 4) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartMonth]), 2) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartDay]), 2) + ' ' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartTimeOfDay]), 121)
                            ELSE 
                                CASE
                                    WHEN [ar].[DaylightTransitionStartWeek] = 5 THEN CONVERT(DATETIME2, CONVERT(NVARCHAR, dbo.[fnGetLastWeekdayInMonth] ([ar].[DaylightTransitionStartDayOfWeek], CONVERT(DATETIME2, RIGHT('0000' + CONVERT(NVARCHAR, YEAR(@UtcDate)), 4) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartMonth]), 2) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartDay]), 2), 121)), 121)  + ' ' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartTimeOfDay]), 121)
                                    ELSE CONVERT(DATETIME2, CONVERT(NVARCHAR, CONVERT(DATE, DATEADD(DAY, ([ar].[DaylightTransitionStartWeek] - 1) * 7, dbo.[fnGetFirstWeekdayInMonth] ([ar].[DaylightTransitionStartDayOfWeek], CONVERT(DATETIME2, RIGHT('0000' + CONVERT(NVARCHAR, YEAR(@UtcDate)), 4) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartMonth]), 2) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartDay]), 2), 121)))), 121)  + ' ' + CONVERT(NVARCHAR, [ar].[DaylightTransitionStartTimeOfDay]), 121)
                                END
                        END
                    AND DATEADD(SECOND, [tz].[BaseUtcOffsetSec] + [ar].[DaylightDeltaSec], @UtcDate) <=
                        CASE
                            WHEN [ar].[DaylightTransitionEndIsFixedDateRule] = 1 THEN CONVERT(DATETIME2, RIGHT('0000' + CONVERT(NVARCHAR, YEAR(@UtcDate)), 4) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndMonth]), 2) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndDay]), 2) + ' ' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndTimeOfDay]), 121)
                            ELSE 
                                CASE
                                    WHEN [ar].[DaylightTransitionEndWeek] = 5 THEN CONVERT(DATETIME2, CONVERT(NVARCHAR, dbo.[fnGetLastWeekdayInMonth] ([ar].[DaylightTransitionEndDayOfWeek], CONVERT(DATETIME2, RIGHT('0000' + CONVERT(NVARCHAR, YEAR(@UtcDate)), 4) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndMonth]), 2) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndDay]), 2), 121)), 121)  + ' ' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndTimeOfDay]), 121)
                                    ELSE CONVERT(DATETIME2, CONVERT(NVARCHAR, CONVERT(DATE, DATEADD(DAY, ([ar].[DaylightTransitionEndWeek] - 1) * 7, dbo.[fnGetFirstWeekdayInMonth] ([ar].[DaylightTransitionEndDayOfWeek], CONVERT(DATETIME2, RIGHT('0000' + CONVERT(NVARCHAR, YEAR(@UtcDate)), 4) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndMonth]), 2) + '-' + RIGHT('00' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndDay]), 2), 121)))), 121)  + ' ' + CONVERT(NVARCHAR, [ar].[DaylightTransitionEndTimeOfDay]), 121)
                                END
                        END
                )              
            )
    WHERE 1 = 1
        AND [tz].[EWTimeZoneID] = @EWTimeZoneID
    ;

	RETURN @Result;

END
GO
PRINT N'Altering [dbo].[proc_CaseHistory_LoadByWebUserIDAndLastLoginDate]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO

ALTER PROCEDURE [dbo].[proc_CaseHistory_LoadByWebUserIDAndLastLoginDate]

@WebUserID int = NULL,
@LastLoginDate datetime

AS

SELECT DISTINCT tblCaseHistory.*, claimnbr, tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename 
	FROM tblCaseHistory 
	INNER JOIN tblCase ON tblCaseHistory.casenbr = tblCase.Casenbr
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseHistory' 
	AND (tblPublishOnWeb.PublishOnWeb = 1)
	AND (tblPublishOnWeb.UserCode IN 
		(SELECT UserCode 
			FROM tblWebUserAccount 
			WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType)) 
	WHERE tblCaseHistory.EventDate > @LastLoginDate
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO



UPDATE tblControl SET DBVersion='2.82'
GO