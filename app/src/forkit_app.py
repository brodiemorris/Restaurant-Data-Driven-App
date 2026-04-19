import streamlit as st
import pandas as pd
import mysql.connector
import streamlit.components.v1 as components

st.set_page_config(page_title="Fork-It", layout="wide")

# ---------- STYLING ----------
st.markdown("""
<style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

    .stApp {
        background-color: #faf9f7;
        font-family: 'Inter', sans-serif;
    }

    #MainMenu {visibility: hidden;}
    footer {visibility: hidden;}
    header {visibility: hidden;}

    .block-container {
        padding-top: 1rem;
        padding-bottom: 2rem;
        max-width: 1100px;
    }

    /* ---------- HERO ---------- */
    .hero-box {
        background: #faf9f7;
        padding: 1.2rem 0 0.8rem 0;
        margin-bottom: 0.6rem;
        border-bottom: 0.5px solid rgba(0,0,0,0.08);
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .hero-title {
        font-size: 1.6rem;
        font-weight: 600;
        color: #1a1a18;
        letter-spacing: -0.5px;
        margin: 0;
    }

    .hero-title .it {
        color: #D85A30;
    }

    .hero-sub {
        font-size: 0.85rem;
        color: #73726c;
        margin: 0;
        letter-spacing: 0.3px;
    }

    /* ---------- SECTION TITLES ---------- */
    .section-title {
        font-size: 1.1rem;
        font-weight: 600;
        color: #1a1a18;
        margin-top: 0.4rem;
        margin-bottom: 0.7rem;
        letter-spacing: -0.3px;
    }

    /* ---------- CARDS ---------- */
    .fork-card {
        background: #ffffff;
        border: 0.5px solid rgba(0,0,0,0.08);
        border-radius: 12px;
        padding: 1rem 1.15rem;
        margin-bottom: 0.75rem;
        transition: border-color 0.15s;
    }

    .fork-card:hover {
        border-color: rgba(0,0,0,0.18);
    }

    .fork-card-title {
        font-size: 1.05rem;
        font-weight: 600;
        color: #1a1a18;
        margin-bottom: 0.2rem;
        letter-spacing: -0.2px;
    }

    .fork-card-meta {
        color: #73726c;
        font-size: 0.82rem;
        margin-bottom: 0.4rem;
    }

    .fork-card-desc {
        color: #3d3d3a;
        font-size: 0.88rem;
        margin-bottom: 0.6rem;
        line-height: 1.55;
    }

    /* ---------- PILLS / TAGS ---------- */
    .metric-pill {
        display: inline-block;
        background: #faf9f7;
        color: #73726c;
        border: 0.5px solid rgba(0,0,0,0.08);
        border-radius: 8px;
        padding: 0.25rem 0.6rem;
        font-size: 0.8rem;
        margin-right: 0.35rem;
        margin-bottom: 0.3rem;
    }

    .rating-pill {
        display: inline-block;
        background: #FAECE7;
        color: #993C1D;
        border: 0.5px solid #F0997B;
        border-radius: 8px;
        padding: 0.25rem 0.6rem;
        font-size: 0.8rem;
    }

    /* ---------- MINI BOX ---------- */
    .mini-box {
        background: #ffffff;
        border: 0.5px solid rgba(0,0,0,0.08);
        border-radius: 12px;
        padding: 1rem 1.1rem;
    }

    /* ---------- FORM ELEMENTS ---------- */
    div[data-baseweb="select"] > div {
        border-radius: 10px !important;
        border-color: rgba(0,0,0,0.1) !important;
    }

    .stTextInput input, .stTextArea textarea, .stNumberInput input {
        border-radius: 10px !important;
        border-color: rgba(0,0,0,0.1) !important;
    }

    .stTextInput input:focus, .stTextArea textarea:focus {
        border-color: #D85A30 !important;
        box-shadow: 0 0 0 1px #D85A30 !important;
    }

    .stButton > button {
        background-color: #D85A30;
        color: white;
        border: none;
        border-radius: 10px;
        padding: 0.55rem 1.2rem;
        font-weight: 600;
        font-size: 0.88rem;
        letter-spacing: -0.1px;
        transition: background-color 0.15s;
    }

    .stButton > button:hover {
        background-color: #c04e28;
        color: white;
    }

    .stDataFrame, .stTable {
        border-radius: 12px;
        overflow: hidden;
    }

    /* ---------- SIDEBAR ---------- */
    [data-testid="stSidebar"] {
        background: #ffffff;
        border-right: 0.5px solid rgba(0,0,0,0.08);
    }

    [data-testid="stSidebar"] .stRadio label {
        font-size: 0.9rem;
        color: #3d3d3a;
    }

    /* ---------- METRICS ---------- */
    [data-testid="stMetric"] {
        background: #ffffff;
        border: 0.5px solid rgba(0,0,0,0.08);
        border-radius: 12px;
        padding: 0.8rem 1rem;
    }

    [data-testid="stMetric"] label {
        color: #73726c !important;
        font-size: 0.78rem !important;
        font-weight: 500 !important;
        text-transform: lowercase;
    }

    [data-testid="stMetric"] [data-testid="stMetricValue"] {
        color: #1a1a18 !important;
        font-weight: 600 !important;
    }

    /* ---------- SLIDER ---------- */
    .stSlider [data-baseweb="slider"] [role="slider"] {
        background-color: #D85A30 !important;
    }

    /* ---------- BAR CHART ---------- */
    .stBarChart {
        border-radius: 12px;
        overflow: hidden;
    }

    /* ---------- PERSONA CARD ---------- */
    .persona-card {
        background: #ffffff;
        border: 1.5px solid rgba(0,0,0,0.08);
        border-radius: 14px;
        padding: 1.4rem 1.2rem;
        text-align: center;
        transition: border-color 0.2s, box-shadow 0.2s;
    }
    .persona-card:hover {
        border-color: #D85A30;
        box-shadow: 0 2px 12px rgba(216,90,48,0.10);
    }
    .persona-icon {
        font-size: 2.4rem;
        margin-bottom: 0.5rem;
    }
    .persona-name {
        font-size: 1rem;
        font-weight: 600;
        color: #1a1a18;
        margin-bottom: 0.15rem;
    }
    .persona-role {
        font-size: 0.82rem;
        color: #73726c;
        margin-bottom: 0.5rem;
    }
    .persona-desc {
        font-size: 0.82rem;
        color: #3d3d3a;
        line-height: 1.5;
    }
</style>
""", unsafe_allow_html=True)

# ---------- SVG LOGO ----------
FORK_SVG = '<svg width="28" height="28" viewBox="0 0 44 180" fill="none" xmlns="http://www.w3.org/2000/svg"><line x1="4" y1="0" x2="4" y2="58" stroke="#D85A30" stroke-width="3.5" stroke-linecap="round"/><line x1="16" y1="0" x2="16" y2="58" stroke="#D85A30" stroke-width="3.5" stroke-linecap="round"/><line x1="28" y1="0" x2="28" y2="58" stroke="#D85A30" stroke-width="3.5" stroke-linecap="round"/><line x1="40" y1="0" x2="40" y2="58" stroke="#D85A30" stroke-width="3.5" stroke-linecap="round"/><path d="M 4,58 Q 4,72 22,72 Q 40,72 40,58" fill="none" stroke="#D85A30" stroke-width="3.5" stroke-linecap="round"/><line x1="22" y1="72" x2="22" y2="170" stroke="#D85A30" stroke-width="3.5" stroke-linecap="round"/></svg>'

# ---------- DATABASE ----------
def get_connection():
    return mysql.connector.connect(
        host="127.0.0.1",
        port=3200,
        user="root",
        password="ForkIt$123",
        database="forkit"
    )

