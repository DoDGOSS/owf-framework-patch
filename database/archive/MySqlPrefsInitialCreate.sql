--  *********************************************************************
--  Update Database Script
--  *********************************************************************
--  Change Log: changelog.groovy
--  Ran at: 8/21/15 4:27 PM
--  Against: owf_admin@localhost@jdbc:mysql://localhost:3306/owf
--  Liquibase version: 2.0.5
--  *********************************************************************

--  Create Database Lock Table
CREATE TABLE `DATABASECHANGELOGLOCK` (`ID` INT NOT NULL, `LOCKED` TINYINT(1) NOT NULL, `LOCKGRANTED` DATETIME NULL, `LOCKEDBY` VARCHAR(255) NULL, CONSTRAINT `PK_DATABASECHANGELOGLOCK` PRIMARY KEY (`ID`)) ENGINE=InnoDB;

INSERT INTO `DATABASECHANGELOGLOCK` (`ID`, `LOCKED`) VALUES (1, 0);

--  Lock Database
--  Create Database Change Log Table
CREATE TABLE `DATABASECHANGELOG` (`ID` VARCHAR(63) NOT NULL, `AUTHOR` VARCHAR(63) NOT NULL, `FILENAME` VARCHAR(200) NOT NULL, `DATEEXECUTED` DATETIME NOT NULL, `ORDEREXECUTED` INT NOT NULL, `EXECTYPE` VARCHAR(10) NOT NULL, `MD5SUM` VARCHAR(35) NULL, `DESCRIPTION` VARCHAR(255) NULL, `COMMENTS` VARCHAR(255) NULL, `TAG` VARCHAR(255) NULL, `LIQUIBASE` VARCHAR(20) NULL, CONSTRAINT `PK_DATABASECHANGELOG` PRIMARY KEY (`ID`, `AUTHOR`, `FILENAME`)) ENGINE=InnoDB;

--  Changeset changelog_3.7.0.groovy::3.7.0-1::owf::(Checksum: 3:3cf00281bcd7806ea16b7fb7703f84c6)
create table dashboard (id bigint not null auto_increment, version bigint not null, isdefault bit not null, dashboard_position integer not null, altered_by_admin bit not null, guid varchar(255) not null unique, column_count integer not null, layout varchar(9) not null, name varchar(200) not null, user_id bigint not null, primary key (id)) ENGINE=InnoDB;

create table dashboard_widget_state (id bigint not null auto_increment, version bigint not null, region varchar(15) not null, button_opened bit not null, z_index integer not null, person_widget_definition_id bigint, minimized bit not null, unique_id varchar(255) not null unique, height integer not null, pinned bit not null, name varchar(200) not null, widget_guid varchar(255), column_pos integer not null, width integer not null, button_id varchar(255), collapsed bit not null, maximized bit not null, state_position integer not null, active bit not null, dashboard_id bigint not null, y integer not null, x integer not null, primary key (id)) ENGINE=InnoDB;

create table domain_mapping (id bigint not null auto_increment, version bigint not null, src_id bigint not null, src_type varchar(255) not null, relationship_type varchar(8), dest_id bigint not null, dest_type varchar(255) not null, primary key (id)) ENGINE=InnoDB;

create table eventing_connections (id bigint not null auto_increment, version bigint not null, dashboard_widget_state_id bigint not null, widget_guid varchar(255) not null, eventing_connections_idx integer, primary key (id)) ENGINE=InnoDB;

create table owf_group (id bigint not null auto_increment, version bigint not null, status varchar(8) not null, email varchar(255), description varchar(255), name varchar(200) not null, automatic bit not null, primary key (id)) ENGINE=InnoDB;

create table owf_group_people (person_id bigint not null, group_id bigint not null, primary key (group_id, person_id)) ENGINE=InnoDB;

create table person (id bigint not null auto_increment, version bigint not null, enabled bit not null, user_real_name varchar(200) not null, username varchar(200) not null unique, last_login datetime, email_show bit not null, email varchar(255), prev_login datetime, description varchar(255), primary key (id)) ENGINE=InnoDB;

create table person_widget_definition (id bigint not null auto_increment, version bigint not null, person_id bigint not null, visible bit not null, pwd_position integer not null, widget_definition_id bigint not null, primary key (id), unique (person_id, widget_definition_id)) ENGINE=InnoDB;

create table preference (id bigint not null auto_increment, version bigint not null, value longtext not null, path varchar(200) not null, user_id bigint not null, namespace varchar(200) not null, primary key (id), unique (path, namespace, user_id)) ENGINE=InnoDB;

create table requestmap (id bigint not null auto_increment, version bigint not null, url varchar(255) not null unique, config_attribute varchar(255) not null, primary key (id)) ENGINE=InnoDB;

create table role (id bigint not null auto_increment, version bigint not null, authority varchar(255) not null unique, description varchar(255) not null, primary key (id)) ENGINE=InnoDB;

create table role_people (person_id bigint not null, role_id bigint not null, primary key (role_id, person_id)) ENGINE=InnoDB;

create table tag_links (id bigint not null auto_increment, version bigint not null, pos bigint, visible bit, tag_ref bigint not null, tag_id bigint not null, type varchar(255) not null, editable bit, primary key (id)) ENGINE=InnoDB;

create table tags (id bigint not null auto_increment, version bigint not null, name varchar(255) not null unique, primary key (id)) ENGINE=InnoDB;

create table widget_definition (id bigint not null auto_increment, version bigint not null, visible bit not null, image_url_large varchar(2083) not null, image_url_small varchar(2083) not null, singleton bit not null, width integer not null, widget_version varchar(2083) not null, height integer not null, widget_url varchar(2083) not null, widget_guid varchar(255) not null unique, display_name varchar(200) not null, primary key (id)) ENGINE=InnoDB;

alter table dashboard add index FKC18AEA948656347D (user_id), add constraint FKC18AEA948656347D foreign key (user_id) references person (id);

alter table dashboard_widget_state add index FKB6440EA192BD68BB (person_widget_definition_id), add constraint FKB6440EA192BD68BB foreign key (person_widget_definition_id) references person_widget_definition (id);

alter table dashboard_widget_state add index FKB6440EA1CA944B81 (dashboard_id), add constraint FKB6440EA1CA944B81 foreign key (dashboard_id) references dashboard (id);

alter table eventing_connections add index FKBCC1569EB20FFC4B (dashboard_widget_state_id), add constraint FKBCC1569EB20FFC4B foreign key (dashboard_widget_state_id) references dashboard_widget_state (id);

alter table owf_group_people add index FK2811370C1F5E0B3 (person_id), add constraint FK2811370C1F5E0B3 foreign key (person_id) references person (id);

alter table owf_group_people add index FK28113703B197B21 (group_id), add constraint FK28113703B197B21 foreign key (group_id) references owf_group (id);

alter table person_widget_definition add index FK6F5C17C4C1F5E0B3 (person_id), add constraint FK6F5C17C4C1F5E0B3 foreign key (person_id) references person (id);

alter table person_widget_definition add index FK6F5C17C4293A835C (widget_definition_id), add constraint FK6F5C17C4293A835C foreign key (widget_definition_id) references widget_definition (id);

alter table preference add index FKA8FCBCDB8656347D (user_id), add constraint FKA8FCBCDB8656347D foreign key (user_id) references person (id);

alter table role_people add index FK28B75E78C1F5E0B3 (person_id), add constraint FK28B75E78C1F5E0B3 foreign key (person_id) references person (id);

alter table role_people add index FK28B75E7870B353 (role_id), add constraint FK28B75E7870B353 foreign key (role_id) references role (id);

alter table tag_links add index FK7C35D6D45A3B441D (tag_id), add constraint FK7C35D6D45A3B441D foreign key (tag_id) references tags (id);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Custom SQL', 'EXECUTED', 'changelog_3.7.0.groovy', '3.7.0-1', '2.0.5', '3:3cf00281bcd7806ea16b7fb7703f84c6', 1);

--  Changeset changelog_3.8.0.groovy::3.8.0-1::owf::(Checksum: 3:e3e4161aea2784490b697128b6c83920)
ALTER TABLE `dashboard` MODIFY `user_id` BIGINT NULL;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Drop Not-Null Constraint', 'EXECUTED', 'changelog_3.8.0.groovy', '3.8.0-1', '2.0.5', '3:e3e4161aea2784490b697128b6c83920', 2);

--  Changeset changelog_3.8.0.groovy::3.8.0-2::owf::(Checksum: 3:43600e1eebd0b612def9a76758daa403)
--  Added description column into Dashboard Table
ALTER TABLE `dashboard` ADD `description` VARCHAR(255);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Added description column into Dashboard Table', NOW(), 'Add Column', 'EXECUTED', 'changelog_3.8.0.groovy', '3.8.0-2', '2.0.5', '3:43600e1eebd0b612def9a76758daa403', 3);

--  Changeset changelog_3.8.0.groovy::3.8.0-3::owf::(Checksum: 3:cd0a0df59ba7079055230181279b9fe5)
ALTER TABLE `dashboard` ADD `created_by_id` BIGINT;

ALTER TABLE `dashboard` ADD `created_date` DATETIME;

ALTER TABLE `dashboard` ADD `edited_by_id` BIGINT;

ALTER TABLE `dashboard` ADD `edited_date` DATETIME;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Add Column', 'EXECUTED', 'changelog_3.8.0.groovy', '3.8.0-3', '2.0.5', '3:cd0a0df59ba7079055230181279b9fe5', 4);

--  Changeset changelog_3.8.0.groovy::3.8.0-4::owf::(Checksum: 3:b98ec98220fc4669acb11cc65cba959b)
ALTER TABLE `dashboard` ADD CONSTRAINT `FKC18AEA94372CC5A` FOREIGN KEY (`created_by_id`) REFERENCES `person` (`id`);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Add Foreign Key Constraint', 'EXECUTED', 'changelog_3.8.0.groovy', '3.8.0-4', '2.0.5', '3:b98ec98220fc4669acb11cc65cba959b', 5);

--  Changeset changelog_3.8.0.groovy::3.8.0-5::owf::(Checksum: 3:30cd6eb8e32c5bb622cd48a6730e86e1)
ALTER TABLE `dashboard` ADD CONSTRAINT `FKC18AEA947028B8DB` FOREIGN KEY (`edited_by_id`) REFERENCES `person` (`id`);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Add Foreign Key Constraint', 'EXECUTED', 'changelog_3.8.0.groovy', '3.8.0-5', '2.0.5', '3:30cd6eb8e32c5bb622cd48a6730e86e1', 6);

