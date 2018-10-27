

--Add a new transcription status Transcribing
SET IDENTITY_INSERT [dbo].[tblTranscriptionStatus] ON
INSERT INTO [dbo].[tblTranscriptionStatus] ([TranscriptionStatusCode], [Descrip]) VALUES (5, 'Transcribing')
SET IDENTITY_INSERT [dbo].[tblTranscriptionStatus] OFF
GO


--Add an BME custom to all databases
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[tblAddendumCodes]') AND OBJECTPROPERTY(id,N'IsTABLE') = 1)
CREATE TABLE [tblAddendumCodes] (
  [fldACPK] INTEGER IDENTITY(100,1) NOT NULL,
  [fldACDescription] VARCHAR(50) NOT NULL,
  [fldACResponsibility] VARCHAR(50) NOT NULL,
  CONSTRAINT [PK_tblAddendumCodes] PRIMARY KEY NONCLUSTERED ([fldACPK])
)
GO


--Add a new field to store the date time each time the transcription job status is changed
ALTER TABLE [tblTranscriptionJob]
  ADD [LastStatusChg] DATETIME
GO



--New fields and functions to calculate TAT - Turn Around Time
ALTER TABLE [tblIMEData]
  ADD [WorkHourStart] INTEGER
GO

ALTER TABLE [tblIMEData]
  ADD [WorkHourEnd] INTEGER
GO

UPDATE tblIMEData SET WorkHourStart=8, WorkHourEnd=20
GO


--Return the Date value of a date time field
CREATE FUNCTION fnDateValue
(
  @Date datetime
)
RETURNS DATETIME
BEGIN

DECLARE @dateValue DATETIME
 SELECT @dateValue = DATEADD(dd, 0, DATEDIFF(dd, 0, @Date))
 RETURN @dateValue
END

GO


--Determin if a given day is a work day.  Currently it only checks if the day is a weekday, not taking holiday into consideration
CREATE FUNCTION fnIsWorkDay
(
  @Date DATETIME
)
RETURNS BIT
BEGIN

DECLARE @isWorkDay BIT

SELECT
  @isWorkDay =
  CASE (DATEPART(dw, @Date) + @@DATEFIRST) % 7
    WHEN 1 THEN 0 --'Sunday'
    WHEN 2 THEN 1 --'Monday'
    WHEN 3 THEN 1 --'Tuesday'
    WHEN 4 THEN 1 --'Wednesday'
    WHEN 5 THEN 1 --'Thursday'
    WHEN 6 THEN 1 --'Friday'
    WHEN 0 THEN 0 --'Saturday'
  END

RETURN @isWorkDay

END

GO



--Format TAT into formatted string
CREATE FUNCTION fnGetTATString 
(
 @tat INT
)
RETURNS VARCHAR(20)
AS
BEGIN

--Declare and initialize variables
DECLARE @days INT
DECLARE @hours INT
DECLARE @mins INT
DECLARE @workHourPerDay INT
 
 SELECT TOP 1 @workHourPerDay = WorkHourEnd-WorkHourStart FROM tblIMEData ORDER BY IMECode
            
    SELECT @hours = FLOOR(@tat / 60)
    SELECT @mins = @tat % 60
    SELECT @days = FLOOR(@hours / @workHourPerDay)
    SELECT @hours = @hours % @workHourPerDay
            
    --Only return non zero values
    DECLARE @result VARCHAR(20)
    SELECT @result = ''
    If @days > 0
  SELECT @result = CAST(@days AS VARCHAR) + 'd '
    If @hours > 0
  SELECT @result = @result + CAST(@hours AS VARCHAR) + 'h '
    If @mins > 0
  SELECT @result = @result + CAST(@mins AS VARCHAR) + 'm '
    SELECT @result = RTRIM(@result)
    --If all zero, use "< 1m" rather than empty string
    If @result = ''
  SELECT @result = '< 1m'
    RETURN @result
END

GO


--Calculate TAT Elapsed Time in Minutes
CREATE FUNCTION fnGetTATMins
(
 @startDate DATETIME,
 @endDate DATETIME
)
RETURNS INT
AS
BEGIN

--Declare and initialize variables
DECLARE @minStart INT
DECLARE @minEnd INT
DECLARE @days INT


SELECT @minStart = 0
SELECT @minEnd = 0
SELECT @days = 0

--Load system settings
DECLARE @workHourStart INT
DECLARE @workHourEnd INT
SELECT TOP 1 @workHourStart = tblIMEData.WorkHourStart, @workHourEnd=tblIMEData.WorkHourEnd FROM dbo.tblIMEData ORDER BY tblIMEData.IMECode

