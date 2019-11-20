
-- ======================================================================================================
-- Issue 11262 

	-- 11.	Patch Svc WF data – anything that has a source StatusCode 3, create a new row but use the new tblQueues 
		-- primary key as the source StatusCode.  This should involve two tables: tblServiceWorkflowQueue and tblServiceWorkflowQueueDocument

		--  11. Part 1 below is query tp patch tblServiceWorkflowQueue
		  INSERT INTO tblServiceWorkflowQueue (ServiceWorkflowID, DateAdded, DateEdited, UserIDAdded, UserIDEdited, QueueOrder, StatusCode, NextStatus, CreateVoucher, CreateInvoice)
		  (SELECT ServiceWorkflowID, GETDATE(), NULL, 'TLyde', NULL, QueueOrder, 34, NextStatus, CreateVoucher, CreateInvoice FROM tblServiceWorkflowQueue WHERE StatusCode = 3)


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

			-- get the workflow ID's from tblServiceWorkflowQueueDocument for statusCode = 3 in tblServiceWorkflowQueue
			SELECT ServiceWorkflowQueueID 
			INTO tempTable_Lyde1
			FROM tblServiceWorkflowQueueDocument
			WHERE ServiceWorkflowQueueID IN (SELECT ServiceWorkflowQueueID FROM tblServiceWorkflowQueue WHERE StatusCode = 3)

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
				   WHERE D.ServiceWorkflowQueueID IN (SELECT ServiceWorkflowQueueID FROM tblServiceWorkflowQueue WHERE StatusCode = 3))
	   

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
