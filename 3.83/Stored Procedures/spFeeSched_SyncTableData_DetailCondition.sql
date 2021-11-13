CREATE PROCEDURE [dbo].[spFeeSched_SyncTableData_DetailCondition]
     @iDetailID INTEGER,
	@sTable VARCHAR(30), 
	@sIDs VARCHAR(MAX)
AS
BEGIN
	
	DECLARE @xmlIDs XML
	
	-- delete all conditions for the specified DetailID and ConditionTable 
	DELETE FROM tblFSDetailCondition WHERE FSDetailID = @iDetailID AND ConditionTable = @sTable 
	
	-- if IDs is -1 then nothing to do
	IF @sIDs = '-1'
	BEGIN 
		RETURN 
	END 
	ELSE 
	BEGIN 
		-- need to create an entry in tblFSDetailCondition for each of the ID values in the string 
		-- DEVNOTE: 
		-- 		we are going to do some some character subsitution and turn our comma separated 
		--		list into an XML string this XML string can then easily be parsed into a table 
		--		and used in an INSERT statement to create needed items.
		SET @xmlIDs = N'<t>' + REPLACE(@sIDs, ',', '</t><t>') + '</t>'
		INSERT INTO tblFSDetailCondition(FSDetailID, ConditionTable, ConditionKey)
			SELECT @iDetailID, @sTable, r.value('.', 'INTEGER') AS ItemID 
			  FROM @xmlIDs.nodes('t') as tmp(r)
	END 
	RETURN 

END
