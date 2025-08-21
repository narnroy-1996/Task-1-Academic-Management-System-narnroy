create database Academic_Management_System;
use database Academic_Management_System;


-- a) Create the StudentInfo table with columns STU_ ID, STU_NAME, DOB, PHONE_NO,EMAIL_ID,ADDRESS

CREATE TABLE StudentInfo (
    STU_ID INT PRIMARY KEY,
    STU_NAME VARCHAR(50),
    DOB DATE,
    PHONE_NO VARCHAR(15),
    EMAIL_ID VARCHAR(50),
    ADDRESS VARCHAR(100)
);

-- b) Create the CoursesInfo table with columns COURSE_ID,COURSE_NAME,COURSE_INSTRUCTOR NAME


CREATE TABLE CoursesInfo (
    COURSE_ID INT PRIMARY KEY,
    COURSE_NAME VARCHAR(50),
    COURSE_INSTRUCTOR_NAME VARCHAR(50)
);

-- c) Create the EnrollmentInfo with columns ENROLLMENT_ID, STU_ ID, COURSE_ID

CREATE TABLE EnrollmentInfo (
    ENROLLMENT_ID INT PRIMARY KEY,
    STU_ID INT,
    COURSE_ID INT,
    ENROLL_STATUS VARCHAR(20) CHECK (ENROLL_STATUS IN ('Enrolled', 'Not Enrolled')),
    FOREIGN KEY (STU_ID) REFERENCES StudentInfo(STU_ID),
    FOREIGN KEY (COURSE_ID) REFERENCES CoursesInfo(COURSE_ID)
);



INSERT INTO StudentInfo (STU_ID, STU_NAME, DOB, PHONE_NO, EMAIL_ID, ADDRESS) VALUES
(101, 'Ayushi Sarkar', '2004-07-30', '9897512221', 'sarkar.ayushi@gmail.com', '23 Moniporna Apartment'),
(102, 'Debayan Bagchi', '2004-03-01', '9030661929', 'bagchi.debayan@gmail.com', 'Sourthern Height Joka'),
(103, 'Debanik Dawn', '2003-12-30', '9830337975', 'dawn.debanik@msn.com', '567 Silapra Road'),
(104, 'Shubham Bhattacharya', '2004-11-21', '8678951292', 'bhat.shubham@gmail.com', '22/1 Rabindra Nagar Lane'),
(105, 'Papaye Ghosh', '2002-06-24', '9830340929', 'ghosh.papaye@outlook.com', 'Balaka Apartment Dhakuria'),
(106, 'Suman Biswas', '2003-04-18', '9874170455', 'suma.ghosh@gmail.com', '23 Salt Lake Sector V');


INSERT INTO CoursesInfo (COURSE_ID, COURSE_NAME, COURSE_INSTRUCTOR_NAME) VALUES
(1001, 'Mathematics', 'Prof. Sukumar'),
(1002, 'Geography', 'Prof. Shanku'),
(1003, 'World History', 'Prof. Anthony'),
(1004, 'Music', 'Prof. Sidhu'),
(1005, 'Chemistry', 'Prof. Abhijeet'),
(1006, 'Anthropology', 'Prof. Vivek');




INSERT INTO EnrollmentInfo (ENROLLMENT_ID, STU_ID, COURSE_ID, ENROLL_STATUS) VALUES
(400001, 101, 1001, 'Enrolled'),
(400002, 102, 1002, 'Enrolled'),
(400003, 103, 1003, 'Not Enrolled'),
(400004, 104, 1001, 'Enrolled'),
(400005, 105, 1005, 'Enrolled'),
(400006, 106, 1006, 'Not Enrolled');


-- 3) Retrieve the Student Information

-- a) Write a query to retrieve student details, such as student name, contact informations, and Enrollment status

