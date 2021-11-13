CREATE PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_InitData]
AS

--
-- Hartford Data Initialization
--

SET NOCOUNT ON 

-- Drop and create temp tables
IF OBJECT_ID('tempdb..##tmp_HartfordOfficeMap') IS NOT NULL DROP TABLE ##tmp_HartfordOfficeMap
IF OBJECT_ID('tempdb..##tmp_HartfordSpecialtyMap') IS NOT NULL DROP TABLE ##tmp_HartfordSpecialtyMap
IF OBJECT_ID('tempdb..##tmp_HartfordSubSpecialtyMap') IS NOT NULL DROP TABLE ##tmp_HartfordSubSpecialtyMap

-- Create Office Mapping Table
CREATE TABLE ##tmp_HartfordOfficeMap (
	Id INT NOT NULL Primary Key Identity (1,1),
	CurrentOfficeName VarChar(64),
	NewOfficeName VarChar(64),
	IsLawOffice bit 
)

-- Create Specialty Mapping Table
CREATE TABLE ##tmp_HartfordSpecialtyMap (
	Id INT NOT NULL Primary Key Identity (1,1),	
	CurrentSpecialtyName VarChar(64) NULL,
	NewSpecialtyName VarChar(64) NOT NULL
)

-- Create Sub-Specialty Mapping Table
create table ##tmp_HartfordSubSpecialtyMap (
	Id INT NOT NULL Primary Key Identity (1,1),	
	CurrentSpecialtyName VarChar(64) NULL,
	NewSpecialtyName VarChar(64) NOT NULL
)

