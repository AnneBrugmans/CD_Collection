--correction to relationship between Recoding_Studio (one) and CD_Title (many)
USE [CompactDiskCollection];

ALTER TABLE Recording_Studio
DROP CONSTRAINT FK__Recording__CD_ID__31EC6D26;

ALTER TABLE CD_Title
ADD Studio_ID int;

ALTER TABLE CD_Title
		ADD CONSTRAINT FK_Recording_Studio_ID
		FOREIGN KEY (Studio_ID) REFERENCES Recording_Studio (Studio_ID);

