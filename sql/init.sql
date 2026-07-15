-- 식물집사 DB 초기화 스크립트
-- MySQL 5.7.44

CREATE DATABASE IF NOT EXISTS plantcare
	DEFAULT CHARACTER SET utf8mb4
	DEFAULT COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'plantcare'@'localhost' IDENTIFIED BY 'plantcare';
GRANT ALL PRIVILEGES ON plantcare.* TO 'plantcare'@'localhost';
FLUSH PRIVILEGES;

USE plantcare;

-- 1. plant_info — API 식물 정보 캐시
CREATE TABLE IF NOT EXISTS plant_info (
	cntnts_no    VARCHAR(50)  PRIMARY KEY,
	plant_name   VARCHAR(200),
	plant_sci_name VARCHAR(200),
	plant_eng_name VARCHAR(200),
	distb_nm     VARCHAR(200),
	image_url    VARCHAR(500),
	water_spring VARCHAR(10),
	water_summer VARCHAR(10),
	water_autumn VARCHAR(10),
	water_winter VARCHAR(10),
	manage_level VARCHAR(50),
	growth_info  TEXT,
	is_manual    CHAR(1) DEFAULT 'N',
	reg_date     DATETIME DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. my_plant — 사용자 등록 식물
CREATE TABLE IF NOT EXISTS my_plant (
	plant_no           INT AUTO_INCREMENT PRIMARY KEY,
	user_id            VARCHAR(50) DEFAULT 'default',
	cntnts_no          VARCHAR(50),
	nickname           VARCHAR(100) NOT NULL,
	photo_path         VARCHAR(500),
	user_water_interval INT NULL,
	last_water_date    DATE,
	reg_date           DATETIME DEFAULT NOW(),
	del_yn             CHAR(1) DEFAULT 'N',
	INDEX idx_my_plant_user_id (user_id),
	FOREIGN KEY (cntnts_no) REFERENCES plant_info(cntnts_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. watering_log — 간편체크 기록
CREATE TABLE IF NOT EXISTS watering_log (
	log_no     INT AUTO_INCREMENT PRIMARY KEY,
	plant_no   INT,
	water_date DATE,
	reg_date   DATETIME DEFAULT NOW(),
	INDEX idx_watering_log_plant_date (plant_no, water_date DESC),
	FOREIGN KEY (plant_no) REFERENCES my_plant(plant_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
