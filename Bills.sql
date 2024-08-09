CREATE TABLE IF NOT EXISTS `bills` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `amount` DECIMAL(10,2) NOT NULL,
    `reason` VARCHAR(255) NOT NULL,
    `sender_cid` VARCHAR(50) NOT NULL,
    `receiver_cid` VARCHAR(50) NOT NULL,
    `date` VARCHAR(10) NOT NULL,
    `time` VARCHAR(8) NOT NULL,
    `paid` BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (`id`)
);
