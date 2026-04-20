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
USE forkit;

-- CITY (50 rows)
INSERT INTO CITY VALUES (1, 'Boston', 'Massachusetts', 'USA');
INSERT INTO CITY VALUES (2, 'New York', 'New York', 'USA');
INSERT INTO CITY VALUES (3, 'Los Angeles', 'California', 'USA');
INSERT INTO CITY VALUES (4, 'Chicago', 'Illinois', 'USA');
INSERT INTO CITY VALUES (5, 'Houston', 'Texas', 'USA');
INSERT INTO CITY VALUES (6, 'Phoenix', 'Arizona', 'USA');
INSERT INTO CITY VALUES (7, 'Philadelphia', 'Pennsylvania', 'USA');
INSERT INTO CITY VALUES (8, 'San Antonio', 'Texas', 'USA');
INSERT INTO CITY VALUES (9, 'San Diego', 'California', 'USA');
INSERT INTO CITY VALUES (10, 'Dallas', 'Texas', 'USA');
INSERT INTO CITY VALUES (11, 'Austin', 'Texas', 'USA');
INSERT INTO CITY VALUES (12, 'San Francisco', 'California', 'USA');
INSERT INTO CITY VALUES (13, 'Seattle', 'Washington', 'USA');
INSERT INTO CITY VALUES (14, 'Denver', 'Colorado', 'USA');
INSERT INTO CITY VALUES (15, 'Portland', 'Oregon', 'USA');
INSERT INTO CITY VALUES (16, 'Nashville', 'Tennessee', 'USA');
INSERT INTO CITY VALUES (17, 'Miami', 'Florida', 'USA');
INSERT INTO CITY VALUES (18, 'Atlanta', 'Georgia', 'USA');
INSERT INTO CITY VALUES (19, 'Minneapolis', 'Minnesota', 'USA');
INSERT INTO CITY VALUES (20, 'Detroit', 'Michigan', 'USA');
INSERT INTO CITY VALUES (21, 'Charlotte', 'North Carolina', 'USA');
INSERT INTO CITY VALUES (22, 'Raleigh', 'North Carolina', 'USA');
INSERT INTO CITY VALUES (23, 'Tampa', 'Florida', 'USA');
INSERT INTO CITY VALUES (24, 'Pittsburgh', 'Pennsylvania', 'USA');
INSERT INTO CITY VALUES (25, 'Cincinnati', 'Ohio', 'USA');
INSERT INTO CITY VALUES (26, 'Kansas City', 'Missouri', 'USA');
INSERT INTO CITY VALUES (27, 'Columbus', 'Ohio', 'USA');
INSERT INTO CITY VALUES (28, 'Indianapolis', 'Indiana', 'USA');
INSERT INTO CITY VALUES (29, 'Milwaukee', 'Wisconsin', 'USA');
INSERT INTO CITY VALUES (30, 'Las Vegas', 'Nevada', 'USA');
INSERT INTO CITY VALUES (31, 'Orlando', 'Florida', 'USA');
INSERT INTO CITY VALUES (32, 'Baltimore', 'Maryland', 'USA');
INSERT INTO CITY VALUES (33, 'Memphis', 'Tennessee', 'USA');
INSERT INTO CITY VALUES (34, 'Louisville', 'Kentucky', 'USA');
INSERT INTO CITY VALUES (35, 'Richmond', 'Virginia', 'USA');
INSERT INTO CITY VALUES (36, 'Salt Lake City', 'Utah', 'USA');
INSERT INTO CITY VALUES (37, 'Sacramento', 'California', 'USA');
INSERT INTO CITY VALUES (38, 'San Jose', 'California', 'USA');
INSERT INTO CITY VALUES (39, 'Jacksonville', 'Florida', 'USA');
INSERT INTO CITY VALUES (40, 'Oklahoma City', 'Oklahoma', 'USA');
INSERT INTO CITY VALUES (41, 'New Orleans', 'Louisiana', 'USA');
INSERT INTO CITY VALUES (42, 'Buffalo', 'New York', 'USA');
INSERT INTO CITY VALUES (43, 'Providence', 'Rhode Island', 'USA');
INSERT INTO CITY VALUES (44, 'Hartford', 'Connecticut', 'USA');
INSERT INTO CITY VALUES (45, 'Tucson', 'Arizona', 'USA');
INSERT INTO CITY VALUES (46, 'Albuquerque', 'New Mexico', 'USA');
INSERT INTO CITY VALUES (47, 'Omaha', 'Nebraska', 'USA');
INSERT INTO CITY VALUES (48, 'Boise', 'Idaho', 'USA');
INSERT INTO CITY VALUES (49, 'Charleston', 'South Carolina', 'USA');
INSERT INTO CITY VALUES (50, 'Savannah', 'Georgia', 'USA');

-- PRICETIER (4 rows)
INSERT INTO PRICETIER VALUES (1, '$', 0, 15);
INSERT INTO PRICETIER VALUES (2, '$$', 15, 30);
INSERT INTO PRICETIER VALUES (3, '$$$', 30, 60);
INSERT INTO PRICETIER VALUES (4, '$$$$', 60, 150);

-- CUISINE (45 rows)
INSERT INTO CUISINE VALUES (1, 'Italian');
INSERT INTO CUISINE VALUES (2, 'Mexican');
INSERT INTO CUISINE VALUES (3, 'Chinese');
INSERT INTO CUISINE VALUES (4, 'Japanese');
INSERT INTO CUISINE VALUES (5, 'Indian');
INSERT INTO CUISINE VALUES (6, 'Thai');
INSERT INTO CUISINE VALUES (7, 'French');
INSERT INTO CUISINE VALUES (8, 'Greek');
INSERT INTO CUISINE VALUES (9, 'Spanish');
INSERT INTO CUISINE VALUES (10, 'Korean');
INSERT INTO CUISINE VALUES (11, 'Vietnamese');
INSERT INTO CUISINE VALUES (12, 'Ethiopian');
INSERT INTO CUISINE VALUES (13, 'Turkish');
INSERT INTO CUISINE VALUES (14, 'Lebanese');
INSERT INTO CUISINE VALUES (15, 'Moroccan');
INSERT INTO CUISINE VALUES (16, 'Peruvian');
INSERT INTO CUISINE VALUES (17, 'Brazilian');
INSERT INTO CUISINE VALUES (18, 'Cuban');
INSERT INTO CUISINE VALUES (19, 'Jamaican');
INSERT INTO CUISINE VALUES (20, 'Filipino');
INSERT INTO CUISINE VALUES (21, 'Malaysian');
INSERT INTO CUISINE VALUES (22, 'Indonesian');
INSERT INTO CUISINE VALUES (23, 'Taiwanese');
INSERT INTO CUISINE VALUES (24, 'German');
INSERT INTO CUISINE VALUES (25, 'British');
INSERT INTO CUISINE VALUES (26, 'Irish');
INSERT INTO CUISINE VALUES (27, 'Polish');
INSERT INTO CUISINE VALUES (28, 'Russian');
INSERT INTO CUISINE VALUES (29, 'Ukrainian');
INSERT INTO CUISINE VALUES (30, 'Swedish');
INSERT INTO CUISINE VALUES (31, 'Mediterranean');
INSERT INTO CUISINE VALUES (32, 'Cajun');
INSERT INTO CUISINE VALUES (33, 'Southern');
INSERT INTO CUISINE VALUES (34, 'BBQ');
INSERT INTO CUISINE VALUES (35, 'Seafood');
INSERT INTO CUISINE VALUES (36, 'Vegetarian');
INSERT INTO CUISINE VALUES (37, 'Vegan');
INSERT INTO CUISINE VALUES (38, 'Fusion');
INSERT INTO CUISINE VALUES (39, 'American');
INSERT INTO CUISINE VALUES (40, 'Hawaiian');
INSERT INTO CUISINE VALUES (41, 'Tex-Mex');
INSERT INTO CUISINE VALUES (42, 'Soul Food');
INSERT INTO CUISINE VALUES (43, 'Afghan');
INSERT INTO CUISINE VALUES (44, 'Nepalese');
INSERT INTO CUISINE VALUES (45, 'Salvadoran');

-- DIETARYRESTRICTION (12 rows)
INSERT INTO DIETARYRESTRICTION VALUES (1, 'Gluten-Free');
INSERT INTO DIETARYRESTRICTION VALUES (2, 'Nut-Free');
INSERT INTO DIETARYRESTRICTION VALUES (3, 'Dairy-Free');
INSERT INTO DIETARYRESTRICTION VALUES (4, 'Vegan');
INSERT INTO DIETARYRESTRICTION VALUES (5, 'Vegetarian');
INSERT INTO DIETARYRESTRICTION VALUES (6, 'Halal');
INSERT INTO DIETARYRESTRICTION VALUES (7, 'Kosher');
INSERT INTO DIETARYRESTRICTION VALUES (8, 'Pescatarian');
INSERT INTO DIETARYRESTRICTION VALUES (9, 'Keto');
INSERT INTO DIETARYRESTRICTION VALUES (10, 'Paleo');
INSERT INTO DIETARYRESTRICTION VALUES (11, 'Low-Sodium');
INSERT INTO DIETARYRESTRICTION VALUES (12, 'Soy-Free');

-- TAG (40 rows)
INSERT INTO TAG VALUES (1, 'Pet Friendly');
INSERT INTO TAG VALUES (2, 'Outdoor Seating');
INSERT INTO TAG VALUES (3, 'Live Music');
INSERT INTO TAG VALUES (4, 'Happy Hour');
INSERT INTO TAG VALUES (5, 'Late Night');
INSERT INTO TAG VALUES (6, 'Brunch');
INSERT INTO TAG VALUES (7, 'Delivery');
INSERT INTO TAG VALUES (8, 'Takeout');
INSERT INTO TAG VALUES (9, 'Dine-In');
INSERT INTO TAG VALUES (10, 'Drive-Through');
INSERT INTO TAG VALUES (11, 'Wheelchair Accessible');
INSERT INTO TAG VALUES (12, 'Kid Friendly');
INSERT INTO TAG VALUES (13, 'Date Night');
INSERT INTO TAG VALUES (14, 'Group Dining');
INSERT INTO TAG VALUES (15, 'Waterfront');
INSERT INTO TAG VALUES (16, 'Rooftop');
INSERT INTO TAG VALUES (17, 'Sports Bar');
INSERT INTO TAG VALUES (18, 'Craft Cocktails');
INSERT INTO TAG VALUES (19, 'Wine Bar');
INSERT INTO TAG VALUES (20, 'Beer Garden');
INSERT INTO TAG VALUES (21, 'Farm to Table');
INSERT INTO TAG VALUES (22, 'Organic');
INSERT INTO TAG VALUES (23, 'Locally Sourced');
INSERT INTO TAG VALUES (24, 'Fast Casual');
INSERT INTO TAG VALUES (25, 'Fine Dining');
INSERT INTO TAG VALUES (26, 'Buffet');
INSERT INTO TAG VALUES (27, 'Food Truck');
INSERT INTO TAG VALUES (28, 'Catering');
INSERT INTO TAG VALUES (29, 'Private Events');
INSERT INTO TAG VALUES (30, 'Free WiFi');
INSERT INTO TAG VALUES (31, 'Parking Available');
INSERT INTO TAG VALUES (32, 'Reservations');
INSERT INTO TAG VALUES (33, 'Walk-Ins Welcome');
INSERT INTO TAG VALUES (34, 'BYOB');
INSERT INTO TAG VALUES (35, 'Scenic View');
INSERT INTO TAG VALUES (36, 'Historic Building');
INSERT INTO TAG VALUES (37, 'Trendy');
INSERT INTO TAG VALUES (38, 'Cozy');
INSERT INTO TAG VALUES (39, 'Romantic');
INSERT INTO TAG VALUES (40, 'Family Style');

-- USER (50 rows)
INSERT INTO `USER` VALUES (1, 'James', 'Smith', 'james.smith@email.com', 'admin', '18-24', 'Non-binary', 'Southeast', '2024-04-05 23:06:43');
INSERT INTO `USER` VALUES (2, 'Mary', 'Johnson', 'mary.johnson@email.com', 'admin', '18-24', 'Prefer not to say', 'Northeast', '2024-01-03 06:14:32');
INSERT INTO `USER` VALUES (3, 'Robert', 'Williams', 'robert.williams@email.com', 'admin', '18-24', 'Female', 'West', '2024-07-08 14:37:17');
INSERT INTO `USER` VALUES (4, 'Patricia', 'Brown', 'patricia.brown@email.com', 'owner', '25-34', 'Prefer not to say', 'Midwest', '2024-05-05 06:48:21');
INSERT INTO `USER` VALUES (5, 'John', 'Jones', 'john.jones@email.com', 'owner', '18-24', 'Prefer not to say', 'Northeast', '2024-06-28 11:38:16');
INSERT INTO `USER` VALUES (6, 'Jennifer', 'Garcia', 'jennifer.garcia@email.com', 'owner', '65+', 'Prefer not to say', 'West', '2024-02-13 02:35:18');
INSERT INTO `USER` VALUES (7, 'Michael', 'Miller', 'michael.miller@email.com', 'owner', '35-44', 'Female', 'Northeast', '2024-01-22 07:49:18');
INSERT INTO `USER` VALUES (8, 'Linda', 'Davis', 'linda.davis@email.com', 'owner', '25-34', 'Male', 'Southwest', '2024-05-15 20:53:23');
INSERT INTO `USER` VALUES (9, 'David', 'Rodriguez', 'david.rodriguez@email.com', 'owner', '35-44', 'Non-binary', 'Southeast', '2024-11-09 22:59:43');
INSERT INTO `USER` VALUES (10, 'Elizabeth', 'Martinez', 'elizabeth.martinez@email.com', 'owner', '55-64', 'Female', 'West', '2024-12-08 05:29:24');
INSERT INTO `USER` VALUES (11, 'William', 'Hernandez', 'william.hernandez@email.com', 'owner', '65+', 'Female', 'Midwest', '2024-01-08 01:51:20');
INSERT INTO `USER` VALUES (12, 'Barbara', 'Lopez', 'barbara.lopez@email.com', 'owner', '35-44', 'Male', 'Southeast', '2024-10-23 10:13:41');
INSERT INTO `USER` VALUES (13, 'Richard', 'Gonzalez', 'richard.gonzalez@email.com', 'owner', '45-54', 'Prefer not to say', 'Southeast', '2024-05-05 07:47:35');
INSERT INTO `USER` VALUES (14, 'Susan', 'Wilson', 'susan.wilson@email.com', 'owner', '35-44', 'Prefer not to say', 'West', '2024-07-12 07:08:32');
INSERT INTO `USER` VALUES (15, 'Joseph', 'Anderson', 'joseph.anderson@email.com', 'owner', '18-24', 'Male', 'Northeast', '2024-03-21 05:50:43');
INSERT INTO `USER` VALUES (16, 'Jessica', 'Thomas', 'jessica.thomas@email.com', 'user', '55-64', 'Male', 'Southwest', '2024-07-20 14:33:16');
INSERT INTO `USER` VALUES (17, 'Thomas', 'Taylor', 'thomas.taylor@email.com', 'owner', '18-24', 'Male', 'West', '2024-05-25 20:21:07');
INSERT INTO `USER` VALUES (18, 'Sarah', 'Moore', 'sarah.moore@email.com', 'user', '45-54', 'Female', 'Southwest', '2024-01-24 23:16:32');
INSERT INTO `USER` VALUES (19, 'Christopher', 'Jackson', 'christopher.jackson@email.com', 'user', '55-64', 'Male', 'Midwest', '2024-11-17 19:12:09');
INSERT INTO `USER` VALUES (20, 'Karen', 'Martin', 'karen.martin@email.com', 'user', '25-34', 'Male', 'West', '2024-06-16 00:07:59');
INSERT INTO `USER` VALUES (21, 'Daniel', 'Lee', 'daniel.lee@email.com', 'user', '35-44', 'Female', 'Northeast', '2024-04-19 02:05:46');
INSERT INTO `USER` VALUES (22, 'Lisa', 'Perez', 'lisa.perez@email.com', 'owner', '18-24', 'Female', 'Southeast', '2024-11-16 17:10:16');
INSERT INTO `USER` VALUES (23, 'Matthew', 'Thompson', 'matthew.thompson@email.com', 'owner', '55-64', 'Prefer not to say', 'Southeast', '2024-09-25 23:44:12');
INSERT INTO `USER` VALUES (24, 'Nancy', 'White', 'nancy.white@email.com', 'user', '45-54', 'Non-binary', 'Southwest', '2024-09-15 03:15:14');
INSERT INTO `USER` VALUES (25, 'Anthony', 'Harris', 'anthony.harris@email.com', 'user', '35-44', 'Male', 'West', '2024-09-08 18:14:00');
INSERT INTO `USER` VALUES (26, 'Betty', 'Sanchez', 'betty.sanchez@email.com', 'user', '65+', 'Male', 'Southeast', '2024-02-02 10:04:32');
INSERT INTO `USER` VALUES (27, 'Mark', 'Clark', 'mark.clark@email.com', 'user', '35-44', 'Prefer not to say', 'Southeast', '2024-09-05 23:59:56');
INSERT INTO `USER` VALUES (28, 'Margaret', 'Ramirez', 'margaret.ramirez@email.com', 'admin', '55-64', 'Prefer not to say', 'Southeast', '2024-08-26 13:12:06');
INSERT INTO `USER` VALUES (29, 'Donald', 'Lewis', 'donald.lewis@email.com', 'user', '65+', 'Prefer not to say', 'Midwest', '2024-07-14 14:55:46');
INSERT INTO `USER` VALUES (30, 'Sandra', 'Robinson', 'sandra.robinson@email.com', 'user', '65+', 'Male', 'Northeast', '2024-07-24 10:51:55');
INSERT INTO `USER` VALUES (31, 'Steven', 'Walker', 'steven.walker@email.com', 'user', '25-34', 'Female', 'Southeast', '2024-09-15 04:27:11');
INSERT INTO `USER` VALUES (32, 'Ashley', 'Young', 'ashley.young@email.com', 'user', '45-54', 'Female', 'Northeast', '2024-08-26 17:06:03');
INSERT INTO `USER` VALUES (33, 'Andrew', 'Allen', 'andrew.allen@email.com', 'owner', '18-24', 'Male', 'Southeast', '2024-03-14 15:30:13');
INSERT INTO `USER` VALUES (34, 'Dorothy', 'King', 'dorothy.king@email.com', 'user', '18-24', 'Female', 'Southwest', '2024-01-13 08:59:50');
INSERT INTO `USER` VALUES (35, 'Paul', 'Wright', 'paul.wright@email.com', 'owner', '35-44', 'Prefer not to say', 'West', '2024-11-23 15:09:12');
INSERT INTO `USER` VALUES (36, 'Kimberly', 'Scott', 'kimberly.scott@email.com', 'user', '25-34', 'Male', 'West', '2024-12-18 01:47:20');
INSERT INTO `USER` VALUES (37, 'Joshua', 'Torres', 'joshua.torres@email.com', 'user', '18-24', 'Prefer not to say', 'West', '2024-09-06 01:32:05');
INSERT INTO `USER` VALUES (38, 'Emily', 'Nguyen', 'emily.nguyen@email.com', 'user', '18-24', 'Male', 'Southeast', '2024-07-04 18:15:37');
INSERT INTO `USER` VALUES (39, 'Kenneth', 'Hill', 'kenneth.hill@email.com', 'admin', '18-24', 'Male', 'Southwest', '2024-11-19 18:33:20');
INSERT INTO `USER` VALUES (40, 'Donna', 'Flores', 'donna.flores@email.com', 'user', '25-34', 'Non-binary', 'Southeast', '2024-05-13 04:42:41');
INSERT INTO `USER` VALUES (41, 'Kevin', 'Green', 'kevin.green@email.com', 'user', '45-54', 'Non-binary', 'Northeast', '2024-01-15 19:36:06');
INSERT INTO `USER` VALUES (42, 'Michelle', 'Adams', 'michelle.adams@email.com', 'user', '55-64', 'Female', 'West', '2024-05-05 11:56:04');
INSERT INTO `USER` VALUES (43, 'Brian', 'Nelson', 'brian.nelson@email.com', 'user', '35-44', 'Non-binary', 'Southeast', '2024-08-27 17:45:19');
INSERT INTO `USER` VALUES (44, 'Carol', 'Baker', 'carol.baker@email.com', 'admin', '65+', 'Male', 'West', '2024-05-22 03:56:08');
INSERT INTO `USER` VALUES (45, 'George', 'Hall', 'george.hall@email.com', 'user', '18-24', 'Male', 'West', '2024-03-09 09:38:13');
INSERT INTO `USER` VALUES (46, 'Amanda', 'Rivera', 'amanda.rivera@email.com', 'user', '25-34', 'Non-binary', 'West', '2024-08-09 01:05:40');
INSERT INTO `USER` VALUES (47, 'Timothy', 'Campbell', 'timothy.campbell@email.com', 'user', '35-44', 'Male', 'Northeast', '2024-06-25 04:40:16');
INSERT INTO `USER` VALUES (48, 'Melissa', 'Mitchell', 'melissa.mitchell@email.com', 'user', '65+', 'Prefer not to say', 'West', '2024-12-14 17:00:07');
INSERT INTO `USER` VALUES (49, 'Ronald', 'Carter', 'ronald.carter@email.com', 'user', '65+', 'Female', 'West', '2024-01-27 11:37:35');
INSERT INTO `USER` VALUES (50, 'Deborah', 'Roberts', 'deborah.roberts@email.com', 'user', '45-54', 'Female', 'Northeast', '2024-05-12 01:57:22');

