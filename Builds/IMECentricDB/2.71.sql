DECLARE @cmd VARCHAR(500)

DECLARE TblCursorPK CURSOR FOR
WITH    PKNames
          AS ( SELECT   name AS IndexName ,
                        OBJECT_NAME(object_id) AS TableName ,
                        OBJECT_SCHEMA_NAME(object_id) AS SchemaName ,
                        ( SELECT    '' + c.name
                          FROM      sys.index_columns ic
                                    INNER JOIN sys.columns c ON ic.object_id = c.object_id
                                                              AND ic.index_column_id = c.column_id
                          WHERE     ic.object_id = i.object_id
                                    AND ic.index_id = i.index_id
                                    AND ic.is_included_column = 0
                          ORDER BY  ic.key_ordinal
                        FOR
                          XML PATH('')
                        ) AS Columns
               FROM     sys.indexes i
               WHERE    i.is_primary_key = 1
             )
    SELECT  'EXEC sp_rename ''' + QUOTENAME(SchemaName) + '.'
            + QUOTENAME(IndexName) + ''', ''PK_' + TableName
			--+ '_' + Columns
            + ''''
    FROM    PKNames
    WHERE   IndexName <> 'PK_' + TableName
			--+ '_' + Columns

OPEN TblCursorPK

FETCH NEXT FROM TblCursorPK INTO @cmd
WHILE @@FETCH_STATUS = 0
BEGIN
  PRINT @cmd
  EXEC (@cmd) 
  FETCH NEXT FROM TblCursorPK INTO @cmd
END

CLOSE TblCursorPK
DEALLOCATE TblCursorPK





DECLARE TblCursorDF CURSOR FOR
SELECT  'EXEC sp_rename ''' + QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
        + '.' + QUOTENAME(dc.name) + ''', ''DF_'
        + OBJECT_NAME(dc.parent_object_id) + '_' + c.name + ''''
FROM    sys.default_constraints dc
        INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id
                                    AND dc.parent_column_id = c.column_id
WHERE   dc.name <> 'DF_' + OBJECT_NAME(dc.parent_object_id) + '_' + c.name


OPEN TblCursorDF

FETCH NEXT FROM TblCursorDF INTO @cmd
WHILE @@FETCH_STATUS = 0
BEGIN
  PRINT @cmd
  EXEC (@cmd) 
  FETCH NEXT FROM TblCursorDF INTO @cmd
END

CLOSE TblCursorDF
DEALLOCATE TblCursorDF




UPDATE tblControl SET DBVersion='2.71'
GO
