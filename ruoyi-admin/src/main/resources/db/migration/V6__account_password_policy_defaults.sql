-- Complete account password policy defaults.
insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '密码最小长度', 'sys.account.passwordMinLength', '5', 'N', 'admin', sysdate(), '账号密码最小长度'
where not exists (select 1 from sys_config where config_key = 'sys.account.passwordMinLength');

insert into sys_config(config_name, config_key, config_value, config_type, create_by, create_time, remark)
select '密码最大长度', 'sys.account.passwordMaxLength', '20', 'N', 'admin', sysdate(), '账号密码最大长度'
where not exists (select 1 from sys_config where config_key = 'sys.account.passwordMaxLength');

update sys_config
set config_value = '5', update_by = 'admin', update_time = sysdate()
where config_key = 'sys.account.passwordMinLength'
  and (config_value is null or config_value = '');

update sys_config
set config_value = '20', update_by = 'admin', update_time = sysdate()
where config_key = 'sys.account.passwordMaxLength'
  and (config_value is null or config_value = '');
