CREATE FUNCTION dbo.GetZipDistanceMiles
    (
      @zip0 VARCHAR(7) ,
      @zip1 VARCHAR(7)
    )
RETURNS FLOAT
AS 
    BEGIN

        DECLARE @lat0 FLOAT
        DECLARE @lon0 FLOAT
        DECLARE @lat1 FLOAT
        DECLARE @lon1 FLOAT
        DECLARE @lonDiff FLOAT
        DECLARE @x FLOAT
        DECLARE @radDist FLOAT
        DECLARE @distance FLOAT

        SET @lat0 = 0
        SET @lon0 = 0
        SELECT  @lat0 = fLatitude ,
                @lon0 = fLongitude
        FROM    tblZipCode
        WHERE   sZip = @zip0

        SET @lat1 = 0
        SET @lon1 = 0
        SELECT  @lat1 = fLatitude ,
                @lon1 = fLongitude
        FROM    tblZipCode
        WHERE   sZip = @zip1

        IF ( @lat0 = 0
             OR @lat1 = 0
             OR @lon0 = 0
             OR @lon1 = 0
           ) 
            BEGIN
                RETURN NULL
            END

        IF ( @lat0 = @lat1
             AND @lon0 = @lon1
           ) 
            BEGIN
                RETURN 0
            END
	
        SET @lat0 = @lat0 * PI() / 180
        SET @lon0 = @lon0 * PI() / 180
        SET @lat1 = @lat1 * PI() / 180
        SET @lon1 = @lon1 * PI() / 180
        SET @lonDiff = ABS(@lon0 - @lon1)
        SET @x = SIN(@lat0) * SIN(@lat1) + COS(@lat0) * COS(@lat1)
            * COS(@lonDiff)
        SET @radDist = ATAN(-@x / SQRT(-@x * @x + 1)) + 2 * ATAN(1)
        SET @distance = @radDist * 3958.754 /* miles */

        RETURN @distance
    END
GO

--New tables and fields for Fax Project
ALTER TABLE tblDocument ADD
	FaxCoverDemographics INT NULL,
	FaxCoverID INT NULL
GO

CREATE TABLE tblFaxCover
    (
      FaxCoverID INT NOT NULL IDENTITY(1, 1) ,
      Description VARCHAR(50) NULL ,
      XMediusBodyCode VARCHAR(20) NULL
    )
GO
ALTER TABLE tblFaxCover ADD CONSTRAINT PK_tblFaxCover PRIMARY KEY CLUSTERED  (FaxCoverID)
GO

CREATE TABLE tblMessageToken
    (
      MessageTokenID INT NOT NULL IDENTITY(1, 1) ,
      Name VARCHAR(30) NULL ,
      Description VARCHAR(50) NULL
    )
GO
ALTER TABLE tblMessageToken ADD CONSTRAINT PK_tblMessage PRIMARY KEY CLUSTERED  (MessageTokenID)
GO


UPDATE tblControl SET DBVersion='2.08'
GO
