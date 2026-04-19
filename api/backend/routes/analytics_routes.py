from flask import Blueprint, jsonify, request
from backend.db_connection import get_db
from mysql.connector import Error

analytics = Blueprint("analytics", __name__, url_prefix="/analytics")

@analytics.route("/ratings", methods=["GET"])
def get_ratings():
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT c.city_name, cu.cuisine_name,
                   COUNT(r.restaurant_id) AS restaurant_count,
                   AVG(r.avg_rating) AS avg_rating
            FROM RESTAURANT r
            JOIN CITY c ON r.city_id = c.city_id
            JOIN RESTAURANTCUISINE rc ON r.restaurant_id = rc.restaurant_id
            JOIN CUISINE cu ON rc.cuisine_id = cu.cuisine_id
            WHERE r.is_active = TRUE
            GROUP BY c.city_name, cu.cuisine_name
            ORDER BY c.city_name, avg_rating DESC
        """)

        results = cursor.fetchall()
        return jsonify(results), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@analytics.route("/trends", methods=["GET"])
def get_trends():
    cursor = get_db().cursor(dictionary=True)
    try:
        cuisine_id = request.args.get("cuisine_id")
        restaurant_id = request.args.get("restaurant_id")

        query = """
            SELECT DATE(activity_date) AS date, COUNT(*) AS swipe_count
            FROM SWIPEACTIVITY
            WHERE swipe_result = 'yes'
        """

        params = []

        if cuisine_id:
            query += " AND cuisine_id = %s"
            params.append(cuisine_id)
        elif restaurant_id:
            query += " AND restaurant_id = %s"
            params.append(restaurant_id)

        query += " GROUP BY DATE(activity_date) ORDER BY date"

        cursor.execute(query, tuple(params))
        results = cursor.fetchall()

        return jsonify(results), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@analytics.route("/pricing", methods=["GET"])
def get_pricing():
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT c.city_name, cu.cuisine_name, pt.tier_label,
                   pt.min_price, pt.max_price,
                   COUNT(r.restaurant_id) AS restaurant_count,
                   AVG(r.avg_rating) AS avg_rating
            FROM RESTAURANT r
            JOIN CITY c ON r.city_id = c.city_id
            JOIN PRICETIER pt ON r.price_tier_id = pt.price_tier_id
            JOIN RESTAURANTCUISINE rc ON r.restaurant_id = rc.restaurant_id
            JOIN CUISINE cu ON rc.cuisine_id = cu.cuisine_id
            WHERE r.is_active = TRUE
            GROUP BY c.city_name, cu.cuisine_name,
                     pt.tier_label, pt.min_price, pt.max_price
            ORDER BY c.city_name, cu.cuisine_name, pt.min_price
        """)

        results = cursor.fetchall()
        return jsonify(results), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@analytics.route("/demographics", methods=["GET"])
def get_demographics():
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT u.region, u.age_group, u.gender,
                   COUNT(rv.review_id) AS review_count
            FROM REVIEW rv
            JOIN USER u ON rv.user_id = u.user_id
            GROUP BY u.region, u.age_group, u.gender
            ORDER BY u.region, review_count DESC
        """)

        results = cursor.fetchall()
        return jsonify(results), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

