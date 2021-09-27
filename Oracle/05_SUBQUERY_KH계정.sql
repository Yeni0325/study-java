/*
    * 서브쿼리 (SUBQUERY)
    - 하나의 SQL문 안에 포함된 또다른 SELECT문
    - 메인 SAL문을 위해 보조 역할을 하는 쿼리문
*/

-- 간단한 서브쿼리 예시 1.
-- 노옹철 사원과 같은 부서에 속한 사원들을 조회하고 싶음!

-- 1) 먼저 노옹철 사원의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';   -- 노옹철 사원이 'D9'인걸 알아냄!!

-- 2) 부서코드가 D9인 사원들 조회 
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

--> 위의 2단계를 하나의 쿼리문으로 합쳐보자
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '노옹철'); --부서코드가 노옹철 사원과 일치하는 부서코드
                    
                    
-- 간단한 서브쿼리 예시 2.
-- 전 직원의 평균 급여보다 더 많은 급여를 받는 사원들의 사번, 이름, 직급코드, 급여 조회

-- 1) 전 직원의 평균 급여 조회
SELECT AVG(SALARY)
FROM EMPLOYEE;  --> 전 직원들의 평균급여가 대략 3047663원 인걸 알아냄

-- 2) 급여값이 3047663원 이상인 사원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3047663;

-- 위의 2단계를 하나의 쿼리문으로 합쳐보자
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY)
                 FROM EMPLOYEE);

----------------------------------------------------------------------------------------------

/*
    * 서브쿼리의 구분
      서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라서 서브쿼리의 종류가 구분된다.
      
      - 단일행 서브쿼리 : 서브쿼리의 조회 결과값의 갯수가 오로지 1개일 때 (한 행, 한 열)
      - 다중행 서브쿼리 : 서브쿼리의 조회 결과값이 여러행일 때 (여러 행, 한 열)
      - 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 한 행이지만 컬럼이 여러개일 때 (한 행, 여러 열)
      - 다중행 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 여러 행, 여러 컬럼일 때 (여러 행, 여러 열)
      
      => 서브쿼리의 종류가 뭐냐에 따라서 서브쿼리 앞에 붙는 연산자가 달라진다.
*/
/*
    1. 단일행 서브쿼리 (SINGLE ROW SUBQUERY)
    서브쿼리의 조회 결과값의 갯수가 오로지 1개일 때 (한 행, 한 열)
    일반 비교연산자 사용가능
    = != ^= > < >=, ...
*/
-- 1) 전 직원의 평균급여보다 급여를 더 적게 받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE)
ORDER BY SALARY;

-- 2) 최저 급여를 받는 사원의 사번, 이름, 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);
                
-- 3) 노옹철 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철');

-- JOIN절 사용
-- 노옹철 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 급여, 부서명 조회
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철')
  AND DEPT_CODE = DEPT_ID;

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철');

-- 4) 부서별 급여합이 가장 큰 부서의 부서코드, 급여 합 조회
-- 4-1) 먼저 부서별 급여합 중에서도 가장 큰 값 하나만 조회
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- 17700000인걸 알아냄

-- 4-2) 부서별 급여합이 17700000원인 부서 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

-- 위의 두 단계를 하나의 쿼리문으로 합쳐보자
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE);
                      

-- 5) 전지연 사원과 같은 부서원들의 사번, 사원명, 전화번호, 입사일, 부서명 조회
--    단, 전지연은 제외

-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID 
  AND DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '전지연')
 AND EMP_NAME != '전지연';                        
 
-->> ANSI 전용 구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '전지연')
  AND EMP_NAME != '전지연';
  
----------------------------------------------------------------------------------------
/*
    2. 다중행 서브쿼리 (MULTI ROW SUBQUERY)
    서브쿼리를 수행한 결과값이 여러 행일 때 (컬럼은 한개!)
    
    - 1) IN 서브쿼리 : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면
    
    - > ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 클 경우 조회(여러개의 결과값 중에서 가장 작은값보다 클 경우)
    - < ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 작을 경우 조회(여러개의 결과값 중에서 가장 큰값보다 작을 경우)
    
        비교대상 > ANY (값1, 값2, 값3)
        비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
        => ANY는 OR로 해석이 된다.
        
    - > ALL 서브쿼리 : 여러개의 "모든" 결과값들 보다 클 경우 조회
    - < ALL 서브쿼리 : 여러개의 "모든" 결과값들 보다 작을 경우 조회 
    
        비교대상 > ALL (값1, 값2, 값3)
        비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3
        => ALL은 AND로 해석이 된다.
*/

