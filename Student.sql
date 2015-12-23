CREATE TABLE Student (
StudentId INT IDENTITY(1,1) NOT NULL,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Age INT NOT NULL,
Gender VARCHAR(1) NULL,
Race VARCHAR(50) NULL,
CountryOfOrigin VARCHAR(30) NOT NULL,
CONSTRAINT pk_StudentId PRIMARY KEY (StudentId)
);