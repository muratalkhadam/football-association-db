USE football_association;


DROP ROLE IF EXISTS referee;
CREATE ROLE referee;
GRANT SELECT, UPDATE (yellow_cards, red_cards) ON TABLE football_association.player_cards TO referee;
GRANT SELECT, UPDATE, DELETE ON TABLE football_association.matches TO referee;

DROP ROLE IF EXISTS fan;
CREATE ROLE fan;
GRANT SELECT ON football_association.match_with_teams TO fan;
GRANT SELECT ON football_association.player_coach_contracts TO fan;

DROP ROLE IF EXISTS team_manager;
CREATE ROLE team_manager;
GRANT ALL ON football_association.contracts TO team_manager;
GRANT ALL ON football_association.players TO team_manager;
GRANT ALL ON football_association.coaches TO team_manager;
GRANT ALL ON football_association.player_cards TO team_manager;

DROP USER IF EXISTS test_manager@localhost;
CREATE USER test_manager@localhost IDENTIFIED BY 'manager';
GRANT team_manager TO test_manager@localhost;

DROP USER IF EXISTS test_referee@localhost;
CREATE USER test_referee@localhost IDENTIFIED BY 'referee';
GRANT referee TO test_referee@localhost;

DROP USER IF EXISTS test_fan@localhost;
CREATE USER test_fan@localhost IDENTIFIED BY 'fan';
GRANT fan TO test_fan@localhost;