--  Changeset changelog_3.8.0.groovy::3.8.0-9::owf::(Checksum: 3:b8bfb871d46a61e853fbe3c16f5f3941)
ALTER TABLE `widget_definition` MODIFY `widget_version` VARCHAR(2083) NULL;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Drop Not-Null Constraint', 'EXECUTED', 'changelog_3.8.0.groovy', '3.8.0-9', '2.0.5', '3:b8bfb871d46a61e853fbe3c16f5f3941', 7);

--  Changeset changelog_4.0.0.groovy::4.0.0-3::owf::(Checksum: 3:d066b39ebec901b63dbe5b674825449d)
--  Added defaultSettings column into Dashboard Table
ALTER TABLE `dashboard` ADD `default_settings` LONGTEXT;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Added defaultSettings column into Dashboard Table', NOW(), 'Add Column', 'EXECUTED', 'changelog_4.0.0.groovy', '4.0.0-3', '2.0.5', '3:d066b39ebec901b63dbe5b674825449d', 8);

--  Changeset changelog_4.0.0.groovy::4.0.0-4::owf::(Checksum: 3:c4ccbcf8a10f33b5063af97a9d15d28c)
--  Added background column for WidgetDefinition
ALTER TABLE `widget_definition` ADD `background` TINYINT(1);

UPDATE `widget_definition` SET `background` = 0;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Added background column for WidgetDefinition', NOW(), 'Add Column', 'EXECUTED', 'changelog_4.0.0.groovy', '4.0.0-4', '2.0.5', '3:c4ccbcf8a10f33b5063af97a9d15d28c', 9);

--  Changeset changelog_4.0.0.groovy::4.0.0-47::owf::(Checksum: 3:967a5a6cb7f1d94dfef9beb90b77e1e5)
--  Added showLaunchMenu column into Dashboard Table
ALTER TABLE `dashboard` ADD `show_launch_menu` TINYINT(1) DEFAULT 0;

UPDATE `dashboard` SET `show_launch_menu` = 0;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Added showLaunchMenu column into Dashboard Table', NOW(), 'Add Column', 'EXECUTED', 'changelog_4.0.0.groovy', '4.0.0-47', '2.0.5', '3:967a5a6cb7f1d94dfef9beb90b77e1e5', 10);

--  Changeset changelog_4.0.0.groovy::4.0.0-48::owf::(Checksum: 3:43eac589305fd819d29fe84a43414c3f)
--  Create widget type table and linking table
CREATE TABLE `widget_type` (`id` BIGINT AUTO_INCREMENT NOT NULL, `version` BIGINT NOT NULL, `name` VARCHAR(255) NOT NULL, CONSTRAINT `widget_typePK` PRIMARY KEY (`id`)) ENGINE=InnoDB;

CREATE TABLE `widget_definition_widget_types` (`widget_definition_id` BIGINT NOT NULL, `widget_type_id` BIGINT NOT NULL) ENGINE=InnoDB;

ALTER TABLE `widget_definition_widget_types` ADD PRIMARY KEY (`widget_definition_id`, `widget_type_id`);

ALTER TABLE `widget_definition_widget_types` ADD CONSTRAINT `FK8A59D92F293A835C` FOREIGN KEY (`widget_definition_id`) REFERENCES `widget_definition` (`id`);

ALTER TABLE `widget_definition_widget_types` ADD CONSTRAINT `FK8A59D92FD46C6F7C` FOREIGN KEY (`widget_type_id`) REFERENCES `widget_type` (`id`);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Create widget type table and linking table', NOW(), 'Create Table (x2), Add Primary Key, Add Foreign Key Constraint (x2)', 'EXECUTED', 'changelog_4.0.0.groovy', '4.0.0-48', '2.0.5', '3:43eac589305fd819d29fe84a43414c3f', 11);

--  Changeset changelog_4.0.0.groovy::4.0.0-51::owf::(Checksum: 3:dc8cf89d14b68c19d487908ef28c89b1)
--  Add widget types to table
INSERT INTO `widget_type` (`id`, `name`, `version`) VALUES (1, 'standard', 0);

INSERT INTO `widget_type` (`id`, `name`, `version`) VALUES (2, 'administration', 0);

INSERT INTO `widget_type` (`id`, `name`, `version`) VALUES (3, 'marketplace', 0);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add widget types to table', NOW(), 'Insert Row (x3)', 'EXECUTED', 'changelog_4.0.0.groovy', '4.0.0-51', '2.0.5', '3:dc8cf89d14b68c19d487908ef28c89b1', 12);

--  Changeset changelog_4.0.0.groovy::4.0.0-56::owf::(Checksum: 3:7e4d6568d91e79149f8b895501eb8579)
--  Updating display_name column to 256 chars
ALTER TABLE `widget_definition` MODIFY `display_name` VARCHAR(256);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Updating display_name column to 256 chars', NOW(), 'Modify data type', 'EXECUTED', 'changelog_4.0.0.groovy', '4.0.0-56', '2.0.5', '3:7e4d6568d91e79149f8b895501eb8579', 13);

--  Changeset changelog_5.0.0.groovy::5.0.0-1::owf::(Checksum: 3:42d9c4bdcdff38a4fbe40bd1ec78d9b1)
--  Add display name to group
ALTER TABLE `owf_group` ADD `display_name` VARCHAR(200);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add display name to group', NOW(), 'Add Column', 'EXECUTED', 'changelog_5.0.0.groovy', '5.0.0-1', '2.0.5', '3:42d9c4bdcdff38a4fbe40bd1ec78d9b1', 14);

--  Changeset changelog_5.0.0.groovy::5.0.0-3::owf::(Checksum: 3:aa2aca168ad6eaeea8509fd642d8c17b)
--  Add metric widget types to table
INSERT INTO `widget_type` (`id`, `name`, `version`) VALUES (4, 'metric', 0);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add metric widget types to table', NOW(), 'Insert Row', 'EXECUTED', 'changelog_5.0.0.groovy', '5.0.0-3', '2.0.5', '3:aa2aca168ad6eaeea8509fd642d8c17b', 15);

--  Changeset changelog_6.0.0.groovy::6.0.0-1::owf::(Checksum: 3:b7a17650e4cfde415fdbbcc4f2bd1317)
--  Add universal_name to widgetdefinition
ALTER TABLE `widget_definition` ADD `universal_name` VARCHAR(255);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add universal_name to widgetdefinition', NOW(), 'Add Column', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-1', '2.0.5', '3:b7a17650e4cfde415fdbbcc4f2bd1317', 16);

--  Changeset changelog_6.0.0.groovy::6.0.0-2::owf::(Checksum: 3:30ea4354058c7a09bfafb6acabfd1e33)
--  Add layoutConfig to dashboard
ALTER TABLE `dashboard` ADD `layout_config` LONGTEXT;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add layoutConfig to dashboard', NOW(), 'Add Column', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-2', '2.0.5', '3:30ea4354058c7a09bfafb6acabfd1e33', 17);

--  Changeset changelog_6.0.0.groovy::6.0.0-3::owf::(Checksum: 3:6ce1db42048bc63ece1be0c3f4669a52)
--  Add descriptor_url to widgetdefinition
ALTER TABLE `widget_definition` ADD `descriptor_url` VARCHAR(2083);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add descriptor_url to widgetdefinition', NOW(), 'Add Column', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-3', '2.0.5', '3:6ce1db42048bc63ece1be0c3f4669a52', 18);

--  Changeset changelog_6.0.0.groovy::6.0.0-4::owf::(Checksum: 3:4e940a0bdfea36b98c62330e4b373dd3)
--  Remove EventingConnections table and association with DashboardWidgetState
DROP TABLE `eventing_connections`;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Remove EventingConnections table and association with DashboardWidgetState', NOW(), 'Drop Table', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-4', '2.0.5', '3:4e940a0bdfea36b98c62330e4b373dd3', 19);

--  Changeset changelog_6.0.0.groovy::6.0.0-5::owf::(Checksum: 3:2c40b74eb7eb29a286ac641320a97b4d)
--  Create intent table
CREATE TABLE `intent` (`id` BIGINT AUTO_INCREMENT NOT NULL, `version` BIGINT NOT NULL, `action` VARCHAR(255) NOT NULL, CONSTRAINT `intentPK` PRIMARY KEY (`id`), UNIQUE (`action`)) ENGINE=InnoDB;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Create intent table', NOW(), 'Create Table', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-5', '2.0.5', '3:2c40b74eb7eb29a286ac641320a97b4d', 20);

--  Changeset changelog_6.0.0.groovy::6.0.0-6::owf::(Checksum: 3:008f636cf428abbd60459975d28e62a1)
--  Create intent_data_type table
CREATE TABLE `intent_data_type` (`id` BIGINT AUTO_INCREMENT NOT NULL, `version` BIGINT NOT NULL, `data_type` VARCHAR(255) NOT NULL, CONSTRAINT `intent_data_typePK` PRIMARY KEY (`id`)) ENGINE=InnoDB;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Create intent_data_type table', NOW(), 'Create Table', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-6', '2.0.5', '3:008f636cf428abbd60459975d28e62a1', 21);

--  Changeset changelog_6.0.0.groovy::6.0.0-7::owf::(Checksum: 3:b462f738ef9c30634a0a47d245d16a59)
--  Create intent_data_types table
CREATE TABLE `intent_data_types` (`intent_data_type_id` BIGINT NOT NULL, `intent_id` BIGINT NOT NULL) ENGINE=InnoDB;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Create intent_data_types table', NOW(), 'Create Table', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-7', '2.0.5', '3:b462f738ef9c30634a0a47d245d16a59', 22);

--  Changeset changelog_6.0.0.groovy::6.0.0-8::owf::(Checksum: 3:ee497899a41d5cc2798af5cfc277aecb)
--  Add foreign constraint for intent_data_type_id and intent_id in intent_data_types table
ALTER TABLE `intent_data_types` ADD CONSTRAINT `FK8A59132FD46C6FAA` FOREIGN KEY (`intent_data_type_id`) REFERENCES `intent_data_type` (`id`);

