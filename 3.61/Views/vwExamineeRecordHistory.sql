CREATE VIEW vwExamineeRecordHistory
AS
    SELECT  tblRecordActions.Description ,
            tblRecordHistory.MedRecID ,
            tblRecordHistory.CaseNbr ,
            tblRecordHistory.ActionID ,
            tblRecordHistory.Type ,
            tblRecordHistory.Inches ,
            tblRecordHistory.Pages ,
            tblRecordHistory.Notes ,
            tblRecordHistory.DateAdded ,
            tblRecordHistory.UserIDAdded ,
            tblRecordHistory.DateEdited ,
            tblRecordHistory.UserIDEdited ,
            tblRecordHistory.OnINDocument ,
            tblRecordHistory.OnVODocument
    FROM    tblRecordHistory
            INNER JOIN tblRecordActions ON tblRecordHistory.ActionID = tblRecordActions.ActionID
