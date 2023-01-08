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
            SET MESSAGE_TEXT = 'Player number already exists in team';
    END IF;
END $$
DELIMITER ;

CALL get_team_by_player(11);

UPDATE players p
SET p.player_number = 10
WHERE p.id = 11;

UPDATE players p
SET p.player_number = 9
WHERE p.id = 11;

CALL get_team_by_player(11);;
