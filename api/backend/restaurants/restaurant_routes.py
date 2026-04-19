from flask import Blueprint, jsonify, request, current_app
from backend.db_connection import get_db
from mysql.connector import Error

restaurants = Blueprint("restaurants", __name__)

@restaurants.route("/", methods = ["GET"])
def get_all_restaurants():
    cursor = get_db().cursor(dictionary=True)
    try:
        query = """
            SELECT r.restaurant_id, r.restaurant_name, r.address,
                   r.description, r.avg_rating, r.is_active,
                   c.city_name, pt.tier_label
            FROM RESTAURANT r
            JOIN CITY c ON r.city_id = c.city_id
            JOIN PRICETIER pt ON r.price_tier_id = pt.price_tier_id
            WHERE 1=1
        """
        params = []

        # Optional arguments to filter the restaurants by
        cuisine_id = request.args.get("cuisine_id")
        city_id    = request.args.get("city_id")
        is_active  = request.args.get("is_active")

        if cuisine_id:
            query += " AND r.restaurant_id IN (SELECT restaurant_id FROM RESTAURANTCUISINE WHERE cuisine_id = %s)"
            params.append(cuisine_id)
        if city_id:
            query += " AND r.city_id = %s"
            params.append(city_id)
        if is_active:
            query += " AND r.is_active = %s"
            params.append(is_active)

        cursor.execute(query, params)
        results = cursor.fetchall()
        return jsonify(results), 200

    except Error as e:
        current_app.logger.error(f"Error in get_all_restaurants: {e}")
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@restaurants.route("/<int:restaurant_id>", methods=["GET"])
def get_Restaurant(restaurant_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT r.*, c.city_name, pt.tier_label
            FROM RESTAURANT r
            JOIN CITY c ON r.city_id = c.city_id
            JOIN PRICETIER pt ON r.price_tier_id = pt.price_tier_id
            WHERE r.restaurant_id = %s
        """, (restaurant_id,))

        result = cursor.fetchone()

        if not result:
            return jsonify({"error": "Restaurant not found"}), 404
        
        return jsonify(result), 200
    
    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

