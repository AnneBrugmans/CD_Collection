--select all files form original flatfile imported as table into database 
SELECT * FROM "Oma's_CD_Collection_flatfile";
--27 rows in total 

--current table (original flatfile) renamed for easier access in commands 
SP_RENAME "Oma's_CD_Collection_Flatfile", 'Omas_CD_Collection';

--determine datebase to be used 
USE [Oma's CD Collection];

--review all information in current table
SELECT * FROM Omas_CD_Collection;

--replace any blanks in table data with underscore for consistency

									--these commands did not execute correction 
									UPDATE Omas_CD_Collection
									SET CD_Title 
									WHERE "_";

									SELECT CD_Title
									FROM Omas_CD_Collection
									WHERE " "
									SET AS "_";

	--command to execute change was successful 
UPDATE Omas_CD_Collection
SET    CD_Title = REPLACE(CD_Title, ' ', '_')
WHERE  CD_Title LIKE '%[ ]%';

--rename columns due to mispelling
									--these commands did not work
									EXEC sp_rename 'Omas_CD_Collection', 'Additonal_CD_Title', 'Additional_CD_Title';

									ALTER TABLE Oma_CD_Collection
									RENAME COLUMN Additonal_CD_Title
									TO Additional_CD_Title;
	--this command successful
sp_RENAME 'Omas_CD_Collection.[Additonal_CD_Title]' , '[Additional_CD_Title]', 'COLUMN';

--continue to execute change into table data to replace any blanks with underscore for consistency 
UPDATE Omas_CD_Collection
SET    Additional_CD_Title = REPLACE(Additional_CD_Title, ' ', '_')
WHERE  Additional_CD_Title LIKE '%[ ]%';

UPDATE Omas_CD_Collection
SET    Artist = REPLACE(Artist, ' ', '_')
WHERE  Artist LIKE '%[ ]%';

UPDATE Omas_CD_Collection
SET    Additional_Musicians = REPLACE(Additional_Musicians, ' ', '_')
WHERE  Additional_Musicians LIKE '%[ ]%';

UPDATE Omas_CD_Collection
SET    Genre = REPLACE(Genre, ' ', '_')
WHERE  Genre LIKE '%[ ]%';

UPDATE Omas_CD_Collection
SET    Type = REPLACE(Type, ' ', '_')
WHERE  Type LIKE '%[ ]%';

UPDATE Omas_CD_Collection
SET    Date_Written = REPLACE(Date_Written, ' ', '_')
WHERE  Date_Written LIKE '%[ ]%';

UPDATE Omas_CD_Collection
SET    Date_Recorded = REPLACE(Date_Recorded, ' ', '_')
WHERE  Date_Recorded LIKE '%[ ]%';

UPDATE Omas_CD_Collection
SET    Date_Released = REPLACE(Date_Released, ' ', '_')
WHERE  Date_Released LIKE '%[ ]%';

UPDATE Omas_CD_Collection
SET    Record_Label = REPLACE(Record_Label, ' ', '_')
WHERE  Record_Label LIKE '%[ ]%';

UPDATE Omas_CD_Collection
SET    Record_Company = REPLACE(Record_Company, ' ', '_')
WHERE  Record_Company LIKE '%[ ]%';

--Review changes have been executed successfully 
SELECT * FROM Omas_CD_Collection;

--Check columns do not contain duplicate values and only list the different (distinct) values
SELECT DISTINCT CD_Title, 
				Additional_CD_Title, 
				Artist, 
				Additional_Musicians, 
				Genre, 
				Type, 
				Date_Written, 
				Date_Recorded, 
				Record_Label, 
				Record_Company
FROM Omas_CD_Collection;

--Double check using COUNT(*)>1 statement 
SELECT	CD_Title, 
		Additional_CD_Title, 
		Artist, 
		Additional_Musicians, 
		Genre, 
		Type, 
		Date_Written, 
		Date_Recorded, 
		Record_Label, 
		Record_Company,
COUNT(*)
FROM Omas_CD_Collection
GROUP BY 
		CD_Title, 
		Additional_CD_Title, 
		Artist, 
		Additional_Musicians, 
		Genre, 
		Type, 
		Date_Written, 
		Date_Recorded, 
		Record_Label, 
		Record_Company
HAVING COUNT(*)>1
ORDER BY CD_title;
--0 rows were affected 

-- Deleting duplicates using MAX function
DELETE FROM Omas_CD_Collection			
WHERE CD_ID NOT IN 
(
	SELECT MAX(CD_ID) AS MAX_CDRecordID
		FROM Omas_CD_COllection 
        GROUP BY CD_ID, 
				 CD_Title,
				 Additional_CD_Title,
				 [[Artist_Name]]],
				 [[Additional_Artists]]],
				 Genre,
				 Type,
				 Date_Written,
				 Date_Recorded,
				 Date_Released,
				 Record_Label,
				 Record_Company,
				 Record_CO_Address,
				 Favorite,
				 Single_CD
);
--0 rows were affected 

