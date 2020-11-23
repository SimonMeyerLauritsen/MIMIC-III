CREATE PROCEDURE [dbo].[InsertGet_labs] @delta INT
AS 

--DECLARE @delta INT = 2;
DECLARE @sqlCommand NVARCHAR(MAX);
SET @sqlCommand = '

	INSERT INTO dbo.labs_table 
	SELECT
	  pvt.icustay_id
	    , min(case when label = ''BANDS'' then valuenum else null end) as BANDS_min
	    , max(case when label = ''BANDS'' then valuenum else null end) as BANDS_max
		, max(case when label = ''BILIRUBIN'' then valuenum else null end) as BILIRUBIN_max
		, max(case when label = ''CREATININE'' then valuenum else null end) as CREATININE_max
		, min(case when label = ''PLATELET'' then valuenum else null end) as PLATELET_min
		, min(case when label = ''WBC'' then valuenum else null end) as WBC_min
		, max(case when label = ''WBC'' then valuenum else null end) as WBC_max
	 , ' + CAST(@delta AS NVARCHAR)  + ' as time_window -- SKAL SKIFTES UD MED VARIABEL
	from
	( -- begin query that extracts the data
	  select ie.icustay_id
	  -- here we assign labels to ITEMIDs
	  -- this also fuses together multiple ITEMIDs containing the same data
	  , case
			when itemid = 50885 then ''BILIRUBIN''
			when itemid = 50912 then ''CREATININE''
			when itemid = 51265 then ''PLATELET''
			when itemid = 51300 then ''WBC''
			when itemid = 51301 then ''WBC''
			when itemid = 51144 then ''BANDS''
		  else null
		end as label
	  , -- add in some sanity checks on the values
	  -- the where clause below requires all valuenum to be > 0, so these are only upper limit checks
		case
		  when itemid = 50885 and valuenum >   150 then null -- mg/dL ''BILIRUBIN''
		  when itemid = 50912 and valuenum >   150 then null -- mg/dL ''CREATININE''
		  when itemid = 51265 and valuenum > 10000 then null -- K/uL ''PLATELET''
		  when itemid = 51300 and valuenum >  1000 then null -- ''WBC''
		  when itemid = 51301 and valuenum >  1000 then null -- ''WBC''
		  when itemid = 51144 and valuenum < 0 then null -- immature band forms
          when itemid = 51144 and valuenum > 100 then null -- immature band forms
		else le.valuenum
		end as valuenum

	  from
	  -- subselect to add HADM_ID to suspinfect table
	  ( select s.*, ie.hadm_id from dbo.suspinfect_poe s  --CHANGED FROM ORIGINAL: added _poe!
		inner join dbo.icustays ie
		on s.icustay_id = ie.icustay_id ) ie
	  left join dbo.labevents le
		on le.hadm_id = ie.hadm_id
		and le.charttime
	-- SKAL SKIFTES UD

		 BETWEEN DATEADD(HOUR, -24, DATEADD(HOUR, ' + CAST(@delta AS NVARCHAR)  + ', ie.si_starttime))
	AND DATEADD(HOUR, ' + CAST(@delta AS NVARCHAR)  + ', ie.si_starttime) --1 SKAL SKIFTES UD MED VARIABEL

	-- SKAL SKIFTES UD
		  and le.ITEMID in
		  (
			-- comment is: LABEL | CATEGORY | FLUID | NUMBER OF ROWS IN LABEVENTS
            51144, -- BANDS - hematology
			50885, -- BILIRUBIN, TOTAL | CHEMISTRY | BLOOD | 238277
			50912, -- CREATININE | CHEMISTRY | BLOOD | 797476
			51265, -- PLATELET COUNT | HEMATOLOGY | BLOOD | 778444
			51301, -- WHITE BLOOD CELLS | HEMATOLOGY | BLOOD | 753301
			51300  -- WBC COUNT | HEMATOLOGY | BLOOD | 2371
		  )
		  and valuenum is not null and valuenum > 0 -- lab values cannot be 0 and cannot be negative
	) pvt
	group by pvt.icustay_id
	order by pvt.icustay_id';
PRINT(@sqlCommand);
EXECUTE (@sqlCommand);
GO
