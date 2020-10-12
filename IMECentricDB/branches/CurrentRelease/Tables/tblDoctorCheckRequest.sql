CREATE TABLE [dbo].[tblDoctorCheckRequest] (
    [CheckRequestID] INT          IDENTITY (1, 1) NOT NULL,
    [AcctingTransID] INT          NOT NULL,
    [CaseNbr]        INT          NOT NULL,
    [DoctorCode]     INT          NOT NULL,
    [ApptTime]       DATETIME     NULL,
    [EWFacilityID]   INT          NOT NULL,
    [EWLocationID]   INT          NOT NULL,
    [Amount]         MONEY        NULL,
    [Comment]        VARCHAR (30) NULL,
    [DateAdded]      DATETIME     NOT NULL,
    [UserIDAdded]    VARCHAR (15) NULL,
    [FollowupDate]   DATETIME     NULL,
    [BatchNbr]       INT          NULL,
    [ExportDate]     DATETIME     NULL,
    [GPCheckReqNbr]  INT          NULL,
    [DateEdited]     DATETIME     NULL,
    [UserIDEdited]   VARCHAR (15) NULL,
    CONSTRAINT [PK_tblDoctorCheckRequest] PRIMARY KEY CLUSTERED ([CheckRequestID] ASC)
);








GO



GO


CREATE TRIGGER tblDoctorCheckRequest_AfterInsert_TRG 
  ON tblDoctorCheckRequest
AFTER INSERT
AS
  UPDATE tblDoctorCheckRequest
  SET tblDoctorCheckRequest.GPCheckReqNbr = i.CheckRequestID
  FROM Inserted AS i
  WHERE tblDoctorCheckRequest.CheckRequestID = i.CheckRequestID

GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblDoctorCheckRequest_AcctingTransID]
    ON [dbo].[tblDoctorCheckRequest]([AcctingTransID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorCheckRequest_CaseNbr]
    ON [dbo].[tblDoctorCheckRequest]([CaseNbr] ASC);

