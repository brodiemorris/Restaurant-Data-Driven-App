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

Fork It uses a role-based access control (RBAC) system. On the home screen, select your role to access the role's page to access key features:

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

## Getting started

Ensure you have the following installed:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Git](https://git-scm.com/)
- [Anaconda](https://www.anaconda.com/download) or [Miniconda](https://www.anaconda.com/docs/getting-started/miniconda/install)

---

### 1. Clone the Repository

```bash
git clone https://github.com/brodiemorris/Restaurant-Data-Driven-App
cd Restaurant-Data-Driven-App
```

### 2. Set Up Your Python Environment

```bash
conda create -n db-proj python=3.11
conda activate db-proj

cd api
pip install -r requirements.txt

cd ../app/src
pip install -r requirements.txt
```

### 3. Configure Environment Variables

In the `api/` folder, create a `.env` file based on the provided template:

```bash
cp api/.env.template api/.env
```

### 4. Set Up Docker Password

In line 290 of the `.env` file, change "ForkIt$123" to your personal docker password, run a mySql instance on docker.

### 5. Start the Docker Containers

From the root of the repository, run:

```bash
docker compose up -d
```

This will spin up three containers:
- **db** — MySQL database (auto-initialized from `./database-files`)
- **api** — Flask REST API
- **app** — Streamlit frontend

To stop the containers:

```bash
docker compose stop
```

To fully shut down and remove the containers:

```bash
docker compose down
```

### 6. Open the App

Once the containers are running, open your browser and go to:

```
http://localhost:8501
```

## Resetting the Database

If you make changes to any SQL files in `./database-files`, you must recreate the MySQL container for them to take effect:

```bash
docker compose down db -v && docker compose up db -d
```

> **Note:** The SQL files in `./database-files` are executed in **alphabetical order** on first startup.

---

## Project Structure

| Path | Description |
|------|-------------|
| `app/src/Home.py` | Landing page with role selection |
| `app/src/pages/` | Role-based Streamlit pages |
| `app/src/modules/nav.py` | Sidebar navigation logic by role |
| `api/backend/` | Flask route handlers organized by persona |
| `api/requirements.txt` | Python dependencies for the API |
| `database-files/` | SQL DDL and seed data scripts |
| `datasets/` | Raw datasets used for mock data generation |
| `ml-src/` | (Optional) ML model development |
| `docker-compose.yaml` | Docker container orchestration config |

---

## GitHub Repository

[https://github.com/brodiemorris/Restaurant-Data-Driven-App](https://github.com/brodiemorris/Restaurant-Data-Driven-App)
