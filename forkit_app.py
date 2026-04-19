import streamlit as st
import pandas as pd
import mysql.connector
from PIL import Image

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
</style>
""", unsafe_allow_html=True)

# ---------- DATA ----------
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

# ---------- HEADER ----------
FORK_SVG = '<svg width="28" height="28" viewBox="0 0 44 180" fill="none" xmlns="http://www.w3.org/2000/svg"><line x1="4" y1="0" x2="4" y2="58" stroke="#D85A30" stroke-width="3.5" stroke-linecap="round"/><line x1="16" y1="0" x2="16" y2="58" stroke="#D85A30" stroke-width="3.5" stroke-linecap="round"/><line x1="28" y1="0" x2="28" y2="58" stroke="#D85A30" stroke-width="3.5" stroke-linecap="round"/><line x1="40" y1="0" x2="40" y2="58" stroke="#D85A30" stroke-width="3.5" stroke-linecap="round"/><path d="M 4,58 Q 4,72 22,72 Q 40,72 40,58" fill="none" stroke="#D85A30" stroke-width="3.5" stroke-linecap="round"/><line x1="22" y1="72" x2="22" y2="170" stroke="#D85A30" stroke-width="3.5" stroke-linecap="round"/></svg>'

col_logo, col_head = st.columns([1, 8])
with col_logo:
    st.markdown(FORK_SVG, unsafe_allow_html=True)
with col_head:
    st.markdown('<p style="font-size:1.6rem;font-weight:600;color:#1a1a18;letter-spacing:-0.5px;margin:0;">fork-<span style="color:#D85A30;">it</span></p>', unsafe_allow_html=True)
    st.markdown('<p style="font-size:0.85rem;color:#73726c;margin:0;">Stop debating, start eating.</p>', unsafe_allow_html=True)

st.markdown('<hr style="border:none;border-top:0.5px solid rgba(0,0,0,0.08);margin:0.4rem 0 0.8rem 0;">', unsafe_allow_html=True)

# ---------- SIDEBAR ----------
st.sidebar.markdown(FORK_SVG, unsafe_allow_html=True)
st.sidebar.markdown('<p style="font-size:1rem;font-weight:600;color:#1a1a18;letter-spacing:-0.3px;margin:0 0 0.8rem 0;">fork-<span style="color:#D85A30;">it</span></p>', unsafe_allow_html=True)

page = st.sidebar.radio(
    "Navigate",
    ["Swipe & Discover", "Browse Restaurants", "Restaurant Details", "Add Review", "Analytics Dashboard"]
)

# ---------- PAGE 0: SWIPE ----------
if page == "Swipe & Discover":
    st.markdown('<div class="section-title">What are you in the mood for?</div>', unsafe_allow_html=True)
    st.caption("Swipe right if it sounds good, left if it doesn't. We'll find your perfect spot.")

    import streamlit.components.v1 as components

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
            border-radius: 16px;
            border: 1px solid #e8e7e4;
            background: #fff;
            display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 14px;
            cursor: grab; user-select: none;
            transition: transform 0.35s ease, opacity 0.35s ease;
            position: absolute; top: 0; left: 0;
        }
        .card.dragging { transition: none; cursor: grabbing; }

        .icon-circle { width: 72px; height: 72px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 32px; }
        .card-q { font-size: 22px; font-weight: 600; color: #1a1a18; text-align: center; padding: 0 24px; line-height: 1.3; }
        .card-sub { font-size: 13px; color: #73726c; }

        .hint {
            position: absolute; top: 14px; left: 0; right: 0;
            display: flex; justify-content: center;
            opacity: 0; transition: opacity 0.15s; pointer-events: none;
        }
        .hint-label { font-size: 13px; font-weight: 600; padding: 5px 16px; border-radius: 20px; }

        .buttons { display: flex; justify-content: center; align-items: center; gap: 20px; margin-top: 18px; }
        .btn-circle {
            width: 54px; height: 54px; border-radius: 50%;
            border: 2px solid; background: #fff;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; transition: transform 0.1s;
        }
        .btn-circle:active { transform: scale(0.93); }
        .btn-no { border-color: #F09595; }
        .btn-skip { border-color: #d3d1c7; width: 42px; height: 42px; font-size: 14px; font-weight: 600; color: #73726c; }
        .btn-yes { border-color: #97C459; }

        .result-box {
            width: 320px; min-height: 380px;
            border-radius: 16px; border: 2px solid #D85A30;
            background: #fff; padding: 28px 24px;
            display: none; flex-direction: column; align-items: center; justify-content: center; gap: 14px; text-align: center;
        }
        .result-box .icon-circle { width: 80px; height: 80px; font-size: 36px; background: #FAECE7; }
        .result-title { font-size: 14px; color: #73726c; font-weight: 500; letter-spacing: 0.5px; }
        .result-name { font-size: 24px; font-weight: 700; color: #1a1a18; line-height: 1.2; }
        .result-meta { font-size: 14px; color: #73726c; }
        .result-desc { font-size: 14px; color: #3d3d3a; line-height: 1.5; }
        .result-btn {
            margin-top: 8px; padding: 12px 28px;
            background: #D85A30; color: #fff;
            border: none; border-radius: 12px;
            font-size: 15px; font-weight: 600; cursor: pointer;
        }
        .result-btn:hover { background: #c04e28; }
        .retry-btn {
            padding: 10px 24px; background: #fff; color: #1a1a18;
            border: 1px solid #e8e7e4; border-radius: 12px;
            font-size: 14px; font-weight: 500; cursor: pointer;
        }
    </style>
    </head>
    <body>

    <div class="progress">
        <span id="counter">1 of 8</span>
        <div class="bar-bg"><div class="bar-fill" id="bar" style="width:12.5%"></div></div>
    </div>

    <div class="card-area" id="card-area">
        <div class="card" id="card">
            <div class="hint" id="hint">
                <span class="hint-label" id="hint-label"></span>
            </div>
            <div class="icon-circle" id="card-icon" style="background:#FAEEDA;">🍝</div>
            <div class="card-q" id="card-q">In the mood for Italian?</div>
            <div class="card-sub" id="card-sub">Pasta, pizza, risotto...</div>
        </div>
    </div>

    <div class="buttons" id="buttons">
        <div class="btn-circle btn-no" onclick="swipeAway('left')">
            <svg width="20" height="20" viewBox="0 0 20 20" fill="none"><line x1="5" y1="5" x2="15" y2="15" stroke="#E24B4A" stroke-width="2.5" stroke-linecap="round"/><line x1="15" y1="5" x2="5" y2="15" stroke="#E24B4A" stroke-width="2.5" stroke-linecap="round"/></svg>
        </div>
        <div class="btn-circle btn-skip" onclick="swipeAway('skip')">?</div>
        <div class="btn-circle btn-yes" onclick="swipeAway('right')">
            <svg width="20" height="20" viewBox="0 0 20 20" fill="none"><polyline points="4,11 8,16 16,5" stroke="#639922" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" fill="none"/></svg>
        </div>
    </div>

    <div class="result-box" id="result">
        <div class="result-title">FORK-IT SAYS</div>
        <div class="icon-circle">🍽️</div>
        <div class="result-name" id="res-name">Pasta Corner</div>
        <div class="result-meta" id="res-meta">Boston · $ · 4.2</div>
        <div class="result-desc" id="res-desc">Homestyle pasta and Italian comfort food on Newbury St.</div>
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
        { name: "Pasta Corner", meta: "Boston · $ · 4.2", desc: "Homestyle pasta and Italian comfort food on Newbury St.", tags: ["italian", "pizza"] },
        { name: "Bangkok Bites", meta: "Boston · $ · 4.5", desc: "Casual Thai street food and noodles on Boylston.", tags: ["spicy", "healthy"] },
        { name: "Sakura House", meta: "New York · $$ · 4.8", desc: "Upscale sushi and Japanese small plates on Broadway.", tags: ["japanese", "healthy"] },
        { name: "Taco Spot", meta: "New York · $ · 4.1", desc: "Fast casual tacos and burritos on 5th Ave.", tags: ["mexican", "spicy"] },
    ];

    let idx = 0;
    let likes = [];
    const card = document.getElementById('card');
    const hint = document.getElementById('hint');
    const hintLabel = document.getElementById('hint-label');
    let startX = 0, dx = 0, dragging = false;

    function updateCard() {
        const p = prompts[idx];
        document.getElementById('card-q').textContent = p.q;
        document.getElementById('card-sub').textContent = p.sub;
        document.getElementById('card-icon').textContent = p.icon;
        document.getElementById('card-icon').style.background = p.bg;
        document.getElementById('counter').textContent = (idx + 1) + ' of ' + prompts.length;
        document.getElementById('bar').style.width = (((idx + 1) / prompts.length) * 100) + '%';
        card.style.transform = 'translateX(0) rotate(0deg)';
        card.style.opacity = '1';
        hint.style.opacity = '0';
        card.classList.remove('dragging');
    }

    function showResult() {
        let best = null, bestScore = -1;
        restaurants.forEach(r => {
            let score = r.tags.filter(t => likes.includes(t)).length;
            if (score > bestScore) { bestScore = score; best = r; }
        });
        if (!best) best = restaurants[0];
        document.getElementById('res-name').textContent = best.name;
        document.getElementById('res-meta').textContent = best.meta;
        document.getElementById('res-desc').textContent = best.desc;
        document.getElementById('card-area').style.display = 'none';
        document.getElementById('buttons').style.display = 'none';
        document.querySelector('.progress').style.display = 'none';
        document.getElementById('result').style.display = 'flex';
    }

    function swipeAway(dir) {
        if (dir === 'right') likes.push(prompts[idx].tag);
        const tx = dir === 'left' ? -400 : dir === 'right' ? 400 : 0;
        const rot = dir === 'left' ? -15 : dir === 'right' ? 15 : 0;
        card.classList.remove('dragging');
        card.style.transform = 'translateX(' + tx + 'px) rotate(' + rot + 'deg)';
        card.style.opacity = '0';
        setTimeout(() => {
            idx++;
            if (idx >= prompts.length) { showResult(); return; }
            card.style.transition = 'none';
            card.style.transform = 'translateX(0) rotate(0deg)';
            setTimeout(() => {
                card.style.transition = 'transform 0.35s ease, opacity 0.35s ease';
                updateCard();
            }, 30);
        }, 350);
    }

    function restart() {
        idx = 0; likes = [];
        document.getElementById('card-area').style.display = 'flex';
        document.getElementById('buttons').style.display = 'flex';
        document.querySelector('.progress').style.display = 'flex';
        document.getElementById('result').style.display = 'none';
        updateCard();
    }

    card.addEventListener('pointerdown', e => {
        startX = e.clientX; dx = 0; dragging = true;
        card.classList.add('dragging');
        card.setPointerCapture(e.pointerId);
    });
    card.addEventListener('pointermove', e => {
        if (!dragging) return;
        dx = e.clientX - startX;
        card.style.transform = 'translateX(' + dx + 'px) rotate(' + (dx * 0.05) + 'deg)';
        if (dx > 40) { hint.style.opacity = '1'; hintLabel.textContent = 'Yum!'; hintLabel.style.background = '#EAF3DE'; hintLabel.style.color = '#27500A'; }
        else if (dx < -40) { hint.style.opacity = '1'; hintLabel.textContent = 'Nah'; hintLabel.style.background = '#FCEBEB'; hintLabel.style.color = '#791F1F'; }
        else { hint.style.opacity = '0'; }
    });
    card.addEventListener('pointerup', () => {
        dragging = false;
        card.classList.remove('dragging');
        if (dx > 80) swipeAway('right');
        else if (dx < -80) swipeAway('left');
        else { card.style.transform = 'translateX(0) rotate(0deg)'; hint.style.opacity = '0'; }
    });
    </script>
    </body>
    </html>
    """

    components.html(swipe_html, height=540, scrolling=False)