--Temp variables used for calculation
DECLARE @hourStart DATETIME
DECLARE @hourEnd DATETIME
DECLARE @tmpDateTime DATETIME

 --Get the working minutes on the start day
 IF dbo.fnIsWorkDay(@startDate) = 1
  BEGIN
   --If the start time of the start date is before working hours start, use working hours start instead
   SELECT @tmpDateTime = DATEADD(hh, @workHourStart, dbo.fnDateValue(@startDate))
   IF @startDate > @tmpDateTime
    SELECT @hourStart = @startDate
   ELSE
    SELECT @hourStart = @tmpDateTime
   
   --if the end date is actually the same date as start AND before the working hours end, then use the end date time,
   --otherwise use the working hours end of the start date portion
   SELECT @tmpDateTime = DATEADD(hh, @workHourEnd, dbo.fnDateValue(@startDate))
   IF @endDate < @tmpDateTime
    SELECT @hourEnd = @endDate
   ELSE
    SELECT @hourEnd = @tmpDateTime

   --in case start and end time are both before working hours start OR both after working hours end
   --hours start can be after hour end, then just ignore and return 0 for minStart
   IF @hourStart < @hourEnd
    SELECT @minStart = DATEDIFF(n, @hourStart, @hourEnd)
  END

    --Only if start and end date are no the same day
    DECLARE @dateToCheck DATETIME
    SELECT @dateToCheck = DateAdd(d, 1, @startDate)
    --loop thru each day in between and see which one is working day
    While @dateToCheck < dbo.fnDateValue(@endDate)
 BEGIN
  If dbo.fnIsWorkDay(@dateToCheck) = 1
   SELECT @days = @days + 1
  SELECT @dateToCheck = DateAdd(d, 1, @dateToCheck)
 END

    --If end date is a working day and is not the same as start date, calculate the working minutes
    If dbo.fnIsWorkDay(@endDate) = 1 And (dbo.fnDateValue(@startDate) < dbo.fnDateValue(@endDate))
    BEGIN
        --Similar logic as minStart, calculate minEnd for end date
        SELECT @tmpDateTime = DateAdd(hh, @workHourStart, dbo.fnDateValue(@endDate))
        If @startDate > @tmpDateTime
            SELECT @hourStart = @startDate
        Else
            SELECT @hourStart = @tmpDateTime

        SELECT @tmpDateTime = DateAdd(hh, @workHourEnd, dbo.fnDateValue(@endDate))
        If @endDate < @tmpDateTime
            SELECT @hourEnd = @endDate
        Else
            SELECT @hourEnd = @tmpDateTime
        If @hourStart < @hourEnd
   SELECT @minEnd = DateDiff(n, @hourStart, @hourEnd)
    END
    
    --Return the total working time in minutes
 RETURN @minStart + (@days * (@workHourEnd - @workHourStart) * 60) + @minEnd
END

GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_TranscriptionJob_Update];
GO

CREATE PROCEDURE [proc_TranscriptionJob_Update]
(
	@TranscriptionJobID int,
	@TranscriptionStatusCode int,
	@DateAdded datetime = NULL,
	@DateEdited datetime = NULL,
	@UserIDEdited varchar(20) = NULL,
	@DictationFile varchar(100) = NULL,
	@CaseNbr int,
	@ReportTemplate varchar(15) = NULL,
	@CoverLetterFile varchar(100) = NULL,
	@TransCode int = NULL, 
	@DateAssigned datetime = NULL,
	@ReportFile varchar(100) = NULL,
	@DateRptReceived datetime = NULL,
	@DateCompleted datetime = NULL,
	@LastStatusChg datetime = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblTranscriptionJob]
	SET

	[TranscriptionStatusCode] = @TranscriptionStatusCode,
	[DateAdded] = @DateAdded,
	[DateEdited] = @DateEdited,
	[UserIDEdited] = @UserIDEdited,
	[DictationFile] = @DictationFile,
	[CaseNbr] = @CaseNbr,
	[ReportTemplate] = @ReportTemplate,
	[CoverLetterFile] = @CoverLetterFile,
	[TransCode] = @TransCode,
	[DateAssigned] = @DateAssigned,
	[ReportFile] = @ReportFile,
	[DateRptReceived] = @DateRptReceived,
	[DateCompleted] = @DateCompleted,
	[LastStatusChg] = @LastStatusChg

	WHERE
		[TranscriptionJobID] = @TranscriptionJobID


	SET @Err = @@Error


	RETURN @Err
END
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_TranscriptionJob_Insert];
GO

CREATE PROCEDURE [proc_TranscriptionJob_Insert]
(
	@TranscriptionJobID int = NULL output,
	@TranscriptionStatusCode int,
	@DateAdded datetime = NULL,
	@DateEdited datetime = NULL,
	@UserIDEdited varchar(20) = NULL,
	@DictationFile varchar(100) = NULL,
	@CaseNbr int,
	@ReportTemplate varchar(15) = NULL,
	@CoverLetterFile varchar(100) = NULL,
	@TransCode int = NULL, 
	@DateAssigned datetime = NULL,
	@ReportFile varchar(100) = NULL,
	@DateRptReceived datetime = NULL,
	@DateCompleted datetime = NULL,
	@LastStatusChg datetime = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblTranscriptionJob]
	(
		[TranscriptionStatusCode],
		[DateAdded],
		[DateEdited],
		[UserIDEdited],
		[DictationFile],
		[CaseNbr],
		[ReportTemplate],
		[CoverLetterFile],
		[TransCode],
		[DateAssigned],
		[ReportFile],
		[DateRptReceived],
		[DateCompleted],
		[LastStatusChg]
	)
	VALUES
	(
		@TranscriptionStatusCode,
		@DateAdded,
		@DateEdited,
		@UserIDEdited,
		@DictationFile,
		@CaseNbr,
		@ReportTemplate,
		@CoverLetterFile,
		@TransCode, 
		@DateAssigned,
		@ReportFile,
		@DateRptReceived,
		@DateCompleted,
		@LastStatusChg
	)

	SET @Err = @@Error

	SELECT @TranscriptionJobID = SCOPE_IDENTITY()

	RETURN @Err
END
GO



UPDATE tblControl SET DBVersion='1.73'
GO