--Remove ID_Item column to replace with unique identity column for assigning PK 
ALTER TABLE Omas_CD_Collection
DROP COLUMN ID_Item

--ASSIGNING PRIMARY KEY
--Add unique identifying column as PK
ALTER TABLE Omas_CD_Collection 
ADD CD_ID int IDENTITY  (1,1) primary key;

--Adding additional columns for more detailed information 
ALTER TABLE Omas_CD_Collection
ADD Record_CO_Address varchar(50)null;

ALTER TABLE Omas_CD_Collection 
ADD Favorite bit;

ALTER TABLE Omas_CD_Collection
ADD Single_CD bit;

									--'BIT' data type not suitable for new columns 
									INSERT INTO Omas_CD_Collection
										(Record_CO_Address, Favorite, Single_CD)
										VALUES
										('Canada','N','N');

--change data type to accept information needed in new columns 
ALTER TABLE Omas_CD_Collection
ALTER COLUMN Record_CO_Address VARCHAR(10);

ALTER TABLE Omas_CD_Collection
ALTER COLUMN Favorite VARCHAR(5);

ALTER TABLE Omas_CD_Collection
ALTER COLUMN Single_CD VARCHAR(5);

							SELECT column_names
							FROM table_name
							WHERE column_name IS NULL;	
																				   
							--Change columns with dates to be correct data type in table
							--these commands did not work 
							ALTER TABLE Omas_CD_Collection 
							ALTER COLUMN Date_Written date;

							CAST Date_Written AS date;

							DECLARE Date_Written nvarchar(50)
							SET Date_Written = '24-06-2019'
							SELECT CONVERT(DATE, Date_Written) AS [Date];
						
		
--Creating additional table from the main table (Omas_CD_Collection)
SELECT CD_ID, CD_Title, Additional_CD_Title
INTO CD_Title
FROM Omas_CD_Collection;	

--change name of column to match ERD
sp_RENAME 'Omas_CD_Collection.[Additional_Musicians]' , '[Additional_Artists]', 'COLUMN';
sp_RENAME 'Omas_CD_Collection.[Artist]' , '[Artist_Name]', 'COLUMN';

--Creating additional table from the main table (Omas_CD_Collection)
SELECT [Artist_Name], [Additional_Artists]
INTO Artists
FROM Omas_CD_Collection;
								--renaming coumns to match ERD
								EXEC sp_rename 'Artists.[Artist_Name]', 'Artist_Name', 'COLUMN';

--Creating additional table from the main table (Omas_CD_Collection)
SELECT Genre, Type
INTO Genre
FROM Omas_CD_Collection;

--renaming coLumns to match ERD
EXEC sp_rename 'Genre.Genre', 'Category', 'COLUMN';
EXEC sp_rename 'Genre.Type', 'Type_of_Music', 'COLUMN';

--creating additional tables for the main table (Omas_CD_Collection)
SELECT Date_Written, Date_Recorded, Date_Released
INTO Dates
FROM Omas_CD_Collection;

SELECT Record_Label, Record_Company, Record_CO_Address
INTO Recording_Studio
FROM Omas_CD_Collection;

SELECT Favorite, Single_CD
INTO Extras
FROM Omas_CD_Collection;

--add unique identity columns for each new table to assign promary keys and ensure referential integrity
ALTER TABLE Artists 
ADD Artist_ID int IDENTITY  (1,1) primary key;

ALTER TABLE Dates
ADD Dates_ID int IDENTITY (1,1) primary key;

ALTER TABLE Extras 
ADD Extras_ID int IDENTITY (1,1) primary key;

ALTER TABLE Genre
ADD Genre_ID int IDENTITY (1,1) primary key;

ALTER TABLE Recording_Studio
ADD Studio_ID int IDENTITY (1,1) primary key;

--Assigning PK to table with unique identifier already established 
ALTER TABLE CD_Title
ADD CONSTRAINT PK_CD_ID PRIMARY KEY (CD_ID);

