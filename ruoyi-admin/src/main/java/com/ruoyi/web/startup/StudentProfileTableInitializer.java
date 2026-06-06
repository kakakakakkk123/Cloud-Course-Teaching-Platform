package com.ruoyi.web.startup;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.sql.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

/**
 * Ensures the student profile table exists and is upgraded for older databases.
 */
@Component
public class StudentProfileTableInitializer implements ApplicationRunner
{
    private static final Logger log = LoggerFactory.getLogger(StudentProfileTableInitializer.class);

    private final DataSource dataSource;

    public StudentProfileTableInitializer(DataSource dataSource)
    {
        this.dataSource = dataSource;
    }

    @Override
    public void run(ApplicationArguments args) throws Exception
    {
        String createTableSql = """
                create table if not exists edu_student_profile (
                  profile_id bigint(20) not null auto_increment comment '档案ID',
                  user_id bigint(20) not null comment '用户ID',
                  grade varchar(20) default null comment '年级',
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
                ) engine=innodb auto_increment=1 comment = '学生档案表'
                """;

        try (Connection connection = dataSource.getConnection(); Statement statement = connection.createStatement())
        {
            statement.execute(createTableSql);
            if (!hasGradeColumn(connection))
            {
                statement.execute("alter table edu_student_profile add column grade varchar(20) default null comment '年级' after user_id");
            }
            log.info("student profile table checked");
        }
    }

    private boolean hasGradeColumn(Connection connection) throws Exception
    {
        try (ResultSet rs = connection.getMetaData().getColumns(connection.getCatalog(), null, "edu_student_profile", "grade"))
        {
            return rs.next();
        }
    }
}