-- RESTAURANT (50 rows)
INSERT INTO RESTAURANT VALUES (1, 7, 31, 1, 'The Golden Fork', '216 Maple Ln', 'A wonderful dining experience at The Golden Fork.', 3.6, 0, '2024-04-23 22:24:31');
INSERT INTO RESTAURANT VALUES (2, 10, 16, 2, 'Bella Cucina', '106 Cedar Dr', 'A wonderful dining experience at Bella Cucina.', 4.1, 1, '2024-02-25 13:14:11');
INSERT INTO RESTAURANT VALUES (3, 12, 30, 1, 'Sakura Garden', '906 Broadway Dr', 'A wonderful dining experience at Sakura Garden.', 3.9, 1, '2024-08-05 14:42:33');
INSERT INTO RESTAURANT VALUES (4, 12, 39, 3, 'Spice Route', '768 Elm Ave', 'A wonderful dining experience at Spice Route.', 4.9, 1, '2024-10-27 23:57:32');
INSERT INTO RESTAURANT VALUES (5, 10, 36, 4, 'Le Petit Bistro', '886 Elm Ave', 'A wonderful dining experience at Le Petit Bistro.', 4.7, 1, '2024-08-09 07:53:40');
INSERT INTO RESTAURANT VALUES (6, 8, 50, 4, 'Dragon Palace', '903 Broadway St', 'A wonderful dining experience at Dragon Palace.', 4.1, 1, '2024-08-03 22:18:15');
INSERT INTO RESTAURANT VALUES (7, 8, 22, 3, 'Taco Loco', '184 Cedar Rd', 'A wonderful dining experience at Taco Loco.', 4.7, 1, '2024-03-05 07:24:44');
INSERT INTO RESTAURANT VALUES (8, 6, 46, 2, 'Mediterranean Breeze', '822 Maple Blvd', 'A wonderful dining experience at Mediterranean Breeze.', 2.7, 1, '2024-06-18 14:26:03');
INSERT INTO RESTAURANT VALUES (9, 7, 27, 4, 'Seoul Kitchen', '164 Oak Rd', 'A wonderful dining experience at Seoul Kitchen.', 4.8, 0, '2024-12-01 18:24:30');
INSERT INTO RESTAURANT VALUES (10, 4, 23, 3, 'Pho Paradise', '894 Main Rd', 'A wonderful dining experience at Pho Paradise.', 4.4, 1, '2024-09-24 23:34:51');
INSERT INTO RESTAURANT VALUES (11, 7, 32, 2, 'The Rustic Table', '228 Maple Rd', 'A wonderful dining experience at The Rustic Table.', 3.2, 1, '2024-01-13 10:42:43');
INSERT INTO RESTAURANT VALUES (12, 10, 47, 2, 'Ocean Blue', '359 Pine Ave', 'A wonderful dining experience at Ocean Blue.', 4.6, 1, '2024-10-18 00:58:25');
INSERT INTO RESTAURANT VALUES (13, 4, 6, 4, 'Curry House', '229 Main Ln', 'A wonderful dining experience at Curry House.', 2.8, 1, '2024-03-02 08:24:20');
INSERT INTO RESTAURANT VALUES (14, 7, 30, 3, 'Ember Grill', '198 Broadway Blvd', 'A wonderful dining experience at Ember Grill.', 3.3, 1, '2024-05-25 13:16:53');
INSERT INTO RESTAURANT VALUES (15, 5, 31, 1, 'Noodle Republic', '286 Oak Blvd', 'A wonderful dining experience at Noodle Republic.', 4.4, 1, '2024-06-08 20:04:49');
INSERT INTO RESTAURANT VALUES (16, 4, 49, 1, 'Farm & Fire', '360 State Rd', 'A wonderful dining experience at Farm & Fire.', 4.9, 1, '2024-01-20 04:15:08');
INSERT INTO RESTAURANT VALUES (17, 11, 43, 1, 'The Olive Branch', '696 State Blvd', 'A wonderful dining experience at The Olive Branch.', 3.9, 1, '2024-08-23 08:49:23');
INSERT INTO RESTAURANT VALUES (18, 6, 39, 1, 'Chopstick Express', '962 Main St', 'A wonderful dining experience at Chopstick Express.', 4.4, 1, '2024-05-04 18:01:59');
INSERT INTO RESTAURANT VALUES (19, 8, 37, 4, 'Sunrise Cafe', '899 Pine Ave', 'A wonderful dining experience at Sunrise Cafe.', 3.5, 1, '2024-02-19 22:53:40');
INSERT INTO RESTAURANT VALUES (20, 7, 7, 3, 'Midnight Diner', '595 Pine St', 'A wonderful dining experience at Midnight Diner.', 4.6, 0, '2024-02-26 18:50:02');
INSERT INTO RESTAURANT VALUES (21, 9, 35, 4, 'Red Pepper', '112 High Rd', 'A wonderful dining experience at Red Pepper.', 4.2, 1, '2024-09-21 10:00:54');
INSERT INTO RESTAURANT VALUES (22, 10, 32, 1, 'The Hungry Bear', '354 Cedar Rd', 'A wonderful dining experience at The Hungry Bear.', 3.6, 1, '2024-11-27 14:45:09');
INSERT INTO RESTAURANT VALUES (23, 10, 12, 3, 'Saffron Pot', '621 State St', 'A wonderful dining experience at Saffron Pot.', 4.0, 0, '2024-08-15 13:52:46');
INSERT INTO RESTAURANT VALUES (24, 8, 21, 2, 'Maple & Main', '395 High Ave', 'A wonderful dining experience at Maple & Main.', 4.6, 1, '2024-05-15 07:48:29');
INSERT INTO RESTAURANT VALUES (25, 10, 22, 1, 'Coastal Catch', '261 Main Ln', 'A wonderful dining experience at Coastal Catch.', 3.7, 1, '2024-03-16 06:22:51');
INSERT INTO RESTAURANT VALUES (26, 8, 22, 3, 'Urban Wok', '447 Main Dr', 'A wonderful dining experience at Urban Wok.', 4.7, 1, '2024-09-01 16:12:05');
INSERT INTO RESTAURANT VALUES (27, 7, 47, 4, 'The Creamery', '948 State Ln', 'A wonderful dining experience at The Creamery.', 3.7, 1, '2024-12-16 20:45:31');
INSERT INTO RESTAURANT VALUES (28, 11, 2, 1, 'Firehouse Pizza', '737 Maple Blvd', 'A wonderful dining experience at Firehouse Pizza.', 3.2, 1, '2024-12-08 09:42:37');
INSERT INTO RESTAURANT VALUES (29, 9, 31, 3, 'Garden Bistro', '442 Oak Ln', 'A wonderful dining experience at Garden Bistro.', 3.6, 0, '2024-06-12 22:29:17');
INSERT INTO RESTAURANT VALUES (30, 8, 17, 2, 'The Lobster Trap', '943 Cedar Dr', 'A wonderful dining experience at The Lobster Trap.', 2.8, 1, '2024-06-04 23:34:48');
INSERT INTO RESTAURANT VALUES (31, 6, 13, 2, 'Smoky Mountain BBQ', '322 Oak Ln', 'A wonderful dining experience at Smoky Mountain BBQ.', 4.3, 1, '2024-12-19 16:38:18');
INSERT INTO RESTAURANT VALUES (32, 5, 13, 3, 'Tandoori Nights', '922 Pine Dr', 'A wonderful dining experience at Tandoori Nights.', 3.1, 1, '2024-05-01 22:34:08');
INSERT INTO RESTAURANT VALUES (33, 8, 3, 1, 'Pasta La Vista', '317 Broadway Blvd', 'A wonderful dining experience at Pasta La Vista.', 3.9, 1, '2024-11-28 15:06:55');
INSERT INTO RESTAURANT VALUES (34, 4, 37, 3, 'Zen Sushi', '413 Pine Dr', 'A wonderful dining experience at Zen Sushi.', 3.7, 1, '2024-06-06 01:16:55');
INSERT INTO RESTAURANT VALUES (35, 11, 8, 1, 'The Brunch Box', '131 Maple Rd', 'A wonderful dining experience at The Brunch Box.', 3.5, 1, '2024-10-21 21:03:09');
INSERT INTO RESTAURANT VALUES (36, 6, 37, 3, 'Bayou Kitchen', '681 Broadway Ln', 'A wonderful dining experience at Bayou Kitchen.', 2.7, 1, '2024-02-18 13:38:38');
INSERT INTO RESTAURANT VALUES (37, 7, 50, 4, 'Havana Nights', '767 Elm Dr', 'A wonderful dining experience at Havana Nights.', 3.6, 1, '2024-05-28 18:27:19');
INSERT INTO RESTAURANT VALUES (38, 4, 40, 1, 'Alpine Lodge', '583 Pine Rd', 'A wonderful dining experience at Alpine Lodge.', 4.9, 1, '2024-11-07 08:42:05');
INSERT INTO RESTAURANT VALUES (39, 6, 16, 2, 'The Tasting Room', '562 Main Blvd', 'A wonderful dining experience at The Tasting Room.', 3.9, 1, '2024-01-14 14:44:38');
INSERT INTO RESTAURANT VALUES (40, 11, 19, 1, 'Bombay Street', '294 Maple Rd', 'A wonderful dining experience at Bombay Street.', 3.1, 1, '2024-12-28 14:04:43');
INSERT INTO RESTAURANT VALUES (41, 7, 17, 2, 'Crispy Crust', '805 High Dr', 'A wonderful dining experience at Crispy Crust.', 3.6, 0, '2024-04-21 04:58:17');
INSERT INTO RESTAURANT VALUES (42, 6, 5, 1, 'The Vineyard', '671 Cedar Rd', 'A wonderful dining experience at The Vineyard.', 2.9, 1, '2024-10-24 18:58:18');
INSERT INTO RESTAURANT VALUES (43, 11, 8, 4, 'Harbor House', '453 Market Ln', 'A wonderful dining experience at Harbor House.', 4.2, 1, '2024-05-17 17:31:28');
INSERT INTO RESTAURANT VALUES (44, 5, 39, 1, 'Peking Garden', '219 State Rd', 'A wonderful dining experience at Peking Garden.', 4.7, 1, '2024-10-09 00:05:14');
INSERT INTO RESTAURANT VALUES (45, 4, 49, 3, 'The Local Pub', '813 Elm Ln', 'A wonderful dining experience at The Local Pub.', 3.9, 1, '2024-08-17 20:28:58');
INSERT INTO RESTAURANT VALUES (46, 8, 12, 4, 'Mesa Verde', '87 Pine Dr', 'A wonderful dining experience at Mesa Verde.', 4.1, 1, '2024-02-16 11:26:21');
INSERT INTO RESTAURANT VALUES (47, 9, 43, 1, 'Bistro 22', '680 High Blvd', 'A wonderful dining experience at Bistro 22.', 4.6, 1, '2024-07-23 15:18:42');
INSERT INTO RESTAURANT VALUES (48, 10, 49, 1, 'The Noodle House', '96 Maple Ln', 'A wonderful dining experience at The Noodle House.', 3.6, 1, '2024-05-11 03:49:25');
INSERT INTO RESTAURANT VALUES (49, 12, 1, 4, 'Starlight Diner', '318 Maple Ave', 'A wonderful dining experience at Starlight Diner.', 3.5, 1, '2024-09-12 19:48:31');
INSERT INTO RESTAURANT VALUES (50, 11, 49, 1, 'The Spice Market', '151 Main St', 'A wonderful dining experience at The Spice Market.', 3.0, 0, '2024-03-10 14:56:44');

-- DININGGROUP (45 rows)
INSERT INTO DININGGROUP VALUES (1, 'Weeknight Dinner Club', 30, '2025-01-24 04:26:55', 'active');
INSERT INTO DININGGROUP VALUES (2, 'Friday Group', 5, '2025-08-26 08:21:39', 'completed');
INSERT INTO DININGGROUP VALUES (3, 'Biweekly Bites', 42, '2025-02-28 10:54:43', 'disbanded');
INSERT INTO DININGGROUP VALUES (4, 'Weekly Eats', 25, '2025-06-21 22:56:48', 'completed');
INSERT INTO DININGGROUP VALUES (5, 'Sunday Bunch', 35, '2025-01-20 02:15:40', 'active');
INSERT INTO DININGGROUP VALUES (6, 'Friday Bunch', 15, '2025-12-03 13:06:48', 'active');
INSERT INTO DININGGROUP VALUES (7, 'Weeknight Dinner Club 6', 29, '2025-03-23 09:57:01', 'active');
INSERT INTO DININGGROUP VALUES (8, 'Saturday Dinner Club', 21, '2025-01-10 11:23:27', 'active');
INSERT INTO DININGGROUP VALUES (9, 'Weeknight Dinner Club 8', 16, '2025-09-14 18:43:50', 'active');
INSERT INTO DININGGROUP VALUES (10, 'Weekly Eats 9', 11, '2025-03-03 19:55:24', 'disbanded');
INSERT INTO DININGGROUP VALUES (11, 'Weeknight Feast', 44, '2025-04-16 18:09:14', 'completed');
INSERT INTO DININGGROUP VALUES (12, 'Monthly Feast', 41, '2025-05-15 08:42:00', 'completed');
INSERT INTO DININGGROUP VALUES (13, 'Weeknight Gang', 19, '2025-11-18 05:04:28', 'active');
INSERT INTO DININGGROUP VALUES (14, 'Weeknight Bites', 38, '2025-05-21 13:44:16', 'completed');
INSERT INTO DININGGROUP VALUES (15, 'Weeknight Bunch', 20, '2025-04-13 15:06:15', 'completed');
INSERT INTO DININGGROUP VALUES (16, 'Saturday Squad', 37, '2025-06-19 09:44:18', 'active');
INSERT INTO DININGGROUP VALUES (17, 'Saturday Group', 43, '2025-07-09 00:36:55', 'active');
INSERT INTO DININGGROUP VALUES (18, 'Monthly Eats', 39, '2025-12-16 09:49:51', 'active');
INSERT INTO DININGGROUP VALUES (19, 'Biweekly Dinner Club', 39, '2025-06-08 20:12:39', 'active');
INSERT INTO DININGGROUP VALUES (20, 'Sunday Squad', 44, '2025-12-25 21:43:53', 'active');
INSERT INTO DININGGROUP VALUES (21, 'Sunday Bunch 20', 41, '2025-02-21 20:02:19', 'completed');
INSERT INTO DININGGROUP VALUES (22, 'Sunday Foodies', 3, '2025-10-12 23:08:05', 'active');
INSERT INTO DININGGROUP VALUES (23, 'Sunday Feast', 21, '2025-12-14 05:12:08', 'disbanded');
INSERT INTO DININGGROUP VALUES (24, 'Biweekly Group', 24, '2025-09-17 08:53:10', 'active');
INSERT INTO DININGGROUP VALUES (25, 'Monthly Gang', 31, '2025-05-24 10:51:07', 'completed');
INSERT INTO DININGGROUP VALUES (26, 'Biweekly Eats', 5, '2025-03-25 07:55:43', 'completed');
INSERT INTO DININGGROUP VALUES (27, 'Weeknight Bunch 26', 36, '2025-06-03 12:00:16', 'disbanded');
INSERT INTO DININGGROUP VALUES (28, 'Weeknight Crew', 8, '2025-08-12 21:47:43', 'active');
INSERT INTO DININGGROUP VALUES (29, 'Sunday Bunch 28', 38, '2025-07-27 20:23:06', 'active');
INSERT INTO DININGGROUP VALUES (30, 'Biweekly Bunch', 31, '2025-01-20 17:20:58', 'disbanded');
INSERT INTO DININGGROUP VALUES (31, 'Weeknight Gang 30', 15, '2025-11-03 20:52:29', 'active');
INSERT INTO DININGGROUP VALUES (32, 'Sunday Bites', 42, '2025-07-04 04:02:02', 'active');
INSERT INTO DININGGROUP VALUES (33, 'Weekly Bites', 32, '2025-02-04 07:56:34', 'active');
INSERT INTO DININGGROUP VALUES (34, 'Monthly Squad', 25, '2025-08-12 21:47:44', 'disbanded');
INSERT INTO DININGGROUP VALUES (35, 'Saturday Squad 34', 27, '2025-10-24 23:09:56', 'completed');
INSERT INTO DININGGROUP VALUES (36, 'Friday Crew', 42, '2025-02-27 15:39:26', 'active');
INSERT INTO DININGGROUP VALUES (37, 'Weekly Gang', 3, '2025-12-12 06:28:28', 'active');
INSERT INTO DININGGROUP VALUES (38, 'Weekly Squad', 24, '2025-02-22 11:34:57', 'active');
INSERT INTO DININGGROUP VALUES (39, 'Weeknight Eats', 4, '2025-07-09 06:07:54', 'completed');
INSERT INTO DININGGROUP VALUES (40, 'Weeknight Foodies', 6, '2025-11-07 20:40:38', 'active');
INSERT INTO DININGGROUP VALUES (41, 'Saturday Bunch', 4, '2025-06-08 04:50:36', 'active');
INSERT INTO DININGGROUP VALUES (42, 'Monthly Crew', 5, '2025-09-07 18:13:52', 'active');
INSERT INTO DININGGROUP VALUES (43, 'Biweekly Dinner Club 42', 22, '2025-03-26 19:00:17', 'active');
INSERT INTO DININGGROUP VALUES (44, 'Biweekly Gang', 9, '2025-09-09 05:07:42', 'active');
INSERT INTO DININGGROUP VALUES (45, 'Friday Bunch 44', 9, '2025-01-12 07:37:20', 'active');

-- USERPREFERENCE (50 rows)
INSERT INTO USERPREFERENCE VALUES (1, 1, 10, 40, 2.3, 1, '2025-09-04 23:04:30');
INSERT INTO USERPREFERENCE VALUES (2, 2, 20, 50, 13.3, 0, '2025-08-17 07:39:02');
INSERT INTO USERPREFERENCE VALUES (3, 3, 15, 65, 16.4, 0, '2025-01-16 12:27:43');
INSERT INTO USERPREFERENCE VALUES (4, 4, 5, 55, 18.1, 1, '2025-02-03 10:38:09');
INSERT INTO USERPREFERENCE VALUES (5, 5, 5, 30, 7.6, 1, '2025-07-20 16:18:29');
INSERT INTO USERPREFERENCE VALUES (6, 6, 20, 35, 20.0, 0, '2025-11-21 17:46:55');
INSERT INTO USERPREFERENCE VALUES (7, 7, 10, 60, 11.8, 0, '2025-07-11 14:25:26');
INSERT INTO USERPREFERENCE VALUES (8, 8, 5, 35, 11.2, 1, '2025-06-05 21:59:30');
INSERT INTO USERPREFERENCE VALUES (9, 9, 5, 20, 21.0, 0, '2025-07-04 23:47:23');
INSERT INTO USERPREFERENCE VALUES (10, 10, 10, 90, 2.4, 1, '2025-11-04 13:22:55');
INSERT INTO USERPREFERENCE VALUES (11, 11, 20, 35, 24.2, 1, '2025-06-04 18:32:13');
INSERT INTO USERPREFERENCE VALUES (12, 12, 10, 60, 6.4, 0, '2025-06-28 17:23:07');
INSERT INTO USERPREFERENCE VALUES (13, 13, 15, 95, 6.4, 1, '2025-09-25 19:39:43');
INSERT INTO USERPREFERENCE VALUES (14, 14, 5, 85, 23.3, 1, '2025-01-06 08:44:48');
INSERT INTO USERPREFERENCE VALUES (15, 15, 15, 45, 9.4, 0, '2025-03-19 21:25:04');
INSERT INTO USERPREFERENCE VALUES (16, 16, 10, 25, 3.2, 0, '2025-07-14 14:21:10');
INSERT INTO USERPREFERENCE VALUES (17, 17, 15, 45, 18.3, 0, '2025-01-05 05:48:39');
INSERT INTO USERPREFERENCE VALUES (18, 18, 5, 20, 7.5, 1, '2025-08-20 14:26:17');
INSERT INTO USERPREFERENCE VALUES (19, 19, 10, 90, 3.7, 1, '2025-02-10 21:43:37');
INSERT INTO USERPREFERENCE VALUES (20, 20, 20, 100, 17.0, 0, '2025-04-13 19:03:00');
INSERT INTO USERPREFERENCE VALUES (21, 21, 10, 40, 23.7, 0, '2025-05-10 10:07:00');
INSERT INTO USERPREFERENCE VALUES (22, 22, 20, 70, 5.2, 1, '2025-09-23 07:32:35');
INSERT INTO USERPREFERENCE VALUES (23, 23, 15, 30, 10.5, 0, '2025-07-01 14:58:04');
INSERT INTO USERPREFERENCE VALUES (24, 24, 15, 95, 11.3, 1, '2025-12-21 13:18:07');
INSERT INTO USERPREFERENCE VALUES (25, 25, 20, 35, 24.2, 0, '2025-10-15 22:58:23');
INSERT INTO USERPREFERENCE VALUES (26, 26, 5, 55, 21.3, 0, '2025-07-19 12:33:05');
INSERT INTO USERPREFERENCE VALUES (27, 27, 20, 50, 18.9, 0, '2025-06-25 05:04:32');
INSERT INTO USERPREFERENCE VALUES (28, 28, 5, 85, 13.2, 1, '2025-06-24 20:52:09');
INSERT INTO USERPREFERENCE VALUES (29, 29, 10, 25, 4.5, 0, '2025-03-20 04:48:48');
INSERT INTO USERPREFERENCE VALUES (30, 30, 5, 30, 23.8, 1, '2025-08-25 18:48:37');
INSERT INTO USERPREFERENCE VALUES (31, 31, 20, 100, 16.4, 1, '2025-11-11 04:28:04');
INSERT INTO USERPREFERENCE VALUES (32, 32, 20, 70, 16.2, 1, '2025-10-02 11:32:04');
INSERT INTO USERPREFERENCE VALUES (33, 33, 15, 65, 11.8, 0, '2025-06-27 09:04:41');
INSERT INTO USERPREFERENCE VALUES (34, 34, 5, 85, 15.3, 1, '2025-08-19 17:50:47');
INSERT INTO USERPREFERENCE VALUES (35, 35, 5, 55, 22.8, 0, '2025-06-20 15:32:09');
INSERT INTO USERPREFERENCE VALUES (36, 36, 5, 55, 3.5, 1, '2025-12-03 16:41:11');
INSERT INTO USERPREFERENCE VALUES (37, 37, 5, 30, 18.0, 1, '2025-09-17 19:10:23');
INSERT INTO USERPREFERENCE VALUES (38, 38, 15, 45, 10.3, 1, '2025-11-20 01:50:40');
INSERT INTO USERPREFERENCE VALUES (39, 39, 15, 30, 8.9, 1, '2025-05-09 23:54:42');
INSERT INTO USERPREFERENCE VALUES (40, 40, 10, 40, 3.0, 0, '2025-06-10 20:44:42');
INSERT INTO USERPREFERENCE VALUES (41, 41, 20, 45, 15.3, 0, '2025-05-18 12:41:50');
INSERT INTO USERPREFERENCE VALUES (42, 42, 15, 40, 17.1, 0, '2025-11-22 13:32:23');
INSERT INTO USERPREFERENCE VALUES (43, 43, 5, 35, 8.4, 0, '2025-06-25 15:12:14');
INSERT INTO USERPREFERENCE VALUES (44, 44, 10, 35, 2.9, 0, '2025-09-25 17:53:47');
INSERT INTO USERPREFERENCE VALUES (45, 45, 5, 35, 22.0, 0, '2025-10-13 04:10:11');
INSERT INTO USERPREFERENCE VALUES (46, 46, 10, 60, 2.0, 1, '2025-11-24 07:28:39');
INSERT INTO USERPREFERENCE VALUES (47, 47, 15, 65, 6.6, 0, '2025-05-26 15:57:53');
INSERT INTO USERPREFERENCE VALUES (48, 48, 10, 40, 17.3, 1, '2025-08-25 09:49:24');
INSERT INTO USERPREFERENCE VALUES (49, 49, 20, 45, 20.6, 0, '2025-05-02 20:30:55');
INSERT INTO USERPREFERENCE VALUES (50, 50, 15, 95, 23.4, 0, '2025-05-03 05:17:28');

