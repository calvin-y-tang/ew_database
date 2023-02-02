-- Sprint 103

-- IMEC-13313 - add new business rules to require Employer for PC=Lowes and other specific Companies.
USE IMECentricEW 
GO 
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES -- Using PCID = 324 because that is the PCID for Lowes in Production DBs.
       (130, 'PC', 324, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'PC', 324, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, NULL, 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- 15409 Plunkett & Cooney - MI Flint
       (130, 'CO', 15409, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'MI', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 15409, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'IN', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 15409, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'MI', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 15409, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'IN', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Murphy Sanchez, PLLC - PA Fort Washington
       (130, 'CO', 80982, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'PA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80982, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'DC', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80982, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'DE', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80982, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'PA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80982, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'DC', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80982, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'DE', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- McCandlish Holton - VA Richmond
       (130, 'CO', 80981, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'VA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80981, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'VA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Hepler Broom - Chicago, IL
       (130, 'CO', 80992, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'IL', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80992, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'IL', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Davis, Rothwell, Earle & Xóchihua - OR Portland
       (130, 'CO', 36404, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'OR', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 36404, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'OR', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Quattlebaum, Grooms, & Tull PLLC
       (130, 'CO', 81001, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'OR', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 81001, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'OR', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Peavler Briscoe - TX Grapevine
       (130, 'CO', 81000, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'TX', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 81000, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'TX', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Mayer, LLP-TX Dallas
       (130, 'CO', 80506, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'TX', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80506, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'TX', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Mayer, LLP-TX Houston
       (130, 'CO', 78110, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'TX', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 78110, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'TX', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       ---- Mayer, LLP-TX-San Antoio
       (130, 'CO', 80990, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'TX', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80990, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'TX', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Johnson & Jones, P.C.
       (130, 'CO', 80991, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'OK', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80991, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'OK', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Taylor Wellons Politz Duhe, APLC
       (130, 'CO', 75903, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'LA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 75903, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'MS', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 75903, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'LA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 75903, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'MS', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Roetzel & Andress - OH Cleveland
       (130, 'CO', 62882, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'OH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 62882, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'OH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Roetzel & Andress - OH Columbus
       (130, 'CO', 62539, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'OH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 62539, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'OH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Roetzel & Andress - OH Toledo
       (130, 'CO', 17704, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'OH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 17704, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'OH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Roetzel & Andress - OH Akron
       (130, 'CO', 16658, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'OH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 16658, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'OH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Steptoe & Johnson WV-Charleston
       (130, 'CO', 77355, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'KY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 77355, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'KY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 77355, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'WV', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 77355, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'WV', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Steptoe & Johnson WV-Bridgeport
       (130, 'CO', 77356, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'KY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 77356, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'KY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 77356, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'WV', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 77356, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'WV', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Steptoe & Johnson WV-Martinsburg
       (130, 'CO', 77354, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'KY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 77354, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'KY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 77354, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'WV', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 77354, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'WV', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Steptoe & Johnson WV-Morgantown
       (130, 'CO', 77357, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'KY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 77357, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'KY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 77357, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'WV', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 77357, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'WV', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Goodsill, Anderson, Quinn & Stifel, LLP - HI Honolulu
       (130, 'CO', 80999, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'HI', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80999, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'HI', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Tharpe & Howell - CA Sherman Oaks
       (130, 'CO', 27451, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'CA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 27451, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'CA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Stott & Harrington PC - AL Birmingham
       (130, 'CO', 80994, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'AL', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80994, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'AL', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Spicer Rudstrom PLLC - TN Nashville,  Spicer Rudstrom PLLC - TN Memphis
       (130, 'CO', 80995, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'TN', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80995, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'TN', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Spicer Rudstrom PLLC - TN Nashville,  Spicer Rudstrom PLLC - TN Memphis
       (130, 'CO', 80996, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'TN', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80996, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'TN', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Burr Forman LLP - SC Columbia
       (130, 'CO', 80997, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'SC', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80997, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'SC', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Cranfill Sumner - NC Raleigh
       (130, 'CO', 80965, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NC', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80965, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NC', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Morrison Mahoney LLP - MA Fall River
       (130, 'CO', 66023, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'CT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66023, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'CT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66023, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'MA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66023, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'MA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66023, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'ME', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66023, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'ME', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66023, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66023, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66023, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'RI', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66023, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'RI', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66023, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'VT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66023, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'VT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Morrison Mahoney LLP - CT, Hatford
       (130, 'CO', 68114, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'CT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68114, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'CT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68114, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'MA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68114, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'MA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68114, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'ME', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68114, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'ME', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68114, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68114, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68114, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'RI', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68114, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'RI', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68114, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'VT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68114, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'VT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Morrison Mahony LLP-RI
       (130, 'CO', 68048, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'CT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68048, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'CT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68048, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'MA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68048, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'MA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68048, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'ME', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68048, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'ME', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68048, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68048, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68048, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'RI', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68048, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'RI', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68048, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'VT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 68048, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'VT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Morrison, Mahoney & Miller-Boston
       (130, 'CO', 66021, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'CT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66021, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'CT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66021, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'MA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66021, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'MA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66021, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'ME', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66021, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'ME', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66021, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66021, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NH', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66021, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'RI', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66021, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'RI', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66021, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'VT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 66021, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'VT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Goldberg Segalla, LLC - NJ Newark
       (130, 'CO', 74340, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NJ', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 74340, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NJ', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 74340, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 74340, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Goldberg Segalla, LLP - NJ Princeton
       (130, 'CO', 1924, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NJ', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 1924, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NJ', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 1924, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 1924, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Goldberg Segella, LLP - NY Mineola
       (130, 'CO', 2859, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NJ', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 2859, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NJ', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 2859, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 2859, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Goldberg Segalla, LLP - NY Buffalo
       (130, 'CO', 5151, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NJ', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 5151, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NJ', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 5151, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 5151, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Goldberg Segalla - NY Syracuse
       (130, 'CO', 80993, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NJ', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80993, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NJ', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80993, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80993, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Goldberg Segalla, LLP - NY - New York
       (130, 'CO', 74441, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NJ', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 74441, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NJ', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 74441, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 74441, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Hall & Evans, LLC - CO Denver
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'CO', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'CO', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'ID', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'ID', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'MT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'MT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NM', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NM', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'UT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'UT', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'WY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'WY', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'KS', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'KS', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'MO', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'MO', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'IA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80864, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'IA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Lewis, Brisbois, et al. - CA Costa Mesa
       (130, 'CO', 33509, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'AK', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 33509, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'AK', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 33509, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'ND', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 33509, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'ND', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 33509, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'NV', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 33509, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'NV', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 33509, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'WA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 33509, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'WA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 33509, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'WI', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 33509, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'WI', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 33509, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'AZ', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 33509, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'AZ', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Vernis & Bowling of Atlanta, LLC. - GA Atlanta
       (130, 'CO', 78487, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'FL', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 78487, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'FL', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 78487, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'GA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 78487, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'GA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       -- Vernis & Bowling of the Gulf Coast, P.A.
       (130, 'CO', 6323, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'FL', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 6323, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'FL', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 6323, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'GA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 6323, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'GA', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
        -- Secura - Unknown Company
       (130, 'CO', 80806, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, 'TX', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL),
       (130, 'CO', 80806, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, 'TX', 'cboEmployer', NULL, NULL, NULL, NULL, 0, NULL)
GO


