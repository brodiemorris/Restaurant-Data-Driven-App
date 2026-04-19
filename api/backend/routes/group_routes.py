from flask import Blueprint, jsonify, request
from backend.db_connection import get_db
from mysql.connector import Error

group_routes = Blueprint("groups", __name__, url_prefix="/groups")

@group_routes.route("", methods=["POST"])
def create_group():
    cursor = get_db().cursor(dictionary=True)
    try:
        data = request.get_json()

        cursor.execute("""
            INSERT INTO DININGGROUP
            (group_name, created_by_user_id, created_at, status)
            VALUES (%s, %s, NOW(), 'active')
        """, (data["group_name"], data["created_by_user_id"]))

        get_db().commit()
        return jsonify({"message": "Group created"}), 201

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@group_routes.route("/<int:group_id>/members", methods=["GET"])
def get_members(group_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT u.user_id, u.first_name, u.last_name, gm.joined_at
            FROM GROUPMEMBER gm
            JOIN USER u ON gm.user_id = u.user_id
            WHERE gm.group_id = %s
        """, (group_id,))

        results = cursor.fetchall()
        return jsonify(results), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@group_routes.route("/<int:group_id>/members", methods=["POST"])
def add_member(group_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        data = request.get_json()

        cursor.execute("""
            INSERT INTO GROUPMEMBER (group_id, user_id, joined_at)
            VALUES (%s, %s, NOW())
        """, (group_id, data["user_id"]))

        get_db().commit()
        return jsonify({"message": "Member added"}), 201

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@group_routes.route("/<int:group_id>/members/<int:user_id>", methods=["DELETE"])
def remove_member(group_id, user_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            DELETE FROM GROUPMEMBER
            WHERE group_id = %s AND user_id = %s
        """, (group_id, user_id))

        get_db().commit()
        return jsonify({"message": "Member removed"}), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()