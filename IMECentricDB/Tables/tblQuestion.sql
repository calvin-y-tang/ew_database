CREATE TABLE tblQuestion
          (
	          [QuestionID]   INT          IDENTITY (1, 1) NOT NULL,
	          [QuestionText] VARCHAR(MAX) NOT NULL,
	          [DateAdded]	 DATETIME     NOT NULL, 
	          [UserIDAdded]	 VARCHAR(15)  NOT NULL, 
	          [DateEdited]	 DATETIME     NULL, 
	          [UserIDEdited] VARCHAR(15)  NULL, 
              CONSTRAINT [PK_tblQuestion] PRIMARY KEY ([QuestionID])
          )
