-- Move seeded course images from frontend static assets to the unified upload resource path.
update edu_course
set cover_image = case course_id
  when 5001 then '/profile/course/cover/java-web.png'
  when 5002 then '/profile/course/cover/vue2-portal.png'
  when 5003 then '/profile/course/cover/spring-boot.png'
  when 5004 then '/profile/course/cover/python-data.png'
  when 5005 then '/profile/course/cover/sql-modeling.png'
  when 5006 then '/profile/course/cover/ui-design.png'
  else cover_image
end
where course_id in (5001, 5002, 5003, 5004, 5005, 5006);

update edu_course_banner
set banner_image = case banner_id
  when 9001 then '/profile/course/banner/banner-java-web.png'
  when 9002 then '/profile/course/banner/banner-vue2-portal.png'
  when 9003 then '/profile/course/banner/banner-spring-boot.png'
  else banner_image
end
where banner_id in (9001, 9002, 9003);
