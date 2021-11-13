CREATE       PROCEDURE [dbo].[spInsertActionTableRecords]
	@UserName varchar (50),
	@CaseNbr int,
	@Param1 varchar(255),
	@Param2 varchar(255),
	@Param5 varchar(255),
	@Command varchar(15),
	@Status int
AS
DECLARE @strCaseGUID varchar(255)
DECLARE @strUserGUID varchar(255)
DECLARE @CaseGUID uniqueidentifier 
DECLARE @UserGUID uniqueidentifier
DECLARE @QueueGUID uniqueidentifier
DECLARE @Action_LocalID int
DECLARE @Action_LocalIDType int


-------------------------------------------------------------------
SELECT @CaseGuid = WebGUID FROM tblCase WHERE casenbr= @casenbr
--print '@caseGUID after select from tblcase = ' + cast(@caseguid as varchar(50))
--print '@caseNbr = ' + cast(@casenbr as varchar(10))
if @CaseGuid is null
begin
	print '@caseguid is null'
	set @strCaseGuid = ''
	set @Action_LocalID = @casenbr
	set @Action_LocalIDType = 0
--print '@Action_LocalID = ' + cast(@Action_LocalID as varchar(10))
end
else

--print '@caseGUID after select from tblcase = ' + cast(@caseGUID as varchar(50))
--------------------------------
SELECT @UserGUID = WebGUID from tblUser WHERE userid= @UserName
---------------------------------
if @Userguid is null
begin
	print '@Userguid is null'
end
else
begin
	set @strUserGuid = cast(@UserGUID as varchar(255))
end
--print '@UserGUID after select from tbluser = ' + cast(@UserGUID as varchar(50))

if @Command = 'ASSESS_BOOK' or @Command = 'ASSESS_CONDUCT' or @Command = 'ASSESS_NO_SHOW'
BEGIN


	if @CaseGuid is null 
	    Begin
		SET @Param1 = ''
	    end
	else
	    Begin
		SET @Param1 = cast(@CaseGUID as varchar (255))
	    end
	
	SELECT @param2 = CONVERT( VARCHAR(20), apptdate, 101 ) FROM tblCase WHERE casenbr = @casenbr
print 'param2 = ' + @param2


  INSERT INTO tblActions (
	action_UserGUID,
	action_command,
	action_param1,
	action_param2,
	action_param5,
	Action_LocalID, 
	Action_LocalIDType) VALUES (

    	@UserGUID,
     	@Command,
     	@Param1,
     	@Param2,
     	@Param5,
     	@Action_LocalID,
     	@Action_LocalIDType
   )

PRINT @COMMAND
END

if @Command = 'ROLLBACK'
BEGIN


	if @CaseGuid is null 
	    Begin
		SET @Param1 = ''
	    end
	else
	    Begin
		SET @Param1 = cast(@CaseGUID as varchar (255))
	    end
	
	SELECT @QueueGuid = WebGUID FROM tblQueues WHERE statuscode = @status
	set @Param2 = cast(@QueueGUID as varchar(255))


  INSERT INTO tblActions (
	action_UserGUID,
	action_command,
	action_param1,
	action_param2,
	action_param5,
	Action_LocalID, 
	Action_LocalIDType) VALUES (

    	@UserGUID,
     	@Command,
     	@Param1,
     	@Param2,
     	@Param5,
     	@Action_LocalID,
     	@Action_LocalIDType
   )

PRINT @COMMAND
END


if @Command = 'COMPLETE'
BEGIN

	if @CaseGuid is null 
	    Begin
		SET @Param1 = ''
	    end
	else
	    Begin
		SET @Param1 = cast(@CaseGUID as varchar (255))
	    end
	


  INSERT INTO tblActions (
	action_UserGUID,
	action_command,
	action_param1,
	action_param2,
	action_param5,
	Action_LocalID, 
	Action_LocalIDType) VALUES (

    	@UserGUID,
     	@Command,
     	@Param1,
     	@Param2,
     	@Param5,
     	@Action_LocalID,
     	@Action_LocalIDType
   )

