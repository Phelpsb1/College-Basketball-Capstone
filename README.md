# College-Basketball-Capstone
College-Basketball-Capstone
4/6
Worked on project proposal and finally landed on a good idea with data we already found to back it up. Came up with what models we are going to build and how we we're going to support evidence found. Worked on pulling data from the API and setting up our main branch, struggled with the API key and deleting the history of the github to protect the key. 
4/8
Ended up just deleting the whole repo and making a new one was easier so we took that method to fix our problem. Working on pulling data from the API and cleaning up the code we already had. 4/13
working on pulling all the data and getting it cleaned, fixed the issue with the march madness API
The goals for the near future is to fully finish cleaning the data and create an engine.
FINAL Capstone: Basketball Analytics
Scenario
We are curious of the competitiveness of the college NCAA basketball league. We want to look at elo rating, wins above bubble, and final marchmadness placements to see how they compare over the years. We believe that the gap will increase and less underdogs will be winning throughout the years since the gap has seemingly become bigger.
4/12
worked more on trying to fix WAB thinking about ideas that we want to use for showing our theory for presentation.
4/15
worked more on calculating WAB got a bit closer with no more errors but the played games are thrown off so the expected wins are thrown off causing WAB to be inaccurate, Worked a bit on trying to pull from the excel files. Couldn't get any information off the excel files for some reason.
4/19
Kept working on getting WAB and changed all Excels to CSV's to pull it easier and clean it easier. Worked on cleaning all the CSV's since they all have similar variables but they were labeled differently. After cleaning CSV's cleanly put them all together with the year they were pulled from in the first column, changed the name to combined csv I did this so it would be easier to pull from but I don't think it was really needed. 
4/20
Kept troubleshooting WAB
4/21

Goals to work on til project is done.
Calculate WAB
Make a Clean Table
Create Engine to transfer data to docker
Create tables for datagrip
Build visuals with Q1 wins, WAB, maybe SOS, or AvgOPPNETRANK
Start Presentation

What You Will Build
EXCELS + API  →  pandas (EDA + clean)  →  PostgreSQL  →  SQL (normalize + analytics)  →  Metabase
We are going to build mutiple visual graphs that will either disprove or support our data. 

Setup
1. Start the Docker Stack
From the docker/ folder, bring up PostgreSQL and Metabase:

cd docker
docker compose up -d
This starts two containers:

capstone_postgres — PostgreSQL on port 5432
capstone_metabase — Metabase on port 3000
Wait about 30 seconds for Metabase to finish starting, then open http://localhost:3000 to confirm it loads.

Docker Shortcuts
To stop the stack when you're done: docker compose down To stop and delete all data: docker compose down -v

2. Python Virtual Environment Shortcut
python3 -m venv .venv
source .venv/bin/activate          # MAC
.venv\Scripts\activate             # WINDOWS
pip install -r requirements.txt
Step-by-Step Workflow
Step 1 — Complete the Jupyter Notebook
Run every cell in order. Fill in the cells marked # YOUR CODE HERE:

Part	What you do
Part 1	Load all of our excels; fetch data from the College-Basketball API
Part 2	EDA — explore both DataFrames: shape, dtypes, nulls, duplicates, value counts
Part 3	Clean both DataFrames (see data quality issues above)
Part 4	Write the cleaned DataFrames to PostgreSQL with pd.to_sql()
Step 2 — Connect DataGrip to PostgreSQL
Open DataGrip → New Data Source → PostgreSQL
Enter the connection details:
Field	Value
Host	localhost
Port	5432
Database	postgres
User	postgres
Password	postgres
Click Test Connection → you should see a green checkmark
Click Apply / OK
Step 3 — Run analytics.sql in DataGrip
Open analytics.sql in DataGrip and work through each step one statement at a time (place your cursor inside a statement and press Ctrl+Enter):

Step	What it does
Step 1	Verify row counts in both tables
Step 2	Preview both tables
Step 3a	Create dim_agency (given as example)
Step 3b	Create dim_site — your code
Step 3c	Create fact_launches — your code
Step 3d	Spot-check the normalization
Step 4	Write at least 3 analytics queries of your choice (see prompt list in the file)
Step 4 — Build a Metabase Dashboard
Metabase is already running at http://localhost:3000.

First-time setup (one time only):

Complete the Metabase welcome wizard
When asked to add a database, choose PostgreSQL and enter:
Field	Value
Host	host.docker.internal
Port	5432
Database	postgres
Username	postgres
Password	postgres
Build your dashboard:

Click + New → Dashboard, give it a name
Add questions (charts) using + New → Question
Choose the postgres database and pick one of your analytics tables
Select a visualization type and justify your choice in your submission
Project File Structure
Final-capstone/
├── basketball.ipynb      Main file
├── analytics.sql         SQL file (run in DataGrip)
├── requirements.txt      Python dependencies
├── keys.json             (Storing API_Key)Needed for pulling API 
├── DAT400 Project Proposal.docx    Project Proposal(ignore)
├── .gitignore            (git ignore)
├── data/
│   └── NCAA Statistics 2020.xlsx  -Excel files for data
    └── NCAA Statistics 2021.xlsx
    └── NCAA Statistics 2022.xlsx
    └── NCAA Statistics 2023.xlsx
    └── NCAA Statistics 2024.xlsx
    └── NCAA Statistics 2025.xlsx
    └── NCAA Statistics 2026.xlsx
└── docker/
    └── docker-compose.yml ← Defines Postgres + Metabase containers