/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2026/6/16 19:14:28                           */
/*==============================================================*/


drop trigger trg_公告_状态校验;

drop trigger trg_参赛安排_参与类型校验;

drop trigger trg_场地_时间校验;

drop trigger trg_场地_状态校验;

drop trigger trg_成绩_唯一性;

drop trigger trg_报名项目_类型校验;

drop trigger trg_报名项目_个人报名上限;

drop trigger trg_报名项目_个人报名下限;

drop trigger trg_报名项目_队伍报名上限;

drop trigger trg_报名项目_状态校验;

drop trigger trg_报名项目_性别校验;

drop trigger trg_用户_角色校验;

drop trigger trg_用户_性别校验;

drop trigger trg_裁判_时间冲突;

drop trigger trg_赛事_日期校验;

drop trigger trg_赛事_状态校验;

drop trigger trg_赛程_时间校验;

drop trigger trg_赛程_场地冲突;

drop trigger trg_赛程_轮次校验;

drop trigger trg_赛程_状态校验;

drop trigger trg_队伍_状态校验;

drop trigger trg_成员操作_状态校验;

drop trigger trg_成员_性别校验;

drop trigger trg_项目_类型校验;

drop table if exists 公告;

drop table if exists 参赛安排;

drop table if exists 场地;

drop table if exists 成绩;

drop table if exists 报名者;

drop table if exists 报名项目;

drop table if exists 操作日志;

drop table if exists 用户;

drop table if exists 裁判执行赛程;

drop table if exists 赛事;

drop table if exists 赛程;

drop table if exists 队伍;

drop table if exists 队伍关系成员操作;

drop table if exists 项目;

/*==============================================================*/
/* Table: 公告                                                    */
/*==============================================================*/
create table 公告
(
   公告ID                 int not null auto_increment comment '主键，自增',
   标题                   varchar(100) not null comment '公告标题',
   内容                   text not null comment '公告正文',
   创建时间                 datetime not null comment '发布时间',
   状态                   varchar(10) not null default '正常' comment '正常/已删除',
   fk_创建人ID             int not null comment '发布人用户ID',
   fk_赛事ID              int default NULL comment '关联赛事ID，系统级公告可为空',
   primary key (公告ID)
);

/*==============================================================*/
/* Table: 参赛安排                                                  */
/*==============================================================*/
create table 参赛安排
(
   参赛安排ID               int not null auto_increment comment '主键，自增',
   fk_赛程ID              int not null,
   参与类型                 varchar(10) not null comment '运动员/队伍',
   参与方ID                varchar(20) not null comment '运动员ID或队伍ID，由参与类型决定',
   primary key (参赛安排ID)
);

/*==============================================================*/
/* Table: 场地                                                    */
/*==============================================================*/
create table 场地
(
   场地ID                 int not null auto_increment comment '主键，自增',
   名称                   varchar(50) not null comment '场地名称',
   状态                   varchar(10) not null default '空闲' comment '空闲/使用中',
   借用时间                 datetime,
   归还时间                 datetime,
   primary key (场地ID)
);

/*==============================================================*/
/* Table: 成绩                                                    */
/*==============================================================*/
create table 成绩
(
   成绩ID                 int not null auto_increment,
   fk_参赛安排ID            varchar(40) not null comment '主键，自增',
   成绩                   varchar(20),
   名次                   int not null,
   状态                   bool not null,
   fk_管理员ID             varchar(20) not null,
   fk_裁判ID              varchar(1024),
   fk_运动员ID             varchar(20) not null,
   fk_队伍ID              int not null comment '主键，自增',
   primary key (成绩ID)
);

/*==============================================================*/
/* Table: 报名者                                                   */
/*==============================================================*/
create table 报名者
(
   fk_报名ID              int not null,
   fk_用户ID              int comment '主键',
   fk_队伍ID              int comment '主键，自增',
   primary key (fk_报名ID)
);

