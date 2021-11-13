

CREATE PROCEDURE [proc_tblActionsInsert]
(
 @ActionID uniqueidentifier,
 @action_AddedDate datetime,
 @action_UserGUID uniqueidentifier = NULL,
 @action_command varchar(15),
 @action_param1 varchar(255),
 @action_param2 varchar(255) = NULL,
 @action_param3 varchar(255) = NULL,
 @action_param4 varchar(255) = NULL,
 @action_param5 text = NULL,
 @action_ResponseDate datetime = NULL,
 @action_ResponseCode int = NULL,
 @action_ResponseMessage text = NULL,
 @action_localID int = NULL,
 @action_localIDType int = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int
 IF @ActionID IS NULL
   SET @ActionID = NEWID()

 SET @Err = @@Error

 IF (@Err <> 0)
     RETURN @Err


 INSERT
 INTO [tblActions]
 (
  [ActionID],
  [action_AddedDate],
  [action_UserGUID],
  [action_command],
  [action_param1],
  [action_param2],
  [action_param3],
  [action_param4],
  [action_param5],
  [action_ResponseDate],
  [action_ResponseCode],
  [action_ResponseMessage],
  [action_localID],
  [action_localIDType]
 )
 VALUES
 (
  @ActionID,
  @action_AddedDate,
  @action_UserGUID,
  @action_command,
  @action_param1,
  @action_param2,
  @action_param3,
  @action_param4,
  @action_param5,
  @action_ResponseDate,
  @action_ResponseCode,
  @action_ResponseMessage,
  @action_localID,
  @action_localIDType
 )

 SET @Err = @@Error


 RETURN @Err
END


