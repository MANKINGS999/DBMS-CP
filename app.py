from flask import Flask, render_template
from database import get_db_connection
from flask import Flask, render_template, request, redirect, url_for
from database import get_db_connection

app = Flask(__name__)


@app.route("/")
def home():
    return render_template("login.html")


@app.route("/dashboard")
def dashboard():

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    # Basic counts
    cursor.execute("SELECT COUNT(*) AS count FROM Student")
    total_students = cursor.fetchone()["count"]

    cursor.execute("SELECT COUNT(*) AS count FROM Company")
    total_companies = cursor.fetchone()["count"]

    cursor.execute("SELECT COUNT(*) AS count FROM Job")
    total_jobs = cursor.fetchone()["count"]

    cursor.execute("SELECT COUNT(*) AS count FROM Placement")
    total_placements = cursor.fetchone()["count"]

    # Application status counts
    cursor.execute("""
        SELECT status, COUNT(*) AS count
        FROM Application
        GROUP BY status
    """)
    status_data = cursor.fetchall()

    # Company-wise applications
    cursor.execute("""
        SELECT
            c.company_name,
            COUNT(a.application_id) AS applications
        FROM Company c
        JOIN Job j
            ON c.company_id = j.company_id
        LEFT JOIN Application a
            ON j.job_id = a.job_id
        GROUP BY c.company_id, c.company_name
        ORDER BY applications DESC
    """)
    company_data = cursor.fetchall()

    # Package statistics
    cursor.execute("""
        SELECT
            AVG(package) AS average_package,
            MAX(package) AS highest_package
        FROM Placement
    """)
    package_data = cursor.fetchone()

    cursor.close()
    db.close()

    return render_template(
        "dashboard.html",
        total_students=total_students,
        total_companies=total_companies,
        total_jobs=total_jobs,
        total_placements=total_placements,
        status_data=status_data,
        company_data=company_data,
        average_package=package_data["average_package"],
        highest_package=package_data["highest_package"]
    )

@app.route("/students")
def students():
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute("""
        SELECT student_id, name, email, phone, branch, cgpa
        FROM Student
        ORDER BY student_id
    """)

    students = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template("students.html", students=students)


@app.route("/students/add", methods=["GET", "POST"])
def add_student():

    if request.method == "POST":

        name = request.form["name"]
        email = request.form["email"]
        phone = request.form["phone"]
        branch = request.form["branch"]
        cgpa = request.form["cgpa"]
        graduation_year = request.form["graduation_year"]

        db = get_db_connection()
        cursor = db.cursor()

        cursor.execute("""
            INSERT INTO Student
            (name, email, phone, branch, cgpa,graduation_year)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (name, email, phone, branch, cgpa,graduation_year))

        db.commit()

        cursor.close()
        db.close()

        return redirect(url_for("students"))

    return render_template("add_student.html")


@app.route("/students/delete/<int:student_id>", methods=["POST"])
def delete_student(student_id):

    db = get_db_connection()
    cursor = db.cursor()

    cursor.execute(
        "DELETE FROM Student WHERE student_id = %s",
        (student_id,)
    )

    db.commit()

    cursor.close()
    db.close()

    return redirect(url_for("students"))

@app.route("/companies")
def companies():
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute("""
        SELECT company_id, company_name, industry, location
        FROM Company
        ORDER BY company_id
    """)

    companies = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template("companies.html", companies=companies)


@app.route("/companies/add", methods=["GET", "POST"])
def add_company():

    if request.method == "POST":

        company_name = request.form["company_name"]
        industry = request.form["industry"]
        location = request.form["location"]

        db = get_db_connection()
        cursor = db.cursor()

        cursor.execute("""
            INSERT INTO Company
            (company_name, industry, location)
            VALUES (%s, %s, %s)
        """, (company_name, industry, location))

        db.commit()

        cursor.close()
        db.close()

        return redirect(url_for("companies"))

    return render_template("add_company.html")


@app.route("/companies/delete/<int:company_id>", methods=["POST"])
def delete_company(company_id):

    db = get_db_connection()
    cursor = db.cursor()

    cursor.execute(
        "DELETE FROM Company WHERE company_id = %s",
        (company_id,)
    )

    db.commit()

    cursor.close()
    db.close()

    return redirect(url_for("companies"))

@app.route("/jobs")
def jobs():
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            j.job_id,
            j.company_id,
            c.company_name,
            j.job_role,
            j.package,
            j.location,
            j.min_cgpa
        FROM Job j
        JOIN Company c ON j.company_id = c.company_id
        ORDER BY j.job_id
    """)

    jobs = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template("jobs.html", jobs=jobs)


