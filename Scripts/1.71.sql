

DROP PROCEDURE [proc_CaseTranscription_Delete]
GO

DROP PROCEDURE [proc_CaseTranscription_Insert]
GO

DROP PROCEDURE [proc_CaseTranscription_LoadByCaseNbr]
GO

DROP PROCEDURE [proc_CaseTranscription_LoadByPrimaryKey]
GO

DROP PROCEDURE [proc_CaseTranscription_LoadByTransCode]
GO

DROP PROCEDURE [proc_CaseTranscription_LoadByTranscriptionID]
GO

DROP PROCEDURE [proc_CaseTranscription_Update]
GO

DROP TABLE tblCaseTranscription
GO


declare @table_name nvarchar(256)
declare @col_name nvarchar(256)
declare @Command  nvarchar(1000)

set @table_name = N'tblWebUser'

set @col_name = N'AllowTranscriptionRequest'
select @Command = 'ALTER TABLE ' + @table_name + ' drop constraint ' + d.name
 from sys.tables t   
  join    sys.default_constraints d       
   on d.parent_object_id = t.object_id  
  join    sys.columns c      
   on c.object_id = t.object_id      
    and c.column_id = d.parent_column_id
 where t.name = @table_name
  and c.name = @col_name
execute (@Command)

set @col_name = N'NotifyTranscriptionAssignment'
select @Command = 'ALTER TABLE ' + @table_name + ' drop constraint ' + d.name
 from sys.tables t   
  join    sys.default_constraints d       
   on d.parent_object_id = t.object_id  
  join    sys.columns c      
   on c.object_id = t.object_id      
    and c.column_id = d.parent_column_id
 where t.name = @table_name
  and c.name = @col_name
execute (@Command)
GO

ALTER TABLE [tblWebUser]
  DROP COLUMN [AllowTranscriptionRequest]
GO

ALTER TABLE [tblWebUser]
  DROP COLUMN [NotifyTranscriptionAssignment]
GO




UPDATE tblControl SET DBVersion='1.71'
GO
