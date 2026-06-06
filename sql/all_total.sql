drop table if exists edu_student_profile;
create table edu_student_profile (
  profile_id bigint(20) not null auto_increment comment '档案ID',
  user_id bigint(20) not null comment '用户ID',
  signature varchar(200) default '' comment '个性签名',
  todo_items text comment '待办事项',
  learning_history text comment '学习历史',
  learning_notes text comment '学习笔记',
  favorites text comment '收藏内容',
  wrong_questions text comment '错题内容',
  discussions text comment '讨论内容',
  create_by varchar(64) default '' comment '创建者',
  create_time datetime comment '创建时间',
  update_by varchar(64) default '' comment '更新者',
  update_time datetime comment '更新时间',
  remark varchar(500) default null comment '备注',
  primary key (profile_id),
  unique key uk_edu_student_profile_user_id (user_id)
) engine=innodb auto_increment=1 comment = '学生档案表';
-- 学号与班级示例数据
-- 学号规则：YYYY + 学院2位 + 专业2位 + 班级2位 + 班内序号2位
-- 示例：202501010101
-- 2025 = 2025级
-- 01 = 计算机学院
-- 01 = 软件工程专业
-- 01 = 1班
-- 01 = 班内第1名学生
--
-- 学院编码建议：
-- 01 计算机学院
-- 02 经济管理学院
-- 03 外国语学院
--
-- 专业编码建议：
-- 计算机学院：01 软件工程，02 数据科学与大数据技术
-- 经济管理学院：01 工商管理，02 会计学
-- 外国语学院：01 英语，02 商务英语

