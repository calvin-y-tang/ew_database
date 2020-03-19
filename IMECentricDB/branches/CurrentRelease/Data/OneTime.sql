--// 11503 - adding new default e-document for daysheet
insert into tblDocument (Document, Type, Description, EmailSubject, EmailBody, DateAdded, UserIDAdded, DateEdited, UserIDEdited, AddressedTo, CreateHistory, NeverEmail, NeverFax, DocumentDateFlag, TemplateFormat, FlattenFormFields, UsePDFReaderToPrint, PageScaling, [Status]) values (
    'DaySheetDefault',
    'EDocument',
    'Day Sheet Default Document',
    'Daily Status Sheet(s) for examinations',
    'Attached is the schedule for the Independent Medical Evaluations on the above date(s). \nAfter exams are completed please indicate SHOW or NO SHOW on the sheet provided and Email and or Fax back to our office as soon as possible. \nThank you for your cooperation.',
    getdate(),
    'admin',
    getdate(),
    'admin',
    'Doctor',
    1, 0, 0, 'G', 'Word', 0, 0, 0, 'Active'
);

--// 11503 - updating all offices with the new default day sheet e-document
update tblOffice set DaySheetDocument = 'DaySheetDefault';