ALTER TABLE `intent_data_types` ADD CONSTRAINT `FK8A59D92FD46C6FAA` FOREIGN KEY (`intent_id`) REFERENCES `intent` (`id`);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add foreign constraint for intent_data_type_id and intent_id in intent_data_types table', NOW(), 'Add Foreign Key Constraint (x2)', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-8', '2.0.5', '3:ee497899a41d5cc2798af5cfc277aecb', 23);

--  Changeset changelog_6.0.0.groovy::6.0.0-9::owf::(Checksum: 3:8dda2a300eac867527577e37dabf3187)
--  Create widget_def_intent table
CREATE TABLE `widget_def_intent` (`id` BIGINT AUTO_INCREMENT NOT NULL, `version` BIGINT NOT NULL, `receive` TINYINT(1) NOT NULL, `send` TINYINT(1) NOT NULL, `intent_id` BIGINT NOT NULL, `widget_definition_id` BIGINT NOT NULL, CONSTRAINT `widget_def_intentPK` PRIMARY KEY (`id`)) ENGINE=InnoDB;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Create widget_def_intent table', NOW(), 'Create Table', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-9', '2.0.5', '3:8dda2a300eac867527577e37dabf3187', 24);

--  Changeset changelog_6.0.0.groovy::6.0.0-10::owf::(Checksum: 3:e5d364edc24ace7b9b89d3854bb70408)
--  Add foreign constraint for widget_definition_id in widget_def_intent table
ALTER TABLE `widget_def_intent` ADD CONSTRAINT `FK8A59D92FD46C6FAB` FOREIGN KEY (`widget_definition_id`) REFERENCES `widget_definition` (`id`);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add foreign constraint for widget_definition_id in widget_def_intent table', NOW(), 'Add Foreign Key Constraint', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-10', '2.0.5', '3:e5d364edc24ace7b9b89d3854bb70408', 25);

--  Changeset changelog_6.0.0.groovy::6.0.0-11::owf::(Checksum: 3:fcf69ebd060340afd1483c2f4588f456)
--  Add foreign constraint for intent_id in widget_definition_intent table
ALTER TABLE `widget_def_intent` ADD CONSTRAINT `FK8A59D92FD46C6FAC` FOREIGN KEY (`intent_id`) REFERENCES `intent` (`id`);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add foreign constraint for intent_id in widget_definition_intent table', NOW(), 'Add Foreign Key Constraint', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-11', '2.0.5', '3:fcf69ebd060340afd1483c2f4588f456', 26);

--  Changeset changelog_6.0.0.groovy::6.0.0-12::owf::(Checksum: 3:05c50cdf2e21818c6986e5ef2d8c9f50)
--  Create widget_def_intent_data_types table
CREATE TABLE `widget_def_intent_data_types` (`intent_data_type_id` BIGINT NOT NULL, `widget_definition_intent_id` BIGINT NOT NULL) ENGINE=InnoDB;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Create widget_def_intent_data_types table', NOW(), 'Create Table', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-12', '2.0.5', '3:05c50cdf2e21818c6986e5ef2d8c9f50', 27);

--  Changeset changelog_6.0.0.groovy::6.0.0-13::owf::(Checksum: 3:3250f92e3b85fec3db493d11b53445e2)
--  Add foreign constraint for intent_data_type_id and widget_definition_intent_id in widget_def_intent_data_types table
ALTER TABLE `widget_def_intent_data_types` ADD CONSTRAINT `FK8A59D92FD41A6FAD` FOREIGN KEY (`intent_data_type_id`) REFERENCES `intent_data_type` (`id`);

ALTER TABLE `widget_def_intent_data_types` ADD CONSTRAINT `FK8A59D92FD46C6FAD` FOREIGN KEY (`widget_definition_intent_id`) REFERENCES `widget_def_intent` (`id`);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add foreign constraint for intent_data_type_id and widget_definition_intent_id in widget_def_intent_data_types table', NOW(), 'Add Foreign Key Constraint (x2)', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-13', '2.0.5', '3:3250f92e3b85fec3db493d11b53445e2', 28);

--  Changeset changelog_6.0.0.groovy::6.0.0-14::owf::(Checksum: 3:897a5aa2802104b8f90bcde737c47002)
--  Add intentConfig column to dashboard table
ALTER TABLE `dashboard` ADD `intent_config` LONGTEXT;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add intentConfig column to dashboard table', NOW(), 'Add Column', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-14', '2.0.5', '3:897a5aa2802104b8f90bcde737c47002', 29);

--  Changeset changelog_6.0.0.groovy::6.0.0-15::owf::(Checksum: 3:a58c7f9ab7dcc8c733d3a16c25adc558)
--  Added description column into Widget Definition table
ALTER TABLE `widget_definition` ADD `description` VARCHAR(255) DEFAULT '';

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Added description column into Widget Definition table', NOW(), 'Add Column', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-15', '2.0.5', '3:a58c7f9ab7dcc8c733d3a16c25adc558', 30);

--  Changeset changelog_6.0.0.groovy::6.0.0-16::owf::(Checksum: 3:9624d22cdbed36b5bbce5da92bdb1bfc)
--  Add groupWidget property to personwidgetdefinition
ALTER TABLE `person_widget_definition` ADD `group_widget` TINYINT(1) DEFAULT 0;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add groupWidget property to personwidgetdefinition', NOW(), 'Add Column', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-16', '2.0.5', '3:9624d22cdbed36b5bbce5da92bdb1bfc', 31);

--  Changeset changelog_6.0.0.groovy::6.0.0-17::owf::(Checksum: 3:92a97333d2f7b5f17e0a541712847a54)
--  Add favorite property to personwidgetdefinition
ALTER TABLE `person_widget_definition` ADD `favorite` TINYINT(1) DEFAULT 0;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add favorite property to personwidgetdefinition', NOW(), 'Add Column', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-17', '2.0.5', '3:92a97333d2f7b5f17e0a541712847a54', 32);

--  Changeset changelog_6.0.0.groovy::6.0.0-44::owf::(Checksum: 3:a0a7528d5494cd0f02b38b3f99b2cfe4)
ALTER TABLE `dashboard` MODIFY `layout` VARCHAR(9) NULL;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Drop Not-Null Constraint', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-44', '2.0.5', '3:a0a7528d5494cd0f02b38b3f99b2cfe4', 33);

--  Changeset changelog_6.0.0.groovy::6.0.0-53::owf::(Checksum: 3:9f398a44008d12aee688e347940b7adf)
--  Add locked property to dashboard
ALTER TABLE `dashboard` ADD `locked` TINYINT(1) DEFAULT 0;

UPDATE `dashboard` SET `locked` = 0;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add locked property to dashboard', NOW(), 'Add Column', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-53', '2.0.5', '3:9f398a44008d12aee688e347940b7adf', 34);

--  Changeset changelog_6.0.0.groovy::6.0.0-55::owf::(Checksum: 3:2aa790687f711ca1d930c1aa24fadd0c)
--  Add display name field to pwd
ALTER TABLE `person_widget_definition` ADD `display_name` VARCHAR(256);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add display name field to pwd', NOW(), 'Add Column', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-55', '2.0.5', '3:2aa790687f711ca1d930c1aa24fadd0c', 35);

--  Changeset changelog_6.0.0.groovy::6.0.0-56::owf::(Checksum: 3:ca86586d796b6e61467c6fc7cb0a787c)
--  Add disabled field to pwd
ALTER TABLE `person_widget_definition` ADD `disabled` TINYINT(1) DEFAULT 0;

UPDATE `person_widget_definition` SET `disabled` = 0;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add disabled field to pwd', NOW(), 'Add Column', 'EXECUTED', 'changelog_6.0.0.groovy', '6.0.0-56', '2.0.5', '3:ca86586d796b6e61467c6fc7cb0a787c', 36);

--  Changeset changelog_7.0.0.groovy::7.0.0-1::owf::(Checksum: 3:9c64b0b8b8cb507555f0c02c00cb382b)
--  Expand a widget definition's description field to 4000 to match Marketplace
ALTER TABLE `widget_definition` MODIFY `description` VARCHAR(4000);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Expand a widget definition''s description field to 4000 to match Marketplace', NOW(), 'Modify data type', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-1', '2.0.5', '3:9c64b0b8b8cb507555f0c02c00cb382b', 37);

--  Changeset changelog_7.0.0.groovy::7.0.0-2::owf::(Checksum: 3:d1ab9c56671573cf7cde5a4e7c13652c)
--  Remove DashboardWidgetState since it is no longer used.
DROP TABLE `dashboard_widget_state`;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Remove DashboardWidgetState since it is no longer used.', NOW(), 'Drop Table', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-2', '2.0.5', '3:d1ab9c56671573cf7cde5a4e7c13652c', 38);

--  Changeset changelog_7.0.0.groovy::7.0.0-4::owf::(Checksum: 3:21b5b103a5b9e7134b2bbb0a7686e3cf)
--  Remove show_launch_menu since it is no longer used.
ALTER TABLE `dashboard` DROP COLUMN `show_launch_menu`;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Remove show_launch_menu since it is no longer used.', NOW(), 'Drop Column', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-4', '2.0.5', '3:21b5b103a5b9e7134b2bbb0a7686e3cf', 39);

--  Changeset changelog_7.0.0.groovy::7.0.0-5::owf::(Checksum: 3:634c7ed646b89e253102d12b6818c245)
--  Remove layout since it is no longer used.
ALTER TABLE `dashboard` DROP COLUMN `layout`;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Remove layout since it is no longer used.', NOW(), 'Drop Column', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-5', '2.0.5', '3:634c7ed646b89e253102d12b6818c245', 40);

--  Changeset changelog_7.0.0.groovy::7.0.0-6::owf::(Checksum: 3:ef21c5e1a70b81160e2ed6989fc1afa6)
--  Remove intent_config since it is no longer used.
ALTER TABLE `dashboard` DROP COLUMN `intent_config`;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Remove intent_config since it is no longer used.', NOW(), 'Drop Column', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-6', '2.0.5', '3:ef21c5e1a70b81160e2ed6989fc1afa6', 41);

--  Changeset changelog_7.0.0.groovy::7.0.0-7::owf::(Checksum: 3:9ee1cd65b85caaca3178939bac1e0fcf)
--  Remove default_settings since it is no longer used.
ALTER TABLE `dashboard` DROP COLUMN `default_settings`;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Remove default_settings since it is no longer used.', NOW(), 'Drop Column', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-7', '2.0.5', '3:9ee1cd65b85caaca3178939bac1e0fcf', 42);

