##Find the number of students per Race enrolled in full Govt Sponsored scholarships in a given month

DECLARE @QueryMonth int;
DECLARE @QueryYear int;

SET @QueryMonth = 7;
SET @QueryYear = 2015;

SELECT stud.Race, count(distinct stud.StudentId) as StudentCount 
FROM Student stud                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
INNER JOIN Eligibility elig                                                                                                                                                                         
	ON enroll.StudentId=elig.StudentId  
	AND elig.EdgStatusCode = 'AP'		-- The student's eligibility should be "Approved" in the system
	AND elig.IsDelete = 'N'				-- The student's eligibility record should be active
	AND elig.ProgramCode in ('FED','STATE')		-- The student should be eligible for either Federal or State govt scholarship
	AND elig.EligibilityTransactionId = (SELECT max([EligibilityRunId])     -- Select the latest eligibility run for a specific student                                                                                                                                                                   
                                            FROM Eligibility elig_inner                                                                                                             
                                            WHERE elig_inner.StudentId=elig.StudentId    
											AND elig_inner.[EdgStatusCode] = 'AP'                                                                                
                                            AND elig_inner.IsDelete='N'                                                                                 
                                            AND elig_inner.[ProgramCode] IN ('FED','STATE')                                                                                   
                                            AND month(elig_inner.EligibilityBeginDate)<=@QueryMonth AND year(elig_inner.EligibilityBeginDate)>=@QueryYear
											AND ((MONTH(elig_inner.EligibilityEndDate)>=@QueryMonth AND year(elig_inner.EligibilityEndDate)=@QueryYear) or year(elig_inner.EligibilityEndDate)>@QueryYear or elig_inner.EligibilityEndDate is NULL)
                                            ) 
WHERE      
	-- The enrollment and eligibility periods should be in the specified month and year                                                                                                                                                               -- 
	month(elig.EligibilityBeginDate)<=@QueryMonth AND year(elig.EligibilityBeginDate)>=@QueryYear
	AND ((MONTH(elig.EligibilityEndDate)>=@QueryMonth AND year(elig.EligibilityEndDate)=@QueryYear) or year(elig.EligibilityEndDate)>@QueryYear or elig.EligibilityEndDate is NULL)
GROUP BY stud.Race
ORDER BY count(stud.StudentId) desc
