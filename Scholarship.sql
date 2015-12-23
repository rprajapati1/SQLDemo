CREATE TABLE Scholarship (
ScholarshipId INT IDENTITY(1,1) NOT NULL,
ScholarshipName VARCHAR(20) NOT NULL,
ScholarshipType VARCHAR(10) NOT NULL,
EffectiveBeginDate INT NOT NULL,
EffectiveEndDate INT NULL,
CONSTRAINT pk_ScholarshipId PRIMARY KEY (ScholarshipId)
);