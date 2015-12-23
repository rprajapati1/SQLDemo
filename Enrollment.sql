CREATE TABLE Enrollment (
EnrollmentId INT IDENTITY(1,1) NOT NULL,
StudentId INT NOT NULL,
ScholarshipId INT NOT NULL,
EnrollmentBeginDate INT NOT NULL,
EnrollmentEndDate INT NULL,
EnrollmentStatusCode VARCHAR(5) NOT NULL,
PremiumPercent INT NULL,
CONSTRAINT pk_EnrollmentId PRIMARY KEY (EnrollmentId)
);

ALTER TABLE Enrollment
ADD CONSTRAINT fk_StudentId FOREIGN KEY (StudentId) REFERENCES Student(StudentId)

ALTER TABLE Enrollment
ADD CONSTRAINT fk_ScholarshipId FOREIGN KEY (ScholarshipId) REFERENCES Scholarship(ScholarshipId)