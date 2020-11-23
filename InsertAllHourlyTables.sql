CREATE procedure [dbo].[InsertAllHourlyTables]
as
--DROP TABLE IF EXISTS [dbo].[bg_table]
CREATE TABLE [dbo].[bg_table](
	[icustay_id] [int] NULL,
	[charttime] DATETIME NOT NULL,
	[PaO2FiO2] [float] NULL,
	[PCO2] [float] NULL,
	[time_window] [int] NULL
) ON [Standard]

CREATE TABLE [dbo].[gcs_table](
	[icustay_id] [int] NULL,
	[MinGCS] [float] NULL,
	[time_window] [int] NULL
) ON [Standard]

--DROP TABLE IF EXISTS dbo.[labs_table]
CREATE TABLE dbo.[labs_table](
	[icustay_id] [int] NULL,
	BANDS_min [float] NULL,
	BANDS_max [float] NULL,
	[Bilirubin_Max] [float] NULL,
	[Creatinine_Max] [float] NULL,
	[Platelet_Min] [float] NULL,
	WBC_min [float] NULL,
	WBC_max [float] NULL,
	[time_window] [int] NULL,
) ON [Standard]


--DROP TABLE IF EXISTS dbo.[SIRS_hourly]
CREATE TABLE dbo.[SIRS_hourly](
	[icustay_id] [int] NULL,
	SIRS [int] NULL,
	Temp_score [int] NULL,
	HeartRate_score [int] NULL,
	Resp_score [int] NULL,
	WBC_score [int] NULL,
	[time_window] [int] NULL,
) ON [Standard]