select 
s.STU_NAME,s.PHONE_NO,s.EMAIL_ID,s.ADDRESS,e.ENROLL_STATUS
from StudentInfo s
left join EnrollmentInfo e on s.STU_ID = e.STU_ID
left join CoursesInfo c on e.COURSE_ID = c.COURSE_ID;



-- b) Write a query to retrieve a list of courses in which a specific student is enrolled

select s.STU_ID, s.STU_NAME, c.COURSE_NAME, e.ENROLL_STATUS
from StudentInfo s
inner join EnrollmentInfo e ON s.STU_ID = e.STU_ID
inner join  CoursesInfo c ON e.COURSE_ID = c.COURSE_ID
where s.STU_ID = 101 #Student ID is unique//name can be duplicate in datasets hence used studentID
AND e.ENROLL_STATUS = 'Enrolled';



-- c) Write a query to retrieve course information, including course name, instructor information

select COURSE_ID, COURSE_NAME, COURSE_INSTRUCTOR_NAME
FROM CoursesInfo;



-- d) Write a query to retrieve course information for a specific course (Example Course 1001)

select COURSE_ID,COURSE_NAME,COURSE_INSTRUCTOR_NAME
from CoursesInfo
where COURSE_ID = 1001;#Using courseid instead of name to prevent Duplication



-- e) Write a query to retrieve course information for multiple courses(example 1001,1003,1005)

select COURSE_ID, COURSE_NAME, COURSE_INSTRUCTOR_NAME
from CoursesInfo
where COURSE_ID in (1001, 1005, 1003);##Using course_id instead of course name to ensure integrity




-- Reporting and Analytics:


-- a) Write a query to retrieve the number of students enrolled in each course

select c.COURSE_ID, c.COURSE_NAME, 
Count(CASE WHEN e.ENROLL_STATUS = 'Enrolled' 
THEN 1 END) as enrolled_students  
from CoursesInfo c
left Join EnrollmentInfo e ON c.COURSE_ID = e.COURSE_ID
group by c.COURSE_ID, c.COURSE_NAME
order by enrolled_students desc;


-- b) Write a query to retrieve the list of students enrolled in a specific course(for example course id 1001)

select s.STU_ID, s.STU_NAME, c.COURSE_NAME, e.ENROLL_STATUS
from studentinfo s
inner join enrollmentinfo e ON s.STU_ID = e.STU_ID
inner join coursesinfo c ON e.COURSE_ID = c.COURSE_ID
where c.COURSE_ID = 1001 and e.ENROLL_STATUS = 'Enrolled'; #used course_id as it reduced chance of duplication

-- c) Write a query to retrieve the count of enrolled students for each instructor

select c.COURSE_INSTRUCTOR_NAME, COUNT(*) as enrolled_students
from CoursesInfo c
inner join EnrollmentInfo e ON c.COURSE_ID = e.COURSE_ID
where e.ENROLL_STATUS = 'Enrolled'
group by COURSE_INSTRUCTOR_NAME
order by COURSE_INSTRUCTOR_NAME desc;

-- d) Write a query to retrieve the list of students who are enrolled in multiple courses
#(null output as no student in multiple courses)
select s.STU_ID, s.STU_NAME, count(*) as no_of_courses
from studentinfo s
inner join enrollmentinfo e ON s.STU_ID = e.STU_ID
where e.ENROLL_STATUS = 'Enrolled'
group by s.STU_ID, s.STU_NAME having count(*) > 1;


-- e) Write a query to retrieve the courses that have the highest number of enrolled students(arranging from highest to lowest

select c.COURSE_ID, c.COURSE_NAME, c.COURSE_INSTRUCTOR_NAME, count(*) as no_of_enrolled_students
from coursesinfo c
inner join enrollmentinfo e ON c.COURSE_ID = e.COURSE_ID
where e.ENROLL_STATUS = 'Enrolled'
group by c.COURSE_ID, c.COURSE_NAME, c.COURSE_INSTRUCTOR_NAME
order by no_of_enrolled_students DESC;

