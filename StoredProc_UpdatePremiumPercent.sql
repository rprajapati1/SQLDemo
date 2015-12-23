

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('uspPremiumPercentUpdate') AND type in (N'P', N'PC'))
DROP PROCEDURE uspPremiumPercentUpdate
GO

CREATE PROCEDURE uspPremiumPercentUpdate

AS

/* Logic for getting the appropriate scholarship premium percentage values to be paid by the student*/
Select finalquery.EnrollmentId, finalquery.PremiumPercent 
INTO #TempPremiumPercentUpdate
FROM
(
SELECT priority.EnrollmentId, priority.PremiumPercent 
FROM
  (
    SELECT distinct source.EnrollmentId
      ,source.StudentId
      ,source.Age 
      ,source.EligStatusCode
      ,source.PremiumPercent
      -- Building the logic for priority
      ,row_number() over (partition by source.EnrollmentId,source.StudentId,source.EligStatusCode order by source.EnrollmentId,source.StudentId,source.EligStatusCode,source.ProgramCode asc) as rownum
    FROM
    (
      SELECT distinct enroll.EnrollmentId
        ,stud.StudentId
        ,stud.Age 
        ,CASE WHEN (elig.EligibilityStatusCode='DN') THEN 'TN' ELSE elig.EligibilityStatusCode END as EligStatusCode
        ,CASE WHEN (elig.ProgramCode = 'PARTIAL') THEN            --Determining the Premium Percentage to be paid by the student
          CASE WHEN (stud.Age >= 35) THEN '50'                    --depending on his/her age and eligibility 
          ELSE 
            CASE WHEN (stud.Age >= 30 and stud.Age < 35) THEN '40'
            ELSE
              CASE WHEN (stud.Age >= 25 and stud.Age < 30) THEN '30'
              ELSE
                CASE WHEN (stud.Age >= 20 and stud.Age < 25) THEN '20'
                ELSE '10'
                END
              END
            END
          END
        ELSE '0'
        END as PremiumPercent
      FROM Enrollment enroll                                                                                                                                                                                                                                                                                                                                                     
      INNER JOIN Student stud                                                                                                                                                                         
        ON enroll.StudentId=stud.StudentId                                                                                                                                                                                                                                                                                                                                                   
      INNER JOIN Scholarship sch                                                                                                                                                                           
        ON enroll.ScholarshipId=sch.ScholarshipId                                                                                                                                                                       
      INNER JOIN Eligibility elig                                                                                                                                                                         
        ON enroll.StudentId=elig.StudentId  
        AND elig.EdgStatusCode = 'AP'   -- The student's eligibility should be "Approved" in the system
        AND elig.IsDelete = 'N'       -- The student's eligibility record should be active
        AND elig.ProgramCode in ('COMPANY','PARTIAL')     -- The student should be eligible for either Federal or State govt scholarship
        AND elig.EligibilityTransactionId = (SELECT max([EligibilityRunId])     -- Select the latest eligibility run for a specific student                                                                                                                                                                   
                                                  FROM Eligibility elig_inner                                                                                                             
                                                  WHERE elig_inner.StudentId=elig.StudentId    
                                                  AND elig_inner.[EdgStatusCode] = 'AP'                                                                                
                                                  AND elig_inner.IsDelete='N'                                                                                 
                                                  AND elig_inner.[ProgramCode] IN ('COMPANY','PARTIAL')                                                                                   
                                                  ) 
      WHERE      
        enroll.statuscode in ('TERM','ENRL')
        and sch.ScholarshipType = 'COMPANY'
    ) source
  ) priority
WHERE priority.rownum =1
) finalquery


/*Updating the Enrollment table*/

Update Enrollment
set PremiumPercent=TempPremiumPercentUpdate.PremiumPercent
from #TempPremiumPercentUpdate TempPremiumPercentUpdate
where Enrollment.EnrollmentId=TempPremiumPercentUpdate.EnrollmentId;


drop table #TempPremiumPercentUpdate;

GO


