from flask import Blueprint, jsonify, request
from backend.db_connection import get_db
from mysql.connector import Error

users = Blueprint("users", __name__, url_prefix="/users")

@users.route("/<int:user_id>/preferences", methods=["GET"])
def get_user_preferences(user_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT budget_min, budget_max, mile_radius, group_mode_on, updated_at
            FROM USERPREFERENCE WHERE user_id = %s
        """, (user_id,))
        preferences = cursor.fetchone()

        if not preferences:
            return jsonify({"error": "Preferences not found"}), 404

        cursor.execute("""
            SELECT c.cuisine_id, c.cuisine_name, ucp.preference_type
            FROM USERCUISINEPREFERENCE ucp
            JOIN CUISINE c ON ucp.cuisine_id = c.cuisine_id
            WHERE ucp.user_id = %s
        """, (user_id,))
        cuisines = cursor.fetchall()

        cursor.execute("""
            SELECT d.dietary_restriction_id, d.restriction_name
            FROM USERDIETARYRESTRICTION udr
            JOIN DIETARYRESTRICTION d
            ON udr.dietary_restriction_id = d.dietary_restriction_id
            WHERE udr.user_id = %s
        """, (user_id,))
        restrictions = cursor.fetchall()

        return jsonify({
            "preferences": preferences,
            "cuisines": cuisines,
            "dietary_restrictions": restrictions
        }), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@users.route("/<int:user_id>/preferences", methods=["PUT"])
def update_user_preferences(user_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        data = request.get_json()

        cursor.execute("""
            UPDATE USERPREFERENCE
            SET budget_min = %s,
                budget_max = %s,
                mile_radius = %s,
                updated_at = NOW()
            WHERE user_id = %s
        """, (
            data["budget_min"],
            data["budget_max"],
            data["mile_radius"],
            user_id
        ))

        get_db().commit()
        return jsonify({"message": "Preferences updated"}), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@users.route("/<int:user_id>/preferences/cuisines", methods=["PUT"])
def upsert_cuisine(user_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        data = request.get_json()

        cursor.execute("""
            INSERT INTO USERCUISINEPREFERENCE
            (user_id, cuisine_id, preference_type, updated_at)
            VALUES (%s, %s, %s, NOW())
            ON DUPLICATE KEY UPDATE
                preference_type = %s,
                updated_at = NOW()
        """, (
            user_id,
            data["cuisine_id"],
            data["preference_type"],
            data["preference_type"]
        ))

        get_db().commit()
        return jsonify({"message": "Cuisine preference saved"}), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@users.route("/<int:user_id>/dining-history", methods=["GET"])
def get_dining_history(user_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT dh.history_id, dh.visit_date, dh.user_rating,
                   r.restaurant_id, r.restaurant_name, r.address
            FROM DININGHISTORY dh
            JOIN RESTAURANT r ON dh.restaurant_id = r.restaurant_id
            WHERE dh.user_id = %s
            ORDER BY dh.visit_date DESC
        """, (user_id,))

        results = cursor.fetchall()
        return jsonify(results), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@users.route("/<int:user_id>/dining-history/<int:history_id>", methods=["DELETE"])
def delete_dining_history(user_id, history_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            DELETE FROM DININGHISTORY
            WHERE history_id = %s AND user_id = %s
        """, (history_id, user_id))

        get_db().commit()
        return jsonify({"message": "Dining history deleted"}), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()