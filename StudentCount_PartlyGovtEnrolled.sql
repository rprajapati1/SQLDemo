##Find the number of students enrolled in different scholarships who are eligible for partial Governmental Aid

##Find the number of students per Race enrolled in Govt Sponsored scholarships in a given month

DECLARE @QueryMonth int;
DECLARE @QueryYear int;

SET @QueryMonth = 7;
SET @QueryYear = 2015;

SELECT priority.Race, count(priority.StudentId) as StudentCount
FROM
	(
		SELECT distinct source.StudentId
			,source.Race 
			,source.EligStatusCode
			,source.EnrollmentId
			-- Building the logic for priority
			,row_number() over (partition by source.EnrollmentId,source.StudentId,source.EligStatusCode order by source.EnrollmentId,source.StudentId,source.EligStatusCode,source.ProgramCode asc) as rownum
		FROM
		(
			SELECT distinct stud.StudentId
				,stud.Race 
				,CASE WHEN (elig.EligibilityStatusCode='DN') THEN 'TN' ELSE elig.EligibilityStatusCode END as EligStatusCode
				,enroll.EnrollmentId
			FROM Enrollment enroll                                                                                                                                                                                                                                                                                                                                                     
			INNER JOIN Student stud                                                                                                                                                                         
				ON enroll.StudentId=stud.StudentId                                                                                                                                                                                                                                                                                                                                                   
			INNER JOIN Scholarship sch                                                                                                                                                                           
				ON enroll.ScholarshipId=sch.ScholarshipId                                                                                                                                                                       
			INNER JOIN Eligibility elig                                                                                                                                                                         
				ON enroll.StudentId=elig.StudentId  
				AND elig.EdgStatusCode = 'AP'		-- The student's eligibility should be "Approved" in the system
				AND elig.IsDelete = 'N'				-- The student's eligibility record should be active
				AND elig.ProgramCode in ('COMPANY','PARTIAL')  		-- The student should be eligible for either Federal or State govt scholarship
				AND elig.EligibilityTransactionId = (SELECT max([EligibilityRunId])     -- Select the latest eligibility run for a specific student                                                                                                                                                                   
			                                            FROM Eligibility elig_inner                                                                                                             
			                                            WHERE elig_inner.StudentId=elig.StudentId    
														AND elig_inner.[EdgStatusCode] = 'AP'                                                                                
			                                            AND elig_inner.IsDelete='N'                                                                                 
			                                            AND elig_inner.[ProgramCode] IN ('COMPANY','PARTIAL')                                                                                   
			                                            AND month(elig_inner.EligibilityBeginDate)<=@QueryMonth AND year(elig_inner.EligibilityBeginDate)>=@QueryYear
														AND ((MONTH(elig_inner.EligibilityEndDate)>=@QueryMonth AND year(elig_inner.EligibilityEndDate)=@QueryYear) or year(elig_inner.EligibilityEndDate)>@QueryYear or elig_inner.EligibilityEndDate is NULL)
			                                            ) 
			WHERE      
				-- The enrollment and eligibility periods should be in the specified month and year                                                                                                                                                               -- 
				month(enroll.EnrollmentBeginDate)<=@QueryMonth AND year(enroll.EnrollmentBeginDate)>=@QueryYear
				AND ((MONTH(enroll.EnrollmentEndDate)>=@QueryMonth AND year(enroll.EnrollmentEndDate)=@QueryYear) or year(enroll.EnrollmentEndDate)>@QueryYear or enroll.EnrollmentEndDate is NULL)
				AND month(elig.EligibilityBeginDate)<=@QueryMonth AND year(elig.EligibilityBeginDate)>=@QueryYear
				AND ((MONTH(elig.EligibilityEndDate)>=@QueryMonth AND year(elig.EligibilityEndDate)=@QueryYear) or year(elig.EligibilityEndDate)>@QueryYear or elig.EligibilityEndDate is NULL)
				AND enroll.statuscode in ('TERM','ENRL')
				and sch.ScholarshipType = 'COMPANY'
		) source
	) priority
WHERE priority.rownum =1
GROUP BY priority.Race
ORDER BY count(priority.StudentId) desc
