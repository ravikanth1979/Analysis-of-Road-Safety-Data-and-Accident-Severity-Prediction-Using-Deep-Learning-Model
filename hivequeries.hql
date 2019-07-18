/****************************************************************************************************************************************/
/*************************************************************HIVE TABLE CREATION********************************************************/
/****************************************************************************************************************************************/

/* Create external tables that referes to the .csv files in Google Cloud Storage*/

/****************************************************************1.db_bdtt_ac.accidents**************************************************/
CREATE EXTERNAL TABLE if not exists db_bdtt_ac.accidents(Accident_Index varchar(50),Location_Easting_OSGR FLOAT, Location_Northing_OSGR FLOAT,Longitude DECIMAL(10,8),Latitude DECIMAL(10,8),Police_Force INT,Accident_Severity INT,Number_of_Vehicles INT,Number_of_Casualties INT,\`Date\` VARCHAR(50),Day_of_Week INT,Time VARCHAR(50),Local_Authority_District INT,Local_Authority_Highway VARCHAR(50), 1st_Road_Class INT,1st_Road_Number INT,Road_Type INT,Speed_limit FLOAT,Junction_Detail INT,Junction_Control INT,2nd_Road_Class INT,2nd_Road_Number INT,Pedestrian_Crossing_Human_Control INT,Pedestrian_Crossing_Physical_Facilities INT,Light_Conditions INT,Weather_Conditions INT,Road_Surface_Conditions INT,Special_Conditions_at_Site INT,Carriageway_Hazards INT,Urban_or_Rural_Area INT,Did_Police_Officer_Attend_Scene_of_Accident INT,LSOA_of_Accident_Location VARCHAR(50)) comment 'External table for accidents data' row format delimited fields terminated by ',' location 'gs://ravikanth-assignment-bucket/accidents/' tblproperties("skip.header.line.count"="1");

/****************************************************************2.db_bdtt_ac.vehicles****************************************************/
CREATE EXTERNAL TABLE if not exists  db_bdtt_ac.vehicles(Accident_Index VARCHAR(50),Vehicle_Reference INT,Vehicle_Type INT,Towing_and_Articulation INT,Vehicle_Manoeuvre INT,Vehicle_Location_Restricted_Lane INT,Junction_Location INT,Skidding_and_Overturning INT,Hit_Object_in_Carriageway INT,Vehicle_Leaving_Carriageway INT,Hit_Object_off_Carriageway INT,1st_Point_of_Impact INT,Was_Vehicle_Left_Hand_Drive INT,Journey_Purpose_of_Driver INT,Sex_of_Driver INT,Age_of_Driver INT,Age_Band_of_Driver INT,Engine_Capacity_CC INT,Propulsion_Code INT,Age_of_Vehicle INT,Driver_IMD_Decile INT,Driver_Home_Area_Type INT,Vehicle_IMD_Decile INT) comment 'External table for vehicles data' row format delimited fields terminated by ',' location 'gs://ravikanth-assignment-bucket/vehicles/' tblproperties("skip.header.line.count"="1");

/****************************************************************3.db_bdtt_ac.casualties****************************************************/
CREATE EXTERNAL TABLE if not exists db_bdtt_ac.casualties(Accident_Index varchar(50),Vehicle_Reference int,Casualty_Reference int,Casualty_Class int,Sex_of_Casualty int,Age_of_Casualty int,Age_Band_of_Casualty int,Casualty_Severity int,Pedestrian_Location int,Pedestrian_Movement int,Car_Passenger int,Bus_or_Coach_Passenger int,Pedestrian_Road_Maintenance_Worker int,Casualty_Type int,Casualty_Home_Area_Type int,Casualty_IMD_Decile int) comment 'External table for casualties data' row format delimited fields terminated by ',' location 'gs://ravikanth-assignment-bucket/casualties/' tblproperties("skip.header.line.count"="1");

/****************************************************************4.db_bdtt_ac.road_type*****************************************************/
CREATE EXTERNAL TABLE if not exists db_bdtt_ac.road_type(code int, label varchar(50)) comment 'external table for road_type data' row format delimited fields terminated by ',' location 'gs://ravikanth-assignment-bucket/road_type' tblproperties("skip.header.line.count"="1");

/****************************************************************5.db_bdtt_ac.accident_severity*********************************************/
CREATE EXTERNAL TABLE if not exists db_bdtt_ac.accident_severity(code int, label varchar(50)) comment 'external table for accident_severity data' row format delimited fields terminated by ',' location 'gs://ravikanth-assignment-bucket/accident_severity/' tblproperties("skip.header.line.count"="1");

/****************************************************************6.db_bdtt_ac.day_of_week***************************************************/
CREATE EXTERNAL TABLE if not exists db_bdtt_ac.day_of_week(code int, label varchar(50)) comment 'external table for day_of_week data' row format delimited fields terminated by ',' location 'gs://ravikanth-assignment-bucket/day_of_week/' tblproperties("skip.header.line.count"="1");

/****************************************************************7.db_bdtt_ac.local_authority_district**************************************/
CREATE EXTERNAL TABLE if not exists db_bdtt_ac.local_authority_district(code int, label varchar(50)) comment 'external table for local_authority_district data' row format delimited fields terminated by ',' location 'gs://ravikanth-assignment-bucket/local_authority_district/' tblproperties("skip.header.line.count"="1");

/****************************************************************8.db_bdtt_ac.local_authority_highway***************************************/
CREATE EXTERNAL TABLE if not exists db_bdtt_ac.local_authority_highway(code varchar(50),label varchar(50)) comment 'external table for local_authority_highway data' row format delimited fields terminated by ',' location 'gs://ravikanth-assignment-bucket/local_authority_highway/' tblproperties(\"skip.header.line.count\"=\"1\");

/****************************************************************9.db_bdtt_ac.police_force_codes**************************************************************************/
CREATE EXTERNAL TABLE if not exists db_bdtt_ac.police_force_codes(code int, label varchar(50)) comment 'external table for police_force_codes data' row format delimited fields terminated by ',' location 'gs://ravikanth-assignment-bucket/police_force_codes/' tblproperties("skip.header.line.count"="1");

/****************************************************************10.db_bdtt_ac.vehicle_type**************************************************/
CREATE EXTERNAL TABLE if not exists db_bdtt_ac.vehicle_type(code int, label varchar(50)) comment 'external table for vehicle_type data' row format delimited fields terminated by ',' location 'gs://ravikanth-assignment-bucket/vehicle_type' tblproperties("skip.header.line.count"="1");
/********************************************************************************************************************************************/
/*************************************************************Problem Statements*************************************************************/
/********************************************************************************************************************************************/
/*1. Top 3 Police Force that have most the Fatal Accidents*/
select p.label, count(a.Accident_Index) as accidents_count  from db_bdtt_ac.accidents a,db_bdtt_ac.police_force_codes p where a.Accident_Severity in (select code from db_bdtt_ac.accident_severity where label='fatal') and a.Police_Force = p.code group by a.Police_Force,p.label order by accidents_count  desc limit 3;

/*2.Top 5 Local Authorities that have most Serious Accidents*/

/*2.1. Local Authority District*/
select ld.label, count(Accident_Index) as accidents_count from db_bdtt_ac.accidents a,db_bdtt_ac.local_authority_district ld where a.Accident_Severity in (select code from db_bdtt_ac.accident_severity where label='serious') and a.Local_Authority_District = ld.code group by a.Local_Authority_District ,ld.label order by accidents_count desc limit 5;

/*2.1. Local Authority Highway*/
select lh.label, count(a. Accident_Index) as accidents_count from db_bdtt_ac.accidents a,db_bdtt_ac.local_authority_highway lh where a.Accident_Severity in (select code from db_bdtt_ac.accident_severity where label='serious') and a. Local_Authority_Highway = lh.code group by a. Local_Authority_Highway ,lh.label order by accidents_count desc limit 5;

/*3.The Vehicle Type that have most Serious and Fatal Accidents*/

/*3.1.Serious Accidents*/
select vt.label,count(v.Accident_Index) as accidents_count from db_bdtt_ac.vehicles v,db_bdtt_ac.vehicle_type vt where v.Accident_Index in (select Accident_Index from db_bdtt_ac.accidents where Accident_Severity in (select code from db_bdtt_ac.accident_severity where label='serious')) and v.Vehicle_Type = vt.code group by vt.label order by accidents_count desc limit 5;


/*3.2.Fatal Accidents*/
select vt.label,count(v.Accident_Index) as accidents_count from db_bdtt_ac.vehicles v,db_bdtt_ac.vehicle_type vt where v.Accident_Index in (select Accident_Index from db_bdtt_ac.accidents where Accident_Severity in (select code from db_bdtt_ac.accident_severity where label='fatal')) and v.Vehicle_Type = vt.code group by vt.label order by accidents_count desc limit 5;

/* 4.The Age Band of Casualty that have most Fatal Accidents */
select abc.label, count(c.Accident_Index) as accidents_count  from db_bdtt_ac.casualties c,db_bdtt_ac.age_band_casuality abc where c.Accident_Index in (select Accident_Index from db_bdtt_ac.accidents a where a.Accident_Severity in (select code from db_bdtt_ac.accident_severity where label='fatal')) and c. Age_Band_of_Casualty = abc.code group by abc.label order by accidents_count desc limit 5;

/* 5.Group and display the Slight Accidents by Day of Week in West Yorkshire Police Force Area*/
select dw.label,count(a.Accident_Index) as accidents_count from db_bdtt_ac.accidents a, db_bdtt_ac.day_of_week dw where Accident_Severity in (select code from db_bdtt_ac.accident_severity where label='slight') and a.Police_Force in (select pf.code from db_bdtt_ac.police_force_codes pf where pf.label='West Yorkshire') and dw.code = a. Day_of_Week group by dw.label order by accidents_count desc;

/*6.The peak hour that have most Fatal Accidents in Dual carriageway*/
select CONCAT(SUBSTR(a.Time,0,2),'-',CAST(CAST(SUBSTR(a.Time,0,2) AS INT)+1 AS STRING))  AS PEAK_HOUR,count(a.Accident_Index) AS Accident_Count from db_bdtt_ac.accidents a where a.Accident_Severity in (select code from db_bdtt_ac.accident_severity where label='fatal') and a.Road_Type IN (select code from db_bdtt_ac.Road_Type where label='Dual carriageway')  group by SUBSTR(a.Time,0,2) ORDER BY Accident_Count DESC LIMIT 3

/*7.The area that have most Fatal Motorcycle Accidents*/
select CASE WHEN  Urban_or_Rural_Area=2 THEN 'Urban' WHEN Urban_or_Rural_Area=1  THEN 'Rural' ELSE 'Unalloted' END AS Uran_Or_Rural, count(Accident_Index) AS accidents_count from db_bdtt_ac.accidents where Accident_Index in (select Accident_Index from db_bdtt_ac.vehicles where Vehicle_Type in (select code from db_bdtt_ac.vehicle_type where LOWER(label) like '%motor%')) and Accident_Severity in (select code from db_bdtt_ac.accident_severity where label='fatal') group by Urban_or_Rural_Area order by accidents_count desc;
