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

@restaurants.route("</int:restaurant_id>", methods: ["PUT"])
def update_restaurant(restaurant_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        data = request.get_json()

        allowed_fields = ["restaurant_name", "address", "description", "price-tier-id", "is_active"]

        update_fields = [f "{f} = %s" for f in allowed_fields if f in data]
        params = [data[f] for f in allowed_fields if f in data]

        if not update_fields:
            return jsonify({error: "No valid fields to update"}), 400
        
        params.append(restaurant_id)
        query = f"UPDATE RESTAURANT SET {", ".join(update_fields)} WHERE restaurant_id = %s"
        cursor.execute(query, params)
        get_db().commit()
        return jsonify({"message": "Restaurant fields updated successfully"}), 200
    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@restaurants.route("</int restaurant_id>", methods=["DELETE"])
def delete_restaurant(restaurant_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("DELETE FROM RESTAURANT WHERE restaurant_id = %s", (restaurant_id,))
        get_db().commit()

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
    
@restaurants.route("</int restaurant_id>/menu", methods = ["GET"])
def get_menu(restaurant_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT * FROM MENUITEM
            WHERE restaurant_id = %s
        """, (restaurant_id,))
        return jsonify(cursor.fetchall()), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@restaurants.route("</int restaurant_id/menu", methods = ["POST"])
def add_menu_item(restaurant_id):
    cursor = get_db().cursor()
    try:
        data = request.get_json()

        cursor.execute("""
            INSERT INTO MENUITEM (restaurant_id, item_name, description, price, is_available)
            VALUES (%s, %s, %s, %s, %s)
        """, (restaurant_id,
              data["item_name"],
              data.get("description", ""),
              data["price"],
              data.get("is_available", True)))

        get_db().commit()
        return jsonify({"menu_item_id": cursor.lastrowid}), 201
    
    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

