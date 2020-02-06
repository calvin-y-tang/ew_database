-- Issue 11469 - patch existing exception triggers to set "Type" value for "Case"
UPDATE tblExceptionList SET [Type] = 'Case' WHERE ExceptionID IN (1,2,3,5,6,10,11,12,13,14,15,16,17,18,19,20,22,25,26,27,28,29,30,31)
GO
