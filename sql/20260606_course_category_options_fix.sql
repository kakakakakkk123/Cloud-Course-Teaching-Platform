-- 教师端新增课程分类下拉修复脚本
-- 作用：
-- 1. 非破坏式补齐课程分类数据
-- 2. 给教师角色补齐课程分类下拉所需的 edu:category:list 权限
-- 执行后请退出教师账号并重新登录。

insert into edu_course_category
(category_id, parent_id, ancestors, category_name, order_num, icon, status, del_flag, create_by, create_time, update_by, update_time, remark)
values
(3001, 0, '0', '编程开发', 1, 'monitor', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁一级分类'),
(3002, 0, '0', '数据与分析', 2, 'chart', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁一级分类'),
(3003, 0, '0', '设计创作', 3, 'edit', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁一级分类'),
(3004, 0, '0', '人工智能', 4, 'skill', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁一级分类'),
(3005, 0, '0', '云计算与运维', 5, 'server', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁一级分类'),
(3006, 0, '0', '产品与运营', 6, 'guide', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁一级分类'),
(3007, 0, '0', '学科基础', 7, 'education', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁一级分类'),
(3101, 3001, '0,3001', 'Java 开发', 1, 'tree', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3102, 3001, '0,3001', '前端开发', 2, 'build', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3103, 3001, '0,3001', 'Python 开发', 3, 'code', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3104, 3001, '0,3001', '移动开发', 4, 'phone', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3105, 3001, '0,3001', '后端架构', 5, 'nested', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3201, 3002, '0,3002', '数据分析', 1, 'money', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3202, 3002, '0,3002', '数据库技术', 2, 'table', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3203, 3002, '0,3002', '大数据开发', 3, 'redis', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3204, 3002, '0,3002', '商业智能', 4, 'excel', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3301, 3003, '0,3003', '视觉设计', 1, 'peoples', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3302, 3003, '0,3003', 'UI/UX 设计', 2, 'component', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3303, 3003, '0,3003', '数字媒体', 3, 'color', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3401, 3004, '0,3004', '机器学习', 1, 'skill', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3402, 3004, '0,3004', '深度学习', 2, 'rate', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3403, 3004, '0,3004', 'AIGC 应用', 3, 'international', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3501, 3005, '0,3005', 'Linux 运维', 1, 'server', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3502, 3005, '0,3005', '云原生与容器', 2, 'redis-list', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3503, 3005, '0,3005', '网络安全', 3, 'lock', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3601, 3006, '0,3006', '产品经理', 1, 'guide', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3602, 3006, '0,3006', '新媒体运营', 2, 'message', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3603, 3006, '0,3006', '项目管理', 3, 'documentation', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3701, 3007, '0,3007', '高等数学', 1, 'number', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3702, 3007, '0,3007', '计算机基础', 2, 'education', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类'),
(3703, 3007, '0,3007', '英语通识', 3, 'language', '0', '0', 'admin', sysdate(), 'admin', sysdate(), '课程分类补丁二级分类')
on duplicate key update
  category_name = values(category_name),
  parent_id = values(parent_id),
  ancestors = values(ancestors),
  order_num = values(order_num),
  icon = values(icon),
  status = '0',
  del_flag = '0',
  update_by = 'admin',
  update_time = sysdate();

insert into sys_menu
(menu_id, menu_name, parent_id, order_num, path, component, `query`, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
select 21026, '课程分类列表', 2101, 11, '', '', '', '', 0, 0, 'F', '0', '0', 'edu:category:list', '#', 'admin', sysdate(), '', null, '课程分类下拉查询权限'
where not exists (select 1 from sys_menu where menu_id = 21026);

insert into sys_role_menu (role_id, menu_id)
select 3, 21026
where not exists (select 1 from sys_role_menu where role_id = 3 and menu_id = 21026);

select category_id, category_name, parent_id, order_num
from edu_course_category
where category_id between 3001 and 3703
order by parent_id, order_num, category_id;