def run_query(query, params=None):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(query, params or ())
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return pd.DataFrame(rows)

def run_action(query, params=None):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(query, params or ())
    conn.commit()
    cursor.close()
    conn.close()

# ---------- SESSION STATE INIT ----------
if "logged_in" not in st.session_state:
    st.session_state.logged_in = False
if "user_id" not in st.session_state:
    st.session_state.user_id = None
if "user_name" not in st.session_state:
    st.session_state.user_name = ""
if "persona" not in st.session_state:
    st.session_state.persona = None

# =====================================================================
#  LANDING PAGE — Persona Select + Login
# =====================================================================
if not st.session_state.logged_in:
    st.markdown(f"""
    <div style="display:flex;align-items:center;gap:12px;margin-bottom:0.2rem;">
        {FORK_SVG}
        <div>
            <p style="font-size:1.6rem;font-weight:600;color:#1a1a18;letter-spacing:-0.5px;margin:0;">fork-<span style="color:#D85A30;">it</span></p>
            <p style="font-size:0.85rem;color:#73726c;margin:0;">Stop debating, start eating.</p>
        </div>
    </div>
    """, unsafe_allow_html=True)
    st.markdown('<hr style="border:none;border-top:0.5px solid rgba(0,0,0,0.08);margin:0.4rem 0 1.2rem 0;">', unsafe_allow_html=True)

    st.markdown('<div class="section-title">Who are you?</div>', unsafe_allow_html=True)
    st.caption("Select your persona to get started.")

    # --- Persona cards ---
    personas = [
        {"key": "diner",   "icon": "🍽️", "name": "Edgar Ripley",  "role": "Casual Diner",      "desc": "Browse, swipe, and discover restaurants tailored to your taste."},
        {"key": "owner",   "icon": "👨‍🍳", "name": "John Pork",     "role": "Restaurant Owner",  "desc": "Manage your restaurant, menu, promotions, and reviews."},
        {"key": "analyst", "icon": "📊", "name": "Walter White",  "role": "Data Analyst",      "desc": "Explore dining trends, ratings, and export market reports."},
        {"key": "admin",   "icon": "🛡️", "name": "Zara Larson",   "role": "Platform Admin",    "desc": "Approve listings, resolve complaints, and manage the platform."},
    ]

    cols = st.columns(4)
    for i, p in enumerate(personas):
        with cols[i]:
            st.markdown(f"""
            <div class="persona-card">
                <div class="persona-icon">{p['icon']}</div>
                <div class="persona-name">{p['name']}</div>
                <div class="persona-role">{p['role']}</div>
                <div class="persona-desc">{p['desc']}</div>
            </div>
            """, unsafe_allow_html=True)

    st.markdown("<br>", unsafe_allow_html=True)

    # --- Persona select widget ---
    persona_choice = st.selectbox(
        "Select your persona",
        ["-- Choose --", "Casual Diner", "Restaurant Owner", "Data Analyst", "Platform Admin"]
    )

    # --- User login based on persona ---
    if persona_choice != "-- Choose --":
        role_map = {
            "Casual Diner": "user",
            "Restaurant Owner": "owner",
            "Data Analyst": "admin",   # analysts are admin-role in DB
            "Platform Admin": "admin",
        }
        role = role_map[persona_choice]

        if persona_choice == "Data Analyst":
            users = run_query("SELECT user_id, first_name, last_name FROM `USER` WHERE role = 'admin'")
        elif persona_choice == "Platform Admin":
            users = run_query("SELECT user_id, first_name, last_name FROM `USER` WHERE role = 'admin'")
        else:
            users = run_query("SELECT user_id, first_name, last_name FROM `USER` WHERE role = %s", (role,))

        if users.empty:
            st.warning(f"No users found with the '{role}' role in the database.")
        else:
            user_options = {f"{row['first_name']} {row['last_name']} (ID: {row['user_id']})": row['user_id'] for _, row in users.iterrows()}
            selected_user = st.selectbox("Log in as", list(user_options.keys()))

            if st.button("Log in →"):
                uid = user_options[selected_user]
                st.session_state.logged_in = True
                st.session_state.user_id = uid
                st.session_state.user_name = selected_user.split(" (ID")[0]
                st.session_state.persona = persona_choice
                st.rerun()

    st.stop()

# =====================================================================
#  LOGGED-IN APP — Sidebar + Pages
# =====================================================================

# ---------- HEADER ----------
col_logo, col_head, col_user = st.columns([1, 6, 3])
with col_logo:
    st.markdown(FORK_SVG, unsafe_allow_html=True)
with col_head:
    st.markdown('<p style="font-size:1.6rem;font-weight:600;color:#1a1a18;letter-spacing:-0.5px;margin:0;">fork-<span style="color:#D85A30;">it</span></p>', unsafe_allow_html=True)
    st.markdown('<p style="font-size:0.85rem;color:#73726c;margin:0;">Stop debating, start eating.</p>', unsafe_allow_html=True)
with col_user:
    st.markdown(f'<p style="text-align:right;color:#73726c;font-size:0.85rem;margin-top:0.5rem;">{st.session_state.persona} &middot; <strong>{st.session_state.user_name}</strong></p>', unsafe_allow_html=True)

st.markdown('<hr style="border:none;border-top:0.5px solid rgba(0,0,0,0.08);margin:0.4rem 0 0.8rem 0;">', unsafe_allow_html=True)

# ---------- SIDEBAR NAV ----------
st.sidebar.markdown(FORK_SVG, unsafe_allow_html=True)
st.sidebar.markdown(f'<p style="font-size:1rem;font-weight:600;color:#1a1a18;letter-spacing:-0.3px;margin:0 0 0.2rem 0;">fork-<span style="color:#D85A30;">it</span></p>', unsafe_allow_html=True)
st.sidebar.markdown(f'<p style="font-size:0.82rem;color:#73726c;margin:0 0 0.8rem 0;">{st.session_state.persona}</p>', unsafe_allow_html=True)

persona = st.session_state.persona

if persona == "Casual Diner":
    nav_options = ["Home", "Swipe & Discover", "Browse Restaurants", "My Dining History"]
elif persona == "Restaurant Owner":
    nav_options = ["Home", "My Restaurant", "Menu & Promotions", "Reviews & Replies"]
elif persona == "Data Analyst":
    nav_options = ["Home", "Ratings Dashboard", "Market Research", "Export Reports"]
elif persona == "Platform Admin":
    nav_options = ["Home", "Restaurant Submissions", "User Complaints", "Manage Restaurants"]
else:
    nav_options = ["Home"]

page = st.sidebar.radio("Navigate", nav_options)

if st.sidebar.button("Log out"):
    st.session_state.logged_in = False
    st.session_state.user_id = None
    st.session_state.user_name = ""
    st.session_state.persona = None
    st.rerun()

uid = st.session_state.user_id

