Select COUNT(*) FROM Wab;
Select COUNT(*) FROM NCAA;
Select COUNT(*) FROM Predictions;

-- Create Table ncaa_with_quad_split

CREATE TABLE ncaa_with_quad_split AS
SELECT
    "Season",
    "Team",
    -- Quad 1
    CAST(SPLIT_PART("Q1", '-', 1) AS INT) AS quad1_wins,
    CAST(SPLIT_PART("Q1", '-', 2) AS INT) AS quad1_losses,
    -- Quad 2
    CAST(SPLIT_PART("Q2", '-', 1) AS INT) AS quad2_wins,
    CAST(SPLIT_PART("Q2", '-', 2) AS INT) AS quad2_losses,
    -- Quad 3
    CAST(SPLIT_PART("Q3", '-', 1) AS INT) AS quad3_wins,
    CAST(SPLIT_PART("Q3", '-', 2) AS INT) AS quad3_losses,
    -- Quad 4
    CAST(SPLIT_PART("Q4", '-', 1) AS INT) AS quad4_wins,
    CAST(SPLIT_PART("Q4", '-', 2) AS INT) AS quad4_losses,
    -- Keep original columns if needed
    "Q1" AS quad1_record,
    "Q2" AS quad2_record,
    "Q3" AS quad3_record,
    "Q4" AS quad4_record
FROM "NCAA"
WHERE "Q1" IS NOT NULL
    AND "Q1" LIKE '%-%'
    AND "Q2" IS NOT NULL
    AND "Q2" LIKE '%-%'
    AND "Q3" IS NOT NULL
    AND "Q3" LIKE '%-%'
    AND "Q4" IS NOT NULL
    AND "Q4" LIKE '%-%';



-- Analytics Query 1
-- Show the changes in Wins Above Bubble for teams before NIL and after NIL

select "Team",  avg("Wab") as "Average Wins Above Bubble"
from "Wab"
where "Season" > 2021
group by "Team"
order by avg("Wab") desc;

select "Team",  avg("Wab") as "Average Wins Above Bubble"
from "Wab"
where "Season" < 2021
group by "Team"
order by avg("Wab") desc;


-- Analytics Query 2
-- Does Quadrant wins have a strong correlation with Wins Above Bubble?

SELECT
    n."Team",
    AVG((n.quad1_wins - n.quad1_losses) + (n.quad2_wins - n.quad2_losses)+ (n.quad3_wins - n.quad3_losses)) as "Avg Differential",
    AVG(w."Wab") as "Avg Wins Above Bubble"
FROM ncaa_with_quad_split n
JOIN "Wab" w ON w."Team" = n."Team" AND w."Season" = n."Season"
WHERE n."Season" > 2020
GROUP BY n."Team"
ORDER BY "Avg Wins Above Bubble" DESC;


-- Analytics Query 3
-- Biggest Risers and fallers before NIL to After NIL

WITH team_wab AS (
    SELECT
        "Team",
        AVG(CASE WHEN "Season" > 2021 THEN "Wab" END) as wab_post_NIL,
        AVG(CASE WHEN "Season" <= 2021 THEN "Wab" END) as wab_pre_NIL
    FROM "Wab"
    GROUP BY "Team"
    HAVING COUNT(CASE WHEN "Season" > 2021 THEN 1 END) >= 2
       AND COUNT(CASE WHEN "Season" <= 2021 THEN 1 END) >= 2
)
SELECT
    "Team",
    COALESCE(ROUND(CAST(wab_pre_NIL AS NUMERIC), 2), 0) as "Pre-NIL",
    COALESCE(ROUND(CAST(wab_post_NIL AS NUMERIC), 2), 0) as "Post-NIL",
    COALESCE(ROUND(CAST(ABS(wab_post_NIL - wab_pre_NIL) AS NUMERIC), 2), 0) as "Magnitude",
    CASE
        WHEN wab_post_NIL > wab_pre_NIL THEN 'IMPROVED'
        WHEN wab_post_NIL < wab_pre_NIL THEN 'DECLINED'
        ELSE 'STABLE'
    END as "Trend",
    COALESCE(ROUND(CAST(wab_post_NIL - wab_pre_NIL AS NUMERIC), 2), 0) as "Differential"
FROM team_wab
WHERE wab_post_NIL != wab_pre_NIL
ORDER BY ABS(wab_post_NIL - wab_pre_NIL) DESC
LIMIT 50;

-- Analytics Query 4
-- 2027 College Basketball Regular Season Prediction

select "Team","net_transfers_2026" as "Transfers","recruiting_2026" as "2026 Recruit Score" ,"predicted_wab_2027" as "2027 Prediction"
from "Predictions"