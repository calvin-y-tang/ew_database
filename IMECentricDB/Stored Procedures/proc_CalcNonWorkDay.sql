

CREATE PROCEDURE proc_CalcNonWorkDay

@BeginDate datetime,
@EndDate datetime

AS

select nonworkday from tblnonworkdays where nonworkday >= @BeginDate and nonworkday <= @EndDate