-- 1) 유재식 또는 윤은해 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여 조회
-- 1-1) 유재식 또는 윤은해 사원이 어떤 직급인지 조회
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('유재식', '윤은해'); -- J3, J7

-- 1-2) J3, J7 직급인 사원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3', 'J7');

-- 위의 2단계를 하나의 쿼리문으로 합쳐보자
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME IN ('유재식', '윤은해'));

-- 사원 => 대리 => 과장 => 차장 => 부장 ...
-- 2) 대리 직급임에도 불구하고 과장 직급 급여들 중 최소 급여보다 많이 받는 직원들의 사번, 이름, 직급, 급여 조회
-- 2-1) 먼저 과장 직급인 사원들의 급여 조회
SELECT SALARY
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '과장'; -- 2200000, 2500000, 3760000

-- 2-2) 직급이 대리이면서 급여값이 위의 목록들 중 하나라도 큰 사원
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리' 
  AND SALARY > ANY (2200000, 2500000, 3760000);
 
-- 위의 2단계를 하나의 쿼리문으로 합쳐보자
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리' 
  AND SALARY > ANY (SELECT SALARY
               FROM EMPLOYEE 
               JOIN JOB USING (JOB_CODE)
               WHERE JOB_NAME = '과장');
               
--> 단일행 서브쿼리로도 가능!
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리' 
  AND SALARY > (SELECT MIN(SALARY)
               FROM EMPLOYEE 
               JOIN JOB USING (JOB_CODE)
               WHERE JOB_NAME = '과장');
    
-- 3) 과장직급임에도 불구하고 차장직급인 사원들의 모든 급여보다도 더 많이 받는 사원들의 사번, 사원명, 직급명, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '과장'
  AND SALARY > ALL (SELECT SALARY
                    FROM EMPLOYEE
                    JOIN JOB USING (JOB_CODE)
                    WHERE JOB_NAME = '차장');
                    
-----------------------------------------------------------------------------------------

/*
    3. 다중열 서브쿼리
    결과값은 한행이지만 나열된 컬럼수가 여러개일 경우
*/

-- 1) 하이유 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사원명, 부서코드, 직급코드, 입사일 조회
-->> 단일행 서브쿼리로도 가능하긴하다
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '하이유') -- 'D5'
  AND JOB_CODE = (SELECT JOB_CODE
                  FROM EMPLOYEE
                  WHERE EMP_NAME = '하이유'); -- 'J5'

-->> 다중열 서브쿼리
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                               FROM EMPLOYEE
                               WHERE EMP_NAME = '하이유');
                               
-- 2) 박나라 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 사번, 사원명, 직급코드, 사수사번 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '박나라');
                                
----------------------------------------------------------------------------------------------

/*
    4. 다중행 다중열 서브쿼리
    서브쿼리 조회 결과값이 여러행 여러열일 경우
*/

-- 1) 각 직급별 최소급여를 받는 사원의 사번, 사원명, 직급코드, 급여 조회
-- 1-1) 각 직급별 최소급여 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J2' AND SALARY = 3700000
   OR JOB_CODE = 'J7' AND SALARY = 1380000
   OR JOB_CODE = 'J3' AND SALARY = 3400000
   ...;
   
-- 위의 내용을 다르게 표현  
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) = ('J2', 3700000)
   OR (JOB_CODE, SALARY) = ('J7', 1380000)
   OR (JOB_CODE, SALARY) = ('J3', 3400000)
   ...;
   
-- 서브쿼리 적용
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                             FROM EMPLOYEE
                             GROUP BY JOB_CODE);
                             
-- 2) 각 부서별 최고급여를 받는 사원들의 사번, 사원명, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                              FROM EMPLOYEE
                              GROUP BY DEPT_CODE);
                              
-------------------------------------------------------------------------------------------

/*
    5. 인라인 뷰 (INLINE - VIEW)
    FROM 절에 서브쿼리를 작성한 것
    
    서브쿼리를 수행한 결과를 마치 테이블처럼 사용

*/