@app.route("/jobs/add", methods=["GET", "POST"])
def add_job():

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    if request.method == "POST":

        company_id = request.form["company_id"]
        job_role = request.form["job_role"]
        package = request.form["package"]
        location = request.form["location"]
        min_cgpa = request.form["min_cgpa"]

        cursor.execute("""
            INSERT INTO Job
            (company_id, job_role, package, location, min_cgpa)
            VALUES (%s, %s, %s, %s, %s)
        """, (
            company_id,
            job_role,
            package,
            location if location else None,
            min_cgpa if min_cgpa else None
        ))

        db.commit()

        cursor.close()
        db.close()

        return redirect(url_for("jobs"))

    cursor.execute("""
        SELECT company_id, company_name
        FROM Company
        ORDER BY company_name
    """)

    companies = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template(
        "add_job.html",
        companies=companies
    )


@app.route("/jobs/delete/<int:job_id>", methods=["POST"])
def delete_job(job_id):

    db = get_db_connection()
    cursor = db.cursor()

    cursor.execute(
        "DELETE FROM Job WHERE job_id = %s",
        (job_id,)
    )

    db.commit()

    cursor.close()
    db.close()

    return redirect(url_for("jobs"))

@app.route("/applications")
def applications():
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            a.application_id,
            a.student_id,
            s.name AS student_name,
            a.job_id,
            c.company_name,
            j.job_role,
            j.package,
            a.applied_date,
            a.status
        FROM Application a
        JOIN Student s ON a.student_id = s.student_id
        JOIN Job j ON a.job_id = j.job_id
        JOIN Company c ON j.company_id = c.company_id
        ORDER BY a.application_id
    """)

    applications = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template(
        "applications.html",
        applications=applications
    )


@app.route("/applications/add", methods=["GET", "POST"])
def add_application():

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    if request.method == "POST":

        student_id = request.form["student_id"]
        job_id = request.form["job_id"]
        applied_date = request.form["applied_date"]
        status = request.form["status"]

        cursor.execute("""
            INSERT INTO Application
            (student_id, job_id, applied_date, status)
            VALUES (%s, %s, %s, %s)
        """, (
            student_id,
            job_id,
            applied_date,
            status
        ))

        db.commit()

        cursor.close()
        db.close()

        return redirect(url_for("applications"))

    cursor.execute("""
        SELECT student_id, name
        FROM Student
        ORDER BY name
    """)

    students = cursor.fetchall()

    cursor.execute("""
        SELECT
            j.job_id,
            j.job_role,
            c.company_name,
            j.package
        FROM Job j
        JOIN Company c ON j.company_id = c.company_id
        ORDER BY c.company_name, j.job_role
    """)

    jobs = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template(
        "add_application.html",
        students=students,
        jobs=jobs
    )


@app.route("/applications/delete/<int:application_id>", methods=["POST"])
def delete_application(application_id):

    db = get_db_connection()
    cursor = db.cursor()

    cursor.execute(
        "DELETE FROM Application WHERE application_id = %s",
        (application_id,)
    )

    db.commit()

    cursor.close()
    db.close()

    return redirect(url_for("applications"))

@app.route("/interviews")
def interviews():

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            i.interview_id,
            i.application_id,
            s.name AS student_name,
            c.company_name,
            j.job_role,
            i.round_no,
            i.interview_date,
            i.result
        FROM Interview i
        JOIN Application a
            ON i.application_id = a.application_id
        JOIN Student s
            ON a.student_id = s.student_id
        JOIN Job j
            ON a.job_id = j.job_id
        JOIN Company c
            ON j.company_id = c.company_id
        ORDER BY i.interview_date, i.interview_id
    """)

    interviews = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template(
        "interviews.html",
        interviews=interviews
    )


