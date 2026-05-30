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
