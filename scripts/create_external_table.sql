CREATE EXTERNAL TABLE airlines_bi_pq (
  year INT,
  month INT,
  day INT,
  dayofweek INT,
  dep_time INT,
  crs_dep_time INT,
  arr_time INT,
  crs_arr_time INT,
  carrier STRING,
  flight_num INT,
  tail_num INT,
  actual_elapsed_time INT,
  crs_elapsed_time INT,
  airtime INT,
  arrdelay INT,
  depdelay INT,
  origin STRING,
  dest STRING,
  distance INT,
  taxi_in INT,
  taxi_out INT,
  cancelled INT,
  cancellation_code STRING,
  diverted INT,
  carrier_delay INT,
  weather_delay INT,
  nas_delay INT,
  security_delay INT,
  late_aircraft_delay INT,
  date_yyyymm STRING
) STORED AS PARQUET
LOCATION "s3a://<YOUR-BUCKET-NAME>/data/refined/www.ibis-project.org/airlines_bi_pq"
TBLPROPERTIES ("numFiles"="0", "COLUMN_STATS_ACCURATE"="true", "transient_lastDdlTime"="1484553764", "numRows"="123534969", "totalSize"="0", "rawDataSize"="-1");

CREATE EXTERNAL TABLE airports (
  iata STRING,
  name STRING,
  city STRING,
  state STRING,
  country STRING,
  latitude DOUBLE,
  longitude DOUBLE
)
ROW FORMAT SERDE "org.apache.hadoop.hive.serde2.OpenCSVSerde"
STORED AS TEXTFILE
LOCATION "s3a://<YOUR-BUCKET-NAME>/data/raw/openflights.org/airports"
tblproperties("skip.header.line.count"="1");

-- If you have Parquet format file, you can use following query.
--CREATE EXTERNAL TABLE airports_pq (
--  iata STRING,
--  name STRING,
--  city STRING,
--  state STRING,
--  country STRING,
--  latitude DOUBLE,
--  longitude DOUBLE
--) STORED AS PARQUET LOCATION "s3a://<YOUR-BUCKET-NAME>/data/refined/openflights.org/airports_pq"
--TBLPROPERTIES ("transient_lastDdlTime"="1485426798");