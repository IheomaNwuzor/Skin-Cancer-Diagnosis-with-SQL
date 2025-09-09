-- Q1 Determine the percentage Count of malignant and benign lesions within the structured 1088 records
SELECT 
    CASE WHEN diagnostic IN ('MEL', 'SCC', 'BCC') THEN 'Malignant'
        ELSE 'Benign'
    END AS lesion_group,
    COUNT(*) AS total_cases,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) 
	FROM table2), 2) AS percentage
FROM Table2 t2
GROUP BY lesion_group;



-- Q2 Calculate the average diameter of Malignant vs benign
SELECT 
    CASE WHEN diagnostic IN ('MEL', 'SCC', 'BCC') THEN 'Malignant'
        ELSE 'Benign'
    END AS lesion_group,
    ROUND(AVG(CAST((diameter_1 + diameter_2) / 2.0 
	AS numeric)), 2) AS avg_diameter
FROM Table2 t2
GROUP BY lesion_group;



-- Q3 Determine the percentage Grew — malignant vs benign for each group (percentage of lesions that grew within each group)
SELECT 
    lesion_group,
    ROUND(100.0 * SUM(CASE WHEN grew = '1' 
	THEN 1 ELSE 0 END) / COUNT(*), 2) AS grew_percentage
FROM (
    SELECT CASE WHEN diagnostic IN ('MEL', 'SCC', 'BCC') 
	THEN 'Malignant'
            ELSE 'Benign'
        END AS lesion_group,grew
    FROM Table2 t) AS sub
GROUP BY lesion_group;



-- A4 Determine the percentage Grew — malignant vs benign for the overall % across both groups 
SELECT 
    lesion_group,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM Table2), 2) 
		AS percentage_of_total
FROM (SELECT CASE 
            WHEN diagnostic IN ('MEL', 'SCC', 'BCC') THEN 'Malignant'
            ELSE 'Benign'
        END AS lesion_group
    FROM Table2 t2) 
AS sub GROUP BY lesion_group;



--- Q5 Determine the percentage changed — malignant vs benign within the group
SELECT 
    lesion_group,
    ROUND(100.0 * SUM(CASE WHEN changed = '1' 
	THEN 1 ELSE 0 END) / COUNT(*), 2) AS changed_percentage
FROM (SELECT CASE 
            WHEN diagnostic IN ('MEL', 'SCC', 'BCC') 
			THEN 'Malignant'
            ELSE 'Benign'
        END AS lesion_group,
        changed
    FROM Table2) AS sub
GROUP BY lesion_group;


--- Q6 Determine the symptoms of the Itch and Hurt for Malignant and benign
SELECT 
    lesion_group,
    ROUND(100.0 * SUM(CASE WHEN (itch = '1' OR hurt = '1') 
	THEN 1 ELSE 0 END) / COUNT(*), 2) AS itch_hurt_percentage
FROM (
    SELECT 
        CASE 
            WHEN diagnostic IN ('MEL', 'SCC', 'BCC') THEN 'Malignant'
            ELSE 'Benign'
        END AS lesion_group,
        itch,
        hurt
    FROM Table2) AS sub
GROUP BY lesion_group;



-- Q7 Determine the percentage of malignant cases by skin type group
SELECT 
    CASE 
        WHEN fitspatrick IN (1, 2) THEN 'I–II'
        WHEN fitspatrick IN (3, 4) THEN 'III–IV'
        WHEN fitspatrick IN (5, 6) THEN 'V–VI'
        ELSE 'Unknown'
    END AS skin_group,
    COUNT(*) AS total_lesions,
    SUM(CASE WHEN diagnostic IN ('MEL','BCC','SCC') 
	THEN 1 ELSE 0 END) AS malignant_count,
    ROUND(100.0 * CAST(SUM(CASE WHEN diagnostic IN ('MEL','BCC','SCC') 
	THEN 1 ELSE 0 END) AS numeric)
        / NULLIF(COUNT(*),0), 2) 
		AS pct_malignant_within_group
FROM table2 t2
GROUP BY skin_group
ORDER BY skin_group;



--Q8 Determine the lesion region for UV and covered(Face, Arms, Chest, Thigh)
SELECT 
    region,
    COUNT(*) AS total_lesions,
    SUM(CASE WHEN diagnostic IN ('MEL','BCC','SCC') THEN 1 ELSE 0 END) AS malignant_count,
    ROUND(
        100.0 * SUM(CASE WHEN diagnostic IN ('MEL','BCC','SCC') THEN 1 ELSE 0 END)::numeric
        / NULLIF(COUNT(*),0),
        2
    ) AS pct_malignant