# ---------- PAGE 1 ----------
elif page == "Browse Restaurants":
    st.markdown('<div class="section-title">Browse restaurants</div>', unsafe_allow_html=True)

    cities = run_query("SELECT city_id, city_name FROM CITY")
    price_tiers = run_query("SELECT price_tier_id, tier_label FROM PRICETIER")
    cuisines = run_query("SELECT cuisine_id, cuisine_name FROM CUISINE")

    city_map = {"All": None, **dict(zip(cities["city_name"], cities["city_id"]))}
    price_map = {"All": None, **dict(zip(price_tiers["tier_label"], price_tiers["price_tier_id"]))}
    cuisine_map = {"All": None, **dict(zip(cuisines["cuisine_name"], cuisines["cuisine_id"]))}

    filter1, filter2, filter3 = st.columns(3)
    with filter1:
        selected_city = st.selectbox("City", list(city_map.keys()))
    with filter2:
        selected_price = st.selectbox("Price tier", list(price_map.keys()))
    with filter3:
        selected_cuisine = st.selectbox("Cuisine", list(cuisine_map.keys()))

    query = """
        SELECT DISTINCT
            r.restaurant_id,
            r.restaurant_name,
            r.address,
            r.description,
            r.avg_rating,
            c.city_name,
            p.tier_label
        FROM RESTAURANT r
        JOIN CITY c ON r.city_id = c.city_id
        JOIN PRICETIER p ON r.price_tier_id = p.price_tier_id
        LEFT JOIN RESTAURANTCUISINE rc ON r.restaurant_id = rc.restaurant_id
        WHERE 1=1
    """
    params = []

    if city_map[selected_city] is not None:
        query += " AND r.city_id = %s"
        params.append(city_map[selected_city])

    if price_map[selected_price] is not None:
        query += " AND r.price_tier_id = %s"
        params.append(price_map[selected_price])

    if cuisine_map[selected_cuisine] is not None:
        query += " AND rc.cuisine_id = %s"
        params.append(cuisine_map[selected_cuisine])

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