-- 1. 教学组织部门树：学院 -> 专业 -> 班级
insert into sys_dept values (120, 100, '0,100', '教学组织', 6, '教务处', '15800000120', 'academic@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);

insert into sys_dept values (121, 120, '0,100,120', '计算机学院', 1, '陈院长', '15800000121', 'cs@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (122, 121, '0,100,120,121', '软件工程', 1, '李主任', '15800000122', 'se@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (123, 122, '0,100,120,121,122', '软件工程1班', 1, '王老师', '15800000123', 'se1@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (124, 122, '0,100,120,121,122', '软件工程2班', 2, '赵老师', '15800000124', 'se2@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (125, 121, '0,100,120,121', '数据科学与大数据技术', 2, '周主任', '15800000125', 'ds@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (126, 125, '0,100,120,121,125', '大数据1班', 1, '吴老师', '15800000126', 'ds1@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (127, 125, '0,100,120,121,125', '大数据2班', 2, '郑老师', '15800000127', 'ds2@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);

insert into sys_dept values (131, 120, '0,100,120', '经济管理学院', 2, '孙院长', '15800000131', 'econ@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (132, 131, '0,100,120,131', '工商管理', 1, '钱主任', '15800000132', 'ba@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (133, 132, '0,100,120,131,132', '工商管理1班', 1, '冯老师', '15800000133', 'ba1@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (134, 132, '0,100,120,131,132', '工商管理2班', 2, '褚老师', '15800000134', 'ba2@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (135, 131, '0,100,120,131', '会计学', 2, '卫主任', '15800000135', 'acc@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (136, 135, '0,100,120,131,135', '会计1班', 1, '蒋老师', '15800000136', 'acc1@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (137, 135, '0,100,120,131,135', '会计2班', 2, '沈老师', '15800000137', 'acc2@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);

insert into sys_dept values (141, 120, '0,100,120', '外国语学院', 3, '韩院长', '15800000141', 'lang@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (142, 141, '0,100,120,141', '英语', 1, '杨主任', '15800000142', 'english@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (143, 142, '0,100,120,141,142', '英语1班', 1, '朱老师', '15800000143', 'english1@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (144, 142, '0,100,120,141,142', '英语2班', 2, '秦老师', '15800000144', 'english2@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (145, 141, '0,100,120,141', '商务英语', 2, '尤主任', '15800000145', 'be@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (146, 145, '0,100,120,141,145', '商务英语1班', 1, '许老师', '15800000146', 'be1@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values (147, 145, '0,100,120,141,145', '商务英语2班', 2, '何老师', '15800000147', 'be2@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);

-- 2. 每个班级补充 3 名学生，默认密码均为 admin123（BCrypt）
-- 软件工程1班
insert into sys_user (user_id, dept_id, user_name, nick_name, student_no, email, phonenumber, sex, avatar, password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, update_by, update_time, remark)
select 2001, 123, 'stu202501010101', '林知夏', '202501010101', '202501010101@school.edu.cn', '13900001001', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '计算机学院-软件工程1班-1号'
where not exists (select 1 from sys_user where user_id = 2001);
insert into sys_user select 2002, 123, 'stu202501010102', '顾言', '202501010102', '202501010102@school.edu.cn', '13900001002', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '计算机学院-软件工程1班-2号' from dual where not exists (select 1 from sys_user where user_id = 2002);
insert into sys_user select 2003, 123, 'stu202501010103', '沈星河', '202501010103', '202501010103@school.edu.cn', '13900001003', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '计算机学院-软件工程1班-3号' from dual where not exists (select 1 from sys_user where user_id = 2003);

-- 软件工程2班
insert into sys_user select 2004, 124, 'stu202501010201', '陆一鸣', '202501010201', '202501010201@school.edu.cn', '13900001004', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '计算机学院-软件工程2班-1号' from dual where not exists (select 1 from sys_user where user_id = 2004);
insert into sys_user select 2005, 124, 'stu202501010202', '夏安', '202501010202', '202501010202@school.edu.cn', '13900001005', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '计算机学院-软件工程2班-2号' from dual where not exists (select 1 from sys_user where user_id = 2005);
insert into sys_user select 2006, 124, 'stu202501010203', '周沐晨', '202501010203', '202501010203@school.edu.cn', '13900001006', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '计算机学院-软件工程2班-3号' from dual where not exists (select 1 from sys_user where user_id = 2006);

-- 大数据1班
insert into sys_user select 2007, 126, 'stu202501020101', '许嘉禾', '202501020101', '202501020101@school.edu.cn', '13900001007', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '计算机学院-大数据1班-1号' from dual where not exists (select 1 from sys_user where user_id = 2007);
insert into sys_user select 2008, 126, 'stu202501020102', '陈予安', '202501020102', '202501020102@school.edu.cn', '13900001008', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '计算机学院-大数据1班-2号' from dual where not exists (select 1 from sys_user where user_id = 2008);
insert into sys_user select 2009, 126, 'stu202501020103', '唐以宁', '202501020103', '202501020103@school.edu.cn', '13900001009', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '计算机学院-大数据1班-3号' from dual where not exists (select 1 from sys_user where user_id = 2009);

-- 大数据2班
insert into sys_user select 2010, 127, 'stu202501020201', '谢景行', '202501020201', '202501020201@school.edu.cn', '13900001010', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '计算机学院-大数据2班-1号' from dual where not exists (select 1 from sys_user where user_id = 2010);
insert into sys_user select 2011, 127, 'stu202501020202', '宋清妍', '202501020202', '202501020202@school.edu.cn', '13900001011', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '计算机学院-大数据2班-2号' from dual where not exists (select 1 from sys_user where user_id = 2011);
insert into sys_user select 2012, 127, 'stu202501020203', '郑书白', '202501020203', '202501020203@school.edu.cn', '13900001012', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '计算机学院-大数据2班-3号' from dual where not exists (select 1 from sys_user where user_id = 2012);

-- 工商管理1班
insert into sys_user select 2013, 133, 'stu202502010101', '梁雨桐', '202502010101', '202502010101@school.edu.cn', '13900001013', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '经济管理学院-工商管理1班-1号' from dual where not exists (select 1 from sys_user where user_id = 2013);
insert into sys_user select 2014, 133, 'stu202502010102', '马知远', '202502010102', '202502010102@school.edu.cn', '13900001014', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '经济管理学院-工商管理1班-2号' from dual where not exists (select 1 from sys_user where user_id = 2014);
insert into sys_user select 2015, 133, 'stu202502010103', '白若溪', '202502010103', '202502010103@school.edu.cn', '13900001015', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '经济管理学院-工商管理1班-3号' from dual where not exists (select 1 from sys_user where user_id = 2015);

-- 工商管理2班
insert into sys_user select 2016, 134, 'stu202502010201', '孔知微', '202502010201', '202502010201@school.edu.cn', '13900001016', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '经济管理学院-工商管理2班-1号' from dual where not exists (select 1 from sys_user where user_id = 2016);
insert into sys_user select 2017, 134, 'stu202502010202', '苏屿', '202502010202', '202502010202@school.edu.cn', '13900001017', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '经济管理学院-工商管理2班-2号' from dual where not exists (select 1 from sys_user where user_id = 2017);
insert into sys_user select 2018, 134, 'stu202502010203', '顾南乔', '202502010203', '202502010203@school.edu.cn', '13900001018', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '经济管理学院-工商管理2班-3号' from dual where not exists (select 1 from sys_user where user_id = 2018);

-- 会计1班
insert into sys_user select 2019, 136, 'stu202502020101', '韩溪', '202502020101', '202502020101@school.edu.cn', '13900001019', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '经济管理学院-会计1班-1号' from dual where not exists (select 1 from sys_user where user_id = 2019);
insert into sys_user select 2020, 136, 'stu202502020102', '程亦可', '202502020102', '202502020102@school.edu.cn', '13900001020', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '经济管理学院-会计1班-2号' from dual where not exists (select 1 from sys_user where user_id = 2020);
insert into sys_user select 2021, 136, 'stu202502020103', '许言希', '202502020103', '202502020103@school.edu.cn', '13900001021', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '经济管理学院-会计1班-3号' from dual where not exists (select 1 from sys_user where user_id = 2021);

-- 会计2班
insert into sys_user select 2022, 137, 'stu202502020201', '乔青岚', '202502020201', '202502020201@school.edu.cn', '13900001022', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '经济管理学院-会计2班-1号' from dual where not exists (select 1 from sys_user where user_id = 2022);
insert into sys_user select 2023, 137, 'stu202502020202', '杜景宁', '202502020202', '202502020202@school.edu.cn', '13900001023', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '经济管理学院-会计2班-2号' from dual where not exists (select 1 from sys_user where user_id = 2023);
insert into sys_user select 2024, 137, 'stu202502020203', '林晚意', '202502020203', '202502020203@school.edu.cn', '13900001024', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '经济管理学院-会计2班-3号' from dual where not exists (select 1 from sys_user where user_id = 2024);

-- 英语1班
insert into sys_user select 2025, 143, 'stu202503010101', '温书宁', '202503010101', '202503010101@school.edu.cn', '13900001025', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '外国语学院-英语1班-1号' from dual where not exists (select 1 from sys_user where user_id = 2025);
insert into sys_user select 2026, 143, 'stu202503010102', '叶瑾', '202503010102', '202503010102@school.edu.cn', '13900001026', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '外国语学院-英语1班-2号' from dual where not exists (select 1 from sys_user where user_id = 2026);
insert into sys_user select 2027, 143, 'stu202503010103', '顾听澜', '202503010103', '202503010103@school.edu.cn', '13900001027', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '外国语学院-英语1班-3号' from dual where not exists (select 1 from sys_user where user_id = 2027);

-- 英语2班
insert into sys_user select 2028, 144, 'stu202503010201', '沈嘉宁', '202503010201', '202503010201@school.edu.cn', '13900001028', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '外国语学院-英语2班-1号' from dual where not exists (select 1 from sys_user where user_id = 2028);
insert into sys_user select 2029, 144, 'stu202503010202', '贺明修', '202503010202', '202503010202@school.edu.cn', '13900001029', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '外国语学院-英语2班-2号' from dual where not exists (select 1 from sys_user where user_id = 2029);
insert into sys_user select 2030, 144, 'stu202503010203', '陶安可', '202503010203', '202503010203@school.edu.cn', '13900001030', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '外国语学院-英语2班-3号' from dual where not exists (select 1 from sys_user where user_id = 2030);

-- 商务英语1班
insert into sys_user select 2031, 146, 'stu202503020101', '姜映雪', '202503020101', '202503020101@school.edu.cn', '13900001031', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '外国语学院-商务英语1班-1号' from dual where not exists (select 1 from sys_user where user_id = 2031);
insert into sys_user select 2032, 146, 'stu202503020102', '周若安', '202503020102', '202503020102@school.edu.cn', '13900001032', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '外国语学院-商务英语1班-2号' from dual where not exists (select 1 from sys_user where user_id = 2032);
insert into sys_user select 2033, 146, 'stu202503020103', '陆清歌', '202503020103', '202503020103@school.edu.cn', '13900001033', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '外国语学院-商务英语1班-3号' from dual where not exists (select 1 from sys_user where user_id = 2033);

-- 商务英语2班
insert into sys_user select 2034, 147, 'stu202503020201', '季星晚', '202503020201', '202503020201@school.edu.cn', '13900001034', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '外国语学院-商务英语2班-1号' from dual where not exists (select 1 from sys_user where user_id = 2034);
insert into sys_user select 2035, 147, 'stu202503020202', '何清越', '202503020202', '202503020202@school.edu.cn', '13900001035', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '外国语学院-商务英语2班-2号' from dual where not exists (select 1 from sys_user where user_id = 2035);
insert into sys_user select 2036, 147, 'stu202503020203', '顾昭宁', '202503020203', '202503020203@school.edu.cn', '13900001036', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '外国语学院-商务英语2班-3号' from dual where not exists (select 1 from sys_user where user_id = 2036);

-- 3. 学生角色
insert into sys_user_role (user_id, role_id)
select u.user_id, 4
from sys_user u
where u.user_id between 2001 and 2036
  and not exists (
    select 1 from sys_user_role ur where ur.user_id = u.user_id and ur.role_id = 4
  );

-- 4. 学生档案
insert into edu_student_profile (user_id, signature, todo_items, learning_history, learning_notes, favorites, wrong_questions, discussions, create_by, create_time, remark)
select u.user_id,
       concat('你好，我是 ', u.nick_name),
       concat('完成 ', d.dept_name, ' 本周学习任务'),
       concat('已加入 ', d.dept_name, ' 的课程学习'),
       '课堂笔记与复习提纲',
       '专业导论、通识课程、在线精品课程',
       '待整理错题集',
       '已参与班级学习讨论',
       'admin',
       sysdate(),
       concat(d.dept_name, ' 学生初始化档案')
from sys_user u
left join sys_dept d on u.dept_id = d.dept_id
where u.user_id between 2001 and 2036
  and not exists (
    select 1 from edu_student_profile p where p.user_id = u.user_id
  );
-- 学院/专业初始化脚本
-- 用途：
-- 1. 确保存在“教学组织”根节点
-- 2. 清空“教学组织”下现有学院/专业
-- 3. 按当前院系结构重建学院 -> 专业两级树
--
-- 说明：
-- 1. 注册页会直接读取本树的前两级数据作为“学院/专业”选项
-- 2. 本脚本会删除“教学组织”下的现有子节点，请在执行前确认不再需要旧示例数据

-- 0. 确保存在“教学组织”根节点（挂在若依科技/100 下）
insert into sys_dept (
  dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email,
  status, del_flag, create_by, create_time, update_by, update_time
)
values (
  120, 100, '0,100', '教学组织', 6, '教务处', '15800000120', 'academic@school.edu.cn',
  '0', '0', 'admin', sysdate(), '', null
)
on duplicate key update
  parent_id = values(parent_id),
  ancestors = values(ancestors),
  dept_name = values(dept_name),
  order_num = values(order_num),
  leader = values(leader),
  phone = values(phone),
  email = values(email),
  status = values(status),
  del_flag = values(del_flag),
  update_by = 'admin',
  update_time = sysdate();

-- 1. 清空“教学组织”下已有学院/专业
delete from sys_dept where find_in_set('120', ancestors);

-- 2. 重建学院节点
insert into sys_dept values
(121, 120, '0,100,120', '金融与经贸学院', 1, '金融与经贸学院', '15800000121', 'academy121@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(122, 120, '0,100,120', '财税学院', 2, '财税学院', '15800000122', 'academy122@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(123, 120, '0,100,120', '工商管理学院', 3, '工商管理学院', '15800000123', 'academy123@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(124, 120, '0,100,120', '会计学院', 4, '会计学院', '15800000124', 'academy124@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(125, 120, '0,100,120', '信息与人工智能学院', 5, '信息与人工智能学院', '15800000125', 'academy125@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(126, 120, '0,100,120', '法律与社会工作学院', 6, '法律与社会工作学院', '15800000126', 'academy126@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(127, 120, '0,100,120', '文化传播与设计学院', 7, '文化传播与设计学院', '15800000127', 'academy127@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(128, 120, '0,100,120', '外国语学院', 8, '外国语学院', '15800000128', 'academy128@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);

-- 3. 重建专业节点
insert into sys_dept values
(129, 121, '0,100,120,121', '金融学', 1, '金融学', '15800000129', 'major129@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(130, 121, '0,100,120,121', '经济学', 2, '经济学', '15800000130', 'major130@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(131, 121, '0,100,120,121', '国际经济与贸易', 3, '国际经济与贸易', '15800000131', 'major131@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(132, 121, '0,100,120,121', '跨境电子商务', 4, '跨境电子商务', '15800000132', 'major132@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(133, 121, '0,100,120,121', '保险学', 5, '保险学', '15800000133', 'major133@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),

(134, 122, '0,100,120,122', '财政学', 1, '财政学', '15800000134', 'major134@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(135, 122, '0,100,120,122', '税收学', 2, '税收学', '15800000135', 'major135@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(136, 122, '0,100,120,122', '劳动与社会保障', 3, '劳动与社会保障', '15800000136', 'major136@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),

(137, 123, '0,100,120,123', '工商管理', 1, '工商管理', '15800000137', 'major137@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(138, 123, '0,100,120,123', '市场营销', 2, '市场营销', '15800000138', 'major138@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(139, 123, '0,100,120,123', '工程管理', 3, '工程管理', '15800000139', 'major139@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(140, 123, '0,100,120,123', '人力资源管理', 4, '人力资源管理', '15800000140', 'major140@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(141, 123, '0,100,120,123', '物流管理', 5, '物流管理', '15800000141', 'major141@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),

(142, 124, '0,100,120,124', '会计学', 1, '会计学', '15800000142', 'major142@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(143, 124, '0,100,120,124', '财务管理', 2, '财务管理', '15800000143', 'major143@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(144, 124, '0,100,120,124', '审计学', 3, '审计学', '15800000144', 'major144@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(145, 124, '0,100,120,124', '资产评估', 4, '资产评估', '15800000145', 'major145@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),

(146, 125, '0,100,120,125', '信息管理与信息系统', 1, '信息管理与信息系统', '15800000146', 'major146@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(147, 125, '0,100,120,125', '计算机科学与技术', 2, '计算机科学与技术', '15800000147', 'major147@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(148, 125, '0,100,120,125', '电子商务', 3, '电子商务', '15800000148', 'major148@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(149, 125, '0,100,120,125', '应用统计学', 4, '应用统计学', '15800000149', 'major149@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(150, 125, '0,100,120,125', '人工智能', 5, '人工智能', '15800000150', 'major150@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(151, 125, '0,100,120,125', '数据科学与大数据技术', 6, '数据科学与大数据技术', '15800000151', 'major151@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),

(152, 126, '0,100,120,126', '法学', 1, '法学', '15800000152', 'major152@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(153, 126, '0,100,120,126', '社会工作', 2, '社会工作', '15800000153', 'major153@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),

(154, 127, '0,100,120,127', '汉语言文学', 1, '汉语言文学', '15800000154', 'major154@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(155, 127, '0,100,120,127', '广告学', 2, '广告学', '15800000155', 'major155@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(156, 127, '0,100,120,127', '视觉传达设计', 3, '视觉传达设计', '15800000156', 'major156@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(157, 127, '0,100,120,127', '环境设计', 4, '环境设计', '15800000157', 'major157@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(158, 127, '0,100,120,127', '工业设计', 5, '工业设计', '15800000158', 'major158@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(159, 127, '0,100,120,127', '服装与服饰设计', 6, '服装与服饰设计', '15800000159', 'major159@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),

(160, 128, '0,100,120,128', '英语', 1, '英语', '15800000160', 'major160@school.edu.cn', '0', '0', 'admin', sysdate(), '', null),
(161, 128, '0,100,120,128', '日语', 2, '日语', '15800000161', 'major161@school.edu.cn', '0', '0', 'admin', sysdate(), '', null);

-- 4. 可选检查
select dept_id, parent_id, dept_name, order_num
from sys_dept
where dept_id = 120 or find_in_set('120', ancestors)
order by ancestors, order_num, dept_id;
-- 首页模块测试数据
-- 说明：
-- 1. 请先执行首页模块对应的建表脚本，确保以下表已存在：
--    edu_course_category / edu_course / edu_course_content / edu_course_enroll / edu_course_banner / edu_course_like
-- 2. 本脚本默认系统中已存在基础账号：
--    教师：user_id = 3（teacher）
--    学生：user_id = 4（student01）
--    以上账号来自 ry_20260417.sql
-- 3. 本脚本只清理本次演示数据使用的固定 ID，不影响你已有的其它数据

-- ----------------------------
-- 0. 清理旧演示数据
-- ----------------------------
delete from edu_course_like where like_id between 11001 and 11008;
delete from edu_course_enroll where enroll_id between 10001 and 10006;
delete from edu_course_banner where banner_id between 9001 and 9003;
delete from edu_course_content where content_id between 7001 and 7016;
delete from edu_course where course_id between 5001 and 5006;
delete from edu_course_category where category_id between 3001 and 3703;

-- ----------------------------
-- 1. 课程分类
-- ----------------------------
insert into edu_course_category
(category_id, parent_id, ancestors, category_name, order_num, icon, status, del_flag, create_by, create_time, update_by, update_time, remark)
values
(3001, 0, '0', '编程开发', 1, 'monitor', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3002, 0, '0', '数据与分析', 2, 'chart', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3003, 0, '0', '设计创作', 3, 'edit', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3004, 0, '0', '人工智能', 4, 'skill', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3005, 0, '0', '云计算与运维', 5, 'server', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3006, 0, '0', '产品与运营', 6, 'guide', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3007, 0, '0', '学科基础', 7, 'education', '0', '0', 'admin', '2026-05-20 09:00:00', 'admin', '2026-05-20 09:00:00', '首页演示一级分类'),
(3101, 3001, '0,3001', 'Java 开发', 1, 'tree', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3102, 3001, '0,3001', '前端开发', 2, 'build', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3103, 3001, '0,3001', 'Python 开发', 3, 'code', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3104, 3001, '0,3001', '移动开发', 4, 'phone', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3105, 3001, '0,3001', '后端架构', 5, 'nested', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3201, 3002, '0,3002', '数据分析', 1, 'money', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3202, 3002, '0,3002', '数据库技术', 2, 'table', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3203, 3002, '0,3002', '大数据开发', 3, 'redis', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3204, 3002, '0,3002', '商业智能', 4, 'excel', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3301, 3003, '0,3003', '视觉设计', 1, 'peoples', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3302, 3003, '0,3003', 'UI/UX 设计', 2, 'component', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3303, 3003, '0,3003', '数字媒体', 3, 'color', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3401, 3004, '0,3004', '机器学习', 1, 'skill', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3402, 3004, '0,3004', '深度学习', 2, 'rate', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3403, 3004, '0,3004', 'AIGC 应用', 3, 'international', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3501, 3005, '0,3005', 'Linux 运维', 1, 'server', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3502, 3005, '0,3005', '云原生与容器', 2, 'redis-list', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3503, 3005, '0,3005', '网络安全', 3, 'lock', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3601, 3006, '0,3006', '产品经理', 1, 'guide', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3602, 3006, '0,3006', '新媒体运营', 2, 'message', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3603, 3006, '0,3006', '项目管理', 3, 'documentation', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3701, 3007, '0,3007', '高等数学', 1, 'number', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3702, 3007, '0,3007', '计算机基础', 2, 'education', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类'),
(3703, 3007, '0,3007', '英语通识', 3, 'language', '0', '0', 'admin', '2026-05-20 09:10:00', 'admin', '2026-05-20 09:10:00', '首页演示二级分类');

-- ----------------------------
-- 2. 课程主数据
-- ----------------------------
insert into edu_course
(course_id, category_id, teacher_id, course_name, course_subtitle, cover_image, intro, detail_html, tags,
 difficulty_level, publish_status, recommend_flag, hot_flag, banner_flag, allow_register, sort_order,
 view_count, like_count, enroll_count, content_count, exam_count, last_content_time, publish_time,
 status, del_flag, create_by, create_time, update_by, update_time, remark)
values
(5001, 3101, 3, 'Java Web 企业开发实战', '从 Servlet 到课程平台实战开发', 'https://dummyimage.com/720x420/2563eb/ffffff&text=Java+Web',
 '面向在线教育平台的 Java Web 实战课程，覆盖接口设计、权限控制、分页查询与前后端联调。',
 '<p>课程围绕在线教育平台常见业务展开，适合完成首页、课程与考试模块实训。</p>',
 'Java,SpringBoot,MySQL,若依', '2', '1', '1', '1', '1', '1', 90,
 286, 3, 18, 3, 1, '2026-05-25 18:20:00', '2026-05-18 09:00:00',
 '0', '0', 'admin', '2026-05-18 09:00:00', 'admin', '2026-05-25 18:20:00', '推荐热门课程'),

(5002, 3102, 3, 'Vue2 教育平台前端实战', '聚焦课程门户首页、课程广场与详情页实现', 'https://dummyimage.com/720x420/0ea5e9/ffffff&text=Vue2+Portal',
 '以 Vue2 + Element UI 为基础，完成在线课程平台的首页、搜索、课程卡片与详情页展示。',
 '<p>课程强调组件复用、页面层级设计和课程门户风格构建。</p>',
 'Vue2,ElementUI,课程门户,前端', '1', '1', '1', '0', '1', '1', 88,
 198, 2, 14, 3, 0, '2026-05-24 21:00:00', '2026-05-19 10:00:00',
 '0', '0', 'admin', '2026-05-19 10:00:00', 'admin', '2026-05-24 21:00:00', '推荐课程'),

(5003, 3101, 3, 'Spring Boot 课程管理项目实训', '课程管理、章节发布与内容统计一体化实践', 'https://dummyimage.com/720x420/1d4ed8/ffffff&text=Spring+Boot',
 '通过课程管理、内容管理和统计字段回写，掌握在线课程平台的后端业务落地方式。',
 '<p>课程适合与首页模块、考试模块联动开发。</p>',
 'SpringBoot,课程管理,MyBatis', '2', '1', '0', '1', '0', '1', 82,
 164, 2, 12, 3, 1, '2026-05-26 09:30:00', '2026-05-21 08:30:00',
 '0', '0', 'admin', '2026-05-21 08:30:00', 'admin', '2026-05-26 09:30:00', '最新课程'),

(5004, 3201, 3, 'Python 数据分析入门', '从数据清洗到可视化的基础训练', 'https://dummyimage.com/720x420/14b8a6/ffffff&text=Python+Data',
 '适合初学者快速掌握数据处理、图表分析和结果汇报等基础能力。',
 '<p>课程内容覆盖数据读取、清洗、分析与图表呈现。</p>',
 'Python,数据分析,可视化', '1', '1', '0', '0', '0', '1', 78,
 123, 1, 9, 2, 0, '2026-05-25 15:40:00', '2026-05-20 14:00:00',
 '0', '0', 'admin', '2026-05-20 14:00:00', 'admin', '2026-05-25 15:40:00', '数据分析课程'),

(5005, 3201, 3, 'SQL 数据库建模与优化', '面向业务系统的数据设计与性能优化', 'https://dummyimage.com/720x420/f59e0b/ffffff&text=SQL+Modeling',
 '围绕课程平台中的用户、课程、考试等业务，学习数据库建模、索引设计与查询优化。',
 '<p>课程强调建模规范、统计字段设计和导入测试数据实践。</p>',
 'MySQL,SQL,建模,优化', '2', '1', '0', '0', '0', '1', 70,
 108, 1, 7, 2, 0, '2026-05-23 16:00:00', '2026-05-17 11:20:00',
 '0', '0', 'admin', '2026-05-17 11:20:00', 'admin', '2026-05-23 16:00:00', '数据库课程'),

(5006, 3301, 3, 'UI 界面设计与交互基础', '教育平台页面视觉层级与组件规范', 'https://dummyimage.com/720x420/a855f7/ffffff&text=UI+Design',
 '围绕在线教育平台首页、课程卡片与信息层级设计，训练基础视觉与交互表达。',
 '<p>课程适合首页优化、卡片风格统一和移动端适配练习。</p>',
 'UI,交互设计,教育平台', '1', '1', '1', '0', '0', '1', 76,
 96, 1, 6, 3, 0, '2026-05-22 19:30:00', '2026-05-16 13:30:00',
 '0', '0', 'admin', '2026-05-16 13:30:00', 'admin', '2026-05-22 19:30:00', '设计课程');

-- ----------------------------
-- 3. 课程内容
-- ----------------------------
insert into edu_course_content
(content_id, course_id, parent_id, content_title, content_type, source_type, file_name, file_url, cover_image,
 link_url, summary, content_body, duration_seconds, exam_id, is_preview, sort_order, publish_status,
 view_count, create_by, create_time, update_by, update_time, remark)
values
(7001, 5001, 0, '第1讲：课程平台整体架构', '1', '1', '架构说明.pdf', 'https://example.com/files/java-web-01.pdf', '', '',
 '理解课程平台从首页到课程详情页的整体数据流。', '介绍课程平台基础架构、模块关系与开发顺序。', 0, null, '1', 1, '1',
 28, 'teacher', '2026-05-18 09:20:00', 'teacher', '2026-05-18 09:20:00', 'Java Web 文档课件'),
(7002, 5001, 0, '第2讲：登录与课程接口联调', '2', '2', '', '', '',
 'https://example.com/video/java-web-02', '完成登录态下课程查询与注册流程联调。', '通过视频演示课程查询、点赞与注册的完整交互。', 1860, null, '0', 2, '1',
 35, 'teacher', '2026-05-25 18:20:00', 'teacher', '2026-05-25 18:20:00', 'Java Web 视频课件'),

(7003, 5002, 0, '第1讲：课程门户首页布局', '1', '1', 'portal-home.pdf', 'https://example.com/files/vue-portal-01.pdf', '', '',
 '搭建课程首页的 Hero、搜索区和课程分区。', '完成在线教育首页的布局设计和组件拆分。', 0, null, '1', 1, '1',
 31, 'teacher', '2026-05-19 10:30:00', 'teacher', '2026-05-19 10:30:00', '前端首页文档'),
(7004, 5002, 0, '第2讲：课程卡片与详情页', '2', '2', '', '', '',
 'https://example.com/video/vue-portal-02', '统一课程卡片风格并实现详情页交互。', '演示课程详情页、点赞注册和信息卡片呈现。', 1540, null, '0', 2, '1',
 24, 'teacher', '2026-05-24 21:00:00', 'teacher', '2026-05-24 21:00:00', '前端详情视频'),

(7005, 5003, 0, '第1讲：课程后台管理设计', '1', '1', 'course-manage.pdf', 'https://example.com/files/spring-course-01.pdf', '', '',
 '掌握课程分类、课程、内容三张主表的关系。', '介绍课程后台的菜单设计、接口分层和 Mapper 编写。', 0, null, '1', 1, '1',
 20, 'teacher', '2026-05-21 08:50:00', 'teacher', '2026-05-21 08:50:00', '后台管理文档'),
(7006, 5003, 0, '第2讲：统计字段刷新策略', '1', '1', 'course-stat.pdf', 'https://example.com/files/spring-course-02.pdf', '', '',
 '理解 enroll_count、like_count、content_count 的维护方式。', '讲解课程热度、最新课程与课程统计字段的刷新逻辑。', 0, null, '0', 2, '1',
 18, 'teacher', '2026-05-26 09:30:00', 'teacher', '2026-05-26 09:30:00', '统计字段文档'),

(7007, 5004, 0, '第1讲：数据清洗基础', '1', '1', 'python-data-01.pdf', 'https://example.com/files/python-data-01.pdf', '', '',
 '掌握常见数据清洗步骤和分析准备工作。', '从原始数据导入、字段清洗到结果检查。', 0, null, '1', 1, '1',
 16, 'teacher', '2026-05-20 14:20:00', 'teacher', '2026-05-20 14:20:00', '数据分析文档'),
(7008, 5004, 0, '第2讲：图表可视化实践', '2', '2', '', '', '',
 'https://example.com/video/python-data-02', '用图表展示分析结果，适合课程总结演示。', '演示常见图表与分析报告页面设计。', 1320, null, '0', 2, '1',
 22, 'teacher', '2026-05-25 15:40:00', 'teacher', '2026-05-25 15:40:00', '数据分析视频'),

(7009, 5005, 0, '第1讲：用户与课程关系建模', '1', '1', 'sql-model-01.pdf', 'https://example.com/files/sql-model-01.pdf', '', '',
 '围绕用户、课程和考试的关系设计数据库结构。', '分析课程平台注册、点赞、考试等场景的数据建模。', 0, null, '1', 1, '1',
 12, 'teacher', '2026-05-17 11:40:00', 'teacher', '2026-05-17 11:40:00', 'SQL 建模文档'),
(7010, 5005, 0, '第2讲：索引与排序优化', '1', '1', 'sql-model-02.pdf', 'https://example.com/files/sql-model-02.pdf', '', '',
 '优化课程列表查询和首页排序效率。', '讲解课程名称搜索、分类过滤与排序字段索引设计。', 0, null, '0', 2, '1',
 10, 'teacher', '2026-05-23 16:00:00', 'teacher', '2026-05-23 16:00:00', 'SQL 优化文档'),

(7011, 5006, 0, '第1讲：教育平台信息层级', '1', '1', 'ui-design-01.pdf', 'https://example.com/files/ui-design-01.pdf', '', '',
 '建立首页、课程广场和详情页的一致视觉层级。', '讲解教育类页面的标题、摘要、按钮和卡片布局。', 0, null, '1', 1, '1',
 14, 'teacher', '2026-05-16 13:50:00', 'teacher', '2026-05-16 13:50:00', 'UI 设计文档'),
(7012, 5006, 0, '第2讲：卡片交互与移动端适配', '2', '2', '', '', '',
 'https://example.com/video/ui-design-02', '通过 hover、阴影和间距统一提升页面体验。', '演示卡片上浮、按钮交互和小屏适配技巧。', 1240, null, '0', 2, '1',
 17, 'teacher', '2026-05-22 19:30:00', 'teacher', '2026-05-22 19:30:00', 'UI 视频课程');

-- ----------------------------
-- 4. 学生注册课程
-- 说明：保证 student01 登录后“我的课程”有内容可看
-- ----------------------------
insert into edu_course_enroll
(enroll_id, course_id, student_id, enroll_source, enroll_status, progress_percent, last_study_time, finish_time,
 create_by, create_time, update_by, update_time, remark)
values
(10001, 5001, 4, '1', '1', 68.50, '2026-05-25 20:10:00', null, 'student01', '2026-05-19 20:00:00', 'student01', '2026-05-25 20:10:00', '首页演示：已注册课程'),
(10002, 5002, 4, '1', '1', 42.00, '2026-05-24 22:15:00', null, 'student01', '2026-05-20 18:30:00', 'student01', '2026-05-24 22:15:00', '首页演示：已注册课程'),
(10003, 5004, 4, '1', '1', 15.00, '2026-05-25 15:50:00', null, 'student01', '2026-05-23 16:40:00', 'student01', '2026-05-25 15:50:00', '首页演示：已注册课程');

-- ----------------------------
-- 5. 点赞数据
-- 说明：这里使用已有用户进行点赞，便于演示课程热度
-- ----------------------------
insert into edu_course_like
(like_id, course_id, user_id, create_time)
values
(11001, 5001, 1, '2026-05-24 09:00:00'),
(11002, 5001, 2, '2026-05-24 09:10:00'),
(11003, 5001, 4, '2026-05-24 09:20:00'),
(11004, 5002, 1, '2026-05-24 10:00:00'),
(11005, 5002, 4, '2026-05-24 10:20:00'),
(11006, 5003, 2, '2026-05-25 08:00:00'),
(11007, 5004, 4, '2026-05-25 08:20:00'),
(11008, 5006, 1, '2026-05-25 08:40:00');

-- ----------------------------
-- 6. 首页轮播图
-- ----------------------------
insert into edu_course_banner
(banner_id, banner_title, banner_image, course_id, jump_url, sort_order, status, start_time, end_time,
 create_by, create_time, update_by, update_time, remark)
values
(9001, '首页推荐：Java Web 企业开发实战', 'https://dummyimage.com/1440x420/2563eb/ffffff&text=Java+Web+Course', 5001, '', 1, '0',
 '2026-05-01 00:00:00', '2026-12-31 23:59:59', 'admin', '2026-05-20 10:00:00', 'admin', '2026-05-20 10:00:00', '首页主轮播'),
(9002, '前端专题：Vue2 教育平台前端实战', 'https://dummyimage.com/1440x420/0ea5e9/ffffff&text=Vue2+Portal+Course', 5002, '', 2, '0',
 '2026-05-01 00:00:00', '2026-12-31 23:59:59', 'admin', '2026-05-20 10:10:00', 'admin', '2026-05-20 10:10:00', '首页主轮播'),
(9003, '项目实训：Spring Boot 课程管理项目实训', 'https://dummyimage.com/1440x420/1d4ed8/ffffff&text=Spring+Boot+Training', 5003, '', 3, '0',
 '2026-05-01 00:00:00', '2026-12-31 23:59:59', 'admin', '2026-05-20 10:20:00', 'admin', '2026-05-20 10:20:00', '首页主轮播');

-- ----------------------------
-- 7. 导入后快速检查
-- ----------------------------
select category_id, category_name, parent_id, order_num
from edu_course_category
where category_id between 3001 and 3703
order by parent_id, order_num, category_id;

select course_id, course_name, teacher_id, category_id, recommend_flag, hot_flag, enroll_count, like_count, content_count
from edu_course
where course_id between 5001 and 5006
order by sort_order desc, course_id asc;

select enroll_id, course_id, student_id, progress_percent
from edu_course_enroll
where enroll_id between 10001 and 10003
order by enroll_id asc;

select banner_id, banner_title, course_id, sort_order, status
from edu_course_banner
where banner_id between 9001 and 9003
order by sort_order asc;
-- 教师课程管理菜单与权限修复脚本
-- 作用：
-- 1. 补齐“教学管理 -> 课程管理”菜单
-- 2. 补齐课程与课程内容接口对应的功能权限
-- 3. 绑定教师角色（role_id = 3）
--
-- 使用说明：
-- 1. 在 ruoyi 数据库执行本脚本
-- 2. 执行后退出并重新登录教师账号
-- 3. 左侧应出现“教学管理 -> 课程管理”

-- 0. 修正已有菜单的路由属性
update sys_menu
set is_frame = '1'
where menu_id in (2100, 2101)
  and is_frame <> '1';

-- 1. 教学管理目录
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2100, '教学管理', 0, 5, 'teaching', '', '', '', 1, 0, 'M', '0', '0', '', 'education', 'admin', sysdate(), '', null, '教师教学管理目录'
where not exists (select 1 from sys_menu where menu_id = 2100);

-- 2. 课程管理菜单
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 2101, '课程管理', 2100, 1, 'course', 'teaching/course/index', '', '', 1, 0, 'C', '0', '0', 'edu:course:list', 'form', 'admin', sysdate(), '', null, '教师课程管理菜单'
where not exists (select 1 from sys_menu where menu_id = 2101);

-- 3. 课程管理功能权限
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21011, '课程查询', 2101, 1, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:course:query', '#', 'admin', sysdate(), '', null, '课程查询权限'
where not exists (select 1 from sys_menu where menu_id = 21011);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21012, '课程新增', 2101, 2, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:course:add', '#', 'admin', sysdate(), '', null, '课程新增权限'
where not exists (select 1 from sys_menu where menu_id = 21012);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21013, '课程修改', 2101, 3, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:course:edit', '#', 'admin', sysdate(), '', null, '课程修改权限'
where not exists (select 1 from sys_menu where menu_id = 21013);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21014, '课程删除', 2101, 4, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:course:remove', '#', 'admin', sysdate(), '', null, '课程删除权限'
where not exists (select 1 from sys_menu where menu_id = 21014);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21015, '课程列表', 2101, 5, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:course:list', '#', 'admin', sysdate(), '', null, '课程列表权限'
where not exists (select 1 from sys_menu where menu_id = 21015);

-- 4. 课程内容功能权限
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21021, '内容列表', 2101, 6, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:content:list', '#', 'admin', sysdate(), '', null, '课程内容列表权限'
where not exists (select 1 from sys_menu where menu_id = 21021);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21022, '内容详情', 2101, 7, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:content:query', '#', 'admin', sysdate(), '', null, '课程内容详情权限'
where not exists (select 1 from sys_menu where menu_id = 21022);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21023, '内容新增', 2101, 8, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:content:add', '#', 'admin', sysdate(), '', null, '课程内容新增权限'
where not exists (select 1 from sys_menu where menu_id = 21023);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21024, '内容修改', 2101, 9, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:content:edit', '#', 'admin', sysdate(), '', null, '课程内容修改权限'
where not exists (select 1 from sys_menu where menu_id = 21024);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21025, '内容删除', 2101, 10, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:content:remove', '#', 'admin', sysdate(), '', null, '课程内容删除权限'
where not exists (select 1 from sys_menu where menu_id = 21025);

-- 5. 课程分类下拉权限
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21026, '课程分类列表', 2101, 11, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:category:list', '#', 'admin', sysdate(), '', null, '课程分类下拉查询权限'
where not exists (select 1 from sys_menu where menu_id = 21026);

-- 6. 绑定教师角色菜单与权限
insert into sys_role_menu (role_id, menu_id)
select 3, 2100 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 2100);

insert into sys_role_menu (role_id, menu_id)
select 3, 2101 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 2101);

insert into sys_role_menu (role_id, menu_id)
select 3, 21011 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21011);

insert into sys_role_menu (role_id, menu_id)
select 3, 21012 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21012);

insert into sys_role_menu (role_id, menu_id)
select 3, 21013 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21013);

insert into sys_role_menu (role_id, menu_id)
select 3, 21014 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21014);

insert into sys_role_menu (role_id, menu_id)
select 3, 21015 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21015);

insert into sys_role_menu (role_id, menu_id)
select 3, 21021 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21021);

insert into sys_role_menu (role_id, menu_id)
select 3, 21022 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21022);

insert into sys_role_menu (role_id, menu_id)
select 3, 21023 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21023);

insert into sys_role_menu (role_id, menu_id)
select 3, 21024 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21024);

insert into sys_role_menu (role_id, menu_id)
select 3, 21025 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21025);

insert into sys_role_menu (role_id, menu_id)
select 3, 21026 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21026);

-- 7. 执行后可用下面 SQL 验证
-- select
--   r.role_key,
--   m.menu_id,
--   m.menu_name,
--   m.component,
--   m.perms
-- from sys_role r
-- join sys_role_menu rm on r.role_id = rm.role_id
-- join sys_menu m on rm.menu_id = m.menu_id
-- where r.role_key = 'teacher'
--   and m.menu_id between 2100 and 21026
-- order by m.menu_id;
-- 考试模块菜单与权限修复脚本
-- 作用：
-- 1. 统一试卷管理、成绩统计菜单权限为当前后端使用的 edu:* 权限
-- 2. 补齐题库、试题、试卷、考试、统计接口所需功能权限
-- 3. 绑定教师角色（role_id = 3）
--
-- 使用说明：
-- 1. 在 ruoyi 数据库中执行本脚本
-- 2. 执行后退出并重新登录教师账号
-- 3. 课程管理、题库管理、试卷管理、考试发布、成绩统计接口将按新权限生效

-- 0. 修正已有菜单的路由属性与权限标识
update sys_menu
set menu_name = '题库管理',
    is_frame = '1',
    perms = 'edu:paper:list'
where menu_id = 2103;

update sys_menu
set is_frame = '1',
    perms = 'edu:score:list'
where menu_id = 2104;

-- 1. 题库与试卷接口权限
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21031, '题库试卷查询', 2103, 1, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:paper:query', '#', 'admin', sysdate(), '', null, '题库与试卷查询权限'
where not exists (select 1 from sys_menu where menu_id = 21031);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21032, '题库试卷新增', 2103, 2, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:paper:add', '#', 'admin', sysdate(), '', null, '题库与试卷新增权限'
where not exists (select 1 from sys_menu where menu_id = 21032);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21033, '题库试卷修改', 2103, 3, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:paper:edit', '#', 'admin', sysdate(), '', null, '题库与试卷修改权限'
where not exists (select 1 from sys_menu where menu_id = 21033);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21034, '题库试卷删除', 2103, 4, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:paper:remove', '#', 'admin', sysdate(), '', null, '题库与试卷删除权限'
where not exists (select 1 from sys_menu where menu_id = 21034);

-- 2. 试题接口权限
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21035, '试题列表', 2103, 5, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:question:list', '#', 'admin', sysdate(), '', null, '试题列表权限'
where not exists (select 1 from sys_menu where menu_id = 21035);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21036, '试题查询', 2103, 6, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:question:query', '#', 'admin', sysdate(), '', null, '试题查询权限'
where not exists (select 1 from sys_menu where menu_id = 21036);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21037, '试题新增', 2103, 7, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:question:add', '#', 'admin', sysdate(), '', null, '试题新增权限'
where not exists (select 1 from sys_menu where menu_id = 21037);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21038, '试题修改', 2103, 8, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:question:edit', '#', 'admin', sysdate(), '', null, '试题修改权限'
where not exists (select 1 from sys_menu where menu_id = 21038);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21039, '试题删除', 2103, 9, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:question:remove', '#', 'admin', sysdate(), '', null, '试题删除权限'
where not exists (select 1 from sys_menu where menu_id = 21039);

-- 3. 考试发布与统计权限
insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21041, '考试查询', 2104, 1, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:score:query', '#', 'admin', sysdate(), '', null, '考试查询权限'
where not exists (select 1 from sys_menu where menu_id = 21041);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21042, '考试新增', 2104, 2, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:score:add', '#', 'admin', sysdate(), '', null, '考试新增权限'
where not exists (select 1 from sys_menu where menu_id = 21042);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21043, '考试修改', 2104, 3, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:score:edit', '#', 'admin', sysdate(), '', null, '考试修改权限'
where not exists (select 1 from sys_menu where menu_id = 21043);

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21044, '考试删除', 2104, 4, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:score:remove', '#', 'admin', sysdate(), '', null, '考试删除权限'
where not exists (select 1 from sys_menu where menu_id = 21044);

-- 4. 绑定教师角色
insert into sys_role_menu (role_id, menu_id)
select 3, 2103 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 2103);

insert into sys_role_menu (role_id, menu_id)
select 3, 2104 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 2104);

insert into sys_role_menu (role_id, menu_id)
select 3, 21031 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21031);

insert into sys_role_menu (role_id, menu_id)
select 3, 21032 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21032);

insert into sys_role_menu (role_id, menu_id)
select 3, 21033 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21033);

insert into sys_role_menu (role_id, menu_id)
select 3, 21034 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21034);

insert into sys_role_menu (role_id, menu_id)
select 3, 21035 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21035);

insert into sys_role_menu (role_id, menu_id)
select 3, 21036 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21036);

insert into sys_role_menu (role_id, menu_id)
select 3, 21037 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21037);

insert into sys_role_menu (role_id, menu_id)
select 3, 21038 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21038);

insert into sys_role_menu (role_id, menu_id)
select 3, 21039 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21039);

insert into sys_role_menu (role_id, menu_id)
select 3, 21041 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21041);

insert into sys_role_menu (role_id, menu_id)
select 3, 21042 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21042);

insert into sys_role_menu (role_id, menu_id)
select 3, 21043 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21043);

insert into sys_role_menu (role_id, menu_id)
select 3, 21044 where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21044);

-- 5. 执行后可用下列 SQL 自检
-- select m.menu_id, m.menu_name, m.perms
-- from sys_role_menu rm
-- join sys_menu m on rm.menu_id = m.menu_id
-- where rm.role_id = 3
--   and m.menu_id between 2103 and 21044
-- order by m.menu_id;
-- 考试模块建表脚本
-- 说明：
-- 1. 本脚本用于在线课程教学平台的考试模块第一阶段建设。
-- 2. 设计目标：围绕“题库 -> 试题 -> 试卷 -> 考试 -> 学生作答 -> 成绩统计”形成最小闭环。
-- 3. 本脚本与现有课程模块对齐：
--    - 考试通过 edu_exam.course_id 归属于课程
--    - 课程内容表 edu_course_content.exam_id 可直接挂接到 edu_exam.exam_id
-- 4. 本脚本不包含防作弊、AI 判题、监考等增强能力，后续可按需扩展。

-- ----------------------------
-- 1. 题库表
-- ----------------------------
drop table if exists edu_question_bank;
create table edu_question_bank (
  bank_id               bigint(20)      not null auto_increment comment '题库ID',
  bank_name             varchar(120)    not null comment '题库名称',
  creator_id            bigint(20)      not null comment '创建教师ID',
  visibility            char(1)         default '0' comment '可见范围（0私有 1公开）',
  tags                  varchar(500)    default '' comment '题库标签，多个使用逗号分隔',
  question_count        int(11)         default 0 comment '题目数量',
  usage_count           int(11)         default 0 comment '试卷使用次数',
  answer_count          int(11)         default 0 comment '学生答题次数',
  correct_rate          decimal(5,2)    default 0.00 comment '题库平均正确率',
  status                char(1)         default '0' comment '状态（0正常 1停用）',
  del_flag              char(1)         default '0' comment '删除标志（0存在 2删除）',
  create_by             varchar(64)     default '' comment '创建者',
  create_time           datetime        comment '创建时间',
  update_by             varchar(64)     default '' comment '更新者',
  update_time           datetime        comment '更新时间',
  remark                varchar(500)    default null comment '备注',
  primary key (bank_id),
  key idx_bank_creator (creator_id),
  key idx_bank_status (status, del_flag)
) engine=innodb auto_increment=10000 comment='题库表';

-- ----------------------------
-- 2. 题库关联课程表
-- 说明：需求中题库可关联 0~多个课程，因此单独拆关系表
-- ----------------------------
drop table if exists edu_question_bank_course;
create table edu_question_bank_course (
  id                    bigint(20)      not null auto_increment comment '主键ID',
  bank_id               bigint(20)      not null comment '题库ID',
  course_id             bigint(20)      not null comment '课程ID',
  create_time           datetime        comment '创建时间',
  primary key (id),
  unique key uk_bank_course (bank_id, course_id),
  key idx_bank_course_course (course_id)
) engine=innodb auto_increment=10000 comment='题库关联课程表';

-- ----------------------------
-- 3. 试题表
-- 题型：
-- 1 单选题
-- 2 多选题
-- 3 判断题
-- 4 填空题
-- 5 简答题
-- ----------------------------
drop table if exists edu_question;
create table edu_question (
  question_id           bigint(20)      not null auto_increment comment '试题ID',
  bank_id               bigint(20)      not null comment '所属题库ID',
  creator_id            bigint(20)      not null comment '创建教师ID',
  question_type         char(1)         not null comment '题型（1单选 2多选 3判断 4填空 5简答）',
  difficulty_level      char(1)         default '2' comment '难度等级（1简单 2中等 3困难）',
  score                 decimal(8,2)    default 0.00 comment '默认分值',
  question_title        text            not null comment '题干',
  answer_json           longtext        comment '标准答案JSON',
  analysis              longtext        comment '答案解析',
  attachment_url        varchar(500)    default '' comment '附件地址',
  auto_marking          char(1)         default '1' comment '是否自动判分（0否 1是）',
  status                char(1)         default '0' comment '状态（0正常 1停用）',
  del_flag              char(1)         default '0' comment '删除标志（0存在 2删除）',
  usage_count           int(11)         default 0 comment '使用次数',
  answer_count          int(11)         default 0 comment '答题次数',
  correct_count         int(11)         default 0 comment '答对次数',
  create_by             varchar(64)     default '' comment '创建者',
  create_time           datetime        comment '创建时间',
  update_by             varchar(64)     default '' comment '更新者',
  update_time           datetime        comment '更新时间',
  remark                varchar(500)    default null comment '备注',
  primary key (question_id),
  key idx_question_bank (bank_id),
  key idx_question_creator (creator_id),
  key idx_question_type (question_type),
  key idx_question_status (status, del_flag)
) engine=innodb auto_increment=10000 comment='试题表';

-- ----------------------------
-- 4. 试题选项表
-- 仅用于单选、多选、判断题等带选项试题
-- ----------------------------
drop table if exists edu_question_option;
create table edu_question_option (
  option_id             bigint(20)      not null auto_increment comment '选项ID',
  question_id           bigint(20)      not null comment '试题ID',
  option_label          varchar(20)     not null comment '选项标识，如A/B/C',
  option_content        text            not null comment '选项内容',
  is_correct            char(1)         default '0' comment '是否正确答案（0否 1是）',
  sort_order            int(4)          default 0 comment '排序值',
  primary key (option_id),
  key idx_option_question (question_id)
) engine=innodb auto_increment=10000 comment='试题选项表';

-- ----------------------------
-- 5. 试卷表
-- ----------------------------
drop table if exists edu_paper;
create table edu_paper (
  paper_id              bigint(20)      not null auto_increment comment '试卷ID',
  paper_name            varchar(120)    not null comment '试卷名称',
  creator_id            bigint(20)      not null comment '创建教师ID',
  course_id             bigint(20)      default null comment '所属课程ID',
  bank_id               bigint(20)      default null comment '主要题库ID',
  paper_desc            varchar(1000)   default '' comment '试卷说明',
  total_score           decimal(8,2)    default 0.00 comment '总分',
  question_count        int(11)         default 0 comment '题目数量',
  objective_score       decimal(8,2)    default 0.00 comment '客观题总分',
  subjective_score      decimal(8,2)    default 0.00 comment '主观题总分',
  status                char(1)         default '0' comment '状态（0草稿 1启用 2停用）',
  del_flag              char(1)         default '0' comment '删除标志（0存在 2删除）',
  create_by             varchar(64)     default '' comment '创建者',
  create_time           datetime        comment '创建时间',
  update_by             varchar(64)     default '' comment '更新者',
  update_time           datetime        comment '更新时间',
  remark                varchar(500)    default null comment '备注',
  primary key (paper_id),
  key idx_paper_creator (creator_id),
  key idx_paper_course (course_id),
  key idx_paper_status (status, del_flag)
) engine=innodb auto_increment=10000 comment='试卷表';

-- ----------------------------
-- 6. 试卷题目关系表
-- ----------------------------
drop table if exists edu_paper_question;
create table edu_paper_question (
  id                    bigint(20)      not null auto_increment comment '主键ID',
  paper_id              bigint(20)      not null comment '试卷ID',
  question_id           bigint(20)      not null comment '试题ID',
  question_order        int(4)          default 0 comment '题目顺序',
  question_score        decimal(8,2)    default 0.00 comment '该题分值',
  question_type         char(1)         not null comment '题型（冗余存储）',
  difficulty_level      char(1)         default '2' comment '难度等级（冗余存储）',
  primary key (id),
  unique key uk_paper_question (paper_id, question_id),
  key idx_paper_question_paper (paper_id),
  key idx_paper_question_question (question_id)
) engine=innodb auto_increment=10000 comment='试卷题目关系表';

-- ----------------------------
-- 7. 考试表
-- 与课程内容表 edu_course_content.exam_id 对应
-- ----------------------------
drop table if exists edu_exam;
create table edu_exam (
  exam_id               bigint(20)      not null auto_increment comment '考试ID',
  exam_name             varchar(120)    not null comment '考试名称',
  paper_id              bigint(20)      not null comment '试卷ID',
  creator_id            bigint(20)      not null comment '创建教师ID',
  course_id             bigint(20)      default null comment '所属课程ID',
  exam_desc             varchar(2000)   default '' comment '考试说明',
  start_time            datetime        default null comment '开始时间',
  end_time              datetime        default null comment '结束时间',
  duration_minutes      int(11)         default 0 comment '考试时长（分钟）',
  pass_score            decimal(8,2)    default 0.00 comment '及格分',
  total_score           decimal(8,2)    default 0.00 comment '总分',
  max_attempt_count     int(11)         default 1 comment '最多考试次数',
  allow_interrupt       char(1)         default '0' comment '是否允许中断（0否 1是）',
  interrupt_count_time  char(1)         default '1' comment '中断是否计时（0否 1是）',
  show_answer_after     char(1)         default '0' comment '交卷后是否展示答案解析（0否 1是）',
  show_score_after      char(1)         default '1' comment '交卷后是否显示成绩（0否 1是）',
  question_shuffle      char(1)         default '0' comment '是否题目乱序（0否 1是）',
  option_shuffle        char(1)         default '0' comment '是否选项乱序（0否 1是）',
  status                char(1)         default '0' comment '状态（0草稿 1已发布 2已结束 3已下线）',
  del_flag              char(1)         default '0' comment '删除标志（0存在 2删除）',
  create_by             varchar(64)     default '' comment '创建者',
  create_time           datetime        comment '创建时间',
  update_by             varchar(64)     default '' comment '更新者',
  update_time           datetime        comment '更新时间',
  remark                varchar(500)    default null comment '备注',
  primary key (exam_id),
  key idx_exam_paper (paper_id),
  key idx_exam_course (course_id),
  key idx_exam_creator (creator_id),
  key idx_exam_time (start_time, end_time),
  key idx_exam_status (status, del_flag)
) engine=innodb auto_increment=10000 comment='考试表';

-- ----------------------------
-- 8. 学生考试记录表
-- ----------------------------
drop table if exists edu_exam_record;
create table edu_exam_record (
  record_id             bigint(20)      not null auto_increment comment '考试记录ID',
  exam_id               bigint(20)      not null comment '考试ID',
  paper_id              bigint(20)      not null comment '试卷ID',
  course_id             bigint(20)      default null comment '课程ID',
  student_id            bigint(20)      not null comment '学生ID',
  attempt_no            int(11)         default 1 comment '第几次考试',
  start_time            datetime        default null comment '开始时间',
  submit_time           datetime        default null comment '提交时间',
  duration_seconds      int(11)         default 0 comment '耗时（秒）',
  exam_status           char(1)         default '0' comment '考试状态（0待开始 1进行中 2已交卷 3已批改 4缺考）',
  objective_score       decimal(8,2)    default 0.00 comment '客观题得分',
  subjective_score      decimal(8,2)    default 0.00 comment '主观题得分',
  total_score           decimal(8,2)    default 0.00 comment '总分',
  pass_flag             char(1)         default '0' comment '是否及格（0否 1是）',
  checked_flag          char(1)         default '0' comment '是否完成阅卷（0否 1是）',
  primary key (record_id),
  unique key uk_exam_student_attempt (exam_id, student_id, attempt_no),
  key idx_record_exam (exam_id),
  key idx_record_student (student_id),
  key idx_record_course (course_id),
  key idx_record_status (exam_status, checked_flag)
) engine=innodb auto_increment=10000 comment='学生考试记录表';

-- ----------------------------
-- 9. 学生答题明细表
-- ----------------------------
drop table if exists edu_exam_answer;
create table edu_exam_answer (
  answer_id             bigint(20)      not null auto_increment comment '答题明细ID',
  record_id             bigint(20)      not null comment '考试记录ID',
  exam_id               bigint(20)      not null comment '考试ID',
  question_id           bigint(20)      not null comment '试题ID',
  question_type         char(1)         not null comment '题型',
  question_order        int(4)          default 0 comment '题目顺序',
  standard_answer       longtext        comment '标准答案快照',
  student_answer        longtext        comment '学生答案',
  is_correct            char(1)         default '0' comment '是否答对（0否 1是）',
  question_score        decimal(8,2)    default 0.00 comment '题目总分',
  actual_score          decimal(8,2)    default 0.00 comment '实际得分',
  teacher_comment       varchar(1000)   default '' comment '教师评语',
  checked_by            bigint(20)      default null comment '阅卷教师ID',
  checked_time          datetime        default null comment '阅卷时间',
  primary key (answer_id),
  unique key uk_record_question (record_id, question_id),
  key idx_answer_record (record_id),
  key idx_answer_exam (exam_id),
  key idx_answer_question (question_id)
) engine=innodb auto_increment=10000 comment='学生答题明细表';

-- ----------------------------
-- 10. 说明
-- ----------------------------
-- 后续开发建议：
-- 1. 教师端先做题库、试题、试卷、考试管理四个页面。
-- 2. 学生端考试入口可直接通过课程内容表中的 exam_id 进入。
-- 3. 若后续需要支持更复杂标签、随机组卷、防作弊，可在本结构基础上扩展。
-- 云课教学平台三种账号
-- 默认密码：admin123

insert into sys_user (
  user_id, dept_id, user_name, nick_name, student_no, email, phonenumber, sex, avatar,
  password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time,
  update_by, update_time, remark
)
select 10, 103, 'admin02', '系统管理员', 'AD001', 'admin02@school.edu.cn', '13800000010', '1', '',
       '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2',
       '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '系统管理员账号'
where not exists (select 1 from sys_user where user_name = 'admin02');

insert into sys_user (
  user_id, dept_id, user_name, nick_name, student_no, email, phonenumber, sex, avatar,
  password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time,
  update_by, update_time, remark
)
select 11, 103, 'teacher02', '教师二号', 'TS002', 'teacher02@school.edu.cn', '13800000011', '1', '',
       '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2',
       '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '教师账号'
where not exists (select 1 from sys_user where user_name = 'teacher02');

insert into sys_user (
  user_id, dept_id, user_name, nick_name, student_no, email, phonenumber, sex, avatar,
  password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time,
  update_by, update_time, remark
)
select 12, 103, 'student02', '学生二号', 'ST002', 'student02@school.edu.cn', '13800000012', '0', '',
       '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2',
       '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '学生账号'
where not exists (select 1 from sys_user where user_name = 'student02');

insert into sys_user_role (user_id, role_id)
select 10, 1 where not exists (select 1 from sys_user_role where user_id = 10 and role_id = 1);

insert into sys_user_role (user_id, role_id)
select 11, 3 where not exists (select 1 from sys_user_role where user_id = 11 and role_id = 3);

insert into sys_user_role (user_id, role_id)
select 12, 4 where not exists (select 1 from sys_user_role where user_id = 12 and role_id = 4);
-- 只往现有 ruoyi 库里插入 3 个账号
-- 默认密码：admin123

insert into sys_role (role_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, update_by, update_time, remark)
select 3, '教师', 'teacher', 3, 1, 1, 1, '0', '0', 'admin', sysdate(), '', null, '教师角色'
where not exists (select 1 from sys_role where role_id = 3);

insert into sys_role (role_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, update_by, update_time, remark)
select 4, '学生', 'student', 4, 2, 1, 1, '0', '0', 'admin', sysdate(), '', null, '学生角色'
where not exists (select 1 from sys_role where role_id = 4);

insert into sys_user (
  user_id, dept_id, user_name, nick_name, student_no, email, phonenumber, sex, avatar,
  password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time,
  update_by, update_time, remark
)
select 1001, 103, 'admin02', '系统管理员', 'AD001', 'admin02@school.edu.cn', '13800000010', '1', '',
       '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2',
       '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '系统管理员账号'
where not exists (select 1 from sys_user where user_name = 'admin02');

insert into sys_user (
  user_id, dept_id, user_name, nick_name, student_no, email, phonenumber, sex, avatar,
  password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time,
  update_by, update_time, remark
)
select 1002, 103, 'teacher02', '教师二号', 'TS002', 'teacher02@school.edu.cn', '13800000011', '1', '',
       '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2',
       '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '教师账号'
where not exists (select 1 from sys_user where user_name = 'teacher02');

insert into sys_user (
  user_id, dept_id, user_name, nick_name, student_no, email, phonenumber, sex, avatar,
  password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time,
  update_by, update_time, remark
)
select 1003, 103, 'student02', '学生二号', 'ST002', 'student02@school.edu.cn', '13800000012', '0', '',
       '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2',
       '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '学生账号'
where not exists (select 1 from sys_user where user_name = 'student02');

insert into sys_user_role (user_id, role_id)
select 1001, 1 where not exists (select 1 from sys_user_role where user_id = 1001 and role_id = 1);

insert into sys_user_role (user_id, role_id)
select 1002, 3 where not exists (select 1 from sys_user_role where user_id = 1002 and role_id = 3);

insert into sys_user_role (user_id, role_id)
select 1003, 4 where not exists (select 1 from sys_user_role where user_id = 1003 and role_id = 4);
-- 云课教学平台角色与菜单补丁
-- 已有数据库可直接执行本文件

update sys_role set role_name = '教师', role_key = 'teacher', role_sort = 3, status = '0', del_flag = '0' where role_id = 3;
update sys_role set role_name = '学生', role_key = 'student', role_sort = 4, status = '0', del_flag = '0' where role_id = 4;

insert into sys_role (role_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, update_by, update_time, remark)
select 3, '教师', 'teacher', 3, 1, 1, 1, '0', '0', 'admin', sysdate(), '', null, '教师角色'
where not exists (select 1 from sys_role where role_id = 3);

insert into sys_role (role_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, update_by, update_time, remark)
select 4, '学生', 'student', 4, 2, 1, 1, '0', '0', 'admin', sysdate(), '', null, '学生角色'
where not exists (select 1 from sys_role where role_id = 4);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2100', '教学管理', '0', '5', 'teaching', '', '', '', 0, 0, 'M', '0', '0', '', 'education', 'admin', sysdate(), '', null, '教师教学管理目录'
where not exists (select 1 from sys_menu where menu_id = '2100');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2101', '课程管理', '2100', '1', 'course', 'teaching/course/index', '', '', 0, 0, 'C', '0', '0', 'teaching:course:list', 'form', 'admin', sysdate(), '', null, '课程管理菜单'
where not exists (select 1 from sys_menu where menu_id = '2101');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2102', '学生管理', '2100', '2', 'student', 'account/student/index', '', '', 0, 0, 'C', '0', '0', 'account:student:list', 'peoples', 'admin', sysdate(), '', null, '学生管理菜单'
where not exists (select 1 from sys_menu where menu_id = '2102');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2103', '试卷管理', '2100', '3', 'paper', 'teaching/paper/index', '', '', 0, 0, 'C', '0', '0', 'teaching:paper:list', 'documentation', 'admin', sysdate(), '', null, '试卷管理菜单'
where not exists (select 1 from sys_menu where menu_id = '2103');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2104', '成绩统计', '2100', '4', 'score', 'teaching/score/index', '', '', 0, 0, 'C', '0', '0', 'teaching:score:list', 'chart', 'admin', sysdate(), '', null, '成绩统计菜单'
where not exists (select 1 from sys_menu where menu_id = '2104');

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2200', '学习中心', '0', '6', 'learning', '', '', '', 0, 0, 'M', '0', '0', '', 'guide', 'admin', sysdate(), '', null, '学生学习中心目录'
where not exists (select 1 from sys_menu where menu_id = '2200');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2201', '我的课程', '2200', '1', 'my-course', 'learning/my-course/index', '', '', 0, 0, 'C', '0', '0', 'learning:course:list', 'dashboard', 'admin', sysdate(), '', null, '我的课程菜单'
where not exists (select 1 from sys_menu where menu_id = '2201');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2202', '在线学习', '2200', '2', 'online', 'learning/online/index', '', '', 0, 0, 'C', '0', '0', 'learning:online:list', 'build', 'admin', sysdate(), '', null, '在线学习菜单'
where not exists (select 1 from sys_menu where menu_id = '2202');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2203', '我的考试', '2200', '3', 'exam', 'learning/exam/index', '', '', 0, 0, 'C', '0', '0', 'learning:exam:list', 'documentation', 'admin', sysdate(), '', null, '我的考试菜单'
where not exists (select 1 from sys_menu where menu_id = '2203');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2204', '我的错题', '2200', '4', 'wrong', 'learning/wrong/index', '', '', 0, 0, 'C', '0', '0', 'learning:wrong:list', 'bug', 'admin', sysdate(), '', null, '我的错题菜单'
where not exists (select 1 from sys_menu where menu_id = '2204');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2205', '收藏', '2200', '5', 'favorite', 'learning/favorite/index', '', '', 0, 0, 'C', '0', '0', 'learning:favorite:list', 'star', 'admin', sysdate(), '', null, '收藏菜单'
where not exists (select 1 from sys_menu where menu_id = '2205');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2206', '笔记', '2200', '6', 'note', 'learning/note/index', '', '', 0, 0, 'C', '0', '0', 'learning:note:list', 'edit', 'admin', sysdate(), '', null, '笔记菜单'
where not exists (select 1 from sys_menu where menu_id = '2206');

delete from sys_role_menu where role_id in (3, 4) and menu_id in (2000,2001,2002,2003,2004,2005,2100,2101,2102,2103,2104,2200,2201,2202,2203,2204,2205,2206);

insert into sys_role_menu (role_id, menu_id) select '3', '2100' where not exists (select 1 from sys_role_menu where role_id = '3' and menu_id = '2100');
insert into sys_role_menu (role_id, menu_id) select '3', '2101' where not exists (select 1 from sys_role_menu where role_id = '3' and menu_id = '2101');
insert into sys_role_menu (role_id, menu_id) select '3', '2102' where not exists (select 1 from sys_role_menu where role_id = '3' and menu_id = '2102');
insert into sys_role_menu (role_id, menu_id) select '3', '2103' where not exists (select 1 from sys_role_menu where role_id = '3' and menu_id = '2103');
insert into sys_role_menu (role_id, menu_id) select '3', '2104' where not exists (select 1 from sys_role_menu where role_id = '3' and menu_id = '2104');
insert into sys_role_menu (role_id, menu_id) select '4', '2200' where not exists (select 1 from sys_role_menu where role_id = '4' and menu_id = '2200');
insert into sys_role_menu (role_id, menu_id) select '4', '2201' where not exists (select 1 from sys_role_menu where role_id = '4' and menu_id = '2201');
insert into sys_role_menu (role_id, menu_id) select '4', '2202' where not exists (select 1 from sys_role_menu where role_id = '4' and menu_id = '2202');
insert into sys_role_menu (role_id, menu_id) select '4', '2203' where not exists (select 1 from sys_role_menu where role_id = '4' and menu_id = '2203');
insert into sys_role_menu (role_id, menu_id) select '4', '2204' where not exists (select 1 from sys_role_menu where role_id = '4' and menu_id = '2204');
insert into sys_role_menu (role_id, menu_id) select '4', '2205' where not exists (select 1 from sys_role_menu where role_id = '4' and menu_id = '2205');
insert into sys_role_menu (role_id, menu_id) select '4', '2206' where not exists (select 1 from sys_role_menu where role_id = '4' and menu_id = '2206');

insert into sys_user (user_id, dept_id, user_name, nick_name, student_no, email, phonenumber, sex, avatar, password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, update_by, update_time, remark)
select 3, 103, 'teacher', '教师', 'TS001', 'teacher@school.edu.cn', '13800000000', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '教师账号'
where not exists (select 1 from sys_user where user_id = 3);

insert into sys_user_role (user_id, role_id)
select 3, 3 where not exists (select 1 from sys_user_role where user_id = 3 and role_id = 3);

insert into sys_user (user_id, dept_id, user_name, nick_name, student_no, email, phonenumber, sex, avatar, password, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, update_by, update_time, remark)
select 4, 103, 'student01', '学生一号', 'ST001', 'student01@school.edu.cn', '13900000001', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '示例学生账号'
where not exists (select 1 from sys_user where user_id = 4);

insert into sys_user_role (user_id, role_id)
select 4, 4 where not exists (select 1 from sys_user_role where user_id = 4 and role_id = 4);

insert into edu_student_profile (user_id, signature, todo_items, learning_history, learning_notes, favorites, wrong_questions, discussions, create_by, create_time)
select 4, '认真学习，持续进步', '完成 Java Web 课程实验和数据库作业', '已完成 Java Web 第 1~6 章学习', '本周重点复习过滤器和拦截器', '收藏：Spring Security 登录流程图', '错题：数据库范式综合题', '讨论：期末项目模块分工', 'admin', sysdate()
where not exists (select 1 from edu_student_profile where user_id = 4);

insert into sys_role (role_id, role_name, role_key, role_sort, data_scope, menu_check_strictly, dept_check_strictly, status, del_flag, create_by, create_time, update_by, update_time, remark)
select 5, '游客', 'visitor', 5, 2, 1, 1, '0', '0', 'admin', sysdate(), '', null, '游客角色'
where not exists (select 1 from sys_role where role_id = 5);

insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2300', '账号管理', '0', '4', 'account', '', '', '', 0, 0, 'M', '0', '0', '', 'user', 'admin', sysdate(), '', null, '账号管理目录'
where not exists (select 1 from sys_menu where menu_id = '2300');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2301', '全部账号', '2300', '1', 'all', 'system/user/index', '{"roleId":0}', '', 0, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', sysdate(), '', null, '全部账号菜单'
where not exists (select 1 from sys_menu where menu_id = '2301');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2302', '学生账号', '2300', '2', 'student', 'system/user/index', '{"roleId":4}', '', 0, 0, 'C', '0', '0', 'system:user:list', 'peoples', 'admin', sysdate(), '', null, '学生账号菜单'
where not exists (select 1 from sys_menu where menu_id = '2302');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2303', '教师账号', '2300', '3', 'teacher', 'system/user/index', '{"roleId":3}', '', 0, 0, 'C', '0', '0', 'system:user:list', 'post', 'admin', sysdate(), '', null, '教师账号菜单'
where not exists (select 1 from sys_menu where menu_id = '2303');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2304', '管理员账号', '2300', '4', 'admin', 'system/user/index', '{"roleId":1}', '', 0, 0, 'C', '0', '0', 'system:user:list', 'admin', 'admin', sysdate(), '', null, '管理员账号菜单'
where not exists (select 1 from sys_menu where menu_id = '2304');
insert into sys_menu (menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select '2305', '游客账号', '2300', '5', 'visitor', 'system/user/index', '{"roleId":5}', '', 0, 0, 'C', '0', '0', 'system:user:list', 'message', 'admin', sysdate(), '', null, '游客账号菜单'
where not exists (select 1 from sys_menu where menu_id = '2305');
update sys_config
set config_value = 'true'
where config_key = 'sys.account.registerUser';
DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
DROP TABLE IF EXISTS QRTZ_LOCKS;
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
DROP TABLE IF EXISTS QRTZ_CALENDARS;

-- ----------------------------
-- 1、存储每一个已配置的 jobDetail 的详细信息
-- ----------------------------
create table QRTZ_JOB_DETAILS (
    sched_name           varchar(120)    not null            comment '调度名称',
    job_name             varchar(200)    not null            comment '任务名称',
    job_group            varchar(200)    not null            comment '任务组名',
    description          varchar(250)    null                comment '相关介绍',
    job_class_name       varchar(250)    not null            comment '执行任务类名称',
    is_durable           varchar(1)      not null            comment '是否持久化',
    is_nonconcurrent     varchar(1)      not null            comment '是否并发',
    is_update_data       varchar(1)      not null            comment '是否更新数据',
    requests_recovery    varchar(1)      not null            comment '是否接受恢复执行',
    job_data             blob            null                comment '存放持久化job对象',
    primary key (sched_name, job_name, job_group)
) engine=innodb comment = '任务详细信息表';

-- ----------------------------
-- 2、 存储已配置的 Trigger 的信息
-- ----------------------------
create table QRTZ_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment '触发器的名字',
    trigger_group        varchar(200)    not null            comment '触发器所属组的名字',
    job_name             varchar(200)    not null            comment 'qrtz_job_details表job_name的外键',
    job_group            varchar(200)    not null            comment 'qrtz_job_details表job_group的外键',
    description          varchar(250)    null                comment '相关介绍',
    next_fire_time       bigint(13)      null                comment '上一次触发时间（毫秒）',
    prev_fire_time       bigint(13)      null                comment '下一次触发时间（默认为-1表示不触发）',
    priority             integer         null                comment '优先级',
    trigger_state        varchar(16)     not null            comment '触发器状态',
    trigger_type         varchar(8)      not null            comment '触发器的类型',
    start_time           bigint(13)      not null            comment '开始时间',
    end_time             bigint(13)      null                comment '结束时间',
    calendar_name        varchar(200)    null                comment '日程表名称',
    misfire_instr        smallint(2)     null                comment '补偿执行的策略',
    job_data             blob            null                comment '存放持久化job对象',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, job_name, job_group) references QRTZ_JOB_DETAILS(sched_name, job_name, job_group)
) engine=innodb comment = '触发器详细信息表';

-- ----------------------------
-- 3、 存储简单的 Trigger，包括重复次数，间隔，以及已触发的次数
-- ----------------------------
create table QRTZ_SIMPLE_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    repeat_count         bigint(7)       not null            comment '重复的次数统计',
    repeat_interval      bigint(12)      not null            comment '重复的间隔时间',
    times_triggered      bigint(10)      not null            comment '已经触发的次数',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = '简单触发器的信息表';

-- ----------------------------
-- 4、 存储 Cron Trigger，包括 Cron 表达式和时区信息
-- ---------------------------- 
create table QRTZ_CRON_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    cron_expression      varchar(200)    not null            comment 'cron表达式',
    time_zone_id         varchar(80)                         comment '时区',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Cron类型的触发器表';

-- ----------------------------
-- 5、 Trigger 作为 Blob 类型存储(用于 Quartz 用户用 JDBC 创建他们自己定制的 Trigger 类型，JobStore 并不知道如何存储实例的时候)
-- ---------------------------- 
create table QRTZ_BLOB_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    blob_data            blob            null                comment '存放持久化Trigger对象',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Blob类型的触发器表';

-- ----------------------------
-- 6、 以 Blob 类型存储存放日历信息， quartz可配置一个日历来指定一个时间范围
-- ---------------------------- 
create table QRTZ_CALENDARS (
    sched_name           varchar(120)    not null            comment '调度名称',
    calendar_name        varchar(200)    not null            comment '日历名称',
    calendar             blob            not null            comment '存放持久化calendar对象',
    primary key (sched_name, calendar_name)
) engine=innodb comment = '日历信息表';

-- ----------------------------
-- 7、 存储已暂停的 Trigger 组的信息
-- ---------------------------- 
create table QRTZ_PAUSED_TRIGGER_GRPS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    primary key (sched_name, trigger_group)
) engine=innodb comment = '暂停的触发器表';

