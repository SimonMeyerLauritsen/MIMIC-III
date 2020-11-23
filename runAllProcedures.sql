CREATE PROCEDURE [dbo].[runAllProcedures]
AS

EXEC [dbo].[CreateCSIndexOnAll]

DROP TABLE IF EXISTS [dbo].[sepsis3_cohort]
DROP TABLE IF EXISTS [dbo].[suspinfect_poe]
DROP TABLE IF EXISTS [dbo].[abx_micro_poe]
DROP TABLE IF EXISTS [dbo].[abx_poe_list]
DROP TABLE IF EXISTS [dbo].[SIRS]
DROP TABLE IF EXISTS [dbo].[bloodgasfirstdayarterial]
DROP TABLE IF EXISTS [dbo].[vitalsfirstday]
DROP TABLE IF EXISTS [dbo].[uofirstday]
DROP TABLE IF EXISTS [dbo].[ventfirstday]
DROP TABLE IF EXISTS [dbo].[VENTDURATIONS]
DROP TABLE IF EXISTS [dbo].[ventsettings]
DROP TABLE IF EXISTS [dbo].[gcsfirstday]
DROP TABLE IF EXISTS [dbo].[labsfirstday]
DROP TABLE IF EXISTS [dbo].[bloodgasfirstday]

EXEC [dbo].InsertVentDuration
EXEC [dbo].[InsertVitalsfirstday]
EXEC [dbo].InsertUofirstday
EXEC [dbo].Insertgcsfirstday
EXEC [dbo].InsertLabsfirstday
EXEC [dbo].InsertBloodgasfirstday
EXEC [dbo].InsertBloodgasfirstdayarterial
EXEC [dbo].InsertVentfirstday
EXEC [dbo].InsertVitalsfirstday
EXEC [dbo].InsertAbx_poe_list
EXEC [dbo].InsertAbxMicroPre
EXEC [dbo].InsertSIRS
EXEC [dbo].InsertSOFA
EXEC [dbo].[InsertSuspinfect_poe]
EXEC [dbo].InsertCohort

EXEC [dbo].[InsertAllHourlyTables]
EXEC [dbo].[InsertHourlyValues]
GO