/*==============================================================*/
/* Table: 报名项目                                                  */
/*==============================================================*/
create table 报名项目
(
   项目ID                 int not null auto_increment comment '主键，自增',
   报名ID                 int not null,
   状态                   varchar(100),
   申请时间                 datetime,
   primary key (项目ID, 报名ID)
);

/*==============================================================*/
/* Table: 操作日志                                                  */
/*==============================================================*/
create table 操作日志
(
   日志ID                 int not null auto_increment comment '主键，自增',
   动作                   varchar(50) not null comment '操作动作名称',
   描述                   varchar(500) default NULL comment '操作详细描述',
   时间戳                  datetime not null comment '操作时间',
   fk_管理员ID             int not null comment '操作用户ID',
   primary key (日志ID)
);

/*==============================================================*/
/* Table: 用户                                                    */
/*==============================================================*/
create table 用户
(
   用户ID                 int not null comment '主键',
   用户名                  varchar(50) not null comment '登录用户名，唯一',
   密码                   varchar(100) not null comment '加密后密码',
   角色                   varchar(10) not null comment '管理员/校体育处/裁判/运动员/观众',
   姓名                   varchar(50) not null comment '真实姓名',
   部门                   varchar(100) default NULL comment '所属部门，可为空',
   性别                   char(10) not null,
   primary key (用户ID)
);

/*==============================================================*/
/* Table: 裁判执行赛程                                                */
/*==============================================================*/
create table 裁判执行赛程
(
   fk_裁判ID              int not null comment '主键，自增',
   fk_赛程ID              int not null comment '主键，自增',
   执裁安排                 varchar(40),
   primary key (fk_裁判ID, fk_赛程ID)
);

/*==============================================================*/
/* Table: 赛事                                                    */
/*==============================================================*/
create table 赛事
(
   赛事ID                 int not null auto_increment comment '主键，自增',
   名称                   varchar(100) not null comment '赛事名称',
   描述                   text default NULL comment '赛事描述',
   开始日期                 date not null comment '赛事开始日期',
   结束日期                 date not null comment '赛事结束日期',
   状态                   varchar(10) not null default '筹备中' comment '筹备中/进行中/已结束',
   fk_体育处ID             int not null comment '创建该赛事的用户ID',
   primary key (赛事ID)
);

/*==============================================================*/
/* Table: 赛程                                                    */
/*==============================================================*/
create table 赛程
(
   赛程ID                 int not null auto_increment comment '主键，自增',
   轮次                   varchar(20) not null comment '预赛/半决赛/决赛等',
   开始时间                 datetime not null comment '比赛开始时间',
   结束时间                 datetime not null comment '比赛结束时间',
   状态                   varchar(10) not null default '已安排' comment '已安排/已发布/已完成',
   fk_项目ID              int not null comment '所属项目ID',
   fk_场地ID              int not null comment '比赛场地ID',
   primary key (赛程ID)
);

/*==============================================================*/
/* Table: 队伍                                                    */
/*==============================================================*/
create table 队伍
(
   队伍ID                 int not null comment '主键，自增',
   名称                   varchar(50) not null comment '队伍名称',
   状态                   varchar(10) not null default '待审核' comment '待审核/已通过/已拒绝/已解散',
   fk_队长ID              int not null comment '队长用户ID',
   primary key (队伍ID)
);

/*==============================================================*/
/* Table: 队伍关系成员操作                                              */
/*==============================================================*/
create table 队伍关系成员操作
(
   fk_队伍ID              int not null comment '主键，自增',
   fk_用户ID              int not null comment '主键，自增',
   操作状态                 varchar(20) not null,
   primary key (fk_队伍ID, fk_用户ID)
);

