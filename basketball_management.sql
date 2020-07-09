-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Φιλοξενητής: 127.0.0.1
-- Χρόνος δημιουργίας: 06 Ιουν 2020 στις 16:45:26
-- Έκδοση διακομιστή: 10.4.11-MariaDB
-- Έκδοση PHP: 7.2.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Βάση δεδομένων: `basketball_management`
--

DELIMITER $$
--
-- Συναρτήσεις
--
CREATE DEFINER=`root`@`localhost` FUNCTION `get_current_judge_by_game` (`game_id` INT(111)) RETURNS INT(11) NO SQL
BEGIN
DECLARE totalHR int(11);
SELECT count(*) into totalHR from human_power HP,user U where  HP.game_id = game_id AND HP.user_id = U.id AND U.profession = 3;
RETURN (totalHR);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_current_referee_by_game` (`game_id` INT(11)) RETURNS INT(11) NO SQL
BEGIN
DECLARE totalHR int(11);
SELECT count(*) into totalHR from human_power HP,user U where U.id = HP.user_id AND HP.game_id = game_id AND HP.user_id = U.id AND U.profession = 2;
RETURN (totalHR);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_last_login_by_user` (`in_user_id` INT) RETURNS DATETIME NO SQL
BEGIN
DECLARE last_login datetime;
SELECT logout_date_time into last_login from login_history where user_id=in_user_id order by logout_date_time desc limit 1;
RETURN (last_login);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_number_of_announcements` () RETURNS INT(11) NO SQL
BEGIN
DECLARE total_announcements int(11);
SELECT count(*) into total_announcements FROM announcement;
RETURN (total_announcements);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_number_of_received_messages_by_user` (`id_in` INT(11)) RETURNS INT(11) NO SQL
BEGIN
DECLARE total_messages int(11);
SELECT count(*) into total_messages FROM message where receiver_id=id_in;
RETURN (total_messages);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_number_of_restrictions` (`in_user_id` INT) RETURNS INT(11) NO SQL
BEGIN
DECLARE total_restrictions int(11);
SELECT count(*) into total_restrictions from restriction where user_id=in_user_id;
RETURN (total_restrictions);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_n_o_r_by_game` (`game_id` INT(11)) RETURNS INT(11) NO SQL
BEGIN
DECLARE total_restrictions int(11);
SELECT count(*) into total_restrictions from game G,restriction R where G.id=game_id AND R.time_to>TIME(date_time) AND R.time_from < DATE_ADD(TIME(date_time), INTERVAL 2 HOUR) AND R.date=DATE(date_time);
RETURN (total_restrictions);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `announcement`
--

CREATE TABLE `announcement` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(50) CHARACTER SET utf8 NOT NULL,
  `text` text CHARACTER SET utf8 NOT NULL,
  `date_time` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Άδειασμα δεδομένων του πίνακα `announcement`
--

INSERT INTO `announcement` (`id`, `user_id`, `title`, `text`, `date_time`) VALUES
(64, 29, 'Διπλωματική Εργασία', 'Το παρόν έργο αποτελεί μέρος διπλωματικής', '2020-06-06 17:42:08');

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `apk_version`
--

