-- **********************************************************************************************************
--
--   Description:
--        Need to ensure that our tmpDelete is truly empty. This becomes important when the
--        scripts or portions of them are run multiple times.
--        The other purpose of this script is to load up the Delete table with the ids of the
--        offices that are to be deleted.
--        THIS NEEDS TO BE THE FIRST DATAT PROCESSING SCRIPT THAT GETS RUN OTHERWISE YOU MIGHT
--        END UP DELETEING OTHER DETAILS FROM THE TMPDELETE TABLE THAT YOU DON'T WANT TO.
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- remove all rows from the tmpDelete table.
TRUNCATE TABLE tmpDelete
GO

-- THE FOLLOWING COMMANDS ARE REQUIRED WHEN PROCESSING THE NAMED DATABASES. THEY WILL IDENTIFY
-- WHICH OFFICES NEED TO BE DELETED FROM THE OFFICE TABLE.
     --In EW-NewJersey, Delete 7
     --INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     --SELECT 'Office', 7, 1

     --In EW-NewYork, Delete 1,2,3,4,6,8
     --INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     --SELECT 'Office', 1, 1
     --INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     --SELECT 'Office', 2, 1
     --INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     --SELECT 'Office', 3, 1
     --INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     --SELECT 'Office', 4, 1
     --INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     --SELECT 'Office', 6, 1
     --INSERT INTO tmpDelete ( Type, ID, OkToDelete)
     --SELECT 'Office', 8, 1