/*==============================================================*/
/* Table: 项目                                                    */
/*==============================================================*/
create table 项目
(
   项目ID                 int not null auto_increment comment '主键，自增',
   名称                   varchar(50) not null comment '项目名称',
   类型                   varchar(10) not null comment '个人/团体',
   性别限制                 varchar(10) not null comment '男/女/混合',
   最少人数                 int not null default 1 comment '最少参赛人数',
   最多人数                 int not null default 1 comment '最多参赛人数',
   最大报名队伍数              int default NULL comment '团体项目最大报名队伍数，个人项目可为空',
   fk_赛事ID              int not null comment '所属赛事ID',
   primary key (项目ID)
);

alter table 公告 add constraint FK_包含 foreign key (fk_赛事ID)
      references 赛事 (赛事ID) on delete restrict on update restrict;

alter table 公告 add constraint FK_发布 foreign key (fk_创建人ID)
      references 用户 (用户ID) on delete restrict on update restrict;

alter table 参赛安排 add constraint FK_包含 foreign key (fk_赛程ID)
      references 赛程 (赛程ID) on delete restrict on update restrict;

alter table 成绩 add constraint FK_参赛结果 foreign key (fk_运动员ID)
      references 用户 (用户ID) on delete restrict on update restrict;

alter table 成绩 add constraint FK_参赛结果 foreign key (fk_队伍ID)
      references 队伍 (队伍ID) on delete restrict on update restrict;

alter table 成绩 add constraint FK_来自 foreign key (fk_参赛安排ID)
      references 参赛安排 (参赛安排ID) on delete restrict on update restrict;

alter table 成绩 add constraint FK_管理 foreign key (fk_管理员ID)
      references 用户 (用户ID) on delete restrict on update restrict;

alter table 成绩 add constraint FK_评判并记录 foreign key (fk_裁判ID)
      references 用户 (用户ID) on delete restrict on update restrict;

alter table 报名者 add constraint FK_成为 foreign key (fk_用户ID)
      references 用户 (用户ID) on delete restrict on update restrict;

alter table 报名者 add constraint FK_成为 foreign key (fk_队伍ID)
      references 队伍 (队伍ID) on delete restrict on update restrict;

alter table 报名项目 add constraint FK_报名 foreign key (报名ID)
      references 报名者 (fk_报名ID) on delete restrict on update restrict;

alter table 报名项目 add constraint FK_被报名 foreign key (项目ID)
      references 项目 (项目ID) on delete restrict on update restrict;

alter table 操作日志 add constraint FK_生成日志 foreign key (fk_管理员ID)
      references 用户 (用户ID) on delete restrict on update restrict;

alter table 裁判执行赛程 add constraint FK_裁判执行赛程 foreign key (fk_裁判ID)
      references 用户 (用户ID) on delete restrict on update restrict;

alter table 裁判执行赛程 add constraint FK_赛程被执行 foreign key (fk_赛程ID)
      references 赛程 (赛程ID) on delete restrict on update restrict;

alter table 赛事 add constraint FK_创建 foreign key (fk_体育处ID)
      references 用户 (用户ID) on delete restrict on update restrict;

alter table 赛程 add constraint FK_使用 foreign key (fk_场地ID)
      references 场地 (场地ID) on delete restrict on update restrict;

alter table 赛程 add constraint FK_包含 foreign key (fk_项目ID)
      references 项目 (项目ID) on delete restrict on update restrict;

alter table 队伍 add constraint FK_创建 foreign key (fk_队长ID)
      references 用户 (用户ID) on delete restrict on update restrict;

alter table 队伍关系成员操作 add constraint FK_队伍关系成员操作 foreign key (fk_用户ID)
      references 用户 (用户ID) on delete restrict on update restrict;

alter table 队伍关系成员操作 add constraint FK_队伍关系成员操作 foreign key (fk_队伍ID)
      references 队伍 (队伍ID) on delete restrict on update restrict;

alter table 项目 add constraint FK_包含 foreign key (fk_赛事ID)
      references 赛事 (赛事ID) on delete restrict on update restrict;


