CREATE TABLE [dbo].[tblConfirmationRuleDetail] (
    [ConfirmationRuleDetailID]       INT          IDENTITY (1, 1) NOT NULL,
    [ConfirmationRuleID]             INT          NOT NULL,
    [ContactType]                    VARCHAR (20) NOT NULL,
    [ContactMethod]                  INT          NOT NULL,
    [DaysPrior]                      INT          NOT NULL,
    [RuleType]                       INT          NOT NULL,
    [ConfirmationMessageID]          INT          NOT NULL,
    [SkipIfConfirmed]                BIT          CONSTRAINT [DF_tblConfirmationRuleDetail_SkipIfConfirmed] DEFAULT ((0)) NOT NULL,
    [CallRetries]                    INT          CONSTRAINT [DF_tblConfirmationRuleDetail_CallRetries] DEFAULT ((0)) NOT NULL,
    [SuccessfulAction]               INT          NOT NULL,
    [UnsuccessfulAction]             INT          NOT NULL,
    [DateAdded]                      DATETIME     NULL,
    [UserIDAdded]                    VARCHAR (15) NULL,
    [DateEdited]                     DATETIME     NULL,
    [UserIDEdited]                   VARCHAR (15) NULL,
    [MasterConfirmationRuleDetailID] INT          NULL,
    [SeqNo]                          INT          NULL,
    [CallAllPhone] BIT NULL, 
    CONSTRAINT [PK_tblConfirmationRuleDetail] PRIMARY KEY CLUSTERED ([ConfirmationRuleDetailID] ASC)
);



GO
CREATE TRIGGER tblConfirmationRuleDetail_AfterInsert_TRG 
  ON tblConfirmationRuleDetail
AFTER INSERT
AS
BEGIN
SET NOCOUNT ON
  UPDATE tblConfirmationRuleDetail
   SET tblConfirmationRuleDetail.SeqNo = (SELECT MAX(SeqNo)+1 FROM tblConfirmationRuleDetail WHERE MasterConfirmationRuleDetailID=Inserted.MasterConfirmationRuleDetailID)
   FROM Inserted
   WHERE tblConfirmationRuleDetail.ConfirmationRuleDetailID = Inserted.ConfirmationRuleDetailID
   AND Inserted.MasterConfirmationRuleDetailID IS NOT NULL
  UPDATE tblConfirmationRuleDetail
   SET tblConfirmationRuleDetail.MasterConfirmationRuleDetailID = Inserted.ConfirmationRuleDetailID, tblConfirmationRuleDetail.SeqNo = 1
   FROM Inserted
   WHERE tblConfirmationRuleDetail.ConfirmationRuleDetailID = Inserted.ConfirmationRuleDetailID
   AND Inserted.MasterConfirmationRuleDetailID IS NULL
SET NOCOUNT OFF
END