--Added data to empty columns to new tables 
INSERT INTO Recording_Studio (Record_CO_Address)
			VALUES
			('Canada'),
			('UK'),
			('Canada'),
			('USA'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('UK'),
			('Canada'),
			('USA'),
			('USA'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('USA'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada');

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
			('No','Yes'),
			('No','Yes'),
			('No','No'),
			('No','Yes'),
			('Yes','Yes'),
			('No','Yes'),
			('No','Yes'),
			('No','Yes'),
			('No','No'),
			('No','Yes'),
			('No','Yes'),
			('No','Yes'),
			('No','Yes'),
			('No','Yes');

--reviewed data in all tables in Oma's CD Collection database 
--27 affected
--PK assigned to unique identifier columns 
SELECT * FROM CD_Title;
SELECT * FROM Artists;
SELECT * FROM Genre;
SELECT * FROM Dates;

		--NULL in 1st 27 records 
		SELECT * FROM Recording_Studio;
		SELECT * FROM Extras;
		--removed tables to remake 
		--inserted values into table first
		--Assigned unique ID as PK after 
		DROP TABLE Recording_Studio;
		DROP TABLE Extras;

		SELECT Record_Label, Record_Company, Record_CO_Address
		INTO Recording_Studio
		FROM Omas_CD_Collection;	

		SELECT Favorite, Single_CD
		INTO Extras
		FROM Omas_CD_Collection;

		--Added data to empty columns to new tables 
INSERT INTO Recording_Studio (Record_CO_Address)
			VALUES
			('Canada'),
			('UK'),
			('Canada'),
			('USA'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('UK'),
			('Canada'),
			('USA'),
			('USA'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('USA'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada'),
			('Canada');

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
			('No','Yes'),
			('No','Yes'),
			('No','No'),
			('No','Yes'),
			('Yes','Yes'),
			('No','Yes'),
			('No','Yes'),
			('No','Yes'),
			('No','No'),
			('No','Yes'),
			('No','Yes'),
			('No','Yes'),
			('No','Yes'),
			('No','Yes');
-- results in 27 NULL rows at top 
DELETE top (27)
FROM Extras;
--Double check
--27 rows affected
SELECT * FROM Extras;
DELETE top (27)
FROM Recording_Studio;
--Double check
--27 rows affected 
SELECT * FROM Recording_Studio;

--re-assign unique identifying columns as primary key to reworked tables 
ALTER TABLE Extras
ADD Extras_ID int IDENTITY (1,1) primary key;

ALTER TABLE Recording_Studio
ADD Studio_ID int IDENTITY (1,1) primary key;

--Alter tables to add columns for the purpose of defining relationship and adding Foreign Keys
--ENSURING REFERENTIAL INTEGRITY
	--relationships from CD_Title table to other tables

ALTER TABLE CD_Title 
ADD Artist_ID int,
	Genre_ID int,
	Studio_ID int,
	Dates_ID int,
	Extras_ID int;
	
	--relationships from other tables to CD_Title table 
	
ALTER TABLE Artists
ADD CD_ID int;

ALTER TABLE Genre
ADD CD_ID int;

ALTER TABLE Recording_Studio
ADD CD_ID int;

ALTER TABLE Dates
ADD CD_ID int;

ALTER TABLE Extras
ADD CD_ID int;

--ASSIGNING FOREIGN KEYS  
	--relationships from CD-Title table to other tables

ALTER TABLE CD_Title
ADD FOREIGN KEY (Artist_ID) REFERENCES Artists(Artist_ID);

ALTER TABLE CD_Title
ADD FOREIGN KEY (Genre_ID) REFERENCES Genre(Genre_ID);

ALTER TABLE CD_Title
ADD FOREIGN KEY (Studio_ID) REFERENCES Recording_Studio(Studio_ID);

ALTER TABLE CD_Title 
ADD FOREIGN KEY (Dates_ID) REFERENCES Dates(Dates_ID);

ALTER TABLE CD_Title
ADD FOREIGN KEY (Extras_ID) REFERENCES Extras(Extras_ID);

	--relationships from other tables to CD_Title table 

ALTER TABLE Artists 
ADD FOREIGN KEY (CD_ID) REFERENCES CD_Title(CD_ID);

ALTER TABLE Genre 
ADD FOREIGN KEY (CD_ID) REFERENCES CD_Title(CD_ID);

ALTER TABLE Recording_Studio 
ADD FOREIGN KEY (CD_ID) REFERENCES CD_Title(CD_ID);

ALTER TABLE Dates 
ADD FOREIGN KEY (CD_ID) REFERENCES CD_Title(CD_ID);

ALTER TABLE Extras 
ADD FOREIGN KEY (CD_ID) REFERENCES CD_Title(CD_ID);

--relationships from Artist table to Extras table

ALTER TABLE Artists 
ADD Extras_ID int;

ALTER TABLE Artists
ADD FOREIGN KEY (Extras_ID) REFERENCES Extras(Extras_ID);

--relationships of Recording_Studio table and Artist table

ALTER TABLE Artists 
ADD Studio_ID int;

ALTER TABLE Recording_Studio
ADD Artist_ID int;

ALTER TABLE Artists
ADD FOREIGN KEY (Studio_ID) REFERENCES Recording_Studio(Studio_ID);

ALTER TABLE Recording_Studio
ADD FOREIGN KEY (Artist_ID) REFERENCES Artists(Artist_ID);	


