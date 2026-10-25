create database placement_management;
use placement_management;

show databases;

CREATE TABLE Student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    branch VARCHAR(50) NOT NULL,
    cgpa DECIMAL(3,2) CHECK (cgpa BETWEEN 0 AND 10),
    graduation_year INT NOT NULL
);

CREATE TABLE Company (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(100) NOT NULL,
    industry VARCHAR(100),
    location VARCHAR(100)
);

CREATE TABLE Job (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    job_role VARCHAR(100) NOT NULL,
    package DECIMAL(10,2) NOT NULL,
    location VARCHAR(100),
    min_cgpa DECIMAL(3,2),
    
    FOREIGN KEY (company_id)
        REFERENCES Company(company_id)
);

CREATE TABLE Application (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    job_id INT NOT NULL,
    applied_date DATE NOT NULL,
    status VARCHAR(30) DEFAULT 'Applied',

    FOREIGN KEY (student_id)
        REFERENCES Student(student_id),

    FOREIGN KEY (job_id)
        REFERENCES Job(job_id),

    UNIQUE (student_id, job_id)
);

CREATE TABLE Skill (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Student_Skill (
    student_id INT,
    skill_id INT,
    proficiency VARCHAR(30),

    PRIMARY KEY (student_id, skill_id),

    FOREIGN KEY (student_id)
        REFERENCES Student(student_id),

    FOREIGN KEY (skill_id)
        REFERENCES Skill(skill_id)
);

CREATE TABLE Interview (
    interview_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT NOT NULL,
    round_no INT NOT NULL,
    interview_date DATE,
    result VARCHAR(30),

    FOREIGN KEY (application_id)
        REFERENCES Application(application_id)
);
CREATE TABLE Placement (
    placement_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    job_id INT NOT NULL,
    offer_date DATE NOT NULL,
    package DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (student_id)
        REFERENCES Student(student_id),

    FOREIGN KEY (job_id)
        REFERENCES Job(job_id),

    UNIQUE (student_id)
);

USE placement_management;

INSERT INTO Company (company_name, industry, location) VALUES
('Google', 'Technology', 'Bangalore'),
('Microsoft', 'Technology', 'Hyderabad'),
('Amazon', 'E-Commerce', 'Bangalore'),
('TCS', 'IT Services', 'Pune'),
('Infosys', 'IT Services', 'Pune'),
('Accenture', 'Consulting', 'Mumbai'),
('Deloitte', 'Consulting', 'Mumbai'),
('Wipro', 'IT Services', 'Bangalore');

INSERT INTO Student
(name, email, phone, branch, cgpa, graduation_year)
VALUES
('Aarav Sharma', 'aarav.sharma@gmail.com', '9876543210', 'CSE', 9.20, 2027),
('Aditya Patil', 'aditya.patil@gmail.com', '9876543211', 'CSE', 8.75, 2027),
('Ananya Kulkarni', 'ananya.kulkarni@gmail.com', '9876543212', 'CSE-AI', 9.10, 2027),
('Arjun Deshmukh', 'arjun.deshmukh@gmail.com', '9876543213', 'ENTC', 8.40, 2027),
('Ishita Joshi', 'ishita.joshi@gmail.com', '9876543214', 'CSE', 9.45, 2027),
('Rohan More', 'rohan.more@gmail.com', '9876543215', 'IT', 8.65, 2027),
('Sneha Patil', 'sneha.patil@gmail.com', '9876543216', 'CSE-AI', 9.30, 2027),
('Kunal Shah', 'kunal.shah@gmail.com', '9876543217', 'IT', 8.15, 2027),
('Priya Nair', 'priya.nair@gmail.com', '9876543218', 'CSE', 9.05, 2027),
('Rahul Jadhav', 'rahul.jadhav@gmail.com', '9876543219', 'ENTC', 7.95, 2027),
('Neha Desai', 'neha.desai@gmail.com', '9876543220', 'CSE', 8.90, 2027),
('Siddhant Pawar', 'siddhant.pawar@gmail.com', '9876543221', 'IT', 8.25, 2027),
('Meera Gupta', 'meera.gupta@gmail.com', '9876543222', 'CSE-AI', 9.50, 2027),
('Vivek Chavan', 'vivek.chavan@gmail.com', '9876543223', 'CSE', 8.55, 2027),
('Tanvi Bhosale', 'tanvi.bhosale@gmail.com', '9876543224', 'IT', 9.15, 2027),
('Akash Shinde', 'akash.shinde@gmail.com', '9876543225', 'ENTC', 8.05, 2027),
('Riya Mehta', 'riya.mehta@gmail.com', '9876543226', 'CSE', 9.35, 2027),
('Omkar Kulkarni', 'omkar.kulkarni@gmail.com', '9876543227', 'CSE-AI', 8.35, 2027),
('Sakshi Wagh', 'sakshi.wagh@gmail.com', '9876543228', 'IT', 8.95, 2027),
('Yash Thakur', 'yash.thakur@gmail.com', '9876543229', 'CSE', 7.80, 2027);

select * from Student;

INSERT INTO Job
(company_id, job_role, package, location, min_cgpa)
VALUES
(1, 'Software Engineer', 28.00, 'Bangalore', 9.00),
(1, 'Data Analyst', 18.00, 'Bangalore', 8.50),

(2, 'Software Engineer', 25.00, 'Hyderabad', 8.50),
(2, 'Cloud Engineer', 22.00, 'Hyderabad', 8.00),

(3, 'SDE-I', 24.00, 'Bangalore', 8.50),
(3, 'Data Engineer', 20.00, 'Bangalore', 8.00),

(4, 'Graduate Engineer Trainee', 7.50, 'Pune', 7.50),
(4, 'Software Developer', 10.00, 'Pune', 8.00),

(5, 'Systems Engineer', 6.50, 'Pune', 7.00),
(5, 'Data Analyst', 8.00, 'Pune', 7.50),

(6, 'Associate Software Engineer', 8.50, 'Mumbai', 7.50),
(6, 'Business Analyst', 9.00, 'Mumbai', 8.00),

(7, 'Technology Analyst', 10.00, 'Mumbai', 8.00),
(7, 'Risk Analyst', 9.50, 'Mumbai', 7.50),

(8, 'Project Engineer', 7.00, 'Bangalore', 7.50),
(8, 'Software Developer', 9.00, 'Bangalore', 8.00);

INSERT INTO Skill (skill_name) VALUES
('C++'),
('Python'),
('Java'),
('SQL'),
('Machine Learning'),
('Data Structures'),
('React'),
('JavaScript'),
('AWS'),
('Docker'),
('Communication'),
('Problem Solving');

INSERT INTO Student_Skill (student_id, skill_id, proficiency) VALUES
(1, 1, 'Advanced'),
(1, 2, 'Advanced'),
(1, 4, 'Advanced'),
(1, 6, 'Advanced'),

(2, 1, 'Advanced'),
(2, 4, 'Intermediate'),
(2, 6, 'Advanced'),
(2, 7, 'Intermediate'),

(3, 2, 'Advanced'),
(3, 4, 'Advanced'),
(3, 5, 'Advanced'),
(3, 8, 'Intermediate'),

(4, 1, 'Intermediate'),
(4, 3, 'Intermediate'),
(4, 6, 'Advanced'),
(4, 12, 'Advanced'),

(5, 2, 'Advanced'),
(5, 4, 'Advanced'),
(5, 5, 'Advanced'),
(5, 6, 'Advanced'),

(6, 1, 'Advanced'),
(6, 4, 'Advanced'),
(6, 8, 'Intermediate'),
(6, 10, 'Intermediate'),

(7, 2, 'Advanced'),
(7, 4, 'Advanced'),
(7, 5, 'Advanced'),
(7, 9, 'Intermediate'),

(8, 1, 'Intermediate'),
(8, 2, 'Intermediate'),
(8, 6, 'Advanced'),

(9, 2, 'Advanced'),
(9, 4, 'Advanced'),
(9, 7, 'Advanced'),
(9, 8, 'Advanced'),

(10, 1, 'Intermediate'),
(10, 6, 'Advanced'),
(10, 11, 'Advanced'),

(11, 2, 'Advanced'),
(11, 4, 'Advanced'),
(11, 6, 'Advanced'),
(11, 12, 'Advanced'),

(12, 1, 'Advanced'),
(12, 3, 'Intermediate'),
(12, 4, 'Intermediate'),

(13, 2, 'Advanced'),
(13, 4, 'Advanced'),
(13, 5, 'Advanced'),
(13, 9, 'Advanced'),

(14, 1, 'Advanced'),
(14, 4, 'Advanced'),
(14, 6, 'Advanced'),

(15, 2, 'Advanced'),
(15, 4, 'Advanced'),
(15, 5, 'Intermediate'),
(15, 7, 'Advanced'),

(16, 1, 'Intermediate'),
(16, 6, 'Advanced'),
(16, 12, 'Advanced'),

(17, 2, 'Advanced'),
(17, 4, 'Advanced'),
(17, 7, 'Advanced'),
(17, 8, 'Advanced'),

(18, 1, 'Advanced'),
(18, 2, 'Intermediate'),
(18, 6, 'Advanced'),

(19, 2, 'Advanced'),
(19, 4, 'Advanced'),
(19, 8, 'Intermediate'),

(20, 1, 'Intermediate'),
(20, 6, 'Intermediate'),
(20, 11, 'Advanced');

SELECT COUNT(*) AS total_students FROM Student;

SELECT COUNT(*) AS total_companies FROM Company;

SELECT COUNT(*) AS total_jobs FROM Job;

SELECT COUNT(*) AS total_skills FROM Skill;

SELECT COUNT(*) AS total_student_skills FROM Student_Skill;

INSERT INTO Application
(student_id, job_id, applied_date, status)
VALUES
(1, 1, '2026-08-01', 'Selected'),
(1, 3, '2026-08-03', 'Shortlisted'),

(2, 3, '2026-08-02', 'Selected'),
(2, 5, '2026-08-04', 'Rejected'),

(3, 1, '2026-08-01', 'Selected'),
(3, 6, '2026-08-05', 'Shortlisted'),
(3, 10, '2026-08-07', 'Rejected'),

(4, 7, '2026-08-02', 'Shortlisted'),
(4, 11, '2026-08-06', 'Rejected'),

(5, 1, '2026-08-01', 'Selected'),
(5, 3, '2026-08-03', 'Shortlisted'),
(5, 5, '2026-08-04', 'Rejected'),

(6, 5, '2026-08-03', 'Shortlisted'),
(6, 8, '2026-08-05', 'Selected'),
(6, 15, '2026-08-08', 'Rejected'),

(7, 1, '2026-08-01', 'Selected'),
(7, 6, '2026-08-04', 'Shortlisted'),

(8, 7, '2026-08-02', 'Rejected'),
(8, 9, '2026-08-05', 'Shortlisted'),

(9, 2, '2026-08-01', 'Selected'),
(9, 4, '2026-08-03', 'Shortlisted'),
(9, 10, '2026-08-06', 'Rejected'),

(10, 7, '2026-08-02', 'Shortlisted'),
(10, 11, '2026-08-06', 'Rejected'),

(11, 3, '2026-08-02', 'Selected'),
(11, 8, '2026-08-05', 'Shortlisted'),

(12, 7, '2026-08-03', 'Rejected'),
(12, 15, '2026-08-07', 'Shortlisted'),

(13, 1, '2026-08-01', 'Selected'),
(13, 6, '2026-08-04', 'Shortlisted'),
(13, 13, '2026-08-07', 'Rejected'),

(14, 3, '2026-08-02', 'Shortlisted'),
(14, 8, '2026-08-05', 'Selected'),

(15, 2, '2026-08-01', 'Selected'),
(15, 4, '2026-08-03', 'Shortlisted'),

(16, 7, '2026-08-03', 'Rejected'),
(16, 11, '2026-08-06', 'Shortlisted'),

(17, 1, '2026-08-01', 'Selected'),
(17, 2, '2026-08-03', 'Shortlisted'),

(18, 5, '2026-08-02', 'Shortlisted'),
(18, 8, '2026-08-05', 'Selected'),

(19, 9, '2026-08-03', 'Shortlisted'),
(19, 15, '2026-08-07', 'Rejected'),

(20, 7, '2026-08-02', 'Rejected'),
(20, 11, '2026-08-06', 'Shortlisted');

SELECT COUNT(*) AS total_applications
FROM Application;

SELECT 
    i.interview_id,
    s.name AS student,
    c.company_name AS company,
    j.job_role,
    i.round_no,
    i.interview_date,
    i.result
FROM Interview i
JOIN Application a ON i.application_id = a.application_id
JOIN Student s ON a.student_id = s.student_id
JOIN Job j ON a.job_id = j.job_id
JOIN Company c ON j.company_id = c.company_id
ORDER BY i.interview_date, s.name;

SELECT 
    a.application_id,
    s.name AS student,
    c.company_name AS company,
    j.job_role,
    j.package,
    a.status
FROM Application a
JOIN Student s 
    ON a.student_id = s.student_id
JOIN Job j 
    ON a.job_id = j.job_id
JOIN Company c 
    ON j.company_id = c.company_id
ORDER BY a.application_id;

SELECT
    a.application_id,
    s.student_id,
    s.name,
    c.company_name,
    j.job_id,
    j.job_role,
    j.package
FROM Application a
JOIN Student s
    ON a.student_id = s.student_id
JOIN Job j
    ON a.job_id = j.job_id
JOIN Company c
    ON j.company_id = c.company_id
WHERE a.status = 'Selected'
ORDER BY a.application_id;

INSERT INTO Placement
(student_id, job_id, offer_date, package)
VALUES
(1, 1, '2026-08-14', 28.00),
(2, 3, '2026-08-15', 25.00),
(3, 1, '2026-08-15', 28.00),
(5, 1, '2026-08-15', 28.00),
(6, 8, '2026-08-15', 10.00),
(7, 1, '2026-08-15', 28.00),
(9, 2, '2026-08-15', 18.00),
(11, 3, '2026-08-15', 25.00),
(13, 1, '2026-08-16', 28.00),
(14, 8, '2026-08-16', 10.00),
(15, 2, '2026-08-16', 18.00),
(17, 1, '2026-08-16', 28.00),
(18, 8, '2026-08-16', 10.00);

SELECT
    p.placement_id,
    s.name AS student,
    s.branch,
    c.company_name AS company,
    j.job_role,
    p.package,
    p.offer_date
FROM Placement p
JOIN Student s
    ON p.student_id = s.student_id
JOIN Job j
    ON p.job_id = j.job_id
JOIN Company c
    ON j.company_id = c.company_id
ORDER BY p.package DESC;

CREATE VIEW placement_report AS
SELECT
    p.placement_id,
    s.student_id,
    s.name AS student_name,
    s.branch,
    s.cgpa,
    c.company_name,
    j.job_role,
    p.package,
    p.offer_date
FROM Placement p
JOIN Student s
    ON p.student_id = s.student_id
JOIN Job j
    ON p.job_id = j.job_id
JOIN Company c
    ON j.company_id = c.company_id;
    
    CREATE VIEW application_details AS
SELECT
    a.application_id,
    s.student_id,
    s.name AS student_name,
    s.branch,
    c.company_name,
    j.job_role,
    j.package,
    a.applied_date,
    a.status
FROM Application a
JOIN Student s
    ON a.student_id = s.student_id
JOIN Job j
    ON a.job_id = j.job_id
JOIN Company c
    ON j.company_id = c.company_id;
    
    CREATE VIEW student_skill_details AS
SELECT
    s.student_id,
    s.name AS student_name,
    sk.skill_name,
    ss.proficiency
FROM Student_Skill ss
JOIN Student s
    ON ss.student_id = s.student_id
JOIN Skill sk
    ON ss.skill_id = sk.skill_id;