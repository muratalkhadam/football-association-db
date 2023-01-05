DROP DATABASE IF EXISTS football_association;
CREATE DATABASE football_association;

USE football_association;

CREATE TABLE Referees
(
    id            INTEGER      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(255) NOT NULL,
    last_name     VARCHAR(255) NOT NULL,
    qualification VARCHAR(255) NOT NULL
);

CREATE TABLE Stadiums
(
    id       INTEGER      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name     VARCHAR(255) NOT NULL,
    city     VARCHAR(255) NOT NULL,
    capacity INTEGER      NOT NULL
);

CREATE TABLE Sponsors
(
    id   INTEGER      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL
);

CREATE TABLE Teams
(
    id      INTEGER      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name    VARCHAR(255) NOT NULL,
    founded DATE         NOT NULL,
    sponsor INTEGER      NOT NULL,
    FOREIGN KEY (sponsor) REFERENCES Sponsors (id)
);

CREATE TABLE Players
(
    id         INTEGER      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name  VARCHAR(255) NOT NULL,
    number     INTEGER      NOT NULL
);

CREATE TABLE Player_Cards
(
    id           INTEGER      NOT NULL PRIMARY KEY,
    position     VARCHAR(255) NOT NULL,
    height       INTEGER      NOT NULL,
    weight       INTEGER      NOT NULL,
    yellow_cards INTEGER      NOT NULL,
    red_cards    INTEGER      NOT NULL,
    birth_date   DATE         NOT NULL,
    nationality  VARCHAR(255) NOT NULL,
    player       INTEGER      NOT NULL,
    FOREIGN KEY (player) REFERENCES Players (id)
);

CREATE TABLE Leagues
(
    id   INTEGER      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Matches
(
    id         INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date       DATE    NOT NULL,
    home_team  INTEGER NOT NULL,
    away_team  INTEGER NOT NULL,
    home_score INTEGER NOT NULL,
    away_score INTEGER NOT NULL,
    stadium    INTEGER NOT NULL,
    referee    INTEGER NOT NULL,
    league     INTEGER NOT NULL,
    FOREIGN KEY (league) REFERENCES Leagues (id),
    FOREIGN KEY (stadium) REFERENCES Stadiums (id),
    FOREIGN KEY (home_team) REFERENCES Teams (id),
    FOREIGN KEY (away_team) REFERENCES Teams (id),
    FOREIGN KEY (referee) REFERENCES Referees (id)
);

CREATE TABLE Contracts
(
    id         INTEGER        NOT NULL AUTO_INCREMENT PRIMARY KEY,
    team       INTEGER        NOT NULL,
    player     INTEGER        NOT NULL,
    start_date DATE           NOT NULL,
    end_date   DATE           NOT NULL,
    salary     DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (team) REFERENCES Teams (id),
    FOREIGN KEY (player) REFERENCES Players (id)
);

CREATE TABLE Coaches
(
    id          INTEGER      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(255) NOT NULL,
    last_name   VARCHAR(255) NOT NULL,
    team        INTEGER      NOT NULL,
    experience  INTEGER      NOT NULL,
    nationality VARCHAR(255) NOT NULL,
    FOREIGN KEY (team) REFERENCES Teams (id)
);