-- MENUITEM (75 rows)
INSERT INTO MENUITEM VALUES (1, 33, 'Caesar Salad', 'Our signature caesar salad.', 13.22, 0);
INSERT INTO MENUITEM VALUES (2, 6, 'Margherita Pizza', 'Our signature margherita pizza.', 52.37, 1);
INSERT INTO MENUITEM VALUES (3, 29, 'Pad Thai', 'Our signature pad thai.', 49.35, 1);
INSERT INTO MENUITEM VALUES (4, 27, 'Chicken Tikka Masala', 'Our signature chicken tikka masala.', 8.61, 1);
INSERT INTO MENUITEM VALUES (5, 16, 'Beef Tacos', 'Our signature beef tacos.', 24.92, 1);
INSERT INTO MENUITEM VALUES (6, 24, 'Sushi Roll Combo', 'Our signature sushi roll combo.', 17.0, 1);
INSERT INTO MENUITEM VALUES (7, 7, 'French Onion Soup', 'Our signature french onion soup.', 47.12, 1);
INSERT INTO MENUITEM VALUES (8, 10, 'Greek Salad', 'Our signature greek salad.', 12.74, 1);
INSERT INTO MENUITEM VALUES (9, 31, 'Lobster Bisque', 'Our signature lobster bisque.', 40.11, 1);
INSERT INTO MENUITEM VALUES (10, 49, 'Fish and Chips', 'Our signature fish and chips.', 40.57, 0);
INSERT INTO MENUITEM VALUES (11, 40, 'Chicken Parmesan', 'Our signature chicken parmesan.', 6.26, 1);
INSERT INTO MENUITEM VALUES (12, 2, 'Vegetable Stir Fry', 'Our signature vegetable stir fry.', 18.54, 1);
INSERT INTO MENUITEM VALUES (13, 36, 'Mushroom Risotto', 'Our signature mushroom risotto.', 52.07, 0);
INSERT INTO MENUITEM VALUES (14, 8, 'BBQ Ribs', 'Our signature bbq ribs.', 44.03, 1);
INSERT INTO MENUITEM VALUES (15, 20, 'Grilled Salmon', 'Our signature grilled salmon.', 11.97, 1);
INSERT INTO MENUITEM VALUES (16, 27, 'Tom Yum Soup', 'Our signature tom yum soup.', 37.31, 0);
INSERT INTO MENUITEM VALUES (17, 5, 'Falafel Wrap', 'Our signature falafel wrap.', 11.43, 0);
INSERT INTO MENUITEM VALUES (18, 39, 'Beef Bulgogi', 'Our signature beef bulgogi.', 32.27, 1);
INSERT INTO MENUITEM VALUES (19, 46, 'Shrimp Scampi', 'Our signature shrimp scampi.', 13.04, 0);
INSERT INTO MENUITEM VALUES (20, 1, 'Pulled Pork Sandwich', 'Our signature pulled pork sandwich.', 36.13, 1);
INSERT INTO MENUITEM VALUES (21, 37, 'Eggs Benedict', 'Our signature eggs benedict.', 26.41, 1);
INSERT INTO MENUITEM VALUES (22, 34, 'Avocado Toast', 'Our signature avocado toast.', 53.76, 1);
INSERT INTO MENUITEM VALUES (23, 34, 'Chicken Wings', 'Our signature chicken wings.', 32.66, 1);
INSERT INTO MENUITEM VALUES (24, 25, 'Miso Soup', 'Our signature miso soup.', 48.79, 1);
INSERT INTO MENUITEM VALUES (25, 41, 'Spring Rolls', 'Our signature spring rolls.', 24.96, 1);
INSERT INTO MENUITEM VALUES (26, 17, 'Lamb Chops', 'Our signature lamb chops.', 42.62, 1);
INSERT INTO MENUITEM VALUES (27, 5, 'Crab Cakes', 'Our signature crab cakes.', 22.9, 1);
INSERT INTO MENUITEM VALUES (28, 50, 'Truffle Fries', 'Our signature truffle fries.', 34.51, 1);
INSERT INTO MENUITEM VALUES (29, 9, 'Pho Bo', 'Our signature pho bo.', 8.17, 1);
INSERT INTO MENUITEM VALUES (30, 42, 'Chicken Shawarma', 'Our signature chicken shawarma.', 14.58, 0);
INSERT INTO MENUITEM VALUES (31, 45, 'Churros', 'Our signature churros.', 29.45, 1);
INSERT INTO MENUITEM VALUES (32, 9, 'Tiramisu', 'Our signature tiramisu.', 9.09, 0);
INSERT INTO MENUITEM VALUES (33, 3, 'Creme Brulee', 'Our signature creme brulee.', 20.38, 1);
INSERT INTO MENUITEM VALUES (34, 13, 'Chocolate Lava Cake', 'Our signature chocolate lava cake.', 49.4, 1);
INSERT INTO MENUITEM VALUES (35, 20, 'Mango Sticky Rice', 'Our signature mango sticky rice.', 31.25, 0);
INSERT INTO MENUITEM VALUES (36, 17, 'Garlic Bread', 'Our signature garlic bread.', 7.79, 1);
INSERT INTO MENUITEM VALUES (37, 19, 'Bruschetta', 'Our signature bruschetta.', 23.49, 1);
INSERT INTO MENUITEM VALUES (38, 42, 'Calamari', 'Our signature calamari.', 22.26, 1);
INSERT INTO MENUITEM VALUES (39, 24, 'Edamame', 'Our signature edamame.', 27.41, 0);
INSERT INTO MENUITEM VALUES (40, 48, 'Hummus Platter', 'Our signature hummus platter.', 27.55, 0);
INSERT INTO MENUITEM VALUES (41, 22, 'Filet Mignon', 'Our signature filet mignon.', 53.71, 0);
INSERT INTO MENUITEM VALUES (42, 45, 'NY Strip Steak', 'Our signature ny strip steak.', 30.38, 1);
INSERT INTO MENUITEM VALUES (43, 6, 'Rack of Lamb', 'Our signature rack of lamb.', 41.63, 1);
INSERT INTO MENUITEM VALUES (44, 28, 'Duck Confit', 'Our signature duck confit.', 35.52, 1);
INSERT INTO MENUITEM VALUES (45, 35, 'Osso Buco', 'Our signature osso buco.', 20.39, 1);
INSERT INTO MENUITEM VALUES (46, 6, 'Penne Vodka', 'Our signature penne vodka.', 22.07, 1);
INSERT INTO MENUITEM VALUES (47, 20, 'Spaghetti Carbonara', 'Our signature spaghetti carbonara.', 27.85, 0);
INSERT INTO MENUITEM VALUES (48, 11, 'Lasagna', 'Our signature lasagna.', 39.8, 1);
INSERT INTO MENUITEM VALUES (49, 29, 'Gnocchi', 'Our signature gnocchi.', 8.08, 1);
INSERT INTO MENUITEM VALUES (50, 40, 'Ravioli', 'Our signature ravioli.', 54.91, 1);
INSERT INTO MENUITEM VALUES (51, 41, 'Burrito Bowl', 'Our signature burrito bowl.', 54.02, 1);
INSERT INTO MENUITEM VALUES (52, 5, 'Quesadilla', 'Our signature quesadilla.', 38.89, 0);
INSERT INTO MENUITEM VALUES (53, 24, 'Nachos Supreme', 'Our signature nachos supreme.', 31.14, 1);
INSERT INTO MENUITEM VALUES (54, 2, 'Enchiladas', 'Our signature enchiladas.', 13.0, 0);
INSERT INTO MENUITEM VALUES (55, 3, 'Tamales', 'Our signature tamales.', 12.19, 1);
INSERT INTO MENUITEM VALUES (56, 50, 'Bibimbap', 'Our signature bibimbap.', 37.61, 1);
INSERT INTO MENUITEM VALUES (57, 25, 'Ramen', 'Our signature ramen.', 52.52, 1);
INSERT INTO MENUITEM VALUES (58, 39, 'Udon', 'Our signature udon.', 13.52, 0);
INSERT INTO MENUITEM VALUES (59, 24, 'Tempura', 'Our signature tempura.', 24.23, 1);
INSERT INTO MENUITEM VALUES (60, 37, 'Gyoza', 'Our signature gyoza.', 12.75, 1);
INSERT INTO MENUITEM VALUES (61, 26, 'Butter Chicken', 'Our signature butter chicken.', 21.4, 1);
INSERT INTO MENUITEM VALUES (62, 16, 'Naan Bread', 'Our signature naan bread.', 53.07, 1);
INSERT INTO MENUITEM VALUES (63, 48, 'Samosa', 'Our signature samosa.', 15.12, 0);
INSERT INTO MENUITEM VALUES (64, 36, 'Biryani', 'Our signature biryani.', 11.77, 1);
INSERT INTO MENUITEM VALUES (65, 46, 'Palak Paneer', 'Our signature palak paneer.', 27.87, 1);
INSERT INTO MENUITEM VALUES (66, 45, 'Clam Chowder', 'Our signature clam chowder.', 50.91, 0);
INSERT INTO MENUITEM VALUES (67, 13, 'Oysters', 'Our signature oysters.', 12.01, 1);
INSERT INTO MENUITEM VALUES (68, 29, 'Grilled Octopus', 'Our signature grilled octopus.', 14.46, 0);
INSERT INTO MENUITEM VALUES (69, 6, 'Tuna Tartare', 'Our signature tuna tartare.', 45.72, 1);
INSERT INTO MENUITEM VALUES (70, 43, 'Ceviche', 'Our signature ceviche.', 23.02, 1);
INSERT INTO MENUITEM VALUES (71, 36, 'Pancake Stack', 'Our signature pancake stack.', 32.57, 1);
INSERT INTO MENUITEM VALUES (72, 11, 'Waffles', 'Our signature waffles.', 40.88, 1);
INSERT INTO MENUITEM VALUES (73, 24, 'French Toast', 'Our signature french toast.', 30.93, 1);
INSERT INTO MENUITEM VALUES (74, 13, 'Acai Bowl', 'Our signature acai bowl.', 44.81, 1);
INSERT INTO MENUITEM VALUES (75, 32, 'Smoothie Bowl', 'Our signature smoothie bowl.', 7.29, 1);

-- PROMOTION (50 rows)
INSERT INTO PROMOTION VALUES (1, 30, 'Happy Hour Special', 'Enjoy our happy hour special - limited time only!', '2025-09-05', '2025-10-21', 0);
INSERT INTO PROMOTION VALUES (2, 5, 'Weekend Brunch Deal', 'Enjoy our weekend brunch deal - limited time only!', '2025-05-13', '2025-07-04', 1);
INSERT INTO PROMOTION VALUES (3, 31, 'Date Night Discount', 'Enjoy our date night discount - limited time only!', '2025-09-14', '2025-11-09', 1);
INSERT INTO PROMOTION VALUES (4, 37, 'Family Feast', 'Enjoy our family feast - limited time only!', '2025-02-05', '2025-03-04', 1);
INSERT INTO PROMOTION VALUES (5, 5, 'Early Bird Special', 'Enjoy our early bird special - limited time only!', '2025-08-15', '2025-10-04', 1);
INSERT INTO PROMOTION VALUES (6, 23, 'Late Night Bites', 'Enjoy our late night bites - limited time only!', '2025-03-27', '2025-05-22', 1);
INSERT INTO PROMOTION VALUES (7, 41, 'Student Discount', 'Enjoy our student discount - limited time only!', '2025-10-06', '2025-12-01', 0);
INSERT INTO PROMOTION VALUES (8, 28, 'Birthday Bonus', 'Enjoy our birthday bonus - limited time only!', '2025-09-28', '2025-10-08', 0);
INSERT INTO PROMOTION VALUES (9, 34, 'Holiday Special', 'Enjoy our holiday special - limited time only!', '2025-03-10', '2025-03-27', 0);
INSERT INTO PROMOTION VALUES (10, 21, 'Loyalty Reward', 'Enjoy our loyalty reward - limited time only!', '2025-12-08', '2026-01-06', 1);
INSERT INTO PROMOTION VALUES (11, 19, 'New Menu Launch', 'Enjoy our new menu launch - limited time only!', '2025-02-09', '2025-02-28', 1);
INSERT INTO PROMOTION VALUES (12, 36, 'Anniversary Sale', 'Enjoy our anniversary sale - limited time only!', '2025-05-05', '2025-06-21', 1);
INSERT INTO PROMOTION VALUES (13, 40, 'Summer Sizzle', 'Enjoy our summer sizzle - limited time only!', '2025-09-03', '2025-10-12', 1);
INSERT INTO PROMOTION VALUES (14, 11, 'Winter Warmup', 'Enjoy our winter warmup - limited time only!', '2025-10-19', '2025-11-04', 0);
INSERT INTO PROMOTION VALUES (15, 43, 'Spring Fling', 'Enjoy our spring fling - limited time only!', '2025-10-24', '2025-12-08', 1);
INSERT INTO PROMOTION VALUES (16, 37, 'Fall Harvest', 'Enjoy our fall harvest - limited time only!', '2025-01-27', '2025-02-04', 0);
INSERT INTO PROMOTION VALUES (17, 3, 'Taco Tuesday', 'Enjoy our taco tuesday - limited time only!', '2025-11-25', '2026-01-07', 1);
INSERT INTO PROMOTION VALUES (18, 42, 'Wine Wednesday', 'Enjoy our wine wednesday - limited time only!', '2025-04-25', '2025-06-07', 1);
INSERT INTO PROMOTION VALUES (19, 40, 'Throwback Thursday', 'Enjoy our throwback thursday - limited time only!', '2025-11-01', '2025-12-09', 1);
INSERT INTO PROMOTION VALUES (20, 35, 'Fish Friday', 'Enjoy our fish friday - limited time only!', '2025-05-21', '2025-06-16', 1);
INSERT INTO PROMOTION VALUES (21, 16, 'Sunday Funday', 'Enjoy our sunday funday - limited time only!', '2025-11-13', '2025-12-09', 1);
INSERT INTO PROMOTION VALUES (22, 5, 'Bottomless Mimosas', 'Enjoy our bottomless mimosas - limited time only!', '2025-12-02', '2025-12-19', 1);
INSERT INTO PROMOTION VALUES (23, 27, 'Kids Eat Free', 'Enjoy our kids eat free - limited time only!', '2025-08-15', '2025-09-04', 1);
INSERT INTO PROMOTION VALUES (24, 39, 'Buy One Get One', 'Enjoy our buy one get one - limited time only!', '2025-03-11', '2025-05-02', 1);
INSERT INTO PROMOTION VALUES (25, 47, 'Free Appetizer', 'Enjoy our free appetizer - limited time only!', '2025-06-13', '2025-06-28', 1);
INSERT INTO PROMOTION VALUES (26, 33, 'Free Dessert', 'Enjoy our free dessert - limited time only!', '2025-09-04', '2025-10-01', 0);
INSERT INTO PROMOTION VALUES (27, 30, 'Lunch Combo', 'Enjoy our lunch combo - limited time only!', '2025-02-09', '2025-03-16', 0);
INSERT INTO PROMOTION VALUES (28, 10, 'Dinner for Two', 'Enjoy our dinner for two - limited time only!', '2025-02-02', '2025-02-27', 1);
INSERT INTO PROMOTION VALUES (29, 40, 'Group Discount', 'Enjoy our group discount - limited time only!', '2025-07-08', '2025-07-25', 1);
INSERT INTO PROMOTION VALUES (30, 37, 'Catering Special', 'Enjoy our catering special - limited time only!', '2025-12-11', '2025-12-30', 0);
INSERT INTO PROMOTION VALUES (31, 32, 'Takeout Deal', 'Enjoy our takeout deal - limited time only!', '2025-09-15', '2025-10-23', 1);
INSERT INTO PROMOTION VALUES (32, 32, 'Delivery Discount', 'Enjoy our delivery discount - limited time only!', '2025-01-03', '2025-02-04', 1);
INSERT INTO PROMOTION VALUES (33, 30, 'First Visit Offer', 'Enjoy our first visit offer - limited time only!', '2025-04-07', '2025-05-21', 1);
INSERT INTO PROMOTION VALUES (34, 4, 'Comeback Coupon', 'Enjoy our comeback coupon - limited time only!', '2025-01-10', '2025-02-17', 1);
INSERT INTO PROMOTION VALUES (35, 42, 'Referral Reward', 'Enjoy our referral reward - limited time only!', '2025-11-16', '2025-12-11', 1);
INSERT INTO PROMOTION VALUES (36, 1, 'Social Media Special', 'Enjoy our social media special - limited time only!', '2025-02-14', '2025-03-01', 1);
INSERT INTO PROMOTION VALUES (37, 47, 'Check-In Deal', 'Enjoy our check-in deal - limited time only!', '2025-06-25', '2025-07-27', 1);
INSERT INTO PROMOTION VALUES (38, 3, 'Review Reward', 'Enjoy our review reward - limited time only!', '2025-07-02', '2025-08-14', 1);
INSERT INTO PROMOTION VALUES (39, 13, 'Seasonal Tasting', 'Enjoy our seasonal tasting - limited time only!', '2025-06-18', '2025-07-13', 0);
INSERT INTO PROMOTION VALUES (40, 25, 'Prix Fixe Menu', 'Enjoy our prix fixe menu - limited time only!', '2025-09-15', '2025-11-09', 1);
INSERT INTO PROMOTION VALUES (41, 18, 'Chef Special', 'Enjoy our chef special - limited time only!', '2025-10-22', '2025-12-07', 0);
INSERT INTO PROMOTION VALUES (42, 9, 'Mystery Dish', 'Enjoy our mystery dish - limited time only!', '2025-02-13', '2025-03-15', 1);
INSERT INTO PROMOTION VALUES (43, 36, 'Power Lunch', 'Enjoy our power lunch - limited time only!', '2025-06-25', '2025-07-11', 0);
INSERT INTO PROMOTION VALUES (44, 39, 'After Work Mixer', 'Enjoy our after work mixer - limited time only!', '2025-09-13', '2025-10-22', 0);
INSERT INTO PROMOTION VALUES (45, 3, 'Game Day Deal', 'Enjoy our game day deal - limited time only!', '2025-01-05', '2025-02-26', 1);
INSERT INTO PROMOTION VALUES (46, 31, 'Valentines Special', 'Enjoy our valentines special - limited time only!', '2025-09-15', '2025-10-01', 1);
INSERT INTO PROMOTION VALUES (47, 33, 'Mothers Day Brunch', 'Enjoy our mothers day brunch - limited time only!', '2025-03-11', '2025-04-26', 1);
INSERT INTO PROMOTION VALUES (48, 11, 'Fathers Day Grill', 'Enjoy our fathers day grill - limited time only!', '2025-07-20', '2025-09-12', 1);
INSERT INTO PROMOTION VALUES (49, 38, 'New Year Feast', 'Enjoy our new year feast - limited time only!', '2025-06-17', '2025-08-16', 1);
INSERT INTO PROMOTION VALUES (50, 35, 'Grand Opening', 'Enjoy our grand opening - limited time only!', '2025-08-23', '2025-10-05', 1);

-- SWIPEACTIVITY (75 rows)
INSERT INTO SWIPEACTIVITY VALUES (1, 31, 2, 24, 'like', '2025-11-04 13:37:19');
INSERT INTO SWIPEACTIVITY VALUES (2, 47, 45, 41, 'like', '2025-10-16 08:41:50');
INSERT INTO SWIPEACTIVITY VALUES (3, 50, 38, 37, 'like', '2025-12-02 18:30:10');
INSERT INTO SWIPEACTIVITY VALUES (4, 34, 41, 40, 'skip', '2025-07-05 21:15:02');
INSERT INTO SWIPEACTIVITY VALUES (5, 37, 45, 8, 'like', '2025-01-15 10:26:09');
INSERT INTO SWIPEACTIVITY VALUES (6, 27, 45, 14, 'dislike', '2025-09-25 19:58:30');
INSERT INTO SWIPEACTIVITY VALUES (7, 48, 47, 4, 'save', '2025-03-17 06:35:20');
INSERT INTO SWIPEACTIVITY VALUES (8, 43, 31, 34, 'dislike', '2025-06-06 14:58:34');
INSERT INTO SWIPEACTIVITY VALUES (9, 22, 35, 23, 'save', '2025-12-22 20:51:44');
INSERT INTO SWIPEACTIVITY VALUES (10, 17, 40, 31, 'like', '2025-04-09 17:19:14');
INSERT INTO SWIPEACTIVITY VALUES (11, 20, 50, 19, 'save', '2025-04-23 22:31:20');
INSERT INTO SWIPEACTIVITY VALUES (12, 31, 23, 36, 'skip', '2025-12-09 09:07:36');
INSERT INTO SWIPEACTIVITY VALUES (13, 44, 35, 25, 'dislike', '2025-06-25 04:18:02');
INSERT INTO SWIPEACTIVITY VALUES (14, 19, 46, 6, 'like', '2025-08-21 08:47:30');
INSERT INTO SWIPEACTIVITY VALUES (15, 14, 13, 35, 'like', '2025-09-23 08:08:06');
INSERT INTO SWIPEACTIVITY VALUES (16, 40, 48, 38, 'like', '2025-04-02 21:57:33');
INSERT INTO SWIPEACTIVITY VALUES (17, 15, 41, 15, 'like', '2025-02-14 10:45:30');
INSERT INTO SWIPEACTIVITY VALUES (18, 7, 44, 9, 'like', '2025-09-06 13:41:59');
INSERT INTO SWIPEACTIVITY VALUES (19, 31, 31, 42, 'like', '2025-05-11 09:41:03');
INSERT INTO SWIPEACTIVITY VALUES (20, 50, 6, 42, 'dislike', '2025-04-18 23:46:54');
INSERT INTO SWIPEACTIVITY VALUES (21, 3, 12, 27, 'skip', '2025-03-02 12:50:31');
INSERT INTO SWIPEACTIVITY VALUES (22, 12, 48, 19, 'like', '2025-01-10 18:38:06');
INSERT INTO SWIPEACTIVITY VALUES (23, 22, 19, 30, 'save', '2025-09-17 15:56:08');
INSERT INTO SWIPEACTIVITY VALUES (24, 33, 30, 18, 'like', '2025-02-11 05:46:29');
INSERT INTO SWIPEACTIVITY VALUES (25, 42, 17, 12, 'like', '2025-12-11 09:36:43');
INSERT INTO SWIPEACTIVITY VALUES (26, 49, 13, 12, 'dislike', '2025-11-13 13:32:20');
INSERT INTO SWIPEACTIVITY VALUES (27, 6, 26, 43, 'like', '2025-03-05 15:20:59');
INSERT INTO SWIPEACTIVITY VALUES (28, 16, 1, 17, 'dislike', '2025-04-15 08:21:19');
INSERT INTO SWIPEACTIVITY VALUES (29, 38, 47, 37, 'like', '2025-05-21 11:44:15');
INSERT INTO SWIPEACTIVITY VALUES (30, 4, 43, 8, 'dislike', '2025-05-06 12:43:32');
INSERT INTO SWIPEACTIVITY VALUES (31, 46, 50, 20, 'save', '2025-02-21 09:23:39');
INSERT INTO SWIPEACTIVITY VALUES (32, 15, 15, 9, 'dislike', '2025-03-15 23:38:23');
INSERT INTO SWIPEACTIVITY VALUES (33, 27, 45, 36, 'dislike', '2025-09-26 21:52:13');
INSERT INTO SWIPEACTIVITY VALUES (34, 49, 16, 44, 'skip', '2025-10-28 02:33:28');
INSERT INTO SWIPEACTIVITY VALUES (35, 34, 46, 24, 'like', '2025-10-04 01:53:35');
INSERT INTO SWIPEACTIVITY VALUES (36, 33, 13, 37, 'dislike', '2025-03-06 10:54:33');
INSERT INTO SWIPEACTIVITY VALUES (37, 29, 8, 44, 'like', '2025-12-19 15:05:57');
INSERT INTO SWIPEACTIVITY VALUES (38, 33, 29, 4, 'dislike', '2025-03-17 13:29:36');
INSERT INTO SWIPEACTIVITY VALUES (39, 4, 36, 30, 'save', '2025-05-24 00:25:16');
INSERT INTO SWIPEACTIVITY VALUES (40, 1, 48, 14, 'dislike', '2025-02-02 13:22:44');
INSERT INTO SWIPEACTIVITY VALUES (41, 5, 35, 4, 'like', '2025-08-02 09:26:11');
INSERT INTO SWIPEACTIVITY VALUES (42, 50, 9, 42, 'save', '2025-11-14 11:57:24');
INSERT INTO SWIPEACTIVITY VALUES (43, 29, 25, 25, 'like', '2025-11-22 17:08:41');
INSERT INTO SWIPEACTIVITY VALUES (44, 23, 8, 12, 'dislike', '2025-07-17 04:46:14');
INSERT INTO SWIPEACTIVITY VALUES (45, 1, 49, 2, 'like', '2025-08-22 23:34:27');
INSERT INTO SWIPEACTIVITY VALUES (46, 35, 25, 15, 'like', '2025-08-12 04:17:12');
INSERT INTO SWIPEACTIVITY VALUES (47, 47, 49, 8, 'like', '2025-11-14 19:49:59');
INSERT INTO SWIPEACTIVITY VALUES (48, 2, 16, 14, 'like', '2025-02-20 01:28:38');
INSERT INTO SWIPEACTIVITY VALUES (49, 44, 46, 4, 'like', '2025-12-02 12:28:14');
INSERT INTO SWIPEACTIVITY VALUES (50, 35, 14, 4, 'like', '2025-09-10 07:52:58');
INSERT INTO SWIPEACTIVITY VALUES (51, 47, 37, 21, 'dislike', '2025-10-25 21:52:20');
INSERT INTO SWIPEACTIVITY VALUES (52, 16, 20, 10, 'save', '2025-09-08 13:19:17');
INSERT INTO SWIPEACTIVITY VALUES (53, 4, 36, 38, 'save', '2025-03-21 21:27:35');
INSERT INTO SWIPEACTIVITY VALUES (54, 32, 4, 23, 'save', '2025-11-13 16:20:44');
INSERT INTO SWIPEACTIVITY VALUES (55, 27, 27, 10, 'like', '2025-07-06 17:30:15');
INSERT INTO SWIPEACTIVITY VALUES (56, 15, 20, 10, 'skip', '2025-08-02 17:26:26');
INSERT INTO SWIPEACTIVITY VALUES (57, 36, 34, 9, 'dislike', '2025-04-09 06:21:41');
INSERT INTO SWIPEACTIVITY VALUES (58, 6, 29, 24, 'like', '2025-09-24 06:03:17');
INSERT INTO SWIPEACTIVITY VALUES (59, 25, 44, 39, 'dislike', '2025-01-28 02:12:51');
INSERT INTO SWIPEACTIVITY VALUES (60, 49, 38, 43, 'dislike', '2025-04-16 06:55:58');
INSERT INTO SWIPEACTIVITY VALUES (61, 22, 20, 1, 'like', '2025-04-24 03:47:48');
INSERT INTO SWIPEACTIVITY VALUES (62, 31, 16, 45, 'dislike', '2025-12-07 12:58:15');
INSERT INTO SWIPEACTIVITY VALUES (63, 36, 21, 19, 'dislike', '2025-08-18 20:22:19');
INSERT INTO SWIPEACTIVITY VALUES (64, 17, 24, 33, 'dislike', '2025-08-04 23:30:48');
INSERT INTO SWIPEACTIVITY VALUES (65, 21, 14, 24, 'like', '2025-07-02 18:55:14');
INSERT INTO SWIPEACTIVITY VALUES (66, 48, 10, 2, 'like', '2025-09-19 18:46:26');
INSERT INTO SWIPEACTIVITY VALUES (67, 19, 10, 13, 'like', '2025-04-13 18:53:15');
INSERT INTO SWIPEACTIVITY VALUES (68, 32, 36, 42, 'save', '2025-06-09 15:46:41');
INSERT INTO SWIPEACTIVITY VALUES (69, 48, 32, 30, 'like', '2025-12-26 11:10:08');
INSERT INTO SWIPEACTIVITY VALUES (70, 47, 35, 32, 'like', '2025-09-21 01:33:02');
INSERT INTO SWIPEACTIVITY VALUES (71, 5, 43, 4, 'skip', '2025-01-14 04:53:40');
INSERT INTO SWIPEACTIVITY VALUES (72, 15, 5, 10, 'like', '2025-04-17 14:23:03');
INSERT INTO SWIPEACTIVITY VALUES (73, 40, 41, 43, 'dislike', '2025-08-22 15:01:00');
INSERT INTO SWIPEACTIVITY VALUES (74, 35, 36, 27, 'like', '2025-01-17 23:17:34');
INSERT INTO SWIPEACTIVITY VALUES (75, 19, 2, 33, 'skip', '2025-12-22 13:51:58');