FROM Table2
GROUP BY region
ORDER BY region;






-- Q9 Compare risk factor distribution between malignant vs. benign
SELECT 
    t1.gender,
    t1.smoke,
    t1.drink,
    t1.background_father,
    t1.background_mother,
    t1.cancer_history,
    t1.skin_cancer_history,
    t1.pesticide,
    t1.has_piped_water,
    t1.has_sewage_system,
    t2.diagnostic,
    COUNT(*) AS case_count
FROM Table1 t1
JOIN Table2 t2 ON t1.patient_id = t2.patient_id
GROUP BY 
    t1.gender, t1.smoke, t1.drink, t1.background_father, 
    t1.background_mother, t1.cancer_history, t1.skin_cancer_history,
    t1.pesticide, t1.has_piped_water, t1.has_sewage_system,
    t2.diagnostic
ORDER BY case_count DESC
LIMIT 15;


-- Q10 Compare the Symptom frequency (itch, bleed, hurt, changed, grew) by diagnosis
SELECT 
    t2.diagnostic,
    SUM(CASE WHEN t2.itch = 'yes' THEN 1 ELSE 0 END) AS itch_count,
    SUM(CASE WHEN t2.bleed = 'yes' THEN 1 ELSE 0 END) AS bleed_count,
    SUM(CASE WHEN t2.hurt = 'yes' THEN 1 ELSE 0 END) AS hurt_count,
    SUM(CASE WHEN t2.changed = 'yes' THEN 1 ELSE 0 END) AS changed_count,
    SUM(CASE WHEN t2.grew = 'yes' THEN 1 ELSE 0 END) AS grew_count,
    COUNT(*) AS total_cases
FROM Table2 t2
GROUP BY t2.diagnostic
ORDER BY t2.diagnostic;






-- Q11 Determine the total lesions in an age group, with their percentage for diagnostic 
--within the age groups (break down by each diagnostic type).
SELECT 
    CASE 
        WHEN t1.age < 30 THEN 'Under 30'
        WHEN t1.age BETWEEN 30 AND 50 THEN '30-50'
        WHEN t1.age BETWEEN 51 AND 70 THEN '51-70'
        ELSE '71+'
    END AS age_group,
    t2.diagnostic,
    COUNT(*) AS lesion_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY 
            CASE 
                WHEN t1.age < 30 THEN 'Under 30'
                WHEN t1.age BETWEEN 30 AND 50 THEN '30-50'
                WHEN t1.age BETWEEN 51 AND 70 THEN '51-70'
                ELSE '71+'
            END), 2) AS pct_within_age_group
FROM Table1 t1
JOIN Table2 t2 ON t1.patient_id = t2.patient_id
GROUP BY age_group, t2.diagnostic
ORDER BY age_group, lesion_count DESC;



-- Q12 Determine the percentage Malignant for each age group.
SELECT 
    CASE 
        WHEN t1.age < 30 THEN 'Under 30'
        WHEN t1.age BETWEEN 30 AND 50 THEN '30-50'
        WHEN t1.age BETWEEN 51 AND 70 THEN '51-70'
        ELSE '71+'
    END AS age_group,
    ROUND(100.0 * SUM(CASE WHEN t2.diagnostic IN ('MEL','BCC','SCC') THEN 1 ELSE 0 END)::numeric
        / NULLIF(COUNT(*),0),2) 
		AS pct_malignant
FROM Table1 t1
JOIN Table2 t2 ON t1.patient_id = t2.patient_id
GROUP BY age_group
ORDER BY age_group;


-- Q13: Calculate the total lesions for each history group and count malignant lesions within each group.
SELECT
    CASE 
        WHEN p.cancer_history = TRUE THEN 'With History'
        ELSE 'Without History'
    END AS history_group,
    COUNT(*) AS total_lesions,
    SUM(CASE WHEN l.diagnostic IN ('MEL','BCC','SCC') THEN 1 ELSE 0 END) AS malignant_count,
    ROUND(
        100.0 * SUM(CASE WHEN l.diagnostic IN ('MEL','BCC','SCC') THEN 1 ELSE 0 END)::numeric
        / NULLIF(COUNT(*),0),
        2
    ) AS pct_malignant
FROM Table1 p
JOIN Table2 l ON p.patient_id = l.patient_id
GROUP BY history_group
ORDER BY history_group;