# ---------- PAGE 2 ----------
elif page == "Restaurant Details":
    st.markdown('<div class="section-title">Restaurant details</div>', unsafe_allow_html=True)

    restaurants = run_query("SELECT restaurant_id, restaurant_name FROM RESTAURANT ORDER BY restaurant_name")
    restaurant_map = dict(zip(restaurants["restaurant_name"], restaurants["restaurant_id"]))

    selected_restaurant = st.selectbox("Select a restaurant", list(restaurant_map.keys()))
    restaurant_id = restaurant_map[selected_restaurant]

    details = run_query("""
        SELECT
            r.restaurant_name,
            r.address,
            r.description,
            r.avg_rating,
            c.city_name,
            p.tier_label
        FROM RESTAURANT r
        JOIN CITY c ON r.city_id = c.city_id
        JOIN PRICETIER p ON r.price_tier_id = p.price_tier_id
        WHERE r.restaurant_id = %s
    """, (restaurant_id,))

    menu = run_query("""
        SELECT item_name, description, price, is_available
        FROM MENUITEM
        WHERE restaurant_id = %s
    """, (restaurant_id,))

    reviews = run_query("""
        SELECT
            u.first_name,
            u.last_name,
            rv.rating,
            rv.review_text,
            rv.review_date
        FROM REVIEW rv
        JOIN USER u ON rv.user_id = u.user_id
        WHERE rv.restaurant_id = %s
    """, (restaurant_id,))

    if not details.empty:
        row = details.iloc[0]
        st.markdown(f"""
        <div class="fork-card">
            <div class="fork-card-title">{row['restaurant_name']}</div>
            <div class="fork-card-meta">{row['city_name']} &middot; {row['tier_label']} &middot; <span class="rating-pill">{row['avg_rating']}</span></div>
            <div class="fork-card-desc">{row['description']}</div>
            <div class="metric-pill">{row['address']}</div>
        </div>
        """, unsafe_allow_html=True)

    left, right = st.columns([1.15, 1])

    with left:
        st.markdown('<div class="mini-box">', unsafe_allow_html=True)
        st.markdown("#### Menu")
        if menu.empty:
            st.write("No menu items available.")
        else:
            for _, item in menu.iterrows():
                avail_color = "#0F6E56" if item["is_available"] else "#A32D2D"
                avail_text = "Available" if item["is_available"] else "Unavailable"
                st.markdown(f"""
                **{item['item_name']}** — ${item['price']:.2f}
                {item['description']}
                <span style="color:{avail_color}; font-size:0.82rem; font-weight:500;">{avail_text}</span>
                """, unsafe_allow_html=True)
                st.markdown("---")
        st.markdown('</div>', unsafe_allow_html=True)

    with right:
        st.markdown('<div class="mini-box">', unsafe_allow_html=True)
        st.markdown("#### Reviews")
        if reviews.empty:
            st.write("No reviews yet.")
        else:
            for _, review in reviews.iterrows():
                st.markdown(f"""
                <div style="margin-bottom:0.6rem;">
                    <span style="font-weight:600;color:#1a1a18;">{review['first_name']} {review['last_name']}</span>
                    <span class="rating-pill" style="margin-left:6px;">{review['rating']}</span>
                    <div style="color:#3d3d3a;font-size:0.88rem;margin-top:4px;line-height:1.5;">{review['review_text']}</div>
                    <div style="color:#73726c;font-size:0.78rem;margin-top:4px;">{review['review_date']}</div>
                </div>
                """, unsafe_allow_html=True)
                st.markdown("---")
        st.markdown('</div>', unsafe_allow_html=True)