-- ----------------------------
-- 8、 存储与已触发的 Trigger 相关的状态信息，以及相联 Job 的执行信息
-- ---------------------------- 
create table QRTZ_FIRED_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    entry_id             varchar(95)     not null            comment '调度器实例id',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    instance_name        varchar(200)    not null            comment '调度器实例名',
    fired_time           bigint(13)      not null            comment '触发的时间',
    sched_time           bigint(13)      not null            comment '定时器制定的时间',
    priority             integer         not null            comment '优先级',
    state                varchar(16)     not null            comment '状态',
    job_name             varchar(200)    null                comment '任务名称',
    job_group            varchar(200)    null                comment '任务组名',
    is_nonconcurrent     varchar(1)      null                comment '是否并发',
    requests_recovery    varchar(1)      null                comment '是否接受恢复执行',
    primary key (sched_name, entry_id)
) engine=innodb comment = '已触发的触发器表';

-- ----------------------------
-- 9、 存储少量的有关 Scheduler 的状态信息，假如是用于集群中，可以看到其他的 Scheduler 实例
-- ---------------------------- 
create table QRTZ_SCHEDULER_STATE (
    sched_name           varchar(120)    not null            comment '调度名称',
    instance_name        varchar(200)    not null            comment '实例名称',
    last_checkin_time    bigint(13)      not null            comment '上次检查时间',
    checkin_interval     bigint(13)      not null            comment '检查间隔时间',
    primary key (sched_name, instance_name)
) engine=innodb comment = '调度器状态表';

