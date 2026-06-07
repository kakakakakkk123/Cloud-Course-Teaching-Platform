-- Use local static course cover images instead of remote placeholder URLs.
update edu_course
set cover_image = case course_id
  when 5001 then '/static/course-covers/java-web.png'
  when 5002 then '/static/course-covers/vue2-portal.png'
  when 5003 then '/static/course-covers/spring-boot.png'
  when 5004 then '/static/course-covers/python-data.png'
  when 5005 then '/static/course-covers/sql-modeling.png'
  when 5006 then '/static/course-covers/ui-design.png'
  else cover_image
end
where course_id in (5001, 5002, 5003, 5004, 5005, 5006);

update edu_course_banner
set banner_image = case banner_id
  when 9001 then '/static/course-covers/banner-java-web.png'
  when 9002 then '/static/course-covers/banner-vue2-portal.png'
  when 9003 then '/static/course-covers/banner-spring-boot.png'
  else banner_image
end
where banner_id in (9001, 9002, 9003);
