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
--Hightlight team Santa Clara for example:
select "Team",  avg("Wab") as "Average Wins Above Bubble"
from "Wab"
where "Season" > 2021 and "Team" = 'Santa Clara'
group by "Team"
order by avg("Wab") desc;

select "Team",  avg("Wab") as "Average Wins Above Bubble"
from "Wab"
where "Season" < 2021 and "Team" = 'Santa Clara'
group by "Team"
order by avg("Wab") desc;

-- Analytics Query 2
-- Does Quadrant 1 wins have a strong correlation with Wins Above Bubble?

select distinct n."Team" , n.quad1_wins as "Q1 Wins", w."Wab" as "Wins Above Bubble"
from ncaa_with_quad_split n, "Wab" w
where w."Team" = n."Team" and n.year = 2026 and w."Season" = 2026
group by n."Team", w."Wab", n.quad1_wins
order by quad1_wins desc;


-- Analytics Query 3
-- Does teams oppenents NET rank have a strong correlation with Wins Above Bubble?

SELECT DISTINCT
    n."Team",
    n."AvgOppNETRank" as "Average Opponent Rank",
    w."Wab" as "Wins Above Bubble"
FROM "NCAA" n
JOIN "Wab" w ON n."Team" = w."Team"
    AND n."Season" = w."Season"

WHERE w."Season" = 2026
ORDER BY w."Wab" desc;

-- Analytics Query 4
-- Can Wins Above Bubble be used to predict next years regular season?

select "Team", "predicted_wab_2027" as "2027 Prediction"
from "Predictions";