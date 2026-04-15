-- Create and use the forkIT database
CREATE DATABASE IF NOT EXISTS forkit;
USE forkit;

-- CITY
CREATE TABLE CITY (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(255),
    state VARCHAR(255),
    country VARCHAR(255)
);

-- PRICETIER
CREATE TABLE PRICETIER (
    price_tier_id INT PRIMARY KEY,
    tier_label VARCHAR(255),
    min_price FLOAT,
    max_price FLOAT
);

-- USER
CREATE TABLE `USER` (
    user_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    role VARCHAR(255),
    age_group VARCHAR(255),
    gender VARCHAR(255),
    region VARCHAR(255),
    created_at DATETIME
);

-- CUISINE
CREATE TABLE CUISINE (
    cuisine_id INT PRIMARY KEY,
    cuisine_name VARCHAR(255)
);

-- DIETARYRESTRICTION
CREATE TABLE DIETARYRESTRICTION (
    dietary_restriction_id INT PRIMARY KEY,
    restriction_name VARCHAR(255)
);

-- TAG
CREATE TABLE TAG (
    tag_id INT PRIMARY KEY,
    tag_name VARCHAR(255)
);

-- RESTAURANT
CREATE TABLE RESTAURANT (
    restaurant_id INT PRIMARY KEY,
    owner_user_id INT,
    city_id INT,
    price_tier_id INT,
    restaurant_name VARCHAR(255),
    address VARCHAR(255),
    description TEXT,
    avg_rating FLOAT,
    is_active BOOLEAN,
    created_at DATETIME,
    FOREIGN KEY (owner_user_id) REFERENCES `USER`(user_id),
    FOREIGN KEY (city_id) REFERENCES CITY(city_id),
    FOREIGN KEY (price_tier_id) REFERENCES PRICETIER(price_tier_id)
);

-- RESTAURANTCUISINE
CREATE TABLE RESTAURANTCUISINE (
    restaurant_id INT,
    cuisine_id INT,
    PRIMARY KEY (restaurant_id, cuisine_id),
    FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id),
    FOREIGN KEY (cuisine_id) REFERENCES CUISINE(cuisine_id)
);

-- USERDIETARYRESTRICTION
CREATE TABLE USERDIETARYRESTRICTION (
    user_id INT,
    dietary_restriction_id INT,
    PRIMARY KEY (user_id, dietary_restriction_id),
    FOREIGN KEY (user_id) REFERENCES `USER`(user_id),
    FOREIGN KEY (dietary_restriction_id) REFERENCES DIETARYRESTRICTION(dietary_restriction_id)
);

-- USERPREFERENCE
CREATE TABLE USERPREFERENCE (
    preference_id INT PRIMARY KEY,
    user_id INT,
    budget_min FLOAT,
    budget_max FLOAT,
    mile_radius FLOAT,
    group_mode_on BOOLEAN,
    updated_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES `USER`(user_id)
);

-- USERCUISINEPREFERENCE
CREATE TABLE USERCUISINEPREFERENCE (
    user_id INT,
    cuisine_id INT,
    preference_type VARCHAR(255),
    updated_at DATETIME,
    PRIMARY KEY (user_id, cuisine_id),
    FOREIGN KEY (user_id) REFERENCES `USER`(user_id),
    FOREIGN KEY (cuisine_id) REFERENCES CUISINE(cuisine_id)
);

-- RESTAURANTTAG
CREATE TABLE RESTAURANTTAG (
    restaurant_id INT,
    tag_id INT,
    PRIMARY KEY (restaurant_id, tag_id),
    FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id),
    FOREIGN KEY (tag_id) REFERENCES TAG(tag_id)
);

-- MENUITEM
CREATE TABLE MENUITEM (
    menu_item_id INT PRIMARY KEY,
    restaurant_id INT,
    item_name VARCHAR(255),
    description TEXT,
    price FLOAT,
    is_available BOOLEAN,
    FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id)
);