DELIMITER //

CREATE TRIGGER trg_公告_状态校验
BEFORE INSERT ON 公告
FOR EACH ROW
BEGIN
    IF NEW.状态 NOT IN ('已发布', '已撤回') THEN
        UPDATE `ERROR: 公告状态值无效，合法值为: 已发布|已撤回` SET x = 1;
    END IF;
END//

CREATE TRIGGER trg_公告_状态校验_upd
BEFORE UPDATE ON 公告
FOR EACH ROW
BEGIN
    IF NEW.状态 NOT IN ('已发布', '已撤回') THEN
        UPDATE `ERROR: 公告状态值无效，合法值为: 已发布|已撤回` SET x = 1;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_参赛安排_参与类型校验
BEFORE INSERT ON 参赛安排
FOR EACH ROW
BEGIN
    IF NEW.参与类型 NOT IN ('个人', '队伍') THEN
        UPDATE `ERROR: 参与类型值无效，合法值为: 个人|队伍` SET x = 1;
    END IF;
END//

CREATE TRIGGER trg_参赛安排_参与类型校验_upd
BEFORE UPDATE ON 参赛安排
FOR EACH ROW
BEGIN
    IF NEW.参与类型 NOT IN ('个人', '队伍') THEN
        UPDATE `ERROR: 参与类型值无效，合法值为: 个人|队伍` SET x = 1;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_场地_时间校验
BEFORE INSERT ON 场地
FOR EACH ROW
BEGIN
    IF NEW.借用时间 IS NOT NULL AND NEW.归还时间 IS NOT NULL
       AND NEW.借用时间 >= NEW.归还时间 THEN
        UPDATE `ERROR: 场地借用时间必须早于归还时间` SET x = 1;
    END IF;
END//

CREATE TRIGGER trg_场地_时间校验_upd
BEFORE UPDATE ON 场地
FOR EACH ROW
BEGIN
    IF NEW.借用时间 IS NOT NULL AND NEW.归还时间 IS NOT NULL
       AND NEW.借用时间 >= NEW.归还时间 THEN
        UPDATE `ERROR: 场地借用时间必须早于归还时间` SET x = 1;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_场地_状态校验
BEFORE INSERT ON 场地
FOR EACH ROW
BEGIN
    IF NEW.状态 NOT IN ('可用', '已占用', '维修中') THEN
        UPDATE `ERROR: 场地状态值无效，合法值为: 可用|已占用|维修中` SET x = 1;
    END IF;
END//

CREATE TRIGGER trg_场地_状态校验_upd
BEFORE UPDATE ON 场地
FOR EACH ROW
BEGIN
    IF NEW.状态 NOT IN ('可用', '已占用', '维修中') THEN
        UPDATE `ERROR: 场地状态值无效，合法值为: 可用|已占用|维修中` SET x = 1;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_成绩_唯一性
BEFORE INSERT ON 成绩
FOR EACH ROW
BEGIN
    DECLARE dup_count INT;

    SELECT COUNT(*) INTO dup_count
    FROM 成绩
    WHERE fk_参赛安排ID = NEW.fk_参赛安排ID
      AND fk_运动员ID = NEW.fk_运动员ID
      AND fk_队伍ID = NEW.fk_队伍ID;

    IF dup_count > 0 THEN
        UPDATE `ERROR: 该参赛安排下已存在此参与方的成绩记录` SET x = 1;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_报名项目_类型校验
