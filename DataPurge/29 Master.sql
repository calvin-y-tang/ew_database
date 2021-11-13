-- **********************************************************************************************************
--
--   Description:
--        ??? TODO: description will be need to filled in after all the TODOs have been figured out
--
--   Notes:
--        1. 08/04/15 - Calvin - created
--        2. 08/20/2015 - JAP - cleanup and documentation
--
-- **********************************************************************************************************

-- ??? TODO: i realize that we are populating some kind of a "Master" table, would be great to include
--           a description of what this data represents/is used for.
INSERT
     INTO EWDoctorDB
         (EWDoctorID ,
          DBID ,
          UserIDAdded ,
          DateAdded
         )
         SELECT EWDoctorID ,
                22 ,
                UserIDAdded ,
                DateAdded
           FROM EWDoctorDB
          WHERE DBID=1
GO

-- ??? TODO: i realize that we are populating some kind of a "Master" table, would be great to include
--           a description of what this data represents/is used for.
INSERT
     INTO EWCompanyDB
         (EWCompanyID ,
          DBID ,
          UserIDAdded ,
          DateAdded
         )
         SELECT EWCompanyID ,
                22 ,
                UserIDAdded ,
                DateAdded
           FROM EWCompanyDB
          WHERE DBID=1
GO

-- ??? TODO: i realize that we are populating some kind of a "Master" table, would be great to include
--           a description of what this data represents/is used for.
INSERT
     INTO EWClientDB
          (EWClientID ,
           DBID ,
           UserIDAdded ,
           DateAdded
          )
          SELECT EWClientID ,
                 22 ,
                 UserIDAdded ,
                 DateAdded
            FROM EWClientDB
           WHERE DBID=1
GO

-- ??? TODO: no clue what is going on here
SELECT EDB.*
--DELETE EDB
  FROM EWDoctorDB AS EDB
          LEFT OUTER JOIN TempNY.dbo.tblDoctor AS D ON D.EWDoctorID = EDB.EWDoctorID
 WHERE EDB.DBID=22
   AND D.DoctorCode IS NULL
GO

-- ??? TODO: no clue what is going on here
SELECT EDB.*
--DELETE EDB
  FROM EWDoctorDB AS EDB
          LEFT OUTER JOIN TempNJ.dbo.tblDoctor AS D ON D.EWDoctorID = EDB.EWDoctorID
 WHERE EDB.DBID=1
   AND D.DoctorCode IS NULL
GO

-- ??? TODO: no clue what is going on here
SELECT EDB.*
--DELETE EDB
  FROM EWClientDB AS EDB
          LEFT OUTER JOIN TempNY.dbo.tblClient AS C ON C.EWClientID = EDB.EWClientID
 WHERE EDB.DBID=22
   AND C.ClientCode IS NULL
GO

-- ??? TODO: no clue what is going on here
SELECT EDB.*
--DELETE EDB
  FROM EWClientDB AS EDB
          LEFT OUTER JOIN TempNJ.dbo.tblClient AS C ON C.EWClientID = EDB.EWClientID
 WHERE EDB.DBID=1
   AND C.ClientCode IS NULL
GO
