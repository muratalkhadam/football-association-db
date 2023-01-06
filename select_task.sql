USE football_association;

# This SELECT statement retrieves the name of each team,+
# the total number of yellow and red cards received by players on the team.
SELECT t.team_name, SUM(pc.yellow_cards) AS total_yellow, SUM(pc.red_cards) AS total_red
FROM teams t
         JOIN contracts c on t.id = c.team
         JOIN players p on p.id = c.player
         JOIN player_cards pc on p.id = pc.player
GROUP BY team;

# This SELECT statement retrieves the average height of players for each position
SELECT pc.position, AVG(pc.height) AS average_height
FROM players p
         JOIN player_cards pc on p.id = pc.player
GROUP BY pc.position;

# This SELECT statement retrieves the name of each team
# and the maximum salary of a player in that team.
SELECT t.team_name, MAX(c.salary) AS max_salary
FROM players p
         JOIN contracts c on p.id = c.player
         JOIN teams t on t.id = c.team
GROUP BY t.team_name;

# This SELECT statement retrieves the average number of yellow cards
# and average number of red cards for each position
SELECT pc.position, AVG(pc.yellow_cards) AS avg_yellow, AVG(pc.red_cards) AS avg_red
FROM players p
         JOIN player_cards pc on p.id = pc.player
GROUP BY position;


# This SELECT statement gets the first and last names and team name of players
# who have a contract with a particular team that has not yet ended.
SELECT first_name, last_name, team_name
FROM teams
         JOIN contracts c on teams.id = c.team
         JOIN players p on p.id = c.player
WHERE teams.id = 5
  AND end_date > CURDATE();


# This SELECT statement gets the team name and number of players on each team
# who have the same nationality as the team's coach and are currently under contract.
SELECT t.team_name, COUNT(pc.nationality) AS player_nationalities
FROM players p
         JOIN player_cards pc on p.id = pc.player
         JOIN contracts c ON p.id = c.player
         JOIN teams t ON t.id = c.team
         JOIN coaches co ON co.team = t.id
WHERE c.end_date > CURDATE()
  AND pc.nationality = co.nationality
GROUP BY t.team_name
ORDER BY player_nationalities DESC;


# The SELECT statement gets the team name and players on each team who
# have the same nationality as the team's coach and are currently under contract.
SELECT CONCAT(p.first_name, ' ', p.last_name)   AS player_fullname,
       CONCAT(co.first_name, ' ', co.last_name) AS coach_fullname,
       pc.nationality,
       co.nationality,
       t.team_name
FROM players p
         JOIN player_cards pc on p.id = pc.player
         JOIN contracts c ON p.id = c.player
         JOIN teams t ON t.id = c.team
         JOIN coaches co ON co.team = t.id
WHERE c.end_date > CURDATE()
  AND pc.nationality = co.nationality;


# This SELECT statement gets the average player salary and full name of each referee who
# officiated a match involving a team that had a player under contract during the time of the match.
SELECT ROUND(AVG(c.salary), 2)                AS average_player_salary,
       CONCAT(r.first_name, ' ', r.last_name) AS referee_fullname
FROM players p
         JOIN player_cards pc on p.id = pc.player
         JOIN contracts c on p.id = c.player
         JOIN teams t on t.id = c.team
         JOIN matches m on (t.id = m.away_team OR m.home_team = t.id)
         JOIN referees r on m.referee = r.id
WHERE c.end_date > m.match_date
  AND c.start_date < m.match_date
GROUP BY r.id;


# This SELECT statement gets the stadium name, team name
# and number of matches played at each stadium by each team.
SELECT s.stadium_name,
       t.team_name          AS team_name,
       COUNT(DISTINCT m.id) AS match_count
FROM stadiums s
         JOIN matches m ON m.stadium = s.id
         JOIN teams t ON (t.id = m.home_team OR t.id = m.away_team)
         JOIN contracts c ON t.id = c.team
         JOIN players p ON p.id = c.player
WHERE c.end_date > m.match_date
  AND c.start_date < m.match_date
GROUP BY s.id, t.id
ORDER BY s.id, match_count DESC;

# This SELECT statement gets the team name and total
# number of goals scored by each team in away matches.
SELECT t.team_name, SUM(m.away_score) AS away_goals
FROM Teams t
JOIN Matches m ON t.id = m.away_team
GROUP BY t.id
ORDER BY away_goals DESC;


