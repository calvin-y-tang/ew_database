CREATE VIEW vwDoctorKeyword
AS
    SELECT
        tblDoctorKeyWord.DoctorCode,
        tblDoctorKeyWord.KeywordID,
        tblKeyWord.Keyword
    FROM
        tblDoctorKeyWord
    INNER JOIN tblKeyWord ON tblDoctorKeyWord.KeywordID=tblKeyWord.KeywordID