--  Changeset changelog_7.0.0.groovy::7.0.0-8::owf::(Checksum: 3:ef688a16b0055a8024a489393bcfc987)
--  Remove column_count since it is no longer used.
ALTER TABLE `dashboard` DROP COLUMN `column_count`;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Remove column_count since it is no longer used.', NOW(), 'Drop Column', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-8', '2.0.5', '3:ef688a16b0055a8024a489393bcfc987', 43);

--  Changeset changelog_7.0.0.groovy::7.0.0-9::owf::(Checksum: 3:43e9c996af93d8cface8845446b8a525)
--  Create stack table
CREATE TABLE `stack` (`id` BIGINT AUTO_INCREMENT NOT NULL, `version` BIGINT NOT NULL, `name` VARCHAR(256) NOT NULL, `description` VARCHAR(4000) NULL, `stack_context` VARCHAR(200) NOT NULL, `image_url` VARCHAR(2083) NULL, `descriptor_url` VARCHAR(2083) NULL, CONSTRAINT `stackPK` PRIMARY KEY (`id`), UNIQUE (`stack_context`)) ENGINE=InnoDB;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Create stack table', NOW(), 'Create Table', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-9', '2.0.5', '3:43e9c996af93d8cface8845446b8a525', 44);

--  Changeset changelog_7.0.0.groovy::7.0.0-10::owf::(Checksum: 3:62f6507a0ac6b50fb383b2a47ba702a8)
--  Create stack_groups table
CREATE TABLE `stack_groups` (`group_id` BIGINT NOT NULL, `stack_id` BIGINT NOT NULL) ENGINE=InnoDB;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Create stack_groups table', NOW(), 'Create Table', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-10', '2.0.5', '3:62f6507a0ac6b50fb383b2a47ba702a8', 45);

--  Changeset changelog_7.0.0.groovy::7.0.0-12::owf::(Checksum: 3:7a64e2e16d79e54338e9ec959602447a)
--  Add primary key constraint for group_id and stack_id in stack_groups table
ALTER TABLE `stack_groups` ADD PRIMARY KEY (`group_id`, `stack_id`);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add primary key constraint for group_id and stack_id in stack_groups table', NOW(), 'Add Primary Key', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-12', '2.0.5', '3:7a64e2e16d79e54338e9ec959602447a', 46);

--  Changeset changelog_7.0.0.groovy::7.0.0-13::owf::(Checksum: 3:0e9ce4f940d8f89b0fd983abc89ee775)
--  Add foreign key constraints for group_id and stack_id in stack_groups table
ALTER TABLE `stack_groups` ADD CONSTRAINT `FK9584AB6B6B3A1281` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`id`);

ALTER TABLE `stack_groups` ADD CONSTRAINT `FK9584AB6B3B197B21` FOREIGN KEY (`group_id`) REFERENCES `owf_group` (`id`);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add foreign key constraints for group_id and stack_id in stack_groups table', NOW(), 'Add Foreign Key Constraint (x2)', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-13', '2.0.5', '3:0e9ce4f940d8f89b0fd983abc89ee775', 47);

--  Changeset changelog_7.0.0.groovy::7.0.0-14::owf::(Checksum: 3:803b99533e3b4d760c15e2f1eca18e05)
--  Add stack_default field to group
ALTER TABLE `owf_group` ADD `stack_default` TINYINT(1) DEFAULT 0;

UPDATE `owf_group` SET `stack_default` = 0;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add stack_default field to group', NOW(), 'Add Column', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-14', '2.0.5', '3:803b99533e3b4d760c15e2f1eca18e05', 48);

--  Changeset changelog_7.0.0.groovy::7.0.0-15::owf::(Checksum: 3:76942320acfc0aa46ca2667795a3ac93)
--  Insert OWF stack
INSERT INTO `stack` (`description`, `image_url`, `name`, `stack_context`, `version`) VALUES ('OWF Stack', 'themes/common/images/owf.png', 'OWF', 'owf', 0);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Insert OWF stack', NOW(), 'Insert Row', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-15', '2.0.5', '3:76942320acfc0aa46ca2667795a3ac93', 49);

--  Changeset changelog_7.0.0.groovy::7.0.0-18::owf::(Checksum: 3:f0ee8e108606cf0faf3593499efc07bf)
--  Insert OWF stack default group
INSERT INTO `owf_group` (`automatic`, `name`, `stack_default`, `status`, `version`) VALUES (0, 'ce86a612-c355-486e-9c9e-5252553cc58e', 1, 'active', 0);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Insert OWF stack default group', NOW(), 'Insert Row', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-18', '2.0.5', '3:f0ee8e108606cf0faf3593499efc07bf', 50);

--  Changeset changelog_7.0.0.groovy::7.0.0-21::owf::(Checksum: 3:32c56c09a37ffceb75742132f42ddf73)
insert into stack_groups (stack_id, group_id) values ((select id from stack where name = 'OWF'), (select id from owf_group where name = 'ce86a612-c355-486e-9c9e-5252553cc58e'));

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Custom SQL', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-21', '2.0.5', '3:32c56c09a37ffceb75742132f42ddf73', 51);

--  Changeset changelog_7.0.0.groovy::7.0.0-22::owf::(Checksum: 3:7146f45f54d8db1d72abb498d691cebb)
--  Add a reference to a host stack to dashboard records to track where user instances should appear
ALTER TABLE `dashboard` ADD `stack_id` BIGINT;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add a reference to a host stack to dashboard records to track where user instances should appear', NOW(), 'Add Column', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-22', '2.0.5', '3:7146f45f54d8db1d72abb498d691cebb', 52);

--  Changeset changelog_7.0.0.groovy::7.0.0-23::owf::(Checksum: 3:4d6a39028c8a5cc0a85b8b37fbf1b1fc)
--  Add foreign key constraint for stack_id in the dashboard table
ALTER TABLE `dashboard` ADD CONSTRAINT `FKC18AEA946B3A1281` FOREIGN KEY (`stack_id`) REFERENCES `stack` (`id`);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add foreign key constraint for stack_id in the dashboard table', NOW(), 'Add Foreign Key Constraint', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-23', '2.0.5', '3:4d6a39028c8a5cc0a85b8b37fbf1b1fc', 53);

--  Changeset changelog_7.0.0.groovy::7.0.0-24::owf::(Checksum: 3:f1e6830542a856459733effeca8aaa24)
--  Add a property to track the count of unique widgets present on the dashboards of a stack
ALTER TABLE `stack` ADD `unique_widget_count` BIGINT DEFAULT '0';

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add a property to track the count of unique widgets present on the dashboards of a stack', NOW(), 'Add Column', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-24', '2.0.5', '3:f1e6830542a856459733effeca8aaa24', 54);

--  Changeset changelog_7.0.0.groovy::7.0.0-25::owf::(Checksum: 3:ac445082cf2ee5903046bef22276a996)
delete from stack_groups where stack_id = (select id from stack where name = 'OWF') and group_id = (select id from owf_group where name = 'ce86a612-c355-486e-9c9e-5252553cc58e');

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Custom SQL', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-25', '2.0.5', '3:ac445082cf2ee5903046bef22276a996', 55);

--  Changeset changelog_7.0.0.groovy::7.0.0-26::owf::(Checksum: 3:74dc7504043a1f24e2d86d75a2dab571)
--  Delete OWF Stack Group
DELETE FROM `owf_group`  WHERE name like 'ce86a612-c355-486e-9c9e-5252553cc58e';

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Delete OWF Stack Group', NOW(), 'Delete Data', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-26', '2.0.5', '3:74dc7504043a1f24e2d86d75a2dab571', 56);

--  Changeset changelog_7.0.0.groovy::7.0.0-27::owf::(Checksum: 3:cae136582b06f1ed04a6309814236cdc)
--  Delete OWF Stack
DELETE FROM `stack`  WHERE name like 'OWF';

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Delete OWF Stack', NOW(), 'Delete Data', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-27', '2.0.5', '3:cae136582b06f1ed04a6309814236cdc', 57);

--  Changeset changelog_7.0.0.groovy::7.0.0-28::owf::(Checksum: 3:f1bf16779c9d7419bc7cc94e81687786)
--  Add user_widget field to person_widget_definition table
ALTER TABLE `person_widget_definition` ADD `user_widget` TINYINT(1) DEFAULT 0;

UPDATE `person_widget_definition` SET `user_widget` = 0;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add user_widget field to person_widget_definition table', NOW(), 'Add Column', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-28', '2.0.5', '3:f1bf16779c9d7419bc7cc94e81687786', 58);

--  Changeset changelog_7.0.0.groovy::7.0.0-53::owf::(Checksum: 3:95913c657b14ecdbb8c9f85fc0a071b1)
--  Expand a dashboard's description field to 4000 to match Marketplace
ALTER TABLE `dashboard` MODIFY `description` VARCHAR(4000);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Expand a dashboard''s description field to 4000 to match Marketplace', NOW(), 'Modify data type', 'EXECUTED', 'changelog_7.0.0.groovy', '7.0.0-53', '2.0.5', '3:95913c657b14ecdbb8c9f85fc0a071b1', 59);

--  Changeset changelog_7.2.0.groovy::7.2.0-1::owf::(Checksum: 3:69c7062f6bb536836805960380dfdb90)
--  Add fullscreen widget types to table
INSERT INTO `widget_type` (`id`, `name`, `version`) VALUES (5, 'fullscreen', 0);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add fullscreen widget types to table', NOW(), 'Insert Row', 'EXECUTED', 'changelog_7.2.0.groovy', '7.2.0-1', '2.0.5', '3:69c7062f6bb536836805960380dfdb90', 60);

--  Changeset changelog_7.3.0.groovy::7.3.0-1::owf::(Checksum: 3:da90c894252394662881278c5011df4f)
--  Add type to dashboard
ALTER TABLE `dashboard` ADD `type` VARCHAR(255);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add type to dashboard', NOW(), 'Add Column', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-1', '2.0.5', '3:da90c894252394662881278c5011df4f', 61);