-- PROMOTION
CREATE TABLE PROMOTION (
    promotion_id INT PRIMARY KEY,
    restaurant_id INT,
    title VARCHAR(255),
    description TEXT,
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN,
    FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id)
);

-- SWIPEACTIVITY
CREATE TABLE SWIPEACTIVITY (
    activity_id INT PRIMARY KEY,
    user_id INT,
    restaurant_id INT,
    cuisine_id INT,
    swipe_result VARCHAR(255),
    activity_date DATETIME,
    FOREIGN KEY (user_id) REFERENCES `USER`(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id),
    FOREIGN KEY (cuisine_id) REFERENCES CUISINE(cuisine_id)
);

-- REVIEW
CREATE TABLE REVIEW (
    review_id INT PRIMARY KEY,
    restaurant_id INT,
    user_id INT,
    rating INT,
    review_text TEXT,
    review_date DATE,
    owner_reply_text TEXT,
    owner_reply_date DATE,
    FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id),
    FOREIGN KEY (user_id) REFERENCES `USER`(user_id)
);

-- DININGGROUP
CREATE TABLE DININGGROUP (
    group_id INT PRIMARY KEY,
    group_name VARCHAR(255),
    created_by_user_id INT,
    created_at DATETIME,
    status VARCHAR(255),
    FOREIGN KEY (created_by_user_id) REFERENCES `USER`(user_id)
);

-- GROUPMEMBER
CREATE TABLE GROUPMEMBER (
    group_id INT,
    user_id INT,
    joined_at DATETIME,
    PRIMARY KEY (group_id, user_id),
    FOREIGN KEY (group_id) REFERENCES DININGGROUP(group_id),
    FOREIGN KEY (user_id) REFERENCES `USER`(user_id)
);

-- GROUPRESTAURANTVOTE
CREATE TABLE GROUPRESTAURANTVOTE (
    vote_id INT PRIMARY KEY,
    group_id INT,
    user_id INT,
    restaurant_id INT,
    vote_value INT,
    voted_at DATETIME,
    FOREIGN KEY (group_id) REFERENCES DININGGROUP(group_id),
    FOREIGN KEY (user_id) REFERENCES `USER`(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id)
);

-- DININGHISTORY
CREATE TABLE DININGHISTORY (
    history_id INT PRIMARY KEY,
    user_id INT,
    restaurant_id INT,
    visit_date DATE,
    user_rating INT,
    FOREIGN KEY (user_id) REFERENCES `USER`(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id)
);

-- RESTAURANTSUBMISSION
CREATE TABLE RESTAURANTSUBMISSION (
    submission_id INT PRIMARY KEY,
    submitted_by_user_id INT,
    reviewed_by_admin_id INT,
    restaurant_name VARCHAR(255),
    address VARCHAR(255),
    city_id INT,
    cuisine_summary VARCHAR(255),
    tag_summary VARCHAR(255),
    status VARCHAR(255),
    submitted_at DATETIME,
    reviewed_at DATETIME,
    FOREIGN KEY (submitted_by_user_id) REFERENCES `USER`(user_id),
    FOREIGN KEY (reviewed_by_admin_id) REFERENCES `USER`(user_id),
    FOREIGN KEY (city_id) REFERENCES CITY(city_id)
);

-- USERCOMPLAINT
CREATE TABLE USERCOMPLAINT (
    complaint_id INT PRIMARY KEY,
    user_id INT,
    restaurant_id INT,
    complaint_text TEXT,
    status VARCHAR(255),
    created_at DATETIME,
    resolved_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES `USER`(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id)
);

-- EXPORTREPORT
CREATE TABLE EXPORTREPORT (
    report_id INT PRIMARY KEY,
    analyst_id INT,
    city_id INT,
    cuisine_id INT,
    generated_at DATETIME,
    format VARCHAR(255),
    FOREIGN KEY (analyst_id) REFERENCES `USER`(user_id),
    FOREIGN KEY (city_id) REFERENCES CITY(city_id),
    FOREIGN KEY (cuisine_id) REFERENCES CUISINE(cuisine_id)
);