BEFORE INSERT ON 报名项目
FOR EACH ROW
BEGIN
    DECLARE proj_type VARCHAR(10);

    SELECT 类型 INTO proj_type FROM 项目 WHERE 项目ID = NEW.项目ID;

    IF proj_type = '个人' THEN
        -- 个人项目：报名ID 必须属于用户（运动员）
        IF NOT EXISTS (SELECT 1 FROM 用户 WHERE 报名ID = NEW.报名ID) THEN
            UPDATE `ERROR: 个人项目只能以个人身份报名` SET x = 1;
        END IF;

    ELSEIF proj_type = '团体' THEN
        -- 团体项目：报名ID 必须属于队伍
        IF NOT EXISTS (SELECT 1 FROM 队伍 WHERE 报名ID = NEW.报名ID) THEN
            UPDATE `ERROR: 团体项目只能以队伍身份报名` SET x = 1;
        END IF;

    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_报名项目_个人报名上限
BEFORE INSERT ON 报名项目
FOR EACH ROW
BEGIN
    DECLARE proj_type VARCHAR(10);
    DECLARE total_athletes INT;
    DECLARE max_members INT;

    SELECT 类型 INTO proj_type FROM 项目 WHERE 项目ID = NEW.项目ID;

    IF proj_type = '个人' THEN

        SELECT COUNT(*) INTO total_athletes
        FROM 报名项目 bm
        JOIN 用户 u ON bm.报名ID = u.报名ID
        WHERE bm.项目ID = NEW.项目ID;

        SELECT 最多人数 INTO max_members
        FROM 项目 WHERE 项目ID = NEW.项目ID;

        IF max_members IS NOT NULL AND total_athletes >= max_members THEN
            UPDATE `ERROR: 该项目个人报名人数已达上限` SET x = 1;
        END IF;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_报名项目_个人报名下限
BEFORE DELETE ON 报名项目
FOR EACH ROW
BEGIN
    DECLARE proj_type VARCHAR(10);
    DECLARE total_athletes INT;
    DECLARE min_members INT;

    SELECT 类型 INTO proj_type FROM 项目 WHERE 项目ID = OLD.项目ID;

    IF proj_type = '个人' THEN

        SELECT COUNT(*) INTO total_athletes
        FROM 报名项目 bm
        JOIN 用户 u ON bm.报名ID = u.报名ID
        WHERE bm.项目ID = OLD.项目ID;

        SELECT 最少人数 INTO min_members
        FROM 项目 WHERE 项目ID = OLD.项目ID;

        IF min_members IS NOT NULL AND (total_athletes - 1) < min_members THEN
            UPDATE `ERROR: 该项目个人报名人数不能低于最少人数` SET x = 1;
        END IF;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_报名项目_队伍报名上限
BEFORE INSERT ON 报名项目
FOR EACH ROW
BEGIN
    DECLARE proj_type VARCHAR(10);
    DECLARE total_teams INT;
    DECLARE max_teams INT;

    SELECT 类型 INTO proj_type FROM 项目 WHERE 项目ID = NEW.项目ID;

    IF proj_type = '团体' THEN

        SELECT COUNT(*) INTO total_teams
        FROM 报名项目 bm
        JOIN 队伍 d ON bm.报名ID = d.报名ID
        WHERE bm.项目ID = NEW.项目ID;

        SELECT 最大报名队伍数 INTO max_teams
        FROM 项目 WHERE 项目ID = NEW.项目ID;

        IF max_teams IS NOT NULL AND total_teams >= max_teams THEN
            UPDATE `ERROR: 该项目队伍报名已达上限` SET x = 1;
        END IF;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_报名项目_状态校验
BEFORE INSERT ON 报名项目
FOR EACH ROW
BEGIN
    IF NEW.状态 NOT IN ('待审核', '已通过', '已拒绝', '已取消') THEN
        UPDATE `ERROR: 报名状态值无效，合法值为: 待审核|已通过|已拒绝|已取消` SET x = 1;
    END IF;
END//

CREATE TRIGGER trg_报名项目_状态校验_upd
BEFORE UPDATE ON 报名项目
FOR EACH ROW
BEGIN
    IF NEW.状态 NOT IN ('待审核', '已通过', '已拒绝', '已取消') THEN
        UPDATE `ERROR: 报名状态值无效，合法值为: 待审核|已通过|已拒绝|已取消` SET x = 1;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_报名项目_性别校验