# =====================================================================
#  HOME PAGES — One per persona
# =====================================================================
if page == "Home":
    if persona == "Casual Diner":
        st.markdown(f'<div class="section-title">Welcome back, {st.session_state.user_name} 👋</div>', unsafe_allow_html=True)
        st.caption("Here's a quick look at your dining life.")

        m1, m2, m3 = st.columns(3)
        with m1:
            count = run_query("SELECT COUNT(*) AS c FROM DININGHISTORY WHERE user_id = %s", (uid,))
            st.metric("Places visited", int(count.iloc[0]["c"]) if not count.empty else 0)
        with m2:
            count = run_query("SELECT COUNT(*) AS c FROM REVIEW WHERE user_id = %s", (uid,))
            st.metric("Reviews written", int(count.iloc[0]["c"]) if not count.empty else 0)
        with m3:
            count = run_query("SELECT COUNT(*) AS c FROM SWIPEACTIVITY WHERE user_id = %s AND swipe_result = 'like'", (uid,))
            st.metric("Restaurants liked", int(count.iloc[0]["c"]) if not count.empty else 0)

        st.markdown("<br>", unsafe_allow_html=True)
        st.markdown("##### Recent dining history")
        recent = run_query("""
            SELECT r.restaurant_name, dh.visit_date, dh.user_rating
            FROM DININGHISTORY dh
            JOIN RESTAURANT r ON dh.restaurant_id = r.restaurant_id
            WHERE dh.user_id = %s
            ORDER BY dh.visit_date DESC LIMIT 5
        """, (uid,))
        if recent.empty:
            st.info("No dining history yet. Start swiping!")
        else:
            st.dataframe(recent, use_container_width=True, hide_index=True)

    elif persona == "Restaurant Owner":
        st.markdown(f'<div class="section-title">Welcome back, {st.session_state.user_name} 👨‍🍳</div>', unsafe_allow_html=True)
        st.caption("Overview of your restaurants.")

        restaurants = run_query("""
            SELECT r.restaurant_id, r.restaurant_name, r.avg_rating, r.is_active, c.city_name, p.tier_label
            FROM RESTAURANT r
            JOIN CITY c ON r.city_id = c.city_id
            JOIN PRICETIER p ON r.price_tier_id = p.price_tier_id
            WHERE r.owner_user_id = %s
        """, (uid,))

        if restaurants.empty:
            st.info("You don't own any restaurants yet.")
        else:
            m1, m2, m3 = st.columns(3)
            with m1:
                st.metric("Your restaurants", len(restaurants))
            with m2:
                avg = restaurants["avg_rating"].mean()
                st.metric("Avg rating", f"{avg:.1f}")
            with m3:
                review_count = run_query("""
                    SELECT COUNT(*) AS c FROM REVIEW rv
                    JOIN RESTAURANT r ON rv.restaurant_id = r.restaurant_id
                    WHERE r.owner_user_id = %s
                """, (uid,))
                st.metric("Total reviews", int(review_count.iloc[0]["c"]))

            for _, row in restaurants.iterrows():
                active_label = "Active" if row["is_active"] else "Inactive"
                active_color = "#0F6E56" if row["is_active"] else "#A32D2D"
                st.markdown(f"""
                <div class="fork-card">
                    <div class="fork-card-title">{row['restaurant_name']}</div>
                    <div class="fork-card-meta">{row['city_name']} &middot; {row['tier_label']} &middot;
                        <span class="rating-pill">{row['avg_rating']}</span> &middot;
                        <span style="color:{active_color};font-weight:500;">{active_label}</span>
                    </div>
                </div>
                """, unsafe_allow_html=True)

    elif persona == "Data Analyst":
        st.markdown(f'<div class="section-title">Welcome back, {st.session_state.user_name} 📊</div>', unsafe_allow_html=True)
        st.caption("Platform overview at a glance.")

        m1, m2, m3, m4 = st.columns(4)
        with m1:
            st.metric("Restaurants", int(run_query("SELECT COUNT(*) AS c FROM RESTAURANT").iloc[0]["c"]))
        with m2:
            st.metric("Reviews", int(run_query("SELECT COUNT(*) AS c FROM REVIEW").iloc[0]["c"]))
        with m3:
            st.metric("Users", int(run_query("SELECT COUNT(*) AS c FROM `USER`").iloc[0]["c"]))
        with m4:
            st.metric("Cities", int(run_query("SELECT COUNT(*) AS c FROM CITY").iloc[0]["c"]))

        st.markdown("<br>", unsafe_allow_html=True)
        st.markdown("##### Top rated cuisines")
        top_cuisines = run_query("""
            SELECT cu.cuisine_name, ROUND(AVG(r.avg_rating), 2) AS avg_rating, COUNT(DISTINCT r.restaurant_id) AS restaurant_count
            FROM RESTAURANT r
            JOIN RESTAURANTCUISINE rc ON r.restaurant_id = rc.restaurant_id
            JOIN CUISINE cu ON rc.cuisine_id = cu.cuisine_id
            GROUP BY cu.cuisine_name
            ORDER BY avg_rating DESC
            LIMIT 10
        """)
        if not top_cuisines.empty:
            st.dataframe(top_cuisines, use_container_width=True, hide_index=True)

    elif persona == "Platform Admin":
        st.markdown(f'<div class="section-title">Welcome back, {st.session_state.user_name} 🛡️</div>', unsafe_allow_html=True)
        st.caption("Platform health dashboard.")

        m1, m2, m3, m4 = st.columns(4)
        with m1:
            pending = run_query("SELECT COUNT(*) AS c FROM RESTAURANTSUBMISSION WHERE status = 'pending'")
            st.metric("Pending submissions", int(pending.iloc[0]["c"]))
        with m2:
            open_complaints = run_query("SELECT COUNT(*) AS c FROM USERCOMPLAINT WHERE status IN ('open','in_review')")
            st.metric("Open complaints", int(open_complaints.iloc[0]["c"]))
        with m3:
            st.metric("Total restaurants", int(run_query("SELECT COUNT(*) AS c FROM RESTAURANT").iloc[0]["c"]))
        with m4:
            st.metric("Total users", int(run_query("SELECT COUNT(*) AS c FROM `USER`").iloc[0]["c"]))

        st.markdown("<br>", unsafe_allow_html=True)
        st.markdown("##### Recent submissions")
        recent_subs = run_query("""
            SELECT rs.restaurant_name, rs.status, rs.submitted_at,
                   u.first_name, u.last_name
            FROM RESTAURANTSUBMISSION rs
            JOIN `USER` u ON rs.submitted_by_user_id = u.user_id
            ORDER BY rs.submitted_at DESC LIMIT 5
        """)
        if not recent_subs.empty:
            st.dataframe(recent_subs, use_container_width=True, hide_index=True)


