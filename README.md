# Fork It 🍴

> **Stop debating, start eating.**

Fork It is a data-driven dining app that allows users to decide where to eat by swiping and indicating their food preferences. Instead of endlessly scrolling through Yelp or Google Maps and debating in group chats, users answer a few swipe-based questions and instantly receive a personalized restaurant recommendation.

---

## Team

- Brodie Morris
- Beach Swanson
- Anna Aderhold
- Kittirat Trakulsujaritchok
- Abhinav Chaudhry

---

## About the App

Fork It is built for four main user personas:

- **Casual Diners** (ex. Edgar Riley) — Swipe through food prompts to get a single, personalized restaurant recommendation in seconds
- **Restaurant Owners** (ex. John Pork) — Manage your restaurant profile, menu, tags, and promotions all in one place
- **Data Analysts** (ex. Walter White) — Explore dining trends, pricing comparisons, and cuisine performance across cities
- **Platform Admins** (ex. Zara Larson) — Approve restaurant submissions, resolve user complaints, and manage platform integrity

---

### User Roles

Fork It uses a role-based access control (RBAC) system. On the home screen, select your role to access key features:

| Role | Description |
|------|-------------|
| 🍽️ Casual Diner | Swipe for recommendations, manage preferences, view dining history |
| 🏪 Restaurant Owner | Manage profile, menu, tags, promotions, and reviews |
| 📊 Data Analyst | Explore dashboards, trends, pricing, and export reports |
| 🛠️ Platform Admin | Approve submissions, resolve complaints, manage restaurants |

---

## Project Layering

- **Frontend** — [Streamlit](https://streamlit.io/)
- **Backend / API** — [Python Flask](https://flask.palletsprojects.com/)
- **Database** — MySQL
- **Infrastructure** — Docker + Docker Compose

---

## Getting Started

The only thing you need installed is:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Git](https://git-scm.com/)

> **Note:** You do NOT need Anaconda, Miniconda, or a local Python environment. Everything runs inside Docker.

---

### 1. Clone the Repository

```bash
git clone https://github.com/brodiemorris/Restaurant-Data-Driven-App
cd Restaurant-Data-Driven-App
```

---

### 2. Configure Environment Variables

Copy the `.env` template:

```bash
# Mac/Linux
cp api/.env.template api/.env

# Windows PowerShell
Copy-Item api/.env.template api/.env
```

Open `api/.env` in a text editor (Notepad, VS Code, etc). It will look like this:

```env
SECRET_KEY=supersecretkey123
DB_USER=root
DB_HOST=db
DB_PORT=3306
DB_NAME=forkit
MYSQL_ROOT_PASSWORD=ForkIt$123
```

**Important:** The `MYSQL_ROOT_PASSWORD` in your `.env` must match the `password` value hardcoded in `app/src/forkit_app.py` (around line 290). By default both are set to `ForkIt$123` — leave them matching unless you change both at the same time.

> **Windows users:** Do not use `echo` or `>>` to edit files in PowerShell — it will corrupt them with UTF-16 encoding. Always use a text editor or `Copy-Item`.

---

### 3. Start the Docker Containers

From the root of the repository, run:

```bash
docker compose up
```

This will spin up three containers:
- **db** — MySQL database (auto-initialized from `./database-files`)
- **api** — Flask REST API on port `4000`
- **app** — Streamlit frontend on port `8501`

The app and api containers will wait for MySQL to pass a health check before starting. MySQL initialization (including seeding) takes roughly 15–20 seconds on first run.

To run in the background:

```bash
docker compose up -d
```

To stop containers:

```bash
docker compose stop
```

To fully shut down and remove containers:

```bash
docker compose down
```

---

### 4. Open the App

Once the containers are running, open your browser and go to:

```
http://localhost:8501
```

---

## Troubleshooting

**App can't connect to MySQL (`Connection refused` or `Name or service not known`)**
MySQL takes time to initialize on first run. If the app crashes before MySQL is ready, restart it:
```bash
docker compose restart app
```

**Access denied for user 'root'**
The password in `app/src/forkit_app.py` doesn't match `MYSQL_ROOT_PASSWORD` in `api/.env`. Make sure both are identical, then wipe the volume and restart:
```bash
docker compose down -v
docker compose up
```

**Port already in use**
If something is already running on port `8501`, `4000`, or `3200`, edit the left-hand port numbers in `docker-compose.yaml` (e.g. change `8501:8501` to `8502:8501`).

**Windows: requirements.txt corruption**
If you see errors like `Invalid requirement: 'm\x00y\x00s\x00q\x00l...'` during build, your `requirements.txt` was saved as UTF-16. Fix it with:
```powershell
python3 -c "open('app/src/requirements.txt', 'w', encoding='utf-8').write(open('app/src/requirements.txt', 'r', encoding='utf-16').read())"
```

---

## Resetting the Database

If you make changes to any SQL files in `./database-files`, wipe the volume and restart:

```bash
docker compose down -v
docker compose up
```

> **Note:** The SQL files in `./database-files` are executed in **alphabetical order** on first startup.

---

## Project Structure

| Path | Description |
|------|-------------|
| `app/src/forkit_app.py` | Main Streamlit app entry point |
| `app/src/pages/` | Role-based Streamlit pages |
| `app/src/modules/nav.py` | Sidebar navigation logic by role |
| `api/backend/` | Flask route handlers organized by persona |
| `api/requirements.txt` | Python dependencies for the API |
| `app/src/requirements.txt` | Python dependencies for the Streamlit app |
| `database-files/` | SQL DDL and seed data scripts |
| `datasets/` | Raw datasets used for mock data generation |
| `ml-src/` | (Optional) ML model development |
| `docker-compose.yaml` | Docker container orchestration config |

---

## GitHub Repository

https://github.com/brodiemorris/Restaurant-Data-Driven-App