-- 사원들의 사번, 이름, 보너스포함연봉(별칭부여), 부서코드 조회 => 보너스포함연봉이 절대 NULL로 나오지 않도록!
-- 단, 보너스포함연봉이 3000만원 이상인 사원들만 조회
SELECT EMP_ID, EMP_NAME, (SALARY+SALARY*NVL(BONUS,0))*12 "연봉", DEPT_CODE  -- 3
FROM EMPLOYEE                                                               -- 1
WHERE (SALARY+SALARY*NVL(BONUS,0))*12 >= 30000000;                          -- 2 (WHERE절에는 바로 별칭 사용 못함)

SELECT *
FROM (SELECT EMP_ID, EMP_NAME, (SALARY+SALARY*NVL(BONUS,0))*12 "연봉", DEPT_CODE 
FROM EMPLOYEE)
WHERE 연봉 >= 30000000;

SELECT EMP_NAME, DEPT_CODE, 연봉
FROM (SELECT EMP_ID, EMP_NAME, (SALARY+SALARY*NVL(BONUS,0))*12 "연봉", DEPT_CODE 
FROM EMPLOYEE)
WHERE 연봉 >= 30000000;

SELECT EMP_NAME, DEPT_CODE, MANAGER_ID -- 오류발생 : 아래 테이블에는 MANAGER_ID가 존재하지 않기 때문
FROM (SELECT EMP_ID, EMP_NAME, (SALARY+SALARY*NVL(BONUS,0))*12 "연봉", DEPT_CODE 
FROM EMPLOYEE)
WHERE 연봉 >= 30000000;

-->> 인라인 뷰를 주로 사용하는 예 => TOP-N 분석

-- 1) 전 직원 중 급여가 가장 높은 상위 5명만 조회
-- * ROWNUM : 오라클에서 제공해주는 컬럼으로 조회된 순서대로 1번부터 순번을 부여해주는 컬럼
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;
-- FROM --> SELECT ROWNUM (이 때 순번 부여됨 => 정렬도 하기전에 이미 순번 부여) --> ORDER BY

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;
--> 정상적인 결과가 조회되지 않음! (정렬이 되기도 전에 5명이 추려지고 나서 정렬)

--> ORDER BY절이 다 수행된 결과를 가지고 ROWNUM 부여 후 5명 추려야함!
SELECT ROWNUM, E.*
FROM (SELECT EMP_NAME, SALARY, DEPT_CODE
      FROM EMPLOYEE
      ORDER BY SALARY DESC) E
WHERE ROWNUM <= 5;

-- 2) 가장 최근에 입사한 사원 5명의 사원명, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT *
      FROM EMPLOYEE
      ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;

-- 3) 각 부서별 평균급여가 높은 3개의 부서 조회 
SELECT DEPT_CODE, FLOOR(평균급여)
FROM (SELECT DEPT_CODE, AVG(SALARY) "평균급여"
      FROM EMPLOYEE
      GROUP BY DEPT_CODE
      ORDER BY AVG(SALARY) DESC)
WHERE ROWNUM <=3;

---------------------------------------------------------------------------------------

/*
    * 순위를 매기는 함수 (WINDOW FUNCTION)
   
   [표현법] 
    RANK() OVER(정렬기준) | DENSE_RANK() OVER(정렬기준) => 공동순위에 대한 정렬방법이 다름
    
    - RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너띄고 순위 계산
                             EX) 공동 1위가 2명이면 그 다음 순위는 3위
    - DENSE_RANK() OVER(정렬기준) : 동일한 순위가 있다 해도 그 다음 순위를 무조건 1씩 증가시킴
                                   EX) 공동 1위가 2명이더라도 그 다음 순위는 2위
    
    >> 두 함수는 무조건 SELECT절에서만 사용 가능!!
*/

-- 1) 급여가 높은 순대로 순위를 매겨서 조회
-- RANK() OVER(정렬기준)
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE;
--> 공동 19위 2명 그 뒤의 순위는 21위

-- DENSE_RANK() OVER(정렬기준)
SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE;
--> 공동 19위 2명 그 뒤의 순위가 20위

-- 급여 상위 5명만 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE
WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5;  -- 오류남! (WHERE절에 사용 못함)

-->> 인라인뷰를 쓸 수 밖에 없음
SELECT *
FROM (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위"
      FROM EMPLOYEE)
WHERE 순위 <= 5;