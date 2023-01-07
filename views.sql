USE football_association;


DROP VIEW IF EXISTS player_medcards;
CREATE OR REPLACE VIEW player_medcards AS
SELECT CONCAT(p.first_name, ' ', p.last_name) AS player_full_name,
       pc.height,
       pc.weight,
       pc.birth_date
FROM players p
         JOIN player_cards pc on p.id = pc.player;

SELECT *
FROM player_medcards;

DROP VIEW IF EXISTS player_coach_contracts;
CREATE OR REPLACE VIEW player_coach_contracts AS
SELECT CONCAT(p.first_name, ' ', p.last_name)   AS player_full_name,
       t.team_name,
       CONCAT(co.first_name, ' ', co.last_name) AS coach_full_name,
       c.start_date,
       c.end_date,
       c.salary
FROM players p
         JOIN player_cards pc on p.id = pc.player
         JOIN contracts c on p.id = c.player
         JOIN teams t on t.id = c.team
         JOIN coaches co on t.id = co.team
ORDER BY p.id;

SELECT *
FROM player_coach_contracts;

DROP VIEW IF EXISTS match_with_teams;
CREATE OR REPLACE VIEW match_with_teams AS
SELECT DISTINCT t_home.team_name                          AS home_team,
                CONCAT(m.home_score, ' : ', m.away_score) AS score,
                t_away.team_name                          AS away_team
FROM matches m
         JOIN teams t_home ON m.home_team = t_home.id
         JOIN teams t_away ON m.away_team = t_away.id;

SELECT *
FROM match_with_teams;