-- REVIEW (75 rows)
INSERT INTO REVIEW VALUES (1, 12, 7, 1, 'The chef really knows what they are doing.', '2025-03-08', 'We apologize for the inconvenience.', '2025-03-13');
INSERT INTO REVIEW VALUES (2, 34, 17, 3, 'A hidden gem in the city!', '2025-07-03', 'Thanks for visiting us!', '2025-07-07');
INSERT INTO REVIEW VALUES (3, 30, 37, 2, 'Portions were generous and tasty.', '2025-05-22', 'We appreciate your feedback and will improve.', '2025-05-28');
INSERT INTO REVIEW VALUES (4, 42, 49, 1, 'Best meal I have had in months!', '2025-07-13', NULL, NULL);
INSERT INTO REVIEW VALUES (5, 36, 31, 1, 'Amazing food and great atmosphere!', '2025-12-06', 'We appreciate your feedback and will improve.', '2025-12-10');
INSERT INTO REVIEW VALUES (6, 28, 42, 3, 'Fresh ingredients and creative dishes.', '2025-02-17', 'Thank you for your kind words!', '2025-02-19');
INSERT INTO REVIEW VALUES (7, 14, 45, 5, 'Perfect for a casual dinner.', '2025-05-02', 'We appreciate your feedback and will improve.', '2025-05-08');
INSERT INTO REVIEW VALUES (8, 18, 35, 5, 'Decent but a bit overpriced.', '2025-03-28', 'Thanks for visiting us!', '2025-03-29');
INSERT INTO REVIEW VALUES (9, 14, 38, 2, 'The staff was incredibly friendly.', '2025-02-10', 'So glad you enjoyed it!', '2025-02-15');
INSERT INTO REVIEW VALUES (10, 16, 37, 4, 'A bit noisy but worth it.', '2025-06-13', 'So glad you enjoyed it!', '2025-06-20');
INSERT INTO REVIEW VALUES (11, 45, 47, 1, 'The chef really knows what they are doing.', '2025-12-12', 'Thank you for your kind words!', '2025-12-13');
INSERT INTO REVIEW VALUES (12, 28, 15, 1, 'Loved the dessert menu!', '2025-10-25', NULL, NULL);
INSERT INTO REVIEW VALUES (13, 50, 21, 1, 'A hidden gem in the city!', '2025-08-16', 'We apologize for the inconvenience.', '2025-08-19');
INSERT INTO REVIEW VALUES (14, 36, 25, 4, 'Not my favorite, but okay.', '2025-11-19', NULL, NULL);
INSERT INTO REVIEW VALUES (15, 6, 50, 5, 'Disappointing experience overall.', '2025-04-23', 'We appreciate your feedback and will improve.', '2025-04-24');
INSERT INTO REVIEW VALUES (16, 18, 10, 4, 'Would definitely come back again.', '2025-12-13', 'Thanks for visiting us!', '2025-12-16');
INSERT INTO REVIEW VALUES (17, 7, 6, 1, 'Disappointing experience overall.', '2025-08-12', 'Hope to see you again soon!', '2025-08-13');
INSERT INTO REVIEW VALUES (18, 9, 6, 2, 'Food was cold when it arrived.', '2025-08-18', NULL, NULL);
INSERT INTO REVIEW VALUES (19, 33, 27, 1, 'Amazing food and great atmosphere!', '2025-02-12', NULL, NULL);
INSERT INTO REVIEW VALUES (20, 6, 39, 5, 'Loved the dessert menu!', '2025-07-01', 'Hope to see you again soon!', '2025-07-05');
INSERT INTO REVIEW VALUES (21, 25, 50, 1, 'A bit noisy but worth it.', '2025-04-19', NULL, NULL);
INSERT INTO REVIEW VALUES (22, 11, 44, 4, 'Not my favorite, but okay.', '2025-03-09', 'Hope to see you again soon!', '2025-03-12');
INSERT INTO REVIEW VALUES (23, 32, 10, 1, 'Not my favorite, but okay.', '2025-07-09', NULL, NULL);
INSERT INTO REVIEW VALUES (24, 20, 31, 1, 'Great spot for brunch with friends.', '2025-05-08', NULL, NULL);
INSERT INTO REVIEW VALUES (25, 39, 40, 2, 'Excellent wine selection.', '2025-02-05', 'Hope to see you again soon!', '2025-02-06');
INSERT INTO REVIEW VALUES (26, 26, 22, 5, 'The staff was incredibly friendly.', '2025-06-15', 'Thanks for visiting us!', '2025-06-19');
INSERT INTO REVIEW VALUES (27, 42, 39, 2, 'Disappointing experience overall.', '2025-06-20', 'We apologize for the inconvenience.', '2025-06-24');
INSERT INTO REVIEW VALUES (28, 21, 12, 4, 'Loved the dessert menu!', '2025-05-24', NULL, NULL);
INSERT INTO REVIEW VALUES (29, 37, 16, 3, 'The staff was incredibly friendly.', '2025-05-27', NULL, NULL);
INSERT INTO REVIEW VALUES (30, 24, 8, 5, 'The ambiance was perfect for date night.', '2025-10-18', 'So glad you enjoyed it!', '2025-10-24');
INSERT INTO REVIEW VALUES (31, 50, 36, 1, 'Excellent wine selection.', '2025-12-07', NULL, NULL);
INSERT INTO REVIEW VALUES (32, 19, 45, 1, 'Food was cold when it arrived.', '2025-11-16', 'So glad you enjoyed it!', '2025-11-22');
INSERT INTO REVIEW VALUES (33, 20, 16, 3, 'Would definitely come back again.', '2025-12-14', NULL, NULL);
INSERT INTO REVIEW VALUES (34, 5, 29, 5, 'Perfect for a casual dinner.', '2025-10-13', NULL, NULL);
INSERT INTO REVIEW VALUES (35, 33, 45, 4, 'A bit noisy but worth it.', '2025-01-26', 'Thanks for visiting us!', '2025-02-01');
INSERT INTO REVIEW VALUES (36, 35, 39, 1, 'Service was slow but food was good.', '2025-04-22', 'Thanks for visiting us!', '2025-04-24');
INSERT INTO REVIEW VALUES (37, 42, 40, 1, 'Fresh ingredients and creative dishes.', '2025-11-22', NULL, NULL);
INSERT INTO REVIEW VALUES (38, 49, 22, 4, 'Service was slow but food was good.', '2025-01-04', 'Hope to see you again soon!', '2025-01-06');
INSERT INTO REVIEW VALUES (39, 33, 48, 5, 'A bit noisy but worth it.', '2025-10-23', 'We apologize for the inconvenience.', '2025-10-27');
INSERT INTO REVIEW VALUES (40, 24, 26, 4, 'Fresh ingredients and creative dishes.', '2025-12-17', 'So glad you enjoyed it!', '2025-12-20');
INSERT INTO REVIEW VALUES (41, 2, 31, 1, 'Disappointing experience overall.', '2025-07-03', 'We appreciate your feedback and will improve.', '2025-07-10');
INSERT INTO REVIEW VALUES (42, 47, 10, 3, 'Disappointing experience overall.', '2025-06-15', 'We apologize for the inconvenience.', '2025-06-20');
INSERT INTO REVIEW VALUES (43, 31, 23, 4, 'Service was slow but food was good.', '2025-08-24', NULL, NULL);
INSERT INTO REVIEW VALUES (44, 21, 5, 3, 'Decent but a bit overpriced.', '2025-12-04', 'Thank you for your kind words!', '2025-12-11');
INSERT INTO REVIEW VALUES (45, 22, 42, 1, 'Not my favorite, but okay.', '2025-12-08', NULL, NULL);
INSERT INTO REVIEW VALUES (46, 12, 36, 2, 'Loved the dessert menu!', '2025-09-14', NULL, NULL);
INSERT INTO REVIEW VALUES (47, 15, 26, 2, 'Not my favorite, but okay.', '2025-11-22', NULL, NULL);
INSERT INTO REVIEW VALUES (48, 26, 2, 5, 'The ambiance was perfect for date night.', '2025-08-19', NULL, NULL);
INSERT INTO REVIEW VALUES (49, 25, 1, 2, 'The ambiance was perfect for date night.', '2025-05-25', 'We appreciate your feedback and will improve.', '2025-05-30');
INSERT INTO REVIEW VALUES (50, 7, 35, 2, 'Great spot for brunch with friends.', '2025-06-07', NULL, NULL);
INSERT INTO REVIEW VALUES (51, 8, 17, 4, 'The chef really knows what they are doing.', '2025-11-11', NULL, NULL);
INSERT INTO REVIEW VALUES (52, 40, 26, 5, 'Service was slow but food was good.', '2025-06-12', NULL, NULL);
INSERT INTO REVIEW VALUES (53, 40, 12, 3, 'Will not be returning unfortunately.', '2025-10-03', 'So glad you enjoyed it!', '2025-10-06');
INSERT INTO REVIEW VALUES (54, 8, 16, 3, 'Service was slow but food was good.', '2025-03-12', 'So glad you enjoyed it!', '2025-03-17');
INSERT INTO REVIEW VALUES (55, 25, 27, 5, 'Would definitely come back again.', '2025-10-13', NULL, NULL);
INSERT INTO REVIEW VALUES (56, 12, 32, 5, 'Not my favorite, but okay.', '2025-09-06', NULL, NULL);
INSERT INTO REVIEW VALUES (57, 19, 9, 2, 'Loved the dessert menu!', '2025-08-20', 'Thank you for your kind words!', '2025-08-27');
INSERT INTO REVIEW VALUES (58, 23, 1, 4, 'Would definitely come back again.', '2025-04-27', NULL, NULL);
INSERT INTO REVIEW VALUES (59, 36, 33, 4, 'Food was cold when it arrived.', '2025-11-16', NULL, NULL);
INSERT INTO REVIEW VALUES (60, 46, 29, 4, 'Not my favorite, but okay.', '2025-02-19', 'Thank you for your kind words!', '2025-02-26');
INSERT INTO REVIEW VALUES (61, 49, 15, 3, 'Decent but a bit overpriced.', '2025-05-08', NULL, NULL);
INSERT INTO REVIEW VALUES (62, 19, 11, 4, 'Fresh ingredients and creative dishes.', '2025-12-25', NULL, NULL);
INSERT INTO REVIEW VALUES (63, 36, 33, 1, 'Fresh ingredients and creative dishes.', '2025-02-09', NULL, NULL);
INSERT INTO REVIEW VALUES (64, 24, 35, 1, 'Excellent wine selection.', '2025-09-07', NULL, NULL);
INSERT INTO REVIEW VALUES (65, 7, 48, 2, 'Disappointing experience overall.', '2025-01-15', 'Hope to see you again soon!', '2025-01-18');
INSERT INTO REVIEW VALUES (66, 6, 29, 1, 'Portions were generous and tasty.', '2025-04-26', 'Thanks for visiting us!', '2025-05-03');
INSERT INTO REVIEW VALUES (67, 46, 40, 4, 'Not my favorite, but okay.', '2025-10-05', 'We apologize for the inconvenience.', '2025-10-12');
INSERT INTO REVIEW VALUES (68, 14, 4, 5, 'Great spot for brunch with friends.', '2025-09-09', NULL, NULL);
INSERT INTO REVIEW VALUES (69, 11, 21, 3, 'Disappointing experience overall.', '2025-10-09', NULL, NULL);
INSERT INTO REVIEW VALUES (70, 44, 7, 2, 'Food was cold when it arrived.', '2025-01-09', 'So glad you enjoyed it!', '2025-01-15');
INSERT INTO REVIEW VALUES (71, 9, 16, 2, 'Loved the dessert menu!', '2025-04-25', NULL, NULL);
INSERT INTO REVIEW VALUES (72, 32, 10, 5, 'A hidden gem in the city!', '2025-11-14', NULL, NULL);
INSERT INTO REVIEW VALUES (73, 29, 5, 1, 'The staff was incredibly friendly.', '2025-09-24', 'Hope to see you again soon!', '2025-09-30');
INSERT INTO REVIEW VALUES (74, 24, 30, 4, 'Loved the dessert menu!', '2025-10-01', 'We appreciate your feedback and will improve.', '2025-10-07');
INSERT INTO REVIEW VALUES (75, 30, 41, 3, 'Best meal I have had in months!', '2025-09-13', 'We apologize for the inconvenience.', '2025-09-17');

-- DININGHISTORY (75 rows)
INSERT INTO DININGHISTORY VALUES (1, 14, 32, '2025-05-11', 3);
INSERT INTO DININGHISTORY VALUES (2, 22, 36, '2025-10-05', 5);
INSERT INTO DININGHISTORY VALUES (3, 32, 22, '2025-11-25', 1);
INSERT INTO DININGHISTORY VALUES (4, 3, 7, '2025-11-26', 4);
INSERT INTO DININGHISTORY VALUES (5, 2, 8, '2025-03-15', 4);
INSERT INTO DININGHISTORY VALUES (6, 1, 28, '2025-04-23', 2);
INSERT INTO DININGHISTORY VALUES (7, 42, 20, '2025-03-28', 3);
INSERT INTO DININGHISTORY VALUES (8, 6, 42, '2025-06-09', 1);
INSERT INTO DININGHISTORY VALUES (9, 24, 43, '2025-11-06', 1);
INSERT INTO DININGHISTORY VALUES (10, 26, 41, '2025-05-24', 2);
INSERT INTO DININGHISTORY VALUES (11, 28, 42, '2025-02-23', 1);
INSERT INTO DININGHISTORY VALUES (12, 1, 14, '2025-08-03', 2);
INSERT INTO DININGHISTORY VALUES (13, 38, 15, '2025-09-22', 4);
INSERT INTO DININGHISTORY VALUES (14, 1, 1, '2025-12-11', 1);
INSERT INTO DININGHISTORY VALUES (15, 28, 45, '2025-03-16', 1);
INSERT INTO DININGHISTORY VALUES (16, 15, 25, '2025-02-24', 1);
INSERT INTO DININGHISTORY VALUES (17, 7, 21, '2025-06-10', 2);
INSERT INTO DININGHISTORY VALUES (18, 25, 50, '2025-03-21', 2);
INSERT INTO DININGHISTORY VALUES (19, 5, 34, '2025-10-01', 5);
INSERT INTO DININGHISTORY VALUES (20, 42, 11, '2025-08-12', 2);
INSERT INTO DININGHISTORY VALUES (21, 41, 48, '2025-03-14', 5);
INSERT INTO DININGHISTORY VALUES (22, 44, 29, '2025-04-03', 1);
INSERT INTO DININGHISTORY VALUES (23, 9, 49, '2025-02-19', 4);
INSERT INTO DININGHISTORY VALUES (24, 23, 28, '2025-06-26', 2);
INSERT INTO DININGHISTORY VALUES (25, 16, 18, '2025-11-03', 2);
INSERT INTO DININGHISTORY VALUES (26, 36, 39, '2025-10-24', 5);
INSERT INTO DININGHISTORY VALUES (27, 19, 50, '2025-12-01', 3);
INSERT INTO DININGHISTORY VALUES (28, 14, 34, '2025-10-17', 2);
INSERT INTO DININGHISTORY VALUES (29, 48, 26, '2025-05-21', 1);
INSERT INTO DININGHISTORY VALUES (30, 16, 32, '2025-07-04', 2);
INSERT INTO DININGHISTORY VALUES (31, 32, 41, '2025-10-03', 5);
INSERT INTO DININGHISTORY VALUES (32, 1, 24, '2025-06-05', 4);
INSERT INTO DININGHISTORY VALUES (33, 37, 27, '2025-06-18', 2);
INSERT INTO DININGHISTORY VALUES (34, 49, 31, '2025-02-01', 5);
INSERT INTO DININGHISTORY VALUES (35, 5, 1, '2025-05-07', 1);
INSERT INTO DININGHISTORY VALUES (36, 4, 26, '2025-09-10', 5);
INSERT INTO DININGHISTORY VALUES (37, 50, 27, '2025-07-23', 4);
INSERT INTO DININGHISTORY VALUES (38, 6, 41, '2025-09-18', 5);
INSERT INTO DININGHISTORY VALUES (39, 10, 18, '2025-02-10', 1);
INSERT INTO DININGHISTORY VALUES (40, 33, 14, '2025-03-18', 3);
INSERT INTO DININGHISTORY VALUES (41, 26, 38, '2025-11-25', 1);
INSERT INTO DININGHISTORY VALUES (42, 20, 45, '2025-07-24', 2);
INSERT INTO DININGHISTORY VALUES (43, 4, 16, '2025-02-14', 1);
INSERT INTO DININGHISTORY VALUES (44, 30, 40, '2025-10-02', 3);
INSERT INTO DININGHISTORY VALUES (45, 43, 48, '2025-11-24', 2);
INSERT INTO DININGHISTORY VALUES (46, 8, 1, '2025-12-05', 1);
INSERT INTO DININGHISTORY VALUES (47, 11, 32, '2025-06-17', 5);
INSERT INTO DININGHISTORY VALUES (48, 47, 17, '2025-03-12', 2);
INSERT INTO DININGHISTORY VALUES (49, 48, 50, '2025-05-24', 1);
INSERT INTO DININGHISTORY VALUES (50, 50, 2, '2025-06-26', 4);
INSERT INTO DININGHISTORY VALUES (51, 18, 34, '2025-02-09', 5);
INSERT INTO DININGHISTORY VALUES (52, 41, 5, '2025-08-15', 5);
INSERT INTO DININGHISTORY VALUES (53, 24, 4, '2025-08-28', 5);
INSERT INTO DININGHISTORY VALUES (54, 11, 24, '2025-03-09', 1);
INSERT INTO DININGHISTORY VALUES (55, 37, 44, '2025-12-04', 2);
INSERT INTO DININGHISTORY VALUES (56, 48, 33, '2025-01-02', 1);
INSERT INTO DININGHISTORY VALUES (57, 16, 3, '2025-08-12', 4);
INSERT INTO DININGHISTORY VALUES (58, 10, 12, '2025-01-18', 4);
INSERT INTO DININGHISTORY VALUES (59, 15, 21, '2025-04-14', 3);
INSERT INTO DININGHISTORY VALUES (60, 18, 5, '2025-10-12', 1);
INSERT INTO DININGHISTORY VALUES (61, 33, 44, '2025-01-06', 2);
INSERT INTO DININGHISTORY VALUES (62, 34, 3, '2025-07-03', 4);
INSERT INTO DININGHISTORY VALUES (63, 19, 50, '2025-05-11', 1);
INSERT INTO DININGHISTORY VALUES (64, 36, 30, '2025-01-12', 2);
INSERT INTO DININGHISTORY VALUES (65, 19, 37, '2025-05-24', 5);
INSERT INTO DININGHISTORY VALUES (66, 16, 30, '2025-06-19', 4);
INSERT INTO DININGHISTORY VALUES (67, 50, 50, '2025-04-24', 5);
INSERT INTO DININGHISTORY VALUES (68, 49, 16, '2025-03-01', 4);
INSERT INTO DININGHISTORY VALUES (69, 2, 15, '2025-09-12', 1);
INSERT INTO DININGHISTORY VALUES (70, 22, 1, '2025-11-13', 3);
INSERT INTO DININGHISTORY VALUES (71, 7, 14, '2025-09-08', 4);
INSERT INTO DININGHISTORY VALUES (72, 32, 4, '2025-03-23', 3);
INSERT INTO DININGHISTORY VALUES (73, 6, 3, '2025-04-28', 5);
INSERT INTO DININGHISTORY VALUES (74, 27, 45, '2025-06-15', 1);
INSERT INTO DININGHISTORY VALUES (75, 38, 7, '2025-09-05', 4);

