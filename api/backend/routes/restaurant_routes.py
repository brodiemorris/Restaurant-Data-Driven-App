from flask import Blueprint, jsonify, request, current_app
from backend.db_connection import get_db
from mysql.connector import Error

restaurants = Blueprint("restaurants", __name__, url_prefix="/restaurants")

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

@restaurants.route("/<int:restaurant_id>", methods= ["PUT"])
def update_restaurant(restaurant_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        data = request.get_json()

        allowed_fields = ["restaurant_name", "address", "description", "price-tier-id", "is_active"]

        update_fields = [f"{f} = %s" for f in allowed_fields if f in data]
        params = [data[f] for f in allowed_fields if f in data]

        if not update_fields:
            return jsonify({"error": "No valid fields to update"}), 400
        
        params.append(restaurant_id)
        query = f"UPDATE RESTAURANT SET {", ".join(update_fields)} WHERE restaurant_id = %s"
        cursor.execute(query, params)
        get_db().commit()
        return jsonify({"message": "Restaurant fields updated successfully"}), 200
    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@restaurants.route("/<int restaurant_id>", methods=["DELETE"])
def delete_restaurant(restaurant_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("DELETE FROM RESTAURANT WHERE restaurant_id = %s", (restaurant_id,))
        get_db().commit()

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
    
@restaurants.route("/<int restaurant_id>/menu", methods = ["GET"])
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

@restaurants.route("/<int restaurant_id>/menu", methods = ["POST"])
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

@restaurants.route(<"/<int restaurant_id>/menu/<int item_id>", methods = ["PUT"])
def update_menu_item(restaurant_id, item_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        data = request.get_json()

        allowed_fields = ["item_name", "description", "price", "is_available"]
        update_fields  = [f"{f} = %s" for f in allowed_fields if f in data]
        params         = [data[f] for f in allowed_fields if f in data]

        if not update_fields:
            return jsonify({"error": "No valid fields to update"}), 400

        params.extend([item_id, restaurant_id])
        query = f"""
            UPDATE MENUITEM
            SET {', '.join(update_fields)}
            WHERE menu_item_id = %s AND restaurant_id = %s
        """
        cursor.execute(query, params)
        get_db().commit()
        return jsonify({"message": "Menu item updated"}), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@restaurants.route("/<int restaurant_id>/menu/<int item_id>", methods = ["DELETE"])
def delete_menu_item(restaurant_id, item_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            DELETE FROM MENUITEM
            WHERE menu_item_id = %s AND restaurant_id = %s
        """, (item_id, restaurant_id))
        get_db().commit()
        return jsonify({"message": "Menu item deleted"}), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@restaurants.route("/<int restaurant_id>/tags", methods = ["GET"])
def get_tags(restaurant_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT t.tag_id, t.tag_name
            FROM TAG t
            JOIN RESTAURANTTAG rt ON t.tag_id = rt.tag_id
            WHERE rt.restaurant_id = %s
        """, (restaurant_id,))
        return jsonify(cursor.fetchall()), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@restaurants.route("/<int restaurant_id>/tags", methods = ["POST"])
def add_tag(restaurant_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        data = request.get_json()
        cursor.execute("""
            INSERT INTO RESTAURANTTAG (restaurant_id, tag_id)
            VALUES (%s, %s)
        """, (restaurant_id, data["tag_id"]))
        get_db().commit()
        return jsonify({"message": "Tag added"}), 201

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@restaurants.route("/<int restaurant_id>/tags/<int tag_id>", methods = ["DELETE"])
def remove_tag(restaurant_id, tag_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            DELETE FROM RESTAURANTTAG
            WHERE restaurant_id = %s AND tag_id = %s
        """, (restaurant_id, tag_id))
        get_db().commit()
        return jsonify({"message": "Tag removed"}), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@restaurants.route("/<int restaurant_id>/stats", methods = ["GET"])
def get_stats(restaurant_id):
    try:
        cursor.execute("""
            SELECT
                SUM(CASE WHEN swipe_result = 'yes' THEN 1 ELSE 0 END) AS total_yes,
                SUM(CASE WHEN swipe_result = 'no'  THEN 1 ELSE 0 END) AS total_no,
                COUNT(*) AS total_swipes
            FROM SWIPEACTIVITY
            WHERE restaurant_id = %s
        """, (restaurant_id,))
        swipe_stats = cursor.fetchone()

        cursor.execute("""
            SELECT DAYOFWEEK(activity_date) AS day_of_week, COUNT(*) AS swipe_count
            FROM SWIPEACTIVITY
            WHERE restaurant_id = %s AND swipe_result = 'yes'
            GROUP BY DAYOFWEEK(activity_date)
            ORDER BY day_of_week
        """, (restaurant_id,))
        swipes_by_day = cursor.fetchall()

        return jsonify({
            "swipe_summary": swipe_stats,
            "swipes_by_day": swipes_by_day
        }), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@restaurants.route("/<int:restaurant_id>/reviews", methods=["GET"])
def get_reviews(restaurant_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT rv.review_id, rv.rating, rv.review_text, rv.review_date,
                   rv.owner_reply_text, rv.owner_reply_date,
                   u.first_name, u.last_name
            FROM REVIEW rv
            JOIN `USER` u ON rv.user_id = u.user_id
            WHERE rv.restaurant_id = %s
            ORDER BY rv.review_date DESC
        """, (restaurant_id,))
        return jsonify(cursor.fetchall()), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@restaurants.route("/<int:restaurant_id>/reviews", methods=["POST"])
def add_review(restaurant_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        data = request.get_json()
        cursor.execute("""
            INSERT INTO REVIEW (restaurant_id, user_id, rating, review_text, review_date)
            VALUES (%s, %s, %s, %s, CURDATE())
        """, (restaurant_id,
              data["user_id"],
              data["rating"],
              data.get("review_text", "")))
        get_db().commit()
        return jsonify({"review_id": cursor.lastrowid}), 201

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@restaurants.route("/<int:restaurant_id>/reviews/<int:review_id>", methods=["PUT"])
def update_review(restaurant_id, review_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        data = request.get_json()

        # 🔧 CHANGE: allowed_fields and the two WHERE columns.
        allowed_fields = ["rating", "review_text",
                          "owner_reply_text", "owner_reply_date"]
        update_fields  = [f"{f} = %s" for f in allowed_fields if f in data]
        params         = [data[f] for f in allowed_fields if f in data]

        if not update_fields:
            return jsonify({"error": "No valid fields to update"}), 400

        params.extend([review_id, restaurant_id])
        query = f"""
            UPDATE REVIEW
            SET {', '.join(update_fields)}
            WHERE review_id = %s AND restaurant_id = %s
        """
        cursor.execute(query, params)
        get_db().commit()
        return jsonify({"message": "Review updated"}), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

@restaurants.route("/recommend", methods=["GET"])
def recommend_restaurant():
    cursor = get_db().cursor(dictionary=True)
    try:
        user_id = request.args.get("user_id")
        if not user_id:
            return jsonify({"error": "user_id is required"}), 400

        cursor.execute("""
            SELECT r.restaurant_id, r.restaurant_name, r.address, r.avg_rating
            FROM RESTAURANT r
            JOIN RESTAURANTCUISINE rc ON r.restaurant_id = rc.restaurant_id
            JOIN USERCUISINEPREFERENCE ucp
                 ON rc.cuisine_id = ucp.cuisine_id AND ucp.user_id = %s
            WHERE r.is_active = TRUE
              AND r.restaurant_id NOT IN (
                  SELECT restaurant_id FROM DININGHISTORY WHERE user_id = %s
              )
            ORDER BY r.avg_rating DESC
            LIMIT 1
        """, (user_id, user_id))

        result = cursor.fetchone()
        if not result:
            return jsonify({"error": "No recommendation found"}), 404

        return jsonify(result), 200

    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()