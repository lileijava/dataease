DROP TABLE IF EXISTS `chart_view_field`;
CREATE TABLE `chart_view_field`
(
    `id`              varchar(50)  NOT NULL COMMENT 'ID',
    `table_id`        varchar(50)  NOT NULL COMMENT '表ID',
    `chart_id`        varchar(50)  NOT NULL COMMENT '视图ID',
    `origin_name`     longtext,
    `name`            varchar(255) NOT NULL COMMENT '字段名',
    `dataease_name`   varchar(255) NOT NULL COMMENT '字段名',
    `group_type`      varchar(50) DEFAULT NULL COMMENT '维度/指标标识 d:维度，q:指标',
    `type`            varchar(50)  NOT NULL COMMENT '原始字段类型',
    `size`            int(11) DEFAULT NULL,
    `de_type`         int(10) NOT NULL COMMENT 'dataease字段类型：0-文本，1-时间，2-整型数值，3-浮点数值...',
    `de_type_format`  int(10) DEFAULT NULL COMMENT '类型格式',
    `de_extract_type` int(10) NOT NULL,
    `ext_field`       int(10) DEFAULT NULL COMMENT '是否扩展字段 0否 1是',
    `checked`         tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否选中',
    `column_index`    int(10) NOT NULL COMMENT '列位置',
    `last_sync_time`  bigint(13) DEFAULT NULL COMMENT '同步时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;


ALTER TABLE `dataset_table` ADD COLUMN `sql_variable_details` LONGTEXT NULL AFTER `last_update_time`;

INSERT INTO `my_plugin` (`name`, `store`, `free`, `cost`, `category`, `descript`, `version`, `creator`, `load_mybatis`,
                         `install_time`, `module_name`, `ds_type`)
VALUES ('达梦数据源插件', 'default', '0', '0', 'datasource', '达梦数据源插件', '1.0-SNAPSHOT', 'DATAEASE', '0',
        '1650765903630', 'dm-backend', 'dm');

update sys_user set nick_name='示例用户' where user_id =2;
DROP VIEW IF EXISTS `v_auth_model`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_auth_model` AS select `sys_user`.`user_id` AS `id`,concat(`sys_user`.`nick_name`,'（',`sys_user`.`username`,'）') AS `name`,`sys_user`.`username` AS `label`,'0' AS `pid`,'leaf' AS `node_type`,'user' AS `model_type`,'user' AS `model_inner_type`,'target' AS `auth_type`,`sys_user`.`create_by` AS `create_by`,0 AS `level`,0 AS `mode`,'0' AS `data_source_id` from `sys_user` where (`sys_user`.`is_admin` <> 1) union all select `sys_role`.`role_id` AS `id`,`sys_role`.`name` AS `name`,`sys_role`.`name` AS `label`,'0' AS `pid`,'leaf' AS `node_type`,'role' AS `model_type`,'role' AS `model_inner_type`,'target' AS `auth_type`,`sys_role`.`create_by` AS `create_by`,0 AS `level`,0 AS `mode`,'0' AS `data_source_id` from `sys_role` union all select `sys_dept`.`dept_id` AS `id`,`sys_dept`.`name` AS `name`,`sys_dept`.`name` AS `lable`,(cast(`sys_dept`.`pid` as char charset utf8mb4) collate utf8mb4_general_ci) AS `pid`,if((`sys_dept`.`sub_count` = 0),'leaf','spine') AS `node_type`,'dept' AS `model_type`,'dept' AS `model_inner_type`,'target' AS `auth_type`,`sys_dept`.`create_by` AS `create_by`,0 AS `level`,0 AS `mode`,'0' AS `data_source_id` from `sys_dept` union all select `datasource`.`id` AS `id`,`datasource`.`name` AS `NAME`,`datasource`.`name` AS `label`,'0' AS `pid`,'leaf' AS `node_type`,'link' AS `model_type`,`datasource`.`type` AS `model_inner_type`,'source' AS `auth_type`,`datasource`.`create_by` AS `create_by`,0 AS `level`,0 AS `mode`,'0' AS `data_source_id` from `datasource` union all select `dataset_group`.`id` AS `id`,`dataset_group`.`name` AS `NAME`,`dataset_group`.`name` AS `lable`,if(isnull(`dataset_group`.`pid`),'0',`dataset_group`.`pid`) AS `pid`,'spine' AS `node_type`,'dataset' AS `model_type`,`dataset_group`.`type` AS `model_inner_type`,'source' AS `auth_type`,`dataset_group`.`create_by` AS `create_by`,`dataset_group`.`level` AS `level`,0 AS `mode`,'0' AS `data_source_id` from `dataset_group` union all select `dataset_table`.`id` AS `id`,`dataset_table`.`name` AS `NAME`,`dataset_table`.`name` AS `lable`,`dataset_table`.`scene_id` AS `pid`,'leaf' AS `node_type`,'dataset' AS `model_type`,`dataset_table`.`type` AS `model_inner_type`,'source' AS `auth_type`,`dataset_table`.`create_by` AS `create_by`,0 AS `level`,`dataset_table`.`mode` AS `mode`,`dataset_table`.`data_source_id` AS `data_source_id` from `dataset_table` union all select `panel_group`.`id` AS `id`,`panel_group`.`name` AS `NAME`,`panel_group`.`name` AS `label`,(case `panel_group`.`id` when 'panel_list' then '0' when 'default_panel' then '0' else `panel_group`.`pid` end) AS `pid`,if((`panel_group`.`node_type` = 'folder'),'spine','leaf') AS `node_type`,'panel' AS `model_type`,`panel_group`.`panel_type` AS `model_inner_type`,'source' AS `auth_type`,`panel_group`.`create_by` AS `create_by`,0 AS `level`,0 AS `mode`,'0' AS `data_source_id` from `panel_group` union all select `sys_menu`.`menu_id` AS `menu_id`,`sys_menu`.`title` AS `name`,`sys_menu`.`title` AS `label`,`sys_menu`.`pid` AS `pid`,if((`sys_menu`.`sub_count` > 0),'spine','leaf') AS `node_type`,'menu' AS `model_type`,(case `sys_menu`.`type` when 0 then 'folder' when 1 then 'menu' when 2 then 'button' end) AS `model_inner_type`,'source' AS `auth_type`,`sys_menu`.`create_by` AS `create_by`,0 AS `level`,0 AS `mode`,'0' AS `data_source_id` from `sys_menu` where ((`sys_menu`.`i_frame` <> 1) or isnull(`sys_menu`.`i_frame`)) union all select `plugin_sys_menu`.`menu_id` AS `menu_id`,`plugin_sys_menu`.`title` AS `name`,`plugin_sys_menu`.`title` AS `label`,`plugin_sys_menu`.`pid` AS `pid`,if((`plugin_sys_menu`.`sub_count` > 0),'spine','leaf') AS `node_type`,'menu' AS `model_type`,(case `plugin_sys_menu`.`type` when 0 then 'folder' when 1 then 'menu' when 2 then 'button' end) AS `model_inner_type`,'source' AS `auth_type`,`plugin_sys_menu`.`create_by` AS `create_by`,0 AS `level`,0 AS `mode`,'0' AS `data_source_id` from `plugin_sys_menu` where ((`plugin_sys_menu`.`i_frame` <> 1) or isnull(`plugin_sys_menu`.`i_frame`));

delete from panel_subject;
INSERT INTO `panel_subject` (`id`, `name`, `type`, `details`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES ('system_2', '系统主题_深色', 'system', '{\"width\":1600,\"height\":900,\"scale\":100,\"scaleWidth\":100,\"scaleHeight\":100,\"selfAdaption\":true,\"auxiliaryMatrix\":true,\"openCommonStyle\":true,\"panel\":{\"themeColor\":\"dark\",\"color\":\"#030B2E\",\"imageUrl\":{},\"backgroundType\":\"color\",\"gap\":\"yes\",\"resultMode\":\"all\",\"resultCount\":1000},\"aidedDesign\":{\"showGrid\":false,\"matrixBase\":4},\"refreshViewLoading\":true,\"refreshUnit\":\"minute\",\"refreshTime\":5,\"themeId\":\"b32bb6c0-f381-11ec-8f96-ef9d1b285eec\",\"chartInfo\":{\"chartTitle\":{\"show\":true,\"fontSize\":\"18\",\"color\":\"#FFFFFF\",\"hPosition\":\"left\",\"vPosition\":\"top\",\"isItalic\":false,\"isBolder\":true},\"chartColor\":{\"value\":\"default\",\"colors\":[\"#5470c6\",\"#91cc75\",\"#fac858\",\"#ee6666\",\"#73c0de\",\"#3ba272\",\"#fc8452\",\"#9a60b4\",\"#ea7ccc\"],\"alpha\":100,\"tableHeaderBgColor\":\"#4E81BB\",\"tableItemBgColor\":\"#131E42\",\"tableFontColor\":\"#ffffff\",\"tableStripe\":true,\"dimensionColor\":\"#ffffff\",\"quotaColor\":\"#4E81BB\",\"tableBorderColor\":\"#CCCCCC\",\"seriesColors\":[]},\"chartCommonStyle\":{\"backgroundColorSelect\":true,\"color\":\"#131E42\",\"alpha\":100,\"borderRadius\":5,\"innerPadding\":0},\"filterStyle\":{\"horizontal\":\"left\",\"vertical\":\"top\",\"color\":\"#FFFFFF\",\"brColor\":\"#4E4B4B\",\"wordColor\":\"#4E4B4B\",\"innerBgColor\":\"#131E42\"}}}', 1656049892765, NULL, NULL, NULL);
INSERT INTO `panel_subject` (`id`, `name`, `type`, `details`, `create_time`, `create_by`, `update_time`, `update_by`) VALUES ('system_1', '系统主题_浅色', 'system', '{\"width\":1600,\"height\":900,\"scale\":100,\"scaleWidth\":100,\"scaleHeight\":100,\"selfAdaption\":true,\"auxiliaryMatrix\":true,\"openCommonStyle\":true,\"panel\":{\"themeColor\":\"light\",\"color\":\"#F1F3F5\",\"imageUrl\":{},\"backgroundType\":\"color\",\"gap\":\"yes\",\"resultMode\":\"all\",\"resultCount\":1000},\"aidedDesign\":{\"showGrid\":false,\"matrixBase\":4},\"refreshViewLoading\":true,\"refreshUnit\":\"minute\",\"refreshTime\":5,\"themeId\":\"b1b1c0f0-f381-11ec-8f96-ef9d1b285eec\",\"chartInfo\":{\"chartTitle\":{\"show\":true,\"fontSize\":\"18\",\"color\":\"#000000\",\"hPosition\":\"left\",\"vPosition\":\"top\",\"isItalic\":false,\"isBolder\":true},\"chartColor\":{\"value\":\"default\",\"colors\":[\"#5470c6\",\"#91cc75\",\"#fac858\",\"#ee6666\",\"#73c0de\",\"#3ba272\",\"#fc8452\",\"#9a60b4\",\"#ea7ccc\"],\"alpha\":100,\"tableHeaderBgColor\":\"#6D9A49\",\"tableItemBgColor\":\"#FFFFFF\",\"tableFontColor\":\"#000000\",\"tableStripe\":true,\"dimensionColor\":\"#000000\",\"quotaColor\":\"#4E81BB\",\"tableBorderColor\":\"#E6E7E4\",\"seriesColors\":[]},\"chartCommonStyle\":{\"backgroundColorSelect\":true,\"color\":\"#FFFFFF\",\"alpha\":100,\"borderRadius\":5,\"innerPadding\":0},\"filterStyle\":{\"horizontal\":\"left\",\"vertical\":\"top\",\"color\":\"#000000\",\"brColor\":\"\",\"wordColor\":\"\",\"innerBgColor\":\"\"}}}', 1656049890290, NULL, NULL, NULL);

