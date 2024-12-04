/*
Advanced - League Table Case Study

Build the league table in a few steps

Firstly get each team results any individual match level
and then summarise into a basic league table
and store as a temporary table
*/
DROP TABLE IF EXISTS #LeagueTable;

WITH MatchResult ([Date], [Team], [Won], [Drawn],  [Lost],  [For], [Against],  [Points]) 
AS
(
SELECT 
	m.Date
	, m.HomeTeam AS Team
	, CASE 	WHEN m.FTHG > m.FTAG THEN 1 ELSE 0 	END AS Won
	, CASE WHEN m.FTHG = m.FTAG THEN 1 ELSE 0 END AS Drawn
	, CASE WHEN m.FTHG < m.FTAG THEN 1 ELSE 0 END AS Lost
	, m.FTHG AS [For]
	, m.FTAG AS [Against]
	, CASE m.FTR WHEN 'H' THEN 3 WHEN 'D' THEN 1 ELSE 0 END AS Points
FROM
	dbo.FootballMatch m
UNION ALL	
SELECT 
	m.Date, 
	m.AwayTeam AS Team, 
	CASE WHEN m.FTHG < m.FTAG THEN  1 ELSE 0 END AS Won,    
	CASE WHEN m.FTHG = m.FTAG THEN  1 ELSE 0 END AS Drawn,    
	CASE WHEN m.FTHG > m.FTAG THEN  1 ELSE 0 END AS Lost,   
	m.FTAG AS [For],
	m.FTHG AS [Against],
	CASE m.FTR WHEN 'H' THEN 0 WHEN 'D' THEN 1 ELSE 3 END AS Points
FROM dbo.FootballMatch m
)
--SELECT * FROM MatchResult
SELECT
	Team
	, SUM(Won) AS Won
	, SUM(Drawn) AS Drawn
	, SUM(Lost) AS Lost
	, SUM([For]) AS [For]
	, SUM(Against) AS Against
	, SUM(Points) AS Points 
INTO
	#LeagueTable
FROM
	MatchResult
GROUP BY
	Team;

SELECT
	Team
	, Won
	, Drawn
	, Lost
	, [For]
	, Against
	, ([For] - Against) AS GD
	, Points
FROM
	#LeagueTable
ORDER BY
	Points DESC
	, GD DESC;

-- Optional � add the Form, the team�s results of the last five games

DROP TABLE IF EXISTS #MatchForm;

WITH MatchResult ([Date], [Team], [Result]) 
AS
(
SELECT 
	m.Date 
	, m.HomeTeam AS Team
	, CASE m.FTR WHEN 'H' THEN 'W' WHEN 'D' THEN 'D' ELSE 'L' END AS Result
FROM dbo.FootballMatch m
UNION ALL	
SELECT 
	m.Date
	, m.AwayTeam AS Team
	,CASE m.FTR WHEN 'H' THEN 'L' WHEN 'D' THEN 'D' ELSE 'W' END AS Result
FROM dbo.FootballMatch m
)
SELECT
	[Team]
	, [Date]
	, [Result]
	, ROW_NUMBER() OVER (PARTITION BY Team ORDER BY Team , [Date] DESC) AS ReverseDateRank
INTO
	#MatchForm
FROM
	MatchResult;

SELECT * FROM #MatchForm;

-- we only need the results frtom the last 5 matches
DELETE FROM #MatchForm WHERE ReverseDateRank > 5;  

SELECT * FROM #MatchForm;

DROP TABLE IF EXISTS #MatchFormTranspose;

SELECT 
	Team 
	, CASE WHEN ReverseDateRank = 1 THEN Result ELSE NULL END AS R1
	, CASE WHEN ReverseDateRank = 2 THEN Result ELSE NULL END AS R2
	, CASE WHEN ReverseDateRank = 3 THEN Result ELSE NULL END AS R3
	, CASE WHEN ReverseDateRank = 4 THEN Result ELSE NULL END AS R4
	, CASE WHEN ReverseDateRank = 5 THEN Result ELSE NULL END AS R5
INTO #MatchFormTranspose
 FROM #MatchForm;

SELECT * FROM #MatchFormTranspose;

DROP TABLE IF EXISTS #MatchFormTransposeGroup;

SELECT 
	Team
	, MAX(R1) AS R1
	, MAX(R2) AS R2
	, MAX(R3) AS R3
	, MAX(R4) AS R4
	, MAX(R5) AS R5
	, MAX(R5) + MAX(R4) + MAX(R3) + MAX(R2) + MAX(R1) AS LatestMatchForm
INTO
	#MatchFormTransposeGroup
FROM
	#MatchFormTranspose
GROUP BY
	Team;

SELECT * FROM #MatchFormTransposeGroup;

SELECT
	lt.Team
	, lt.Won
	, lt.Drawn
	, lt.Lost
	, lt.[For]
	, lt.Against
	, (lt.[For] - lt.Against) AS GD
	, lt.Points
	, mftg.LatestMatchForm
FROM
	#LeagueTable lt INNER JOIN #MatchFormTransposeGroup mftg ON 	mftg.Team = lt.Team
ORDER BY
	lt.Points DESC
	, GD DESC;
