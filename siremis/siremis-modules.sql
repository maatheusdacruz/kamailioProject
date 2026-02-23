-- Module: contact

CREATE TABLE IF NOT EXISTS `contact` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `display_name` varchar(255) NOT NULL,
  `company` varchar(255) NOT NULL,
  `department` varchar(255) DEFAULT '',
  `position` varchar(255) DEFAULT '',
  `fast_index` varchar(10) DEFAULT '',
  `photo` varchar(255) DEFAULT '',
  `phone` varchar(255) DEFAULT '',
  `mobile` varchar(255) DEFAULT '',
  `fax` varchar(255) DEFAULT '',
  `zipcode` varchar(255) DEFAULT '',
  `province` varchar(255) DEFAULT '',
  `city` varchar(255) DEFAULT '',
  `street` varchar(255) DEFAULT '',
  `country` varchar(255) DEFAULT '',
  `email` varchar(255) DEFAULT '',
  `webpage` varchar(255) NOT NULL DEFAULT '',
  `qq` varchar(255) DEFAULT '',
  `icq` varchar(255) DEFAULT '',
  `skype` varchar(255) DEFAULT '',
  `yahoo` varchar(255) DEFAULT '',
  `misc` text,
  `type_id` int(11) NOT NULL,
  `sortorder` int(11) NOT NULL,
  `user_id` int(11) DEFAULT '0',
  `published` int(11) NOT NULL DEFAULT '0',
  `default` int(11) DEFAULT '0',
  `access` varchar(255) DEFAULT NULL,
  `params` text,
  `create_by` int(11) NOT NULL,
  `create_time` datetime NOT NULL,
  `update_by` int(11) NOT NULL,
  `update_time` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `type_id` (`type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;


INSERT IGNORE INTO `contact` (`id`, `first_name`, `last_name`, `display_name`, `company`, `department`, `position`, `fast_index`, `photo`, `phone`, `mobile`, `fax`, `zipcode`, `province`, `city`, `street`, `country`, `email`, `webpage`, `qq`, `icq`, `skype`, `yahoo`, `misc`, `type_id`, `sortorder`, `user_id`, `published`, `default`, `access`, `params`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES
(1, 'Rocky', 'Swen', 'Rocky, Swen', 'Openbiz LLC', 'Management', 'CEO', 'J', '/files/upload/contact/20100524200309-RockySwen.jpg', '', '', '', '', 'CA', '', '', 'USA', '', '', '', '', '', '', NULL, 1, 50, 0, 1, 0, NULL, NULL, 1, '2010-05-24 08:00:01', 1, '2010-05-24 20:03:09'),
(2, 'Jixian', 'Wang', 'Jixian, Wang', 'Openbiz LLC', 'Management', 'CTO', 'R', '/files/upload/contact/20100524200245-skype.jpg', '+86 10 6497 9191', '+86 139 1015 4220', '+86 10 6497 9191', '100101', 'Beijing', 'Beijing', 'Chaoyang Yayuncun', 'China', 'jixian2003@qq.com', 'http://www.czm.cn/', '315824246', '', 'jixianwang', '', 'Hosting Company CEO\r\n#1 fadsf\r\nadfasdf', 1, 50, 0, 1, 0, NULL, NULL, 1, '2010-05-24 08:41:57', 1, '2010-05-24 20:02:45'),
(3, 'Wang', 'Ou', 'Wang, Ou', 'Openbiz LLC', 'Design Dept', 'Designer', 'W', '/files/upload/contact/20100524200233-WangOu.jpg', '+86 10 64979191', '', '', '', '', '', '', '', '', '', '', '', '', '', NULL, 1, 50, 0, 1, 0, NULL, NULL, 1, '2010-05-24 08:43:41', 1, '2010-06-12 04:02:29'),
(4, 'test', 'li', 'test, li', 'jixian llc', 'sdf', 'jixian', 't', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', NULL, 1, 50, 0, 1, 0, NULL, NULL, 1, '2010-06-13 10:52:00', 1, '2010-06-13 10:52:00');


CREATE TABLE IF NOT EXISTS `contact_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `sortorder` int(11) NOT NULL,
  `published` int(11) NOT NULL,
  `create_by` int(11) NOT NULL,
  `create_time` datetime NOT NULL,
  `update_by` int(11) NOT NULL,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;


INSERT IGNORE INTO `contact_type` (`id`, `name`, `description`, `sortorder`, `published`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES
(1, 'Business', 'Business Contacts', 45, 1, 1, '2010-05-23 01:09:06', 1, '2010-05-23 18:47:14'),
(2, 'Family', 'Family Contacts', 45, 1, 1, '2010-05-23 01:23:04', 1, '2010-05-24 18:51:35'),
(3, 'Provider', 'Business Provider Contacts', 50, 1, 1, '2010-05-23 01:34:12', 1, '2010-05-24 02:41:09'),
(4, 'Client', 'Business Client Contacts', 45, 1, 1, '2010-05-23 01:34:39', 1, '2010-05-24 11:10:32');

-- Module: cronjob
/*Table structure for table `cronjob` */


CREATE TABLE `cronjob` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `minute` varchar(255) NOT NULL default '',
  `hour` varchar(255) NOT NULL default '',
  `day` varchar(255) NOT NULL default '',
  `month` varchar(255) NOT NULL default '',
  `weekday` varchar(255) NOT NULL default '',
  `command` varchar(255) NOT NULL default '',
  `sendmail` varchar(255) default '',
  `max_run` int(2) default '1',
  `num_run` int(2) default '0',
  `description` varchar(255) default NULL,
  `status` int(1) default '1',
  `last_exec` int(11) default NULL,
  `create_by` int(11) default NULL,
  `create_time` datetime default NULL,
  `update_by` int(11) default NULL,
  `update_time` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `minute` (`minute`),
  KEY `hour` (`hour`),
  KEY `weekday` (`day`),
  KEY `month` (`month`),
  KEY `week` (`weekday`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `cronjob` */

-- Module: eventlog
/*Table structure for table `event_log` */


CREATE TABLE `event_log` (                                                                                                                    
     `id` int(11) NOT NULL auto_increment,                                                                                    
     `user_id` int(11) NOT NULL default '0',                                                                                  
     `ipaddr` varchar(50) NOT NULL,                                                                                     
     `event` varchar(255) NOT NULL,                                                                                       
     `message` varchar(255) NOT NULL,                                                                               
     `comment` text NOT NULL,                                                                                       
     `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,                          
     PRIMARY KEY  (`id`),                                                                                                                        
     KEY `UserID` (`user_id`,`ipaddr`,`event`),                                                                                                  
     KEY `Message` (`message`)                                                                                                                   
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Module: help
/*Table structure for table `help` */


CREATE TABLE `help` (
  `id` int(11) NOT NULL auto_increment,
  `category_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `sort_order` int(11) NOT NULL default '10',
  `content` longtext,
  `create_by` int(11) default NULL,
  `create_time` datetime default NULL,
  `update_by` int(11) default NULL,
  `update_time` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `create_by` (`create_by`),
  KEY `update_by` (`update_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `help` */

insert  into `help`(`id`,`category_id`,`title`,`description`,`sort_order`,`content`,`create_by`,`create_time`,`update_by`,`update_time`) values (1,3,'What is Module Management?','<p>\n	Module Management screen allows administrator to manage modules in the application</p>\n',10,'<p>\n	Action can be done on the module management screen.</p>\n<ul>\n	<li>\n		Edit button. This is to activate or deactivate a module</li>\n	<li>\n		Delete button. This is to delete a module. When a module is deleted, its ACL settings are deleted as well.</li>\n	<li>\n		Load button. This is to load new modules added in the modules directory. The loading processor will read mod.xml, and load module and it ACL info to the system.</li>\n</ul>\n',1,'2010-05-01 13:01:58',1,'2010-05-01 13:06:21');
insert  into `help`(`id`,`category_id`,`title`,`description`,`sort_order`,`content`,`create_by`,`create_time`,`update_by`,`update_time`) values (2,1,'What is User Management ?','<p>\n	User Manage screen allows administrator to manage application users</p>\n',10,'<p>\n	Action can be done on the user management screen</p>\n<ul>\n	<li>\n		Add button to add a new user</li>\n	<li>\n		Edit button to edit a selected user</li>\n	<li>\n		Delete button to delete a selected user</li>\n</ul>\n',1,'2010-02-07 16:07:21',1,'2010-05-01 12:50:12');
insert  into `help`(`id`,`category_id`,`title`,`description`,`sort_order`,`content`,`create_by`,`create_time`,`update_by`,`update_time`) values (3,2,'What is Role Management?','<p>\n	Role Management screen allows administrator to manage roles in the application</p>\n',10,'<p>\n	Actions can be done on the role management screen.</p>\n<ul>\n	<li>\n		Add button</li>\n	<li>\n		Edit button</li>\n	<li>\n		Delete button. If a role is deleted, its permissions will be deleted as well.</li>\n</ul>\n',1,'2010-02-07 17:25:46',1,'2010-05-01 12:58:06');
insert  into `help`(`id`,`category_id`,`title`,`description`,`sort_order`,`content`,`create_by`,`create_time`,`update_by`,`update_time`) values (4,6,'How to ceate a help tip?','<p>\r\n	You need to go to Manage Help tips module and click Add button to create a new help tips.</p>\r\n',10,NULL,1,'2010-04-24 04:18:35',1,'2010-04-24 04:19:35');
insert  into `help`(`id`,`category_id`,`title`,`description`,`sort_order`,`content`,`create_by`,`create_time`,`update_by`,`update_time`) values (5,6,'How to map a help category to system module?','<p>\r\n	You can mapping a help category to a module&#39;s left help panel by specified URL match. then the module will only show help tips under this category.</p>\r\n',10,NULL,1,'2010-04-24 04:21:54',1,'2010-04-24 04:21:54');
insert  into `help`(`id`,`category_id`,`title`,`description`,`sort_order`,`content`,`create_by`,`create_time`,`update_by`,`update_time`) values (6,3,'How to reload a module?','<p>\n	A module can be reloaded to update its change</p>\n',10,'<p>\n	On the module management screen, click the module name to drilldown the module detail form. On this form, click Reload button to update the changes into the system</p>\n',1,'2010-05-01 13:09:09',1,'2010-05-01 13:09:09');
insert  into `help`(`id`,`category_id`,`title`,`description`,`sort_order`,`content`,`create_by`,`create_time`,`update_by`,`update_time`) values (7,4,'What is Event Log?','<p>\n	Event log screen is to list all events logged by the application</p>\n',10,'<p>\n	On the Event Log screen, clicking on the comments link to see to event log detail.</p>\n<p>\n	Clicking on the Clear button, all log records will be deleted from the log table. Be careful of using it.</p>\n',1,'2010-05-01 13:12:11',1,'2010-05-01 13:15:33');
insert  into `help`(`id`,`category_id`,`title`,`description`,`sort_order`,`content`,`create_by`,`create_time`,`update_by`,`update_time`) values (8,5,'How to manage email queue?','<p>\n	Email Queue Management screen allows user to manage queued emails</p>\n',10,'<p>\n	Action can be done on the email queue management screen.</p>\n<ul>\n	<li>\n		Send All button. This is to send all queued email immediately</li>\n	<li>\n		Send button. This is to send the selected email immediately</li>\n	<li>\n		Delete. This is to delete the selected email from the queue</li>\n	<li>\n		Delete Sent. This is to delete all sent emails from the queue</li>\n	<li>\n		Delete All. This is to empty the email queue</li>\n</ul>\n',1,'2010-05-01 13:17:05',1,'2010-05-01 16:18:48');
insert  into `help`(`id`,`category_id`,`title`,`description`,`sort_order`,`content`,`create_by`,`create_time`,`update_by`,`update_time`) values (9,5,'How to manage email log?','<p>\n	Email Log Management screen allows user to manage email activities</p>\n',10,'<p>\n	Clicking the Clear button will empty the email log records.</p>\n',1,'2010-05-01 13:18:11',1,'2010-05-01 16:19:59');

/*Table structure for table `help_category` */


CREATE TABLE `help_category` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default '0',
  `name` varchar(255) NOT NULL,
  `url_match` varchar(255) default NULL,
  `description` text,
  `sort_order` int(11) NOT NULL default '10',
  `create_by` int(11) NOT NULL,
  `create_time` datetime NOT NULL,
  `update_by` int(11) NOT NULL,
  `update_time` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `help_category` */

insert  into `help_category`(`id`,`parent_id`,`name`,`url_match`,`description`,`sort_order`,`create_by`,`create_time`,`update_by`,`update_time`) values (1,7,'User Management','/system/user_list.*','<p>\n	About how to manage users and system access.</p>\n',10,1,'2010-04-19 18:15:18',1,'2010-04-22 01:37:29');
insert  into `help_category`(`id`,`parent_id`,`name`,`url_match`,`description`,`sort_order`,`create_by`,`create_time`,`update_by`,`update_time`) values (2,7,'Role Management','/system/role_list.*','<p>\n	About how to manage system role and permissions group.</p>\n',20,1,'2010-04-19 19:50:23',1,'2010-04-21 08:10:48');
insert  into `help_category`(`id`,`parent_id`,`name`,`url_match`,`description`,`sort_order`,`create_by`,`create_time`,`update_by`,`update_time`) values (3,7,'Module Management','/system/module_list.*','<p>\n	About how to mount a module into system.</p>\n',30,1,'2010-04-21 03:35:11',1,'2010-04-21 05:11:09');
insert  into `help_category`(`id`,`parent_id`,`name`,`url_match`,`description`,`sort_order`,`create_by`,`create_time`,`update_by`,`update_time`) values (4,7,'Event Log Management','/system/event_log.*','<p>About system event log/</p>\n',40,1,'2010-04-21 05:01:44',1,'2010-04-21 08:09:53');
insert  into `help_category`(`id`,`parent_id`,`name`,`url_match`,`description`,`sort_order`,`create_by`,`create_time`,`update_by`,`update_time`) values (5,7,'Email Management','/email/email_.*','<p>\n	About how to manage system email function</p>\n',50,1,'2010-04-21 05:03:43',1,'2010-05-01 13:19:08');
insert  into `help_category`(`id`,`parent_id`,`name`,`url_match`,`description`,`sort_order`,`create_by`,`create_time`,`update_by`,`update_time`) values (6,7,'Help Management','/help/help_.*','<p>\r\n	About how to manage the online help module of cubi system.</p>\r\n',60,1,'2010-04-21 05:09:50',1,'2010-04-24 05:16:02');
insert  into `help_category`(`id`,`parent_id`,`name`,`url_match`,`description`,`sort_order`,`create_by`,`create_time`,`update_by`,`update_time`) values (7,0,'System Admin',NULL,'<p>\n	System help content.</p>\n',10,1,'2010-04-21 05:10:29',1,'2010-04-21 05:11:54');

/*Table structure for table `help_category_mapping` */


CREATE TABLE `help_category_mapping` (
  `id` int(11) NOT NULL auto_increment,
  `url` varchar(255) NOT NULL,
  `cat_id` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  KEY `url` (`url`),
  KEY `cat_id` (`cat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `help_category_mapping` */

-- Module: menu

-- Module: system
/*Table structure for table `acl_action` */


CREATE TABLE `acl_action` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `module` varchar(64) NOT NULL default '',
  `resource` varchar(64) NOT NULL default '',
  `action` varchar(64) NOT NULL default '',
  `description` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `acl_role_action` */


CREATE TABLE `acl_role_action` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `role_id` int(10) unsigned NOT NULL default '0',
  `action_id` int(10) unsigned NOT NULL default '0',
  `access_level` varchar(4) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `role_id` (`role_id`),
  KEY `action_id` (`action_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `meta_do` */


CREATE TABLE `meta_do` (
  `name` varchar(100) NOT NULL,
  `module` varchar(100) NOT NULL,
  `class` varchar(100) NOT NULL,
  `dbname` varchar(100) default NULL,
  `table` varchar(100) default NULL,
  `data` text,
  `fields` text,
  PRIMARY KEY  (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `meta_form` */


CREATE TABLE `meta_form` (
  `name` varchar(100) NOT NULL,
  `module` varchar(100) NOT NULL,
  `class` varchar(100) NOT NULL,
  `dataobj` varchar(100) default NULL,
  `template` varchar(100) default NULL,
  `data` text,
  `elements` text,
  PRIMARY KEY  (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `meta_view` */


CREATE TABLE `meta_view` (
  `name` varchar(100) NOT NULL,
  `module` varchar(100) NOT NULL,
  `class` varchar(100) NOT NULL,
  `template` varchar(100) default NULL,
  `data` text,
  `forms` text,
  PRIMARY KEY  (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `module` */


CREATE TABLE `module` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(64) NOT NULL default '',
  `description` varchar(255) default NULL,
  `status` int(2) default '1',
  `author` varchar(64) default NULL,
  `version` varchar(64) default NULL,
  `openbiz_version` varchar(64) default NULL,
  `depend_on` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `role` */


CREATE TABLE `role` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(64) NOT NULL default '',
  `description` varchar(255) default NULL,
  `status` int(2) default '1',
  `default` int(2) default '0',
  `startpage` varchar( 255 ) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`),
  INDEX (  `default` ),
  INDEX (  `status` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `role` */

insert  into `role`(`id`,`name`,`description`,`status`,`startpage`) values (1,'Administrator','System administrator',1,'/system/general_default');
insert  into `role`(`id`,`name`,`description`,`status`,`startpage`) values (2,'Sipadmin','General SIP admins',1,'/sipadmin/sipadmin_default');
insert  into `role`(`id`,`name`,`description`,`status`,`startpage`) values (3,'Sipuser','General SIP users',1,'/sipuser/sipuser_default');

/*Table structure for table `user` */


CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `username` varchar(64) NOT NULL default '',
  `password` varchar(64) NOT NULL default '',
  `enctype` varchar(64) NOT NULL default 'SHA1',
  `email` varchar(64) default '',
  `status` int(2) default '1',
  `lastlogin` datetime default NULL,
  `lastlogout` datetime default NULL,
  `create_by` int(10) default 1,
  `create_time` datetime default NULL,
  `update_by` int(10) default 1,
  `update_time` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `user` */

insert  into `user`(`id`,`username`,`password`,`enctype`,`email`,`status`,`lastlogin`,`lastlogout`,`create_by`,`create_time`,`update_by`,`update_time`) values (1,'admin','d033e22ae348aeb5660fc2140aec35850c4da997','SHA1','admin@yourcompany.com',1,'2010-05-16 18:20:40','2009-08-24 13:24:14',1,'2010-05-01 01:19:57',1,'2010-05-01 01:19:57');
insert  into `user`(`id`,`username`,`password`,`enctype`,`email`,`status`,`lastlogin`,`lastlogout`,`create_by`,`create_time`,`update_by`,`update_time`) values (2,'member','6467baa3b187373e3931422e2a8ef22f3e447d77','SHA1','member@yourcompany.com',0,'2010-05-01 01:19:57','2009-08-23 23:39:37',1,'2010-05-01 01:19:57',5,'2010-05-01 01:19:57');
insert  into `user`(`id`,`username`,`password`,`enctype`,`email`,`status`,`lastlogin`,`lastlogout`,`create_by`,`create_time`,`update_by`,`update_time`) values (3,'guest','35675e68f4b5af7b995d9205ad0fc43842f16450','SHA1','guest@yourcompany.com',0,NULL,NULL,NULL,'2010-01-12 02:20:10',NULL,'2010-01-12 02:20:10');

/*Table structure for table `user_role` */


CREATE TABLE `user_role` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL default '0',
  `role_id` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `user_role` */

insert  into `user_role`(`id`,`user_id`,`role_id`) values (1,1,1);
insert  into `user_role`(`id`,`user_id`,`role_id`) values (2,2,2);
insert  into `user_role`(`id`,`user_id`,`role_id`) values (3,3,3);

/*Table structure for table `group` */


CREATE TABLE `group` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(64) NOT NULL default '',
  `description` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `group_role` */


CREATE TABLE `user_group` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL default '0',
  `group_id` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `pass_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token` varchar(64) NOT NULL,
  `expiration` datetime DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

/*Table structure for table `menu` */


CREATE TABLE `menu` (                                 
  `name` varchar(100) NOT NULL default '',      
  `module` varchar(100) default NULL,           
  `title` varchar(100) default NULL,                 
  `link` varchar(255) default NULL,      
  `url_match` varchar(255) default NULL,        
  `view` varchar(255) default NULL,             
  `type` varchar(50) NOT NULL default '',       
  `published` tinyint(1) NOT NULL default '1',  
  `parent` varchar(255) default '',             
  `ordering` int(4) default '10',               
  `access` varchar(100) default NULL,           
  `icon` varchar(100) default NULL,             
  `icon_css` varchar(100) default NULL,     
  `description` varchar(255) default NULL,
  `create_by` int(10) default 1,
  `create_time` datetime default NULL,
  `update_by` int(10) default 1,
  `update_time` datetime default NULL,
  PRIMARY KEY  (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `menu` */

INSERT IGNORE INTO `menu` (`name`, `module`, `title`, `link`, `url_match`, `view`, `type`, `published`, `parent`, `ordering`, `access`, `icon`, `icon_css`, `description`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('Contact','contact','Contacts','',NULL,NULL,'',1,'Collaboration',50,'','spacer.gif','icon_contact','',1,NULL,1,NULL),('Contact.ByType','contact','View By Contact Type','/contact/contact_type_list',NULL,NULL,'',1,'Contact',10,'','','','',1,NULL,1,NULL),('Contact.Company','contact','View Company','/contact/company_list',NULL,NULL,'',1,'Contact',10,'','','','',1,NULL,1,NULL),('Contact.DCard','contact','View Detailed Card','/contact/contact_detail_card',NULL,NULL,'',1,'Contact',10,'','','','',1,NULL,1,NULL),('Contact.GCard','contact','View General Card','/contact/contact_general_card',NULL,NULL,'',1,'Contact',10,'','','','',1,NULL,1,NULL),('Contact.NewProf','contact','New Contact Profile','/contact/contact_new',NULL,NULL,'',1,'Contact',10,'','','','',1,NULL,1,NULL),('Contact.PhoneBook','contact','View Phone Book','/contact/contact_list',NULL,NULL,'',1,'Contact',10,'','','','',1,NULL,1,NULL),('Contact.Type','contact','Contact Type Manage','/contact/type_manage',NULL,NULL,'',1,'Contact',10,'','','','',1,NULL,1,NULL),('System','system','Administration','/system/general_default',NULL,NULL,'',1,'',10,'Site.Administer_General','','','',1,NULL,1,NULL),('System.Cronjob','cronjob','Cronjob','',NULL,NULL,'',1,'System',40,'','spacer.gif','icon_cronjob','',1,NULL,1,NULL),('System.Cronjob.List','cronjob','Manage CronjobLog','/cronjob/cronjob_list',NULL,NULL,'',1,'System.Cronjob',10,'','','','',1,NULL,1,NULL),('System.EventLog','eventlog','Event Log','',NULL,NULL,'',1,'System',60,'','spacer.gif','icon_eventlog','Event Log Management',1,NULL,1,NULL),('System.EventLog.List','eventlog','Manage EventLog','/eventlog/event_log_list',NULL,NULL,'',1,'System.EventLog',10,'','','','',1,NULL,1,NULL),('System.Group','system','Groups','',NULL,NULL,'',1,'System',12,'','spacer.gif','icon_user','Group Management Module',1,NULL,1,NULL),('System.Group.List','system','Group Management','/system/group_list',NULL,NULL,'',1,'System.Group',10,'','','','',1,NULL,1,NULL),('System.Help','help','Help','',NULL,NULL,'',1,'System',50,'','spacer.gif','icon_help','Help Management',1,NULL,1,NULL),('System.Help.Cat','help','Manage Help Category','/help/help_category',NULL,NULL,'',1,'System.Help',10,'','','','',1,NULL,1,NULL),('System.Htlp.Tip','help','Manage Help Tips','/help/help_list',NULL,NULL,'',1,'System.Help',20,'','','','',1,NULL,1,NULL),('System.Menu','menu','Menu','',NULL,NULL,'',1,'System',30,'','spacer.gif','icon_menu','System Menu Management',1,NULL,1,NULL),('System.Menu.List','menu','Manage Menu by List','/menu/menu_list',NULL,NULL,'',1,'System.Menu',20,'','','','',1,NULL,1,NULL),('System.Menu.Tree','menu','Manage Menu by Tree','/menu/menu_tree',NULL,NULL,'',1,'System.Menu',30,'','','','',1,NULL,1,NULL),('System.Module','system','Modules','',NULL,NULL,'',1,'System',14,'','spacer.gif','icon_module','Modules Management',1,NULL,1,NULL),('System.Modules.Detail','system','Module Detail','/system/module_detail',NULL,NULL,'',1,'System.Modules.List',10,'','','','',1,NULL,1,NULL),('System.Modules.List','system','Module Management','/system/module_list',NULL,NULL,'',1,'System.Module',10,'','','','',1,NULL,1,NULL),('System.Role','system','Roles','',NULL,NULL,'',1,'System',12,'','spacer.gif','icon_role','Role Management Module',1,NULL,1,NULL),('System.Role.Detail','system','Role Detail','/system/role_detail',NULL,NULL,'',1,'System.Role.List',10,'','','','',1,NULL,1,NULL),('System.Role.List','system','Role Management','/system/role_list',NULL,NULL,'',1,'System.Role',10,'','','','',1,NULL,1,NULL),('System.Sipadmin','sipadmin','SIP Admin Menu','/sipadmin/sipadmin_default',NULL,NULL,'',1,'',25,'SIPAdmin.Administer_Modules','spacer.gif','','SIP Admin Management',1,NULL,1,NULL),('System.Sipadmin.Acl','sipadmin','ACL Services','',NULL,NULL,'',1,'System.Sipadmin',30,'','','','',1,NULL,1,NULL),('System.Sipadmin.Acl.Address.List','sipadmin','Permissions - Address','{@home:url}/sipadmin/address_list',NULL,NULL,'',1,'System.Sipadmin.Acl.Permissions.Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Acl.Grp.List','sipadmin','Group List','{@home:url}/sipadmin/grp_list',NULL,NULL,'',1,'System.Sipadmin.Acl.Grp.Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Acl.Grp.Management','sipadmin','Group Management','',NULL,NULL,'',1,'System.Sipadmin.Acl',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Acl.Permissions.Management','sipadmin','Permissions Management','',NULL,NULL,'',1,'System.Sipadmin.Acl',30,'','','','',1,NULL,1,NULL),('System.Sipadmin.Acl.ReGrp.List','sipadmin','RegExp Group List','{@home:url}/sipadmin/re_grp_list',NULL,NULL,'',1,'System.Sipadmin.Acl.Grp.Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Acl.Trusted.List','sipadmin','Permissions - Trusted','{@home:url}/sipadmin/trusted_list',NULL,NULL,'',1,'System.Sipadmin.Acl.Permissions.Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Acs','sipadmin','Accounting Services','',NULL,NULL,'',1,'System.Sipadmin',50,'','','','',1,NULL,1,NULL),('System.Sipadmin.Acs.Acc.Management','sipadmin','Accounting Management','',NULL,NULL,'',1,'System.Sipadmin.Acs',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Acs.Accounting','sipadmin','Accounting List','{@home:url}/sipadmin/acc_list',NULL,NULL,'',1,'System.Sipadmin.Acs.Acc.Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Acs.BillingRates','sipadmin','Billing Rates List','{@home:url}/sipadmin/billing_rates_list',NULL,NULL,'',1,'System.Sipadmin.Acs.Cdrs.Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Acs.Cdrs','sipadmin','CDR List','{@home:url}/sipadmin/cdrs_list',NULL,NULL,'',1,'System.Sipadmin.Acs.Cdrs.Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Acs.Cdrs.Management','sipadmin','CDR Management','',NULL,NULL,'',1,'System.Sipadmin.Acs',30,'','','','',1,NULL,1,NULL),('System.Sipadmin.Acs.MissedCalls','sipadmin','Missed Calls List','{@home:url}/sipadmin/missed_calls_list',NULL,NULL,'',1,'System.Sipadmin.Acs.Acc.Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Charts','sipadmin','Chart Services','',NULL,NULL,'',1,'System.Sipadmin',90,'','','','',1,NULL,1,NULL),('System.Sipadmin.Charts.Load','sipadmin','Load Charts','{@home:url}/sipadmin/charts_load/cg=load',NULL,NULL,'',1,'System.Sipadmin.Charts',30,'','','','',1,NULL,1,NULL),('System.Sipadmin.Charts.Shm','sipadmin','SHM Charts','{@home:url}/sipadmin/charts_shm/cg=shm',NULL,NULL,'',1,'System.Sipadmin.Charts',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Charts.Tm','sipadmin','TM Charts','{@home:url}/sipadmin/charts_tm/cg=tm',NULL,NULL,'',1,'System.Sipadmin.Charts',35,'','','','',1,NULL,1,NULL),('System.Sipadmin.Charts.Usrloc','sipadmin','UsrLoc Charts','{@home:url}/sipadmin/charts_uls/cg=usrloc',NULL,NULL,'',1,'System.Sipadmin.Charts',40,'','','','',1,NULL,1,NULL),('System.Sipadmin.ChartsStatsAcc','sipadmin','Acc Charts','{@home:url}/sipadmin/charts_stats_acc',NULL,NULL,'',1,'System.Sipadmin.Charts',70,'','','','',1,NULL,1,NULL),('System.Sipadmin.ChartsStatsUls','sipadmin','UsrLoc Stats','{@home:url}/sipadmin/charts_stats_uls',NULL,NULL,'',1,'System.Sipadmin.Charts',60,'','','','',1,NULL,1,NULL),('System.Sipadmin.Cms','sipadmin','Command Services','',NULL,NULL,'',1,'System.Sipadmin',80,'','','','',1,NULL,1,NULL),('System.Sipadmin.Cms.Fscmds','sipadmin','FSwitch Commands','{@home:url}/sipadmin/fscmds',NULL,NULL,'',1,'System.Sipadmin.Cms',30,'','','','',1,NULL,1,NULL),('System.Sipadmin.Cms.Jrcmds','sipadmin','JSONRPC Commands','{@home:url}/sipadmin/jrcmds',NULL,NULL,'',1,'System.Sipadmin.Cms',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Cms.Xrcmds','sipadmin','XMLRPC Commands','{@home:url}/sipadmin/xrcmds',NULL,NULL,'',1,'System.Sipadmin.Cms',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Msc','sipadmin','Misc Services','',NULL,NULL,'',1,'System.Sipadmin',70,'','','','',1,NULL,1,NULL),('System.Sipadmin.Msc.Moh.Management','sipadmin','MoH Management','{@home:url}/sipadmin/mohqueues_list',NULL,NULL,'',1,'System.Sipadmin.Msc',30,'','','','',1,NULL,1,NULL),('System.Sipadmin.Msc.Mohqcalls.List','sipadmin','MoH QCalls List','{@home:url}/sipadmin/mohqcalls_list',NULL,NULL,'',1,'System.Sipadmin.Msc.Moh.Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Msc.Mohqueues.List','sipadmin','MoH Queues List','{@home:url}/sipadmin/mohqueues_list',NULL,NULL,'',1,'System.Sipadmin.Msc.Moh.Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Msc.Secfilter.List','sipadmin','SecFilter List','{@home:url}/sipadmin/secfilter_list',NULL,NULL,'',1,'System.Sipadmin.Msc',25,'','','','',1,NULL,1,NULL),('System.Sipadmin.Prs','sipadmin','Presence Services','',NULL,NULL,'',1,'System.Sipadmin',60,'','','','',1,NULL,1,NULL),('System.Sipadmin.Prs.ActiveWatchers','sipadmin','Active Watchers List','{@home:url}/sipadmin/active_watchers_list',NULL,NULL,'',1,'System.Sipadmin.Prs.Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Prs.Management','sipadmin','Management List','',NULL,NULL,'',1,'System.Sipadmin.Prs',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Prs.Presentity','sipadmin','Presentity List','{@home:url}/sipadmin/presentity_list',NULL,NULL,'',1,'System.Sipadmin.Prs.Management',30,'','','','',1,NULL,1,NULL),('System.Sipadmin.Prs.Pua','sipadmin','PUA List','{@home:url}/sipadmin/pua_list',NULL,NULL,'',1,'System.Sipadmin.Prs.Management',40,'','','','',1,NULL,1,NULL),('System.Sipadmin.Prs.Rls. Management','sipadmin','RLS Management','',NULL,NULL,'',1,'System.Sipadmin.Prs',50,'','','','',1,NULL,1,NULL),('System.Sipadmin.Prs.RlsPresentity','sipadmin','RLS Presentity List','{@home:url}/sipadmin/rls_presentity_list',NULL,NULL,'',1,'System.Sipadmin.Prs.Rls. Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Prs.RlsWatchers','sipadmin','RLS Watchers List','{@home:url}/sipadmin/rls_watchers_list',NULL,NULL,'',1,'System.Sipadmin.Prs.Rls. Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Prs.Sca','sipadmin','SCA List','{@home:url}/sipadmin/sca_subscriptions_list',NULL,NULL,'',1,'System.Sipadmin.Prs',80,'','','','',1,NULL,1,NULL),('System.Sipadmin.Prs.Watchers','sipadmin','Watchers List','{@home:url}/sipadmin/watchers_list',NULL,NULL,'',1,'System.Sipadmin.Prs.Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Prs.Xcap','sipadmin','XCAP List','{@home:url}/sipadmin/xcap_list',NULL,NULL,'',1,'System.Sipadmin.Prs',70,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg','sipadmin','Routing Services','',NULL,NULL,'',1,'System.Sipadmin',40,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.CarrierFailureRoute.List','sipadmin','CR Failure List','{@home:url}/sipadmin/carrierfailureroute_list',NULL,NULL,'',1,'System.Sipadmin.Rtg.CarrierRoute.Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.CarrierName.List','sipadmin','CR Name List','{@home:url}/sipadmin/carrier_name_list',NULL,NULL,'',1,'System.Sipadmin.Rtg.CarrierRoute.Management',30,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.CarrierRoute.List','sipadmin','CR Route List','{@home:url}/sipadmin/carrierroute_list',NULL,NULL,'',1,'System.Sipadmin.Rtg.CarrierRoute.Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.CarrierRoute.Management','sipadmin','CarrierRoute Management','',NULL,NULL,'',1,'System.Sipadmin.Rtg',60,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.CRDomainName.List','sipadmin','CR Domain List','{@home:url}/sipadmin/domain_name_list',NULL,NULL,'',1,'System.Sipadmin.Rtg.CarrierRoute.Management',40,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.Dispatcher.List','sipadmin','Dispatcher List','{@home:url}/sipadmin/dispatcher_list',NULL,NULL,'',1,'System.Sipadmin.Rtg',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.DrGateways.List','sipadmin','Dr Gateways List','{@home:url}/sipadmin/dr_gateways_list',NULL,NULL,'',1,'System.Sipadmin.Rtg.Drouting.Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.DrGroups.List','sipadmin','Dr Groups List','{@home:url}/sipadmin/dr_groups_list',NULL,NULL,'',1,'System.Sipadmin.Rtg.Drouting.Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.DrGwLists.List','sipadmin','Dr Gateways Ways Lists List','{@home:url}/sipadmin/dr_gw_lists_list',NULL,NULL,'',1,'System.Sipadmin.Rtg.Drouting.Management',30,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.Drouting.Management','sipadmin','Drouting Management','',NULL,NULL,'',1,'System.Sipadmin.Rtg',70,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.DrRules.List','sipadmin','Dr Rules List','{@home:url}/sipadmin/dr_rules_list',NULL,NULL,'',1,'System.Sipadmin.Rtg.Drouting.Management',40,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.Lcr.Management','sipadmin','LCR Management','',NULL,NULL,'',1,'System.Sipadmin.Rtg',30,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.LcrGw.List','sipadmin','LCR Gateway List','{@home:url}/sipadmin/lcr_gw_list',NULL,NULL,'',1,'System.Sipadmin.Rtg.Lcr.Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.LcrRule.List','sipadmin','LCR Rule List','{@home:url}/sipadmin/lcr_rule_list',NULL,NULL,'',1,'System.Sipadmin.Rtg.Lcr.Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.LcrRuleTarget.List','sipadmin','LCR Target List','{@home:url}/sipadmin/lcr_rule_target_list',NULL,NULL,'',1,'System.Sipadmin.Rtg.Lcr.Management',30,'','','','',1,NULL,1,NULL),('System.Sipadmin.Rtg.Pdt.List','sipadmin','Pdt List','{@home:url}/sipadmin/pdt_list',NULL,NULL,'',1,'System.Sipadmin.Rtg',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Sbs','sipadmin','Subscriber Services','',NULL,NULL,'',1,'System.Sipadmin',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Sbs.Aliasdb.List','sipadmin','Aliases DB List','{@home:url}/sipadmin/aliasdb_list',NULL,NULL,'',1,'System.Sipadmin.Sbs',30,'','','','',1,NULL,1,NULL),('System.Sipadmin.Sbs.Globalblacklist.List','sipadmin','Global Black List','{@home:url}/sipadmin/globalblacklist_list',NULL,NULL,'',1,'System.Sipadmin.Sbs.Userblacklist.Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Sbs.Location.List','sipadmin','Location List','{@home:url}/sipadmin/location_list',NULL,NULL,'',1,'System.Sipadmin.Sbs.Location.Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Sbs.Location.Management','sipadmin','Location Management','',NULL,NULL,'',1,'System.Sipadmin.Sbs',70,'','','','',1,NULL,1,NULL),('System.Sipadmin.Sbs.LocationAttrs.List','sipadmin','Location Attrs List','{@home:url}/sipadmin/location_attrs_list',NULL,NULL,'',1,'System.Sipadmin.Sbs.Location.Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Sbs.Msilo.List','sipadmin','Messages List','{@home:url}/sipadmin/silo_list',NULL,NULL,'',1,'System.Sipadmin.Sbs',80,'','','','',1,NULL,1,NULL),('System.Sipadmin.Sbs.Speeddial.List','sipadmin','Speed Dial List','{@home:url}/sipadmin/speed_dial_list',NULL,NULL,'',1,'System.Sipadmin.Sbs',40,'','','','',1,NULL,1,NULL),('System.Sipadmin.Sbs.Subscriber.List','sipadmin','Subscriber List','{@home:url}/sipadmin/subscriber_list',NULL,NULL,'',1,'System.Sipadmin.Sbs',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Sbs.Uridb.List','sipadmin','URI DB List','{@home:url}/sipadmin/uri_list',NULL,NULL,'',1,'System.Sipadmin.Sbs',60,'','','','',1,NULL,1,NULL),('System.Sipadmin.Sbs.Userblacklist.List','sipadmin','User Black List','{@home:url}/sipadmin/userblacklist_list',NULL,NULL,'',1,'System.Sipadmin.Sbs.Userblacklist.Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Sbs.Userblacklist.Management','sipadmin','Blacklist Management','',NULL,NULL,'',1,'System.Sipadmin.Sbs',90,'','','','',1,NULL,1,NULL),('System.Sipadmin.Sbs.UsrPreferences.List','sipadmin','User Preferences','{@home:url}/sipadmin/usr_preferences_list',NULL,NULL,'',1,'System.Sipadmin.Sbs',50,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv','sipadmin','Server Services','',NULL,NULL,'',1,'System.Sipadmin',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.Dialog.List','sipadmin','Dialog List','{@home:url}/sipadmin/dialog_list',NULL,NULL,'',1,'System.Sipadmin.Srv.Dialog.Management',40,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.Dialog.Management','sipadmin','Dialog Management','',NULL,NULL,'',1,'System.Sipadmin.Srv',40,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.DialogVars.List','sipadmin','Dialog Vars List','{@home:url}/sipadmin/dialog_vars_list',NULL,NULL,'',1,'System.Sipadmin.Srv.Dialog.Management',50,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.Dialplan.List','sipadmin','Dialplan List','{@home:url}/sipadmin/dialplan_list',NULL,NULL,'',1,'System.Sipadmin.Srv',30,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.Domain.List','sipadmin','Domain List','{@home:url}/sipadmin/domain_list',NULL,NULL,'',1,'System.Sipadmin.Srv.Domain.Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.Domain.Management','sipadmin','Domain Management','',NULL,NULL,'',1,'System.Sipadmin.Srv',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.DomainAttrs.List','sipadmin','Domain Attrs List','{@home:url}/sipadmin/domain_attrs_list',NULL,NULL,'',1,'System.Sipadmin.Srv.Domain.Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.Htable.List','sipadmin','HTable List','{@home:url}/sipadmin/htable_list',NULL,NULL,'',1,'System.Sipadmin.Srv',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.Mtree.List','sipadmin','MTree List','{@home:url}/sipadmin/mtree_list',NULL,NULL,'',1,'System.Sipadmin.Srv.Mtrees.Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.Mtrees.List','sipadmin','MTrees List','{@home:url}/sipadmin/mtrees_list',NULL,NULL,'',1,'System.Sipadmin.Srv.Mtrees.Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.Mtrees.Management','sipadmin','MTrees Management','',NULL,NULL,'',1,'System.Sipadmin.Srv',80,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.Rtpengine.List','sipadmin','RTPEngine List','{@home:url}/sipadmin/rtpengine_list',NULL,NULL,'',1,'System.Sipadmin.Msc',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.Rtpproxy.List','sipadmin','RTPProxy List','{@home:url}/sipadmin/rtpproxy_list',NULL,NULL,'',1,'System.Sipadmin.Msc',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.SipTrace.List','sipadmin','SIP Trace List','{@home:url}/sipadmin/sip_trace_list',NULL,NULL,'',1,'System.Sipadmin.Srv',60,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.Topos.Management','sipadmin','Topos Management','',NULL,NULL,'',1,'System.Sipadmin.Srv',90,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.ToposD.List','sipadmin','ToposD List','{@home:url}/sipadmin/topos_d_list',NULL,NULL,'',1,'System.Sipadmin.Srv.Topos.Management',10,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.ToposT.List','sipadmin','ToposT List','{@home:url}/sipadmin/topos_t_list',NULL,NULL,'',1,'System.Sipadmin.Srv.Topos.Management',20,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.UACReg.List','sipadmin','UACReg List','{@home:url}/sipadmin/uacreg_list',NULL,NULL,'',1,'System.Sipadmin.Srv',70,'','','','',1,NULL,1,NULL),('System.Sipadmin.Srv.Version.List','sipadmin','Version List','{@home:url}/sipadmin/version_list',NULL,NULL,'',1,'System.Sipadmin.Msc',40,'','','','',1,NULL,1,NULL),('System.Sipadmin.SummaryStatsAcc','sipadmin','Acc Summary','{@home:url}/sipadmin/summary_stats_acc',NULL,NULL,'',1,'System.Sipadmin.Charts',80,'','','','',1,NULL,1,NULL),('System.Sipuser','sipuser','SIP User Menu','/sipuser/sipuser_default',NULL,NULL,'',1,'',45,'SIPUser.Administer_Modules','spacer.gif','','SIP Profile Management',1,NULL,1,NULL),('System.Sipuser.Acs','sipuser','Accounting','',NULL,NULL,'',1,'System.Sipuser',20,'','','','',1,NULL,1,NULL),('System.Sipuser.Acs.Acc.List','sipuser','Initiated Calls','{@home:url}/sipuser/acc_list',NULL,NULL,'',1,'System.Sipuser.Acs',20,'','','','',1,NULL,1,NULL),('System.Sipuser.Acs.Cdrs.List','sipuser','Call Data Records','{@home:url}/sipuser/cdrs_list',NULL,NULL,'',1,'System.Sipuser.Acs',40,'','','','',1,NULL,1,NULL),('System.Sipuser.Acs.MissedCalls.List','sipuser','Missed Calls','{@home:url}/sipuser/missed_calls_list',NULL,NULL,'',1,'System.Sipuser.Acs',30,'','','','',1,NULL,1,NULL),('System.Sipuser.Sbs','sipuser','Own SIP Profile','',NULL,NULL,'',1,'System.Sipuser',10,'','','','',1,NULL,1,NULL),('System.Sipuser.Sbs.Aliasdb.List','sipuser','Aliases DB Records','{@home:url}/sipuser/aliasdb_list',NULL,NULL,'',1,'System.Sipuser.Sbs',40,'','','','',1,NULL,1,NULL),('System.Sipuser.Sbs.Location.List','sipuser','Location Records','{@home:url}/sipuser/location_list',NULL,NULL,'',1,'System.Sipuser.Sbs',30,'','','','',1,NULL,1,NULL),('System.Sipuser.Sbs.Msilo.List','sipuser','Stored Messages','{@home:url}/sipuser/silo_list',NULL,NULL,'',1,'System.Sipuser.Sbs',60,'','','','',1,NULL,1,NULL),('System.Sipuser.Sbs.Speeddial.List','sipuser','Speed Dial Records','{@home:url}/sipuser/speed_dial_list',NULL,NULL,'',1,'System.Sipuser.Sbs',50,'','','','',1,NULL,1,NULL),('System.Sipuser.Sbs.Subscriber.List','sipuser','Subscriber Data','{@home:url}/sipuser/subscriber_list',NULL,NULL,'',1,'System.Sipuser.Sbs',20,'','','','',1,NULL,1,NULL),('System.Theme','theme','Theme','',NULL,NULL,'',1,'System',50,'','spacer.gif','icon_theme','Theme Management',1,NULL,1,NULL),('System.Theme.Manage','theme','Manage Theme','/theme/manage_theme',NULL,NULL,'',1,'System.Theme',10,'','','','',1,NULL,1,NULL),('System.Translation','translation','Translation','',NULL,NULL,'',1,'System',50,'','spacer.gif','icon_translation','Translation Management',1,NULL,1,NULL),('System.Translation.language','translation','Manage Languages','/translation/manage_language',NULL,NULL,'',1,'System.Translation',30,'','','','',1,NULL,1,NULL),('System.Translation.translation','translation','Manage UI Translation','/translation/manage_translation',NULL,NULL,'',1,'System.Translation',20,'','','','',1,NULL,1,NULL),('System.User','system','Users','',NULL,NULL,'',1,'System',10,'User.Administer_Users','spacer.gif','icon_user','System User Management',1,NULL,1,NULL),('System.User.Detail','system','User Detail','/system/user_detail',NULL,NULL,'',1,'System.User.List',10,'','','','',1,NULL,1,NULL),('System.User.List','system','User Management','/system/user_list',NULL,NULL,'',1,'System.User',10,'','','','',1,NULL,1,NULL);

INSERT IGNORE INTO `acl_action` (`id`, `module`, `resource`, `action`, `description`) VALUES (1,'system','Site','Administer_General','General administration of the site'),(2,'system','User','Administer_Users','Administration of users'),(3,'system','User','Administer_User_ACL','Administration of user access control'),(4,'system','Role','Administer_Roles','Administration of user roles'),(5,'system','Group','Administer_Groups','Administration of user groups'),(6,'system','Module','Administer_Modules','Administration includes view modules, load modules, activate/deactivate modules'),(7,'menu','Menu','Administer_Menu','Can manage menu content for the application'),(8,'contact','contact','access','access my contact'),(9,'cronjob','cronjob','Administer_Cron','Manage cronjobs with crontab syntax'),(10,'eventlog','EventLog','Access_EventLog','Access event logs'),(11,'eventlog','EventLog','Administer_EventLog','Manage event logs'),(12,'help','Help','Administer_Help','Can manage help content for the application'),(13,'sipadmin','SIPAdmin','Administer_Modules','Allowed To Manage All SIP Settings'),(14,'sipuser','SIPUser','Administer_Modules','Can manage own SIP settings'),(15,'theme','Theme','Administer_Theme','Can manage system theme package for the application'),(16,'translation','Menu','Administer_Transation','Can manage user interface translation for the application'),(17,'user','UserAccount','Edit_Own_Account','Can edit user own account data');

INSERT IGNORE INTO `acl_role_action` (`id`, `role_id`, `action_id`, `access_level`) VALUES (1,1,1,'1'),(2,1,2,'1'),(3,1,3,'1'),(4,1,4,'1'),(5,1,5,'1'),(6,1,6,'1'),(7,1,7,'1'),(8,1,8,'1'),(9,1,9,'1'),(10,1,10,'1'),(11,1,11,'1'),(12,1,12,'1'),(13,1,13,'1'),(14,1,14,'1'),(15,1,15,'1'),(16,1,16,'1'),(17,1,17,'1'),(18,2,13,'1'),(19,2,17,'1'),(20,3,14,'1'),(21,3,17,'1');

-- Module: theme

-- Module: translation

-- Module: user

