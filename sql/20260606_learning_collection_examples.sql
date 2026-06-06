-- 学生端“我的错题 / 收藏 / 笔记”演示数据
-- 说明：为示例学生 student01（user_id = 4）写入课程内收集的列表数据。

insert into edu_student_profile (
  user_id, signature, todo_items, learning_history, learning_notes, favorites,
  wrong_questions, discussions, create_by, create_time
)
select 4, '认真学习，持续进步', '完成 Java Web 课程实验和数据库作业', '已完成 Java Web 第 1~6 章学习',
       '[]', '[]', '[]', '讨论：期末项目模块分工', 'admin', sysdate()
where not exists (select 1 from edu_student_profile where user_id = 4);

update edu_student_profile
set
  learning_notes = '[
    {
      "id": "note-5001-01",
      "courseId": 5001,
      "courseName": "Java Web 开发实战",
      "chapterTitle": "第 3 章 认证与会话",
      "contentId": 7001,
      "contentTitle": "登录态与拦截器",
      "title": "拦截器处理登录态的执行顺序",
      "summary": "先排除登录、注册和静态资源，再从 Session 或 Token 中读取用户身份。",
      "note": "拦截器适合做统一登录校验，Controller 只处理业务。遇到未登录请求时返回统一错误码，前端根据错误码跳转登录页。",
      "collectedAt": "2026-06-06 09:20",
      "tags": ["登录态", "拦截器"]
    },
    {
      "id": "note-5002-01",
      "courseId": 5002,
      "courseName": "Vue 前端项目实践",
      "chapterTitle": "第 2 章 组件通信",
      "contentId": 7102,
      "contentTitle": "表单组件封装",
      "title": "v-model 封装要点",
      "summary": "子组件通过 value 接收值，通过 input 事件回传新值。",
      "note": "封装上传、选择器、富文本这类组件时，要保持 value/input 约定，避免父页面额外写同步逻辑。",
      "collectedAt": "2026-06-06 10:35",
      "tags": ["Vue", "组件封装"]
    }
  ]',
  favorites = '[
    {
      "id": "fav-5001-01",
      "courseId": 5001,
      "courseName": "Java Web 开发实战",
      "chapterTitle": "第 4 章 权限控制",
      "contentId": 7006,
      "contentTitle": "Spring Security 登录流程图",
      "title": "Spring Security 登录流程图",
      "summary": "用于复习认证过滤器、UserDetailsService 和权限上下文的关系。",
      "detail": "这份资料把登录请求进入过滤器链、认证管理器校验、保存 SecurityContext 的过程串起来，适合考前快速回看。",
      "resourceUrl": "https://example.com/resource/security-flow",
      "collectedAt": "2026-06-06 11:05",
      "tags": ["权限", "流程图"]
    },
    {
      "id": "fav-5004-01",
      "courseId": 5004,
      "courseName": "UI 设计与交互规范",
      "chapterTitle": "第 1 章 信息层级",
      "contentId": 7301,
      "contentTitle": "后台表格页面规范",
      "title": "后台列表页信息层级清单",
      "summary": "收藏用于检查表格筛选区、操作区、状态标签和分页布局。",
      "detail": "重点关注高频操作入口、批量操作禁用态、表格列宽和移动端换行。",
      "resourceUrl": "https://example.com/resource/admin-list-guideline",
      "collectedAt": "2026-06-06 14:10",
      "tags": ["UI", "后台页面"]
    }
  ]',
  wrong_questions = '[
    {
      "id": "wrong-5001-01",
      "courseId": 5001,
      "courseName": "Java Web 开发实战",
      "examId": 9001,
      "examName": "Java Web 阶段测验",
      "questionId": 8101,
      "title": "过滤器与拦截器的执行时机",
      "questionStem": "下列关于 Filter 与 HandlerInterceptor 执行顺序的说法，哪一项正确？",
      "myAnswer": "Controller 方法执行后才进入 Filter",
      "correctAnswer": "Filter 先于 DispatcherServlet，HandlerInterceptor 在 HandlerMapping 之后执行",
      "analysis": "Filter 属于 Servlet 容器层，Interceptor 属于 Spring MVC 层。请求先经过 Filter，再进入 DispatcherServlet 和拦截器链。",
      "summary": "混淆了 Servlet 容器层和 Spring MVC 层的边界。",
      "collectedAt": "2026-06-06 15:25",
      "tags": ["Filter", "Interceptor"]
    },
    {
      "id": "wrong-5002-01",
      "courseId": 5002,
      "courseName": "Vue 前端项目实践",
      "examId": 9002,
      "examName": "Vue 组件基础测验",
      "questionId": 8203,
      "title": "父子组件双向绑定",
      "questionStem": "自定义组件要支持 v-model，默认需要接收哪个 prop 并触发哪个事件？",
      "myAnswer": "接收 modelValue，触发 update:modelValue",
      "correctAnswer": "Vue 2 默认接收 value，触发 input",
      "analysis": "当前项目使用 Vue 2，默认 v-model 协议是 value/input；modelValue/update:modelValue 是 Vue 3 的默认协议。",
      "summary": "把 Vue 2 与 Vue 3 的 v-model 协议混用了。",
      "collectedAt": "2026-06-06 16:00",
      "tags": ["Vue 2", "v-model"]
    }
  ]',
  update_by = 'admin',
  update_time = sysdate()
where user_id = 4;