# =====================================================================
#  CASUAL DINER PAGES
# =====================================================================
elif page == "Swipe & Discover":
    st.markdown('<div class="section-title">What are you in the mood for?</div>', unsafe_allow_html=True)
    st.caption("Swipe right if it sounds good, left if it doesn't. We'll find your perfect spot.")

    swipe_html = """
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="utf-8">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; background: transparent; display: flex; flex-direction: column; align-items: center; padding: 10px 0; }
        .progress { display: flex; align-items: center; gap: 8px; width: 320px; margin-bottom: 16px; }
        .progress span { font-size: 12px; color: #73726c; white-space: nowrap; }
        .bar-bg { flex: 1; height: 4px; border-radius: 3px; background: #e8e7e4; overflow: hidden; }
        .bar-fill { height: 100%; border-radius: 3px; background: #D85A30; transition: width 0.35s; }
        .card-area { width: 320px; height: 380px; position: relative; display: flex; align-items: center; justify-content: center; }
        .card {
            width: 100%; height: 100%;
            border-radius: 16px; border: 1px solid #e8e7e4; background: #fff;
            display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 14px;
            cursor: grab; user-select: none;
            transition: transform 0.35s ease, opacity 0.35s ease;
            position: absolute; top: 0; left: 0;
        }
        .card.dragging { transition: none; cursor: grabbing; }
        .icon-circle { width: 72px; height: 72px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 32px; }
        .card-q { font-size: 22px; font-weight: 600; color: #1a1a18; text-align: center; padding: 0 24px; line-height: 1.3; }
        .card-sub { font-size: 13px; color: #73726c; }
        .hint { position: absolute; top: 14px; left: 0; right: 0; display: flex; justify-content: center; opacity: 0; transition: opacity 0.15s; pointer-events: none; }
        .hint-label { font-size: 13px; font-weight: 600; padding: 5px 16px; border-radius: 20px; }
        .buttons { display: flex; justify-content: center; align-items: center; gap: 20px; margin-top: 18px; }
        .btn-circle {
            width: 54px; height: 54px; border-radius: 50%; border: 2px solid; background: #fff;
            display: flex; align-items: center; justify-content: center; cursor: pointer; transition: transform 0.1s;
        }
        .btn-circle:active { transform: scale(0.93); }
        .btn-no { border-color: #F09595; }
        .btn-skip { border-color: #d3d1c7; width: 42px; height: 42px; font-size: 14px; font-weight: 600; color: #73726c; }
        .btn-yes { border-color: #97C459; }
        .result-box {
            width: 320px; min-height: 380px; border-radius: 16px; border: 2px solid #D85A30;
            background: #fff; padding: 28px 24px;
            display: none; flex-direction: column; align-items: center; justify-content: center; gap: 14px; text-align: center;
        }
        .result-box .icon-circle { width: 80px; height: 80px; font-size: 36px; background: #FAECE7; }
        .result-title { font-size: 14px; color: #73726c; font-weight: 500; letter-spacing: 0.5px; }
        .result-name { font-size: 24px; font-weight: 700; color: #1a1a18; line-height: 1.2; }
        .result-meta { font-size: 14px; color: #73726c; }
        .result-desc { font-size: 14px; color: #3d3d3a; line-height: 1.5; }
        .result-btn { margin-top: 8px; padding: 12px 28px; background: #D85A30; color: #fff; border: none; border-radius: 12px; font-size: 15px; font-weight: 600; cursor: pointer; }
        .result-btn:hover { background: #c04e28; }
        .retry-btn { padding: 10px 24px; background: #fff; color: #1a1a18; border: 1px solid #e8e7e4; border-radius: 12px; font-size: 14px; font-weight: 500; cursor: pointer; }
    </style>
    </head>
    <body>
    <div class="progress">
        <span id="counter">1 of 8</span>
        <div class="bar-bg"><div class="bar-fill" id="bar" style="width:12.5%"></div></div>
    </div>
    <div class="card-area" id="card-area">
        <div class="card" id="card">
            <div class="hint" id="hint"><span class="hint-label" id="hint-label"></span></div>
            <div class="icon-circle" id="card-icon" style="background:#FAEEDA;">🍝</div>
            <div class="card-q" id="card-q">In the mood for Italian?</div>
            <div class="card-sub" id="card-sub">Pasta, pizza, risotto...</div>
        </div>
    </div>
    <div class="buttons" id="buttons">
        <div class="btn-circle btn-no" onclick="swipeAway('left')"><svg width="20" height="20" viewBox="0 0 20 20" fill="none"><line x1="5" y1="5" x2="15" y2="15" stroke="#E24B4A" stroke-width="2.5" stroke-linecap="round"/><line x1="15" y1="5" x2="5" y2="15" stroke="#E24B4A" stroke-width="2.5" stroke-linecap="round"/></svg></div>
        <div class="btn-circle btn-skip" onclick="swipeAway('skip')">?</div>
        <div class="btn-circle btn-yes" onclick="swipeAway('right')"><svg width="20" height="20" viewBox="0 0 20 20" fill="none"><polyline points="4,11 8,16 16,5" stroke="#639922" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" fill="none"/></svg></div>
    </div>
    <div class="result-box" id="result">
        <div class="result-title">FORK-IT SAYS</div>
        <div class="icon-circle">🍽️</div>
        <div class="result-name" id="res-name">Pasta Corner</div>
        <div class="result-meta" id="res-meta">Boston · $ · 4.2</div>
        <div class="result-desc" id="res-desc">Homestyle pasta and Italian comfort food.</div>
        <button class="result-btn" onclick="alert('Opening in Maps!')">Let's go</button>
        <button class="retry-btn" onclick="restart()">Try again</button>
    </div>
    <script>
    const prompts = [
        { q: "In the mood for Italian?", sub: "Pasta, pizza, risotto...", icon: "🍝", bg: "#FAEEDA", tag: "italian" },
        { q: "Craving something spicy?", sub: "Thai, Indian, Sichuan...", icon: "🌶️", bg: "#FCEBEB", tag: "spicy" },
        { q: "How about sushi?", sub: "Rolls, sashimi, ramen...", icon: "🍣", bg: "#E6F1FB", tag: "japanese" },
        { q: "Feeling a burger?", sub: "Smash, gourmet, classic...", icon: "🍔", bg: "#EAF3DE", tag: "american" },
        { q: "Tacos sound good?", sub: "Street, birria, fish...", icon: "🌮", bg: "#FAEEDA", tag: "mexican" },
        { q: "Want something healthy?", sub: "Salads, bowls, poke...", icon: "🥗", bg: "#E1F5EE", tag: "healthy" },
        { q: "Down for BBQ?", sub: "Ribs, brisket, wings...", icon: "🔥", bg: "#FAECE7", tag: "bbq" },
        { q: "Pizza night?", sub: "Neapolitan, NY-style, deep dish...", icon: "🍕", bg: "#EEEDFE", tag: "pizza" },
    ];
    const restaurants = [
        { name: "Pasta Corner", meta: "Boston · $ · 4.2", desc: "Homestyle pasta and Italian comfort food.", tags: ["italian", "pizza"] },
        { name: "Bangkok Bites", meta: "Boston · $ · 4.5", desc: "Casual Thai street food and noodles.", tags: ["spicy", "healthy"] },
        { name: "Sakura House", meta: "New York · $$ · 4.8", desc: "Upscale sushi and Japanese small plates.", tags: ["japanese", "healthy"] },
        { name: "Taco Spot", meta: "New York · $ · 4.1", desc: "Fast casual tacos and burritos.", tags: ["mexican", "spicy"] },
    ];
    let idx = 0, likes = [];
    const card = document.getElementById('card'), hint = document.getElementById('hint'), hintLabel = document.getElementById('hint-label');
    let startX = 0, dx = 0, dragging = false;
    function updateCard() {
        const p = prompts[idx];
        document.getElementById('card-q').textContent = p.q;
        document.getElementById('card-sub').textContent = p.sub;
        document.getElementById('card-icon').textContent = p.icon;
        document.getElementById('card-icon').style.background = p.bg;
        document.getElementById('counter').textContent = (idx+1)+' of '+prompts.length;
        document.getElementById('bar').style.width = (((idx+1)/prompts.length)*100)+'%';
        card.style.transform='translateX(0) rotate(0deg)'; card.style.opacity='1'; hint.style.opacity='0'; card.classList.remove('dragging');
    }
    function showResult() {
        let best=null, bestScore=-1;
        restaurants.forEach(r => { let s=r.tags.filter(t=>likes.includes(t)).length; if(s>bestScore){bestScore=s;best=r;} });
        if(!best) best=restaurants[0];
        document.getElementById('res-name').textContent=best.name;
        document.getElementById('res-meta').textContent=best.meta;
        document.getElementById('res-desc').textContent=best.desc;
        document.getElementById('card-area').style.display='none';
        document.getElementById('buttons').style.display='none';
        document.querySelector('.progress').style.display='none';
        document.getElementById('result').style.display='flex';
    }
    function swipeAway(dir) {
        if(dir==='right') likes.push(prompts[idx].tag);
        const tx=dir==='left'?-400:dir==='right'?400:0, rot=dir==='left'?-15:dir==='right'?15:0;
        card.classList.remove('dragging');
        card.style.transform='translateX('+tx+'px) rotate('+rot+'deg)'; card.style.opacity='0';
        setTimeout(()=>{idx++; if(idx>=prompts.length){showResult();return;} card.style.transition='none'; card.style.transform='translateX(0) rotate(0deg)'; setTimeout(()=>{card.style.transition='transform 0.35s ease, opacity 0.35s ease'; updateCard();},30);},350);
    }
    function restart() { idx=0; likes=[]; document.getElementById('card-area').style.display='flex'; document.getElementById('buttons').style.display='flex'; document.querySelector('.progress').style.display='flex'; document.getElementById('result').style.display='none'; updateCard(); }
    card.addEventListener('pointerdown',e=>{startX=e.clientX;dx=0;dragging=true;card.classList.add('dragging');card.setPointerCapture(e.pointerId);});
    card.addEventListener('pointermove',e=>{if(!dragging)return;dx=e.clientX-startX;card.style.transform='translateX('+dx+'px) rotate('+(dx*0.05)+'deg)';if(dx>40){hint.style.opacity='1';hintLabel.textContent='Yum!';hintLabel.style.background='#EAF3DE';hintLabel.style.color='#27500A';}else if(dx<-40){hint.style.opacity='1';hintLabel.textContent='Nah';hintLabel.style.background='#FCEBEB';hintLabel.style.color='#791F1F';}else{hint.style.opacity='0';}});
    card.addEventListener('pointerup',()=>{dragging=false;card.classList.remove('dragging');if(dx>80)swipeAway('right');else if(dx<-80)swipeAway('left');else{card.style.transform='translateX(0) rotate(0deg)';hint.style.opacity='0';}});
    </script>
    </body>
    </html>
    """
    components.html(swipe_html, height=540, scrolling=False)

