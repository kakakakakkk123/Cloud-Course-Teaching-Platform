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