-- Q14 Percentage Malignant exposed and non-exposed
SELECT
    CASE 
        WHEN t1.pesticide = TRUE THEN 'Exposed'
        ELSE 'Not Exposed'
    END AS pesticide_exposure,
    COUNT(*) AS total_lesions,
    SUM(CASE WHEN t2.diagnostic IN ('MEL','BCC','SCC') 
	THEN 1 ELSE 0 END) AS malignant_count,
    ROUND(100.0 * CAST(SUM(CASE WHEN t2.diagnostic IN ('MEL','BCC','SCC') 
	THEN 1 ELSE 0 END) AS numeric)
        / NULLIF(COUNT(*),0),2) AS pct_malignant
FROM Table1 t1
JOIN Table2 t2 ON t1.patient_id = t2.patient_id
GROUP BY pesticide_exposure
ORDER BY pesticide_exposure;




-- Q15 Compare the percentage malignant and baseline using multiple risk factors
WITH total_baseline AS (
    SELECT 
        COUNT(*) AS total_lesions,
        SUM(CASE WHEN diagnostic IN ('MEL','BCC','SCC') THEN 1 ELSE 0 END) AS malignant_count
    FROM Table2 t2),multi_risk 
	AS (
    SELECT 
        COUNT(*) AS total_lesions,
        SUM(CASE WHEN diagnostic IN ('MEL','BCC','SCC') THEN 1 ELSE 0 END) AS malignant_count
    FROM Table2 t2
    JOIN Table1 t1 ON t1.patient_id = t2.patient_id
    WHERE t1.smoke = TRUE
      AND t1.drink = TRUE
      AND t1.pesticide = TRUE
      AND t2.fitspatrick IN (1,2))
SELECT 
    'Multiple risks (smoke+drink+pesticide+I–II)' AS group_label,
    ROUND(100.0 * multi_risk.malignant_count / NULLIF(multi_risk.total_lesions,0), 2) AS pct_malignant,
    ROUND(100.0 * total_baseline.malignant_count / NULLIF(total_baseline.total_lesions,0), 2) AS pct_baseline
FROM multi_risk, total_baseline;





-- Q16 Calculate biopsy rates for malignant lesions, including how many were biopsied vs missed, based on your dataset.
SELECT
    COUNT(*) AS total_malignant,
    SUM(CASE WHEN biopsed = TRUE THEN 1 ELSE 0 END) AS biopsed_count,
    SUM(CASE WHEN biopsed = FALSE THEN 1 ELSE 0 END) AS missed_count,
    ROUND(
        100.0 * SUM(CASE WHEN biopsed = TRUE THEN 1 ELSE 0 END)::numeric
        / COUNT(*),
        2
    ) AS pct_biopsed,
    ROUND(
        100.0 * SUM(CASE WHEN biopsed = FALSE THEN 1 ELSE 0 END)::numeric
        / COUNT(*),
        2
    ) AS pct_missed
FROM Table2
WHERE diagnostic IN ('MEL','BCC','SCC');




-- Q17 Calculate malignant lesion percentages based on water/sanitation access.
SELECT
    CASE 
        WHEN p.has_piped_water = TRUE AND p.has_sewage_system = TRUE THEN 'Good Access'
        ELSE 'Poor Access'
    END AS water_sanitation_access,
    COUNT(*) AS total_lesions,
    SUM(CASE WHEN l.diagnostic IN ('MEL','BCC','SCC') THEN 1 ELSE 0 END) AS malignant_count,
    ROUND(
        100.0 * CAST(SUM(CASE WHEN l.diagnostic IN ('MEL','BCC','SCC') THEN 1 ELSE 0 END) AS numeric)
        / NULLIF(COUNT(*),0),
        2
    ) AS pct_malignant
FROM Table1 p
JOIN Table2 l ON p.patient_id = l.patient_id
GROUP BY water_sanitation_access
ORDER BY water_sanitation_access;




-- Q18 Calculate Malignant by gender
SELECT
    p.gender,
    COUNT(*) AS total_lesions,
    SUM(CASE WHEN l.diagnostic IN ('MEL','BCC','SCC') THEN 1 ELSE 0 END) AS malignant_count,
    ROUND(
        100.0 * CAST(SUM(CASE WHEN l.diagnostic IN ('MEL','BCC','SCC') THEN 1 ELSE 0 END) AS numeric)
        / NULLIF(COUNT(*),0),
        2
    ) AS pct_malignant
FROM Table1 p
JOIN Table2 l ON p.patient_id = l.patient_id
GROUP BY p.gender
ORDER BY p.gender;




