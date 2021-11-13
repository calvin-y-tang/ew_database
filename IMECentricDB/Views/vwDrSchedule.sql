CREATE VIEW vwDrSchedule
AS
    SELECT
        DS.SchedCode,
        DS.DoctorCode,
        DS.LocationCode,
        DS.date,
        DS.StartTime,
        DS.Status,
        DS.Duration,

        DS.CaseNbr1,
        DS.CaseNbr1Desc,
        DS.CaseNbr2,
        DS.CaseNbr2Desc,
        DS.CaseNbr3,
        DS.CaseNbr3Desc,
        DS.CaseNbr4,
        DS.CaseNbr4Desc,
        DS.CaseNbr5,
        DS.CaseNbr5Desc,
        DS.CaseNbr6,
        DS.CaseNbr6Desc,

        S1.ShortDesc AS Service1,
        S2.ShortDesc AS Service2,
        S3.ShortDesc AS Service3,
        S4.ShortDesc AS Service4,
        S5.ShortDesc AS Service5,
        S6.ShortDesc AS Service6,

        CT1.ShortDesc+'/ '+S1.ShortDesc AS CaseType1,
        CT2.ShortDesc+'/ '+S2.ShortDesc AS CaseType2,
        CT3.ShortDesc+'/ '+S3.ShortDesc AS CaseType3,
        CT4.ShortDesc+'/ '+S4.ShortDesc AS CaseType4,
        CT5.ShortDesc+'/ '+S5.ShortDesc AS CaseType5,
        CT6.ShortDesc+'/ '+S6.ShortDesc AS CaseType6,

        DS.DateAdded,
        DS.UserIDAdded,
        DS.DateEdited,
        DS.UserIDEdited

    FROM tblDoctorSchedule AS DS
    LEFT OUTER JOIN tblCase C1 ON DS.CaseNbr1=C1.CaseNbr
    LEFT OUTER JOIN tblCase C2 ON DS.CaseNbr2=C2.CaseNbr
    LEFT OUTER JOIN tblCase C3 ON DS.CaseNbr3=C3.CaseNbr
    LEFT OUTER JOIN tblCase C4 ON DS.CaseNbr4=C4.CaseNbr
    LEFT OUTER JOIN tblCase C5 ON DS.CaseNbr5=C5.CaseNbr
    LEFT OUTER JOIN tblCase C6 ON DS.CaseNbr6=C6.CaseNbr
    LEFT OUTER JOIN tblCaseType CT1 ON CT1.Code=C1.CaseType
    LEFT OUTER JOIN tblCaseType CT2 ON CT2.Code=C2.CaseType
    LEFT OUTER JOIN tblCaseType CT3 ON CT3.Code=C3.CaseType
    LEFT OUTER JOIN tblCaseType CT4 ON CT4.Code=C4.CaseType
    LEFT OUTER JOIN tblCaseType CT5 ON CT5.Code=C5.CaseType
    LEFT OUTER JOIN tblCaseType CT6 ON CT6.Code=C6.CaseType
    LEFT OUTER JOIN tblServices S1 ON S1.ServiceCode=C1.ServiceCode
    LEFT OUTER JOIN tblServices S2 ON S2.ServiceCode=C2.ServiceCode
    LEFT OUTER JOIN tblServices S3 ON S3.ServiceCode=C3.ServiceCode
    LEFT OUTER JOIN tblServices S4 ON S4.ServiceCode=C4.ServiceCode
    LEFT OUTER JOIN tblServices S5 ON S5.ServiceCode=C5.ServiceCode
    LEFT OUTER JOIN tblServices S6 ON S6.ServiceCode=C6.ServiceCode
