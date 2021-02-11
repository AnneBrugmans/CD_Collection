--determine datebase to be used 
USE [CompactDiskCollection];

--all files form original flatfile imported as table into database 
SELECT * FROM "CD_Collection_flatfile";
--32 rows in total 

--current table (original flatfile) renamed for easier access in commands 
SP_RENAME "CD_Collection_Flatfile", 'Compact_Disc_Collection';

--review all information in current table
SELECT * FROM Compact_Disc_Collection;
--32 rows in total

--replace any blanks in table data with underscore for consistency
UPDATE Compact_Disc_Collection
SET    CD_Title = REPLACE(CD_Title, ' ', '_')
WHERE  CD_Title LIKE '%[ ]%';

--rename columns due to mispelling
sp_RENAME 'Compact_Disc_Collection.[Additonal_CD_Title]' , 'Additional_CD_Title', 'COLUMN';

--continue to execute change into table data to replace any blanks with underscore for consistency 
UPDATE Compact_Disc_Collection
SET    Additional_CD_Title = REPLACE(Additional_CD_Title, ' ', '_')
WHERE  Additional_CD_Title LIKE '%[ ]%';

UPDATE Compact_Disc_Collection
SET    Artist = REPLACE(Artist, ' ', '_')
WHERE  Artist LIKE '%[ ]%';

UPDATE Compact_Disc_Collection
SET    Additional_Musicians = REPLACE(Additional_Musicians, ' ', '_')
WHERE  Additional_Musicians LIKE '%[ ]%';

UPDATE Compact_Disc_Collection
SET    Genre = REPLACE(Genre, ' ', '_')
WHERE  Genre LIKE '%[ ]%';

UPDATE Compact_Disc_Collection
SET    Type = REPLACE(Type, ' ', '_')
WHERE  Type LIKE '%[ ]%';

UPDATE Compact_Disc_Collection
SET    Date_Written = REPLACE(Date_Written, ' ', '_')
WHERE  Date_Written LIKE '%[ ]%';

UPDATE Compact_Disc_Collection
SET    Date_Recorded = REPLACE(Date_Recorded, ' ', '_')
WHERE  Date_Recorded LIKE '%[ ]%';

UPDATE Compact_Disc_Collection
SET    Date_Released = REPLACE(Date_Released, ' ', '_')
WHERE  Date_Released LIKE '%[ ]%';

UPDATE Compact_Disc_Collection
SET    Record_Company = REPLACE(Record_Company, ' ', '_')
WHERE  Record_Company LIKE '%[ ]%';

UPDATE Compact_Disc_Collection
SET    Record_Label = REPLACE(Record_Label, ' ', '_')
WHERE  Record_Label LIKE '%[ ]%';

--Review changes have been executed successfully 
SELECT * FROM Compact_Disc_Collection;

--Remove ID_Item column to replace with unique identity column
ALTER TABLE Compact_Disc_Collection
DROP COLUMN ID_Item;

--Add unique identifying column
ALTER TABLE Compact_Disc_Collection
ADD CD_ID int IDENTITY  (1,1);

--Adding additional columns for more detailed information 
ALTER TABLE Compact_Disc_Collection
ADD Favorite varchar(5);

ALTER TABLE Compact_Disc_Collection
ADD Single_CD varchar(5);

--change data type and size for more efficient storage
ALTER TABLE Compact_Disc_Collection
ALTER COLUMN CD_Title nvarchar(75);

ALTER TABLE Compact_Disc_Collection
ALTER COLUMN Additional_CD_Title nvarchar(75);

ALTER TABLE Compact_Disc_Collection
ALTER COLUMN Artist nvarchar(75);

ALTER TABLE Compact_Disc_Collection
ALTER COLUMN Additional_Musicians nvarchar(150);

ALTER TABLE Compact_Disc_Collection
ALTER COLUMN Genre varchar(30);

ALTER TABLE Compact_Disc_Collection
ALTER COLUMN Type varchar(50);

ALTER TABLE Compact_Disc_Collection
ALTER COLUMN Date_Written varchar(10);

ALTER TABLE Compact_Disc_Collection
ALTER COLUMN Date_Recorded varchar(10);

ALTER TABLE Compact_Disc_Collection
ALTER COLUMN Date_Released varchar(10);						
						
--Creating child tables from the parent table (CD_Collection) to build a relational database structure
SELECT CD_ID, CD_Title, Additional_CD_Title, Date_Written, Date_Recorded, Date_Released
INTO CD_Title
FROM Compact_Disc_Collection;

		--change name of column to match ERD
		sp_RENAME 'Compact_Disc_Collection.[Additional_Musicians]' , 'Additional_Artists', 'COLUMN';
		sp_RENAME 'Compact_Disc_Collection.[Artist]' , 'Artist_Name', 'COLUMN';
		sp_RENAME 'Compact_Disc_Collection.[Genre]' , 'Category' , 'COLUMN';
		sp_RENAME 'Compact_Disc_Collection.[Type]' , 'Type_of_Music' , 'COLUMN';