-- Insert data into Office Mapping
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Linda S Baumann Law Offices - NJ East Windsor','PL-Northeast', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - NY Syracuse (NEWCCC)','NEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford Life and Disability - FL Maitland (CAR)','GB East', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - NY Syracuse Specialized Unit (NEWCCC)','NEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - MD Hunt Valley (SEWCCC)','SEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - FL Lake Mary (SEWCCC)','SEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - TX Houston (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - TX San Antonio (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Diana Lee Khachaturian','PL-Central', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('John A. Hauser Law Offices - CA Brea','PL-Western', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - CA Sacramento (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - CA Rancho Cordova (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford Life and Disability - CA Sacramento','GB West	', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Law Office of Timothy Farley - OR Lake Oswego','PL-Western	', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - OR Lake Oswego (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - AZ Phoenix (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Law Office of Timothy Farley - WA Seattle','PL-Western', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - AZ Phoenix (PL - Western)','PL - Western', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - IL Aurora (CWCCC)','CWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - CT Hartford (NEWCCC)','NEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - NY Syracuse Remote (NEWCCC)','NEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - CT Windsor (PL - Northeast)','PL - Northeast', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Stewart H. Friedman - NY Garden City','PL-Northeast', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - ID Boise','The Hartford - ID Boise', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Hartford Underwriters Insurance Company - TX San Antonio','Hartford Underwriters Insurance Company - TX San Antonio', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Hartford Underwriters Insurance Company - KY Lexington','Hartford Underwriters Insurance Company - KY Lexington', 0)

-- Insert Data into Specialty Mapping
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Acupuncture', 'Acupuncture	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Allergy & Immunology', 'Allergy 	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Anesthesiology', 'Anesthesiology	')
-- INSERT INTO ##tmp_HartfordSpecialtyMap VALUES (0, '', 'Bariatric Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Cardiology', 'Cardiovascular Disease	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Cardiovascular Surgery', 'Cardiovascular Disease	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Chiropractic Medicine', 'Chiropractic Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Dentistry', 'Dentistry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Dermatology', 'Dermatology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Emergency Medicine', 'Emergency Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Endocrinology', 'Endocrinology 	')
--INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('', 'FAA Aviation Medical Examiner	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Family Medicine', 'Family Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Gastroenterology', 'Gastroenterology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Gastroenterology - Pediatrics', 'Gastroenterology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Geriatric Medicine - Family Medicine', 'Geriatric Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Geriatric Medicine - Internal Medicine', 'Geriatric Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Hematology', 'Hematology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Hepatology', 'Hepatology	')
--INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('', 'Immunology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Infectious Disease', 'Infectious Disease	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Internal Medicine', 'Internal Medicine	')
--INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('', 'Low Vision	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Nephrology', 'Nephrology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neurological Surgery', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neurology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neurology - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuro-ophthalmology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropharmacology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neurophysiology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropsychiatry', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropsychiatry - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropsychology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropsychology - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuroradiology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Obstetrics & Gynecology', 'Obstetrics/Gynecology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Occupational Medicine', 'Occupational Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Oncology', 'Oncology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Ophthalmology', 'Ophthalmology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Orthopaedic Oncology', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Orthopaedic Surgery', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Orthopaedic Surgery - Pediatrics', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Otolaryngology', 'Otolaryngology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Otolaryngology - Pediatrics', 'Otolaryngology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Pain Medicine - Anesthesiology', 'Pain Management	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Pain Medicine - Neurology', 'Pain Management	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Pain Medicine - Physical Medicine & Rehabilitation', 'Pain Management	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Physical Medicine & Rehabilitation', 'Physical Medicine & Rehabilitation	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Physical Therapy', 'Physical Therapy	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Podiatry', 'Podiatry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Preventive Medicine', 'Preventative Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Psychiatry', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Psychiatry - Forensic', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Psychiatry - Pediatrics', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Psychology', 'Psychology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Pulmonary Disease', 'Pulmonology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Rheumatology', 'Rheumatology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Sleep Medicine - Family Medicine', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Sleep Medicine - Internal Medicine', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Sleep Medicine - Otolaryngology', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Spine Surgery - Neurological Surgery', 'Surgery	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Spine Surgery - Orthopaedic Surgery', 'Surgery	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Toxicology - Aerospace Medicine', 'Toxicology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Toxicology - Emergency Medicine', 'Toxicology	')
--INSERT INTO ##tmp_HartfordSpecialtyMap VALUES (0, '', 'Transplant Hepatology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Urology', 'Urology	')


-- Insert Data into Sub-Specialty Mapping
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Acupuncture', 'Acupuncture	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Allergy & Immunology', 'Allergy 	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Anesthesiology', 'Anesthesiology	')
-- INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES (0, '', 'Bariatric Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Cardiology', 'Cardiovascular Disease	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Cardiovascular Surgery', 'Cardiovascular Disease	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Chiropractic Medicine', 'Chiropractic Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Dentistry', 'Dentistry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Dermatology', 'Dermatology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Emergency Medicine', 'Emergency Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Endocrinology', 'Endocrinology 	')
--INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('', 'FAA Aviation Medical Examiner	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Family Medicine', 'Family Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Gastroenterology', 'Gastroenterology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Gastroenterology - Pediatrics', 'Gastroenterology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Geriatric Medicine - Family Medicine', 'Geriatric Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Geriatric Medicine - Internal Medicine', 'Geriatric Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Hematology', 'Hematology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Hepatology', 'Hepatology	')
--INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('', 'Immunology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Infectious Disease', 'Infectious Disease	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Internal Medicine', 'Internal Medicine	')
--INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('', 'Low Vision	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Nephrology', 'Nephrology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neurological Surgery', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neurology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neurology - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuro-ophthalmology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropharmacology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neurophysiology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropsychiatry', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropsychiatry - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropsychology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropsychology - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuroradiology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Obstetrics & Gynecology', 'Obstetrics/Gynecology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Occupational Medicine', 'Occupational Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Oncology', 'Oncology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Ophthalmology', 'Ophthalmology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Orthopaedic Oncology', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Orthopaedic Surgery', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Orthopaedic Surgery - Pediatrics', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Otolaryngology', 'Otolaryngology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Otolaryngology - Pediatrics', 'Otolaryngology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Pain Medicine - Anesthesiology', 'Pain Management	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Pain Medicine - Neurology', 'Pain Management	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Pain Medicine - Physical Medicine & Rehabilitation', 'Pain Management	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Physical Medicine & Rehabilitation', 'Physical Medicine & Rehabilitation	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Physical Therapy', 'Physical Therapy	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Podiatry', 'Podiatry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Preventive Medicine', 'Preventative Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Psychiatry', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Psychiatry - Forensic', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Psychiatry - Pediatrics', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Psychology', 'Psychology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Pulmonary Disease', 'Pulmonology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Rheumatology', 'Rheumatology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Sleep Medicine - Family Medicine', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Sleep Medicine - Internal Medicine', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Sleep Medicine - Otolaryngology', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Spine Surgery - Neurological Surgery', 'Surgery	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Spine Surgery - Orthopaedic Surgery', 'Surgery	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Toxicology - Aerospace Medicine', 'Toxicology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Toxicology - Emergency Medicine', 'Toxicology	')
--INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES (0, '', 'Transplant Hepatology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Urology', 'Urology	')

print 'Temp tables created'

SET NOCOUNT OFF
