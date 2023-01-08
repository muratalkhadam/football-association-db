USE football_association;


DROP PROCEDURE IF EXISTS get_team_goals_in_league;
DELIMITER $$
CREATE PROCEDURE get_team_goals_in_league(IN team_id INT, IN league_id INT)
BEGIN
    SELECT IF(SUM(m.home_score + m.away_score) IS NOT NULL,
              SUM(m.home_score + m.away_score),
              0) AS goals
    FROM matches m
             JOIN teams t ON (t.id = m.home_team OR t.id = m.away_team)
             JOIN leagues l ON l.id = m.league
    WHERE (t.id = team_id AND l.id = league_id);
END $$
DELIMITER ;
CALL get_team_goals_in_league(2, 2);

DROP PROCEDURE IF EXISTS get_players_with_valid_contract;
DELIMITER $$
CREATE PROCEDURE get_players_with_valid_contract(IN team_id INT)
BEGIN
    SELECT t.team_name,
           CONCAT(p.first_name, ' ', p.last_name) AS fullname
    FROM teams t
             JOIN contracts c on t.id = c.team
             JOIN players p on p.id = c.player
    WHERE t.id = team_id
      AND end_date > CURDATE();
END $$
DELIMITER ;
CALL get_players_with_valid_contract(1);


DROP PROCEDURE IF EXISTS update_team_salaries;
DELIMITER $$
CREATE PROCEDURE update_team_salaries(IN team_id INT, IN percentage_to_change DECIMAL(5, 2), IN is_increase BOOLEAN)
BEGIN
    UPDATE contracts c
    SET c.salary = (1 + (2 * is_increase - 1) * (percentage_to_change / 100)) * c.salary
    WHERE c.team = team_id;
END $$
DELIMITER ;

SELECT *
FROM contracts
WHERE team = 5;

CALL update_team_salaries(5, 7, TRUE);

SELECT *
FROM contracts
WHERE team = 5;

DROP PROCEDURE IF EXISTS get_team_by_player;
DELIMITER $$
CREATE PROCEDURE get_team_by_player(IN player_id INT)
BEGIN
    DECLARE team_id INT;
    SELECT DISTINCT team INTO team_id
    FROM players
    JOIN contracts c1 ON players.id = c1.player
    WHERE player = player_id AND c1.end_date > CURDATE();

    SELECT p.id, p.first_name, p.last_name, p.player_number, t.team_name
    FROM players p
             JOIN contracts c ON p.id = c.player
             JOIN teams t ON t.id = c.team
    WHERE t.id = team_id
      AND end_date > CURDATE();
END $$
DELIMITER ;
CALL get_team_by_player(11);