--  Changeset changelog_7.3.0.groovy::7.3.0-3::owf::(Checksum: 3:85d934f83517b58484131edbd73d1252)
CREATE TABLE `application_configuration` (`id` BIGINT AUTO_INCREMENT NOT NULL, `version` BIGINT NOT NULL, `created_by_id` BIGINT NULL, `created_date` DATE NULL, `edited_by_id` BIGINT NULL, `edited_date` DATE NULL, `code` VARCHAR(250) NOT NULL, `VALUE` VARCHAR(2000) NULL, `title` VARCHAR(250) NOT NULL, `description` VARCHAR(2000) NULL, `type` VARCHAR(250) NOT NULL, `group_name` VARCHAR(250) NOT NULL, `sub_group_name` VARCHAR(250) NULL, `mutable` TINYINT(1) NOT NULL, `sub_group_order` BIGINT NULL, `help` VARCHAR(2000) NULL, CONSTRAINT `application_configurationPK` PRIMARY KEY (`id`), UNIQUE (`code`)) ENGINE=InnoDB;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Create Table', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-3', '2.0.5', '3:85d934f83517b58484131edbd73d1252', 62);

--  Changeset changelog_7.3.0.groovy::7.3.0-4::owf::(Checksum: 3:3d651aa99a57515a9d4c96f06568ad93)
--  Create index for application_configuration.group_name
CREATE INDEX `FKFC9C0477666C6D2` ON `application_configuration`(`created_by_id`);

CREATE INDEX `FKFC9C047E31CB353` ON `application_configuration`(`edited_by_id`);

CREATE INDEX `app_config_group_name_idx` ON `application_configuration`(`group_name`);

ALTER TABLE `application_configuration` ADD CONSTRAINT `FKFC9C0477666C6D2` FOREIGN KEY (`created_by_id`) REFERENCES `person` (`id`);

ALTER TABLE `application_configuration` ADD CONSTRAINT `FKFC9C047E31CB353` FOREIGN KEY (`edited_by_id`) REFERENCES `person` (`id`);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Create index for application_configuration.group_name', NOW(), 'Create Index (x3), Add Foreign Key Constraint (x2)', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-4', '2.0.5', '3:3d651aa99a57515a9d4c96f06568ad93', 63);

--  Changeset changelog_7.3.0.groovy::7.3.0-5::owf::(Checksum: 3:ebf4c6cfc522e45a5efc657a72cc6b8d)
--  Add icon image url to dashboard
ALTER TABLE `dashboard` ADD `icon_image_url` VARCHAR(2083);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add icon image url to dashboard', NOW(), 'Add Column', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-5', '2.0.5', '3:ebf4c6cfc522e45a5efc657a72cc6b8d', 64);

--  Changeset changelog_7.3.0.groovy::7.3.0-6::owf::(Checksum: 3:05b0697fb3adb15e703588ccfbdc0f7c)
--  Add published_to_store and marked_for_deletion columns to dashboard table
ALTER TABLE `dashboard` ADD `published_to_store` TINYINT(1);

ALTER TABLE `dashboard` ADD `marked_for_deletion` TINYINT(1);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add published_to_store and marked_for_deletion columns to dashboard table', NOW(), 'Add Column', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-6', '2.0.5', '3:05b0697fb3adb15e703588ccfbdc0f7c', 65);

--  Changeset changelog_7.3.0.groovy::7.3.0-7::owf::(Checksum: 3:e50b259c6a288dbdafc06dcd1ef34c37)
ALTER TABLE `stack` ADD `owner_id` BIGINT;

CREATE INDEX `FK68AC2888656347D` ON `stack`(`owner_id`);

ALTER TABLE `stack` ADD CONSTRAINT `FK68AC2888656347D` FOREIGN KEY (`owner_id`) REFERENCES `person` (`id`);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Add Column, Create Index, Add Foreign Key Constraint', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-7', '2.0.5', '3:e50b259c6a288dbdafc06dcd1ef34c37', 66);

--  Changeset changelog_7.3.0.groovy::7.3.0-16::owf::(Checksum: 3:2eb18ef95e182e90bae0a3f9caf69fc2)
--  Adding a column named display_name to the table widget_type so that the UI name is decoupled from the actual back-end name; The display_name will be the same as the name, except for marketplace, which will be displayed as store
ALTER TABLE `widget_type` ADD `display_name` VARCHAR(256);

UPDATE `widget_type` SET `display_name` = name WHERE name != 'marketplace';

UPDATE `widget_type` SET `display_name` = 'store' WHERE name = 'marketplace';

ALTER TABLE `widget_type` MODIFY `display_name` VARCHAR(256) NOT NULL;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Adding a column named display_name to the table widget_type so that the UI name is decoupled from the actual back-end name; The display_name will be the same as the name, except for marketplace, which will be displayed as store', NOW(), 'Add Column, Update Data (x2), Add Not-Null Constraint', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-16', '2.0.5', '3:2eb18ef95e182e90bae0a3f9caf69fc2', 67);

--  Changeset changelog_7.3.0.groovy::7.3.0-17::owf::(Checksum: 3:cc301f6f6f73cf363fe77c5e28604b25)
ALTER TABLE `application_configuration` ALTER `version` SET DEFAULT 0;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Add Default Value', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-17', '2.0.5', '3:cc301f6f6f73cf363fe77c5e28604b25', 68);

--  Changeset app_config_7.3.0.groovy::app_config-7.3.0-1::owf::(Checksum: 3:7a0a54a7ceeef7780ea40164ad99822a)
INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.enable.cef.logging', 'AUDITING', 1, NULL, 1, ' ', 'Boolean', 'true', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.enable.cef.object.access.logging', 'AUDITING', 1, NULL, 2, ' ', 'Boolean', 'false', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.enable.cef.log.sweep', 'AUDITING', 1, NULL, 3, ' ', 'Boolean', 'true', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.cef.log.location', 'AUDITING', 1, NULL, 4, ' ', 'String', '/usr/share/tomcat6', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.cef.sweep.log.location', 'AUDITING', 1, NULL, 5, ' ', 'String', '/var/log/cef', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.security.level', 'AUDITING', 1, NULL, 6, ' ', 'String', NULL, 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.session.control.enabled', 'USER_ACCOUNT_SETTINGS', 1, 'Session Control', 1, ' ', 'Boolean', 'false', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.session.control.max.concurrent', 'USER_ACCOUNT_SETTINGS', 1, 'Session Control', 2, ' ', 'Integer', '1', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.disable.inactive.accounts', 'USER_ACCOUNT_SETTINGS', 1, 'Inactive Accounts', 1, ' ', 'Boolean', 'true', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.inactivity.threshold', 'USER_ACCOUNT_SETTINGS', 1, 'Inactive Accounts', 2, ' ', 'Integer', '90', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.job.disable.accounts.start.time', 'HIDDEN', 1, NULL, 1, ' ', 'String', '23:59:59', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.job.disable.accounts.interval', 'HIDDEN', 1, NULL, 2, ' ', 'Integer', '1440', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.custom.background.url', 'BRANDING', 1, 'Custom Background', 1, ' ', 'String', '', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.custom.header.url', 'BRANDING', 1, 'Custom Header and Footer', 1, ' ', 'String', NULL, 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.custom.header.height', 'BRANDING', 1, 'Custom Header and Footer', 2, ' ', 'Integer', '0', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.custom.footer.url', 'BRANDING', 1, 'Custom Header and Footer', 3, ' ', 'String', NULL, 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.custom.footer.height', 'BRANDING', 1, 'Custom Header and Footer', 4, ' ', 'Integer', '0', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.custom.css', 'BRANDING', 1, 'Custom Header and Footer', 5, ' ', 'String', NULL, 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('owf.custom.jss', 'BRANDING', 1, 'Custom Header and Footer', 6, ' ', 'String', NULL, 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('free.warning.content', 'BRANDING', 1, NULL, 1, ' ', 'String', NULL, 0);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Insert Row (x20)', 'EXECUTED', 'app_config_7.3.0.groovy', 'app_config-7.3.0-1', '2.0.5', '3:7a0a54a7ceeef7780ea40164ad99822a', 69);

--  Changeset changelog_7.3.0.groovy::7.3.0-18::owf::(Checksum: 3:e20a0daf3c5203f6a4aa2df0b27d0673)
--  Add isApproved to stack
ALTER TABLE `stack` ADD `approved` TINYINT(1);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add isApproved to stack', NOW(), 'Add Column', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-18', '2.0.5', '3:e20a0daf3c5203f6a4aa2df0b27d0673', 70);

--  Changeset changelog_7.3.0.groovy::7.3.0-20::owf::(Checksum: 3:b6c0c14c4fdb221e141e49ba0f71b221)
--  Create an OWF Admin group.
INSERT INTO `owf_group` (`automatic`, `description`, `display_name`, `name`, `stack_default`, `status`, `version`) VALUES (1, 'OWF Administrators', 'OWF Administrators', 'OWF Administrators', 0, 'active', 0);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Create an OWF Admin group.', NOW(), 'Insert Row', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-20', '2.0.5', '3:b6c0c14c4fdb221e141e49ba0f71b221', 71);

--  Changeset changelog_7.3.0.groovy::7.3.0-21::owf::(Checksum: 3:8c5356773157ee7fa260d2d83900cba5)
--  Create Administrator's App and its default group.
INSERT INTO `stack` (`approved`, `description`, `image_url`, `name`, `stack_context`, `unique_widget_count`, `version`) VALUES (1, 'This application collects the administrative components into a common set of application pages for managing system resources.  These pages can be used to create, modify, update, and delete Apps, App Components, Users and Groups, and system configuration settings.', 'themes/common/images/admin/64x64_admin_app.png', 'Administration', 'ef8b5d6f-4b16-4743-9a57-31683c94b616', 5, 1);

INSERT INTO `owf_group` (`automatic`, `description`, `display_name`, `email`, `name`, `stack_default`, `status`, `version`) VALUES (0, '', NULL, NULL, '9e05a814-c1a4-4db1-a672-bccae0f0b311', 1, 'active', 0);

INSERT INTO `stack_groups` (`group_id`, `stack_id`) VALUES ((SELECT id FROM owf_group WHERE name='9e05a814-c1a4-4db1-a672-bccae0f0b311'), (SELECT id FROM stack WHERE stack_context='ef8b5d6f-4b16-4743-9a57-31683c94b616'));

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Create Administrator''s App and its default group.', NOW(), 'Insert Row (x3)', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-21', '2.0.5', '3:8c5356773157ee7fa260d2d83900cba5', 72);