elif page == "Browse Restaurants":
    st.markdown('<div class="section-title">Browse restaurants</div>', unsafe_allow_html=True)

    cities = run_query("SELECT city_id, city_name FROM CITY")
    price_tiers = run_query("SELECT price_tier_id, tier_label FROM PRICETIER")
    cuisines = run_query("SELECT cuisine_id, cuisine_name FROM CUISINE")

    city_map = {"All": None, **dict(zip(cities["city_name"], cities["city_id"]))}
    price_map = {"All": None, **dict(zip(price_tiers["tier_label"], price_tiers["price_tier_id"]))}
    cuisine_map = {"All": None, **dict(zip(cuisines["cuisine_name"], cuisines["cuisine_id"]))}

    f1, f2, f3 = st.columns(3)
    with f1:
        selected_city = st.selectbox("City", list(city_map.keys()))
    with f2:
        selected_price = st.selectbox("Price tier", list(price_map.keys()))
    with f3:
        selected_cuisine = st.selectbox("Cuisine", list(cuisine_map.keys()))

    query = """
        SELECT DISTINCT r.restaurant_id, r.restaurant_name, r.address, r.description, r.avg_rating,
               c.city_name, p.tier_label
        FROM RESTAURANT r
        JOIN CITY c ON r.city_id = c.city_id
        JOIN PRICETIER p ON r.price_tier_id = p.price_tier_id
        LEFT JOIN RESTAURANTCUISINE rc ON r.restaurant_id = rc.restaurant_id
        WHERE r.is_active = 1
    """
    params = []
    if city_map[selected_city] is not None:
        query += " AND r.city_id = %s"; params.append(city_map[selected_city])
    if price_map[selected_price] is not None:
        query += " AND r.price_tier_id = %s"; params.append(price_map[selected_price])
    if cuisine_map[selected_cuisine] is not None:
        query += " AND rc.cuisine_id = %s"; params.append(cuisine_map[selected_cuisine])

    df = run_query(query, params)
    if df.empty:
        st.info("No restaurants match those filters.")
    else:
        st.caption(f"{len(df)} restaurant(s) found")
        for _, row in df.iterrows():
            st.markdown(f"""
            <div class="fork-card">
                <div class="fork-card-title">{row['restaurant_name']}</div>
                <div class="fork-card-meta">{row['city_name']} &middot; {row['tier_label']} &middot; <span class="rating-pill">{row['avg_rating']}</span></div>
                <div class="fork-card-desc">{row['description']}</div>
                <div class="metric-pill">{row['address']}</div>
            </div>
            """, unsafe_allow_html=True)

elif page == "My Dining History":
    st.markdown('<div class="section-title">My dining history</div>', unsafe_allow_html=True)

    # --- View history ---
    history = run_query("""
        SELECT dh.history_id, r.restaurant_name, c.city_name, dh.visit_date, dh.user_rating
        FROM DININGHISTORY dh
        JOIN RESTAURANT r ON dh.restaurant_id = r.restaurant_id
        JOIN CITY c ON r.city_id = c.city_id
        WHERE dh.user_id = %s
        ORDER BY dh.visit_date DESC
    """, (uid,))

    if history.empty:
        st.info("No dining history yet.")
    else:
        st.dataframe(history[["restaurant_name", "city_name", "visit_date", "user_rating"]], use_container_width=True, hide_index=True)

    st.markdown("---")

    # --- Add a review (POST) ---
    st.markdown("##### Leave a review")
    restaurants = run_query("SELECT restaurant_id, restaurant_name FROM RESTAURANT ORDER BY restaurant_name")
    restaurant_map = dict(zip(restaurants["restaurant_name"], restaurants["restaurant_id"]))

    selected_restaurant = st.selectbox("Restaurant", list(restaurant_map.keys()))
    rating = st.slider("Rating", 1, 5, 5)
    review_text = st.text_area("Write your review", placeholder="Tell us what you liked...")

    if st.button("Submit review"):
        rid = restaurant_map[selected_restaurant]
        next_id = int(run_query("SELECT COALESCE(MAX(review_id),0)+1 AS nid FROM REVIEW").iloc[0]["nid"])
        run_action("""
            INSERT INTO REVIEW (review_id, restaurant_id, user_id, rating, review_text, review_date)
            VALUES (%s, %s, %s, %s, %s, CURDATE())
        """, (next_id, rid, uid, rating, review_text))
        st.success("Review submitted!")
        st.rerun()

    st.markdown("---")

    # --- Update preferences (PUT) ---
    st.markdown("##### Update my preferences")
    prefs = run_query("SELECT * FROM USERPREFERENCE WHERE user_id = %s", (uid,))

    current_bmin = float(prefs.iloc[0]["budget_min"]) if not prefs.empty else 10.0
    current_bmax = float(prefs.iloc[0]["budget_max"]) if not prefs.empty else 50.0
    current_radius = float(prefs.iloc[0]["mile_radius"]) if not prefs.empty else 10.0

    new_bmin = st.number_input("Budget min ($)", value=current_bmin, step=5.0)
    new_bmax = st.number_input("Budget max ($)", value=current_bmax, step=5.0)
    new_radius = st.slider("Search radius (miles)", 1.0, 50.0, current_radius)

    if st.button("Save preferences"):
        if prefs.empty:
            next_pid = int(run_query("SELECT COALESCE(MAX(preference_id),0)+1 AS nid FROM USERPREFERENCE").iloc[0]["nid"])
            run_action("""
                INSERT INTO USERPREFERENCE (preference_id, user_id, budget_min, budget_max, mile_radius, group_mode_on, updated_at)
                VALUES (%s, %s, %s, %s, %s, 0, NOW())
            """, (next_pid, uid, new_bmin, new_bmax, new_radius))
        else:
            run_action("""
                UPDATE USERPREFERENCE SET budget_min=%s, budget_max=%s, mile_radius=%s, updated_at=NOW()
                WHERE user_id=%s
            """, (new_bmin, new_bmax, new_radius, uid))
        st.success("Preferences saved!")
        st.rerun()


