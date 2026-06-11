-- V19: 清空指向不存在文件的课程封面路径，改用前端占位图兜底
-- 种子数据路径形如 /profile/course/cover/文件名.png（无日期子目录）
-- 真实上传路径形如 /profile/course/cover/2026/06/11/xxx.png（含日期子目录）
-- 仅清空前者，不影响用户上传的封面

UPDATE edu_course
SET cover_image = ''
WHERE (cover_image LIKE '/profile/course/cover/%'
       AND cover_image NOT LIKE '/profile/course/cover/%/%')
   OR cover_image LIKE '/static/course-covers/%';