SELECT Artist_Name, Additional_Artists
INTO Artists
FROM Compact_Disc_Collection;

SELECT Category, Type_of_Music
INTO Genre
FROM Compact_Disc_Collection;

SELECT Record_Label, Record_Company
INTO Recording_Studio
FROM Compact_Disc_Collection;

SELECT Favorite, Single_CD
INTO Extras
FROM Compact_Disc_Collection;

--Assigning PK to table with unique identifier already established 
ALTER TABLE CD_Title
ADD CONSTRAINT PK_CD_ID PRIMARY KEY (CD_ID);

--add unique identity columns for each new table to assign promary keys and ensure referential integrity
ALTER TABLE Artists 
ADD Artist_ID int IDENTITY  (1,1) primary key;

ALTER TABLE Genre
ADD Genre_ID int IDENTITY (1,1) primary key;

INSERT INTO Extras (Favorite, Single_CD)
			VALUES
			('No','No'),
			('Yes','Yes'),
			('No','No'),
			('Yes','Yes'),
			('No','Yes'),
			('Yes','Yes'),
			('Yes','Yes'),
			('Yes','Yes'),
			('Yes','Yes'),
			('Yes','Yes'),
			('Yes','Yes'),
			('Yes','Yes'),
			('Yes','Yes'),
			('Yes','Yes'),
			('Yes','Yes'),
			('Yes','Yes'),
			('Yes','Yes'),
			('No','Yes'),
			('No','Yes'),
			('No','No'),
			('No','Yes'),
			('Yes','Yes'),
			('No','Yes'),
			('No','Yes'),
			('No','Yes'),
			('No','Yes'),
			('No','No'),
			('No','Yes'),
			('No','Yes'),
			('No','Yes'),
			('No','Yes'),
			('No','Yes');
		
		-- results in 32 NULL rows at top 
		DELETE top (32)
		FROM Extras;
		--Double check
		SELECT * FROM Extras;
		--32 rows affected

--assign unique identifying columns as primary key to reworked tables 
ALTER TABLE Extras
ADD Extras_ID int IDENTITY (1,1) primary key;															
																									
--Add additional column with default value for additioanl information
ALTER TABLE Recording_Studio
ADD Record_CO_Address varchar(50) not null
CONSTRAINT df_Record_CO_Address DEFAULT 'Canada';

--edit feilds for accurate information
UPDATE Recording_Studio
SET Record_CO_Address = 'UK'
WHERE Record_Label = 'EMI_Abbey_Road';

UPDATE Recording_Studio
SET Record_CO_Address = 'USA'
WHERE Record_Company = 'BMG_Classics';

UPDATE Recording_Studio
SET Record_CO_Address = 'UK'
WHERE Record_Label = 'Decca_Records' AND Record_Company = 'BMG_Canada';

--Added a unique identifying column for easier editing
ALTER TABLE Recording_Studio
ADD Studio_ID int IDENTITY (1,1);

UPDATE Recording_Studio
SET Record_CO_Address = 'USA'
WHERE Studio_ID = 18;

UPDATE Recording_Studio
SET Record_CO_Address = 'USA'
WHERE Studio_ID = 19;

UPDATE Recording_Studio
SET Record_CO_Address = 'USA'
WHERE Studio_ID = 24;

UPDATE Recording_Studio
SET Record_CO_Address = 'USA'
WHERE Studio_ID = 25;

--Checked fields have been updated accurately 
SELECT * FROM Recording_Studio;

--Assigning PK to table with unique identifier already established 
ALTER TABLE Recording_Studio
ADD CONSTRAINT PK_Studio_ID PRIMARY KEY (Studio_ID);
								
--Created table to ensure one to many relationship structure between attributes originally many to many 
		--first columns to establish relationships needed to be added 
		ALTER TABLE Recording_Studio
		ADD Artist_ID int;

		ALTER TABLE Genre
		ADD CD_ID int;

SELECT Artist_ID, Studio_ID
INTO Artist_Studio
FROM Recording_Studio;

SELECT CD_ID, Genre_ID
INTO CD_Category
FROM Genre;

--Check if columns contain duplicate values and only list the different (distinct) values
SELECT DISTINCT Artist_Name, 
				Additional_Artists
				FROM Artists;
		
		--checked duplicates by using COUNT(*)>1 statement 
		SELECT	Artist_Name, 
				Additional_Artists,
				COUNT(*)
				FROM Artists
				GROUP BY Artist_Name, 
					     Additional_Artists
				HAVING COUNT(*)>1
				ORDER BY Artist_Name;

