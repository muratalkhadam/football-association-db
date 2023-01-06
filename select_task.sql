USE football_association;

# This SELECT statement retrieves the name of each team,+
# the total number of yellow and red cards received by players on the team.
SELECT t.team_name,
       SUM(pc.yellow_cards) AS total_yellow,
       SUM(pc.red_cards)    AS total_red
FROM teams t
         JOIN contracts c on t.id = c.team
         JOIN players p on p.id = c.player
         JOIN player_cards pc on p.id = pc.player
GROUP BY team;

# This SELECT statement retrieves the average height of players for each position
SELECT pc.position,
       AVG(pc.height) AS average_height,
       AVG(pc.weight) AS average_weight
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
SELECT pc.position,
       AVG(pc.yellow_cards) AS avg_yellow,
       AVG(pc.red_cards)    AS avg_red
FROM players p
         JOIN player_cards pc on p.id = pc.player
GROUP BY position;

# This SELECT statement gets the team name and number of players on each team
# who have the same nationality as the team's coach and are currently under contract.
SELECT t.team_name,
       COUNT(pc.nationality) AS player_nationalities_as_coaches
FROM players p
         JOIN player_cards pc on p.id = pc.player
         JOIN contracts c ON p.id = c.player
         JOIN teams t ON t.id = c.team
         JOIN coaches co ON co.team = t.id
WHERE c.end_date > CURDATE()
  AND pc.nationality = co.nationality
GROUP BY t.team_name
ORDER BY player_nationalities_as_coaches DESC;

# This SELECT statement gets the team name and players on each team who
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

# This SELECT statement gets the team name and the total
# number of goals scored as a home or away team for each team.
SELECT t.team_name,
       SUM(IF(t.id = m.home_team, m.home_score, 0)) AS home_goals,
       SUM(IF(t.id = m.away_team, m.away_score, 0)) AS away_goals
FROM teams t
         JOIN matches m ON (t.id = m.home_team OR t.id = m.away_team)
GROUP BY t.id;

# This SELECT statement gets the sponsor name and league name
# for each sponsor that is associated with a team in a particular league.
SELECT DISTINCT sp.sponsor_name, l.league_name
FROM sponsors sp
         JOIN teams t ON sp.id = t.sponsor
         JOIN matches m on (t.id = m.away_team OR m.home_team = t.id)
         JOIN leagues l on l.id = m.league
ORDER BY sp.sponsor_name;

# This SELECT statement gets the sponsor type, team name, and average player
# age for each team, grouped by team name and sponsor type.
SELECT s.type                                                                      AS sponsor_type,
       t.team_name,
       ROUND(AVG(DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), pc.birth_date)), '%Y')), 2) AS average_age
FROM sponsors s
         JOIN teams t on s.id = t.sponsor
         JOIN contracts c on t.id = c.team
         JOIN players p on c.player = p.id
         JOIN player_cards pc on p.id = pc.player
GROUP BY t.team_name, sponsor_type
ORDER BY average_age;

# # This SELECT statement gets the player number, position, and
# number of players with each player number and position combination.
SELECT player_number,
       pc.position,
       COUNT(player_number) AS players
FROM players
         JOIN player_cards pc on players.id = pc.player
GROUP BY player_number, pc.position
ORDER BY player_number, players DESC;

# This SELECT statement gets the position and average player salary
# for each position, ordered by average salary in descending order.
SELECT pc.position,
       ROUND(AVG(c.salary), 2) AS avg_player_salary
FROM players p
         JOIN player_cards pc on p.id = pc.player
         JOIN contracts c on p.id = c.player
GROUP BY pc.position
ORDER BY avg_player_salary DESC;

# This SELECT statement gets the team name, average player salary, and average
# coach experience for each team, ordered by average player salary in descending order.
SELECT team_name,
       ROUND(AVG(salary), 2)     AS average_players_salary,
       ROUND(AVG(experience), 1) AS average_coaches_exp
FROM coaches
         JOIN teams t on coaches.team = t.id
         JOIN contracts c on t.id = c.team
GROUP BY team_name
ORDER BY average_players_salary DESC;

# This SELECT statement gets the league name and average stadium capacity
# for each league, ordered by average capacity in descending order.
SELECT l.league_name,
       CAST(AVG(s.capacity) AS FLOAT) AS avg_stadium_capacity
FROM matches m
         JOIN leagues l on m.league = l.id
         JOIN stadiums s on m.stadium = s.id
GROUP BY l.id
ORDER BY avg_stadium_capacity DESC;

# This SELECT statement gets the match date, home team name, away team name, and the sum of
# the home and away team's player salaries for each match where the home team has a higher player salary sum.
SELECT m.match_date,
       ht.team_name                 AS home_team_name,
       at.team_name                 AS away_team_name,
       (SELECT SUM(c.salary)
        FROM contracts c
                 JOIN players p ON c.player = p.id
        WHERE c.team = m.home_team) AS home_salary_sum,

       (SELECT SUM(c.salary)
        FROM contracts c
                 JOIN players p ON c.player = p.id
        WHERE c.team = m.away_team) AS away_salary_sum
FROM matches m
         JOIN teams ht ON m.home_team = ht.id
         JOIN teams at ON m.away_team = at.id
HAVING home_salary_sum > away_salary_sum;

# This SELECT statement gets the team name, number of players with no red or yellow cards,
# and average player salary for each team where all players have no red or yellow cards.
SELECT t.team_name,
       COUNT(p.id)             AS total_players_with_red,
       ROUND(AVG(c.salary), 2) AS avg_player_salary
FROM teams t
         JOIN contracts c ON t.id = c.team
         JOIN players p ON c.player = p.id
         JOIN player_cards pc ON p.id = pc.player
WHERE pc.red_cards = 0
  AND pc.yellow_cards = 0
GROUP BY t.id
ORDER BY avg_player_salary DESC;