BEFORE INSERT ON 报名项目
FOR EACH ROW
BEGIN
    DECLARE proj_gender VARCHAR(10);
    DECLARE user_gender VARCHAR(2);

    SELECT 性别限制 INTO proj_gender FROM 项目 WHERE 项目ID = NEW.项目ID;

    -- 只要项目不限性别，直接放行
    IF proj_gender != '不限' THEN

        SELECT 性别 INTO user_gender FROM 用户 WHERE 报名ID = NEW.报名ID;

        IF user_gender IS NULL THEN
            UPDATE `ERROR: 报名人未填写性别，无法报名有性别限制的项目` SET x = 1;
        ELSEIF user_gender != proj_gender THEN
            UPDATE `ERROR: 报名人性别与项目性别限制不匹配` SET x = 1;
        END IF;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_用户_角色校验
BEFORE INSERT ON 用户
FOR EACH ROW
BEGIN
    IF NEW.角色 NOT IN ('管理员', '裁判', '运动员', '体育处') THEN
        UPDATE `ERROR: 角色值无效，合法值为: 管理员|裁判|运动员|体育处` SET x = 1;
    END IF;
END//

CREATE TRIGGER trg_用户_角色校验_upd
BEFORE UPDATE ON 用户
FOR EACH ROW
BEGIN
    IF NEW.角色 NOT IN ('管理员', '裁判', '运动员', '体育处') THEN
        UPDATE `ERROR: 角色值无效，合法值为: 管理员|裁判|运动员|体育处` SET x = 1;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_用户_性别校验
BEFORE INSERT ON 用户
FOR EACH ROW
BEGIN
    IF NEW.性别 IS NOT NULL AND NEW.性别 NOT IN ('男', '女') THEN
        UPDATE `ERROR: 性别值无效，合法值为: 男|女` SET x = 1;
    END IF;
END//

CREATE TRIGGER trg_用户_性别校验_upd
BEFORE UPDATE ON 用户
FOR EACH ROW
BEGIN
    IF NEW.性别 IS NOT NULL AND NEW.性别 NOT IN ('男', '女') THEN
        UPDATE `ERROR: 性别值无效，合法值为: 男|女` SET x = 1;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_裁判_时间冲突
BEFORE INSERT ON 裁判执行赛程
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;

    SELECT COUNT(*) INTO conflict_count
    FROM 裁判执行赛程 rs
    JOIN 赛程 sc ON rs.fk_赛程ID = sc.赛程ID
    JOIN 赛程 new_sc ON new_sc.赛程ID = NEW.fk_赛程ID
    WHERE rs.fk_裁判ID = NEW.fk_裁判ID
      AND sc.状态 != '已取消'
      AND new_sc.开始时间 < sc.结束时间
      AND new_sc.结束时间 > sc.开始时间;

    IF conflict_count > 0 THEN
        UPDATE `ERROR: 该裁判在此时段已有其他执裁安排` SET x = 1;
    END IF;
END//

CREATE TRIGGER trg_裁判_时间冲突_upd
BEFORE UPDATE ON 裁判执行赛程
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;

    IF NEW.fk_赛程ID != OLD.fk_赛程ID OR NEW.fk_裁判ID != OLD.fk_裁判ID THEN

        SELECT COUNT(*) INTO conflict_count
        FROM 裁判执行赛程 rs
        JOIN 赛程 sc ON rs.fk_赛程ID = sc.赛程ID
        JOIN 赛程 new_sc ON new_sc.赛程ID = NEW.fk_赛程ID
        WHERE rs.fk_裁判ID = NEW.fk_裁判ID
          AND rs.fk_赛程ID != NEW.fk_赛程ID
          AND sc.状态 != '已取消'
          AND new_sc.开始时间 < sc.结束时间
          AND new_sc.结束时间 > sc.开始时间;

        IF conflict_count > 0 THEN
            UPDATE `ERROR: 该裁判在此时段已有其他执裁安排` SET x = 1;
        END IF;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_赛事_日期校验