--  Changeset changelog_7.3.0.groovy::7.3.0-22::owf::(Checksum: 3:5fdc73b48e8adc3314e2644e28a3f072)
--  Add Administration App to the OWF Administrators group.
INSERT INTO `stack_groups` (`group_id`, `stack_id`) VALUES ((SELECT id FROM owf_group WHERE name='OWF Administrators'), (SELECT id FROM stack WHERE stack_context='ef8b5d6f-4b16-4743-9a57-31683c94b616'));

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add Administration App to the OWF Administrators group.', NOW(), 'Insert Row', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-22', '2.0.5', '3:5fdc73b48e8adc3314e2644e28a3f072', 73);

--  Changeset changelog_7.3.0.groovy::7.3.0-24::owf::(Checksum: 3:7ed6d90e4d1899a28fb6d1e1790ae910)
--  Add new admin components that include universal names.  These will be the primary admin components moving forward.
INSERT INTO `widget_definition` (`background`, `display_name`, `height`, `id`, `image_url_large`, `image_url_small`, `singleton`, `universal_name`, `version`, `visible`, `widget_guid`, `widget_url`, `widget_version`, `width`) VALUES (0, 'App Component Editor', 440, 186, 'themes/common/images/adm-tools/Widgets64.png', 'themes/common/images/adm-tools/Widgets24.png', 0, 'org.ozoneplatform.owf.admin.appcomponentedit', 0, 0, '679294b3-ccc3-4ace-a061-e3f27ed86451', 'admin/WidgetEdit.gsp', '1.0', 581);

INSERT INTO `widget_definition` (`background`, `display_name`, `height`, `id`, `image_url_large`, `image_url_small`, `singleton`, `universal_name`, `version`, `visible`, `widget_guid`, `widget_url`, `widget_version`, `width`) VALUES (0, 'App Components', 440, 187, 'themes/common/images/adm-tools/Widgets64.png', 'themes/common/images/adm-tools/Widgets24.png', 0, 'org.ozoneplatform.owf.admin.appcomponentmanagement', 0, 1, '48edfe94-4291-4991-a648-c19a903a663b', 'admin/WidgetManagement.gsp', '1.0', 818);

INSERT INTO `widget_definition` (`background`, `display_name`, `height`, `id`, `image_url_large`, `image_url_small`, `singleton`, `universal_name`, `version`, `visible`, `widget_guid`, `widget_url`, `widget_version`, `width`) VALUES (0, 'Group Editor', 440, 188, 'themes/common/images/adm-tools/Groups64.png', 'themes/common/images/adm-tools/Groups24.png', 0, 'org.ozoneplatform.owf.admin.groupedit', 0, 0, 'dc5c2062-aaa8-452b-897f-60b4b55ab564', 'admin/GroupEdit.gsp', '1.0', 581);

INSERT INTO `widget_definition` (`background`, `display_name`, `height`, `id`, `image_url_large`, `image_url_small`, `singleton`, `universal_name`, `version`, `visible`, `widget_guid`, `widget_url`, `widget_version`, `width`) VALUES (0, 'Groups', 440, 189, 'themes/common/images/adm-tools/Groups64.png', 'themes/common/images/adm-tools/Groups24.png', 0, 'org.ozoneplatform.owf.admin.groupmanagement', 0, 1, '53a2a879-442c-4012-9215-a17604dedff7', 'admin/GroupManagement.gsp', '1.0', 818);

INSERT INTO `widget_definition` (`background`, `display_name`, `height`, `id`, `image_url_large`, `image_url_small`, `singleton`, `universal_name`, `version`, `visible`, `widget_guid`, `widget_url`, `widget_version`, `width`) VALUES (0, 'User Editor', 440, 190, 'themes/common/images/adm-tools/Users64.png', 'themes/common/images/adm-tools/Users24.png', 0, 'org.ozoneplatform.owf.admin.useredit', 0, 0, 'a9bf8e71-692d-44e3-a465-5337ce5e725e', 'admin/UserEdit.gsp', '1.0', 581);

INSERT INTO `widget_definition` (`background`, `display_name`, `height`, `id`, `image_url_large`, `image_url_small`, `singleton`, `universal_name`, `version`, `visible`, `widget_guid`, `widget_url`, `widget_version`, `width`) VALUES (0, 'Users', 440, 191, 'themes/common/images/adm-tools/Users64.png', 'themes/common/images/adm-tools/Users24.png', 0, 'org.ozoneplatform.owf.admin.usermanagement', 0, 1, '38070c45-5f6a-4460-810c-6e3496495ec4', 'admin/UserManagement.gsp', '1.0', 818);

INSERT INTO `widget_definition` (`background`, `display_name`, `height`, `id`, `image_url_large`, `image_url_small`, `singleton`, `universal_name`, `version`, `visible`, `widget_guid`, `widget_url`, `widget_version`, `width`) VALUES (0, 'Configuration', 440, 192, 'themes/common/images/adm-tools/Configuration64.png', 'themes/common/images/adm-tools/Configuration24.png', 0, 'org.ozoneplatform.owf.admin.configuration', 0, 1, 'af180bfc-3924-4111-93de-ad6e9bfc060e', 'admin/Configuration.gsp', '1.0', 900);

INSERT INTO `widget_definition` (`background`, `display_name`, `height`, `id`, `image_url_large`, `image_url_small`, `singleton`, `universal_name`, `version`, `visible`, `widget_guid`, `widget_url`, `widget_version`, `width`) VALUES (0, 'App Editor', 440, 193, 'themes/common/images/adm-tools/Stacks64.png', 'themes/common/images/adm-tools/Stacks24.png', 0, 'org.ozoneplatform.owf.admin.appedit', 0, 0, '72c382a3-89e7-4abf-94db-18db7779e1df', 'admin/StackEdit.gsp', '1.0', 581);

INSERT INTO `widget_definition` (`background`, `display_name`, `height`, `id`, `image_url_large`, `image_url_small`, `singleton`, `universal_name`, `version`, `visible`, `widget_guid`, `widget_url`, `widget_version`, `width`) VALUES (0, 'Apps', 440, 194, 'themes/common/images/adm-tools/Stacks64.png', 'themes/common/images/adm-tools/Stacks24.png', 0, 'org.ozoneplatform.owf.admin.appmanagement', 0, 1, '391dd2af-a207-41a3-8e51-2b20ec3e7241', 'admin/StackManagement.gsp', '1.0', 818);

INSERT INTO `widget_definition` (`background`, `display_name`, `height`, `id`, `image_url_large`, `image_url_small`, `singleton`, `universal_name`, `version`, `visible`, `widget_guid`, `widget_url`, `widget_version`, `width`) VALUES (0, 'Page Editor', 440, 195, 'themes/common/images/adm-tools/Dashboards64.png', 'themes/common/images/adm-tools/Dashboards24.png', 0, 'org.ozoneplatform.owf.admin.pageedit', 0, 0, '2445afb9-eb3f-4b79-acf8-6b12180921c3', 'admin/DashboardEdit.gsp', '1.0', 581);

insert into widget_definition_widget_types (widget_definition_id, widget_type_id)
            select id, 2 from widget_definition
            where widget_guid in (
                '72c382a3-89e7-4abf-94db-18db7779e1df',
                '391dd2af-a207-41a3-8e51-2b20ec3e7241',
                '679294b3-ccc3-4ace-a061-e3f27ed86451',
                '48edfe94-4291-4991-a648-c19a903a663b',
                'af180bfc-3924-4111-93de-ad6e9bfc060e',
                'dc5c2062-aaa8-452b-897f-60b4b55ab564',
                '53a2a879-442c-4012-9215-a17604dedff7',
                'a9bf8e71-692d-44e3-a465-5337ce5e725e',
                '38070c45-5f6a-4460-810c-6e3496495ec4',
                '2445afb9-eb3f-4b79-acf8-6b12180921c3'
            );

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add new admin components that include universal names.  These will be the primary admin components moving forward.', NOW(), 'Insert Row (x10), Custom SQL', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-24', '2.0.5', '3:7ed6d90e4d1899a28fb6d1e1790ae910', 74);

--  Changeset changelog_7.3.0.groovy::7.3.0-27::owf::(Checksum: 3:013901f70bd73571c7ae872101df29db)
--  Add the pages for the administrator's app.
INSERT INTO `dashboard` (`altered_by_admin`, `dashboard_position`, `description`, `guid`, `icon_image_url`, `isdefault`, `layout_config`, `locked`, `marked_for_deletion`, `name`, `published_to_store`, `type`, `version`) VALUES (0, 1, 'Administer the Apps in the system.', 'cbb92835-7d13-41dc-8f28-3eba59a6a6d5', 'themes/common/images/adm-tools/Stacks64.png', 0, '{"widgets":[{"universalName":"org.ozoneplatform.owf.admin.appmanagement","widgetGuid":"391dd2af-a207-41a3-8e51-2b20ec3e7241","uniqueId":"bf05736e-a52e-d4ee-7da5-4e39c6df53c8","dashboardGuid":"cbb92835-7d13-41dc-8f28-3eba59a6a6d5","paneGuid":"6ff1c292-9689-4240-7cd8-e4a251978395","intentConfig":null,"launchData":null,"name":"Apps","active":true,"x":0,"y":33,"zIndex":0,"minimized":false,"maximized":false,"pinned":false,"collapsed":false,"columnPos":0,"buttonId":null,"buttonOpened":false,"region":"none","statePosition":1,"singleton":false,"floatingWidget":false,"height":973,"width":1554}],"height":"100%","items":[],"xtype":"fitpane","flex":1,"paneType":"fitpane","defaultSettings":{}}', 0, 0, 'Apps', 1, '', 0);

update dashboard set stack_id = (select id from stack where stack_context = 'ef8b5d6f-4b16-4743-9a57-31683c94b616') where guid = 'cbb92835-7d13-41dc-8f28-3eba59a6a6d5';

