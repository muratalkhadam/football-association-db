USE football_association;


DROP TRIGGER IF EXISTS before_update_player_number;
DELIMITER $$
CREATE TRIGGER before_update_player_number
    BEFORE UPDATE
    ON players
    FOR EACH ROW
BEGIN
    DECLARE current_team, num_exists INT;

    SELECT team
    INTO current_team
    FROM contracts
    WHERE contracts.player = OLD.id
      AND end_date > CURDATE();

    SELECT COUNT(*)
    INTO num_exists
    FROM players
    WHERE players.player_number = NEW.player_number
      AND id IN (SELECT id
                 FROM contracts
                 WHERE contracts.team = current_team);

    IF num_exists > 0 AND OLD.player_number != NEW.player_number THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Player number already exists in team.';
    END IF;
END $$
DELIMITER ;
# ------------------------------------------
CALL get_team_by_player(11);

UPDATE players p
SET p.player_number = 10
WHERE p.id = 11;

UPDATE players p
SET p.player_number = 9
WHERE p.id = 11;

CALL get_team_by_player(11);
# ------------------------------------------


DROP TRIGGER IF EXISTS before_insert_sponsor_team;
DELIMITER $$
CREATE TRIGGER before_insert_sponsor_team
    BEFORE INSERT
    ON teams
    FOR EACH ROW
BEGIN
    DECLARE sponsored_teams INT;

    SELECT COUNT(*)
    INTO sponsored_teams
    FROM sponsors
             JOIN teams t on sponsors.id = t.sponsor
    WHERE t.sponsor = NEW.sponsor;

    IF sponsored_teams = 2 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'One sponsor can only work with a maximum of two teams.';
    END IF;
END $$
DELIMITER ;
# ------------------------------------------
SELECT sponsors.id      AS sponsor_id,
       COUNT(team_name) AS sponsored_teams
FROM sponsors
         JOIN teams t on sponsors.id = t.sponsor
GROUP BY sponsors.id;

INSERT INTO teams (team_name, founded, sponsor)
VALUES ('TEST', '2000-01-01', 1);

INSERT INTO teams (team_name, founded, sponsor)
VALUES ('TEST', '2000-01-01', 2);

SELECT sponsors.id      AS sponsor_id,
       COUNT(team_name) AS sponsored_teams
FROM sponsors
         JOIN teams t on sponsors.id = t.sponsor
GROUP BY sponsors.id;

DELETE
FROM teams
WHERE team_name = 'TEST';
# ------------------------------------------


DROP TRIGGER IF EXISTS before_delete_player;
DELIMITER $$
CREATE TRIGGER before_delete_player
    BEFORE DELETE
    ON Players
    FOR EACH ROW
BEGIN
    DECLARE contracts_exist INT;
    SELECT COUNT(*)
    INTO contracts_exist
    FROM contracts
    WHERE player = OLD.id
      AND end_date > CURDATE();

    IF contracts_exist > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete player with valid contracts';
    END IF;
END $$
DELIMITER ;
# ------------------------------------------
SELECT p.id,
       COUNT(*) AS valid_contracts
FROM players p
         JOIN contracts c ON p.id = c.player
         JOIN teams t ON c.team = t.id
WHERE c.end_date > CURDATE()
GROUP BY p.id
ORDER BY p.id, valid_contracts;

DELETE
FROM players
WHERE id = 1;

INSERT INTO players (first_name, last_name, player_number)
VALUES ('TEST', 'TEST', 88);

SELECT *
FROM players;

DELETE
FROM players
WHERE first_name = 'TEST';

SELECT *
FROM players;
