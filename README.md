# Skin-Cancer-Diagnosis-with-SQL
# Project Overview
Skin cancer is one of the most common yet preventable cancers worldwide. Early detection significantly improves survival rates, but diagnosis is often delayed due to misdiagnosis, lack of access to dermatologists, and limited awareness of risk factors. As a data Sxientist, I utilised SQL-based analysis to structure, explore, and analyse a clinical dataset of 1,088 skin lesion cases. I integrated patient demographics, environmental exposures, and lesion characteristics to analyse the dataset incoporating fare patterns and other factors needed to optimise the dataset operations and make data-driven descisions that support early diagnosis, cancer detection and timely treatmnt.

## Objectives
•	Build a SQL database integrating clinical (Patient_Info) and lesion-level (Lesion_Info) data.
•	Explore demographic and environmental risk factors linked to skin cancer incidence.
•	Identify lesion characteristics that distinguish benign vs. malignant lesions.
•	Generate a machine learning–ready dataset for future AI-based classification models.
•	Provide query-based insights to support dermatology and epidemiological studies.

## Dataset Description
Table 1: Patient_Info
Column	Description
patient_id	Unique identifier for each patient
smoke	Patient smokes (TRUE/FALSE)
drink	Patient drinks alcohol (TRUE/FALSE)
background_father	Paternal ethnicity
background_mother	Maternal ethnicity
age	Age of patient
pesticide	Exposure to pesticides (TRUE/FALSE)
gender	Gender (MALE/FEMALE)
skin_cancer_history	Previous skin cancer diagnosis
cancer_history	Family history of cancer
has_piped_water	Access to piped water
has_sewage_system	Access to sewage system
Table 2: Lesion_Info
Column	Description
lesion_id	Unique identifier for each lesion
patient_id	Foreign key linking to Patient_Info
fitspatrick	Fitzpatrick skin type (1–6)
region	Body region of lesion
diameter_1 / diameter_2	Lesion diameter (mm)
diagnostic	Diagnosis (e.g., BCC, MEL, NEV)
itch / grew / hurt / changed / bleed	Lesion symptoms (TRUE/FALSE)
elevation	Lesion raised (TRUE/FALSE)
img_id	Associated lesion image filename
biopsed	Biopsy-confirmed diagnosis (TRUE/FALSE)
Project Workflow
1.	Data Import → Load patient and lesion data into SQL database.
2.	Table Joins → Connect Patient_Info and Lesion_Info on patient_id.
3.	Exploratory Queries → Answer medical and epidemiological questions.
4.	Analysis & Insights → Identify high-risk groups and lesion patterns.
5.	Recommendations → Structure dataset for AI training & clinical use.

![ERD](https://github.com/user-attachments/assets/6b77a159-44bb-4b6e-91fc-62537f6ed2e9)

Example SQL Queries
•	Environmental Risk Factor Analysis
SELECT gender, pesticide, COUNT(*) AS case_count
FROM Patient_Info
JOIN Lesion_Info USING(patient_id)
WHERE diagnostic IN ('BCC', 'MEL')
GROUP BY gender, pesticide
ORDER BY case_count DESC;
•	Lesion Characteristic Insights
SELECT diagnostic, AVG(diameter_1) AS avg_diameter, 
       SUM(changed = 'TRUE') AS changed_cases
FROM Lesion_Info
GROUP BY diagnostic;

## Potential Applications
•	Clinical Decision Support → Assist dermatologists in risk stratification.
•	Public Health → Identify environmental and lifestyle risk factors.
•	Machine Learning → Provide structured metadata for lesion classification models.
•	Education → Enable SQL learners to practice joins, filtering, and aggregations.
Project Structure 
│── README.md                # Project overview 
│── LICENSE                  # License file (MIT, Apache, or your choice)
│── requirements.txt         # PostgreSQL tools
│── .gitignore               
│
├── data/
│   ├── raw/                 # Original dataset (Patient_Info.csv, Lesion_Info.csv)
│   ├── processed/           # Cleaned/normalized dataset ready for analysis
│   └── data_dictionary.md   # Description of dataset columns
│
├── queries/
│   ├── exploratory.sql      # Basic exploration queries
│   ├── risk_factors.sql     # Queries on environmental/demographic risks
│   ├── lesion_patterns.sql  # Queries analyzing lesion characteristics
│   └── ml_ready_dataset.sql # SQL script to prepare dataset for ML
│
├── notebooks/
│   ├── analysis.ipynb       # SQL
│   └── visualization.ipynb  # Plots, charts, and insights
│
├── docs/
│   ├── project_workflow.md  # Detailed workflow and methodology
│   ├── presentation.pdf     # PowerPoint slides 
│   └── schema.png           # ER diagram of database schema
│
└── scripts/
    ├── create_schema.sql    # Script to build database tables
    └── insert_data.sql      # Script to insert dataset into DB


