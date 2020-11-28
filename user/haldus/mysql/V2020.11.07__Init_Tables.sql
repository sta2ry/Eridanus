create database `haldus` default charset utf8mb4 collate utf8mb4_unicode_ci;
create user `haldus` identified by 'haldus';
grant all on `haldus`.* to `haldus`;

use haldus;

create table if not exists `haldus`.`t_user`
(
    `id`             bigint unsigned                                                        not null auto_increment comment '',
    `code`           varchar(32)      default ''                                            not null comment '用户业务编码',
    `name`           varchar(32)      default ''                                            not null comment '用户显示名称',
    `type`           int              default '0'                                           not null comment '用户类型',
    `username`       varchar(32)      default ''                                            not null comment '用户名 由用户自定义的',
    `password`       varchar(128)     default ''                                            not null comment '加密的密码文',
    `enable`         tinyint unsigned default 1                                             not null comment '是否有效/激活',
    `email`          varchar(64)      default ''                                            not null comment '邮箱账号',
    `email_verified` tinyint          default '0'                                           not null comment '邮箱是否已验证过',
    `phone`          varchar(32)      default ''                                            not null comment '联系电话/手机号',
    `phone_verified` tinyint          default 0                                             not null comment '联系电话是否已经验证过',
    `avatar`         varchar(255)     default ''                                            not null comment '用户头像',
    `deleted`        tinyint          default 0                                             not null comment '软删除标记',
    `created_at`     datetime         default current_timestamp                             not null comment '创建时间',
    `updated_at`     datetime         default current_timestamp on update current_timestamp not null comment '最新修改的时间',
    primary key (id),
    unique key `uk_haldus_user_username` (`username`),
    unique key `uk_haldus_user_code` (`code`),
    unique key `uk_haldus_user_email` (`email`),
    unique key `uk_haldus_user_phone` (`phone`)
) Engine = INNODB, comment '用户基础信息';

create table if not exists `haldus`.`t_user_source`
(
    `id`                bigint unsigned                       not null auto_increment comment '',
    `user_code`         varchar(32) default ''                not null comment '所记录的用户code',
    `service`           varchar(32) default ''                not null comment '来源什么服务',
    `service_user_code` varchar(64) default ''                not null comment '所记录的用户code',
    `service_key`       varchar(32) default ''                not null comment '服务的具体appid',
    `service_key_code`  varchar(64) default ''                not null comment '所记录的用户code',
    `created_at`        datetime    default current_timestamp not null comment '创建时间',
    primary key (id),
    unique key `uq_haldus_user_source_user_code` (`user_code`),
    unique key `uq_haldus_user_source_service_user_code` (`service_user_code`, `service`),
    unique key `uq_haldus_user_source_service_key_key_code` (`service_key_code`, `service_key`),
    key `ix_haldus_user_source_service_key_code` (`service_key_code`),
    key `ix_haldus_user_source_service_user_code` (`service_user_code`)
) Engine = INNODB, comment '记录用户来源';

create table if not exists `haldus`.`t_user_contact`
(
    `id`             bigint unsigned                                                    not null auto_increment comment '',
    `code`           varchar(32)  default ''                                            not null comment '联系方式编码 业务主键',
    `name`           varchar(32)  default ''                                            not null comment '用户为自己联系方式起的记忆名称 如“家” “公司”',
    `contact`        varchar(32)  default ''                                            not null comment '联系人名称',
    `phone`          varchar(32)  default ''                                            not null comment '联系电话/手机号',
    `phone_verified` tinyint      default 0                                             not null comment '手机号码通过验证',
    `user_code`      varchar(32)  default ''                                            not null comment '表示是哪个用户的联系方式',
    `default`        tinyint      default 0                                             not null comment '表示该地址为用户默认地址',
    `district`       varchar(32)  default ''                                            not null comment '地址区域,街道一级',
    `address`        varchar(128) default ''                                            not null comment '联系地址详情',
    `comment`        varchar(128) default ''                                            not null comment '地址',
    `deleted`        tinyint      default 0                                             not null comment '软删除标记',
    `created_at`     datetime     default current_timestamp                             not null comment '最新建的时间',
    `updated_at`     datetime     default current_timestamp on update current_timestamp not null comment '最新修改的时间',
    primary key (id),
    key `ix_haldus_user_contact_phone` (`phone`),
    key `ix_haldus_user_contact_user_code` (`user_code`)
) Engine = INNODB, comment '用户的联系方式';


