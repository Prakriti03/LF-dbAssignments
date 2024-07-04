
set search_path to student_management

 -- List all students along with a row number based on their enrollment date in ascending order.
SELECT s.student_name, MIN(e.enrollment_date) AS first_enrollment_date,
row_number() over(ORDER BY MIN(e.enrollment_date) ASC) as rn
FROM Students s
JOIN Enrollments e 
ON s.student_id = e.student_id
GROUP BY s.student_name;

 -- Rank students based on the number of courses they are enrolled in, handling ties by assigning the same rank.
SELECT s.student_name,COUNT(e.course_id) as num_courses,
RANK() OVER(ORDER BY COUNT(e.course_id) desc) as rnk
FROM Students s 
LEFT JOIN Enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_name;


 -- Determine the dense rank of courses based on their enrollment count across all students
 SELECT c.course_name,COUNT(e.enrollment_id) as num_enrollments,
 DENSE_RANK() OVER(ORDER BY COUNT(e.enrollment_id) desc) as rnk
 FROM Courses "c"
 JOIN Enrollments e
 ON c.course_id = e.course_id
 GROUP BY c.course_name;

	 -- Retrieve the list of students and their enrolled courses.
 SELECT s.student_name, c.course_name
 FROM Students s
 JOIN Enrollments e ON s.student_id = e.student_id
 JOIN Courses "c" ON e.course_id = c.course_id;
 
 -- List all students and their enrolled courses, including those who haven't enrolled in any course.
  SELECT s.student_name, c.course_name
 FROM Students s
 LEFT JOIN Enrollments e ON s.student_id = e.student_id
 LEFT JOIN Courses "c" ON e.course_id = c.course_id;
 
-- Display all courses and the students enrolled in each course, including courses with no enrolled students.
 SELECT s.student_name, c.course_name
 FROM Students s
 RIGHT JOIN Enrollments e ON s.student_id = e.student_id
 RIGHT JOIN Courses "c" ON e.course_id = c.course_id;

-- Find pairs of students who are enrolled in at least one common course.
SELECT s1.student_name, s2.student_name
FROM Enrollments e1
JOIN Enrollments e2 ON e1.course_id = e2.course_id AND e1.student_id<e2.student_id
JOIN Students s1 ON e1.student_id = s1.student_id
JOIN Students s2 ON e2.student_id = s2.student_id
GROUP BY s1.student_name, s2.student_name;

-- Retrieve students who are enrolled in 'Introduction to CS' but not in 'Data Structures'.
SELECT 
    S.student_name
FROM 
    Students S
INNER JOIN 
    Enrollments E1 ON S.student_id = E1.student_id
INNER JOIN 
    Courses C1 ON E1.course_id = C1.course_id
WHERE 
    C1.course_name = 'Introduction to CS'
    AND S.student_id NOT IN (
        SELECT 
            E2.student_id
        FROM 
            Enrollments E2
        INNER JOIN 
            Courses C2 ON E2.course_id = C2.course_id
        WHERE 
            C2.course_name = 'Data Structures'
);


 