# =====================================================================
#  RESTAURANT OWNER PAGES
# =====================================================================
elif page == "My Restaurant":
    st.markdown('<div class="section-title">My restaurant profile</div>', unsafe_allow_html=True)

    restaurants = run_query("""
        SELECT r.restaurant_id, r.restaurant_name, r.address, r.description, r.avg_rating, r.is_active,
               c.city_name, p.tier_label
        FROM RESTAURANT r
        JOIN CITY c ON r.city_id = c.city_id
        JOIN PRICETIER p ON r.price_tier_id = p.price_tier_id
        WHERE r.owner_user_id = %s
    """, (uid,))

    if restaurants.empty:
        st.info("You don't own any restaurants.")
    else:
        selected_rest = st.selectbox("Select restaurant", restaurants["restaurant_name"].tolist())
        rest_row = restaurants[restaurants["restaurant_name"] == selected_rest].iloc[0]
        rid = int(rest_row["restaurant_id"])

        st.markdown(f"""
        <div class="fork-card">
            <div class="fork-card-title">{rest_row['restaurant_name']}</div>
            <div class="fork-card-meta">{rest_row['city_name']} &middot; {rest_row['tier_label']} &middot; <span class="rating-pill">{rest_row['avg_rating']}</span></div>
            <div class="fork-card-desc">{rest_row['description']}</div>
            <div class="metric-pill">{rest_row['address']}</div>
        </div>
        """, unsafe_allow_html=True)

        # Swipe stats
        st.markdown("##### Engagement stats")
        stats = run_query("""
            SELECT swipe_result, COUNT(*) AS count
            FROM SWIPEACTIVITY WHERE restaurant_id = %s
            GROUP BY swipe_result
        """, (rid,))
        if not stats.empty:
            stat_cols = st.columns(len(stats))
            for i, (_, srow) in enumerate(stats.iterrows()):
                with stat_cols[i]:
                    st.metric(srow["swipe_result"].capitalize(), int(srow["count"]))

        # Update restaurant description (PUT)
        st.markdown("---")
        st.markdown("##### Update description")
        new_desc = st.text_area("Description", value=rest_row["description"])
        if st.button("Update description"):
            run_action("UPDATE RESTAURANT SET description = %s WHERE restaurant_id = %s", (new_desc, rid))
            st.success("Description updated!")
            st.rerun()

elif page == "Menu & Promotions":
    st.markdown('<div class="section-title">Menu & promotions</div>', unsafe_allow_html=True)

    restaurants = run_query("SELECT restaurant_id, restaurant_name FROM RESTAURANT WHERE owner_user_id = %s", (uid,))
    if restaurants.empty:
        st.info("You don't own any restaurants.")
    else:
        selected_rest = st.selectbox("Select restaurant", restaurants["restaurant_name"].tolist())
        rid = int(restaurants[restaurants["restaurant_name"] == selected_rest].iloc[0]["restaurant_id"])

        # --- Current menu ---
        left, right = st.columns(2)

        with left:
            st.markdown("##### Current menu")
            menu = run_query("SELECT menu_item_id, item_name, price, is_available FROM MENUITEM WHERE restaurant_id = %s", (rid,))
            if menu.empty:
                st.info("No menu items yet.")
            else:
                st.dataframe(menu[["item_name", "price", "is_available"]], use_container_width=True, hide_index=True)

                # Delete menu item (DELETE)
                item_to_delete = st.selectbox("Remove a menu item", menu["item_name"].tolist())
                if st.button("Delete menu item"):
                    del_id = int(menu[menu["item_name"] == item_to_delete].iloc[0]["menu_item_id"])
                    run_action("DELETE FROM MENUITEM WHERE menu_item_id = %s", (del_id,))
                    st.success(f"'{item_to_delete}' removed!")
                    st.rerun()

        with right:
            # Add menu item (POST)
            st.markdown("##### Add menu item")
            new_item = st.text_input("Item name")
            new_item_desc = st.text_input("Item description")
            new_price = st.number_input("Price ($)", min_value=0.0, step=0.50)
            if st.button("Add item"):
                if new_item:
                    next_mid = int(run_query("SELECT COALESCE(MAX(menu_item_id),0)+1 AS nid FROM MENUITEM").iloc[0]["nid"])
                    run_action("""
                        INSERT INTO MENUITEM (menu_item_id, restaurant_id, item_name, description, price, is_available)
                        VALUES (%s, %s, %s, %s, %s, 1)
                    """, (next_mid, rid, new_item, new_item_desc, new_price))
                    st.success(f"'{new_item}' added to menu!")
                    st.rerun()

        st.markdown("---")

        # --- Promotions ---
        st.markdown("##### Active promotions")
        promos = run_query("""
            SELECT promotion_id, title, description, start_date, end_date, is_active
            FROM PROMOTION WHERE restaurant_id = %s ORDER BY start_date DESC
        """, (rid,))
        if promos.empty:
            st.info("No promotions yet.")
        else:
            st.dataframe(promos[["title", "start_date", "end_date", "is_active"]], use_container_width=True, hide_index=True)

        # Add promotion (POST)
        st.markdown("##### Create promotion")
        promo_title = st.text_input("Promotion title")
        promo_desc = st.text_input("Promotion description")
        pc1, pc2 = st.columns(2)
        with pc1:
            promo_start = st.date_input("Start date")
        with pc2:
            promo_end = st.date_input("End date")
        if st.button("Create promotion"):
            if promo_title:
                next_pid = int(run_query("SELECT COALESCE(MAX(promotion_id),0)+1 AS nid FROM PROMOTION").iloc[0]["nid"])
                run_action("""
                    INSERT INTO PROMOTION (promotion_id, restaurant_id, title, description, start_date, end_date, is_active)
                    VALUES (%s, %s, %s, %s, %s, %s, 1)
                """, (next_pid, rid, promo_title, promo_desc, promo_start, promo_end))
                st.success(f"Promotion '{promo_title}' created!")
                st.rerun()

elif page == "Reviews & Replies":
    st.markdown('<div class="section-title">Reviews & replies</div>', unsafe_allow_html=True)

    restaurants = run_query("SELECT restaurant_id, restaurant_name FROM RESTAURANT WHERE owner_user_id = %s", (uid,))
    if restaurants.empty:
        st.info("You don't own any restaurants.")
    else:
        selected_rest = st.selectbox("Select restaurant", restaurants["restaurant_name"].tolist())
        rid = int(restaurants[restaurants["restaurant_name"] == selected_rest].iloc[0]["restaurant_id"])

        reviews = run_query("""
            SELECT rv.review_id, u.first_name, u.last_name, rv.rating, rv.review_text,
                   rv.review_date, rv.owner_reply_text, rv.owner_reply_date
            FROM REVIEW rv
            JOIN `USER` u ON rv.user_id = u.user_id
            WHERE rv.restaurant_id = %s
            ORDER BY rv.review_date DESC
        """, (rid,))

        if reviews.empty:
            st.info("No reviews yet.")
        else:
            for _, rev in reviews.iterrows():
                st.markdown(f"""
                <div class="fork-card">
                    <div class="fork-card-title">{rev['first_name']} {rev['last_name']} <span class="rating-pill">{rev['rating']}/5</span></div>
                    <div class="fork-card-desc">{rev['review_text']}</div>
                    <div class="fork-card-meta">{rev['review_date']}</div>
                </div>
                """, unsafe_allow_html=True)

                if rev["owner_reply_text"]:
                    st.markdown(f"&nbsp;&nbsp;&nbsp;&nbsp;↳ **Your reply** ({rev['owner_reply_date']}): {rev['owner_reply_text']}")
                else:
                    # Reply to review (PUT)
                    with st.expander(f"Reply to {rev['first_name']}'s review"):
                        reply = st.text_area("Your reply", key=f"reply_{rev['review_id']}")
                        if st.button("Send reply", key=f"btn_reply_{rev['review_id']}"):
                            run_action("""
                                UPDATE REVIEW SET owner_reply_text = %s, owner_reply_date = CURDATE()
                                WHERE review_id = %s
                            """, (reply, int(rev["review_id"])))
                            st.success("Reply sent!")
                            st.rerun()