-- RESTAURANTSUBMISSION (50 rows)
INSERT INTO RESTAURANTSUBMISSION VALUES (1, 5, 3, 'Submitted Restaurant 1', '582 First Ave', 43, 'Spanish', 'Rooftop', 'approved', '2025-05-28 10:59:51', '2025-06-04 10:59:51');
INSERT INTO RESTAURANTSUBMISSION VALUES (2, 45, 3, 'Submitted Restaurant 2', '335 Third Ave', 18, 'Moroccan', 'Late Night', 'approved', '2025-03-25 18:06:09', '2025-03-27 18:06:09');
INSERT INTO RESTAURANTSUBMISSION VALUES (3, 11, 2, 'Submitted Restaurant 3', '478 Third Ave', 8, 'Seafood', 'Locally Sourced', 'approved', '2025-08-10 14:16:54', '2025-08-12 14:16:54');
INSERT INTO RESTAURANTSUBMISSION VALUES (4, 6, 1, 'Submitted Restaurant 4', '827 Third Blvd', 45, 'American', 'Live Music', 'approved', '2025-06-05 02:45:15', '2025-06-11 02:45:15');
INSERT INTO RESTAURANTSUBMISSION VALUES (5, 26, 3, 'Submitted Restaurant 5', '51 Third Ave', 12, 'Mexican', 'Buffet', 'approved', '2025-09-24 17:15:06', '2025-10-02 17:15:06');
INSERT INTO RESTAURANTSUBMISSION VALUES (6, 7, 1, 'Submitted Restaurant 6', '125 First St', 50, 'Moroccan', 'Dine-In', 'approved', '2025-07-12 21:40:41', '2025-07-14 21:40:41');
INSERT INTO RESTAURANTSUBMISSION VALUES (7, 38, 3, 'Submitted Restaurant 7', '266 First St', 5, 'Turkish', 'Private Events', 'approved', '2025-02-28 10:07:02', '2025-03-08 10:07:02');
INSERT INTO RESTAURANTSUBMISSION VALUES (8, 4, NULL, 'Submitted Restaurant 8', '947 Fifth Ave', 47, 'Irish', 'Reservations', 'pending', '2025-07-22 13:11:22', NULL);
INSERT INTO RESTAURANTSUBMISSION VALUES (9, 14, 1, 'Submitted Restaurant 9', '282 Third Ave', 10, 'Chinese', 'Family Style', 'rejected', '2025-10-08 20:18:31', '2025-10-15 20:18:31');
INSERT INTO RESTAURANTSUBMISSION VALUES (10, 36, 2, 'Submitted Restaurant 10', '63 First Ave', 25, 'Spanish', 'Food Truck', 'approved', '2025-11-26 16:15:40', '2025-12-09 16:15:40');
INSERT INTO RESTAURANTSUBMISSION VALUES (11, 35, 1, 'Submitted Restaurant 11', '392 Third Ave', 35, 'Cajun', 'Locally Sourced', 'rejected', '2025-09-11 12:17:11', '2025-09-12 12:17:11');
INSERT INTO RESTAURANTSUBMISSION VALUES (12, 21, 3, 'Submitted Restaurant 12', '225 First Ave', 4, 'Mediterranean', 'BYOB', 'approved', '2025-10-08 05:06:15', '2025-10-19 05:06:15');
INSERT INTO RESTAURANTSUBMISSION VALUES (13, 16, 2, 'Submitted Restaurant 13', '547 First St', 37, 'British', 'Locally Sourced', 'approved', '2025-03-08 18:20:51', '2025-03-20 18:20:51');
INSERT INTO RESTAURANTSUBMISSION VALUES (14, 45, 2, 'Submitted Restaurant 14', '936 Fifth St', 46, 'Salvadoran', 'Locally Sourced', 'rejected', '2025-10-05 18:12:53', '2025-10-18 18:12:53');
INSERT INTO RESTAURANTSUBMISSION VALUES (15, 32, 3, 'Submitted Restaurant 15', '317 Second Ave', 3, 'Thai', 'Happy Hour', 'approved', '2025-10-08 00:33:30', '2025-10-09 00:33:30');
INSERT INTO RESTAURANTSUBMISSION VALUES (16, 22, NULL, 'Submitted Restaurant 16', '207 Second Ave', 46, 'Ethiopian', 'Farm to Table', 'pending', '2025-01-05 18:45:58', NULL);
INSERT INTO RESTAURANTSUBMISSION VALUES (17, 10, 1, 'Submitted Restaurant 17', '867 Fifth Ave', 5, 'German', 'Buffet', 'rejected', '2025-02-11 09:20:08', '2025-02-14 09:20:08');
INSERT INTO RESTAURANTSUBMISSION VALUES (18, 47, 2, 'Submitted Restaurant 18', '811 Fourth Blvd', 21, 'Ethiopian', 'Historic Building', 'rejected', '2025-06-08 21:37:52', '2025-06-11 21:37:52');
INSERT INTO RESTAURANTSUBMISSION VALUES (19, 25, 2, 'Submitted Restaurant 19', '752 Third St', 12, 'Italian', 'Trendy', 'approved', '2025-10-02 05:38:20', '2025-10-15 05:38:20');
INSERT INTO RESTAURANTSUBMISSION VALUES (20, 40, NULL, 'Submitted Restaurant 20', '655 Fifth St', 32, 'Korean', 'Organic', 'pending', '2025-04-12 10:10:40', NULL);
INSERT INTO RESTAURANTSUBMISSION VALUES (21, 6, 3, 'Submitted Restaurant 21', '687 Third Ave', 1, 'Brazilian', 'Group Dining', 'approved', '2025-12-03 11:16:50', '2025-12-05 11:16:50');
INSERT INTO RESTAURANTSUBMISSION VALUES (22, 47, 1, 'Submitted Restaurant 22', '50 Fourth Ave', 47, 'Polish', 'Wheelchair Accessible', 'approved', '2025-08-13 11:34:24', '2025-08-15 11:34:24');
INSERT INTO RESTAURANTSUBMISSION VALUES (23, 31, 3, 'Submitted Restaurant 23', '667 Second St', 29, 'Indian', 'Live Music', 'approved', '2025-01-11 08:06:04', '2025-01-17 08:06:04');
INSERT INTO RESTAURANTSUBMISSION VALUES (24, 11, 2, 'Submitted Restaurant 24', '165 First Blvd', 6, 'Indonesian', 'Romantic', 'rejected', '2025-08-23 00:27:41', '2025-08-26 00:27:41');
INSERT INTO RESTAURANTSUBMISSION VALUES (25, 39, 2, 'Submitted Restaurant 25', '161 First St', 22, 'Lebanese', 'Date Night', 'approved', '2025-12-18 23:59:46', '2025-12-27 23:59:46');
INSERT INTO RESTAURANTSUBMISSION VALUES (26, 17, 3, 'Submitted Restaurant 26', '289 Third St', 7, 'Japanese', 'Buffet', 'rejected', '2025-09-27 15:09:03', '2025-10-03 15:09:03');
INSERT INTO RESTAURANTSUBMISSION VALUES (27, 1, 2, 'Submitted Restaurant 27', '90 Third Blvd', 41, 'American', 'Parking Available', 'approved', '2025-02-01 06:10:40', '2025-02-06 06:10:40');
INSERT INTO RESTAURANTSUBMISSION VALUES (28, 6, 2, 'Submitted Restaurant 28', '865 First Ave', 26, 'Mediterranean', 'Reservations', 'approved', '2025-02-21 17:24:11', '2025-02-27 17:24:11');
INSERT INTO RESTAURANTSUBMISSION VALUES (29, 25, 2, 'Submitted Restaurant 29', '192 Fourth St', 17, 'Ukrainian', 'Free WiFi', 'approved', '2025-04-27 08:36:03', '2025-04-30 08:36:03');
INSERT INTO RESTAURANTSUBMISSION VALUES (30, 49, 3, 'Submitted Restaurant 30', '684 First St', 43, 'Taiwanese', 'Scenic View', 'approved', '2025-10-08 17:03:53', '2025-10-15 17:03:53');
INSERT INTO RESTAURANTSUBMISSION VALUES (31, 34, 2, 'Submitted Restaurant 31', '989 Fifth Blvd', 31, 'Vegan', 'Rooftop', 'approved', '2025-05-03 12:57:54', '2025-05-15 12:57:54');
INSERT INTO RESTAURANTSUBMISSION VALUES (32, 3, NULL, 'Submitted Restaurant 32', '585 Fifth Blvd', 44, 'Hawaiian', 'Drive-Through', 'pending', '2025-08-06 05:13:51', NULL);
INSERT INTO RESTAURANTSUBMISSION VALUES (33, 13, 1, 'Submitted Restaurant 33', '44 Fourth St', 44, 'Russian', 'Date Night', 'approved', '2025-10-09 10:58:46', '2025-10-22 10:58:46');
INSERT INTO RESTAURANTSUBMISSION VALUES (34, 5, 1, 'Submitted Restaurant 34', '398 Fifth Ave', 36, 'Malaysian', 'Craft Cocktails', 'rejected', '2025-08-28 00:50:44', '2025-09-07 00:50:44');
INSERT INTO RESTAURANTSUBMISSION VALUES (35, 38, 3, 'Submitted Restaurant 35', '801 Fourth St', 27, 'Korean', 'Drive-Through', 'rejected', '2025-10-19 03:59:06', '2025-10-29 03:59:06');
INSERT INTO RESTAURANTSUBMISSION VALUES (36, 50, 1, 'Submitted Restaurant 36', '805 Third Blvd', 23, 'Polish', 'Sports Bar', 'approved', '2025-11-16 18:38:30', '2025-11-17 18:38:30');
INSERT INTO RESTAURANTSUBMISSION VALUES (37, 12, NULL, 'Submitted Restaurant 37', '413 Second Blvd', 39, 'Nepalese', 'Buffet', 'pending', '2025-07-11 22:15:03', NULL);
INSERT INTO RESTAURANTSUBMISSION VALUES (38, 48, 2, 'Submitted Restaurant 38', '943 Third Ave', 2, 'Indonesian', 'Beer Garden', 'approved', '2025-05-27 15:54:44', '2025-06-07 15:54:44');
INSERT INTO RESTAURANTSUBMISSION VALUES (39, 7, 1, 'Submitted Restaurant 39', '138 Third Blvd', 29, 'Malaysian', 'Craft Cocktails', 'approved', '2025-10-21 02:12:28', '2025-10-25 02:12:28');
INSERT INTO RESTAURANTSUBMISSION VALUES (40, 27, NULL, 'Submitted Restaurant 40', '497 Fifth Ave', 4, 'Southern', 'Wheelchair Accessible', 'pending', '2025-05-23 16:25:08', NULL);
INSERT INTO RESTAURANTSUBMISSION VALUES (41, 50, NULL, 'Submitted Restaurant 41', '901 Fifth St', 12, 'Turkish', 'Date Night', 'pending', '2025-04-02 14:03:58', NULL);
INSERT INTO RESTAURANTSUBMISSION VALUES (42, 24, NULL, 'Submitted Restaurant 42', '204 Third Ave', 30, 'Southern', 'Buffet', 'pending', '2025-11-01 07:23:31', NULL);
INSERT INTO RESTAURANTSUBMISSION VALUES (43, 39, 2, 'Submitted Restaurant 43', '182 Fourth Blvd', 36, 'Taiwanese', 'Locally Sourced', 'approved', '2025-05-24 22:05:18', '2025-05-25 22:05:18');
INSERT INTO RESTAURANTSUBMISSION VALUES (44, 25, 1, 'Submitted Restaurant 44', '167 Fifth St', 15, 'Soul Food', 'Waterfront', 'approved', '2025-05-21 13:32:01', '2025-06-04 13:32:01');
INSERT INTO RESTAURANTSUBMISSION VALUES (45, 50, NULL, 'Submitted Restaurant 45', '10 Fourth St', 42, 'Ethiopian', 'Romantic', 'pending', '2025-04-09 19:51:19', NULL);
INSERT INTO RESTAURANTSUBMISSION VALUES (46, 46, 3, 'Submitted Restaurant 46', '659 Third Ave', 25, 'Taiwanese', 'Free WiFi', 'approved', '2025-04-15 09:43:33', '2025-04-29 09:43:33');
INSERT INTO RESTAURANTSUBMISSION VALUES (47, 40, 2, 'Submitted Restaurant 47', '599 First St', 33, 'Afghan', 'Fast Casual', 'rejected', '2025-11-20 19:18:19', '2025-12-01 19:18:19');
INSERT INTO RESTAURANTSUBMISSION VALUES (48, 7, 2, 'Submitted Restaurant 48', '66 Third Ave', 41, 'Malaysian', 'Craft Cocktails', 'approved', '2025-11-23 20:19:12', '2025-11-26 20:19:12');
INSERT INTO RESTAURANTSUBMISSION VALUES (49, 34, 1, 'Submitted Restaurant 49', '922 First Blvd', 26, 'Afghan', 'Farm to Table', 'approved', '2025-12-01 20:31:18', '2025-12-06 20:31:18');
INSERT INTO RESTAURANTSUBMISSION VALUES (50, 27, 2, 'Submitted Restaurant 50', '398 First Blvd', 46, 'Vegan', 'Date Night', 'approved', '2025-12-23 07:43:34', '2026-01-03 07:43:34');

-- USERCOMPLAINT (50 rows)
INSERT INTO USERCOMPLAINT VALUES (1, 31, 43, 'Overcharged on my bill.', 'resolved', '2025-05-28 05:53:42', '2025-06-26 05:53:42');
INSERT INTO USERCOMPLAINT VALUES (2, 36, 12, 'Incorrect order delivered twice.', 'open', '2025-08-05 23:16:46', NULL);
INSERT INTO USERCOMPLAINT VALUES (3, 36, 49, 'Found a hair in my food.', 'resolved', '2025-06-21 02:14:22', '2025-06-29 02:14:22');
INSERT INTO USERCOMPLAINT VALUES (4, 48, 20, 'Restaurant was not clean.', 'in_review', '2025-06-09 18:18:29', NULL);
INSERT INTO USERCOMPLAINT VALUES (5, 8, 31, 'Food was undercooked and unsafe.', 'resolved', '2025-10-19 19:04:30', '2025-11-17 19:04:30');
INSERT INTO USERCOMPLAINT VALUES (6, 13, 33, 'Rude staff and poor service.', 'resolved', '2025-07-17 09:26:03', '2025-08-14 09:26:03');
INSERT INTO USERCOMPLAINT VALUES (7, 10, 9, 'Waited over an hour for my order.', 'in_review', '2025-07-19 14:09:20', NULL);
INSERT INTO USERCOMPLAINT VALUES (8, 46, 12, 'Rude staff and poor service.', 'resolved', '2025-06-21 05:20:40', '2025-06-23 05:20:40');
INSERT INTO USERCOMPLAINT VALUES (9, 1, 29, 'Incorrect order delivered twice.', 'open', '2025-03-19 05:31:50', NULL);
INSERT INTO USERCOMPLAINT VALUES (10, 49, 50, 'Rude staff and poor service.', 'open', '2025-10-14 20:27:25', NULL);
INSERT INTO USERCOMPLAINT VALUES (11, 28, 31, 'Restaurant was not clean.', 'open', '2025-01-18 06:46:23', NULL);
INSERT INTO USERCOMPLAINT VALUES (12, 1, 21, 'Reservation was lost.', 'open', '2025-01-22 00:40:46', NULL);
INSERT INTO USERCOMPLAINT VALUES (13, 16, 15, 'Overcharged on my bill.', 'in_review', '2025-03-04 12:32:37', NULL);
INSERT INTO USERCOMPLAINT VALUES (14, 20, 11, 'Rude staff and poor service.', 'open', '2025-05-10 14:46:33', NULL);
INSERT INTO USERCOMPLAINT VALUES (15, 39, 34, 'Overcharged on my bill.', 'resolved', '2025-11-05 10:57:31', '2025-11-17 10:57:31');
INSERT INTO USERCOMPLAINT VALUES (16, 49, 13, 'Found a hair in my food.', 'resolved', '2025-01-08 07:46:08', '2025-01-15 07:46:08');
INSERT INTO USERCOMPLAINT VALUES (17, 47, 2, 'Noise level was unbearable.', 'resolved', '2025-03-04 11:45:41', '2025-03-30 11:45:41');
INSERT INTO USERCOMPLAINT VALUES (18, 3, 25, 'Incorrect order delivered twice.', 'resolved', '2025-10-02 19:03:42', '2025-10-06 19:03:42');
INSERT INTO USERCOMPLAINT VALUES (19, 42, 2, 'Food was undercooked and unsafe.', 'resolved', '2025-02-14 14:24:07', '2025-03-04 14:24:07');
INSERT INTO USERCOMPLAINT VALUES (20, 17, 31, 'Found a hair in my food.', 'open', '2025-12-22 20:00:19', NULL);
INSERT INTO USERCOMPLAINT VALUES (21, 27, 43, 'Rude staff and poor service.', 'resolved', '2025-09-09 19:38:44', '2025-09-14 19:38:44');
INSERT INTO USERCOMPLAINT VALUES (22, 27, 7, 'Reservation was lost.', 'resolved', '2025-10-04 09:07:50', '2025-10-08 09:07:50');
INSERT INTO USERCOMPLAINT VALUES (23, 32, 13, 'Noise level was unbearable.', 'open', '2025-05-27 16:12:22', NULL);
INSERT INTO USERCOMPLAINT VALUES (24, 46, 27, 'Incorrect order delivered twice.', 'open', '2025-01-18 15:58:13', NULL);
INSERT INTO USERCOMPLAINT VALUES (25, 45, 31, 'Overcharged on my bill.', 'open', '2025-01-01 21:05:58', NULL);
INSERT INTO USERCOMPLAINT VALUES (26, 8, 37, 'Allergen information was wrong.', 'open', '2025-02-25 16:04:46', NULL);
INSERT INTO USERCOMPLAINT VALUES (27, 47, 7, 'Incorrect order delivered twice.', 'resolved', '2025-04-15 09:16:29', '2025-04-17 09:16:29');
INSERT INTO USERCOMPLAINT VALUES (28, 7, 12, 'Food was undercooked and unsafe.', 'in_review', '2025-06-26 21:20:27', NULL);
INSERT INTO USERCOMPLAINT VALUES (29, 48, 8, 'Rude staff and poor service.', 'open', '2025-01-28 04:42:41', NULL);
INSERT INTO USERCOMPLAINT VALUES (30, 11, 22, 'Overcharged on my bill.', 'resolved', '2025-10-09 23:05:23', '2025-11-05 23:05:23');
INSERT INTO USERCOMPLAINT VALUES (31, 22, 12, 'Rude staff and poor service.', 'resolved', '2025-07-15 08:53:24', '2025-08-07 08:53:24');
INSERT INTO USERCOMPLAINT VALUES (32, 31, 27, 'Found a hair in my food.', 'open', '2025-03-23 23:03:54', NULL);
INSERT INTO USERCOMPLAINT VALUES (33, 11, 7, 'Restaurant was not clean.', 'resolved', '2025-08-26 18:43:28', '2025-09-01 18:43:28');
INSERT INTO USERCOMPLAINT VALUES (34, 40, 25, 'Overcharged on my bill.', 'resolved', '2025-01-28 21:56:53', '2025-02-21 21:56:53');
INSERT INTO USERCOMPLAINT VALUES (35, 9, 31, 'Allergen information was wrong.', 'open', '2025-07-15 01:04:16', NULL);
INSERT INTO USERCOMPLAINT VALUES (36, 42, 21, 'Food was undercooked and unsafe.', 'resolved', '2025-11-17 23:36:46', '2025-12-06 23:36:46');
INSERT INTO USERCOMPLAINT VALUES (37, 15, 43, 'Overcharged on my bill.', 'resolved', '2025-09-23 22:39:06', '2025-10-07 22:39:06');
INSERT INTO USERCOMPLAINT VALUES (38, 43, 47, 'Waited over an hour for my order.', 'resolved', '2025-06-22 21:41:24', '2025-06-27 21:41:24');
INSERT INTO USERCOMPLAINT VALUES (39, 36, 40, 'Food was undercooked and unsafe.', 'open', '2025-11-06 16:54:30', NULL);
INSERT INTO USERCOMPLAINT VALUES (40, 32, 11, 'Rude staff and poor service.', 'resolved', '2025-06-08 10:17:03', '2025-06-25 10:17:03');
INSERT INTO USERCOMPLAINT VALUES (41, 15, 36, 'Restaurant was not clean.', 'resolved', '2025-04-03 14:28:51', '2025-04-22 14:28:51');
INSERT INTO USERCOMPLAINT VALUES (42, 29, 6, 'Allergen information was wrong.', 'resolved', '2025-06-04 15:47:41', '2025-06-05 15:47:41');
INSERT INTO USERCOMPLAINT VALUES (43, 7, 26, 'Restaurant was not clean.', 'open', '2025-09-18 00:52:05', NULL);
INSERT INTO USERCOMPLAINT VALUES (44, 39, 40, 'Incorrect order delivered twice.', 'resolved', '2025-09-07 20:42:29', '2025-09-18 20:42:29');
INSERT INTO USERCOMPLAINT VALUES (45, 24, 4, 'Waited over an hour for my order.', 'resolved', '2025-06-18 19:38:30', '2025-07-11 19:38:30');
INSERT INTO USERCOMPLAINT VALUES (46, 43, 24, 'Allergen information was wrong.', 'open', '2025-02-25 21:14:00', NULL);
INSERT INTO USERCOMPLAINT VALUES (47, 22, 23, 'Incorrect order delivered twice.', 'resolved', '2025-09-12 22:06:02', '2025-10-11 22:06:02');
INSERT INTO USERCOMPLAINT VALUES (48, 11, 32, 'Found a hair in my food.', 'resolved', '2025-12-24 13:06:16', '2026-01-13 13:06:16');
INSERT INTO USERCOMPLAINT VALUES (49, 13, 13, 'Rude staff and poor service.', 'resolved', '2025-04-15 06:45:21', '2025-04-19 06:45:21');
INSERT INTO USERCOMPLAINT VALUES (50, 49, 27, 'Food was undercooked and unsafe.', 'resolved', '2025-11-19 03:49:57', '2025-12-04 03:49:57');

