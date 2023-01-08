USE football_association;


DROP FUNCTION IF EXISTS get_lowest_scoring_team;
DELIMITER $$
CREATE FUNCTION get_lowest_scoring_team()
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE lowest_scoring_team INT;
    SELECT t.id
    INTO lowest_scoring_team

    FROM teams t
             JOIN matches m ON
        (t.id = m.home_team OR t.id = m.away_team)
    GROUP BY t.id
    ORDER BY SUM(m.home_score + m.away_score)
    LIMIT 1;

    RETURN lowest_scoring_team;
END $$
DELIMITER ;
SELECT get_lowest_scoring_team() AS lowest_scoring_team_id;


DROP FUNCTION IF EXISTS get_highest_paid_team_by_sponsor;
DELIMITER $$
CREATE FUNCTION get_highest_paid_team_by_sponsor(sponsor_id INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE team_id INT;
    SELECT t.id
    INTO team_id

    FROM teams t
             JOIN contracts c ON t.id = c.team
    WHERE t.sponsor = sponsor_id
    GROUP BY t.id
    ORDER BY SUM(C.salary) DESC
    LIMIT 1;

    RETURN team_id;
END $$
DELIMITER ;
SELECT get_highest_paid_team_by_sponsor(5) AS highest_paid_team_id;

DROP FUNCTION IF EXISTS get_lowest_scoring_team2;
DELIMITER $$
CREATE FUNCTION get_best_paid_player_for_team(team_id INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE best_paid_player INT;
    SELECT p.id
    INTO best_paid_player

    FROM contracts c
             JOIN players p ON c.player = p.id
    WHERE c.team = team_id
    ORDER BY c.salary DESC
    LIMIT 1;

    RETURN best_paid_player;
END $$
DELIMITER ;
SELECT get_best_paid_player_for_team(8) AS best_paid_player_id;