BEFORE INSERT ON 赛事
FOR EACH ROW
BEGIN
    IF NEW.开始日期 > NEW.结束日期 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '赛事开始日期不能晚于结束日期';
    END IF;
END//

CREATE TRIGGER trg_赛事_日期校验_upd
BEFORE UPDATE ON 赛事
FOR EACH ROW
BEGIN
    IF NEW.开始日期 > NEW.结束日期 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '赛事开始日期不能晚于结束日期';
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_赛事_状态校验
BEFORE INSERT ON 赛事
FOR EACH ROW
BEGIN
    IF NEW.状态 NOT IN ('报名中', '进行中', '已结束', '已取消') THEN
        UPDATE `ERROR: 赛事状态值无效，合法值为: 报名中|进行中|已结束|已取消` SET x = 1;
    END IF;
END//

CREATE TRIGGER trg_赛事_状态校验_upd
BEFORE UPDATE ON 赛事
FOR EACH ROW
BEGIN
    IF NEW.状态 NOT IN ('报名中', '进行中', '已结束', '已取消') THEN
        UPDATE `ERROR: 赛事状态值无效，合法值为: 报名中|进行中|已结束|已取消` SET x = 1;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_赛程_时间校验
BEFORE INSERT ON 赛程
FOR EACH ROW
BEGIN
    IF NEW.开始时间 >= NEW.结束时间 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '赛程开始时间必须早于结束时间';
    END IF;
END//

CREATE TRIGGER trg_赛程_时间校验_upd
BEFORE UPDATE ON 赛程
FOR EACH ROW
BEGIN
    IF NEW.开始时间 >= NEW.结束时间 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '赛程开始时间必须早于结束时间';
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_赛程_场地冲突
BEFORE INSERT ON 赛程
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;

    SELECT COUNT(*) INTO conflict_count
    FROM 赛程
    WHERE fk_场地ID = NEW.fk_场地ID
      AND 状态 != '已取消'
      AND NEW.开始时间 < 结束时间
      AND NEW.结束时间 > 开始时间;

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '该场地在指定时段已被占用，请选择其他时间或场地';
    END IF;
END//

CREATE TRIGGER trg_赛程_场地冲突_upd
BEFORE UPDATE ON 赛程
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;

    -- 只在场地或时间发生变化时检查
    IF NEW.fk_场地ID != OLD.fk_场地ID
       OR NEW.开始时间 != OLD.开始时间
       OR NEW.结束时间 != OLD.结束时间 THEN

        SELECT COUNT(*) INTO conflict_count
        FROM 赛程
        WHERE fk_场地ID = NEW.fk_场地ID
          AND 赛程ID != NEW.赛程ID
          AND 状态 != '已取消'
          AND NEW.开始时间 < 结束时间
          AND NEW.结束时间 > 开始时间;

        IF conflict_count > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '该场地在指定时段已被占用，请选择其他时间或场地';
        END IF;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_赛程_轮次校验
BEFORE INSERT ON 赛程
FOR EACH ROW
BEGIN
    IF NEW.轮次 NOT IN ('预赛', '复赛', '半决赛', '决赛') THEN
        UPDATE `ERROR: 赛程轮次值无效，合法值为: 预赛|复赛|半决赛|决赛` SET x = 1;
    END IF;
END//

CREATE TRIGGER trg_赛程_轮次校验_upd
BEFORE UPDATE ON 赛程
FOR EACH ROW
BEGIN
    IF NEW.轮次 NOT IN ('预赛', '复赛', '半决赛', '决赛') THEN
        UPDATE `ERROR: 赛程轮次值无效，合法值为: 预赛|复赛|半决赛|决赛` SET x = 1;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_赛程_状态校验
