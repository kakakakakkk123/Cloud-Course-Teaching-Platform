<template>
  <profile-memo
    field="todoItems"
    title="学习待办"
    type-label="待办"
    tag-type="primary"
    empty-text="暂无学习待办"
    description="集中维护课程任务、实验作业、复习计划和阶段目标。"
    placeholder="可以直接记录待办文本，也可以保存 JSON 列表。示例：[{'title':'完成数据库作业','content':'提交实验三','time':'2026-06-07'}]"
    :allow-quick-add="true"
    quick-add-button-text="添加学习任务"
    :show-raw-editor="false"
  />
</template>

<script>
import ProfileMemo from "../components/ProfileMemo"

export default {
  name: "LearningTodo",
  components: { ProfileMemo }
}
</script>