@app.route("/interviews/add", methods=["GET", "POST"])
def add_interview():

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    if request.method == "POST":

        application_id = request.form["application_id"]
        round_no = request.form["round_no"]
        interview_date = request.form["interview_date"]
        result = request.form["result"]

        cursor.execute("""
            INSERT INTO Interview
            (application_id, round_no, interview_date, result)
            VALUES (%s, %s, %s, %s)
        """, (
            application_id,
            round_no,
            interview_date if interview_date else None,
            result if result else None
        ))

        db.commit()

        cursor.close()
        db.close()

        return redirect(url_for("interviews"))

    cursor.execute("""
        SELECT
            a.application_id,
            s.name AS student_name,
            c.company_name,
            j.job_role
        FROM Application a
        JOIN Student s
            ON a.student_id = s.student_id
        JOIN Job j
            ON a.job_id = j.job_id
        JOIN Company c
            ON j.company_id = c.company_id
        WHERE a.status IN ('Shortlisted', 'Selected')
        ORDER BY a.application_id
    """)

    applications = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template(
        "add_interview.html",
        applications=applications
    )


@app.route("/interviews/delete/<int:interview_id>", methods=["POST"])
def delete_interview(interview_id):

    db = get_db_connection()
    cursor = db.cursor()

    cursor.execute(
        "DELETE FROM Interview WHERE interview_id = %s",
        (interview_id,)
    )

    db.commit()

    cursor.close()
    db.close()

    return redirect(url_for("interviews"))

@app.route("/placements")
def placements():

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            p.placement_id,
            p.student_id,
            s.name AS student_name,
            p.job_id,
            c.company_name,
            j.job_role,
            p.offer_date,
            p.package
        FROM Placement p
        JOIN Student s
            ON p.student_id = s.student_id
        JOIN Job j
            ON p.job_id = j.job_id
        JOIN Company c
            ON j.company_id = c.company_id
        ORDER BY p.offer_date, p.placement_id
    """)

    placements = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template(
        "placements.html",
        placements=placements
    )


@app.route("/placements/add", methods=["GET", "POST"])
def add_placement():

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    if request.method == "POST":

        student_id = request.form["student_id"]
        job_id = request.form["job_id"]
        offer_date = request.form["offer_date"]
        package = request.form["package"]

        cursor.execute("""
            INSERT INTO Placement
            (student_id, job_id, offer_date, package)
            VALUES (%s, %s, %s, %s)
        """, (
            student_id,
            job_id,
            offer_date,
            package
        ))

        db.commit()

        cursor.close()
        db.close()

        return redirect(url_for("placements"))

    cursor.execute("""
        SELECT
            a.student_id,
            s.name AS student_name,
            a.job_id,
            c.company_name,
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
        ORDER BY s.name
    """)

    selected_applications = cursor.fetchall()

    cursor.close()
    db.close()

    return render_template(
        "add_placement.html",
        selected_applications=selected_applications
    )


@app.route("/placements/delete/<int:placement_id>", methods=["POST"])
def delete_placement(placement_id):

    db = get_db_connection()
    cursor = db.cursor()

    cursor.execute(
        "DELETE FROM Placement WHERE placement_id = %s",
        (placement_id,)
    )

    db.commit()

    cursor.close()
    db.close()

    return redirect(url_for("placements"))

if __name__ == "__main__":
    app.run(debug=True)