BEFORE INSERT ON 赛程
FOR EACH ROW
BEGIN
    IF NEW.状态 NOT IN ('待进行', '进行中', '已结束', '已取消') THEN
        UPDATE `ERROR: 赛程状态值无效，合法值为: 待进行|进行中|已结束|已取消` SET x = 1;
    END IF;
END//

CREATE TRIGGER trg_赛程_状态校验_upd
BEFORE UPDATE ON 赛程
FOR EACH ROW
BEGIN
    IF NEW.状态 NOT IN ('待进行', '进行中', '已结束', '已取消') THEN
        UPDATE `ERROR: 赛程状态值无效，合法值为: 待进行|进行中|已结束|已取消` SET x = 1;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_队伍_状态校验
BEFORE INSERT ON 队伍
FOR EACH ROW
BEGIN
    IF NEW.状态 NOT IN ('正常', '取消','审核') THEN
        UPDATE `ERROR: 队伍状态值无效，合法值为: 正常|取消|审核` SET x = 1;
    END IF;
END//

CREATE TRIGGER trg_队伍_状态校验_upd
BEFORE UPDATE ON 队伍
FOR EACH ROW
BEGIN
    IF NEW.状态 NOT IN ('正常', '取消','审核') THEN
        UPDATE `ERROR: 队伍状态值无效，合法值为: 正常|取消|审核` SET x = 1;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_成员操作_状态校验
BEFORE INSERT ON 队伍关系成员操作
FOR EACH ROW
BEGIN
    IF NEW.操作状态 NOT IN ('已加入', '已退出', '待审批') THEN
        UPDATE `ERROR: 操作状态值无效，合法值为: 已加入|已退出|待审批` SET x = 1;
    END IF;
END//

CREATE TRIGGER trg_成员操作_状态校验_upd
BEFORE UPDATE ON 队伍关系成员操作
FOR EACH ROW
BEGIN
    IF NEW.操作状态 NOT IN ('已加入', '已退出', '待审批') THEN
        UPDATE `ERROR: 操作状态值无效，合法值为: 已加入|已退出|待审批` SET x = 1;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_成员_性别校验
BEFORE INSERT ON 队伍关系成员操作
FOR EACH ROW
BEGIN
    DECLARE proj_gender VARCHAR(10);
    DECLARE user_gender VARCHAR(2);

    IF NEW.操作状态 = '已加入' THEN

        SELECT p.性别限制 INTO proj_gender
        FROM 项目 p
        JOIN 报名项目 bm ON p.项目ID = bm.项目ID
        WHERE bm.报名ID = NEW.报名ID
        LIMIT 1;

        IF proj_gender IS NOT NULL AND proj_gender != '不限' THEN

            SELECT 性别 INTO user_gender FROM 用户 WHERE 用户ID = NEW.fk_用户ID;

            IF user_gender IS NULL THEN
                UPDATE `ERROR: 该用户未填写性别，无法加入有性别限制的项目` SET x = 1;
            ELSEIF user_gender != proj_gender THEN
                UPDATE `ERROR: 该用户性别与项目性别限制不匹配` SET x = 1;
            END IF;
        END IF;
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_项目_类型校验
BEFORE INSERT ON 项目
FOR EACH ROW
BEGIN
    IF NEW.类型 NOT IN ('个人', '团体') THEN
        UPDATE `ERROR: 项目类型值无效，合法值为: 个人|团体` SET x = 1;
    END IF;
END//

CREATE TRIGGER trg_项目_类型校验_upd
BEFORE UPDATE ON 项目
FOR EACH ROW
BEGIN
    IF NEW.类型 NOT IN ('个人', '团体') THEN
        UPDATE `ERROR: 项目类型值无效，合法值为: 个人|团体` SET x = 1;
    END IF;
END//

DELIMITER ;

