CREATE TABLE Eligibility (
EligibilityId INT IDENTITY(1,1) NOT NULL,
EligibilityRunId INT IDENTITY(1,1) NOT NULL,
StudentId INT NOT NULL,
ProgramCode VARCHAR(10) NOT NULL,
EligibilityBeginDate INT NOT NULL,
EligibilityEndDate INT NULL,
EligibilityStatusCode VARCHAR(2) NOT NULL,
IsDelete VARCHAR(1) NOT NULL,
CONSTRAINT pk_EligibilityId PRIMARY KEY (EligibilityId)
);

ALTER TABLE Eligibility
ADD CONSTRAINT fk_StudentId FOREIGN KEY (StudentId) REFERENCES Student(StudentId)