Create database Sports_League;
Use Sports_League;

-- Teams Table
CREATE TABLE Teams (
    team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(255) NOT NULL,
    city VARCHAR(255),
    founded_year INT
);

-- Players Table
CREATE TABLE Players (
    player_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    nationality VARCHAR(255),
    team_id INT,
    position VARCHAR(255),
    height DECIMAL(5, 2),
    weight DECIMAL(5, 2),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- Matches Table
CREATE TABLE Matches (
    match_id INT PRIMARY KEY AUTO_INCREMENT,
    home_team_id INT,
    away_team_id INT,
    match_date DATETIME,
    location VARCHAR(255),
    season VARCHAR(255),
    FOREIGN KEY (home_team_id) REFERENCES Teams(team_id),
    FOREIGN KEY (away_team_id) REFERENCES Teams(team_id)
);

-- Scores Table
CREATE TABLE Scores (
    score_id INT PRIMARY KEY AUTO_INCREMENT,
    match_id INT,
    player_id INT,
    team_id INT,
    score_type VARCHAR(255),
    score_value INT,
    score_time DATETIME,
    FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- Teams
INSERT INTO Teams (team_name, city, founded_year) VALUES
('Los Angeles Lakers', 'Los Angeles', 1947),
('Chicago Bulls', 'Chicago', 1966),
('Golden State Warriors', 'San Francisco', 1946);

-- Players
INSERT INTO Players (first_name, last_name, date_of_birth, nationality, team_id, position, height, weight) VALUES
('LeBron', 'James', '1984-12-30', 'USA', 1, 'Forward', 2.06, 113),
('Michael', 'Jordan', '1963-02-17', 'USA', 2, 'Guard', 1.98, 98),
('Stephen', 'Curry', '1988-03-14', 'USA', 3, 'Guard', 1.91, 86);

-- Matches
INSERT INTO Matches (home_team_id, away_team_id, match_date, location, season) VALUES
(1, 2, '2023-11-15 20:00:00', 'Crypto.com Arena', '2023-2024'),
(2, 3, '2023-11-16 19:30:00', 'United Center', '2023-2024'),
(3, 1, '2023-11-17 21:00:00', 'Chase Center', '2023-2024');

-- Scores
INSERT INTO Scores (match_id, player_id, team_id, score_type, score_value, score_time) VALUES
(1, 1, 1, 'Point', 2, '2023-11-15 20:15:00'),
(1, 2, 2, 'Point', 3, '2023-11-15 20:30:00'),
(2, 2, 2, 'Point', 2, '2023-11-16 20:00:00'),
(2, 3, 3, 'Point', 3, '2023-11-16 20:45:00'),
(3, 3, 3, 'Point', 2, '2023-11-17 21:30:00'),
(3, 1, 1, 'Point', 3, '2023-11-17 22:00:00');


-- Index on Player's Name
CREATE INDEX idx_player_name ON Players (first_name, last_name);

-- Trigger to Update Player's Team Information
DELIMITER //

CREATE TRIGGER update_player_team_on_team_change
AFTER UPDATE ON Teams
FOR EACH ROW
BEGIN
    IF NEW.team_id != OLD.team_id THEN
        UPDATE Players
        SET team_id = NEW.team_id
        WHERE team_id = OLD.team_id;
    END IF;
END;
//

DELIMITER ;

-- Queries:
-- 1)Find all players from the Los Angeles Lakers:
SELECT first_name, last_name
FROM Players
WHERE team_id = (SELECT team_id FROM Teams WHERE team_name = 'Los Angeles Lakers');

-- 2)Find all matches played in the 2023-2024 season
SELECT m.match_date, t1.team_name AS home_team, t2.team_name AS away_team
FROM Matches m
JOIN Teams t1 ON m.home_team_id = t1.team_id
JOIN Teams t2 ON m.away_team_id = t2.team_id
WHERE m.season = '2023-2024';

-- 3)Find all scores by Michael Jordan:
SELECT s.score_value, s.score_type, m.match_date
FROM Scores s
JOIN Players p ON s.player_id = p.player_id
JOIN Matches m ON s.match_id = m.match_id
WHERE p.first_name = 'Michael' AND p.last_name = 'Jordan';

-- 4)Find the team name of the player who scored the first point in match_id 1:
SELECT T.team_name FROM Teams T
JOIN Scores S on T.team_id = S.team_id
WHERE S.match_id = 1
ORDER BY score_time ASC
LIMIT 1;

-- 5.Find all players whose last name begins with 'J':
SELECT first_name, last_name
FROM Players
WHERE last_name LIKE 'J%';

-- 6.Find the average height of all players:
SELECT AVG(height) AS average_height
FROM Players;

-- 7.Find the total points scored by each player:
SELECT p.first_name, p.last_name, SUM(s.score_value) AS total_points
FROM Players p
JOIN Scores s ON p.player_id = s.player_id
GROUP BY p.player_id;