--Experimented to see how duplicates could be deleted							
		-- by using CTE function
		USE [CompactDiskCollection];
		WITH cte AS 
		(
		SELECT Artist_Name,
			   Additional_Artists,
			   ROW_NUMBER() 
			   OVER 
			   (
			   PARTITION BY Artist_Name
			   ORDER BY Artist_Name,
						Additional_Artists
				) row_num
				FROM Artists
		)
		DELETE FROM cte
		WHERE row_num > 1;

		--by using MAX function
		DELETE FROM Artists			
		WHERE Artist_ID NOT IN 
		(
			SELECT MAX(Artist_ID) AS MAX_RecordID
				FROM Artists
				GROUP BY Artist_Name,
						 Additional_Artists
		);

--Deleted duplicates in relevant tables							
--first checked if columns contain duplicate values and list only the distinct values
SELECT DISTINCT CD_Title, 
				Additional_CD_Title,
				Date_Written,
				Date_Recorded,
				Date_Released
				FROM CD_Title;

-- Delete duplicates by using MAX function
DELETE FROM CD_Title			
WHERE CD_ID NOT IN 
(
	SELECT MAX(CD_ID) AS MAX_RecordID
		FROM CD_Title
        GROUP BY CD_Title,
				 Additional_CD_Title,
				 Date_Written,
				 Date_Recorded,
				 Date_Released
);

--first checked if columns contain duplicate values and list only the distinct values
SELECT DISTINCT Record_Label, 
				Record_Company,
				Record_CO_Address
				FROM Recording_Studio;

-- Delete duplicates by using MAX function
DELETE FROM Recording_Studio			
WHERE Studio_ID NOT IN 
(
	SELECT MAX(Studio_ID) AS MAX_RecordID
		FROM Recording_Studio
        GROUP BY Record_Label, 
				 Record_Company,
				 Record_CO_Address
);

--first checked if columns contain duplicate values and list only the distinct values
SELECT DISTINCT Category, 
				Type_of_Music
				FROM Genre;

-- Delete duplicates by using MAX function
DELETE FROM Genre			
WHERE Genre_ID NOT IN 
(
	SELECT MAX(Genre_ID) AS MAX_RecordID
		FROM Genre
        GROUP BY Category, 
				Type_of_Music
);

--ENSURING REFERENTIAL INTEGRITY
--Alter tables to add columns for the purpose of defining relationship and adding Foreign Keys
		--relationships from other tables to CD_Title table 
		ALTER TABLE Artists
		ADD CD_ID int;

		ALTER TABLE Extras
		ADD CD_ID int;

		ALTER TABLE Recording_Studio
		ADD CD_ID INT;

		--relationship from Extras table to Artists table
		ALTER TABLE Extras
		ADD Artist_ID int;
		
--ASSIGNING FOREIGN KEYS  
		--relationships from CD-Title table to other tables
		ALTER TABLE Artists
		ADD FOREIGN KEY (CD_ID) REFERENCES CD_Title(CD_ID);

		ALTER TABLE Extras
		ADD FOREIGN KEY (CD_ID) REFERENCES CD_Title(CD_ID);

		ALTER TABLE Recording_Studio
		ADD FOREIGN KEY (CD_ID) REFERENCES CD_Title(CD_ID);

		ALTER TABLE CD_Category
		ADD FOREIGN KEY (CD_ID) REFERENCES CD_Title (CD_ID);

		ALTER TABLE Artist_Studio
		ADD FOREIGN KEY (Artist_ID) REFERENCES Artists (Artist_ID);
		
		--relationship from Extras table to Artists table
		ALTER TABLE Extras
		ADD FOREIGN KEY (Artist_ID) REFERENCES Artists(Artist_ID);

		--rework columns in tables to ensure one to many relationship (original many to many)
		--cannot have multi unique identity conflicting for FK referencing other tables 
		ALTER TABLE Artist_Studio
		DROP COLUMN Studio_ID;
		
		ALTER TABLE Artist_Studio
		ADD Studio_ID INT;

		ALTER TABLE CD_Category
		DROP COLUMN Genre_ID;

		ALTER TABLE CD_Category
		ADD Genre_ID INT;

		--Create FK constraints to ensure one to many relationship (original many to many)
		ALTER TABLE Artist_Studio
		ADD CONSTRAINT FK_Studio_ID
		FOREIGN KEY (Studio_ID) REFERENCES Recording_Studio (Studio_ID);
																	
		ALTER TABLE CD_Category
		ADD CONSTRAINT FK_Genre_ID
		FOREIGN KEY (Genre_ID) REFERENCES Genre (Genre_ID);