-- ----------------------------
-- 10、 存储程序的悲观锁的信息(假如使用了悲观锁)
-- ---------------------------- 
create table QRTZ_LOCKS (
    sched_name           varchar(120)    not null            comment '调度名称',
    lock_name            varchar(40)     not null            comment '悲观锁名称',
    primary key (sched_name, lock_name)
) engine=innodb comment = '存储的悲观锁信息表';

-- ----------------------------
-- 11、 Quartz集群实现同步机制的行锁表
-- ---------------------------- 
create table QRTZ_SIMPROP_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment 'qrtz_triggers表trigger_name的外键',
    trigger_group        varchar(200)    not null            comment 'qrtz_triggers表trigger_group的外键',
    str_prop_1           varchar(512)    null                comment 'String类型的trigger的第一个参数',
    str_prop_2           varchar(512)    null                comment 'String类型的trigger的第二个参数',
    str_prop_3           varchar(512)    null                comment 'String类型的trigger的第三个参数',
    int_prop_1           int             null                comment 'int类型的trigger的第一个参数',
    int_prop_2           int             null                comment 'int类型的trigger的第二个参数',
    long_prop_1          bigint          null                comment 'long类型的trigger的第一个参数',
    long_prop_2          bigint          null                comment 'long类型的trigger的第二个参数',
    dec_prop_1           numeric(13,4)   null                comment 'decimal类型的trigger的第一个参数',
    dec_prop_2           numeric(13,4)   null                comment 'decimal类型的trigger的第二个参数',
    bool_prop_1          varchar(1)      null                comment 'Boolean类型的trigger的第一个参数',
    bool_prop_2          varchar(1)      null                comment 'Boolean类型的trigger的第二个参数',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = '同步机制的行锁表';

