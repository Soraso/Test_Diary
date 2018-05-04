CREATE TABLE user(
	`user_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`name` VARBINARY(32) NOT NULL,
	`created` TIMESTAMP NOT NULL,
	PRIMARY KEY (user_id),
	UNIQUE KEY (name),
	KEY (created)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE diary(
	`diary_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`user_id` BIGINT Not NULL,
	`diary_name` VARCHAR(256) NOT NULL,
	`created` TIMESTAMP NOT NULL,
	
	PRIMARY KEY (diary_id),
	UNIQUE KEY (diary_name),
	KEY (user_id)
	
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE entry(
	`entry_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`diary_id` BIGINT NOT NULL,
	`title` VARCHAR(512) NOT NULL,
	`entry_body` VARCHAR(512) NOT NULL,
	`created` TIMESTAMP NOT NULL,
	`updated` TIMESTAMP NOT NULL,
	PRIMARY KEY (entry_id),
	KEY (created),
	KEY (updated)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE friend(
	`friend_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`user_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`created` TIMESTAMP NOT NULL,
	PRIMARY KEY (friend_id),
	UNIQUE KEY (user_id),
	KEY(user_id, created)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;