INSERT INTO `dashboard` (`altered_by_admin`, `dashboard_position`, `description`, `guid`, `icon_image_url`, `isdefault`, `layout_config`, `locked`, `marked_for_deletion`, `name`, `published_to_store`, `type`, `version`) VALUES (0, 2, 'Administer the App Components in the system.', '2fc20999-01a6-4275-83f4-f7c68d03d938', 'themes/common/images/adm-tools/Widgets64.png', 0, '{"widgets":[{"universalName":"org.ozoneplatform.owf.admin.appcomponentmanagement","widgetGuid":"48edfe94-4291-4991-a648-c19a903a663b","uniqueId":"fa442c1d-d23e-51a9-3be8-39b203c7d95d","dashboardGuid":"2fc20999-01a6-4275-83f4-f7c68d03d938","paneGuid":"49762ea2-42cc-9e76-b6be-c60bd7ae9c03","intentConfig":null,"launchData":null,"name":"App Components","active":false,"x":0,"y":33,"zIndex":0,"minimized":false,"maximized":false,"pinned":false,"collapsed":false,"columnPos":0,"buttonId":null,"buttonOpened":false,"region":"none","statePosition":1,"singleton":false,"floatingWidget":false,"height":973,"width":1554}],"height":"100%","items":[],"xtype":"fitpane","flex":1,"paneType":"fitpane","defaultSettings":{}}', 0, 0, 'App Components', 1, '', 0);

update dashboard set stack_id = (select id from stack where stack_context = 'ef8b5d6f-4b16-4743-9a57-31683c94b616') where guid = '2fc20999-01a6-4275-83f4-f7c68d03d938';

INSERT INTO `dashboard` (`altered_by_admin`, `dashboard_position`, `description`, `guid`, `icon_image_url`, `isdefault`, `layout_config`, `locked`, `marked_for_deletion`, `name`, `published_to_store`, `type`, `version`) VALUES (0, 3, 'Administer the Users and Groups in the system.', '94bf7ed8-bed9-45ad-933b-4d85584cb483', 'themes/common/images/adm-tools/Groups64.png', 0, '{"xtype":"container","cls":"hbox ","layout":{"type":"hbox","align":"stretch"},"items":[{"xtype":"fitpane","cls":"left","flex":1,"htmlText":"50%","items":[],"widgets":[{"universalName":"org.ozoneplatform.owf.admin.usermanagement","widgetGuid":"38070c45-5f6a-4460-810c-6e3496495ec4","uniqueId":"53783596-8233-9e34-4f91-72e92328785d","dashboardGuid":"94bf7ed8-bed9-45ad-933b-4d85584cb483","paneGuid":"7f3657f1-b391-4ab5-f6be-e4393ea5d72d","intentConfig":null,"launchData":null,"name":"Users","active":true,"x":0,"y":33,"zIndex":0,"minimized":false,"maximized":false,"pinned":false,"collapsed":false,"columnPos":0,"buttonId":null,"buttonOpened":false,"region":"none","statePosition":1,"singleton":false,"floatingWidget":false,"height":973,"width":775}],"paneType":"fitpane","defaultSettings":{"widgetStates":{"101f119e-b56a-4e16-8219-11048c020038":{"x":94,"y":199,"height":440,"width":581,"timestamp":1377274970150}}}},{"xtype":"dashboardsplitter"},{"xtype":"fitpane","cls":"right","flex":1,"htmlText":"50%","items":[],"paneType":"fitpane","widgets":[{"universalName":"org.ozoneplatform.owf.admin.groupmanagement","widgetGuid":"53a2a879-442c-4012-9215-a17604dedff7","uniqueId":"3e0647e3-62b4-cd08-6d6b-9ece1670b10e","dashboardGuid":"94bf7ed8-bed9-45ad-933b-4d85584cb483","paneGuid":"e9746a83-a610-6b01-43c4-d543278729b4","intentConfig":null,"launchData":null,"name":"Groups","active":true,"x":779,"y":33,"zIndex":0,"minimized":false,"maximized":false,"pinned":false,"collapsed":false,"columnPos":0,"buttonId":null,"buttonOpened":false,"region":"none","statePosition":1,"singleton":false,"floatingWidget":false,"height":973,"width":775}],"defaultSettings":{"widgetStates":{"d6ce3375-6e89-45ab-a7be-b6cf3abb0e8c":{"x":0,"y":0,"height":440,"width":581,"timestamp":1377274968504}}}}],"flex":1}', 0, 0, 'Users and Groups', 1, '', 0);

update dashboard set stack_id = (select id from stack where stack_context = 'ef8b5d6f-4b16-4743-9a57-31683c94b616') where guid = '94bf7ed8-bed9-45ad-933b-4d85584cb483';

INSERT INTO `dashboard` (`altered_by_admin`, `dashboard_position`, `description`, `guid`, `icon_image_url`, `isdefault`, `layout_config`, `locked`, `marked_for_deletion`, `name`, `published_to_store`, `type`, `version`) VALUES (0, 4, 'Administer the system configuration.', '976cbf75-5537-410f-88a3-375c5cf970bc', 'themes/common/images/adm-tools/Configuration64.png', 0, '{"widgets":[{"universalName":"org.ozoneplatform.owf.admin.configuration","widgetGuid":"af180bfc-3924-4111-93de-ad6e9bfc060e","uniqueId":"8e7d717c-cece-3d18-c060-c3946d5e7f55","dashboardGuid":"976cbf75-5537-410f-88a3-375c5cf970bc","paneGuid":"7cd8017a-f948-7728-0e20-5b5c2182a432","intentConfig":null,"launchData":null,"name":"Configuration","active":false,"x":0,"y":33,"zIndex":0,"minimized":false,"maximized":false,"pinned":false,"collapsed":false,"columnPos":0,"buttonId":null,"buttonOpened":false,"region":"none","statePosition":1,"singleton":false,"floatingWidget":false,"height":973,"width":1554}],"height":"100%","items":[],"xtype":"fitpane","flex":1,"paneType":"fitpane","defaultSettings":{}}', 0, 0, 'Configuration', 1, '', 0);

update dashboard set stack_id = (select id from stack where stack_context = 'ef8b5d6f-4b16-4743-9a57-31683c94b616') where guid = '976cbf75-5537-410f-88a3-375c5cf970bc';

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add the pages for the administrator''s app.', NOW(), 'Insert Row, Custom SQL, Insert Row, Custom SQL, Insert Row, Custom SQL, Insert Row, Custom SQL', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-27', '2.0.5', '3:013901f70bd73571c7ae872101df29db', 75);

--  Changeset changelog_7.3.0.groovy::7.3.0-28::owf::(Checksum: 3:f5a487dba681fe5229c69ee043168f2f)
--  Add the associations for the stack's default group to the app pages..
INSERT INTO `domain_mapping` (`dest_id`, `dest_type`, `relationship_type`, `src_id`, `src_type`, `version`) VALUES ((SELECT id FROM dashboard WHERE guid='cbb92835-7d13-41dc-8f28-3eba59a6a6d5'), 'dashboard', 'owns', (SELECT id FROM owf_group WHERE name='9e05a814-c1a4-4db1-a672-bccae0f0b311'), 'group', 0);

INSERT INTO `domain_mapping` (`dest_id`, `dest_type`, `relationship_type`, `src_id`, `src_type`, `version`) VALUES ((SELECT id FROM dashboard WHERE guid='2fc20999-01a6-4275-83f4-f7c68d03d938'), 'dashboard', 'owns', (SELECT id FROM owf_group WHERE name='9e05a814-c1a4-4db1-a672-bccae0f0b311'), 'group', 0);

INSERT INTO `domain_mapping` (`dest_id`, `dest_type`, `relationship_type`, `src_id`, `src_type`, `version`) VALUES ((SELECT id FROM dashboard WHERE guid='94bf7ed8-bed9-45ad-933b-4d85584cb483'), 'dashboard', 'owns', (SELECT id FROM owf_group WHERE name='9e05a814-c1a4-4db1-a672-bccae0f0b311'), 'group', 0);

INSERT INTO `domain_mapping` (`dest_id`, `dest_type`, `relationship_type`, `src_id`, `src_type`, `version`) VALUES ((SELECT id FROM dashboard WHERE guid='976cbf75-5537-410f-88a3-375c5cf970bc'), 'dashboard', 'owns', (SELECT id FROM owf_group WHERE name='9e05a814-c1a4-4db1-a672-bccae0f0b311'), 'group', 0);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add the associations for the stack''s default group to the app pages..', NOW(), 'Insert Row (x4)', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-28', '2.0.5', '3:f5a487dba681fe5229c69ee043168f2f', 76);

--  Changeset changelog_7.3.0.groovy::7.3.0-29::owf::(Checksum: 3:eb228dae1ba67f1dc85a7a60397e32ae)
--  Add the associations for the stack's default group to the admin components.
INSERT INTO `domain_mapping` (`dest_id`, `dest_type`, `relationship_type`, `src_id`, `src_type`, `version`) VALUES ((SELECT id FROM widget_definition WHERE widget_guid='72c382a3-89e7-4abf-94db-18db7779e1df'), 'widget_definition', 'owns', (SELECT id FROM owf_group WHERE name='9e05a814-c1a4-4db1-a672-bccae0f0b311'), 'group', 0);

INSERT INTO `domain_mapping` (`dest_id`, `dest_type`, `relationship_type`, `src_id`, `src_type`, `version`) VALUES ((SELECT id FROM widget_definition WHERE widget_guid='391dd2af-a207-41a3-8e51-2b20ec3e7241'), 'widget_definition', 'owns', (SELECT id FROM owf_group WHERE name='9e05a814-c1a4-4db1-a672-bccae0f0b311'), 'group', 0);

INSERT INTO `domain_mapping` (`dest_id`, `dest_type`, `relationship_type`, `src_id`, `src_type`, `version`) VALUES ((SELECT id FROM widget_definition WHERE widget_guid='679294b3-ccc3-4ace-a061-e3f27ed86451'), 'widget_definition', 'owns', (SELECT id FROM owf_group WHERE name='9e05a814-c1a4-4db1-a672-bccae0f0b311'), 'group', 0);

INSERT INTO `domain_mapping` (`dest_id`, `dest_type`, `relationship_type`, `src_id`, `src_type`, `version`) VALUES ((SELECT id FROM widget_definition WHERE widget_guid='48edfe94-4291-4991-a648-c19a903a663b'), 'widget_definition', 'owns', (SELECT id FROM owf_group WHERE name='9e05a814-c1a4-4db1-a672-bccae0f0b311'), 'group', 0);

