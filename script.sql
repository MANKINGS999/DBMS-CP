DELIMITER //

CREATE PROCEDURE GetAllJobs()
BEGIN
    SELECT
        j.job_id,
        c.company_name,
        j.job_role,
        j.package,
        j.location,
        j.min_cgpa
    FROM Job j
    JOIN Company c
        ON j.company_id = c.company_id
    ORDER BY j.package DESC;
END //

DELIMITER ;

CALL GetAllJobs();

DELIMITER //

CREATE PROCEDURE GetStudentApplications(IN sid INT)
BEGIN
    SELECT
        a.application_id,
        c.company_name,
        j.job_role,
        j.package,
        a.applied_date,
        a.status
    FROM Application a
    JOIN Job j
        ON a.job_id = j.job_id
    JOIN Company c
        ON j.company_id = c.company_id
    WHERE a.student_id = sid
    ORDER BY a.applied_date DESC;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetCompanyJobs(IN cid INT)
BEGIN
    SELECT
        j.job_id,
        j.job_role,
        j.package,
        j.location,
        j.min_cgpa
    FROM Job j
    WHERE j.company_id = cid
    ORDER BY j.package DESC;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER check_placement_status
BEFORE INSERT ON Placement
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Application
        WHERE student_id = NEW.student_id
          AND job_id = NEW.job_id
          AND status = 'Selected'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student must have a selected application before placement';
    END IF;
END //

DELIMITER ;

INSERT INTO Placement
(student_id, job_id, offer_date, package)
VALUES
(20, 1, '2026-08-20', 28.00);

SHOW FULL TABLES;
SHOW PROCEDURE STATUS
WHERE Db = 'placement_management';
SHOW TRIGGERS;