PRINT @COMMAND
END

if @Command = 'REPORT_UPLOAD'
BEGIN

	if @CaseGuid is null 
	    Begin
		SET @Param1 = ''
	    end
	else
	    Begin
		SET @Param1 = cast(@CaseGUID as varchar (255))
	    end
	


  INSERT INTO tblActions (
	action_UserGUID,
	action_command,
	action_param1,
	action_param2,
	action_param5,
	Action_LocalID, 
	Action_LocalIDType) VALUES (

    	@UserGUID,
     	@Command,
     	@Param1,
     	@Param2,
     	@Param5,
     	@Action_LocalID,
     	@Action_LocalIDType
   )

PRINT @COMMAND
END

if @Command = 'VOID'
BEGIN

	if @CaseGuid is null 
	    Begin
		SET @Param1 = ''
	    end
	else
	    Begin
		SET @Param1 = cast(@CaseGUID as varchar (255))
	    end
	


  INSERT INTO tblActions (
	action_UserGUID,
	action_command,
	action_param1,
	action_param2,
	action_param5,
	Action_LocalID, 
	Action_LocalIDType) VALUES (

    	@UserGUID,
     	@Command,
     	@Param1,
     	@Param2,
     	@Param5,
     	@Action_LocalID,
     	@Action_LocalIDType
   )

PRINT 'VOID'
END
if @Command = 'SEND_EMAIL'
BEGIN

	if @CaseGuid is null 
	    Begin
		SET @Param1 = ''
	    end
	else
	    Begin
		SET @Param1 = cast(@CaseGUID as varchar (255))
	    end
	

  INSERT INTO tblActions (
	action_UserGUID,
	action_command,
	action_param1,
	action_param2,
	action_param5,
	Action_LocalID, 
	Action_LocalIDType) VALUES (

    	@UserGUID,
     	@Command,
     	@Param1,
     	@Param2,
     	@Param5,
     	@Action_LocalID,
     	@Action_LocalIDType
   )

END

if @Command = 'SET_IN_PROGRESS'
BEGIN

	if @CaseGuid is null 
	    Begin
		SET @Param1 = ''
	    end
	else
	    Begin
		SET @Param1 = cast(@CaseGUID as varchar (255))
	    end
	

  INSERT INTO tblActions (
	action_UserGUID,
	action_command,
	action_param1,
	action_param2,
	action_param5,
	Action_LocalID, 
	Action_LocalIDType) VALUES (

    	@UserGUID,
     	@Command,
     	@Param1,
     	@Param2,
     	@Param5,
     	@Action_LocalID,
     	@Action_LocalIDType
   )

END

if @Command = 'SET_STATUS'
BEGIN
	if @status is not null
	    Begin
	    SELECT @QueueGuid = WebGUID FROM tblQueues WHERE statuscode = @status
--print '@QueueGUID after select from tblQueues = ' + cast(@Queueguid as varchar(50))

		if @CaseGuid is null 
		    Begin
			SET @Param1 = ''
		    end
		else
		    Begin
			SET @Param1 = cast(@CaseGUID as varchar (255))
		    end
		if @QueueGUID is null
		    begin
			SET @Param2 = ''
		    End
		else
		    Begin
			Set @Param2 = cast(@QueueGUID as varchar (255))
		    End

	
	  INSERT INTO tblActions (
		action_UserGUID,
		action_command,
		action_param1,
		action_param2,
                action_param3,
		action_param5,
		Action_LocalID, 
		Action_LocalIDType) VALUES (
	
	    	@UserGUID,
	     	@Command,
	     	@Param1,
	     	@Param2,
                1,
	     	@Param5,
	     	@Action_LocalID,
	     	@Action_LocalIDType
	   )
	    end
END
