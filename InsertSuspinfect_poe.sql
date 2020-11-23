CREATE PROCEDURE [dbo].[InsertSuspinfect_poe]
AS

DROP TABLE IF EXISTS dbo.suspinfect_poe;
with abx as
(
  select icustay_id
    , suspected_infection_time
    , specimen, positiveculture
    , si_starttime, si_endtime
    , antibiotic_name
    , antibiotic_time
    , ROW_NUMBER() OVER
    (
      PARTITION BY icustay_id
      ORDER BY suspected_infection_time
    ) as rn
  from abx_micro_poe
)
select
  ie.icustay_id
  , antibiotic_name
  , antibiotic_time
  , suspected_infection_time
  , specimen, positiveculture
  , si_starttime, si_endtime
into dbo.suspinfect_poe
from icustays ie
left join abx
  on ie.icustay_id = abx.icustay_id
  and abx.rn = 1
order by ie.icustay_id;
GO
