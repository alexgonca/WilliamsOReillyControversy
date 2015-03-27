CREATE TABLE `mediacloud_stories` (
  `stories_id` varchar(10) CHARACTER SET utf8 NOT NULL,
  `media_id` mediumint(9) DEFAULT NULL,
  `media_name` varchar(300) CHARACTER SET utf8 DEFAULT NULL,
  `media_url` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `full_text_rss` smallint(6) DEFAULT NULL,
  `description` longtext,
  `language` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `url` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `title` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `processed_stories_id` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `guid` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `db_row_last_updated` datetime DEFAULT NULL,
  `collect_date` datetime DEFAULT NULL,
  `facebook_url` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `normalized_url` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `click_count` int(10) unsigned DEFAULT NULL,
  `comment_count` int(10) unsigned DEFAULT NULL,
  `comments_fbid` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `commentsbox_count` int(10) unsigned DEFAULT NULL,
  `like_count` int(10) unsigned DEFAULT NULL,
  `share_count` int(10) unsigned DEFAULT NULL,
  `total_count` int(11) DEFAULT NULL,
  `aggregate` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `active` tinyint(4) DEFAULT '1',
  `comment` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `query` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`stories_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `google` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `title` varchar(150) DEFAULT NULL,
  `blurb` varchar(500) DEFAULT NULL,
  `ranking` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `query` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `facebook_url` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `normalized_url` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `click_count` int(10) unsigned DEFAULT NULL,
  `comment_count` int(10) unsigned DEFAULT NULL,
  `comments_fbid` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `commentsbox_count` int(10) unsigned DEFAULT NULL,
  `like_count` int(10) unsigned DEFAULT NULL,
  `share_count` int(10) unsigned DEFAULT NULL,
  `total_count` int(11) DEFAULT NULL,
  `aggregate` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `active` tinyint(4) DEFAULT '0',
  `comment` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=120410 DEFAULT CHARSET=utf8mb4;

CREATE OR REPLACE VIEW `WilliamsOReilly` AS
select `google`.`normalized_url` AS `url`,
    `google`.`title` AS `title`,
    `google`.`total_count` AS `total_count`,
    `google`.`comment_count` AS `comment_count`,
    `google`.`like_count` AS `like_count`,
    `google`.`share_count` AS `share_count`,
    `google`.`date` AS `date`,
    'google' AS `type_url`
from `google`
where `google`.`query` like '%o\'reilly%' or `google`.`query` like '%williams%'
union
select `mediacloud_stories`.`normalized_url` AS `url`,
    `mediacloud_stories`.`title` AS `title`,
    `mediacloud_stories`.`total_count` AS `total_count`,
    `mediacloud_stories`.`comment_count` AS `comment_count`,
    `mediacloud_stories`.`like_count` AS `like_count`,
    `mediacloud_stories`.`share_count` AS `share_count`,
    `mediacloud_stories`.`publish_date` AS `date`,
    'mediacloud' AS `type_url`
from `mediacloud_stories`
where `mediacloud_stories`.`query` = 'WilliamsOReilly';

CREATE OR REPLACE VIEW `WilliamsOReilly_norepetition` as
select `url`,
    max(`title`) as title,
    max(`total_count`) as total_count,
    max(`comment_count`) as comment_count,
    max(`like_count`) as like_count,
    max(`share_count`) as share_count,
    max(`date`) as date,
    max(`type_url`) as type_url
from williamsoreilly
group by url;