# ---------- PAGE 3 ----------
elif page == "Add Review":
    st.markdown('<div class="section-title">Add a review</div>', unsafe_allow_html=True)

    restaurants = run_query("SELECT restaurant_id, restaurant_name FROM RESTAURANT ORDER BY restaurant_name")
    restaurant_map = dict(zip(restaurants["restaurant_name"], restaurants["restaurant_id"]))

    st.markdown('<div class="mini-box">', unsafe_allow_html=True)

    selected_restaurant = st.selectbox("Restaurant", list(restaurant_map.keys()))
    restaurant_id = restaurant_map[selected_restaurant]

    user_id = st.number_input("User ID", min_value=1, step=1, value=1)
    rating = st.slider("Rating", 1, 5, 5)
    review_text = st.text_area("Write your review", placeholder="Tell us what you liked...")

    if st.button("Submit review"):
        next_id_df = run_query("SELECT COALESCE(MAX(review_id), 0) + 1 AS next_id FROM REVIEW")
        next_id = int(next_id_df.loc[0, "next_id"])

        run_action("""
            INSERT INTO REVIEW (review_id, restaurant_id, user_id, rating, review_text, review_date, owner_reply_text, owner_reply_date)
            VALUES (%s, %s, %s, %s, %s, CURDATE(), NULL, NULL)
        """, (next_id, restaurant_id, user_id, rating, review_text))

        st.success("Review submitted successfully!")
        st.rerun()

    st.markdown('</div>', unsafe_allow_html=True)