-- EXPORTREPORT (50 rows)
INSERT INTO EXPORTREPORT VALUES (1, 2, 43, 38, '2025-09-05 15:00:33', 'PDF');
INSERT INTO EXPORTREPORT VALUES (2, 3, 28, 38, '2025-08-17 05:44:37', 'CSV');
INSERT INTO EXPORTREPORT VALUES (3, 3, 9, 7, '2025-07-22 19:38:56', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (4, 3, 25, 27, '2025-10-23 07:17:25', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (5, 2, 29, 9, '2025-03-14 19:44:56', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (6, 3, 36, 21, '2025-12-24 17:40:13', 'CSV');
INSERT INTO EXPORTREPORT VALUES (7, 1, 40, 19, '2025-11-12 21:08:45', 'CSV');
INSERT INTO EXPORTREPORT VALUES (8, 3, 35, 45, '2025-11-11 22:07:48', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (9, 3, 31, 38, '2025-10-22 22:26:43', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (10, 2, 1, 34, '2025-02-01 12:09:03', 'PDF');
INSERT INTO EXPORTREPORT VALUES (11, 1, 18, 11, '2025-05-22 08:09:53', 'PDF');
INSERT INTO EXPORTREPORT VALUES (12, 3, 19, 14, '2025-09-02 11:52:28', 'PDF');
INSERT INTO EXPORTREPORT VALUES (13, 3, 44, 36, '2025-04-24 20:35:24', 'CSV');
INSERT INTO EXPORTREPORT VALUES (14, 3, 45, 19, '2025-12-22 01:59:24', 'JSON');
INSERT INTO EXPORTREPORT VALUES (15, 2, 44, 21, '2025-09-02 00:47:16', 'CSV');
INSERT INTO EXPORTREPORT VALUES (16, 3, 50, 29, '2025-04-21 22:45:41', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (17, 3, 35, 39, '2025-04-25 23:12:18', 'JSON');
INSERT INTO EXPORTREPORT VALUES (18, 1, 44, 5, '2025-03-06 23:32:07', 'JSON');
INSERT INTO EXPORTREPORT VALUES (19, 1, 28, 18, '2025-09-09 04:10:37', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (20, 1, 22, 30, '2025-12-05 01:09:59', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (21, 3, 4, 41, '2025-10-27 21:19:31', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (22, 1, 46, 21, '2025-09-08 05:33:04', 'CSV');
INSERT INTO EXPORTREPORT VALUES (23, 2, 35, 35, '2025-07-03 11:14:56', 'CSV');
INSERT INTO EXPORTREPORT VALUES (24, 3, 22, 22, '2025-06-10 06:48:39', 'JSON');
INSERT INTO EXPORTREPORT VALUES (25, 3, 49, 42, '2025-01-04 21:22:28', 'CSV');
INSERT INTO EXPORTREPORT VALUES (26, 3, 40, 40, '2025-04-02 21:56:20', 'JSON');
INSERT INTO EXPORTREPORT VALUES (27, 1, 25, 17, '2025-09-24 09:01:58', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (28, 3, 33, 29, '2025-08-02 09:57:41', 'CSV');
INSERT INTO EXPORTREPORT VALUES (29, 2, 33, 6, '2025-02-06 17:34:00', 'PDF');
INSERT INTO EXPORTREPORT VALUES (30, 1, 43, 41, '2025-04-28 21:27:53', 'PDF');
INSERT INTO EXPORTREPORT VALUES (31, 1, 35, 45, '2025-12-25 13:41:52', 'PDF');
INSERT INTO EXPORTREPORT VALUES (32, 3, 44, 10, '2025-01-15 22:21:02', 'PDF');
INSERT INTO EXPORTREPORT VALUES (33, 1, 4, 12, '2025-05-18 02:36:52', 'CSV');
INSERT INTO EXPORTREPORT VALUES (34, 2, 27, 25, '2025-08-21 12:27:20', 'PDF');
INSERT INTO EXPORTREPORT VALUES (35, 2, 44, 8, '2025-09-01 20:46:39', 'PDF');
INSERT INTO EXPORTREPORT VALUES (36, 3, 38, 3, '2025-12-28 02:22:59', 'PDF');
INSERT INTO EXPORTREPORT VALUES (37, 2, 44, 20, '2025-10-03 09:48:59', 'JSON');
INSERT INTO EXPORTREPORT VALUES (38, 2, 26, 43, '2025-01-16 05:34:14', 'CSV');
INSERT INTO EXPORTREPORT VALUES (39, 3, 26, 35, '2025-05-21 04:19:43', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (40, 1, 36, 36, '2025-03-04 01:00:36', 'JSON');
INSERT INTO EXPORTREPORT VALUES (41, 3, 36, 6, '2025-05-07 23:47:57', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (42, 1, 27, 42, '2025-09-05 05:11:14', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (43, 1, 8, 12, '2025-11-26 18:54:03', 'JSON');
INSERT INTO EXPORTREPORT VALUES (44, 3, 36, 5, '2025-05-22 02:16:06', 'CSV');
INSERT INTO EXPORTREPORT VALUES (45, 3, 38, 32, '2025-06-12 04:42:41', 'CSV');
INSERT INTO EXPORTREPORT VALUES (46, 1, 19, 40, '2025-02-07 10:31:28', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (47, 3, 43, 20, '2025-12-19 04:36:36', 'XLSX');
INSERT INTO EXPORTREPORT VALUES (48, 2, 28, 11, '2025-01-11 07:50:14', 'JSON');
INSERT INTO EXPORTREPORT VALUES (49, 2, 24, 9, '2025-11-24 10:56:30', 'JSON');
INSERT INTO EXPORTREPORT VALUES (50, 2, 23, 20, '2025-08-18 03:11:41', 'PDF');

-- GROUPRESTAURANTVOTE (75 rows)
INSERT INTO GROUPRESTAURANTVOTE VALUES (1, 18, 9, 35, 0, '2025-05-24 20:04:46');
INSERT INTO GROUPRESTAURANTVOTE VALUES (2, 5, 2, 33, -1, '2025-10-19 12:49:37');
INSERT INTO GROUPRESTAURANTVOTE VALUES (3, 14, 3, 36, 1, '2025-09-18 15:41:49');
INSERT INTO GROUPRESTAURANTVOTE VALUES (4, 10, 24, 26, 0, '2025-10-24 09:08:29');
INSERT INTO GROUPRESTAURANTVOTE VALUES (5, 33, 33, 6, 1, '2025-06-17 00:42:15');
INSERT INTO GROUPRESTAURANTVOTE VALUES (6, 40, 44, 11, 1, '2025-03-15 05:11:36');
INSERT INTO GROUPRESTAURANTVOTE VALUES (7, 37, 43, 10, 1, '2025-06-02 07:48:31');
INSERT INTO GROUPRESTAURANTVOTE VALUES (8, 15, 5, 17, 1, '2025-04-02 21:13:33');
INSERT INTO GROUPRESTAURANTVOTE VALUES (9, 24, 25, 31, 1, '2025-01-02 20:20:06');
INSERT INTO GROUPRESTAURANTVOTE VALUES (10, 34, 41, 18, 1, '2025-10-18 18:11:24');
INSERT INTO GROUPRESTAURANTVOTE VALUES (11, 42, 25, 24, 1, '2025-11-27 02:33:16');
INSERT INTO GROUPRESTAURANTVOTE VALUES (12, 25, 15, 34, 1, '2025-06-27 11:31:50');
INSERT INTO GROUPRESTAURANTVOTE VALUES (13, 31, 39, 1, 1, '2025-03-15 05:14:04');
INSERT INTO GROUPRESTAURANTVOTE VALUES (14, 33, 42, 18, 0, '2025-03-06 05:23:38');
INSERT INTO GROUPRESTAURANTVOTE VALUES (15, 8, 43, 15, 1, '2025-06-24 03:30:43');
INSERT INTO GROUPRESTAURANTVOTE VALUES (16, 31, 31, 14, 1, '2025-03-21 13:01:15');
INSERT INTO GROUPRESTAURANTVOTE VALUES (17, 3, 9, 37, 1, '2025-03-05 20:32:02');
INSERT INTO GROUPRESTAURANTVOTE VALUES (18, 37, 10, 4, 0, '2025-05-06 16:25:38');
INSERT INTO GROUPRESTAURANTVOTE VALUES (19, 37, 41, 2, 1, '2025-02-07 14:38:30');
INSERT INTO GROUPRESTAURANTVOTE VALUES (20, 31, 11, 15, 1, '2025-10-05 18:52:49');
INSERT INTO GROUPRESTAURANTVOTE VALUES (21, 12, 40, 43, 1, '2025-05-06 23:43:21');
INSERT INTO GROUPRESTAURANTVOTE VALUES (22, 30, 39, 38, -1, '2025-04-13 12:08:06');
INSERT INTO GROUPRESTAURANTVOTE VALUES (23, 2, 13, 34, 1, '2025-11-14 04:38:06');
INSERT INTO GROUPRESTAURANTVOTE VALUES (24, 12, 31, 40, 1, '2025-01-26 17:32:48');
INSERT INTO GROUPRESTAURANTVOTE VALUES (25, 8, 6, 31, 0, '2025-10-18 00:57:49');
INSERT INTO GROUPRESTAURANTVOTE VALUES (26, 44, 42, 28, 1, '2025-07-12 01:44:33');
INSERT INTO GROUPRESTAURANTVOTE VALUES (27, 28, 15, 31, 1, '2025-06-19 23:58:48');
INSERT INTO GROUPRESTAURANTVOTE VALUES (28, 45, 37, 7, 1, '2025-03-09 15:49:14');
INSERT INTO GROUPRESTAURANTVOTE VALUES (29, 6, 19, 39, 1, '2025-07-09 06:00:45');
INSERT INTO GROUPRESTAURANTVOTE VALUES (30, 1, 37, 34, -1, '2025-09-01 12:41:13');
INSERT INTO GROUPRESTAURANTVOTE VALUES (31, 45, 21, 27, 1, '2025-02-05 13:41:37');
INSERT INTO GROUPRESTAURANTVOTE VALUES (32, 17, 17, 35, 1, '2025-10-12 19:17:43');
INSERT INTO GROUPRESTAURANTVOTE VALUES (33, 26, 49, 14, 1, '2025-09-26 17:30:11');
INSERT INTO GROUPRESTAURANTVOTE VALUES (34, 24, 36, 36, 1, '2025-05-10 18:22:49');
INSERT INTO GROUPRESTAURANTVOTE VALUES (35, 26, 48, 9, -1, '2025-12-08 14:50:44');
INSERT INTO GROUPRESTAURANTVOTE VALUES (36, 11, 7, 14, 1, '2025-07-26 10:51:35');
INSERT INTO GROUPRESTAURANTVOTE VALUES (37, 40, 45, 44, -1, '2025-03-13 20:00:51');
INSERT INTO GROUPRESTAURANTVOTE VALUES (38, 6, 10, 31, 1, '2025-07-03 02:16:14');
INSERT INTO GROUPRESTAURANTVOTE VALUES (39, 24, 6, 39, -1, '2025-12-13 12:39:41');
INSERT INTO GROUPRESTAURANTVOTE VALUES (40, 34, 19, 46, 1, '2025-01-25 05:40:31');
INSERT INTO GROUPRESTAURANTVOTE VALUES (41, 29, 1, 13, 1, '2025-05-07 01:50:38');
INSERT INTO GROUPRESTAURANTVOTE VALUES (42, 33, 34, 45, 0, '2025-10-06 21:02:23');
INSERT INTO GROUPRESTAURANTVOTE VALUES (43, 16, 42, 1, 0, '2025-02-09 12:22:42');
INSERT INTO GROUPRESTAURANTVOTE VALUES (44, 26, 26, 38, 0, '2025-09-01 23:45:04');
INSERT INTO GROUPRESTAURANTVOTE VALUES (45, 6, 36, 19, 1, '2025-10-12 11:52:17');
INSERT INTO GROUPRESTAURANTVOTE VALUES (46, 15, 39, 13, 1, '2025-07-19 00:16:11');
INSERT INTO GROUPRESTAURANTVOTE VALUES (47, 27, 33, 7, 1, '2025-02-17 09:21:07');
INSERT INTO GROUPRESTAURANTVOTE VALUES (48, 33, 17, 35, 1, '2025-05-23 14:24:36');
INSERT INTO GROUPRESTAURANTVOTE VALUES (49, 31, 50, 16, 1, '2025-08-22 14:57:37');
INSERT INTO GROUPRESTAURANTVOTE VALUES (50, 2, 31, 8, 1, '2025-02-13 20:50:14');
INSERT INTO GROUPRESTAURANTVOTE VALUES (51, 44, 45, 15, 1, '2025-07-12 16:34:00');
INSERT INTO GROUPRESTAURANTVOTE VALUES (52, 45, 17, 16, 1, '2025-02-13 21:47:52');
INSERT INTO GROUPRESTAURANTVOTE VALUES (53, 22, 5, 36, 0, '2025-08-11 11:13:57');
INSERT INTO GROUPRESTAURANTVOTE VALUES (54, 37, 18, 12, 0, '2025-08-24 06:15:47');
INSERT INTO GROUPRESTAURANTVOTE VALUES (55, 16, 17, 14, 0, '2025-04-27 07:53:39');
INSERT INTO GROUPRESTAURANTVOTE VALUES (56, 23, 10, 50, -1, '2025-02-03 21:42:31');
INSERT INTO GROUPRESTAURANTVOTE VALUES (57, 40, 1, 49, 1, '2025-01-28 15:23:39');
INSERT INTO GROUPRESTAURANTVOTE VALUES (58, 21, 32, 37, 1, '2025-08-06 16:17:25');
INSERT INTO GROUPRESTAURANTVOTE VALUES (59, 15, 49, 37, 0, '2025-01-17 13:30:34');
INSERT INTO GROUPRESTAURANTVOTE VALUES (60, 3, 33, 23, 1, '2025-11-25 05:29:07');
INSERT INTO GROUPRESTAURANTVOTE VALUES (61, 45, 34, 30, 1, '2025-12-01 00:43:13');
INSERT INTO GROUPRESTAURANTVOTE VALUES (62, 25, 38, 7, 1, '2025-06-20 08:11:35');
INSERT INTO GROUPRESTAURANTVOTE VALUES (63, 17, 16, 18, 1, '2025-10-11 11:11:31');
INSERT INTO GROUPRESTAURANTVOTE VALUES (64, 28, 14, 27, 1, '2025-06-28 12:17:28');
INSERT INTO GROUPRESTAURANTVOTE VALUES (65, 12, 37, 9, 1, '2025-11-08 03:46:17');
INSERT INTO GROUPRESTAURANTVOTE VALUES (66, 16, 36, 28, 1, '2025-04-05 23:09:30');
INSERT INTO GROUPRESTAURANTVOTE VALUES (67, 1, 12, 27, 1, '2025-03-28 20:33:34');
INSERT INTO GROUPRESTAURANTVOTE VALUES (68, 21, 32, 20, 1, '2025-09-28 18:03:25');
INSERT INTO GROUPRESTAURANTVOTE VALUES (69, 7, 45, 11, -1, '2025-04-27 08:30:53');
INSERT INTO GROUPRESTAURANTVOTE VALUES (70, 41, 7, 29, 1, '2025-05-12 11:35:35');
INSERT INTO GROUPRESTAURANTVOTE VALUES (71, 17, 23, 2, 1, '2025-02-12 21:38:12');
INSERT INTO GROUPRESTAURANTVOTE VALUES (72, 37, 37, 42, 1, '2025-03-25 09:22:20');
INSERT INTO GROUPRESTAURANTVOTE VALUES (73, 44, 33, 32, 1, '2025-02-13 19:18:29');
INSERT INTO GROUPRESTAURANTVOTE VALUES (74, 41, 10, 11, 1, '2025-07-21 19:36:25');
INSERT INTO GROUPRESTAURANTVOTE VALUES (75, 5, 6, 11, 1, '2025-04-11 10:41:18');

-- RESTAURANTCUISINE (150 rows)
INSERT INTO RESTAURANTCUISINE VALUES (1, 11);
INSERT INTO RESTAURANTCUISINE VALUES (1, 34);
INSERT INTO RESTAURANTCUISINE VALUES (1, 45);
INSERT INTO RESTAURANTCUISINE VALUES (2, 3);
INSERT INTO RESTAURANTCUISINE VALUES (2, 10);
INSERT INTO RESTAURANTCUISINE VALUES (2, 12);
INSERT INTO RESTAURANTCUISINE VALUES (2, 45);
INSERT INTO RESTAURANTCUISINE VALUES (3, 38);
INSERT INTO RESTAURANTCUISINE VALUES (4, 2);
INSERT INTO RESTAURANTCUISINE VALUES (4, 4);
INSERT INTO RESTAURANTCUISINE VALUES (4, 18);
INSERT INTO RESTAURANTCUISINE VALUES (4, 35);
INSERT INTO RESTAURANTCUISINE VALUES (4, 43);
INSERT INTO RESTAURANTCUISINE VALUES (5, 35);
INSERT INTO RESTAURANTCUISINE VALUES (6, 28);
INSERT INTO RESTAURANTCUISINE VALUES (6, 42);
INSERT INTO RESTAURANTCUISINE VALUES (7, 5);
INSERT INTO RESTAURANTCUISINE VALUES (7, 17);
INSERT INTO RESTAURANTCUISINE VALUES (7, 19);
INSERT INTO RESTAURANTCUISINE VALUES (8, 16);
INSERT INTO RESTAURANTCUISINE VALUES (8, 26);
INSERT INTO RESTAURANTCUISINE VALUES (9, 9);
INSERT INTO RESTAURANTCUISINE VALUES (9, 16);
INSERT INTO RESTAURANTCUISINE VALUES (9, 32);
INSERT INTO RESTAURANTCUISINE VALUES (10, 1);
INSERT INTO RESTAURANTCUISINE VALUES (10, 24);
INSERT INTO RESTAURANTCUISINE VALUES (10, 45);
INSERT INTO RESTAURANTCUISINE VALUES (11, 41);
INSERT INTO RESTAURANTCUISINE VALUES (11, 42);
INSERT INTO RESTAURANTCUISINE VALUES (12, 2);
INSERT INTO RESTAURANTCUISINE VALUES (12, 9);
INSERT INTO RESTAURANTCUISINE VALUES (12, 38);
INSERT INTO RESTAURANTCUISINE VALUES (13, 5);
INSERT INTO RESTAURANTCUISINE VALUES (13, 17);
INSERT INTO RESTAURANTCUISINE VALUES (13, 21);
INSERT INTO RESTAURANTCUISINE VALUES (13, 24);
INSERT INTO RESTAURANTCUISINE VALUES (13, 27);
INSERT INTO RESTAURANTCUISINE VALUES (13, 30);
INSERT INTO RESTAURANTCUISINE VALUES (14, 8);
INSERT INTO RESTAURANTCUISINE VALUES (14, 11);
INSERT INTO RESTAURANTCUISINE VALUES (14, 31);
INSERT INTO RESTAURANTCUISINE VALUES (15, 1);
INSERT INTO RESTAURANTCUISINE VALUES (15, 6);
INSERT INTO RESTAURANTCUISINE VALUES (15, 16);
INSERT INTO RESTAURANTCUISINE VALUES (15, 17);
INSERT INTO RESTAURANTCUISINE VALUES (15, 21);
INSERT INTO RESTAURANTCUISINE VALUES (16, 1);
INSERT INTO RESTAURANTCUISINE VALUES (16, 3);
INSERT INTO RESTAURANTCUISINE VALUES (16, 11);
INSERT INTO RESTAURANTCUISINE VALUES (16, 41);
INSERT INTO RESTAURANTCUISINE VALUES (17, 3);
INSERT INTO RESTAURANTCUISINE VALUES (17, 10);
INSERT INTO RESTAURANTCUISINE VALUES (17, 31);
INSERT INTO RESTAURANTCUISINE VALUES (18, 9);
INSERT INTO RESTAURANTCUISINE VALUES (18, 19);
INSERT INTO RESTAURANTCUISINE VALUES (18, 27);
INSERT INTO RESTAURANTCUISINE VALUES (18, 36);
INSERT INTO RESTAURANTCUISINE VALUES (18, 38);
INSERT INTO RESTAURANTCUISINE VALUES (18, 45);
INSERT INTO RESTAURANTCUISINE VALUES (19, 8);
INSERT INTO RESTAURANTCUISINE VALUES (19, 39);
INSERT INTO RESTAURANTCUISINE VALUES (20, 1);
INSERT INTO RESTAURANTCUISINE VALUES (20, 21);
INSERT INTO RESTAURANTCUISINE VALUES (20, 23);
INSERT INTO RESTAURANTCUISINE VALUES (20, 32);
INSERT INTO RESTAURANTCUISINE VALUES (21, 31);
INSERT INTO RESTAURANTCUISINE VALUES (22, 6);
INSERT INTO RESTAURANTCUISINE VALUES (22, 27);
INSERT INTO RESTAURANTCUISINE VALUES (22, 41);
INSERT INTO RESTAURANTCUISINE VALUES (23, 19);
INSERT INTO RESTAURANTCUISINE VALUES (23, 42);
INSERT INTO RESTAURANTCUISINE VALUES (24, 27);
INSERT INTO RESTAURANTCUISINE VALUES (24, 30);
INSERT INTO RESTAURANTCUISINE VALUES (25, 1);
INSERT INTO RESTAURANTCUISINE VALUES (25, 20);
INSERT INTO RESTAURANTCUISINE VALUES (25, 23);
INSERT INTO RESTAURANTCUISINE VALUES (25, 25);
INSERT INTO RESTAURANTCUISINE VALUES (25, 29);
INSERT INTO RESTAURANTCUISINE VALUES (25, 44);
INSERT INTO RESTAURANTCUISINE VALUES (26, 7);
INSERT INTO RESTAURANTCUISINE VALUES (26, 16);
INSERT INTO RESTAURANTCUISINE VALUES (26, 18);
INSERT INTO RESTAURANTCUISINE VALUES (27, 11);
INSERT INTO RESTAURANTCUISINE VALUES (28, 21);
INSERT INTO RESTAURANTCUISINE VALUES (29, 9);
INSERT INTO RESTAURANTCUISINE VALUES (29, 13);
INSERT INTO RESTAURANTCUISINE VALUES (29, 20);
INSERT INTO RESTAURANTCUISINE VALUES (29, 24);
INSERT INTO RESTAURANTCUISINE VALUES (29, 41);
INSERT INTO RESTAURANTCUISINE VALUES (30, 35);
INSERT INTO RESTAURANTCUISINE VALUES (31, 12);
INSERT INTO RESTAURANTCUISINE VALUES (31, 35);
INSERT INTO RESTAURANTCUISINE VALUES (31, 36);
INSERT INTO RESTAURANTCUISINE VALUES (32, 6);
INSERT INTO RESTAURANTCUISINE VALUES (32, 13);
INSERT INTO RESTAURANTCUISINE VALUES (32, 14);
INSERT INTO RESTAURANTCUISINE VALUES (32, 29);
INSERT INTO RESTAURANTCUISINE VALUES (32, 31);
INSERT INTO RESTAURANTCUISINE VALUES (34, 6);
INSERT INTO RESTAURANTCUISINE VALUES (34, 8);
INSERT INTO RESTAURANTCUISINE VALUES (34, 11);
INSERT INTO RESTAURANTCUISINE VALUES (34, 29);
INSERT INTO RESTAURANTCUISINE VALUES (34, 40);
INSERT INTO RESTAURANTCUISINE VALUES (34, 41);
INSERT INTO RESTAURANTCUISINE VALUES (34, 43);
INSERT INTO RESTAURANTCUISINE VALUES (35, 7);
INSERT INTO RESTAURANTCUISINE VALUES (35, 23);
INSERT INTO RESTAURANTCUISINE VALUES (35, 45);
INSERT INTO RESTAURANTCUISINE VALUES (36, 19);
INSERT INTO RESTAURANTCUISINE VALUES (36, 24);
INSERT INTO RESTAURANTCUISINE VALUES (36, 28);
INSERT INTO RESTAURANTCUISINE VALUES (36, 42);
INSERT INTO RESTAURANTCUISINE VALUES (37, 12);
INSERT INTO RESTAURANTCUISINE VALUES (37, 28);
INSERT INTO RESTAURANTCUISINE VALUES (39, 30);
INSERT INTO RESTAURANTCUISINE VALUES (39, 42);
INSERT INTO RESTAURANTCUISINE VALUES (40, 10);
INSERT INTO RESTAURANTCUISINE VALUES (40, 29);
INSERT INTO RESTAURANTCUISINE VALUES (40, 32);
INSERT INTO RESTAURANTCUISINE VALUES (41, 16);
INSERT INTO RESTAURANTCUISINE VALUES (41, 20);
INSERT INTO RESTAURANTCUISINE VALUES (41, 30);
INSERT INTO RESTAURANTCUISINE VALUES (41, 35);
INSERT INTO RESTAURANTCUISINE VALUES (41, 41);
INSERT INTO RESTAURANTCUISINE VALUES (42, 35);
INSERT INTO RESTAURANTCUISINE VALUES (43, 17);
INSERT INTO RESTAURANTCUISINE VALUES (43, 23);
INSERT INTO RESTAURANTCUISINE VALUES (44, 40);
INSERT INTO RESTAURANTCUISINE VALUES (45, 3);
INSERT INTO RESTAURANTCUISINE VALUES (45, 31);
INSERT INTO RESTAURANTCUISINE VALUES (45, 35);
INSERT INTO RESTAURANTCUISINE VALUES (45, 39);
INSERT INTO RESTAURANTCUISINE VALUES (45, 44);
INSERT INTO RESTAURANTCUISINE VALUES (46, 18);
INSERT INTO RESTAURANTCUISINE VALUES (46, 29);
INSERT INTO RESTAURANTCUISINE VALUES (47, 1);
INSERT INTO RESTAURANTCUISINE VALUES (47, 3);
INSERT INTO RESTAURANTCUISINE VALUES (47, 9);
INSERT INTO RESTAURANTCUISINE VALUES (48, 6);
INSERT INTO RESTAURANTCUISINE VALUES (48, 7);
INSERT INTO RESTAURANTCUISINE VALUES (48, 19);
INSERT INTO RESTAURANTCUISINE VALUES (48, 36);
INSERT INTO RESTAURANTCUISINE VALUES (48, 38);
INSERT INTO RESTAURANTCUISINE VALUES (48, 45);
INSERT INTO RESTAURANTCUISINE VALUES (49, 9);
INSERT INTO RESTAURANTCUISINE VALUES (49, 10);
INSERT INTO RESTAURANTCUISINE VALUES (49, 23);
INSERT INTO RESTAURANTCUISINE VALUES (50, 6);
INSERT INTO RESTAURANTCUISINE VALUES (50, 26);
INSERT INTO RESTAURANTCUISINE VALUES (50, 28);

-- USERDIETARYRESTRICTION (130 rows)
INSERT INTO USERDIETARYRESTRICTION VALUES (1, 4);
INSERT INTO USERDIETARYRESTRICTION VALUES (1, 11);
INSERT INTO USERDIETARYRESTRICTION VALUES (1, 12);
INSERT INTO USERDIETARYRESTRICTION VALUES (2, 10);
INSERT INTO USERDIETARYRESTRICTION VALUES (2, 12);
INSERT INTO USERDIETARYRESTRICTION VALUES (3, 3);
INSERT INTO USERDIETARYRESTRICTION VALUES (3, 5);
INSERT INTO USERDIETARYRESTRICTION VALUES (3, 6);
INSERT INTO USERDIETARYRESTRICTION VALUES (3, 8);
INSERT INTO USERDIETARYRESTRICTION VALUES (3, 12);
INSERT INTO USERDIETARYRESTRICTION VALUES (4, 6);
INSERT INTO USERDIETARYRESTRICTION VALUES (4, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (4, 10);
INSERT INTO USERDIETARYRESTRICTION VALUES (4, 11);
INSERT INTO USERDIETARYRESTRICTION VALUES (5, 4);
INSERT INTO USERDIETARYRESTRICTION VALUES (5, 5);
INSERT INTO USERDIETARYRESTRICTION VALUES (5, 12);
INSERT INTO USERDIETARYRESTRICTION VALUES (6, 4);
INSERT INTO USERDIETARYRESTRICTION VALUES (6, 7);
INSERT INTO USERDIETARYRESTRICTION VALUES (6, 8);
INSERT INTO USERDIETARYRESTRICTION VALUES (6, 10);
INSERT INTO USERDIETARYRESTRICTION VALUES (7, 1);
INSERT INTO USERDIETARYRESTRICTION VALUES (7, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (7, 11);
INSERT INTO USERDIETARYRESTRICTION VALUES (7, 12);
INSERT INTO USERDIETARYRESTRICTION VALUES (9, 3);
INSERT INTO USERDIETARYRESTRICTION VALUES (9, 5);
INSERT INTO USERDIETARYRESTRICTION VALUES (9, 6);
INSERT INTO USERDIETARYRESTRICTION VALUES (10, 2);
INSERT INTO USERDIETARYRESTRICTION VALUES (10, 6);
INSERT INTO USERDIETARYRESTRICTION VALUES (10, 10);
INSERT INTO USERDIETARYRESTRICTION VALUES (11, 2);
INSERT INTO USERDIETARYRESTRICTION VALUES (11, 3);
INSERT INTO USERDIETARYRESTRICTION VALUES (12, 1);
INSERT INTO USERDIETARYRESTRICTION VALUES (12, 8);
INSERT INTO USERDIETARYRESTRICTION VALUES (12, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (13, 2);
INSERT INTO USERDIETARYRESTRICTION VALUES (13, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (14, 6);
INSERT INTO USERDIETARYRESTRICTION VALUES (14, 12);
INSERT INTO USERDIETARYRESTRICTION VALUES (15, 3);
INSERT INTO USERDIETARYRESTRICTION VALUES (15, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (15, 10);
INSERT INTO USERDIETARYRESTRICTION VALUES (16, 4);
INSERT INTO USERDIETARYRESTRICTION VALUES (16, 6);
INSERT INTO USERDIETARYRESTRICTION VALUES (16, 10);
INSERT INTO USERDIETARYRESTRICTION VALUES (17, 5);
INSERT INTO USERDIETARYRESTRICTION VALUES (17, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (18, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (19, 6);
INSERT INTO USERDIETARYRESTRICTION VALUES (20, 1);
INSERT INTO USERDIETARYRESTRICTION VALUES (20, 4);
INSERT INTO USERDIETARYRESTRICTION VALUES (20, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (21, 2);
INSERT INTO USERDIETARYRESTRICTION VALUES (21, 6);
INSERT INTO USERDIETARYRESTRICTION VALUES (21, 8);
INSERT INTO USERDIETARYRESTRICTION VALUES (21, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (21, 10);
INSERT INTO USERDIETARYRESTRICTION VALUES (21, 12);
INSERT INTO USERDIETARYRESTRICTION VALUES (23, 3);
INSERT INTO USERDIETARYRESTRICTION VALUES (23, 7);
INSERT INTO USERDIETARYRESTRICTION VALUES (24, 8);
INSERT INTO USERDIETARYRESTRICTION VALUES (24, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (24, 10);
INSERT INTO USERDIETARYRESTRICTION VALUES (24, 12);
INSERT INTO USERDIETARYRESTRICTION VALUES (25, 1);
INSERT INTO USERDIETARYRESTRICTION VALUES (25, 2);
INSERT INTO USERDIETARYRESTRICTION VALUES (25, 4);
INSERT INTO USERDIETARYRESTRICTION VALUES (25, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (25, 11);
INSERT INTO USERDIETARYRESTRICTION VALUES (26, 3);
INSERT INTO USERDIETARYRESTRICTION VALUES (26, 5);
INSERT INTO USERDIETARYRESTRICTION VALUES (26, 10);
INSERT INTO USERDIETARYRESTRICTION VALUES (27, 2);
INSERT INTO USERDIETARYRESTRICTION VALUES (27, 11);
INSERT INTO USERDIETARYRESTRICTION VALUES (27, 12);
INSERT INTO USERDIETARYRESTRICTION VALUES (28, 2);
INSERT INTO USERDIETARYRESTRICTION VALUES (28, 5);
INSERT INTO USERDIETARYRESTRICTION VALUES (28, 12);
INSERT INTO USERDIETARYRESTRICTION VALUES (29, 5);
INSERT INTO USERDIETARYRESTRICTION VALUES (29, 6);
INSERT INTO USERDIETARYRESTRICTION VALUES (29, 7);
INSERT INTO USERDIETARYRESTRICTION VALUES (29, 10);
INSERT INTO USERDIETARYRESTRICTION VALUES (30, 5);
INSERT INTO USERDIETARYRESTRICTION VALUES (32, 4);
INSERT INTO USERDIETARYRESTRICTION VALUES (32, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (33, 6);
INSERT INTO USERDIETARYRESTRICTION VALUES (33, 7);
INSERT INTO USERDIETARYRESTRICTION VALUES (33, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (33, 12);
INSERT INTO USERDIETARYRESTRICTION VALUES (34, 2);
INSERT INTO USERDIETARYRESTRICTION VALUES (34, 3);
INSERT INTO USERDIETARYRESTRICTION VALUES (34, 11);
INSERT INTO USERDIETARYRESTRICTION VALUES (35, 4);
INSERT INTO USERDIETARYRESTRICTION VALUES (35, 10);
INSERT INTO USERDIETARYRESTRICTION VALUES (36, 7);
INSERT INTO USERDIETARYRESTRICTION VALUES (37, 2);
INSERT INTO USERDIETARYRESTRICTION VALUES (37, 6);
INSERT INTO USERDIETARYRESTRICTION VALUES (37, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (37, 10);
INSERT INTO USERDIETARYRESTRICTION VALUES (37, 11);
INSERT INTO USERDIETARYRESTRICTION VALUES (37, 12);
INSERT INTO USERDIETARYRESTRICTION VALUES (38, 5);
INSERT INTO USERDIETARYRESTRICTION VALUES (39, 1);
INSERT INTO USERDIETARYRESTRICTION VALUES (39, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (39, 11);
INSERT INTO USERDIETARYRESTRICTION VALUES (40, 12);
INSERT INTO USERDIETARYRESTRICTION VALUES (41, 1);
INSERT INTO USERDIETARYRESTRICTION VALUES (41, 11);
INSERT INTO USERDIETARYRESTRICTION VALUES (42, 8);
INSERT INTO USERDIETARYRESTRICTION VALUES (43, 2);
INSERT INTO USERDIETARYRESTRICTION VALUES (43, 3);
INSERT INTO USERDIETARYRESTRICTION VALUES (43, 4);
INSERT INTO USERDIETARYRESTRICTION VALUES (43, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (44, 8);
INSERT INTO USERDIETARYRESTRICTION VALUES (45, 11);
INSERT INTO USERDIETARYRESTRICTION VALUES (45, 12);
INSERT INTO USERDIETARYRESTRICTION VALUES (46, 2);
INSERT INTO USERDIETARYRESTRICTION VALUES (47, 2);
INSERT INTO USERDIETARYRESTRICTION VALUES (47, 3);
INSERT INTO USERDIETARYRESTRICTION VALUES (47, 7);
INSERT INTO USERDIETARYRESTRICTION VALUES (47, 10);
INSERT INTO USERDIETARYRESTRICTION VALUES (48, 5);
INSERT INTO USERDIETARYRESTRICTION VALUES (48, 7);
INSERT INTO USERDIETARYRESTRICTION VALUES (48, 9);
INSERT INTO USERDIETARYRESTRICTION VALUES (48, 11);
INSERT INTO USERDIETARYRESTRICTION VALUES (50, 1);
INSERT INTO USERDIETARYRESTRICTION VALUES (50, 4);
INSERT INTO USERDIETARYRESTRICTION VALUES (50, 6);
INSERT INTO USERDIETARYRESTRICTION VALUES (50, 12);

-- USERCUISINEPREFERENCE (150 rows)
INSERT INTO USERCUISINEPREFERENCE VALUES (1, 5, 'neutral', '2025-03-14 09:39:58');
INSERT INTO USERCUISINEPREFERENCE VALUES (1, 22, 'favorite', '2025-12-17 04:29:53');
INSERT INTO USERCUISINEPREFERENCE VALUES (2, 23, 'neutral', '2025-02-24 16:07:11');
INSERT INTO USERCUISINEPREFERENCE VALUES (2, 36, 'preferred', '2025-07-14 10:28:01');
INSERT INTO USERCUISINEPREFERENCE VALUES (3, 16, 'preferred', '2025-08-19 22:57:12');
INSERT INTO USERCUISINEPREFERENCE VALUES (3, 17, 'neutral', '2025-02-09 10:44:41');
INSERT INTO USERCUISINEPREFERENCE VALUES (4, 13, 'preferred', '2025-12-24 03:05:07');
INSERT INTO USERCUISINEPREFERENCE VALUES (4, 41, 'neutral', '2025-11-12 02:33:45');
INSERT INTO USERCUISINEPREFERENCE VALUES (5, 12, 'neutral', '2025-12-26 16:39:10');
INSERT INTO USERCUISINEPREFERENCE VALUES (5, 18, 'neutral', '2025-09-13 01:49:10');
INSERT INTO USERCUISINEPREFERENCE VALUES (5, 36, 'disliked', '2025-10-28 21:55:09');
INSERT INTO USERCUISINEPREFERENCE VALUES (6, 12, 'preferred', '2025-03-06 22:03:26');
INSERT INTO USERCUISINEPREFERENCE VALUES (6, 45, 'disliked', '2025-05-24 14:18:40');
INSERT INTO USERCUISINEPREFERENCE VALUES (7, 2, 'preferred', '2025-02-05 06:00:39');
INSERT INTO USERCUISINEPREFERENCE VALUES (7, 9, 'disliked', '2025-01-15 15:54:31');
INSERT INTO USERCUISINEPREFERENCE VALUES (8, 4, 'favorite', '2025-10-16 07:13:37');
INSERT INTO USERCUISINEPREFERENCE VALUES (8, 43, 'neutral', '2025-08-14 14:05:38');
INSERT INTO USERCUISINEPREFERENCE VALUES (9, 6, 'favorite', '2025-04-18 08:39:40');
INSERT INTO USERCUISINEPREFERENCE VALUES (9, 14, 'preferred', '2025-01-06 04:03:41');
INSERT INTO USERCUISINEPREFERENCE VALUES (9, 20, 'disliked', '2025-01-05 01:42:36');
INSERT INTO USERCUISINEPREFERENCE VALUES (9, 28, 'disliked', '2025-06-03 01:06:26');
INSERT INTO USERCUISINEPREFERENCE VALUES (9, 33, 'preferred', '2025-03-22 09:39:42');
INSERT INTO USERCUISINEPREFERENCE VALUES (10, 2, 'preferred', '2025-08-24 18:23:59');
INSERT INTO USERCUISINEPREFERENCE VALUES (10, 6, 'favorite', '2025-02-25 09:20:23');
INSERT INTO USERCUISINEPREFERENCE VALUES (10, 13, 'neutral', '2025-02-25 13:53:35');
INSERT INTO USERCUISINEPREFERENCE VALUES (10, 19, 'favorite', '2025-05-16 04:07:44');
INSERT INTO USERCUISINEPREFERENCE VALUES (10, 22, 'disliked', '2025-06-17 13:33:13');
INSERT INTO USERCUISINEPREFERENCE VALUES (11, 4, 'preferred', '2025-10-02 03:36:46');
INSERT INTO USERCUISINEPREFERENCE VALUES (11, 13, 'favorite', '2025-08-24 22:38:59');
INSERT INTO USERCUISINEPREFERENCE VALUES (11, 21, 'disliked', '2025-07-20 10:16:33');
INSERT INTO USERCUISINEPREFERENCE VALUES (11, 23, 'disliked', '2025-03-20 18:31:33');
INSERT INTO USERCUISINEPREFERENCE VALUES (12, 2, 'neutral', '2025-08-26 05:56:39');
INSERT INTO USERCUISINEPREFERENCE VALUES (12, 21, 'preferred', '2025-12-10 06:00:07');
INSERT INTO USERCUISINEPREFERENCE VALUES (13, 14, 'favorite', '2025-08-21 03:47:54');
INSERT INTO USERCUISINEPREFERENCE VALUES (13, 21, 'preferred', '2025-10-14 13:02:21');
INSERT INTO USERCUISINEPREFERENCE VALUES (13, 32, 'disliked', '2025-09-26 20:13:00');
INSERT INTO USERCUISINEPREFERENCE VALUES (13, 33, 'preferred', '2025-12-10 08:50:04');
INSERT INTO USERCUISINEPREFERENCE VALUES (14, 14, 'disliked', '2025-05-17 17:20:49');
INSERT INTO USERCUISINEPREFERENCE VALUES (15, 3, 'favorite', '2025-02-22 10:21:25');
INSERT INTO USERCUISINEPREFERENCE VALUES (15, 13, 'favorite', '2025-03-07 10:53:21');
INSERT INTO USERCUISINEPREFERENCE VALUES (15, 43, 'neutral', '2025-08-26 01:41:08');
INSERT INTO USERCUISINEPREFERENCE VALUES (15, 44, 'neutral', '2025-03-21 14:57:55');
INSERT INTO USERCUISINEPREFERENCE VALUES (16, 16, 'disliked', '2025-08-26 13:59:47');
INSERT INTO USERCUISINEPREFERENCE VALUES (16, 28, 'favorite', '2025-09-10 18:46:43');
INSERT INTO USERCUISINEPREFERENCE VALUES (16, 40, 'disliked', '2025-09-18 00:13:36');
INSERT INTO USERCUISINEPREFERENCE VALUES (17, 25, 'disliked', '2025-06-03 04:17:53');
INSERT INTO USERCUISINEPREFERENCE VALUES (18, 4, 'favorite', '2025-06-13 20:34:53');
INSERT INTO USERCUISINEPREFERENCE VALUES (18, 15, 'preferred', '2025-10-20 12:11:38');
INSERT INTO USERCUISINEPREFERENCE VALUES (18, 27, 'favorite', '2025-05-23 10:45:02');
INSERT INTO USERCUISINEPREFERENCE VALUES (18, 43, 'disliked', '2025-07-03 15:56:15');
INSERT INTO USERCUISINEPREFERENCE VALUES (19, 13, 'disliked', '2025-08-27 09:13:33');
INSERT INTO USERCUISINEPREFERENCE VALUES (19, 29, 'disliked', '2025-03-04 11:50:02');
INSERT INTO USERCUISINEPREFERENCE VALUES (19, 42, 'preferred', '2025-02-15 16:01:51');
INSERT INTO USERCUISINEPREFERENCE VALUES (20, 16, 'neutral', '2025-09-05 06:21:59');
INSERT INTO USERCUISINEPREFERENCE VALUES (20, 29, 'neutral', '2025-12-28 16:19:49');
INSERT INTO USERCUISINEPREFERENCE VALUES (21, 30, 'disliked', '2025-03-25 03:52:33');
INSERT INTO USERCUISINEPREFERENCE VALUES (21, 32, 'preferred', '2025-04-24 01:29:24');
INSERT INTO USERCUISINEPREFERENCE VALUES (21, 44, 'favorite', '2025-01-10 01:43:54');
INSERT INTO USERCUISINEPREFERENCE VALUES (22, 14, 'favorite', '2025-06-15 01:06:33');
INSERT INTO USERCUISINEPREFERENCE VALUES (22, 32, 'disliked', '2025-01-19 09:40:57');
INSERT INTO USERCUISINEPREFERENCE VALUES (23, 39, 'preferred', '2025-06-07 06:18:17');
INSERT INTO USERCUISINEPREFERENCE VALUES (23, 41, 'disliked', '2025-08-22 03:17:09');
INSERT INTO USERCUISINEPREFERENCE VALUES (24, 12, 'preferred', '2025-05-04 00:39:35');
INSERT INTO USERCUISINEPREFERENCE VALUES (24, 23, 'favorite', '2025-04-18 11:35:20');
INSERT INTO USERCUISINEPREFERENCE VALUES (25, 15, 'disliked', '2025-03-23 09:36:15');
INSERT INTO USERCUISINEPREFERENCE VALUES (25, 32, 'preferred', '2025-02-10 19:57:21');
INSERT INTO USERCUISINEPREFERENCE VALUES (25, 33, 'neutral', '2025-01-05 00:30:57');
INSERT INTO USERCUISINEPREFERENCE VALUES (25, 38, 'favorite', '2025-02-13 01:05:27');
INSERT INTO USERCUISINEPREFERENCE VALUES (25, 43, 'neutral', '2025-03-23 19:57:37');
INSERT INTO USERCUISINEPREFERENCE VALUES (26, 3, 'neutral', '2025-10-12 09:21:52');
INSERT INTO USERCUISINEPREFERENCE VALUES (26, 11, 'preferred', '2025-12-25 21:51:34');
INSERT INTO USERCUISINEPREFERENCE VALUES (26, 20, 'favorite', '2025-08-19 04:05:52');
INSERT INTO USERCUISINEPREFERENCE VALUES (26, 40, 'neutral', '2025-02-15 09:43:41');
INSERT INTO USERCUISINEPREFERENCE VALUES (26, 42, 'neutral', '2025-08-08 07:09:55');
INSERT INTO USERCUISINEPREFERENCE VALUES (26, 43, 'disliked', '2025-06-13 05:44:58');
INSERT INTO USERCUISINEPREFERENCE VALUES (27, 1, 'disliked', '2025-06-15 15:01:04');
INSERT INTO USERCUISINEPREFERENCE VALUES (27, 16, 'neutral', '2025-02-12 15:29:54');
INSERT INTO USERCUISINEPREFERENCE VALUES (27, 27, 'preferred', '2025-05-25 11:38:36');
INSERT INTO USERCUISINEPREFERENCE VALUES (27, 28, 'preferred', '2025-09-04 12:52:45');
INSERT INTO USERCUISINEPREFERENCE VALUES (28, 20, 'favorite', '2025-06-18 20:04:50');
INSERT INTO USERCUISINEPREFERENCE VALUES (29, 3, 'disliked', '2025-09-15 12:37:26');
INSERT INTO USERCUISINEPREFERENCE VALUES (29, 30, 'preferred', '2025-10-08 17:10:30');
INSERT INTO USERCUISINEPREFERENCE VALUES (29, 35, 'neutral', '2025-02-11 06:52:44');
INSERT INTO USERCUISINEPREFERENCE VALUES (29, 40, 'neutral', '2025-07-19 10:34:44');
INSERT INTO USERCUISINEPREFERENCE VALUES (30, 36, 'preferred', '2025-03-22 21:04:47');
INSERT INTO USERCUISINEPREFERENCE VALUES (30, 42, 'neutral', '2025-02-19 19:29:20');
INSERT INTO USERCUISINEPREFERENCE VALUES (31, 2, 'favorite', '2025-08-06 09:25:04');
INSERT INTO USERCUISINEPREFERENCE VALUES (31, 9, 'favorite', '2025-11-27 19:49:52');
INSERT INTO USERCUISINEPREFERENCE VALUES (31, 36, 'neutral', '2025-06-16 20:42:03');
INSERT INTO USERCUISINEPREFERENCE VALUES (32, 45, 'favorite', '2025-04-27 04:56:37');
INSERT INTO USERCUISINEPREFERENCE VALUES (33, 18, 'favorite', '2025-03-22 04:28:34');
INSERT INTO USERCUISINEPREFERENCE VALUES (34, 7, 'disliked', '2025-07-20 18:28:12');
INSERT INTO USERCUISINEPREFERENCE VALUES (34, 20, 'preferred', '2025-11-11 09:36:50');
INSERT INTO USERCUISINEPREFERENCE VALUES (34, 35, 'disliked', '2025-07-23 11:05:37');
INSERT INTO USERCUISINEPREFERENCE VALUES (34, 41, 'favorite', '2025-10-17 12:54:08');
INSERT INTO USERCUISINEPREFERENCE VALUES (34, 42, 'disliked', '2025-01-12 17:03:00');
INSERT INTO USERCUISINEPREFERENCE VALUES (34, 44, 'disliked', '2025-02-28 09:55:01');
INSERT INTO USERCUISINEPREFERENCE VALUES (35, 8, 'preferred', '2025-07-23 18:25:40');
INSERT INTO USERCUISINEPREFERENCE VALUES (35, 34, 'disliked', '2025-12-13 12:24:27');
INSERT INTO USERCUISINEPREFERENCE VALUES (36, 25, 'preferred', '2025-11-06 15:08:12');
INSERT INTO USERCUISINEPREFERENCE VALUES (36, 31, 'neutral', '2025-06-27 13:09:18');
INSERT INTO USERCUISINEPREFERENCE VALUES (36, 40, 'preferred', '2025-03-01 02:41:01');
INSERT INTO USERCUISINEPREFERENCE VALUES (37, 6, 'preferred', '2025-12-16 21:27:08');
INSERT INTO USERCUISINEPREFERENCE VALUES (37, 10, 'favorite', '2025-03-21 13:55:29');
INSERT INTO USERCUISINEPREFERENCE VALUES (37, 13, 'neutral', '2025-10-06 14:32:27');
INSERT INTO USERCUISINEPREFERENCE VALUES (38, 35, 'neutral', '2025-07-12 07:11:27');
INSERT INTO USERCUISINEPREFERENCE VALUES (39, 15, 'favorite', '2025-10-16 23:15:45');
INSERT INTO USERCUISINEPREFERENCE VALUES (39, 22, 'disliked', '2025-07-18 18:23:02');
INSERT INTO USERCUISINEPREFERENCE VALUES (39, 25, 'favorite', '2025-10-16 22:23:07');
INSERT INTO USERCUISINEPREFERENCE VALUES (39, 31, 'neutral', '2025-12-03 04:46:46');
INSERT INTO USERCUISINEPREFERENCE VALUES (39, 35, 'disliked', '2025-08-17 02:33:56');
INSERT INTO USERCUISINEPREFERENCE VALUES (39, 37, 'favorite', '2025-04-16 20:47:42');
INSERT INTO USERCUISINEPREFERENCE VALUES (40, 10, 'favorite', '2025-11-21 17:51:37');
INSERT INTO USERCUISINEPREFERENCE VALUES (40, 15, 'disliked', '2025-10-02 10:34:49');
INSERT INTO USERCUISINEPREFERENCE VALUES (40, 18, 'favorite', '2025-08-15 16:57:30');
INSERT INTO USERCUISINEPREFERENCE VALUES (40, 29, 'disliked', '2025-07-12 09:18:10');
INSERT INTO USERCUISINEPREFERENCE VALUES (40, 41, 'favorite', '2025-12-20 23:19:46');
INSERT INTO USERCUISINEPREFERENCE VALUES (42, 2, 'disliked', '2025-01-21 15:37:10');
INSERT INTO USERCUISINEPREFERENCE VALUES (42, 9, 'favorite', '2025-11-10 23:39:01');
INSERT INTO USERCUISINEPREFERENCE VALUES (42, 37, 'disliked', '2025-08-03 04:32:04');
INSERT INTO USERCUISINEPREFERENCE VALUES (43, 2, 'disliked', '2025-05-05 19:17:17');
INSERT INTO USERCUISINEPREFERENCE VALUES (43, 24, 'disliked', '2025-01-24 03:38:11');
INSERT INTO USERCUISINEPREFERENCE VALUES (43, 34, 'preferred', '2025-11-15 11:51:11');
INSERT INTO USERCUISINEPREFERENCE VALUES (44, 13, 'disliked', '2025-12-08 15:11:51');
INSERT INTO USERCUISINEPREFERENCE VALUES (44, 15, 'favorite', '2025-06-03 04:38:59');
INSERT INTO USERCUISINEPREFERENCE VALUES (44, 23, 'preferred', '2025-08-25 13:49:24');
INSERT INTO USERCUISINEPREFERENCE VALUES (44, 24, 'preferred', '2025-11-15 23:40:10');
INSERT INTO USERCUISINEPREFERENCE VALUES (45, 8, 'preferred', '2025-10-24 11:03:41');
INSERT INTO USERCUISINEPREFERENCE VALUES (45, 34, 'disliked', '2025-02-02 05:29:25');
INSERT INTO USERCUISINEPREFERENCE VALUES (45, 40, 'neutral', '2025-05-16 23:48:59');
INSERT INTO USERCUISINEPREFERENCE VALUES (45, 45, 'preferred', '2025-07-22 22:24:30');
INSERT INTO USERCUISINEPREFERENCE VALUES (46, 2, 'disliked', '2025-03-17 13:00:18');
INSERT INTO USERCUISINEPREFERENCE VALUES (46, 3, 'neutral', '2025-07-22 10:33:43');
INSERT INTO USERCUISINEPREFERENCE VALUES (46, 7, 'favorite', '2025-02-18 20:22:54');
INSERT INTO USERCUISINEPREFERENCE VALUES (46, 42, 'neutral', '2025-10-21 08:21:17');
INSERT INTO USERCUISINEPREFERENCE VALUES (47, 21, 'disliked', '2025-02-09 20:37:25');
INSERT INTO USERCUISINEPREFERENCE VALUES (47, 25, 'neutral', '2025-11-24 07:46:43');
INSERT INTO USERCUISINEPREFERENCE VALUES (48, 18, 'preferred', '2025-09-11 21:44:11');
INSERT INTO USERCUISINEPREFERENCE VALUES (48, 34, 'disliked', '2025-09-01 21:00:53');
INSERT INTO USERCUISINEPREFERENCE VALUES (48, 35, 'favorite', '2025-01-14 03:33:06');
INSERT INTO USERCUISINEPREFERENCE VALUES (48, 37, 'neutral', '2025-06-08 23:18:16');
INSERT INTO USERCUISINEPREFERENCE VALUES (48, 41, 'preferred', '2025-01-01 19:05:03');
INSERT INTO USERCUISINEPREFERENCE VALUES (49, 17, 'preferred', '2025-10-21 03:45:07');
INSERT INTO USERCUISINEPREFERENCE VALUES (49, 21, 'favorite', '2025-10-05 12:42:48');
INSERT INTO USERCUISINEPREFERENCE VALUES (49, 40, 'preferred', '2025-02-23 05:16:18');
INSERT INTO USERCUISINEPREFERENCE VALUES (50, 10, 'neutral', '2025-11-03 20:29:59');
INSERT INTO USERCUISINEPREFERENCE VALUES (50, 19, 'disliked', '2025-07-23 21:49:49');
INSERT INTO USERCUISINEPREFERENCE VALUES (50, 20, 'disliked', '2025-05-06 02:17:49');
INSERT INTO USERCUISINEPREFERENCE VALUES (50, 28, 'favorite', '2025-07-13 10:03:16');
INSERT INTO USERCUISINEPREFERENCE VALUES (50, 31, 'disliked', '2025-03-15 02:31:59');

-- RESTAURANTTAG (175 rows)
INSERT INTO RESTAURANTTAG VALUES (1, 12);
INSERT INTO RESTAURANTTAG VALUES (1, 25);
INSERT INTO RESTAURANTTAG VALUES (1, 27);
INSERT INTO RESTAURANTTAG VALUES (1, 33);
INSERT INTO RESTAURANTTAG VALUES (1, 36);
INSERT INTO RESTAURANTTAG VALUES (2, 32);
INSERT INTO RESTAURANTTAG VALUES (3, 3);
INSERT INTO RESTAURANTTAG VALUES (3, 7);
INSERT INTO RESTAURANTTAG VALUES (3, 10);
INSERT INTO RESTAURANTTAG VALUES (3, 16);
INSERT INTO RESTAURANTTAG VALUES (3, 22);
INSERT INTO RESTAURANTTAG VALUES (3, 25);
INSERT INTO RESTAURANTTAG VALUES (3, 28);
INSERT INTO RESTAURANTTAG VALUES (3, 37);
INSERT INTO RESTAURANTTAG VALUES (4, 18);
INSERT INTO RESTAURANTTAG VALUES (4, 22);
INSERT INTO RESTAURANTTAG VALUES (4, 24);
INSERT INTO RESTAURANTTAG VALUES (5, 5);
INSERT INTO RESTAURANTTAG VALUES (5, 7);
INSERT INTO RESTAURANTTAG VALUES (6, 1);
INSERT INTO RESTAURANTTAG VALUES (6, 27);
INSERT INTO RESTAURANTTAG VALUES (6, 38);
INSERT INTO RESTAURANTTAG VALUES (7, 3);
INSERT INTO RESTAURANTTAG VALUES (7, 10);
INSERT INTO RESTAURANTTAG VALUES (7, 16);
INSERT INTO RESTAURANTTAG VALUES (7, 23);
INSERT INTO RESTAURANTTAG VALUES (7, 40);
INSERT INTO RESTAURANTTAG VALUES (8, 5);
INSERT INTO RESTAURANTTAG VALUES (8, 18);
INSERT INTO RESTAURANTTAG VALUES (8, 32);
INSERT INTO RESTAURANTTAG VALUES (8, 34);
INSERT INTO RESTAURANTTAG VALUES (8, 37);
INSERT INTO RESTAURANTTAG VALUES (9, 3);
INSERT INTO RESTAURANTTAG VALUES (9, 7);
INSERT INTO RESTAURANTTAG VALUES (9, 8);
INSERT INTO RESTAURANTTAG VALUES (9, 30);
INSERT INTO RESTAURANTTAG VALUES (10, 1);
INSERT INTO RESTAURANTTAG VALUES (10, 27);
INSERT INTO RESTAURANTTAG VALUES (10, 31);
INSERT INTO RESTAURANTTAG VALUES (10, 37);
INSERT INTO RESTAURANTTAG VALUES (10, 38);
INSERT INTO RESTAURANTTAG VALUES (11, 2);
INSERT INTO RESTAURANTTAG VALUES (11, 3);
INSERT INTO RESTAURANTTAG VALUES (11, 24);
INSERT INTO RESTAURANTTAG VALUES (11, 37);
INSERT INTO RESTAURANTTAG VALUES (11, 38);
INSERT INTO RESTAURANTTAG VALUES (12, 36);
INSERT INTO RESTAURANTTAG VALUES (12, 40);
INSERT INTO RESTAURANTTAG VALUES (13, 2);
INSERT INTO RESTAURANTTAG VALUES (13, 8);
INSERT INTO RESTAURANTTAG VALUES (13, 21);
INSERT INTO RESTAURANTTAG VALUES (13, 25);
INSERT INTO RESTAURANTTAG VALUES (13, 28);
INSERT INTO RESTAURANTTAG VALUES (13, 40);
INSERT INTO RESTAURANTTAG VALUES (14, 9);
INSERT INTO RESTAURANTTAG VALUES (14, 10);
INSERT INTO RESTAURANTTAG VALUES (14, 34);
INSERT INTO RESTAURANTTAG VALUES (14, 38);
INSERT INTO RESTAURANTTAG VALUES (14, 40);
INSERT INTO RESTAURANTTAG VALUES (15, 5);
INSERT INTO RESTAURANTTAG VALUES (15, 8);
INSERT INTO RESTAURANTTAG VALUES (15, 19);
INSERT INTO RESTAURANTTAG VALUES (15, 38);
INSERT INTO RESTAURANTTAG VALUES (16, 6);
INSERT INTO RESTAURANTTAG VALUES (16, 13);
INSERT INTO RESTAURANTTAG VALUES (16, 21);
INSERT INTO RESTAURANTTAG VALUES (16, 29);
INSERT INTO RESTAURANTTAG VALUES (16, 32);
INSERT INTO RESTAURANTTAG VALUES (18, 1);
INSERT INTO RESTAURANTTAG VALUES (18, 4);
INSERT INTO RESTAURANTTAG VALUES (18, 10);
INSERT INTO RESTAURANTTAG VALUES (18, 13);
INSERT INTO RESTAURANTTAG VALUES (19, 14);
INSERT INTO RESTAURANTTAG VALUES (19, 27);
INSERT INTO RESTAURANTTAG VALUES (20, 7);
INSERT INTO RESTAURANTTAG VALUES (20, 25);
INSERT INTO RESTAURANTTAG VALUES (21, 8);
INSERT INTO RESTAURANTTAG VALUES (21, 14);
INSERT INTO RESTAURANTTAG VALUES (21, 15);
INSERT INTO RESTAURANTTAG VALUES (21, 27);
INSERT INTO RESTAURANTTAG VALUES (22, 5);
INSERT INTO RESTAURANTTAG VALUES (22, 6);
INSERT INTO RESTAURANTTAG VALUES (22, 9);
INSERT INTO RESTAURANTTAG VALUES (22, 20);
INSERT INTO RESTAURANTTAG VALUES (22, 26);
INSERT INTO RESTAURANTTAG VALUES (22, 40);
INSERT INTO RESTAURANTTAG VALUES (23, 19);
INSERT INTO RESTAURANTTAG VALUES (23, 27);
INSERT INTO RESTAURANTTAG VALUES (24, 35);
INSERT INTO RESTAURANTTAG VALUES (25, 5);
INSERT INTO RESTAURANTTAG VALUES (25, 11);
INSERT INTO RESTAURANTTAG VALUES (25, 24);
INSERT INTO RESTAURANTTAG VALUES (26, 4);
INSERT INTO RESTAURANTTAG VALUES (26, 5);
INSERT INTO RESTAURANTTAG VALUES (26, 8);
INSERT INTO RESTAURANTTAG VALUES (26, 12);
INSERT INTO RESTAURANTTAG VALUES (26, 37);
INSERT INTO RESTAURANTTAG VALUES (27, 11);
INSERT INTO RESTAURANTTAG VALUES (27, 16);
INSERT INTO RESTAURANTTAG VALUES (28, 10);
INSERT INTO RESTAURANTTAG VALUES (28, 17);
INSERT INTO RESTAURANTTAG VALUES (28, 38);
INSERT INTO RESTAURANTTAG VALUES (29, 2);
INSERT INTO RESTAURANTTAG VALUES (29, 16);
INSERT INTO RESTAURANTTAG VALUES (29, 17);
INSERT INTO RESTAURANTTAG VALUES (29, 32);
INSERT INTO RESTAURANTTAG VALUES (30, 12);
INSERT INTO RESTAURANTTAG VALUES (30, 14);
INSERT INTO RESTAURANTTAG VALUES (30, 19);
INSERT INTO RESTAURANTTAG VALUES (30, 30);
INSERT INTO RESTAURANTTAG VALUES (30, 35);
INSERT INTO RESTAURANTTAG VALUES (30, 40);
INSERT INTO RESTAURANTTAG VALUES (31, 7);
INSERT INTO RESTAURANTTAG VALUES (31, 28);
INSERT INTO RESTAURANTTAG VALUES (31, 30);
INSERT INTO RESTAURANTTAG VALUES (31, 33);
INSERT INTO RESTAURANTTAG VALUES (31, 38);
INSERT INTO RESTAURANTTAG VALUES (31, 40);
INSERT INTO RESTAURANTTAG VALUES (32, 2);
INSERT INTO RESTAURANTTAG VALUES (32, 4);
INSERT INTO RESTAURANTTAG VALUES (32, 6);
INSERT INTO RESTAURANTTAG VALUES (32, 12);
INSERT INTO RESTAURANTTAG VALUES (32, 33);
INSERT INTO RESTAURANTTAG VALUES (32, 35);
INSERT INTO RESTAURANTTAG VALUES (33, 15);
INSERT INTO RESTAURANTTAG VALUES (34, 26);
INSERT INTO RESTAURANTTAG VALUES (34, 29);
INSERT INTO RESTAURANTTAG VALUES (34, 32);
INSERT INTO RESTAURANTTAG VALUES (35, 9);
INSERT INTO RESTAURANTTAG VALUES (35, 12);
INSERT INTO RESTAURANTTAG VALUES (35, 15);
INSERT INTO RESTAURANTTAG VALUES (35, 20);
INSERT INTO RESTAURANTTAG VALUES (35, 23);
INSERT INTO RESTAURANTTAG VALUES (35, 28);
INSERT INTO RESTAURANTTAG VALUES (36, 1);
INSERT INTO RESTAURANTTAG VALUES (36, 11);
INSERT INTO RESTAURANTTAG VALUES (36, 15);
INSERT INTO RESTAURANTTAG VALUES (37, 17);
INSERT INTO RESTAURANTTAG VALUES (38, 3);
INSERT INTO RESTAURANTTAG VALUES (38, 12);
INSERT INTO RESTAURANTTAG VALUES (38, 38);
INSERT INTO RESTAURANTTAG VALUES (39, 11);
INSERT INTO RESTAURANTTAG VALUES (39, 12);
INSERT INTO RESTAURANTTAG VALUES (39, 40);
INSERT INTO RESTAURANTTAG VALUES (40, 6);
INSERT INTO RESTAURANTTAG VALUES (41, 4);
INSERT INTO RESTAURANTTAG VALUES (41, 6);
INSERT INTO RESTAURANTTAG VALUES (41, 18);
INSERT INTO RESTAURANTTAG VALUES (41, 20);
INSERT INTO RESTAURANTTAG VALUES (41, 23);
INSERT INTO RESTAURANTTAG VALUES (41, 29);
INSERT INTO RESTAURANTTAG VALUES (41, 40);
INSERT INTO RESTAURANTTAG VALUES (42, 7);
INSERT INTO RESTAURANTTAG VALUES (42, 13);
INSERT INTO RESTAURANTTAG VALUES (42, 32);
INSERT INTO RESTAURANTTAG VALUES (43, 13);
INSERT INTO RESTAURANTTAG VALUES (44, 37);
INSERT INTO RESTAURANTTAG VALUES (45, 3);
INSERT INTO RESTAURANTTAG VALUES (45, 9);
INSERT INTO RESTAURANTTAG VALUES (45, 22);
INSERT INTO RESTAURANTTAG VALUES (45, 27);
INSERT INTO RESTAURANTTAG VALUES (45, 31);
INSERT INTO RESTAURANTTAG VALUES (46, 32);
INSERT INTO RESTAURANTTAG VALUES (47, 3);
INSERT INTO RESTAURANTTAG VALUES (47, 13);
INSERT INTO RESTAURANTTAG VALUES (47, 28);
INSERT INTO RESTAURANTTAG VALUES (47, 38);
INSERT INTO RESTAURANTTAG VALUES (48, 4);
INSERT INTO RESTAURANTTAG VALUES (48, 13);
INSERT INTO RESTAURANTTAG VALUES (48, 16);
INSERT INTO RESTAURANTTAG VALUES (48, 27);
INSERT INTO RESTAURANTTAG VALUES (49, 3);
INSERT INTO RESTAURANTTAG VALUES (49, 22);
INSERT INTO RESTAURANTTAG VALUES (49, 30);
INSERT INTO RESTAURANTTAG VALUES (50, 29);

-- GROUPMEMBER (150 rows)
INSERT INTO GROUPMEMBER VALUES (1, 19, '2025-07-03 00:26:40');
INSERT INTO GROUPMEMBER VALUES (1, 48, '2025-05-14 05:35:29');
INSERT INTO GROUPMEMBER VALUES (2, 6, '2025-12-19 04:12:11');
INSERT INTO GROUPMEMBER VALUES (2, 26, '2025-07-10 17:31:02');
INSERT INTO GROUPMEMBER VALUES (3, 19, '2025-05-27 18:19:31');
INSERT INTO GROUPMEMBER VALUES (3, 21, '2025-09-24 14:14:01');
INSERT INTO GROUPMEMBER VALUES (3, 24, '2025-01-05 08:19:40');
INSERT INTO GROUPMEMBER VALUES (3, 43, '2025-11-16 03:41:42');
INSERT INTO GROUPMEMBER VALUES (4, 5, '2025-05-14 05:31:58');
INSERT INTO GROUPMEMBER VALUES (4, 8, '2025-12-21 07:01:07');
INSERT INTO GROUPMEMBER VALUES (4, 10, '2025-05-16 02:38:47');
INSERT INTO GROUPMEMBER VALUES (4, 33, '2025-06-19 15:36:27');
INSERT INTO GROUPMEMBER VALUES (5, 2, '2025-05-21 21:30:44');
INSERT INTO GROUPMEMBER VALUES (5, 36, '2025-02-12 16:46:36');
INSERT INTO GROUPMEMBER VALUES (6, 2, '2025-01-28 08:10:37');
INSERT INTO GROUPMEMBER VALUES (6, 6, '2025-01-05 10:29:56');
INSERT INTO GROUPMEMBER VALUES (6, 10, '2025-12-05 11:10:03');
INSERT INTO GROUPMEMBER VALUES (6, 33, '2025-05-12 13:40:58');
INSERT INTO GROUPMEMBER VALUES (7, 11, '2025-06-02 09:18:33');
INSERT INTO GROUPMEMBER VALUES (8, 31, '2025-11-03 16:12:49');
INSERT INTO GROUPMEMBER VALUES (9, 20, '2025-11-06 03:38:48');
INSERT INTO GROUPMEMBER VALUES (9, 31, '2025-03-18 10:55:20');
INSERT INTO GROUPMEMBER VALUES (9, 44, '2025-11-26 09:17:43');
INSERT INTO GROUPMEMBER VALUES (9, 46, '2025-12-23 11:06:34');
INSERT INTO GROUPMEMBER VALUES (10, 11, '2025-10-12 04:00:08');
INSERT INTO GROUPMEMBER VALUES (10, 24, '2025-09-10 11:49:31');
INSERT INTO GROUPMEMBER VALUES (10, 30, '2025-07-11 05:06:13');
INSERT INTO GROUPMEMBER VALUES (10, 37, '2025-03-17 07:53:12');
INSERT INTO GROUPMEMBER VALUES (11, 17, '2025-09-20 22:53:33');
INSERT INTO GROUPMEMBER VALUES (11, 35, '2025-09-23 17:44:48');
INSERT INTO GROUPMEMBER VALUES (12, 12, '2025-02-14 14:58:04');
INSERT INTO GROUPMEMBER VALUES (13, 30, '2025-02-27 04:59:01');
INSERT INTO GROUPMEMBER VALUES (13, 38, '2025-08-12 09:44:23');
INSERT INTO GROUPMEMBER VALUES (14, 9, '2025-03-27 14:56:38');
INSERT INTO GROUPMEMBER VALUES (14, 20, '2025-09-25 10:11:45');
INSERT INTO GROUPMEMBER VALUES (14, 34, '2025-05-01 23:52:07');
INSERT INTO GROUPMEMBER VALUES (14, 36, '2025-04-05 22:09:44');
INSERT INTO GROUPMEMBER VALUES (14, 47, '2025-04-10 04:13:08');
INSERT INTO GROUPMEMBER VALUES (14, 49, '2025-02-14 22:48:50');
INSERT INTO GROUPMEMBER VALUES (15, 21, '2025-02-03 00:49:30');
INSERT INTO GROUPMEMBER VALUES (15, 29, '2025-07-02 06:06:02');
INSERT INTO GROUPMEMBER VALUES (15, 31, '2025-11-17 18:03:30');
INSERT INTO GROUPMEMBER VALUES (15, 34, '2025-02-09 01:04:19');
INSERT INTO GROUPMEMBER VALUES (16, 8, '2025-11-01 03:50:07');
INSERT INTO GROUPMEMBER VALUES (16, 42, '2025-10-07 18:57:12');
INSERT INTO GROUPMEMBER VALUES (18, 8, '2025-03-22 11:01:05');
INSERT INTO GROUPMEMBER VALUES (18, 13, '2025-03-28 23:17:37');
INSERT INTO GROUPMEMBER VALUES (18, 45, '2025-06-12 05:54:32');
INSERT INTO GROUPMEMBER VALUES (19, 5, '2025-12-20 07:32:36');
INSERT INTO GROUPMEMBER VALUES (19, 11, '2025-02-04 18:48:00');
INSERT INTO GROUPMEMBER VALUES (19, 13, '2025-09-07 22:12:18');
INSERT INTO GROUPMEMBER VALUES (19, 27, '2025-03-25 17:00:46');
INSERT INTO GROUPMEMBER VALUES (19, 31, '2025-02-07 16:54:45');
INSERT INTO GROUPMEMBER VALUES (19, 49, '2025-08-12 22:37:11');
INSERT INTO GROUPMEMBER VALUES (20, 2, '2025-08-22 03:11:53');
INSERT INTO GROUPMEMBER VALUES (20, 8, '2025-06-13 13:13:32');
INSERT INTO GROUPMEMBER VALUES (20, 11, '2025-04-14 03:48:20');
INSERT INTO GROUPMEMBER VALUES (20, 29, '2025-02-15 03:33:08');
INSERT INTO GROUPMEMBER VALUES (20, 37, '2025-08-25 11:45:18');
INSERT INTO GROUPMEMBER VALUES (21, 4, '2025-09-24 01:05:20');
INSERT INTO GROUPMEMBER VALUES (21, 10, '2025-08-04 12:18:29');
INSERT INTO GROUPMEMBER VALUES (21, 23, '2025-10-24 09:43:53');
INSERT INTO GROUPMEMBER VALUES (22, 5, '2025-08-08 17:26:18');
INSERT INTO GROUPMEMBER VALUES (22, 16, '2025-07-07 02:57:53');
INSERT INTO GROUPMEMBER VALUES (22, 34, '2025-08-22 11:11:00');
INSERT INTO GROUPMEMBER VALUES (22, 42, '2025-11-16 21:06:25');
INSERT INTO GROUPMEMBER VALUES (23, 6, '2025-08-17 21:43:05');
INSERT INTO GROUPMEMBER VALUES (23, 18, '2025-02-05 12:25:44');
INSERT INTO GROUPMEMBER VALUES (23, 19, '2025-10-04 23:59:57');
INSERT INTO GROUPMEMBER VALUES (23, 23, '2025-03-03 11:12:21');
INSERT INTO GROUPMEMBER VALUES (23, 27, '2025-04-20 12:07:14');
INSERT INTO GROUPMEMBER VALUES (24, 12, '2025-07-24 15:17:48');
INSERT INTO GROUPMEMBER VALUES (24, 19, '2025-12-25 18:37:17');
INSERT INTO GROUPMEMBER VALUES (24, 23, '2025-11-13 11:30:42');
INSERT INTO GROUPMEMBER VALUES (24, 41, '2025-10-13 15:32:17');
INSERT INTO GROUPMEMBER VALUES (24, 44, '2025-03-25 14:06:07');
INSERT INTO GROUPMEMBER VALUES (25, 24, '2025-05-16 15:14:40');
INSERT INTO GROUPMEMBER VALUES (25, 45, '2025-03-01 03:47:03');
INSERT INTO GROUPMEMBER VALUES (26, 10, '2025-02-16 21:01:11');
INSERT INTO GROUPMEMBER VALUES (26, 12, '2025-07-20 21:20:09');
INSERT INTO GROUPMEMBER VALUES (26, 13, '2025-05-20 19:06:48');
INSERT INTO GROUPMEMBER VALUES (26, 40, '2025-02-22 16:49:31');
INSERT INTO GROUPMEMBER VALUES (27, 9, '2025-08-07 09:42:31');
INSERT INTO GROUPMEMBER VALUES (27, 29, '2025-08-17 08:34:21');
INSERT INTO GROUPMEMBER VALUES (27, 38, '2025-09-18 00:48:02');
INSERT INTO GROUPMEMBER VALUES (28, 18, '2025-07-04 12:28:20');
INSERT INTO GROUPMEMBER VALUES (28, 24, '2025-07-15 14:02:02');
INSERT INTO GROUPMEMBER VALUES (28, 47, '2025-03-18 21:55:49');
INSERT INTO GROUPMEMBER VALUES (28, 49, '2025-05-23 05:31:27');
INSERT INTO GROUPMEMBER VALUES (29, 17, '2025-03-10 22:24:31');
INSERT INTO GROUPMEMBER VALUES (29, 22, '2025-02-19 21:31:42');
INSERT INTO GROUPMEMBER VALUES (29, 30, '2025-09-22 17:36:30');
INSERT INTO GROUPMEMBER VALUES (29, 32, '2025-08-18 05:32:03');
INSERT INTO GROUPMEMBER VALUES (29, 35, '2025-07-09 15:37:24');
INSERT INTO GROUPMEMBER VALUES (29, 40, '2025-10-22 11:49:18');
INSERT INTO GROUPMEMBER VALUES (29, 48, '2025-06-02 00:37:02');
INSERT INTO GROUPMEMBER VALUES (30, 11, '2025-03-27 11:22:51');
INSERT INTO GROUPMEMBER VALUES (30, 30, '2025-12-19 00:48:57');
INSERT INTO GROUPMEMBER VALUES (30, 37, '2025-11-11 12:06:27');
INSERT INTO GROUPMEMBER VALUES (30, 40, '2025-06-12 13:22:03');
INSERT INTO GROUPMEMBER VALUES (30, 46, '2025-11-08 07:15:41');
INSERT INTO GROUPMEMBER VALUES (31, 3, '2025-05-19 02:58:44');
INSERT INTO GROUPMEMBER VALUES (31, 34, '2025-02-28 09:07:21');
INSERT INTO GROUPMEMBER VALUES (31, 43, '2025-03-01 17:20:02');
INSERT INTO GROUPMEMBER VALUES (32, 10, '2025-08-22 13:36:32');
INSERT INTO GROUPMEMBER VALUES (32, 21, '2025-07-09 00:44:30');
INSERT INTO GROUPMEMBER VALUES (32, 38, '2025-10-01 10:24:36');
INSERT INTO GROUPMEMBER VALUES (32, 50, '2025-07-11 18:06:51');
INSERT INTO GROUPMEMBER VALUES (33, 4, '2025-08-04 22:43:13');
INSERT INTO GROUPMEMBER VALUES (33, 34, '2025-06-16 16:51:48');
INSERT INTO GROUPMEMBER VALUES (33, 44, '2025-11-11 05:39:19');
INSERT INTO GROUPMEMBER VALUES (34, 15, '2025-06-14 06:31:40');
INSERT INTO GROUPMEMBER VALUES (34, 36, '2025-02-27 17:13:18');
INSERT INTO GROUPMEMBER VALUES (35, 8, '2025-05-02 09:36:25');
INSERT INTO GROUPMEMBER VALUES (35, 19, '2025-04-20 23:05:45');
INSERT INTO GROUPMEMBER VALUES (35, 29, '2025-10-04 18:21:17');
INSERT INTO GROUPMEMBER VALUES (35, 33, '2025-02-19 16:30:27');
INSERT INTO GROUPMEMBER VALUES (35, 44, '2025-04-12 02:41:52');
INSERT INTO GROUPMEMBER VALUES (36, 6, '2025-05-17 09:27:42');
INSERT INTO GROUPMEMBER VALUES (36, 8, '2025-09-11 06:26:25');
INSERT INTO GROUPMEMBER VALUES (37, 9, '2025-05-20 16:29:42');
INSERT INTO GROUPMEMBER VALUES (37, 14, '2025-09-06 00:40:45');
INSERT INTO GROUPMEMBER VALUES (37, 43, '2025-09-28 05:36:31');
INSERT INTO GROUPMEMBER VALUES (38, 2, '2025-04-22 23:29:17');
INSERT INTO GROUPMEMBER VALUES (38, 39, '2025-11-18 19:54:49');
INSERT INTO GROUPMEMBER VALUES (38, 45, '2025-07-19 23:40:03');
INSERT INTO GROUPMEMBER VALUES (38, 49, '2025-09-07 11:29:09');
INSERT INTO GROUPMEMBER VALUES (39, 39, '2025-04-05 23:43:48');
INSERT INTO GROUPMEMBER VALUES (39, 42, '2025-05-28 13:26:20');
INSERT INTO GROUPMEMBER VALUES (40, 11, '2025-02-21 06:54:26');
INSERT INTO GROUPMEMBER VALUES (40, 22, '2025-05-27 09:41:10');
INSERT INTO GROUPMEMBER VALUES (40, 35, '2025-05-22 19:15:25');
INSERT INTO GROUPMEMBER VALUES (41, 1, '2025-04-04 04:12:01');
INSERT INTO GROUPMEMBER VALUES (41, 2, '2025-04-26 09:29:31');
INSERT INTO GROUPMEMBER VALUES (41, 5, '2025-09-14 13:41:57');
INSERT INTO GROUPMEMBER VALUES (42, 2, '2025-01-07 05:17:08');
INSERT INTO GROUPMEMBER VALUES (42, 21, '2025-01-09 08:42:35');
INSERT INTO GROUPMEMBER VALUES (42, 22, '2025-03-21 01:46:31');
INSERT INTO GROUPMEMBER VALUES (42, 31, '2025-01-02 02:20:38');
INSERT INTO GROUPMEMBER VALUES (42, 36, '2025-05-28 02:57:26');
INSERT INTO GROUPMEMBER VALUES (43, 24, '2025-06-22 21:56:05');
INSERT INTO GROUPMEMBER VALUES (43, 45, '2025-07-27 23:53:08');
INSERT INTO GROUPMEMBER VALUES (44, 6, '2025-04-04 18:47:32');
INSERT INTO GROUPMEMBER VALUES (44, 24, '2025-02-17 21:53:37');
INSERT INTO GROUPMEMBER VALUES (44, 35, '2025-09-09 15:56:05');
INSERT INTO GROUPMEMBER VALUES (44, 43, '2025-04-20 03:49:51');
INSERT INTO GROUPMEMBER VALUES (45, 5, '2025-06-11 18:47:24');
INSERT INTO GROUPMEMBER VALUES (45, 8, '2025-12-24 07:59:27');
INSERT INTO GROUPMEMBER VALUES (45, 10, '2025-04-05 03:11:13');
INSERT INTO GROUPMEMBER VALUES (45, 43, '2025-05-15 13:16:55');