# =====================================================================
#  DATA ANALYST PAGES
# =====================================================================
elif page == "Ratings Dashboard":
    st.markdown('<div class="section-title">Ratings by city & cuisine</div>', unsafe_allow_html=True)

    m1, m2, m3 = st.columns(3)
    with m1:
        st.metric("Restaurants", int(run_query("SELECT COUNT(*) AS c FROM RESTAURANT").iloc[0]["c"]))
    with m2:
        st.metric("Reviews", int(run_query("SELECT COUNT(*) AS c FROM REVIEW").iloc[0]["c"]))
    with m3:
        st.metric("Menu items", int(run_query("SELECT COUNT(*) AS c FROM MENUITEM").iloc[0]["c"]))

    left, right = st.columns(2)

    with left:
        st.markdown("##### Average ratings by city and cuisine")
        ratings = run_query("""
            SELECT c.city_name, cu.cuisine_name, ROUND(AVG(r.avg_rating), 2) AS avg_rating
            FROM RESTAURANT r
            JOIN CITY c ON r.city_id = c.city_id
            JOIN RESTAURANTCUISINE rc ON r.restaurant_id = rc.restaurant_id
            JOIN CUISINE cu ON rc.cuisine_id = cu.cuisine_id
            GROUP BY c.city_name, cu.cuisine_name
            ORDER BY avg_rating DESC
        """)
        st.dataframe(ratings, use_container_width=True, hide_index=True)

    with right:
        st.markdown("##### Review volume by restaurant")
        review_counts = run_query("""
            SELECT r.restaurant_name, COUNT(rv.review_id) AS review_count
            FROM RESTAURANT r
            LEFT JOIN REVIEW rv ON r.restaurant_id = rv.restaurant_id
            GROUP BY r.restaurant_name
            ORDER BY review_count DESC LIMIT 15
        """)
        if not review_counts.empty:
            st.bar_chart(review_counts.set_index("restaurant_name"))

    st.markdown("---")
    st.markdown("##### User demographics by region")
    demos = run_query("""
        SELECT region, age_group, gender, COUNT(*) AS user_count
        FROM `USER`
        GROUP BY region, age_group, gender
        ORDER BY region, user_count DESC
    """)
    if not demos.empty:
        st.dataframe(demos, use_container_width=True, hide_index=True)

elif page == "Market Research":
    st.markdown('<div class="section-title">Market research</div>', unsafe_allow_html=True)

    st.markdown("##### Compare pricing across restaurants")

    cuisines = run_query("SELECT cuisine_id, cuisine_name FROM CUISINE")
    cities = run_query("SELECT city_id, city_name FROM CITY")

    c1, c2 = st.columns(2)
    with c1:
        sel_cuisine = st.selectbox("Filter by cuisine", ["All"] + cuisines["cuisine_name"].tolist())
    with c2:
        sel_city = st.selectbox("Filter by city", ["All"] + cities["city_name"].tolist())

    query = """
        SELECT r.restaurant_name, r.avg_rating, p.tier_label, c.city_name, cu.cuisine_name
        FROM RESTAURANT r
        JOIN CITY c ON r.city_id = c.city_id
        JOIN PRICETIER p ON r.price_tier_id = p.price_tier_id
        JOIN RESTAURANTCUISINE rc ON r.restaurant_id = rc.restaurant_id
        JOIN CUISINE cu ON rc.cuisine_id = cu.cuisine_id
        WHERE 1=1
    """
    params = []
    if sel_cuisine != "All":
        query += " AND cu.cuisine_name = %s"; params.append(sel_cuisine)
    if sel_city != "All":
        query += " AND c.city_name = %s"; params.append(sel_city)
    query += " ORDER BY r.avg_rating DESC"

    results = run_query(query, params)
    if results.empty:
        st.info("No results for those filters.")
    else:
        st.dataframe(results, use_container_width=True, hide_index=True)

    st.markdown("---")
    st.markdown("##### Swipe trends over time")
    trends = run_query("""
        SELECT DATE(activity_date) AS date, swipe_result, COUNT(*) AS count
        FROM SWIPEACTIVITY
        GROUP BY DATE(activity_date), swipe_result
        ORDER BY date
    """)
    if not trends.empty:
        pivot = trends.pivot_table(index="date", columns="swipe_result", values="count", fill_value=0)
        st.line_chart(pivot)

elif page == "Export Reports":
    st.markdown('<div class="section-title">Export reports</div>', unsafe_allow_html=True)

    st.markdown("##### Generate a report")

    cities = run_query("SELECT city_id, city_name FROM CITY")
    cuisines = run_query("SELECT cuisine_id, cuisine_name FROM CUISINE")

    city_map = dict(zip(cities["city_name"], cities["city_id"]))
    cuisine_map = dict(zip(cuisines["cuisine_name"], cuisines["cuisine_id"]))

    c1, c2, c3 = st.columns(3)
    with c1:
        rep_city = st.selectbox("City", list(city_map.keys()))
    with c2:
        rep_cuisine = st.selectbox("Cuisine", list(cuisine_map.keys()))
    with c3:
        rep_format = st.selectbox("Format", ["PDF", "CSV", "XLSX", "JSON"])

    if st.button("Generate & log report"):
        next_rid = int(run_query("SELECT COALESCE(MAX(report_id),0)+1 AS nid FROM EXPORTREPORT").iloc[0]["nid"])
        run_action("""
            INSERT INTO EXPORTREPORT (report_id, analyst_id, city_id, cuisine_id, generated_at, format)
            VALUES (%s, %s, %s, %s, NOW(), %s)
        """, (next_rid, uid, city_map[rep_city], cuisine_map[rep_cuisine], rep_format))
        st.success(f"Report #{next_rid} logged ({rep_format} for {rep_city} / {rep_cuisine})")

    st.markdown("---")
    st.markdown("##### Report history")
    reports = run_query("""
        SELECT er.report_id, c.city_name, cu.cuisine_name, er.format, er.generated_at
        FROM EXPORTREPORT er
        JOIN CITY c ON er.city_id = c.city_id
        JOIN CUISINE cu ON er.cuisine_id = cu.cuisine_id
        WHERE er.analyst_id = %s
        ORDER BY er.generated_at DESC
    """, (uid,))
    if reports.empty:
        st.info("No reports generated yet.")
    else:
        st.dataframe(reports, use_container_width=True, hide_index=True)