commit;-- ----------------------------
-- 1、部门表
-- ----------------------------
drop table if exists sys_dept;
create table sys_dept (
  dept_id           bigint(20)      not null auto_increment    comment '部门id',
  parent_id         bigint(20)      default 0                  comment '父部门id',
  ancestors         varchar(50)     default ''                 comment '祖级列表',
  dept_name         varchar(30)     default ''                 comment '部门名称',
  order_num         int(4)          default 0                  comment '显示顺序',
  leader            varchar(20)     default null               comment '负责人',
  phone             varchar(11)     default null               comment '联系电话',
  email             varchar(50)     default null               comment '邮箱',
  status            char(1)         default '0'                comment '部门状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (dept_id)
) engine=innodb auto_increment=200 comment = '部门表';

-- ----------------------------
-- 初始化-部门表数据
-- ----------------------------
insert into sys_dept values(100,  0,   '0',          '若依科技',   0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(101,  100, '0,100',      '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(102,  100, '0,100',      '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(103,  101, '0,100,101',  '研发部门',   1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(104,  101, '0,100,101',  '市场部门',   2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(105,  101, '0,100,101',  '测试部门',   3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(106,  101, '0,100,101',  '财务部门',   4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(107,  101, '0,100,101',  '运维部门',   5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(108,  102, '0,100,102',  '市场部门',   1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);
insert into sys_dept values(109,  102, '0,100,102',  '财务部门',   2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', sysdate(), '', null);


-- ----------------------------
-- 2、用户信息表
-- ----------------------------
drop table if exists sys_user;
create table sys_user (
  user_id           bigint(20)      not null auto_increment    comment '用户ID',
  dept_id           bigint(20)      default null               comment '部门ID',
  user_name         varchar(30)     not null                   comment '用户账号',
  nick_name         varchar(30)     not null                   comment '用户昵称',
  user_type         varchar(2)      default '00'               comment '用户类型（00系统用户）',
  email             varchar(50)     default ''                 comment '用户邮箱',
  phonenumber       varchar(11)     default ''                 comment '手机号码',
  sex               char(1)         default '0'                comment '用户性别（0男 1女 2未知）',
  avatar            varchar(100)    default ''                 comment '头像地址',
  password          varchar(100)    default ''                 comment '密码',
  status            char(1)         default '0'                comment '账号状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  login_ip          varchar(128)    default ''                 comment '最后登录IP',
  login_date        datetime                                   comment '最后登录时间',
  pwd_update_date   datetime                                   comment '密码最后更新时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (user_id)
) engine=innodb auto_increment=100 comment = '用户信息表';

-- ----------------------------
-- 初始化-用户信息表数据
-- ----------------------------
insert into sys_user values(1,  103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '管理员');
insert into sys_user values(2,  105, 'ry',    '若依', '00', 'ry@qq.com',  '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '测试员');


-- ----------------------------
-- 3、岗位信息表
-- ----------------------------
drop table if exists sys_post;
create table sys_post
(
  post_id       bigint(20)      not null auto_increment    comment '岗位ID',
  post_code     varchar(64)     not null                   comment '岗位编码',
  post_name     varchar(50)     not null                   comment '岗位名称',
  post_sort     int(4)          not null                   comment '显示顺序',
  status        char(1)         not null                   comment '状态（0正常 1停用）',
  create_by     varchar(64)     default ''                 comment '创建者',
  create_time   datetime                                   comment '创建时间',
  update_by     varchar(64)     default ''			       comment '更新者',
  update_time   datetime                                   comment '更新时间',
  remark        varchar(500)    default null               comment '备注',
  primary key (post_id)
) engine=innodb comment = '岗位信息表';

-- ----------------------------
-- 初始化-岗位信息表数据
-- ----------------------------
insert into sys_post values(1, 'ceo',  '董事长',    1, '0', 'admin', sysdate(), '', null, '');
insert into sys_post values(2, 'se',   '项目经理',  2, '0', 'admin', sysdate(), '', null, '');
insert into sys_post values(3, 'hr',   '人力资源',  3, '0', 'admin', sysdate(), '', null, '');
insert into sys_post values(4, 'user', '普通员工',  4, '0', 'admin', sysdate(), '', null, '');


-- ----------------------------
-- 4、角色信息表
-- ----------------------------
drop table if exists sys_role;
create table sys_role (
  role_id              bigint(20)      not null auto_increment    comment '角色ID',
  role_name            varchar(30)     not null                   comment '角色名称',
  role_key             varchar(100)    not null                   comment '角色权限字符串',
  role_sort            int(4)          not null                   comment '显示顺序',
  data_scope           char(1)         default '1'                comment '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  menu_check_strictly  tinyint(1)      default 1                  comment '菜单树选择项是否关联显示',
  dept_check_strictly  tinyint(1)      default 1                  comment '部门树选择项是否关联显示',
  status               char(1)         not null                   comment '角色状态（0正常 1停用）',
  del_flag             char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by            varchar(64)     default ''                 comment '创建者',
  create_time          datetime                                   comment '创建时间',
  update_by            varchar(64)     default ''                 comment '更新者',
  update_time          datetime                                   comment '更新时间',
  remark               varchar(500)    default null               comment '备注',
  primary key (role_id)
) engine=innodb auto_increment=100 comment = '角色信息表';

-- ----------------------------
-- 初始化-角色信息表数据
-- ----------------------------
insert into sys_role values('1', '超级管理员',  'admin',  1, 1, 1, 1, '0', '0', 'admin', sysdate(), '', null, '超级管理员');
insert into sys_role values('2', '普通角色',    'common', 2, 2, 1, 1, '0', '0', 'admin', sysdate(), '', null, '普通角色');


-- ----------------------------
-- 5、菜单权限表
-- ----------------------------
drop table if exists sys_menu;
create table sys_menu (
  menu_id           bigint(20)      not null auto_increment    comment '菜单ID',
  menu_name         varchar(50)     not null                   comment '菜单名称',
  parent_id         bigint(20)      default 0                  comment '父菜单ID',
  order_num         int(4)          default 0                  comment '显示顺序',
  path              varchar(200)    default ''                 comment '路由地址',
  component         varchar(255)    default null               comment '组件路径',
  query             varchar(255)    default null               comment '路由参数',
  route_name        varchar(50)     default ''                 comment '路由名称',
  is_frame          int(1)          default 1                  comment '是否为外链（0是 1否）',
  is_cache          int(1)          default 0                  comment '是否缓存（0缓存 1不缓存）',
  menu_type         char(1)         default ''                 comment '菜单类型（M目录 C菜单 F按钮）',
  visible           char(1)         default 0                  comment '菜单状态（0显示 1隐藏）',
  status            char(1)         default 0                  comment '菜单状态（0正常 1停用）',
  perms             varchar(100)    default null               comment '权限标识',
  icon              varchar(100)    default '#'                comment '菜单图标',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''                 comment '备注',
  primary key (menu_id)
) engine=innodb auto_increment=2000 comment = '菜单权限表';

-- ----------------------------
-- 初始化-菜单信息表数据
-- ----------------------------
-- 一级菜单
insert into sys_menu values('1', '系统管理', '0', '1', 'system',           null, '', '', 1, 0, 'M', '0', '0', '', 'system',   'admin', sysdate(), '', null, '系统管理目录');
insert into sys_menu values('2', '系统监控', '0', '2', 'monitor',          null, '', '', 1, 0, 'M', '0', '0', '', 'monitor',  'admin', sysdate(), '', null, '系统监控目录');
insert into sys_menu values('3', '系统工具', '0', '3', 'tool',             null, '', '', 1, 0, 'M', '0', '0', '', 'tool',     'admin', sysdate(), '', null, '系统工具目录');
insert into sys_menu values('4', '若依官网', '0', '4', 'http://ruoyi.vip', null, '', '', 0, 0, 'M', '0', '0', '', 'guide',    'admin', sysdate(), '', null, '若依官网地址');
-- 二级菜单
insert into sys_menu values('100',  '用户管理', '1',   '1', 'user',       'system/user/index',        '', '', 1, 0, 'C', '0', '0', 'system:user:list',        'user',          'admin', sysdate(), '', null, '用户管理菜单');
insert into sys_menu values('101',  '角色管理', '1',   '2', 'role',       'system/role/index',        '', '', 1, 0, 'C', '0', '0', 'system:role:list',        'peoples',       'admin', sysdate(), '', null, '角色管理菜单');
insert into sys_menu values('102',  '菜单管理', '1',   '3', 'menu',       'system/menu/index',        '', '', 1, 0, 'C', '0', '0', 'system:menu:list',        'tree-table',    'admin', sysdate(), '', null, '菜单管理菜单');
insert into sys_menu values('103',  '部门管理', '1',   '4', 'dept',       'system/dept/index',        '', '', 1, 0, 'C', '0', '0', 'system:dept:list',        'tree',          'admin', sysdate(), '', null, '部门管理菜单');
insert into sys_menu values('104',  '岗位管理', '1',   '5', 'post',       'system/post/index',        '', '', 1, 0, 'C', '0', '0', 'system:post:list',        'post',          'admin', sysdate(), '', null, '岗位管理菜单');
insert into sys_menu values('105',  '字典管理', '1',   '6', 'dict',       'system/dict/index',        '', '', 1, 0, 'C', '0', '0', 'system:dict:list',        'dict',          'admin', sysdate(), '', null, '字典管理菜单');
insert into sys_menu values('106',  '参数设置', '1',   '7', 'config',     'system/config/index',      '', '', 1, 0, 'C', '0', '0', 'system:config:list',      'edit',          'admin', sysdate(), '', null, '参数设置菜单');
insert into sys_menu values('107',  '通知公告', '1',   '8', 'notice',     'system/notice/index',      '', '', 1, 0, 'C', '0', '0', 'system:notice:list',      'message',       'admin', sysdate(), '', null, '通知公告菜单');
insert into sys_menu values('108',  '日志管理', '1',   '9', 'log',        '',                         '', '', 1, 0, 'M', '0', '0', '',                        'log',           'admin', sysdate(), '', null, '日志管理菜单');
insert into sys_menu values('109',  '在线用户', '2',   '1', 'online',     'monitor/online/index',     '', '', 1, 0, 'C', '0', '0', 'monitor:online:list',     'online',        'admin', sysdate(), '', null, '在线用户菜单');
insert into sys_menu values('110',  '定时任务', '2',   '2', 'job',        'monitor/job/index',        '', '', 1, 0, 'C', '0', '0', 'monitor:job:list',        'job',           'admin', sysdate(), '', null, '定时任务菜单');
insert into sys_menu values('111',  '数据监控', '2',   '3', 'druid',      'monitor/druid/index',      '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list',      'druid',         'admin', sysdate(), '', null, '数据监控菜单');
insert into sys_menu values('112',  '服务监控', '2',   '4', 'server',     'monitor/server/index',     '', '', 1, 0, 'C', '0', '0', 'monitor:server:list',     'server',        'admin', sysdate(), '', null, '服务监控菜单');
insert into sys_menu values('113',  '缓存监控', '2',   '5', 'cache',      'monitor/cache/index',      '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list',      'redis',         'admin', sysdate(), '', null, '缓存监控菜单');
insert into sys_menu values('114',  '缓存列表', '2',   '6', 'cacheList',  'monitor/cache/list',       '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list',      'redis-list',    'admin', sysdate(), '', null, '缓存列表菜单');
insert into sys_menu values('115',  '表单构建', '3',   '1', 'build',      'tool/build/index',         '', '', 1, 0, 'C', '0', '0', 'tool:build:list',         'build',         'admin', sysdate(), '', null, '表单构建菜单');
insert into sys_menu values('116',  '代码生成', '3',   '2', 'gen',        'tool/gen/index',           '', '', 1, 0, 'C', '0', '0', 'tool:gen:list',           'code',          'admin', sysdate(), '', null, '代码生成菜单');
insert into sys_menu values('117',  '系统接口', '3',   '3', 'swagger',    'tool/swagger/index',       '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list',       'swagger',       'admin', sysdate(), '', null, '系统接口菜单');
-- 三级菜单
insert into sys_menu values('500',  '操作日志', '108', '1', 'operlog',    'monitor/operlog/index',    '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list',    'form',          'admin', sysdate(), '', null, '操作日志菜单');
insert into sys_menu values('501',  '登录日志', '108', '2', 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor',    'admin', sysdate(), '', null, '登录日志菜单');
-- 用户管理按钮
insert into sys_menu values('1000', '用户查询', '100', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1001', '用户新增', '100', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1002', '用户修改', '100', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1003', '用户删除', '100', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1004', '用户导出', '100', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1005', '用户导入', '100', '6',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1006', '重置密码', '100', '7',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd',       '#', 'admin', sysdate(), '', null, '');
-- 角色管理按钮
insert into sys_menu values('1007', '角色查询', '101', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1008', '角色新增', '101', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1009', '角色修改', '101', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1010', '角色删除', '101', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1011', '角色导出', '101', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export',         '#', 'admin', sysdate(), '', null, '');
-- 菜单管理按钮
insert into sys_menu values('1012', '菜单查询', '102', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1013', '菜单新增', '102', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1014', '菜单修改', '102', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1015', '菜单删除', '102', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove',         '#', 'admin', sysdate(), '', null, '');
-- 部门管理按钮
insert into sys_menu values('1016', '部门查询', '103', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1017', '部门新增', '103', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1018', '部门修改', '103', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1019', '部门删除', '103', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove',         '#', 'admin', sysdate(), '', null, '');
-- 岗位管理按钮
insert into sys_menu values('1020', '岗位查询', '104', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1021', '岗位新增', '104', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1022', '岗位修改', '104', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1023', '岗位删除', '104', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1024', '岗位导出', '104', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export',         '#', 'admin', sysdate(), '', null, '');
-- 字典管理按钮
insert into sys_menu values('1025', '字典查询', '105', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1026', '字典新增', '105', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1027', '字典修改', '105', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1028', '字典删除', '105', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1029', '字典导出', '105', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export',         '#', 'admin', sysdate(), '', null, '');
-- 参数设置按钮
insert into sys_menu values('1030', '参数查询', '106', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1031', '参数新增', '106', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1032', '参数修改', '106', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1033', '参数删除', '106', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove',       '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1034', '参数导出', '106', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export',       '#', 'admin', sysdate(), '', null, '');
-- 通知公告按钮
insert into sys_menu values('1035', '公告查询', '107', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query',        '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1036', '公告新增', '107', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1037', '公告修改', '107', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1038', '公告删除', '107', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove',       '#', 'admin', sysdate(), '', null, '');
-- 操作日志按钮
insert into sys_menu values('1039', '操作查询', '500', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query',      '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1040', '操作删除', '500', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove',     '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1041', '日志导出', '500', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export',     '#', 'admin', sysdate(), '', null, '');
-- 登录日志按钮
insert into sys_menu values('1042', '登录查询', '501', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query',   '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1043', '登录删除', '501', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove',  '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1044', '日志导出', '501', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export',  '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1045', '账户解锁', '501', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock',  '#', 'admin', sysdate(), '', null, '');
-- 在线用户按钮
insert into sys_menu values('1046', '在线查询', '109', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query',       '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1047', '批量强退', '109', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1048', '单条强退', '109', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', sysdate(), '', null, '');
-- 定时任务按钮
insert into sys_menu values('1049', '任务查询', '110', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query',          '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1050', '任务新增', '110', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1051', '任务修改', '110', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1052', '任务删除', '110', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove',         '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1053', '状态修改', '110', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus',   '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1054', '任务导出', '110', '6', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export',         '#', 'admin', sysdate(), '', null, '');
-- 代码生成按钮
insert into sys_menu values('1055', '生成查询', '116', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query',             '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1056', '生成修改', '116', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit',              '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1057', '生成删除', '116', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1058', '导入代码', '116', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import',            '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1059', '预览代码', '116', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview',           '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('1060', '生成代码', '116', '6', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code',              '#', 'admin', sysdate(), '', null, '');


-- ----------------------------
-- 6、用户和角色关联表  用户N-1角色
-- ----------------------------
drop table if exists sys_user_role;
create table sys_user_role (
  user_id   bigint(20) not null comment '用户ID',
  role_id   bigint(20) not null comment '角色ID',
  primary key(user_id, role_id)
) engine=innodb comment = '用户和角色关联表';

-- ----------------------------
-- 初始化-用户和角色关联表数据
-- ----------------------------
insert into sys_user_role values ('1', '1');
insert into sys_user_role values ('2', '2');


-- ----------------------------
-- 7、角色和菜单关联表  角色1-N菜单
-- ----------------------------
drop table if exists sys_role_menu;
create table sys_role_menu (
  role_id   bigint(20) not null comment '角色ID',
  menu_id   bigint(20) not null comment '菜单ID',
  primary key(role_id, menu_id)
) engine=innodb comment = '角色和菜单关联表';

-- ----------------------------
-- 初始化-角色和菜单关联表数据
-- ----------------------------
insert into sys_role_menu values ('2', '1');
insert into sys_role_menu values ('2', '2');
insert into sys_role_menu values ('2', '3');
insert into sys_role_menu values ('2', '4');
insert into sys_role_menu values ('2', '100');
insert into sys_role_menu values ('2', '101');
insert into sys_role_menu values ('2', '102');
insert into sys_role_menu values ('2', '103');
insert into sys_role_menu values ('2', '104');
insert into sys_role_menu values ('2', '105');
insert into sys_role_menu values ('2', '106');
insert into sys_role_menu values ('2', '107');
insert into sys_role_menu values ('2', '108');
insert into sys_role_menu values ('2', '109');
insert into sys_role_menu values ('2', '110');
insert into sys_role_menu values ('2', '111');
insert into sys_role_menu values ('2', '112');
insert into sys_role_menu values ('2', '113');
insert into sys_role_menu values ('2', '114');
insert into sys_role_menu values ('2', '115');
insert into sys_role_menu values ('2', '116');
insert into sys_role_menu values ('2', '117');
insert into sys_role_menu values ('2', '500');
insert into sys_role_menu values ('2', '501');
insert into sys_role_menu values ('2', '1000');
insert into sys_role_menu values ('2', '1001');
insert into sys_role_menu values ('2', '1002');
insert into sys_role_menu values ('2', '1003');
insert into sys_role_menu values ('2', '1004');
insert into sys_role_menu values ('2', '1005');
insert into sys_role_menu values ('2', '1006');
insert into sys_role_menu values ('2', '1007');
insert into sys_role_menu values ('2', '1008');
insert into sys_role_menu values ('2', '1009');
insert into sys_role_menu values ('2', '1010');
insert into sys_role_menu values ('2', '1011');
insert into sys_role_menu values ('2', '1012');
insert into sys_role_menu values ('2', '1013');
insert into sys_role_menu values ('2', '1014');
insert into sys_role_menu values ('2', '1015');
insert into sys_role_menu values ('2', '1016');
insert into sys_role_menu values ('2', '1017');
insert into sys_role_menu values ('2', '1018');
insert into sys_role_menu values ('2', '1019');
insert into sys_role_menu values ('2', '1020');
insert into sys_role_menu values ('2', '1021');
insert into sys_role_menu values ('2', '1022');
insert into sys_role_menu values ('2', '1023');
insert into sys_role_menu values ('2', '1024');
insert into sys_role_menu values ('2', '1025');
insert into sys_role_menu values ('2', '1026');
insert into sys_role_menu values ('2', '1027');
insert into sys_role_menu values ('2', '1028');
insert into sys_role_menu values ('2', '1029');
insert into sys_role_menu values ('2', '1030');
insert into sys_role_menu values ('2', '1031');
insert into sys_role_menu values ('2', '1032');
insert into sys_role_menu values ('2', '1033');
insert into sys_role_menu values ('2', '1034');
insert into sys_role_menu values ('2', '1035');
insert into sys_role_menu values ('2', '1036');
insert into sys_role_menu values ('2', '1037');
insert into sys_role_menu values ('2', '1038');
insert into sys_role_menu values ('2', '1039');
insert into sys_role_menu values ('2', '1040');
insert into sys_role_menu values ('2', '1041');
insert into sys_role_menu values ('2', '1042');
insert into sys_role_menu values ('2', '1043');
insert into sys_role_menu values ('2', '1044');
insert into sys_role_menu values ('2', '1045');
insert into sys_role_menu values ('2', '1046');
insert into sys_role_menu values ('2', '1047');
insert into sys_role_menu values ('2', '1048');
insert into sys_role_menu values ('2', '1049');
insert into sys_role_menu values ('2', '1050');
insert into sys_role_menu values ('2', '1051');
insert into sys_role_menu values ('2', '1052');
insert into sys_role_menu values ('2', '1053');
insert into sys_role_menu values ('2', '1054');
insert into sys_role_menu values ('2', '1055');
insert into sys_role_menu values ('2', '1056');
insert into sys_role_menu values ('2', '1057');
insert into sys_role_menu values ('2', '1058');
insert into sys_role_menu values ('2', '1059');
insert into sys_role_menu values ('2', '1060');

-- ----------------------------
-- 8、角色和部门关联表  角色1-N部门
-- ----------------------------
drop table if exists sys_role_dept;
create table sys_role_dept (
  role_id   bigint(20) not null comment '角色ID',
  dept_id   bigint(20) not null comment '部门ID',
  primary key(role_id, dept_id)
) engine=innodb comment = '角色和部门关联表';

-- ----------------------------
-- 初始化-角色和部门关联表数据
-- ----------------------------
insert into sys_role_dept values ('2', '100');
insert into sys_role_dept values ('2', '101');
insert into sys_role_dept values ('2', '105');


-- ----------------------------
-- 9、用户与岗位关联表  用户1-N岗位
-- ----------------------------
drop table if exists sys_user_post;
create table sys_user_post
(
  user_id   bigint(20) not null comment '用户ID',
  post_id   bigint(20) not null comment '岗位ID',
  primary key (user_id, post_id)
) engine=innodb comment = '用户与岗位关联表';

-- ----------------------------
-- 初始化-用户与岗位关联表数据
-- ----------------------------
insert into sys_user_post values ('1', '1');
insert into sys_user_post values ('2', '2');


-- ----------------------------
-- 10、操作日志记录
-- ----------------------------
drop table if exists sys_oper_log;
create table sys_oper_log (
  oper_id           bigint(20)      not null auto_increment    comment '日志主键',
  title             varchar(50)     default ''                 comment '模块标题',
  business_type     int(2)          default 0                  comment '业务类型（0其它 1新增 2修改 3删除）',
  method            varchar(200)    default ''                 comment '方法名称',
  request_method    varchar(10)     default ''                 comment '请求方式',
  operator_type     int(1)          default 0                  comment '操作类别（0其它 1后台用户 2手机端用户）',
  oper_name         varchar(50)     default ''                 comment '操作人员',
  dept_name         varchar(50)     default ''                 comment '部门名称',
  oper_url          varchar(255)    default ''                 comment '请求URL',
  oper_ip           varchar(128)    default ''                 comment '主机地址',
  oper_location     varchar(255)    default ''                 comment '操作地点',
  oper_param        varchar(2000)   default ''                 comment '请求参数',
  json_result       varchar(2000)   default ''                 comment '返回参数',
  status            int(1)          default 0                  comment '操作状态（0正常 1异常）',
  error_msg         varchar(2000)   default ''                 comment '错误消息',
  oper_time         datetime                                   comment '操作时间',
  cost_time         bigint(20)      default 0                  comment '消耗时间',
  primary key (oper_id),
  key idx_sys_oper_log_bt (business_type),
  key idx_sys_oper_log_s  (status),
  key idx_sys_oper_log_ot (oper_time)
) engine=innodb auto_increment=100 comment = '操作日志记录';


-- ----------------------------
-- 11、字典类型表
-- ----------------------------
drop table if exists sys_dict_type;
create table sys_dict_type
(
  dict_id          bigint(20)      not null auto_increment    comment '字典主键',
  dict_name        varchar(100)    default ''                 comment '字典名称',
  dict_type        varchar(100)    default ''                 comment '字典类型',
  status           char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by        varchar(64)     default ''                 comment '创建者',
  create_time      datetime                                   comment '创建时间',
  update_by        varchar(64)     default ''                 comment '更新者',
  update_time      datetime                                   comment '更新时间',
  remark           varchar(500)    default null               comment '备注',
  primary key (dict_id),
  unique (dict_type)
) engine=innodb auto_increment=100 comment = '字典类型表';

insert into sys_dict_type values(1,  '用户性别', 'sys_user_sex',        '0', 'admin', sysdate(), '', null, '用户性别列表');
insert into sys_dict_type values(2,  '菜单状态', 'sys_show_hide',       '0', 'admin', sysdate(), '', null, '菜单状态列表');
insert into sys_dict_type values(3,  '系统开关', 'sys_normal_disable',  '0', 'admin', sysdate(), '', null, '系统开关列表');
insert into sys_dict_type values(4,  '任务状态', 'sys_job_status',      '0', 'admin', sysdate(), '', null, '任务状态列表');
insert into sys_dict_type values(5,  '任务分组', 'sys_job_group',       '0', 'admin', sysdate(), '', null, '任务分组列表');
insert into sys_dict_type values(6,  '系统是否', 'sys_yes_no',          '0', 'admin', sysdate(), '', null, '系统是否列表');
insert into sys_dict_type values(7,  '通知类型', 'sys_notice_type',     '0', 'admin', sysdate(), '', null, '通知类型列表');
insert into sys_dict_type values(8,  '通知状态', 'sys_notice_status',   '0', 'admin', sysdate(), '', null, '通知状态列表');
insert into sys_dict_type values(9,  '操作类型', 'sys_oper_type',       '0', 'admin', sysdate(), '', null, '操作类型列表');
insert into sys_dict_type values(10, '系统状态', 'sys_common_status',   '0', 'admin', sysdate(), '', null, '登录状态列表');


-- ----------------------------
-- 12、字典数据表
-- ----------------------------
drop table if exists sys_dict_data;
create table sys_dict_data
(
  dict_code        bigint(20)      not null auto_increment    comment '字典编码',
  dict_sort        int(4)          default 0                  comment '字典排序',
  dict_label       varchar(100)    default ''                 comment '字典标签',
  dict_value       varchar(100)    default ''                 comment '字典键值',
  dict_type        varchar(100)    default ''                 comment '字典类型',
  css_class        varchar(100)    default null               comment '样式属性（其他样式扩展）',
  list_class       varchar(100)    default null               comment '表格回显样式',
  is_default       char(1)         default 'N'                comment '是否默认（Y是 N否）',
  status           char(1)         default '0'                comment '状态（0正常 1停用）',
  create_by        varchar(64)     default ''                 comment '创建者',
  create_time      datetime                                   comment '创建时间',
  update_by        varchar(64)     default ''                 comment '更新者',
  update_time      datetime                                   comment '更新时间',
  remark           varchar(500)    default null               comment '备注',
  primary key (dict_code)
) engine=innodb auto_increment=100 comment = '字典数据表';

insert into sys_dict_data values(1,  1,  '男',       '0',       'sys_user_sex',        '',   '',        'Y', '0', 'admin', sysdate(), '', null, '性别男');
insert into sys_dict_data values(2,  2,  '女',       '1',       'sys_user_sex',        '',   '',        'N', '0', 'admin', sysdate(), '', null, '性别女');
insert into sys_dict_data values(3,  3,  '未知',     '2',       'sys_user_sex',        '',   '',        'N', '0', 'admin', sysdate(), '', null, '性别未知');
insert into sys_dict_data values(4,  1,  '显示',     '0',       'sys_show_hide',       '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '显示菜单');
insert into sys_dict_data values(5,  2,  '隐藏',     '1',       'sys_show_hide',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '隐藏菜单');
insert into sys_dict_data values(6,  1,  '正常',     '0',       'sys_normal_disable',  '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(7,  2,  '停用',     '1',       'sys_normal_disable',  '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '停用状态');
insert into sys_dict_data values(8,  1,  '正常',     '0',       'sys_job_status',      '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(9,  2,  '暂停',     '1',       'sys_job_status',      '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '停用状态');
insert into sys_dict_data values(10, 1,  '默认',     'DEFAULT', 'sys_job_group',       '',   '',        'Y', '0', 'admin', sysdate(), '', null, '默认分组');
insert into sys_dict_data values(11, 2,  '系统',     'SYSTEM',  'sys_job_group',       '',   '',        'N', '0', 'admin', sysdate(), '', null, '系统分组');
insert into sys_dict_data values(12, 1,  '是',       'Y',       'sys_yes_no',          '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '系统默认是');
insert into sys_dict_data values(13, 2,  '否',       'N',       'sys_yes_no',          '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '系统默认否');
insert into sys_dict_data values(14, 1,  '通知',     '1',       'sys_notice_type',     '',   'warning', 'Y', '0', 'admin', sysdate(), '', null, '通知');
insert into sys_dict_data values(15, 2,  '公告',     '2',       'sys_notice_type',     '',   'success', 'N', '0', 'admin', sysdate(), '', null, '公告');
insert into sys_dict_data values(16, 1,  '正常',     '0',       'sys_notice_status',   '',   'primary', 'Y', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(17, 2,  '关闭',     '1',       'sys_notice_status',   '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '关闭状态');
insert into sys_dict_data values(18, 99, '其他',     '0',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', sysdate(), '', null, '其他操作');
insert into sys_dict_data values(19, 1,  '新增',     '1',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', sysdate(), '', null, '新增操作');
insert into sys_dict_data values(20, 2,  '修改',     '2',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', sysdate(), '', null, '修改操作');
insert into sys_dict_data values(21, 3,  '删除',     '3',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '删除操作');
insert into sys_dict_data values(22, 4,  '授权',     '4',       'sys_oper_type',       '',   'primary', 'N', '0', 'admin', sysdate(), '', null, '授权操作');
insert into sys_dict_data values(23, 5,  '导出',     '5',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '导出操作');
insert into sys_dict_data values(24, 6,  '导入',     '6',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '导入操作');
insert into sys_dict_data values(25, 7,  '强退',     '7',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '强退操作');
insert into sys_dict_data values(26, 8,  '生成代码', '8',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '生成操作');
insert into sys_dict_data values(27, 9,  '清空数据', '9',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '清空操作');
insert into sys_dict_data values(28, 1,  '成功',     '0',       'sys_common_status',   '',   'primary', 'N', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(29, 2,  '失败',     '1',       'sys_common_status',   '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '停用状态');


-- ----------------------------
-- 13、参数配置表
-- ----------------------------
drop table if exists sys_config;
create table sys_config (
  config_id         int(5)          not null auto_increment    comment '参数主键',
  config_name       varchar(100)    default ''                 comment '参数名称',
  config_key        varchar(100)    default ''                 comment '参数键名',
  config_value      varchar(500)    default ''                 comment '参数键值',
  config_type       char(1)         default 'N'                comment '系统内置（Y是 N否）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (config_id)
) engine=innodb auto_increment=100 comment = '参数配置表';

insert into sys_config values(1, '主框架页-默认皮肤样式名称',     'sys.index.skinName',               'skin-blue',     'Y', 'admin', sysdate(), '', null, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow' );
insert into sys_config values(2, '用户管理-账号初始密码',         'sys.user.initPassword',            '123456',        'Y', 'admin', sysdate(), '', null, '初始化密码 123456' );
insert into sys_config values(3, '主框架页-侧边栏主题',           'sys.index.sideTheme',              'theme-dark',    'Y', 'admin', sysdate(), '', null, '深色主题theme-dark，浅色主题theme-light' );
insert into sys_config values(4, '账号自助-验证码开关',           'sys.account.captchaEnabled',       'true',          'Y', 'admin', sysdate(), '', null, '是否开启验证码功能（true开启，false关闭）');
insert into sys_config values(5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser',         'true',          'Y', 'admin', sysdate(), '', null, '是否开启注册用户功能（true开启，false关闭）');
insert into sys_config values(6, '用户登录-黑名单列表',           'sys.login.blackIPList',            '',              'Y', 'admin', sysdate(), '', null, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
insert into sys_config values(7, '用户管理-初始密码修改策略',     'sys.account.initPasswordModify',   '1',             'Y', 'admin', sysdate(), '', null, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
insert into sys_config values(8, '用户管理-账号密码更新周期',     'sys.account.passwordValidateDays', '0',             'Y', 'admin', sysdate(), '', null, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
insert into sys_config values(9, '用户管理-密码字符范围',         'sys.account.chrtype',              '0',             'Y', 'admin', sysdate(), '', null, '默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');


-- ----------------------------
-- 14、系统访问记录
-- ----------------------------
drop table if exists sys_logininfor;
create table sys_logininfor (
  info_id        bigint(20)     not null auto_increment   comment '访问ID',
  user_name      varchar(50)    default ''                comment '用户账号',
  ipaddr         varchar(128)   default ''                comment '登录IP地址',
  login_location varchar(255)   default ''                comment '登录地点',
  browser        varchar(50)    default ''                comment '浏览器类型',
  os             varchar(50)    default ''                comment '操作系统',
  status         char(1)        default '0'               comment '登录状态（0成功 1失败）',
  msg            varchar(255)   default ''                comment '提示消息',
  login_time     datetime                                 comment '访问时间',
  primary key (info_id),
  key idx_sys_logininfor_s  (status),
  key idx_sys_logininfor_lt (login_time)
) engine=innodb auto_increment=100 comment = '系统访问记录';


-- ----------------------------
-- 15、定时任务调度表
-- ----------------------------
drop table if exists sys_job;
create table sys_job (
  job_id              bigint(20)    not null auto_increment    comment '任务ID',
  job_name            varchar(64)   default ''                 comment '任务名称',
  job_group           varchar(64)   default 'DEFAULT'          comment '任务组名',
  invoke_target       varchar(500)  not null                   comment '调用目标字符串',
  cron_expression     varchar(255)  default ''                 comment 'cron执行表达式',
  misfire_policy      varchar(20)   default '3'                comment '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  concurrent          char(1)       default '1'                comment '是否并发执行（0允许 1禁止）',
  status              char(1)       default '0'                comment '状态（0正常 1暂停）',
  create_by           varchar(64)   default ''                 comment '创建者',
  create_time         datetime                                 comment '创建时间',
  update_by           varchar(64)   default ''                 comment '更新者',
  update_time         datetime                                 comment '更新时间',
  remark              varchar(500)  default ''                 comment '备注信息',
  primary key (job_id, job_name, job_group)
) engine=innodb auto_increment=100 comment = '定时任务调度表';

insert into sys_job values(1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams',        '0/10 * * * * ?', '3', '1', '1', 'admin', sysdate(), '', null, '');
insert into sys_job values(2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')',  '0/15 * * * * ?', '3', '1', '1', 'admin', sysdate(), '', null, '');
insert into sys_job values(3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)',  '0/20 * * * * ?', '3', '1', '1', 'admin', sysdate(), '', null, '');


-- ----------------------------
-- 16、定时任务调度日志表
-- ----------------------------
drop table if exists sys_job_log;
create table sys_job_log (
  job_log_id          bigint(20)     not null auto_increment    comment '任务日志ID',
  job_name            varchar(64)    not null                   comment '任务名称',
  job_group           varchar(64)    not null                   comment '任务组名',
  invoke_target       varchar(500)   not null                   comment '调用目标字符串',
  job_message         varchar(500)                              comment '日志信息',
  status              char(1)        default '0'                comment '执行状态（0正常 1失败）',
  exception_info      varchar(2000)  default ''                 comment '异常信息',
  start_time          datetime                                  comment '执行开始时间',
  end_time            datetime                                  comment '执行结束时间',
  create_time         datetime                                  comment '创建时间',
  primary key (job_log_id)
) engine=innodb comment = '定时任务调度日志表';


-- ----------------------------
-- 17、通知公告表
-- ----------------------------
drop table if exists sys_notice;
create table sys_notice (
  notice_id         int(4)          not null auto_increment    comment '公告ID',
  notice_title      varchar(50)     not null                   comment '公告标题',
  notice_type       char(1)         not null                   comment '公告类型（1通知 2公告）',
  notice_content    longblob        default null               comment '公告内容',
  status            char(1)         default '0'                comment '公告状态（0正常 1关闭）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(255)    default null               comment '备注',
  primary key (notice_id)
) engine=innodb auto_increment=10 comment = '通知公告表';

-- ----------------------------
-- 初始化-公告信息表数据
-- ----------------------------
insert into sys_notice values('1', '温馨提醒：2018-07-01 若依新版本发布啦', '2', '新版本内容', '0', 'admin', sysdate(), '', null, '管理员');
insert into sys_notice values('2', '维护通知：2018-07-01 若依系统凌晨维护', '1', '维护内容',   '0', 'admin', sysdate(), '', null, '管理员');
insert into sys_notice values('3', '若依开源框架介绍', '1', '<p><span style=\"color: rgb(230, 0, 0);\">项目介绍</span></p><p><font color=\"#333333\">RuoYi开源项目是为企业用户定制的后台脚手架框架，为企业打造的一站式解决方案，降低企业开发成本，提升开发效率。主要包括用户管理、角色管理、部门管理、菜单管理、参数管理、字典管理、</font><span style=\"color: rgb(51, 51, 51);\">岗位管理</span><span style=\"color: rgb(51, 51, 51);\">、定时任务</span><span style=\"color: rgb(51, 51, 51);\">、</span><span style=\"color: rgb(51, 51, 51);\">服务监控、登录日志、操作日志、代码生成等功能。其中，还支持多数据源、数据权限、国际化、Redis缓存、Docker部署、滑动验证码、第三方认证登录、分布式事务、</span><font color=\"#333333\">分布式文件存储</font><span style=\"color: rgb(51, 51, 51);\">、分库分表处理等技术特点。</span></p><p><img src=\"https://foruda.gitee.com/images/1773931848342439032/a4d22313_1815095.png\" style=\"width: 64px;\"><br></p><p><span style=\"color: rgb(230, 0, 0);\">官网及演示</span></p><p><span style=\"color: rgb(51, 51, 51);\">若依官网地址：&nbsp;</span><a href=\"http://ruoyi.vip\" target=\"_blank\">http://ruoyi.vip</a><a href=\"http://ruoyi.vip\" target=\"_blank\"></a></p><p><span style=\"color: rgb(51, 51, 51);\">若依文档地址：&nbsp;</span><a href=\"http://doc.ruoyi.vip\" target=\"_blank\">http://doc.ruoyi.vip</a><br></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【不分离版】：&nbsp;</span><a href=\"http://demo.ruoyi.vip\" target=\"_blank\">http://demo.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【分离版本】：&nbsp;</span><a href=\"http://vue.ruoyi.vip\" target=\"_blank\">http://vue.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【微服务版】：&nbsp;</span><a href=\"http://cloud.ruoyi.vip\" target=\"_blank\">http://cloud.ruoyi.vip</a></p><p><span style=\"color: rgb(51, 51, 51);\">演示地址【移动端版】：&nbsp;</span><a href=\"http://h5.ruoyi.vip\" target=\"_blank\">http://h5.ruoyi.vip</a></p><p><br style=\"color: rgb(48, 49, 51); font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 12px;\"></p>', '0', 'admin', sysdate(), '', null, '管理员');

-- ----------------------------
-- 账户模块扩展
-- ----------------------------
alter table sys_user add column student_no varchar(20) default '' comment '学号' after nick_name;

drop table if exists edu_student_profile;
create table edu_student_profile (
  profile_id        bigint(20)      not null auto_increment comment '档案ID',
  user_id           bigint(20)      not null               comment '用户ID',
  signature         varchar(200)    default ''             comment '个性签名',
  todo_items        longtext                                comment '个人待办事项',
  learning_history  longtext                                comment '学习历史',
  learning_notes    longtext                                comment '学习笔记',
  favorites         longtext                                comment '我的收藏',
  wrong_questions   longtext                                comment '我的错题',
  discussions       longtext                                comment '我的讨论',
  create_by         varchar(64)     default ''             comment '创建者',
  create_time       datetime                                comment '创建时间',
  update_by         varchar(64)     default ''             comment '更新者',
  update_time       datetime                                comment '更新时间',
  remark            varchar(500)    default null           comment '备注',
  primary key (profile_id),
  unique key uk_user_id (user_id)
) engine=innodb auto_increment=1 comment = '学生档案表';

insert into sys_role values('3', '教师', 'teacher', 3, 1, 1, 1, '0', '0', 'admin', sysdate(), '', null, '教师角色');
insert into sys_role values('4', '学生', 'student', 4, 2, 1, 1, '0', '0', 'admin', sysdate(), '', null, '学生角色');

insert into sys_menu values('2000', '账户管理', '0', '5', 'account', null, '', '', 1, 0, 'M', '0', '0', '', 'user', 'admin', sysdate(), '', null, '账户管理目录');
insert into sys_menu values('2001', '学生管理', '2000', '1', 'student', 'account/student/index', '', '', 1, 0, 'C', '0', '0', 'account:student:list', 'peoples', 'admin', sysdate(), '', null, '学生管理菜单');
insert into sys_menu values('2002', '学生管理查询', '2001', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'account:student:list', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2003', '学生管理重置密码', '2001', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'account:student:resetPwd', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2004', '学生管理删除', '2001', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'account:student:remove', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2005', '学生管理状态', '2001', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'account:student:edit', '#', 'admin', sysdate(), '', null, '');

insert into sys_user values(3, 103, 'teacher', '教师', 'TS001', 'teacher@school.edu.cn', '13800000000', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '教师账号');
insert into sys_user_role values ('3', '3');
insert into sys_menu values('2100', '教学管理', '0', '5', 'teaching', null, '', '', 0, 0, 'M', '0', '0', '', 'education', 'admin', sysdate(), '', null, '教师教学管理目录');
insert into sys_menu values('2101', '课程管理', '2100', '1', 'course', 'teaching/course/index', '', '', 0, 0, 'C', '0', '0', 'teaching:course:list', 'form', 'admin', sysdate(), '', null, '课程管理菜单');
insert into sys_menu values('2102', '学生管理', '2100', '2', 'student', 'account/student/index', '', '', 0, 0, 'C', '0', '0', 'account:student:list', 'peoples', 'admin', sysdate(), '', null, '学生管理菜单');
insert into sys_menu values('2103', '试卷管理', '2100', '3', 'paper', 'teaching/paper/index', '', '', 0, 0, 'C', '0', '0', 'teaching:paper:list', 'documentation', 'admin', sysdate(), '', null, '试卷管理菜单');
insert into sys_menu values('2104', '成绩统计', '2100', '4', 'score', 'teaching/score/index', '', '', 0, 0, 'C', '0', '0', 'teaching:score:list', 'chart', 'admin', sysdate(), '', null, '成绩统计菜单');
insert into sys_menu values('2200', '学习中心', '0', '6', 'learning', null, '', '', 0, 0, 'M', '0', '0', '', 'guide', 'admin', sysdate(), '', null, '学生学习中心目录');
insert into sys_menu values('2201', '我的课程', '2200', '1', 'my-course', 'learning/my-course/index', '', '', 0, 0, 'C', '0', '0', 'learning:course:list', 'dashboard', 'admin', sysdate(), '', null, '我的课程菜单');
insert into sys_menu values('2202', '在线学习', '2200', '2', 'online', 'learning/online/index', '', '', 0, 0, 'C', '0', '0', 'learning:online:list', 'build', 'admin', sysdate(), '', null, '在线学习菜单');
insert into sys_menu values('2203', '我的考试', '2200', '3', 'exam', 'learning/exam/index', '', '', 0, 0, 'C', '0', '0', 'learning:exam:list', 'documentation', 'admin', sysdate(), '', null, '我的考试菜单');
insert into sys_menu values('2204', '我的错题', '2200', '4', 'wrong', 'learning/wrong/index', '', '', 0, 0, 'C', '0', '0', 'learning:wrong:list', 'bug', 'admin', sysdate(), '', null, '我的错题菜单');
insert into sys_menu values('2205', '收藏', '2200', '5', 'favorite', 'learning/favorite/index', '', '', 0, 0, 'C', '0', '0', 'learning:favorite:list', 'star', 'admin', sysdate(), '', null, '收藏菜单');
insert into sys_menu values('2206', '笔记', '2200', '6', 'note', 'learning/note/index', '', '', 0, 0, 'C', '0', '0', 'learning:note:list', 'edit', 'admin', sysdate(), '', null, '笔记菜单');
insert into sys_role_menu values ('3', '2100');
insert into sys_role_menu values ('3', '2101');
insert into sys_role_menu values ('3', '2102');
insert into sys_role_menu values ('3', '2103');
insert into sys_role_menu values ('3', '2104');
insert into sys_role_menu values ('4', '2200');
insert into sys_role_menu values ('4', '2201');
insert into sys_role_menu values ('4', '2202');
insert into sys_role_menu values ('4', '2203');
insert into sys_role_menu values ('4', '2204');
insert into sys_role_menu values ('4', '2205');
insert into sys_role_menu values ('4', '2206');

insert into sys_user values(4, 103, 'student01', '学生一号', 'ST001', 'student01@school.edu.cn', '13900000001', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', sysdate(), sysdate(), 'admin', sysdate(), '', null, '示例学生账号');
insert into sys_user_role values ('4', '4');
insert into edu_student_profile(user_id, signature, todo_items, learning_history, learning_notes, favorites, wrong_questions, discussions, create_by, create_time)
values (4, '认真学习，持续进步', '完成 Java Web 课程实验和数据库作业', '已完成 Java Web 第 1~6 章学习', '本周重点复习过滤器和拦截器', '收藏：Spring Security 登录流程图', '错题：数据库范式综合题', '讨论：期末项目模块分工', 'admin', sysdate());


-- ----------------------------
-- 18、公告已读记录表
-- ----------------------------
drop table if exists sys_notice_read;
create table sys_notice_read (
  read_id          bigint(20)       not null auto_increment    comment '已读主键',
  notice_id        int(4)           not null                   comment '公告id',
  user_id          bigint(20)       not null                   comment '用户id',
  read_time        datetime         not null                   comment '阅读时间',
  primary key (read_id),
  unique key uk_user_notice (user_id, notice_id)   comment '同一用户同一公告只记录一次'
) engine=innodb auto_increment=1 comment='公告已读记录表';


-- ----------------------------
-- 19、代码生成业务表
-- ----------------------------
drop table if exists gen_table;
create table gen_table (
  table_id          bigint(20)      not null auto_increment    comment '编号',
  table_name        varchar(200)    default ''                 comment '表名称',
  table_comment     varchar(500)    default ''                 comment '表描述',
  sub_table_name    varchar(64)     default null               comment '关联子表的表名',
  sub_table_fk_name varchar(64)     default null               comment '子表关联的外键名',
  class_name        varchar(100)    default ''                 comment '实体类名称',
  tpl_category      varchar(200)    default 'crud'             comment '使用的模板（crud单表操作 tree树表操作）',
  tpl_web_type      varchar(30)     default ''                 comment '前端模板类型（element-ui模版 element-plus模版）',
  package_name      varchar(100)                               comment '生成包路径',
  module_name       varchar(30)                                comment '生成模块名',
  business_name     varchar(30)                                comment '生成业务名',
  function_name     varchar(50)                                comment '生成功能名',
  function_author   varchar(50)                                comment '生成功能作者',
  form_col_num      int(1)          default 1                  comment '表单布局（单列 双列 三列）',
  gen_type          char(1)         default '0'                comment '生成代码方式（0zip压缩包 1自定义路径）',
  gen_path          varchar(200)    default '/'                comment '生成路径（不填默认项目路径）',
  options           varchar(1000)                              comment '其它生成选项',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (table_id)
) engine=innodb auto_increment=1 comment = '代码生成业务表';


-- ----------------------------
-- 20、代码生成业务表字段
-- ----------------------------
drop table if exists gen_table_column;
create table gen_table_column (
  column_id         bigint(20)      not null auto_increment    comment '编号',
  table_id          bigint(20)                                 comment '归属表编号',
  column_name       varchar(200)                               comment '列名称',
  column_comment    varchar(500)                               comment '列描述',
  column_type       varchar(100)                               comment '列类型',
  java_type         varchar(500)                               comment 'JAVA类型',
  java_field        varchar(200)                               comment 'JAVA字段名',
  is_pk             char(1)                                    comment '是否主键（1是）',
  is_increment      char(1)                                    comment '是否自增（1是）',
  is_required       char(1)                                    comment '是否必填（1是）',
  is_insert         char(1)                                    comment '是否为插入字段（1是）',
  is_edit           char(1)                                    comment '是否编辑字段（1是）',
  is_list           char(1)                                    comment '是否列表字段（1是）',
  is_query          char(1)                                    comment '是否查询字段（1是）',
  query_type        varchar(200)    default 'EQ'               comment '查询方式（等于、不等于、大于、小于、范围）',
  html_type         varchar(200)                               comment '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  dict_type         varchar(200)    default ''                 comment '字典类型',
  sort              int                                        comment '排序',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (column_id)
) engine=innodb auto_increment=1 comment = '代码生成业务表字段';
