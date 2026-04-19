from flask import Blueprint, jsonify, request
from backend.db_connection import get_db
from mysql.connector import Error

admin = Blueprint('admin', __name__)

@admin.route("/submissions", methods=["GET"])
def get_submissions():
    cursor = get_db().cursor(dictionary=True)
    try:
        status = request.args.get("status")

        query = """
            SELECT s.*, u.first_name, u.last_name, c.city_name
            FROM RESTAURANTSUBMISSION s
            JOIN USER u ON s.submitted_by_user_id = u.user_id
            JOIN CITY c ON s.city_id = c.city_id
            WHERE 1=1
        """

        params = []

        if status:
            query += " AND s.status = %s"
            params.append(status)

        cursor.execute(query, tuple(params))
        results = cursor.fetchall()

        return jsonify(results), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@admin.route("/submissions/<int:submission_id>", methods=["GET"])
def get_submission(submission_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT s.*, u.first_name, u.last_name, c.city_name
            FROM RESTAURANTSUBMISSION s
            JOIN USER u ON s.submitted_by_user_id = u.user_id
            JOIN CITY c ON s.city_id = c.city_id
            WHERE s.submission_id = %s
        """, (submission_id,))

        result = cursor.fetchone()

        if not result:
            return jsonify({"error": "Submission not found"}), 404

        return jsonify(result), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@admin.route("/submissions/<int:submission_id>", methods=["PUT"])
def update_submission(submission_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        data = request.get_json()

        cursor.execute("""
            UPDATE RESTAURANTSUBMISSION
            SET status = %s,
                reviewed_by_admin_id = %s,
                reviewed_at = NOW()
            WHERE submission_id = %s
        """, (
            data["status"],
            data["admin_id"],
            submission_id
        ))

        get_db().commit()

        return jsonify({"message": "Submission updated successfully"}), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@admin.route("/complaints", methods=["GET"])
def get_complaints():
    cursor = get_db().cursor(dictionary=True)
    try:
        status = request.args.get("status")

        query = """
            SELECT uc.*, u.first_name, u.last_name, r.restaurant_name
            FROM USERCOMPLAINT uc
            JOIN USER u ON uc.user_id = u.user_id
            JOIN RESTAURANT r ON uc.restaurant_id = r.restaurant_id
            WHERE 1=1
        """

        params = []

        if status:
            query += " AND uc.status = %s"
            params.append(status)

        cursor.execute(query, tuple(params))
        results = cursor.fetchall()

        return jsonify(results), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@admin.route("/complaints/<int:complaint_id>", methods=["GET"])
def get_complaint(complaint_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT uc.*, u.first_name, u.last_name, r.restaurant_name
            FROM USERCOMPLAINT uc
            JOIN USER u ON uc.user_id = u.user_id
            JOIN RESTAURANT r ON uc.restaurant_id = r.restaurant_id
            WHERE uc.complaint_id = %s
        """, (complaint_id,))

        result = cursor.fetchone()

        if not result:
            return jsonify({"error": "Complaint not found"}), 404

        return jsonify(result), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@admin.route("/complaints/<int:complaint_id>", methods=["PUT"])
def resolve_complaint(complaint_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            UPDATE USERCOMPLAINT
            SET status = 'resolved',
                resolved_at = NOW()
            WHERE complaint_id = %s
        """, (complaint_id,))

        get_db().commit()

        return jsonify({"message": "Complaint resolved"}), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@admin.route("/messages/broadcast", methods=["POST"])
def broadcast_message():
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT u.email, u.first_name
            FROM USER u
            JOIN RESTAURANT r ON u.user_id = r.owner_user_id
            WHERE r.is_active = TRUE AND u.role = 'owner'
        """)

        recipients = cursor.fetchall()

        return jsonify({
            "recipients": recipients,
            "count": len(recipients)
        }), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()