INSERT INTO `domain_mapping` (`dest_id`, `dest_type`, `relationship_type`, `src_id`, `src_type`, `version`) VALUES ((SELECT id FROM widget_definition WHERE widget_guid='af180bfc-3924-4111-93de-ad6e9bfc060e'), 'widget_definition', 'owns', (SELECT id FROM owf_group WHERE name='9e05a814-c1a4-4db1-a672-bccae0f0b311'), 'group', 0);

INSERT INTO `domain_mapping` (`dest_id`, `dest_type`, `relationship_type`, `src_id`, `src_type`, `version`) VALUES ((SELECT id FROM widget_definition WHERE widget_guid='dc5c2062-aaa8-452b-897f-60b4b55ab564'), 'widget_definition', 'owns', (SELECT id FROM owf_group WHERE name='9e05a814-c1a4-4db1-a672-bccae0f0b311'), 'group', 0);

INSERT INTO `domain_mapping` (`dest_id`, `dest_type`, `relationship_type`, `src_id`, `src_type`, `version`) VALUES ((SELECT id FROM widget_definition WHERE widget_guid='53a2a879-442c-4012-9215-a17604dedff7'), 'widget_definition', 'owns', (SELECT id FROM owf_group WHERE name='9e05a814-c1a4-4db1-a672-bccae0f0b311'), 'group', 0);

INSERT INTO `domain_mapping` (`dest_id`, `dest_type`, `relationship_type`, `src_id`, `src_type`, `version`) VALUES ((SELECT id FROM widget_definition WHERE widget_guid='a9bf8e71-692d-44e3-a465-5337ce5e725e'), 'widget_definition', 'owns', (SELECT id FROM owf_group WHERE name='9e05a814-c1a4-4db1-a672-bccae0f0b311'), 'group', 0);

INSERT INTO `domain_mapping` (`dest_id`, `dest_type`, `relationship_type`, `src_id`, `src_type`, `version`) VALUES ((SELECT id FROM widget_definition WHERE widget_guid='38070c45-5f6a-4460-810c-6e3496495ec4'), 'widget_definition', 'owns', (SELECT id FROM owf_group WHERE name='9e05a814-c1a4-4db1-a672-bccae0f0b311'), 'group', 0);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', 'Add the associations for the stack''s default group to the admin components.', NOW(), 'Insert Row (x9)', 'EXECUTED', 'changelog_7.3.0.groovy', '7.3.0-29', '2.0.5', '3:eb228dae1ba67f1dc85a7a60397e32ae', 77);

--  Changeset changelog_7.10.0.groovy::7.10.0-1::owf::(Checksum: 3:115190a042e53f65034683e629f8cf47)
ALTER TABLE `person` ADD `last_notification` DATETIME;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Add Column', 'EXECUTED', 'changelog_7.10.0.groovy', '7.10.0-1', '2.0.5', '3:115190a042e53f65034683e629f8cf47', 78);

--  Changeset changelog_7.10.0.groovy::7.10.0-2::owf::(Checksum: 3:41ac759cfb732888d39c704edd1aa12d)
INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('notifications.enabled', 'NOTIFICATIONS', 1, 1, ' ', 'Boolean', 'false', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('notifications.query.interval', 'NOTIFICATIONS', 1, 2, ' ', 'Integer', '30', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('url.public', 'NOTIFICATIONS', 1, 3, ' ', 'String', NULL, 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('notifications.xmpp.server.hostname', 'NOTIFICATIONS', 1, 'XMPP Settings', 1, ' ', 'String', NULL, 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('notifications.xmpp.server.port', 'NOTIFICATIONS', 1, 'XMPP Settings', 2, ' ', 'Integer', '5222', 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('notifications.xmpp.room', 'NOTIFICATIONS', 1, 'XMPP Settings', 3, ' ', 'String', NULL, 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('notifications.xmpp.username', 'NOTIFICATIONS', 1, 'XMPP Settings', 4, ' ', 'String', NULL, 0);

INSERT INTO `application_configuration` (`code`, `group_name`, `mutable`, `sub_group_name`, `sub_group_order`, `title`, `type`, `value`, `version`) VALUES ('notifications.xmpp.password', 'NOTIFICATIONS', 1, 'XMPP Settings', 5, ' ', 'String', NULL, 0);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Insert Row (x8)', 'EXECUTED', 'changelog_7.10.0.groovy', '7.10.0-2', '2.0.5', '3:41ac759cfb732888d39c704edd1aa12d', 79);

--  Changeset changelog_7.15.1.groovy::7.15.1-1::owf::(Checksum: 3:a253a2a9c7e7571b94e59fc1767c58b3)
DELETE FROM `application_configuration`  WHERE code = 'notifications.xmpp.server.hostname';

DELETE FROM `application_configuration`  WHERE code = 'notifications.xmpp.server.port';

DELETE FROM `application_configuration`  WHERE code = 'notifications.xmpp.room';

DELETE FROM `application_configuration`  WHERE code = 'notifications.xmpp.username';

DELETE FROM `application_configuration`  WHERE code = 'notifications.xmpp.password';

DELETE FROM `application_configuration`  WHERE code = 'notifications.enabled';

DELETE FROM `application_configuration`  WHERE code = 'notifications.query.interval';

DELETE FROM `application_configuration`  WHERE code = 'url.public';

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Delete Data (x8)', 'EXECUTED', 'changelog_7.15.1.groovy', '7.15.1-1', '2.0.5', '3:a253a2a9c7e7571b94e59fc1767c58b3', 80);

--  Changeset changelog_7.15.1.groovy::7.15.1-2::owf::(Checksum: 3:1234ac8c0f21a1d748e17510d1c4373c)
ALTER TABLE `widget_definition` CHANGE `image_url_large` `image_url_medium` VARCHAR(2083);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Rename Column', 'EXECUTED', 'changelog_7.15.1.groovy', '7.15.1-2', '2.0.5', '3:1234ac8c0f21a1d748e17510d1c4373c', 81);

--  Changeset changelog_7.16.0.groovy::7.16.0-1::owf::(Checksum: 3:a5550d64efe7315b58db632c964075f3)
UPDATE `application_configuration` SET `sub_group_order` = '5', `type` = 'String', `value` = '/var/log/cef' WHERE code='owf.cef.sweep.log.location' AND type <> 'String';

UPDATE `application_configuration` SET `sub_group_order` = '3', `type` = 'Boolean', `value` = 'true' WHERE code='owf.enable.cef.log.sweep' AND type <> 'Boolean';

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Update Data (x2)', 'EXECUTED', 'changelog_7.16.0.groovy', '7.16.0-1', '2.0.5', '3:a5550d64efe7315b58db632c964075f3', 82);

--  Changeset changelog_7.16.0.groovy::7.16.0-2::owf::(Checksum: 3:9413ce637b7ef560903ebae7e9da84d3)
ALTER TABLE `person` ADD `requires_sync` TINYINT(1) DEFAULT 0;

UPDATE `person` SET `requires_sync` = 0;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Add Column', 'EXECUTED', 'changelog_7.16.0.groovy', '7.16.0-2', '2.0.5', '3:9413ce637b7ef560903ebae7e9da84d3', 83);

--  Changeset changelog_7.16.0.groovy::7.16.0-3::owf::(Checksum: 3:7727672cc83b77a203682f2ed0f7e403)
ALTER TABLE `stack` ADD `default_group_id` BIGINT;

ALTER TABLE `stack` ADD CONSTRAINT `FK68AC28835014F5F` FOREIGN KEY (`default_group_id`) REFERENCES `owf_group` (`id`);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Add Column, Add Foreign Key Constraint', 'EXECUTED', 'changelog_7.16.0.groovy', '7.16.0-3', '2.0.5', '3:7727672cc83b77a203682f2ed0f7e403', 84);

--  Changeset changelog_7.16.0.groovy::7.16.0-5::owf::(Checksum: 3:2004c0339ed2540d43b4185bfdd594fa)
CREATE INDEX `domain_mapping_all` ON `domain_mapping`(`src_id`, `src_type`, `relationship_type`, `dest_id`, `dest_type`);

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Create Index', 'EXECUTED', 'changelog_7.16.0.groovy', '7.16.0-5', '2.0.5', '3:2004c0339ed2540d43b4185bfdd594fa', 85);

--  Changeset changelog_7.16.0.groovy::7.16.0-6::owf::(Checksum: 3:1a84a71cf6605cd2706216801b85e477)
ALTER TABLE `widget_definition` ADD `mobile_ready` TINYINT(1) NOT NULL DEFAULT 0;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Add Column', 'EXECUTED', 'changelog_7.16.0.groovy', '7.16.0-6', '2.0.5', '3:1a84a71cf6605cd2706216801b85e477', 86);

--  Changeset changelog_7.16.1.groovy::7.16.1-1::owf::(Checksum: 3:ae067414a3c058b53045e311d46646cc)
INSERT INTO `role` (`authority`, `description`, `id`, `version`) VALUES ('ROLE_USER', 'User Role', '26', '2');

INSERT INTO `role` (`authority`, `description`, `id`, `version`) VALUES ('ROLE_ADMIN', 'Admin Role', '27', '1');

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Insert Row (x2)', 'EXECUTED', 'changelog_7.16.1.groovy', '7.16.1-1', '2.0.5', '3:ae067414a3c058b53045e311d46646cc', 87);

--  Changeset changelog_7.16.1.groovy::7.16.1-3::owf::(Checksum: 3:8b4c3f03d4786a6263553143cda2bde0)
CREATE TABLE `person_role` (`person_authorities_id` BIGINT NULL, `role_id` BIGINT NULL) ENGINE=InnoDB;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Create Table', 'EXECUTED', 'changelog_7.16.1.groovy', '7.16.1-3', '2.0.5', '3:8b4c3f03d4786a6263553143cda2bde0', 88);

--  Changeset changelog_7.16.1.groovy::7.16.1-4::owf::(Checksum: 3:86e4f665a39e4de4eea6cf49696b7f32)
DROP TABLE `role_people`;

INSERT INTO `DATABASECHANGELOG` (`AUTHOR`, `COMMENTS`, `DATEEXECUTED`, `DESCRIPTION`, `EXECTYPE`, `FILENAME`, `ID`, `LIQUIBASE`, `MD5SUM`, `ORDEREXECUTED`) VALUES ('owf', '', NOW(), 'Drop Table', 'EXECUTED', 'changelog_7.16.1.groovy', '7.16.1-4', '2.0.5', '3:86e4f665a39e4de4eea6cf49696b7f32', 89);

