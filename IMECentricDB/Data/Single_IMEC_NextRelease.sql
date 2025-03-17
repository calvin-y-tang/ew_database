-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------
-- sprint 147

-----IMEC-14925   Fix Marketer DB Triggers
USE [IMECentricEW]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[tblCase_Log_AfterUpdate_TRG] 
  ON [dbo].[tblCase]
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT OFF
	  IF EXISTS (
        SELECT 1 
    FROM inserted i
    JOIN deleted d 
        ON i.CaseNbr = d.CaseNbr 
    WHERE i.MarketerCode <> d.MarketerCode  -- Ensure MarketerCode actually changed
    OR (i.MarketerCode IS NOT NULL AND d.MarketerCode IS NULL) -- Handle NULL cases
    OR (i.MarketerCode IS NULL AND d.MarketerCode IS NOT NULL) -- Handle NULL cases 
    )
    BEGIN	
	INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
    SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblCase', 'MarketerCode', 
               I.CaseNbr, D.MarketerCode, I.MarketerCode, GetDate(), 'Changed By :' + I.UserIDEdited
          FROM INSERTED AS I	  
                   JOIN  deleted AS D
					ON I.CaseNbr = D.CaseNbr
   END	
END
GO

USE [IMECentricEW]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[tblCompany_Log_AfterUpdate_TRG]
    ON [dbo].[tblCompany]
AFTER UPDATE
AS
BEGIN    
    SET NOCOUNT ON    
	  IF EXISTS (
        SELECT 1 
    FROM inserted i
    JOIN deleted d 
        ON i.CompanyCode = d.CompanyCode
    WHERE i.MarketerCode <> d.MarketerCode  -- Ensure MarketerCode actually changed
    OR (i.MarketerCode IS NOT NULL AND d.MarketerCode IS NULL) -- Handle NULL cases
    OR (i.MarketerCode IS NULL AND d.MarketerCode IS NOT NULL) -- Handle NULL cases    		
    )
    BEGIN
        INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
        SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblCompany', 'MarketerCode', 
               I.CompanyCode, D.MarketerCode, I.MarketerCode, GetDate(), 'Changed By :' + I.UserIDEdited
          FROM DELETED AS D
                    INNER JOIN INSERTED AS I ON I.CompanyCode = D.CompanyCode    
	END				
END
GO

USE [IMECentricEW]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[tblClient_Log_AfterUpdate_TRG]
    ON [dbo].[tblClient]
AFTER UPDATE
AS
BEGIN    
     SET NOCOUNT ON     
	  IF EXISTS (
        SELECT 1 
    FROM inserted i
    JOIN deleted d 
        ON i.ClientCode = d.ClientCode 
    WHERE i.MarketerCode <> d.MarketerCode  -- Ensure MarketerCode actually changed
    OR (i.MarketerCode IS NOT NULL AND d.MarketerCode IS NULL) -- Handle NULL cases
    OR (i.MarketerCode IS NULL AND d.MarketerCode IS NOT NULL) -- Handle NULL cases 
    )
    BEGIN
    	 INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
     SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblClient', 'MarketerCode', 
               I.ClientCode, D.MarketerCode, I.MarketerCode, GetDate(), 'Changed By :' + I.UserIDEdited
          FROM DELETED AS D
                    INNER JOIN INSERTED AS I ON I.ClientCode = D.ClientCode   
	END				
END
GO