# ---------- PAGE 4 ----------
elif page == "Analytics Dashboard":
    st.markdown('<div class="section-title">Analytics dashboard</div>', unsafe_allow_html=True)

    ratings = run_query("""
        SELECT
            c.city_name,
            cu.cuisine_name,
            ROUND(AVG(r.avg_rating), 2) AS avg_restaurant_rating
        FROM RESTAURANT r
        JOIN CITY c ON r.city_id = c.city_id
        JOIN RESTAURANTCUISINE rc ON r.restaurant_id = rc.restaurant_id
        JOIN CUISINE cu ON rc.cuisine_id = cu.cuisine_id
        GROUP BY c.city_name, cu.cuisine_name
        ORDER BY avg_restaurant_rating DESC
    """)

    review_counts = run_query("""
        SELECT
            r.restaurant_name,
            COUNT(rv.review_id) AS review_count
        FROM RESTAURANT r
        LEFT JOIN REVIEW rv ON r.restaurant_id = rv.restaurant_id
        GROUP BY r.restaurant_name
        ORDER BY review_count DESC
    """)

    metric1, metric2, metric3 = st.columns(3)
    with metric1:
        st.metric("Restaurants", int(run_query("SELECT COUNT(*) AS count FROM RESTAURANT").iloc[0]["count"]))
    with metric2:
        st.metric("Reviews", int(run_query("SELECT COUNT(*) AS count FROM REVIEW").iloc[0]["count"]))
    with metric3:
        st.metric("Menu items", int(run_query("SELECT COUNT(*) AS count FROM MENUITEM").iloc[0]["count"]))

    left, right = st.columns(2)

    with left:
        st.markdown('<div class="mini-box">', unsafe_allow_html=True)
        st.markdown("#### Average ratings by city and cuisine")
        st.dataframe(ratings, use_container_width=True, hide_index=True)
        st.markdown('</div>', unsafe_allow_html=True)

    with right:
        st.markdown('<div class="mini-box">', unsafe_allow_html=True)
        st.markdown("#### Review volume by restaurant")
        if not review_counts.empty:
            st.bar_chart(review_counts.set_index("restaurant_name"))
        st.markdown('</div>', unsafe_allow_html=True)