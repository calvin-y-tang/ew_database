
-- Issue 10169 - add column to tblCase - not sure if this is needed here since I changed the table in this project
  ALTER TABLE tblCase ADD RptQADraftDate DATETIME NULL
  ALTER TABLE tblCase ADD TATQADraftToQAComplete INT NULL


-- Issue 10169 data changes - adds data fields to use for TAT
  INSERT INTO tblDataField (DataFieldID, TableName, FieldName, Descrip) VALUES
  (214, 'tblCase', 'RptQADraftDate', 'Report QA Draft Date'),
  (120, 'tblCase', 'TATQADraftToQAComplete', '')

  -- Issue 10169 data changes - specifies how to calculate fields for TAT
  INSERT INTO tblTATCalculationMethod (TATCalculationMethodID, StartDateFieldID, EndDateFieldID, Unit, TATDataFieldID, UseTrend) VALUES
(20, 214, 204, 'Day', 120, 0)


-- Issue 10169 data changes - change the grouping display order for TAT calculation details so I can add new one in the middle
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 7 WHERE TATCalculationMethodID = 2 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 9 WHERE TATCalculationMethodID = 3 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 10 WHERE TATCalculationMethodID = 4 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 11 WHERE TATCalculationMethodID = 16 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 12 WHERE TATCalculationMethodID = 9 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 13 WHERE TATCalculationMethodID = 5 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 14 WHERE TATCalculationMethodID = 17 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 15 WHERE TATCalculationMethodID = 18 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 16 WHERE TATCalculationMethodID = 19 AND TATCalculationGroupID = 1

-- Issue 10169 data changes - add to the business line group IMEC
  INSERT INTO tblTATCalculationGroupDetail (TATCalculationGroupID, TATCalculationMethodID, DisplayOrder) VALUES
  (1, 20, 8)