# =====================================================================
#  PLATFORM ADMIN PAGES
# =====================================================================
elif page == "Restaurant Submissions":
    st.markdown('<div class="section-title">Restaurant submissions</div>', unsafe_allow_html=True)

    tab1, tab2 = st.tabs(["Pending", "All Submissions"])

    with tab1:
        pending = run_query("""
            SELECT rs.submission_id, rs.restaurant_name, rs.address, rs.cuisine_summary, rs.tag_summary,
                   rs.submitted_at, u.first_name, u.last_name
            FROM RESTAURANTSUBMISSION rs
            JOIN `USER` u ON rs.submitted_by_user_id = u.user_id
            WHERE rs.status = 'pending'
            ORDER BY rs.submitted_at DESC
        """)

        if pending.empty:
            st.info("No pending submissions.")
        else:
            for _, sub in pending.iterrows():
                st.markdown(f"""
                <div class="fork-card">
                    <div class="fork-card-title">{sub['restaurant_name']}</div>
                    <div class="fork-card-meta">Submitted by {sub['first_name']} {sub['last_name']} &middot; {sub['submitted_at']}</div>
                    <div class="fork-card-desc">{sub['address']} &middot; {sub['cuisine_summary']} &middot; {sub['tag_summary']}</div>
                </div>
                """, unsafe_allow_html=True)

                ac1, ac2 = st.columns(2)
                with ac1:
                    if st.button("Approve", key=f"approve_{sub['submission_id']}"):
                        run_action("""
                            UPDATE RESTAURANTSUBMISSION SET status='approved', reviewed_by_admin_id=%s, reviewed_at=NOW()
                            WHERE submission_id=%s
                        """, (uid, int(sub["submission_id"])))
                        st.success(f"'{sub['restaurant_name']}' approved!")
                        st.rerun()
                with ac2:
                    if st.button("Reject", key=f"reject_{sub['submission_id']}"):
                        run_action("""
                            UPDATE RESTAURANTSUBMISSION SET status='rejected', reviewed_by_admin_id=%s, reviewed_at=NOW()
                            WHERE submission_id=%s
                        """, (uid, int(sub["submission_id"])))
                        st.warning(f"'{sub['restaurant_name']}' rejected.")
                        st.rerun()

    with tab2:
        all_subs = run_query("""
            SELECT rs.submission_id, rs.restaurant_name, rs.status, rs.submitted_at, rs.reviewed_at,
                   u.first_name, u.last_name
            FROM RESTAURANTSUBMISSION rs
            JOIN `USER` u ON rs.submitted_by_user_id = u.user_id
            ORDER BY rs.submitted_at DESC
        """)
        if not all_subs.empty:
            st.dataframe(all_subs, use_container_width=True, hide_index=True)

elif page == "User Complaints":
    st.markdown('<div class="section-title">User complaints</div>', unsafe_allow_html=True)

    tab1, tab2 = st.tabs(["Open / In Review", "Resolved"])

    with tab1:
        open_complaints = run_query("""
            SELECT uc.complaint_id, u.first_name, u.last_name, r.restaurant_name,
                   uc.complaint_text, uc.status, uc.created_at
            FROM USERCOMPLAINT uc
            JOIN `USER` u ON uc.user_id = u.user_id
            JOIN RESTAURANT r ON uc.restaurant_id = r.restaurant_id
            WHERE uc.status IN ('open', 'in_review')
            ORDER BY uc.created_at DESC
        """)

        if open_complaints.empty:
            st.info("No open complaints.")
        else:
            for _, comp in open_complaints.iterrows():
                st.markdown(f"""
                <div class="fork-card">
                    <div class="fork-card-title">{comp['first_name']} {comp['last_name']} → {comp['restaurant_name']}</div>
                    <div class="fork-card-desc">{comp['complaint_text']}</div>
                    <div class="fork-card-meta">Status: {comp['status']} &middot; {comp['created_at']}</div>
                </div>
                """, unsafe_allow_html=True)

                rc1, rc2 = st.columns(2)
                with rc1:
                    if comp["status"] == "open":
                        if st.button("Mark In Review", key=f"review_{comp['complaint_id']}"):
                            run_action("UPDATE USERCOMPLAINT SET status='in_review' WHERE complaint_id=%s", (int(comp["complaint_id"]),))
                            st.rerun()
                with rc2:
                    if st.button("Resolve", key=f"resolve_{comp['complaint_id']}"):
                        run_action("UPDATE USERCOMPLAINT SET status='resolved', resolved_at=NOW() WHERE complaint_id=%s", (int(comp["complaint_id"]),))
                        st.success("Complaint resolved.")
                        st.rerun()

    with tab2:
        resolved = run_query("""
            SELECT uc.complaint_id, u.first_name, u.last_name, r.restaurant_name,
                   uc.complaint_text, uc.created_at, uc.resolved_at
            FROM USERCOMPLAINT uc
            JOIN `USER` u ON uc.user_id = u.user_id
            JOIN RESTAURANT r ON uc.restaurant_id = r.restaurant_id
            WHERE uc.status = 'resolved'
            ORDER BY uc.resolved_at DESC
        """)
        if resolved.empty:
            st.info("No resolved complaints.")
        else:
            st.dataframe(resolved, use_container_width=True, hide_index=True)

elif page == "Manage Restaurants":
    st.markdown('<div class="section-title">Manage restaurants</div>', unsafe_allow_html=True)

    all_restaurants = run_query("""
        SELECT r.restaurant_id, r.restaurant_name, r.avg_rating, r.is_active,
               c.city_name, p.tier_label,
               u.first_name AS owner_first, u.last_name AS owner_last
        FROM RESTAURANT r
        JOIN CITY c ON r.city_id = c.city_id
        JOIN PRICETIER p ON r.price_tier_id = p.price_tier_id
        JOIN `USER` u ON r.owner_user_id = u.user_id
        ORDER BY r.restaurant_name
    """)

    if all_restaurants.empty:
        st.info("No restaurants in the system.")
    else:
        # Search / filter
        search = st.text_input("Search by name")
        filtered = all_restaurants
        if search:
            filtered = all_restaurants[all_restaurants["restaurant_name"].str.contains(search, case=False, na=False)]

        st.caption(f"{len(filtered)} restaurant(s)")

        for _, row in filtered.iterrows():
            active_label = "Active" if row["is_active"] else "Inactive"
            active_color = "#0F6E56" if row["is_active"] else "#A32D2D"
            st.markdown(f"""
            <div class="fork-card">
                <div class="fork-card-title">{row['restaurant_name']}</div>
                <div class="fork-card-meta">
                    {row['city_name']} &middot; {row['tier_label']} &middot;
                    <span class="rating-pill">{row['avg_rating']}</span> &middot;
                    Owner: {row['owner_first']} {row['owner_last']} &middot;
                    <span style="color:{active_color};font-weight:500;">{active_label}</span>
                </div>
            </div>
            """, unsafe_allow_html=True)

            ac1, ac2 = st.columns(2)
            with ac1:
                # Toggle active/inactive (PUT)
                toggle_label = "Deactivate" if row["is_active"] else "Reactivate"
                if st.button(toggle_label, key=f"toggle_{row['restaurant_id']}"):
                    new_status = 0 if row["is_active"] else 1
                    run_action("UPDATE RESTAURANT SET is_active = %s WHERE restaurant_id = %s",
                               (new_status, int(row["restaurant_id"])))
                    st.rerun()
            with ac2:
                # Delete restaurant (DELETE) — cascading cleanup
                if st.button("Delete", key=f"del_{row['restaurant_id']}"):
                    rid = int(row["restaurant_id"])
                    # delete dependent rows first
                    run_action("DELETE FROM GROUPRESTAURANTVOTE WHERE restaurant_id = %s", (rid,))
                    run_action("DELETE FROM DININGHISTORY WHERE restaurant_id = %s", (rid,))
                    run_action("DELETE FROM SWIPEACTIVITY WHERE restaurant_id = %s", (rid,))
                    run_action("DELETE FROM REVIEW WHERE restaurant_id = %s", (rid,))
                    run_action("DELETE FROM USERCOMPLAINT WHERE restaurant_id = %s", (rid,))
                    run_action("DELETE FROM MENUITEM WHERE restaurant_id = %s", (rid,))
                    run_action("DELETE FROM PROMOTION WHERE restaurant_id = %s", (rid,))
                    run_action("DELETE FROM RESTAURANTTAG WHERE restaurant_id = %s", (rid,))
                    run_action("DELETE FROM RESTAURANTCUISINE WHERE restaurant_id = %s", (rid,))
                    run_action("DELETE FROM RESTAURANT WHERE restaurant_id = %s", (rid,))
                    st.success(f"'{row['restaurant_name']}' deleted.")
                    st.rerun()
