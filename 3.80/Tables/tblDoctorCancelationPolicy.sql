CREATE TABLE [dbo].[tblDoctorCancelationPolicy]
(
	[DoctorCancelationPolicyID] INT						IDENTITY (1, 1)	NOT NULL, 
    [DoctorCode]				INT						NOT NULL, 
    [ProcessOrder]				INT						NOT NULL, 
    [CancelDays]				INT						NOT NULL, 
    [LocationCode]				INT						NULL, 
    [UserIDAdded]				VARCHAR(15)				NULL, 
    [DateAdded]					DATETIME				NULL, 
    [UserIDEdited]				VARCHAR(15)				NULL, 
    [DateEdited]				DATETIME				NULL, 
    [Status]					VARCHAR(10)				NULL,
	CONSTRAINT [PK_tblDoctorCancelationPolicy] PRIMARY KEY CLUSTERED ([DoctorCancelationPolicyID] ASC)
)