-- ======================================================================================================
-- Issue 11262 
		-- 7. add new queue for web reserved appointments
		INSERT INTO tblQueueForms VALUES ('frmStatusWbRsvdAppts', 'Form for Web Rerserved Appointments')

		SET IDENTITY_INSERT tblQueues ON
		GO
		INSERT INTO tblQueues (StatusCode, StatusDesc, Type, ShortDesc, DisplayOrder, 
			FormToOpen, DateAdded, DateEdited, UserIDAdded, UserIDEdited, 
			Status, SubType, FunctionCode, WebStatusCode, NotifyScheduler, 
			NotifyQARep, NotifyIMECompany, WebGUID, AllowToAwaitingScheduling, IsConfirmation, 
			WebStatusCodeV2, AwaitingReptDictation, AwaitingReptApproval, DoNotAllowManualChange)
		VALUES(34, 'Web Reserved Appointment', 'System', 'WbRsvdAppt', 50, 
			   'frmStatusWbRsvdAppts', GETDATE(), NULL, 'TLyde', NULL,
			   'Active', 'Case', 'None', NULL, 0,
			   0, 1, NULL, NULL, 0, 
			   NULL, Null, NULL, 1)
		GO
		SET IDENTITY_INSERT tblQueues OFF

		-- 9. Set the new column on tblControl equl to the new key primary key
		 UPDATE tblControl SET ApptRequestStatusCode = 34 WHERE InstallID = 1

	-- 11.	Patch Svc WF data – anything that has a source StatusCode 10, create a new row but use the new tblQueues 
		-- primary key as the source StatusCode.  This should involve two tables: tblServiceWorkflowQueue and tblServiceWorkflowQueueDocument

		--  11. Part 1 below is query tp patch tblServiceWorkflowQueue
		  INSERT INTO tblServiceWorkflowQueue (ServiceWorkflowID, DateAdded, DateEdited, UserIDAdded, UserIDEdited, QueueOrder, StatusCode, NextStatus, CreateVoucher, CreateInvoice)
		  (SELECT ServiceWorkflowID, GETDATE(), NULL, 'TLyde', NULL, QueueOrder, 34, NextStatus, CreateVoucher, CreateInvoice FROM tblServiceWorkflowQueue WHERE StatusCode = 10)


		  -- 11. Part 2 - patch of tblServiceWorkflowQueueDocument
			IF OBJECT_ID('tempTable_Lyde1') IS NOT NULL
			BEGIN
			DROP TABLE tempTable_Lyde1
			END

			IF OBJECT_ID('tempTable_Lyde2') IS NOT NULL
			BEGIN
			DROP TABLE tempTable_Lyde2
			END

			IF OBJECT_ID('tempTable_Lyde3') IS NOT NULL
			BEGIN
			DROP TABLE tempTable_Lyde3
			END

			-- get the workflow ID's from tblServiceWorkflowQueueDocument for statusCode = 10 in tblServiceWorkflowQueue
			SELECT ServiceWorkflowQueueID 
			INTO tempTable_Lyde1
			FROM tblServiceWorkflowQueueDocument
			WHERE ServiceWorkflowQueueID IN (SELECT ServiceWorkflowQueueID FROM tblServiceWorkflowQueue WHERE StatusCode = 10)

			-- Now that I know the work flow queue ID's, I need to find the corresponding work flow ID's from tblServiceWorkflowQueue
			SELECT ServiceWorkflowID 
			INTO tempTable_Lyde2
			FROM tblServiceWorkflowQueue WHERE ServiceWorkflowQueueID IN (SELECT * FROM tempTable_Lyde1)

			-- Now find the work flow queue ID's for the work flow ID's for a status of 34
			SELECT ServiceWorkflowQueueID, ServiceWorkflowID
			INTO tempTable_Lyde3
			FROM tblServiceWorkflowQueue WHERE ServiceWorkflowID IN (SELECT * FROM tempTable_Lyde2) AND StatusCode = 34


			-- USE temptable3 to create new rows - Use the work flow queue ID's from tempTable_Lyde3
				INSERT INTO tblServiceWorkflowQueueDocument 
				  (ServiceWorkflowQueueID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, Document,
				   Attachment, ProcessOrder, PrintCopies, EmailDoctor, EmailAttorney, EmailClient, FaxDoctor, FaxAttorney, FaxClient,
				   PublishOnWeb, PublishedTo, EnvelopeAOrder, EnvelopeBOrder, EnvelopeCOrder, EnvelopeDOrder, CombineDocs)
				(SELECT T.ServiceWorkflowQueueID, GETDATE(), 'TLyde', NULL, NULL, Document,
				   Attachment, ProcessOrder, PrintCopies, EmailDoctor, EmailAttorney, EmailClient, FaxDoctor, FaxAttorney, FaxClient,
				   PublishOnWeb, PublishedTo, EnvelopeAOrder, EnvelopeBOrder, EnvelopeCOrder, EnvelopeDOrder, CombineDocs
				   FROM tblServiceWorkflowQueueDocument AS D
				   LEFT JOIN tblServiceWorkflowQueue AS A ON D.ServiceWorkflowQueueID = A.ServiceWorkflowQueueID
				   LEFT JOIN tempTable_Lyde3 AS T ON  A.ServiceWorkflowID = T.ServiceWorkflowID
				   WHERE D.ServiceWorkflowQueueID IN (SELECT ServiceWorkflowQueueID FROM tblServiceWorkflowQueue WHERE StatusCode = 10))
	   

			IF OBJECT_ID('tempTable_Lyde1') IS NOT NULL
			BEGIN
			DROP TABLE tempTable_Lyde1
			END

			IF OBJECT_ID('tempTable_Lyde2') IS NOT NULL
			BEGIN
			DROP TABLE tempTable_Lyde2
			END

			IF OBJECT_ID('tempTable_Lyde3') IS NOT NULL
			BEGIN
			DROP TABLE tempTable_Lyde3
			END


-- ======================================================================================================

-- Issue 11326 Data Patch - A new column -AllowScheduling- was added to tblWebUser.  Sets default values to 0
	UPDATE tblWebUser SET AllowScheduling = 0 