create table `haldus`.`t_user_service_wechat_user_info`
(
    `id`         bigint                                                             not null auto_increment,
    `user_code`  varchar(32)  default ''                                            not null comment '本地用户管理用户编码',
    `unionid`    varchar(64)  default ''                                            not null comment '微信集中管理账号的unionid',
    `nickname`   varchar(64)  default ''                                            not null comment '微信用户的昵称',
    `sex`        int          default 0                                             not null comment '微信用户的性别',
    `headimgurl` varchar(64)  default ''                                            not null comment '头像图片url',
    `city`       varchar(64)  default ''                                            not null comment '城市',
    `province`   varchar(64)  default ''                                            not null comment '省',
    `country`    varchar(64)  default ''                                            not null comment '国家',
    `language`   varchar(64)  default ''                                            not null comment '语言',
    `comment`    varchar(128) default ''                                            not null comment '备注',
    `deleted`    tinyint      default 0                                             not null comment '软删除标记',
    `created_at` datetime     default current_timestamp                             not null comment '最新建的时间',
    `updated_at` datetime     default current_timestamp on update current_timestamp not null comment '最新修改的时间',
    primary key (id),
    unique key unq_wechat_user_info_user_code (user_code),
    unique key unq_wechat_user_info_unionid (unionid),
    key idx_wechat_user_info_city (city(20)),
    key idx_wechat_user_info_province (province(20)),
    key idx_wechat_user_info_country (country(20)),
    key idx_wechat_user_info_language (`language`(20))
) Engine = INNODB, comment '微信的用户信息';


create table `haldus`.t_user_service_wechat_user_xxxxx
(
    `id`             bigint                                                             not null auto_increment,
    `user_code`      varchar(32)  default ''                                            not null comment '本地用户管理用户编码',
    `openid`         varchar(64)  default ''                                            not null comment '微信对于本服务号的openid',
    `unionid`        varchar(64)  default ''                                            not null comment '微信集中管理账号的unionid',
    `access_token`   varchar(64)  default ''                                            not null comment '访问令牌',
    `access_period`  int          default 7200                                          not null comment '当前访问令牌的时长,自refresh_time算起',
    `refresh_token`  varchar(64)  default ''                                            not null comment '刷新访问令牌的令牌',
    `refresh_time`   datetime     default current_timestamp                             not null comment '刷新访问领牌的时间,即访问令牌的有效起始时间',
    `subscribed`     tinyint      default 0                                             not null comment '是否关注了本服务号',
    `subscribe_time` datetime     default current_timestamp                             not null comment '关注本服务号的时间',
    `groupid`        varchar(64)  default ''                                            not null comment '分组id',
    `comment`        varchar(128) default ''                                            not null comment '备注',
    `deleted`        tinyint      default 0                                             not null comment '软删除标记',
    `created_at`     datetime     default current_timestamp                             not null comment '最新建的时间',
    `updated_at`     datetime     default current_timestamp on update current_timestamp not null comment '最新修改的时间',
    primary key (id),
    unique key unq_user_service_wechat_user_xxxxx_user_code (user_code),
    unique key unq_user_service_wechat_user_xxxxx_openid (openid),
    unique key idx_user_service_wechat_user_xxxxx_unionid (unionid),
    key idx_user_service_wechat_user_xxxxx_access_token (access_token(20)),
    key idx_user_service_wechat_user_xxxxx_refresh_token (refresh_token(20)),
    key idx_user_service_wechat_user_xxxxx_groupid (groupid(20))
) Engine = INNODB, comment '公众号xxxxx的用户信息';