CREATE TABLE `apk_version` (
  `id` int(3) NOT NULL,
  `apk_name` varchar(20) CHARACTER SET utf8 NOT NULL,
  `release_date` datetime NOT NULL DEFAULT current_timestamp(),
  `version_number` varchar(10) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `city`
--

CREATE TABLE `city` (
  `id` int(11) NOT NULL,
  `name` varchar(20) CHARACTER SET utf8 NOT NULL,
  `active` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Άδειασμα δεδομένων του πίνακα `city`
--

INSERT INTO `city` (`id`, `name`, `active`) VALUES
(1, 'Κοζάνη', 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `court`
--

CREATE TABLE `court` (
  `id` int(11) NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `longitude` varchar(20) CHARACTER SET utf8 NOT NULL,
  `latitude` varchar(20) CHARACTER SET utf8 NOT NULL,
  `city` int(11) NOT NULL,
  `active` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `game`
--

CREATE TABLE `game` (
  `id` int(11) NOT NULL,
  `team_id_1` int(11) NOT NULL,
  `team_id_2` int(11) NOT NULL,
  `court_id` int(11) NOT NULL,
  `date_time` datetime NOT NULL,
  `team_score_1` int(3) DEFAULT 0,
  `team_score_2` int(3) DEFAULT 0,
  `rate` int(2) NOT NULL,
  `required_referees` tinyint(1) NOT NULL,
  `required_judges` tinyint(1) NOT NULL,
  `state` tinyint(1) NOT NULL DEFAULT 0,
  `register_timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `human_power`
--

CREATE TABLE `human_power` (
  `game_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `login_history`
--

CREATE TABLE `login_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `login_date_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `logout_date_time` timestamp NULL DEFAULT current_timestamp(),
  `safe_key` varchar(15) CHARACTER SET utf8 NOT NULL,
  `device_name` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `ip` varchar(50) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `message`
--

CREATE TABLE `message` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `text_message` text CHARACTER SET utf8 NOT NULL,
  `date_time` datetime NOT NULL DEFAULT current_timestamp(),
  `message_read` tinyint(1) NOT NULL DEFAULT 0,
  `sender_delete` tinyint(1) NOT NULL DEFAULT 0,
  `receiver_delete` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `playable_categories`
--

CREATE TABLE `playable_categories` (
  `user_id` int(11) NOT NULL,
  `team_categories_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `rate`
--

CREATE TABLE `rate` (
  `id` int(2) NOT NULL,
  `name` varchar(15) CHARACTER SET utf8 NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Άδειασμα δεδομένων του πίνακα `rate`
--

INSERT INTO `rate` (`id`, `name`, `active`) VALUES
(1, '⭐', 0),
(2, '⭐⭐', 0),
(3, '⭐⭐⭐', 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `restriction`
--

CREATE TABLE `restriction` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `time_from` time NOT NULL,
  `time_to` time NOT NULL,
  `date` date NOT NULL,
  `register_timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `deletable` tinyint(1) DEFAULT 0,
  `comment` varchar(255) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `team`
--

CREATE TABLE `team` (
  `id` int(11) NOT NULL,
  `name` varchar(30) CHARACTER SET utf8 NOT NULL,
  `category` int(3) NOT NULL,
  `total_games` int(3) NOT NULL DEFAULT 0,
  `wins` int(3) NOT NULL DEFAULT 0,
  `loses` int(3) NOT NULL DEFAULT 0,
  `points` int(3) NOT NULL DEFAULT 0,
  `team_group` int(2) NOT NULL DEFAULT 0,
  `active` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `team_categories`
--

CREATE TABLE `team_categories` (
  `id` int(3) NOT NULL,
  `name` varchar(30) CHARACTER SET utf8 NOT NULL,
  `active` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Άδειασμα δεδομένων του πίνακα `team_categories`
--

INSERT INTO `team_categories` (`id`, `name`, `active`) VALUES
(1, 'A Ανδρών', 0),
(2, 'B Ανδρών', 0),
(3, 'Γυναικών', 0),
(4, 'Εφήβων', 0),
(5, 'Νεανίδων', 0),
(7, 'Παίδων', 0),
(8, 'Κορασίδων', 0),
(9, 'ΕΘΝΙΚΑ', 1);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `team_groups`
--

CREATE TABLE `team_groups` (
  `id` int(2) NOT NULL,
  `name` varchar(50) NOT NULL,
  `active` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Άδειασμα δεδομένων του πίνακα `team_groups`
--

INSERT INTO `team_groups` (`id`, `name`, `active`) VALUES
(0, 'Κανένας', 0),
(1, 'A - Όμιλος', 0),
(2, 'B - Όμιλος', 0),
(3, 'Γ - Όμιλος', 0),
(4, 'Δ - Όμιλος', 0),
(15, 'D', 1);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(15) CHARACTER SET utf8 NOT NULL,
  `password` char(60) CHARACTER SET utf8 NOT NULL,
  `name` varchar(15) CHARACTER SET utf8 NOT NULL,
  `surname` varchar(15) CHARACTER SET utf8 NOT NULL,
  `email` varchar(30) CHARACTER SET utf8 NOT NULL,
  `phone` varchar(15) CHARACTER SET utf8 NOT NULL,
  `driving_licence` enum('0','1') CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `living_place` int(11) DEFAULT NULL,
  `profession` int(2) NOT NULL,
  `profile_pic` varchar(100) CHARACTER SET utf8 NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `rate` int(2) NOT NULL,
  `language` enum('en','gr') CHARACTER SET utf8 NOT NULL DEFAULT 'gr',
  `polling_time` tinyint(3) NOT NULL DEFAULT 20,
  `password_recovery_url` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `mobile_token` varchar(200) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Άδειασμα δεδομένων του πίνακα `user`
--

INSERT INTO `user` (`id`, `username`, `password`, `name`, `surname`, `email`, `phone`, `driving_licence`, `living_place`, `profession`, `profile_pic`, `active`, `rate`, `language`, `polling_time`, `password_recovery_url`, `mobile_token`) VALUES
(29, 'admin', '$2y$10$09XHC4hZlHod3SS/B41FUeNM7WCrfSsQ1oGcHOikRVBNGkVm20ZBa', 'Admin', 'Admin', 'my_mail@yahoo.com', '0123456789', '0', 1, 1, 'assets/img/users/Sekvce5XhWBPKGoYFoDR', 0, 2, 'gr', 20, NULL, ''),
(156, 'user', '$2y$10$V7uwFaCdRBWXuNeN0cnuG.fBad8ISY38JTEoUWX3rHgyKkQjqFZUi', 'User', 'User', 'it_support@gmail.com', '2020', '1', 1, 10, 'assets/img/users/aUi6OUZisWh0KIb6ewgL', 0, 3, 'gr', 20, '', NULL);

--
-- Δείκτες `user`
--
DELIMITER $$
CREATE TRIGGER `user_update_history` BEFORE UPDATE ON `user` FOR EACH ROW BEGIN
INSERT INTO user_update_history
SET id=DEFAULT,
user_id=OLD.id,
username = OLD.username	,
password = OLD.password	,
name=OLD.name,
surname=OLD.surname,
living_place=OLD.living_place,
email=OLD.email,
phone=OLD.phone,
driving_licence=OLD.driving_licence,
profession=OLD.profession,
profile_pic=OLD.profile_pic,
active=OLD.active,
rate=OLD.rate,
update_time = NOW();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `user_categories`
--

CREATE TABLE `user_categories` (
  `id` int(2) NOT NULL,
  `name` varchar(15) CHARACTER SET utf8 NOT NULL,
  `active` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Άδειασμα δεδομένων του πίνακα `user_categories`
--

INSERT INTO `user_categories` (`id`, `name`, `active`) VALUES
(1, 'Admin', 0),
(10, 'IT Support', 0);

-- --------------------------------------------------------

--
-- Δομή πίνακα για τον πίνακα `user_update_history`
--

CREATE TABLE `user_update_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `username` varchar(15) CHARACTER SET utf8 NOT NULL,
  `password` char(60) CHARACTER SET utf8 NOT NULL,
  `name` varchar(15) CHARACTER SET utf8 NOT NULL,
  `surname` varchar(15) CHARACTER SET utf8 NOT NULL,
  `email` varchar(30) CHARACTER SET utf8 NOT NULL,
  `phone` varchar(15) CHARACTER SET utf8 NOT NULL,
  `driving_licence` tinyint(2) NOT NULL,
  `living_place` int(11) NOT NULL,
  `profession` int(2) NOT NULL,
  `profile_pic` varchar(100) CHARACTER SET utf8 NOT NULL,
  `active` tinyint(1) NOT NULL,
  `rate` int(2) NOT NULL,
  `update_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Ευρετήρια για άχρηστους πίνακες
--

--
-- Ευρετήρια για πίνακα `announcement`
--
ALTER TABLE `announcement`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Ευρετήρια για πίνακα `apk_version`
--
ALTER TABLE `apk_version`
  ADD PRIMARY KEY (`id`);

--
-- Ευρετήρια για πίνακα `city`
--
ALTER TABLE `city`
  ADD PRIMARY KEY (`id`);

--
-- Ευρετήρια για πίνακα `court`
--
ALTER TABLE `court`
  ADD PRIMARY KEY (`id`),
  ADD KEY `city` (`city`);

--
-- Ευρετήρια για πίνακα `game`
--
ALTER TABLE `game`
  ADD PRIMARY KEY (`id`),
  ADD KEY `court_id` (`court_id`),
  ADD KEY `team_id_1` (`team_id_1`),
  ADD KEY `team_id_2` (`team_id_2`);

--
-- Ευρετήρια για πίνακα `human_power`
--
ALTER TABLE `human_power`
  ADD PRIMARY KEY (`game_id`,`user_id`) USING BTREE,
  ADD KEY `user_id` (`user_id`,`game_id`) USING BTREE;

--
-- Ευρετήρια για πίνακα `login_history`
--
ALTER TABLE `login_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Ευρετήρια για πίνακα `message`
--
ALTER TABLE `message`
  ADD PRIMARY KEY (`id`),
  ADD KEY `receiver_id` (`receiver_id`),
  ADD KEY `sender_id` (`sender_id`);

--
-- Ευρετήρια για πίνακα `playable_categories`
--
ALTER TABLE `playable_categories`
  ADD PRIMARY KEY (`user_id`,`team_categories_id`) USING BTREE,
  ADD KEY `team_categories` (`team_categories_id`,`user_id`) USING BTREE;

--
-- Ευρετήρια για πίνακα `rate`
--
ALTER TABLE `rate`
  ADD PRIMARY KEY (`id`);

--
-- Ευρετήρια για πίνακα `restriction`
--
ALTER TABLE `restriction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Ευρετήρια για πίνακα `team`
--
ALTER TABLE `team`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category` (`category`),
  ADD KEY `group` (`team_group`);

--
-- Ευρετήρια για πίνακα `team_categories`
--
ALTER TABLE `team_categories`
  ADD PRIMARY KEY (`id`);

--
-- Ευρετήρια για πίνακα `team_groups`
--
ALTER TABLE `team_groups`
  ADD PRIMARY KEY (`id`);

--
-- Ευρετήρια για πίνακα `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `profession` (`profession`),
  ADD KEY `living_place` (`living_place`),
  ADD KEY `rate` (`rate`);

--
-- Ευρετήρια για πίνακα `user_categories`
--
ALTER TABLE `user_categories`
  ADD PRIMARY KEY (`id`);

--
-- Ευρετήρια για πίνακα `user_update_history`
--
ALTER TABLE `user_update_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT για άχρηστους πίνακες
--

--
-- AUTO_INCREMENT για πίνακα `announcement`
--
ALTER TABLE `announcement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT για πίνακα `apk_version`
--
ALTER TABLE `apk_version`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT για πίνακα `city`
--
ALTER TABLE `city`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT για πίνακα `court`
--
ALTER TABLE `court`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT για πίνακα `game`
--
ALTER TABLE `game`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT για πίνακα `login_history`
--
ALTER TABLE `login_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT για πίνακα `message`
--
ALTER TABLE `message`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT για πίνακα `rate`
--
ALTER TABLE `rate`
  MODIFY `id` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT για πίνακα `restriction`
--
ALTER TABLE `restriction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT για πίνακα `team`
--
ALTER TABLE `team`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT για πίνακα `team_categories`
--
ALTER TABLE `team_categories`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT για πίνακα `team_groups`
--
ALTER TABLE `team_groups`
  MODIFY `id` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT για πίνακα `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=157;

--
-- AUTO_INCREMENT για πίνακα `user_categories`
--
ALTER TABLE `user_categories`
  MODIFY `id` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT για πίνακα `user_update_history`
--
ALTER TABLE `user_update_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Περιορισμοί για άχρηστους πίνακες
--

--
-- Περιορισμοί για πίνακα `announcement`
--
ALTER TABLE `announcement`
  ADD CONSTRAINT `announcement_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Περιορισμοί για πίνακα `court`
--
ALTER TABLE `court`
  ADD CONSTRAINT `court_ibfk_1` FOREIGN KEY (`city`) REFERENCES `city` (`id`);

--
-- Περιορισμοί για πίνακα `game`
--
ALTER TABLE `game`
  ADD CONSTRAINT `game_ibfk_4` FOREIGN KEY (`team_id_1`) REFERENCES `team` (`id`),
  ADD CONSTRAINT `game_ibfk_5` FOREIGN KEY (`team_id_2`) REFERENCES `team` (`id`),
  ADD CONSTRAINT `game_ibfk_6` FOREIGN KEY (`court_id`) REFERENCES `court` (`id`);

--
-- Περιορισμοί για πίνακα `human_power`
--
ALTER TABLE `human_power`
  ADD CONSTRAINT `human_power_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`),
  ADD CONSTRAINT `human_power_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Περιορισμοί για πίνακα `login_history`
--
ALTER TABLE `login_history`
  ADD CONSTRAINT `login_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Περιορισμοί για πίνακα `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `message_ibfk_1` FOREIGN KEY (`receiver_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `message_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `user` (`id`);

--
-- Περιορισμοί για πίνακα `playable_categories`
--
ALTER TABLE `playable_categories`
  ADD CONSTRAINT `playable_categories_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `playable_categories_ibfk_2` FOREIGN KEY (`team_categories_id`) REFERENCES `team_categories` (`id`);

--
-- Περιορισμοί για πίνακα `restriction`
--
ALTER TABLE `restriction`
  ADD CONSTRAINT `restriction_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Περιορισμοί για πίνακα `team`
--
ALTER TABLE `team`
  ADD CONSTRAINT `team_ibfk_1` FOREIGN KEY (`category`) REFERENCES `team_categories` (`id`),
  ADD CONSTRAINT `team_ibfk_2` FOREIGN KEY (`team_group`) REFERENCES `team_groups` (`id`);

--
-- Περιορισμοί για πίνακα `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`profession`) REFERENCES `user_categories` (`id`),
  ADD CONSTRAINT `user_ibfk_2` FOREIGN KEY (`living_place`) REFERENCES `city` (`id`),
  ADD CONSTRAINT `user_ibfk_3` FOREIGN KEY (`rate`) REFERENCES `rate` (`id`);

--
-- Περιορισμοί για πίνακα `user_update_history`
--
ALTER TABLE `user_update_history`
  ADD CONSTRAINT `user_update_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;