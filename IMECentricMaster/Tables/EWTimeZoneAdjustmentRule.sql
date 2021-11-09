CREATE TABLE [dbo].[EWTimeZoneAdjustmentRule] (
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
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_EWTimeZoneAdjustmentRule_EWTimeZoneIDDateStartDateEnd]
    ON [dbo].[EWTimeZoneAdjustmentRule]([EWTimeZoneID] ASC, [DateStart] ASC, [DateEnd] ASC);

