-- V14: 统一 is_frame 语义，所有内嵌 SPA 菜单均使用 is_frame='1'（NO_FRAME），
-- 此前学生端学习中心菜单误设为 '0'，虽不影响当前功能但存在被误判为外部链接/iframe 的风险。

update sys_menu set is_frame = '1', update_time = sysdate()
where menu_id between 2200 and 2206
  and is_frame <> '1';

-- 确保教学管理菜单 is_frame 也为 '1'（兜底）
update sys_menu set is_frame = '1', update_time = sysdate()
where menu_id between 2100 and 2104
  and is_frame <> '1';
